defmodule Definition.BPMProcess do


  defstruct tasks: %{}, events: %{}, gateways: %{}

  @moduledoc """
  This module holds the functions for executing a BPM process.
  """


    @doc """
    Starts a new process.
    """
    def start_link do
      Agent.start_link(fn -> %Definition.BPMProcess{} end)
    end

    @doc """
    Add an task to the process.
    """
    def addTask(process, %Definition.BPMTask{} = task) do
        Agent.update(process, fn state -> %{state | tasks: Map.put(state.tasks, task.id, task)} end)
    end

    def deleteTask(process, taskId) do
      Agent.update(process, fn state -> %{state | tasks: Map.delete(state.tasks, taskId)} end)
    end

    @doc """
    Deletes a task from the list and adds the argumentin its place.
    """
    def updateTask(process, %Definition.BPMTask{} = task) do
      deleteTask(process, task.id)
      addTask(process, task)
    end

    @doc """
    Gets a task from the `process` by `key`.
    """
    def getTasks(process) do
      Agent.get(process, &Map.get(&1, :tasks))
    end

    @doc """
    Gets a task from the `process` by `id`.
    """
    def getTaskById(process, id) do
        tasks = getTasks(process)
        tasks
        |> Map.get(id)
    end

    @doc """
    Add an event to the process.
    """
    def addEvent(process, %Definition.BPMEvent{} = event) do
      Agent.update(process, fn state -> %{state | events: Map.put(state.events, event.id, event)}  end)
    end

    def deleteEvent(process, eventId) do
      Agent.update(process, fn state -> %{state | events: Map.delete(state.events, eventId)} end)
    end

    @doc """
    Deletes a event from the list and adds the argumentin its place.
    """
    def updateEvent(process, %Definition.BPMEvent{} = event) do
      deleteEvent(process, event.id)
      addEvent(process, event)
    end

    @doc """
    Gets a event from the `process` by `key`.
    """
    def getEvents(process) do
      Agent.get(process, &Map.get(&1, :events))
    end

    @doc """
    Gets a event from the `process` by `id`.
    """
    def getEventById(process, id) do
      events = getEvents(process)

      events
      |> Map.get(id)
    end

    @doc """
    Add an gateway to the process.
    """
    def addGateway(process, %Definition.BPMGateway{} = gateway) do
          Agent.update(process, fn state -> %{state | gateways: Map.put(state.gateways, gateway.id, gateway)}  end)
    end

    def deleteGateway(process, gatewayId) do
      Agent.update(process, fn state -> %{state | gateways: Map.delete(state.gateways, gatewayId)} end)
    end

    @doc """
    Deletes a gateway from the list and adds the argumentin its place.
    """
    def updateGateway(process, %Definition.BPMGateway{} = gateway) do
      deleteGateway(process, gateway.id)
      addGateway(process, gateway)
    end

    @doc """
    Gets a gateway from the `process` by `key`.
    """
    def getGateways(process) do
      Agent.get(process, &Map.get(&1, :gateways))
    end

    @doc """
    Gets a gateway from the `process` by `id`.
    """
    def getGatewayById(process, id) do
      gateways = getGateways(process)

      gateways
      |> Map.get(id)
    end

end
