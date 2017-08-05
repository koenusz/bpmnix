defmodule ProcessDefinitionTest do
  use ExUnit.Case, async: true


alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway


  setup do

    process = simple_process(%ProcessDefinition{})
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

    test "store a list of tasks", %{process: process} do
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

    # setup the test data
    def simple_process(process) do

      process
      |> add_start_and_stop_events
      |> add_tasks
      |> ProcessDefinition.add_sequence_flow({:event, :start}, {:task, :task1}, 1)
      |> ProcessDefinition.add_sequence_flow({:task, :task1}, {:task, :task2}, 2)
      |> ProcessDefinition.add_sequence_flow({:task, :task2}, {:event, :stop}, 3)

    end

    def add_start_and_stop_events(process) do
      start = %BPMEvent{id: :start, name: "start"}
      stop = %BPMEvent{id: :stop, name: "stop"}

      process
      |> ProcessDefinition.add( start)
      |> ProcessDefinition.add( stop)
    end

    def add_tasks(process) do
      task = %BPMTask{id: :task1, name: "task 1"}
      task2 = %BPMTask{id: :task2, name: "task 2"}

      process
      |> ProcessDefinition.add(task)
      |> ProcessDefinition.add(task2)
    end

    def add_gateways(process) do
      gateway = %BPMGateway{id: 1, name: "myGateway1"}
      gateway2 = %BPMGateway{id: 2, name: "myGateway2"}

      process
      |> ProcessDefinition.add(gateway)
      |> ProcessDefinition.add(gateway2)
    end
end
