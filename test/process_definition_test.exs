defmodule ProcessDefinitionTest do
  use ExUnit.Case, async: true

import Support.ProcessDefinition

  setup do
    process = simple_process()
    {:ok, process: process}
  end


    test "step through the process", %{process: process} do
      newstatus = ProcessDefinition.next_step(process, [{:event, :start}])
      assert newstatus == [{:task, :task1}]
      newstatus = ProcessDefinition.next_step(process, [{:task, :task1}])
      assert newstatus == [{:task, :task2}]
      newstatus = ProcessDefinition.next_step(process, [{:task, :task2}])
      assert newstatus == [{:event, :stop}]
    end


    test "add a task to a process", %{process: process} do
      process = ProcessDefinition.add(process, %Definition.BPMTask{id: :task3, name: "the new task"})
      Map.keys(process.tasks)
         |> length
         |> (fn length -> length == 3  end).()
         |> assert
    end


    test "get task by id", %{process: process} do
      {:ok, task} = ProcessDefinition.get(process,{:task, :task1})
      assert task.name == "task 1"
    end


    test "delete task", %{process: process} do
      process.tasks
      |> Map.keys
      |> length
      |> (fn length -> length == 2  end).()
      |> assert

      process
      |> ProcessDefinition.delete({:task, :task1})
      |> (fn process -> Map.keys(process.tasks) end).()
      |> length
      |> (fn length -> length == 1  end).()
      |> assert
    end


    test "update task" , %{process: process} do
      refute process.tasks[:task1].name == "this is updated"
      updated = %{process.tasks[:task1] | name: "this is updated"}
      process = ProcessDefinition.update(process, updated)
      assert process.tasks[:task1].name == "this is updated"
    end
end
