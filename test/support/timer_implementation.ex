defmodule Support.SimpleTimer do
  use BPMProcess, "test/resources/timer.bpmn"
  @moduledoc false

  event(:timer) do
    :timer.sleep(10)
    #there is no reason to actually wait that long
    IO.puts("done waiting 1000 ms")
  end

  event(:StartEvent_1) do
    IO.puts("Support.SimpleImplementation: starting the process")
  end

  event(:EndEvent_0l52b8v) do
    IO.puts("Support.SimpleImplementation: stopping the process")
  end


end
