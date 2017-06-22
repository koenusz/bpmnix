defmodule BPMTaskTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMTask


  setup do
    {:ok, process} = BPMProcess.start_link
    {:ok, process: process}
  end



    def add2Tasks(process) do
      task = %BPMTask{id: 1, name: "myTask"}
      task2 = %BPMTask{id: 2, name: "myTask2"}

      BPMProcess.addTask(process, task)
      BPMProcess.addTask(process, task2)
    end

    test "store a list of tasks", %{process: process} do
      assert BPMProcess.getTasks(process) == %{}
      add2Tasks(process)
      tasks = BPMProcess.getTasks(process)
       Map.keys(tasks)
          |> length
          |> (fn length -> length == 2  end).()
          |> assert
    end

    test "get task by id", %{process: process} do

      add2Tasks(process)
      assert BPMProcess.getTaskById(process, 1).name == "myTask"

    end

    test "delete task", %{process: process} do

      add2Tasks(process)

      tasksBefore = BPMProcess.getTasks(process)
      BPMProcess.deleteTask(process, tasksBefore[1].id)

      tasksAfter = BPMProcess.getTasks(process)

      Map.keys(tasksAfter)
         |> length
         |> (fn length -> length == 1  end).()
         |> assert
    end

    test "update task" , %{process: process} do

      add2Tasks(process)

      tasksBefore = BPMProcess.getTasks(process)
      BPMProcess.deleteTask(process, tasksBefore[1].id)

      updated = %{tasksBefore[1] | name: "this is updated"}

      BPMProcess.updateTask(process, updated)

      tasksAfter = BPMProcess.getTasks(process)

      assert tasksAfter[1].name == "this is updated"


    end

end
