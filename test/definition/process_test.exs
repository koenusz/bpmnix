defmodule ProcessTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMTask
alias Definition.BPMEvent
alias Definition.BPMGateway

  setup do
    {:ok, process} = BPMProcess.start_link
    {:ok, process: process}
  end



    def add2Events(process) do
      event = %BPMEvent{id: 1, name: "myEvent1"}
      event2 = %BPMEvent{id: 2, name: "myEvent2"}

      BPMProcess.addEvent(process, event)
      BPMProcess.addEvent(process, event2)

    end

    def add2Tasks(process) do
      task = %BPMTask{id: 1, name: "myTask"}
      task2 = %BPMTask{id: 2, name: "myTask2"}

      BPMProcess.addTask(process, task)
      BPMProcess.addTask(process, task2)
    end

    def add2Gateways(process) do
      gateway = %BPMGateway{id: 1, name: "myGateway"}
      gateway2 = %BPMGateway{id: 2, name: "myGateway2"}

      BPMProcess.addGateway(process, gateway)
      BPMProcess.addGateway(process, gateway2)
    end

end
