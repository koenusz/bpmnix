defmodule Support.ProcessImplementation do
        use BPMProcess, "test/resources/simple_gateway.bpmn"
  @moduledoc false

    step({:task, :mytestingId}) do
      IO.puts("testing this step")
    end

    task(:taskId) do
     IO.puts("testing this task")
     end

     event(:start) do
      IO.puts("testing this event")
     end

     gateway(:decide) do
      IO.puts("testing this gateway")
     end


end