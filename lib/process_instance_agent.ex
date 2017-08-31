defmodule ProcessInstanceAgent do
  use Agent
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

  def getStatus(id) do
    Agent.get(via_tuple(id), fn instance -> instance.status  end)
  end

  def getHistory(id) do
    Agent.get(via_tuple(id), fn instance -> instance.history  end)
  end

  def getVersion(id) do
    Agent.get(via_tuple(id), fn instance -> instance.version  end)
  end

  def next_step(id) do
    Agent.update(via_tuple(id), &ProcessInstance.next_step(&1))
  end

  def register_error(id, step_id, message) do
    IO.inspect(message)
    Agent.update(via_tuple(id), &ProcessInstance.register_error(&1, step_id, message))
  end

  def child_spec(_args) do
    %{id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      type: :worker}
  end

  defp via_tuple (process_id) do
    {:via, Registry, {:process_instance_registry, process_id}}
  end
end