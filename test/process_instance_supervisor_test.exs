defmodule ProcessInstanceSupervisorTest do
  use ExUnit.Case, async: false
  @moduledoc false

  import Support.ProcessDefinition

  setup do
    start_supervised(ProcessInstanceSupervisor)
    start_supervised({Registry, [keys: :unique, name: :process_instance_registry]})

    ProcessInstanceSupervisor.start_process [1, simple_process()]
    :ok
  end


  test "a process restarts after a crash" do

    # test if the process is registered under its own id
    assert ProcessInstanceAgent.get(1).id == 1
    assert ProcessInstanceAgent.getStatus(1) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(1) == []

    [{pid, _value}] = Registry.lookup(:process_instance_registry, 1)

    #let it crash
    kill_and_assert_down(pid)
    wait_for_id(1)

    # test if the process is registered under its own id
    assert ProcessInstanceAgent.get(1).id == 1
    assert ProcessInstanceAgent.getStatus(1) == [{:event, :start}]
    assert ProcessInstanceAgent.getHistory(1) == []

  end


  test "child_spec of ProcessInstanceAgent is permanent" do
    assert Supervisor.child_spec(ProcessInstanceAgent, []).restart == :permanent
  end

  #waits until a process is reregistered
  defp wait_for_id(id) do

    case Registry.lookup(:process_instance_registry, 1) do
      [{pid, _value}] -> :ok
      [] ->
        :timer.sleep(100)
        wait_for_id(id)
    end
  end

  defp kill_and_assert_down(pid) do
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)
    assert_receive {:DOWN, ^ref, _, _, _}
  end

end
