defmodule ProcessInstanceAgent do
  use Agent
  require Logger

  @moduledoc """
    This module is a wrapping agent around the process instance functional datastructure.
  """

  def start_link(id, process) do
    name = via_tuple(id)
    Agent.start_link(fn -> ProcessInstance.new_instance(id, process) end, name: name)
  end


  def get(id) do
    Agent.get(via_tuple(id), fn instance -> instance  end)
  end

  def getImplementation(id) do
    Agent.get(via_tuple(id), fn instance -> instance.process_implementation  end)
  end

  def getStatus(id) do
    Agent.get(via_tuple(id), fn instance -> instance.status  end)
  end

  def getHistory(id) do
    Agent.get(via_tuple(id), fn instance -> instance.history  end)
  end

  def getVersion(id) do
    Agent.get(via_tuple(id), fn instance -> instance.version  end)
  end

  def next_step(id, step) do
    Agent.get(
      via_tuple(id),
      fn instance ->
        ProcessDefinition.next_step instance.process_implementation.definition, step
      end
    )
  end


  @doc """
    Checks if there is an event in the process definition of the process instance contained in this agent
    , and if that event is of type :endEvent returns true else false.
  """
  def end_event?(id, event_type_id) do
    getImplementation(id).definition
    |> ProcessDefinition.end_event?(event_type_id)

  end

  def execute_step(id, {type, step_id}) do

    step_implementation_function = Atom.to_string(type) <> "_" <> Atom.to_string(step_id)
                                   |> String.to_atom

    Task.async(getImplementation(id), step_implementation_function, [])
    |> Task.await
    |> case do
         :ok -> :ok
         {:error, message} -> register_error(id, step_id, message)
       end
  end

  def complete_step(id, step_type_id) do
    Agent.update(via_tuple(id), &ProcessInstance.complete_step(&1, step_type_id))
  end

  def register_error(id, step_id, message) do
    Agent.update(via_tuple(id), &ProcessInstance.register_error(&1, step_id, message))
  end

  def complete(id) do
    Agent.update(via_tuple(id), &ProcessInstance.complete(&1))
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      type: :worker
    }
  end

  defp via_tuple (process_id) do
    {:via, Registry, {:process_instance_registry, process_id}}
  end
end