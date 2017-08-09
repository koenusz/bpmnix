defmodule ProcessInstanceAgent do
  use Agent
  @moduledoc """
  This module is a wrapping agent around the process instance functional datastructure.
"""

    def start_link(opts) do
        [id: id, process_definition: process] = opts
        Agent.start_link( fn -> ProcessInstance.new_instance(id, process) end)
    end

    def getStatus(instance_agent) do
      Agent.get(instance_agent, fn instance -> instance.status  end )
    end

    def getHistory(instance_agent) do
      Agent.get(instance_agent, fn instance -> instance.history  end )
    end

    def next_step(instance_agent) do
      Agent.update(instance_agent, &ProcessInstance.next_step(&1))
    end
end