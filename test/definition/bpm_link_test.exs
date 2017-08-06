defmodule Definition.BPMLinkTest do
  use ExUnit.Case, async: true

alias Definition.BPMLink
alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway

  setup do

    result = %ProcessDefinition{id: :link}
    |> ProcessDefinition.add(%BPMEvent{id: :start, name: "start"})
    |> ProcessDefinition.add(%BPMTask{id: :task1, name: "theTask"})
    |> ProcessDefinition.add(%BPMTask{id: :task2, name: "theOtherTask"})
    |> ProcessDefinition.add(%BPMGateway{id: :gateway1, name: "theGateway"})
    |> ProcessDefinition.add(%BPMEvent{id: :stop, name: "stop"})
    {:ok, process: result}
  end


  test "link 2 process.tasks",  %{process: process} do


    {task, task2} = BPMLink.link(process.tasks[:task1], process.tasks[:task2], 1)

    assert length(task2.incoming) == 1
    assert length(task.outgoing) == 1
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
