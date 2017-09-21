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
    Updates the process to go to the next step.
  """
  def next_step(%__MODULE__{} = process, status) do

    Enum.map(status, &get(process, &1))    #get att the current steps
    |> Keyword.get_values(:ok)
    |> Enum.flat_map(fn step -> step.outgoing  end)       #collect all the outgoinng sequenceflows from all the steps
    |> Enum.map(fn outgoing -> outgoing.target  end)      #get the targets.
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
    IO.inspect(unknown)
    {:error, :unknown}
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



end
