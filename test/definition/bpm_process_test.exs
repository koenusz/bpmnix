defmodule Definition.BPMTaskTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway


  setup do

    process = simple_process(%BPMProcess{})
    {:ok, process: process}
  end


    test "step through the process", %{process: process} do


      assert process.status == [{:event, :start}]
      process = BPMProcess.next_step(process)
      assert process.status == [{:task, :task1}]
      process = BPMProcess.next_step(process)
      assert process.status == [{:task, :task2}]
      process = BPMProcess.next_step(process)
      assert process.status == [{:event, :stop}]
    end

    test "store a list of tasks", %{process: process} do
      process = BPMProcess.add(process, %Definition.BPMTask{id: :task3, name: "the new task"})

       Map.keys(process.tasks)
          |> length
          |> (fn length -> length == 3  end).()
          |> assert
    end

    test "get task by id", %{process: process} do

      {:ok, task} = BPMProcess.get(process,{:task, :task1})

      assert task.name == "task 1"

    end

    test "delete task", %{process: process} do


      process.tasks
      |> Map.keys
      |> length
      |> (fn length -> length == 2  end).()
      |> assert


      process
      |> BPMProcess.delete({:task, :task1})
      |> (fn process -> Map.keys(process.tasks) end).()
      |> length
      |> (fn length -> length == 1  end).()
      |> assert

    end

    test "update task" , %{process: process} do

      refute process.tasks[:task1].name == "this is updated"
      updated = %{process.tasks[:task1] | name: "this is updated"}

      process = BPMProcess.update(process, updated)
      assert process.tasks[:task1].name == "this is updated"


    end

    # setup the test data
    def simple_process(process) do

      process
      |> add_start_and_stop_events
      |> add_tasks
      |> BPMProcess.add_sequence_flow({:event, :start}, {:task, :task1}, 1)
      |> BPMProcess.add_sequence_flow({:task, :task1}, {:task, :task2}, 2)
      |> BPMProcess.add_sequence_flow({:task, :task2}, {:event, :stop}, 3)

    end

    def add_start_and_stop_events(process) do
      start = %BPMEvent{id: :start, name: "start"}
      stop = %BPMEvent{id: :stop, name: "stop"}

      process
      |> BPMProcess.add( start)
      |> BPMProcess.add( stop)
    end

    def add_tasks(process) do
      task = %BPMTask{id: :task1, name: "task 1"}
      task2 = %BPMTask{id: :task2, name: "task 2"}

      process
      |> BPMProcess.add(task)
      |> BPMProcess.add(task2)
    end

    def add_gateways(process) do
      gateway = %BPMGateway{id: 1, name: "myGateway1"}
      gateway2 = %BPMGateway{id: 2, name: "myGateway2"}

      process
      |> BPMProcess.add(gateway)
      |> BPMProcess.add(gateway2)
    end
end
