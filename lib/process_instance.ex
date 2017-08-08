defmodule ProcessInstance do

  @moduledoc"""
    Represent an instance of the process definition.
"""

     @enforce_keys [:id, :process_definition]
    defstruct id: nil, history: [] , status: [{:event, :start}], process_definition: nil


    @doc """
    Creates a new instance for this process definition.
    """
    def new_instance(id, definition) do
    %ProcessInstance{id: id, process_definition: definition}
    end

    @doc """
    Determines the next step for this instance and updates the status and the history.
    """
    def next_step(instance) do
    next_status = ProcessDefinition.next_step(instance.process_definition, instance.status)
    %{instance | status: next_status, history: instance.status ++ instance.history }
    end


end

