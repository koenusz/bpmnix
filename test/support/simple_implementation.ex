defmodule Support.SimpleImplementation do
  use BPMProcess
  @moduledoc false


  task(:task1) do
    IO.puts("Support.SimpleImplementation: testing task 1")
  end

  task(:task2) do
    IO.puts("Support.SimpleImplementation: testing task 2")
  end


  event(:start) do
    IO.puts("Support.SimpleImplementation: starting the process")
  end

  event(:stop) do
    IO.puts("Support.SimpleImplementation: stopping the process")
  end

  def definition() do
    Support.ProcessDefinition.simple_process()
  end

end
