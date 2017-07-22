defmodule Definition.BPMLinkTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMLink
alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway

  setup do
    process =  %BPMProcess{}
    result = process
    |> BPMProcess.add(%BPMEvent{id: 1, name: "start"})
    |> BPMProcess.add(%BPMTask{id: 1, name: "theTask"})
    |> BPMProcess.add(%BPMTask{id: 2, name: "theOtherTask"})
    |> BPMProcess.add(%BPMGateway{id: 1, name: "theGateway"})
    |> BPMProcess.add(%BPMEvent{id: 2, name: "stop"})
    {:ok, process: result}
  end


  test "link 2 process.tasks",  %{process: process} do

    {task, task2} = BPMLink.link(process.tasks[1], process.tasks[2], 1)

    assert length(task2.incoming) == 1
    assert length(task.outgoing) == 1
    assert List.first(task2.incoming).id == 1

  end

  test "link a task and an event",  %{process: process} do

    {task, event} = BPMLink.link(process.tasks[1], process.events[2], 1)

    assert length(task.outgoing) == 1
    assert length(event.incoming) == 1
    assert List.first(event.incoming).id == 1
    assert List.first(task.outgoing).id == 1
  end
  #
  # test "link a task and a gateway",  %{process: process} do
  #
  #
  #   {task, gateway} = BPMLink.link(process.tasks[1], process.gateways[2], 1)
  #   assert length(task.outgoing) == 1
  #   assert length(gateway.incoming) == 1
  #   assert List.first(gateway.incoming).id == 1
  #   assert List.first(task.outgoing).id == 1
  # end
  #
  # test "link a gateway and an event",  %{process: process} do
  #
  #   {gateway, event} = BPMLink.link(process.gateways[1], process.events[2], 1)
  #   assert length(gateway.outgoing) == 1
  #   assert length(event.incoming) == 1
  #   assert List.first(event.incoming).id == 1
  #   assert List.first(gateway.outgoing).id == 1
  # end

end
