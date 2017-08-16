defmodule ProcessInstanceSupervisorTest do
  use ExUnit.Case, async: true
  @moduledoc false

  import Support.ProcessDefinition

  test "start a process instance with the supervisor" do

    case ProcessInstanceSupervisor.start_link do
      {:ok, sup } -> assert Process.alive?(sup)
      {:error, {:already_started, sup} } -> assert Process.alive?(sup)
    end
    {:ok, agent} = ProcessInstanceSupervisor.start_process [1, simple_process()]
    assert Process.alive?(agent)

    assert ProcessInstanceAgent.getStatus(agent) == [{:event, :start}]
  end


end
