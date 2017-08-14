defmodule ProcessInstanceSupervisorTest do
  use ExUnit.Case, async: true
  @moduledoc false

  import Support.ProcessDefinition

  test "start a process instance with the supervisor" do

    {:ok, sup } = ProcessInstanceSupervisor.start_link
    assert Process.alive?(sup)
    {:ok, agent} = ProcessInstanceSupervisor.start_process(id: 1, process_definition: simple_process())
    assert Process.alive?(agent)

    assert ProcessInstanceAgent.getStatus(agent) == [{:event, :start}]
  end


end
