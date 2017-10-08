defmodule Definition.BPMLinkTest do
  use ExUnit.Case, async: true

alias Definition.BPMLink
alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway

  setup do

    result = %ProcessDefinition{id: :link}
    |> ProcessDefinition.add(%BPMEvent{id: :start, type: :startEvent, name: "start"})
    |> ProcessDefinition.add(%BPMTask{id: :task1, type: :task, name: "theTask"})
    |> ProcessDefinition.add(%BPMTask{id: :task2, type: :task, name: "theOtherTask"})
    |> ProcessDefinition.add(%BPMGateway{id: :gateway1, type: :exclusiveGateway, name: "theGateway"})
    |> ProcessDefinition.add(%BPMEvent{id: :stop, type: :endEvent, name: "stop"})
    {:ok, process: result}
  end


  test "link 2 process.tasks",  %{process: process} do

    {task1, task2} = BPMLink.link(process.tasks[:task1], process.tasks[:task2], 1)

    assert length(task2.incoming) == 1
    assert length(task1.outgoing) == 1
    assert List.first(task2.incoming).id == 1

  end

  test "link 3 steps",  %{process: process} do

    {start, task} = BPMLink.link(process.events[:start], process.tasks[:task1], 1)
    {task1, task2} = BPMLink.link(process.tasks[:task1], process.tasks[:task2], 1)

    assert length(start.outgoing) == 1
    assert length(task.incoming) == 1
    assert task.id == task1.id
    assert length(task2.incoming) == 1
    assert length(task1.outgoing) == 1
    assert List.first(task2.incoming).id == 1

  end

  test "link a task and an event",  %{process: process} do

    {task, event} = BPMLink.link(process.tasks[:task1], process.events[:stop], 1)

    assert length(task.outgoing) == 1
    assert length(event.incoming) == 1
    assert List.first(event.incoming).id == 1
    assert List.first(task.outgoing).id == 1
  end

   test "link a task and a gateway",  %{process: process} do


     {task, gateway} = BPMLink.link(process.tasks[:task1], process.gateways[:gateway1], 1)
     assert length(task.outgoing) == 1
     assert length(gateway.incoming) == 1
     assert List.first(gateway.incoming).id == 1
     assert List.first(task.outgoing).id == 1
   end

   test "link a gateway and an event",  %{process: process} do

     {gateway, event} = BPMLink.link(process.gateways[:gateway1], process.events[:stop], 1)
     assert length(gateway.outgoing) == 1
     assert length(event.incoming) == 1
     assert List.first(event.incoming).id == 1
     assert List.first(gateway.outgoing).id == 1
   end

end
