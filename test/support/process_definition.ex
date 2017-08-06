defmodule Support.ProcessDefinition do
  @moduledoc false

  alias Definition.BPMTask
  alias Definition.BPMEvent
  alias Definition.BPMGateway

   # setup the test data
      def simple_process() do

        %ProcessDefinition{id: :simple_process}
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