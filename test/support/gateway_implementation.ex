defmodule Support.GatewayImplementation do
        use BPMProcess, "test/resources/simple_gateway.bpmn"
  @moduledoc false

    step({:task, :mytestingId}) do
      IO.puts("#{inspect __MODULE__} testing this step")
    end

    task(:taskId) do
     IO.puts("#{inspect __MODULE__} testing this task")
     end

     event(:start) do
      IO.puts("#{inspect __MODULE__} testing this event")
     end

     gateway(:decide) do
      IO.puts("#{inspect __MODULE__} testing this gateway")
      [:SequenceFlow_1eecs6l]
     end


end