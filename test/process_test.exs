defmodule ProcessTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMTask
alias Definition.BPMLink
alias Definition.BPMEvent

  setup do
    {:ok, process} = BPMProcess.start_link
    {:ok, process: process}
  end



    def add2Events(process) do
      event = %BPMEvent{id: 1, name: "myEvent1"}
      event2 = %BPMEvent{id: 2, name: "myEvent2"}

      BPMProcess.addEvent(process, event)
      BPMProcess.addEvent(process, event2)

    end

    def add2Tasks(process) do
      task = %BPMTask{id: 1, name: "myTask"}
      task2 = %BPMTask{id: 2, name: "myTask2"}

      BPMProcess.addTask(process, task)
      BPMProcess.addTask(process, task2)
    end




  test "link 2 tasks",  %{process: process} do
    add2Tasks(process)
    tasks = BPMProcess.getTasks(process)

    {task3, task4} = BPMLink.link(tasks[1], tasks[2], 1)



    assert length(task4.incoming) == 1
    assert length(task3.outgoing) == 1
    assert List.first(task4.incoming).id == 1

  end

  test "link a task and an event",  %{process: process} do
    add2Tasks(process)
    tasks = BPMProcess.getTasks(process)

    {task3, task4} = BPMLink.link(tasks[1], tasks[2], 1)



    assert length(task4.incoming) == 1
    assert length(task3.outgoing) == 1
    assert List.first(task4.incoming).id == 1

  end


end
