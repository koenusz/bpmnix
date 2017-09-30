defmodule Support.SimpleImplementation do
  use BPMProcess
  @moduledoc false


  task(:task1) do
    IO.puts("testing task 1")
  end

  task(:task2) do
    IO.puts("testing task 2")
  end


  event(:start) do
    IO.puts("starting the process")
  end

  event(:stop) do
    IO.puts("stopping the process")
  end

  def definition() do
    Support.ProcessDefinition.simple_process()
  end

end
