defmodule TestUtils do


  alias Definition.BPMProcess
  alias Definition.BPMTask
  alias Definition.BPMEvent
  alias Definition.BPMGateway




def simple_process(process) do

  process
  |> add_start_and_stop_events
  |> add_tasks
  |> BPMProcess.add_sequence_flow({:event, 1}, {:task, 1}, 1)
  |> BPMProcess.add_sequence_flow({:task, 1}, {:task, 2}, 2)
  |> BPMProcess.add_sequence_flow({:task, 2}, {:event, 2}, 3)

end

def add_start_and_stop_events(process) do
  start = %BPMEvent{id: 1, name: "start"}
  stop = %BPMEvent{id: 2, name: "stop"}

  process
  |> BPMProcess.add( start)
  |> BPMProcess.add( stop)
end

def add_tasks(process) do
  task = %BPMTask{id: 1, name: "task 1"}
  task2 = %BPMTask{id: 2, name: "task 2"}

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
