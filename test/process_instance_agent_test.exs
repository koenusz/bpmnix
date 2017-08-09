defmodule ProcessInstanceAgentTest do
  use ExUnit.Case, async: true

  @moduledoc false

import Support.ProcessDefinition

    setup do
      process = simple_process()
      {:ok, instance_agent_pid} = start_supervised({ProcessInstanceAgent, [id: 1, process_definition: process]})
      {:ok, instance_agent_pid: instance_agent_pid}
    end

  test "start an agent with a process instance", %{instance_agent_pid: instance_agent_pid} do

    assert ProcessInstanceAgent.getStatus(instance_agent_pid) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(instance_agent_pid) == []

  end

  test "take a step in the process", %{instance_agent_pid: instance_agent_pid} do
        ProcessInstanceAgent.next_step(instance_agent_pid)
        assert ProcessInstanceAgent.getStatus(instance_agent_pid) == [{:task, :task1}]
        assert ProcessInstanceAgent.getHistory(instance_agent_pid) == [{:event, :start}]
  end
  
end