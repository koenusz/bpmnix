defmodule Definition.BPMTaskTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess


  setup do
    Code.load_file("test/test_utils.exs")
    process = TestUtils.simple_process(%BPMProcess{})
    {:ok, process: process}
  end

    test "store a list of tasks", %{process: process} do
      process = BPMProcess.add(process, %Definition.BPMTask{id: 3, name: "the new task"})

       Map.keys(process.tasks)
          |> length
          |> (fn length -> length == 3  end).()
          |> assert
    end

    test "get task by id", %{process: process} do

      {:ok, task} = BPMProcess.get(process,{:task, 1})

      assert task.name == "task 1"

    end

    test "delete task", %{process: process} do


      process.tasks
      |> Map.keys
      |> length
      |> (fn length -> length == 2  end).()
      |> assert


      process
      |> BPMProcess.delete({:task, 1})
      |> (fn process -> Map.keys(process.tasks) end).()
      |> length
      |> (fn length -> length == 1  end).()
      |> assert

    end

    test "update task" , %{process: process} do

      refute process.tasks[1].name == "this is updated"
      updated = %{process.tasks[1] | name: "this is updated"}

      process = BPMProcess.update(process, updated)
      assert process.tasks[1].name == "this is updated"


    end

end
