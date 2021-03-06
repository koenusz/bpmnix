defmodule ProcessInstanceAgentTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  import ExUnit.CaptureLog


  @moduledoc false

  @history [
    %{
      data: %{},
      version: %{
        branch: 0,
        update: 0
      },
      status: [
        event: :start
      ]
    }
  ]

  setup do
    start_supervised(ProcessInstanceSupervisor)
    start_supervised({Registry, [keys: :unique, name: :process_instance_registry]})

    ProcessInstanceSupervisor.start_process [1, Support.SimpleImplementation]
    ProcessInstanceSupervisor.start_process [2, Support.SimpleTimer]
    :ok
  end

  test "start an agent with a process instance" do

    # test if the process is registered under its own id
    assert ProcessInstanceAgent.get(1).id == 1
    assert ProcessInstanceAgent.getStatus(1) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(1) == []

  end

  test "get a next step" do
    assert ProcessInstanceAgent.next_step(1, {:event, :start}) == [{:task, :task1}]
  end

  test "execute an event" do
    assert capture_io(
             fn ->
               ProcessInstanceAgent.execute_step(1, {:event, :start})
             end
           ) == "Support.SimpleImplementation: starting the process" <> "\n"
  end

  test "execute a default task" do
    assert capture_log(
             fn ->
               ProcessInstanceAgent.execute_step(1, {:event, :non_existing})
             end
           ) =~ "Missing implementation for event"
  end

  test "execute a timer event" do
    assert capture_io(
             fn ->
               ProcessInstanceAgent.execute_step(2, {:event, :timer})
             end
           ) == "done waiting 1000 ms" <> "\n"
  end

  test "take a step in the process" do

    assert ProcessInstanceAgent.get(1).id == 1
    ProcessInstanceAgent.complete_step(1, {:event, :start})
    assert ProcessInstanceAgent.getStatus(1) == [{:task, :task1}]
    assert ProcessInstanceAgent.getHistory(1) == @history
  end

  test "register_error" do
    ProcessInstanceAgent.register_error(1, :task1, "task 1 failed")
    assert ProcessInstanceAgent.get(1).errors > 1
  end

  test "complete a process" do
    ProcessInstanceAgent.complete(1)
    assert ProcessInstanceAgent.get(1).completed? == true
  end

end