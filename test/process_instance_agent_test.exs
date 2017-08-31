defmodule ProcessInstanceAgentTest do
  use ExUnit.Case, async: false

  @moduledoc false

  @history [%{data: %{}, version: %{branch: 0, update: 0}, status: [event: :start]}]

  import Support.ProcessDefinition

  setup do
    start_supervised(ProcessInstanceSupervisor)
    start_supervised({Registry, [keys: :unique, name: :process_instance_registry]})

     ProcessInstanceSupervisor.start_process [1, simple_process()]
      :ok
  end

  test "start an agent with a process instance" do

    # test if the process is registered under its own id
    assert ProcessInstanceAgent.get(1).id == 1
    assert ProcessInstanceAgent.getStatus(1) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(1) == []

  end

  test "take a step in the process" do

    assert ProcessInstanceAgent.get(1).id == 1
    ProcessInstanceAgent.next_step(1)
    assert ProcessInstanceAgent.getStatus(1) == [{:task, :task1}]
    assert ProcessInstanceAgent.getHistory(1) == @history
  end

  test "register_error" do
    ProcessInstanceAgent.register_error(1, :task1, "task 1 failed")
    assert ProcessInstanceAgent.get(1).errors > 1
  end

end