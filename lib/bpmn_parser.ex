defmodule BPMNParser do
  @moduledoc """
  This module takes in bpmn files and parses it into a ProcessDefinition.

  TODO There could be more process per file, to solve this"
  let all the step methods accept the process id and let the
  xpath match on the process id.
  """
  import SweetXml
  require Logger
  alias Definition.BPMEvent
  alias Definition.BPMTask
  alias Definition.BPMGateway

  @event_types [:startEvent, :endEvent, :intermediateCatchEvent]
  @gateway_types [:exclusiveGateway]
  @task_types [:task]

  @doc """
  Read an xml file from disk.
  """
  def read_file file do
    case File.read(file) do
      {:ok, body} -> {:ok, body}
      {:error, reason} -> Logger.error "Could not open file #{file}, #{reason}"
    end
  end

  @doc """
  Return a list of structs Definition.BPMEvent of type :startEvent.
  """
  def start_events doc do
    event_type(doc, :startEvent)
  end

  @doc """
  Return a list of structs Definition.BPMEvent of type :endEvent.
  """
  def end_events doc do
    event_type(doc, :endEvent)
  end

  @doc """
  Converts the bpmn xml document into a list of all the defined gateways in
  the document in the form of a list of  structs Definition.BPMEvent.
  """

  def events doc do
    Enum.reduce(
      @event_types,
      [],
      fn type, acc -> acc ++ event_type(doc, type)
      end
    )
  end

  defp event_type doc, type do
    doc
    |> xpath(~x"//bpmn:#{type}"l)
    |> Enum.map(
         fn (event) ->
           %BPMEvent{
             id: id(event),
             type: type,
             name: attribute(event, "name")
           }
         end
       )
  end

  @doc """
  Converts the bpmn xml document into a list of all the defined gateways in
  the document in the form of a list of  structs Definition.BPMGateway.
  """
  def gateways doc do
    Enum.reduce(
      @gateway_types,
      [],
      fn type, acc -> acc ++ gateway_type(doc, type)
      end
    )
  end

  defp gateway_type doc, type do
    doc
    |> xpath(~x"//bpmn:#{type}"l)
    |> Enum.map(
         fn (event) ->
           %BPMGateway{
             id: id(event),
             type: type,
             name: attribute(event, "name")
           }
         end
       )
  end

  @doc """
  Converts the bpmn xml document into a list of all the defined gateways in
  the document in the form of a list of  structs Definition.BPMTask.
  """
  def tasks doc do
    Enum.reduce(
      @task_types,
      [],
      fn type, acc -> acc ++ task_type(doc, type)
      end
    )
  end

  defp task_type doc, type do
    doc
    |> xpath(~x"//bpmn:#{type}"l)
    |> Enum.map(
         fn (task) ->
           %BPMTask{
             id: id(task),
             type: type,
             name: attribute(task, "name")
           }
         end
       )
  end

  @doc """
  Return a list of tuples with three items: sequenceflow id, source id, target id.
  """
  def sequence_flows doc do
    doc
    |> xpath(~x"//bpmn:sequenceFlow"l)
    |> Enum.map(
         fn (flow) ->
           {
             id(flow),
             atom_attribute(flow, "sourceRef"),
             atom_attribute(flow, "targetRef")
           }
         end
       )
  end


  @doc """
  Consumes a bpmn xml document.

  Returns a list of %ProcessDefinition{}. The id is filled with the id attribute of the
  process element.
  """
  def process_definition doc do

    [process_definition] =
      xpath(doc, ~x"//bpmn:process"l)
      |> Enum.map(

           fn (process) ->
             %ProcessDefinition{
               id: id(process)
             }
           end
         )
    #add the tasks, gateways and events to the process definition
    steps = tasks(doc) ++ events(doc) ++ gateways(doc)

    def_with_steps = Enum.reduce(
      steps,
      process_definition,
      fn step, def -> ProcessDefinition.add(def, step)
      end
    )

    #add the sequence flows to the process definition
    sequence_flows(doc)
    |> Enum.reduce(
         def_with_steps,
         fn flow, definition ->
           {id, source_id, target_id} = flow

           ProcessDefinition.add_sequence_flow(
             definition,
             {get_step_type(steps, source_id), source_id},
             {get_step_type(steps, target_id), target_id},
             id
           )

         end
       )
  end

  defp get_step_type(steps, id) do
    case Enum.filter(steps, fn step -> step.id == id end) do
      [step] -> step
      [] -> IO.warn("The type for #{inspect id} is not defined in the parser", Macro.Env.stacktrace(__ENV__))
    end
    |> case do
         %BPMEvent{} -> :event
         %BPMGateway{} -> :gateway
         %BPMTask{} -> :task
       end
  end


  defp attribute doc, attribute_name do
    case xpath(doc, ~x"./@#{attribute_name}") do
      nil -> nil
      value -> to_string(value)
    end
  end

  defp atom_attribute doc, attribute_name do
    case xpath(doc, ~x"./@#{attribute_name}") do
      nil -> nil
      value -> to_string(value)
               |> String.to_atom
    end
  end

  defp id doc do
    doc
    |> xpath(~x"./@id")
    |> to_string
    |> String.to_atom
  end


end