defmodule ProcessInstanceAgentTest do
  use ExUnit.Case, async: true

  @moduledoc false

  import Support.ProcessDefinition

  setup do
    case ProcessInstanceSupervisor.start_link do
      {:ok, sup } -> assert Process.alive?(sup)
      {:error, {:already_started, sup} } -> assert Process.alive?(sup)
    end

    {:ok, agent} = ProcessInstanceSupervisor.start_process [1, simple_process()]
    {:ok, agent: agent}
  end

  test "start an agent with a process instance", %{agent: agent} do

    assert ProcessInstanceAgent.getId(agent) == 1
    assert ProcessInstanceAgent.getStatus(agent) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(agent) == []

  end

  test "take a step in the process", %{agent: agent} do

    assert ProcessInstanceAgent.getId(agent) == 1
    ProcessInstanceAgent.next_step(agent)
    assert ProcessInstanceAgent.getStatus(agent) == [{:task, :task1}]
    assert ProcessInstanceAgent.getHistory(agent) == [{:event, :start}]
  end

end