defmodule Definition.BPMProcess do


  defstruct tasks: %{}, events: %{}, gateways: %{}


alias Definition.BPMLink


  @moduledoc """
  This module holds the functions for executing a BPM process.
  """

    @doc """
      Creates a sequence flow between a source and a target.
      The source and the target need are tuples where the first argument
      is one of the atoms: :task, :event, :gateway. The second argument
      is the id of the task gateway or event you want to link.

      ## Examples

          iex> Definition.BPMProcess.add_sequence_flow(process,{:event, 1}, {:task, 1} )
          :ok


    """
    def add_sequence_flow(%__MODULE__{} = process, source, target, link_id) do

        {:ok, source_part} = __MODULE__.get_process_part(process, source)
        {:ok, target_part} = __MODULE__.get_process_part(process, target)

        {sourceItem, targetItem} =
          BPMLink.link(source_part, target_part, link_id)

        process
        |> __MODULE__.update(sourceItem)
        |> __MODULE__.update(targetItem)


    end

    def get_process_part(process, {:event, id}) do
       __MODULE__.get_event_by_id(process, id)
    end

    def get_process_part(process, {:task, id}) do
       __MODULE__.get_task_by_id(process, id)
    end

    def get_process_part(process, {:gateway, id}) do
       __MODULE__.get_gateway_by_id(process, id)
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
      delete_task(process, task.id)
      add(process, task)
    end

    @doc """
    Deletes a gateway from the list and adds the argumentin its place.
    """
    def update(process, %Definition.BPMGateway{} = gateway) do
      delete_gateway(process, gateway.id)
      add(process, gateway)
    end

    @doc """
    Deletes a event from the list and adds the argumentin its place.
    """
    def update(process, %Definition.BPMEvent{} = event) do
      delete_event(process, event.id)
      add(process, event)
    end

    @doc """
    Gets a task from the `process` by `id`.
    """
    def get_task_by_id(process, id) do
        process.tasks
        |> Map.fetch(id)
    end

    def delete_task(process, taskId) do
     %{process | tasks: Map.delete(process.tasks, taskId)}
    end

    def delete_event(process, eventId) do
      %{process | events: Map.delete(process.events, eventId)}
    end

    @doc """
    Gets a event from the `process` by `id`.
    """
    def get_event_by_id(process, id) do
      process.events
      |> Map.fetch(id)
    end

    def delete_gateway(process, gatewayId) do
      %{process | gateways: Map.delete(process.gateways, gatewayId)}
    end

    @doc """
    Gets a gateway from the `process` by `id`.
    """
    def get_gateway_by_id(process, id) do
      process.gateways
      |> Map.fetch(id)
    end

end
