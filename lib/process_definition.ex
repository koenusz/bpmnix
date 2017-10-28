defmodule ProcessDefinition do

  @enforce_keys :id
  defstruct id: nil, tasks: %{}, events: %{}, gateways: %{}


  alias Definition.BPMLink


  @moduledoc """
  This module describes the data structure of a bpm process. A process is a struct with a map of tasks,
  events and gateways where the maps key is the id of the accompanieing struct.

  The default status is [{:event :start}].

  It provides the functions for stepping a process.
  """


  @doc """
    Returns a list of the next steps in the process definition.
  """
  def next_step(%__MODULE__{} = process_definition, step_type_id) do
    get(process_definition, step_type_id)
    |> fn {:ok, step} -> step end.()
    |> fn step -> step.outgoing  end.()       #collect all the outgoinng sequenceflows from all the steps
    |> Enum.map(fn outgoing -> outgoing.target  end) #get the targets.
  end

  @doc """
    Returns a list of the next steps in the process definition. Only outgoing steps that are in the filter are considered.
  """
  def next_step(%__MODULE__{} = process_definition, gateway_id, outgoing_filter) do
    get(process_definition, gateway_id)
    |> fn {:ok, step} -> step end.()
    |> fn step -> step.outgoing  end.()       #collect all the outgoinng sequenceflows from all the steps
    |> Enum.filter(fn outgoing -> Enum.member?(outgoing_filter, outgoing.id) end)  #only add outgoing flows to the list that are in the filter
    |> Enum.map(fn outgoing -> outgoing.target  end) #get the targets.
  end

  @doc """
  Checks if there is an event in the process definition, and if that event is of type :endEvent returns true else false.
  """

  def end_event?(%__MODULE__{} = process_definition, event_type_id) do
    case get(process_definition, event_type_id) do
      {:ok, event} -> event.type == :endEvent
      _ -> false
    end
  end


  @doc """
    Creates a sequence flow between a source and a target.
    The source and the target need are tuples where the first argument
    is one of the atoms: :task, :event, :gateway. The second argument
    is the id of the task gateway or event you want to link.

    ## Examples

        iex> Definition.BPMProcess.add_sequence_flow(process,{:event, :event1}, {:task, :task1} )
        :ok
  """
  def add_sequence_flow(%__MODULE__{} = definition, source, target, link_id) do

    {:ok, source_part} = __MODULE__.get(definition, source)
    {:ok, target_part} = __MODULE__.get(definition, target)

    {sourceItem, targetItem} =
      BPMLink.link(source_part, target_part, link_id)

    definition
    |> __MODULE__.update(sourceItem)
    |> __MODULE__.update(targetItem)
  end


  @doc """
      Provides all the ids of the steps that this definition contains.
  """
  def list_step_ids(definition) do
    Map.keys(definition.tasks) ++ Map.keys(definition.events) ++ Map.keys(definition.gateways)
  end

  @doc """
  Add an event to the process.
  """
  def add(process, %Definition.BPMEvent{} = event) do
    %{process | events: Map.put(process.events, event.id, event)}
  end

  @doc """
  Add an gateway to the process.
  """
  def add(process, %Definition.BPMGateway{} = gateway) do
    %{process | gateways: Map.put(process.gateways, gateway.id, gateway)}
  end

  @doc """
  Add an task to the process.
  """
  def add(process, %Definition.BPMTask{} = task) do
    %{process | tasks: Map.put(process.tasks, task.id, task)}
  end


  @doc """
  Deletes a task from the list and adds the argumentin its place.
  """
  def update(process, %Definition.BPMTask{} = task) do
    delete(process, {:task, task.id})
    add(process, task)
  end

  @doc """
  Deletes a gateway from the list and adds the argumentin its place.
  """
  def update(process, %Definition.BPMGateway{} = gateway) do
    delete(process, {:gateway, gateway.id})
    add(process, gateway)
  end

  @doc """
  Deletes a event from the list and adds the argumentin its place.
  """
  def update(process, %Definition.BPMEvent{} = event) do
    delete(process, {:event, event.id})
    add(process, event)
  end

  @doc """
  Gets a event from the `process` by `id`.
  """
  def get(process, {:event, eventId}) do
    process.events
    |> Map.fetch(eventId)
  end

  @doc """
  Gets a task from the `process` by `id`.
  """
  def get(process, {:task, taskId}) do
    process.tasks
    |> Map.fetch(taskId)
  end

  @doc """
  Gets a gateway from the `process` by `id`.
  """
  def get(process, {:gateway, gatewayId}) do
    process.gateways
    |> Map.fetch(gatewayId)
  end

  @doc """
  Gets a gateway from the `process` by `id`.
  """
  def get(_process, unknown) do
    {:error, unknown}
  end

  @doc """
    delete a task
  """
  def delete(process, {:task, taskId}) do
    %{process | tasks: Map.delete(process.tasks, taskId)}
  end
  @doc """
    delete a event
  """
  def delete(process, {:event, eventId}) do
    %{process | events: Map.delete(process.events, eventId)}
  end
  @doc """
    delete a gateway
  """
  def delete(process, {:gateway, gatewayId}) do
    %{process | gateways: Map.delete(process.gateways, gatewayId)}
  end

  @doc """
  Returns a list of all the step id's.
  """
  def steps(process) do
    Map.keys(process.tasks) ++ Map.keys(process.events) ++ Map.keys(process.gateways)
  end


end
