defmodule Definition.BPMLinkTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMLink

  setup do
     process = TestUtils.simpleProcess
    {:ok, process: process}
  end


  test "link 2 tasks",  %{process: process} do
    tasks = BPMProcess.getTasks(process)

    {task3, task4} = BPMLink.link(tasks[1], tasks[2], 1)



    assert length(task4.incoming) == 1
    assert length(task3.outgoing) == 1
    assert List.first(task4.incoming).id == 1

  end

  test "link a task and an event",  %{process: process} do
    tasks = BPMProcess.getTasks(process)
    events = BPMProcess.getEvents(process)

    {task, event} = BPMLink.link(tasks[1], events[2], 1)
    assert length(task.outgoing) == 1
    assert length(event.incoming) == 1
    assert List.first(event.incoming).id == 1
    assert List.first(task.outgoing).id == 1
  end

  test "link a task and a gateway",  %{process: process} do
    tasks = BPMProcess.getTasks(process)
    gateways = BPMProcess.getGateways(process)

    {task, gateway} = BPMLink.link(tasks[1], gateways[2], 1)
    assert length(task.outgoing) == 1
    assert length(gateway.incoming) == 1
    assert List.first(gateway.incoming).id == 1
    assert List.first(task.outgoing).id == 1
  end

  test "link a gateway and an event",  %{process: process} do

    gateways = BPMProcess.getGateways(process)
    events = BPMProcess.getEvents(process)

    {gateway, event} = BPMLink.link(gateways[1], events[2], 1)
    assert length(gateway.outgoing) == 1
    assert length(event.incoming) == 1
    assert List.first(event.incoming).id == 1
    assert List.first(gateway.outgoing).id == 1
  end

end
