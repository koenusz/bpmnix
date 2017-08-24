defmodule ProcessInstance do

  @moduledoc"""
    Represent an instance of the process definition.

    The versioning is semantic, it is a list consisting of two items. The
    first item represents the amount of updates done in the current branch.
    The second number is the branch number. The branch number starts at 0 and
    is increased by 1 every time the rewind function is called.

  """

  @enforce_keys [:id, :process_definition, :data]
  defstruct id: nil,
            version: [
              update: 0,
              branch: 0
            ],
            history: [],
            status: [{:event, :start}],
            data: %{},
            process_definition: nil,
            errors: [],
            completed?: false


  @doc """
  Creates a new instance for this process definition.
  """
  def new_instance(id, definition, data \\ %{}) do
    history = %{version: 0.0, step: [{:event, :start}], data: data}
    %ProcessInstance{id: id, process_definition: definition, data: data}
  end

  @doc """
  Determines the next step for this instance and updates the status and the history.
  """
  def next_step(instance) do
    next_status = ProcessDefinition.next_step instance.process_definition, instance.status
    %{instance | status: next_status, history: update_history(instance), version: version_update(instance)}

  end

  @doc """
  Updates the data map in the data field, adds a new historyy item and bumps the version.
  """

  def update_data(instance, %{} = data) do
    %{instance | data: data, history: update_history(instance), version: version_update(instance)}
  end

  @doc """
  Completes the process instance.
  """
  def complete(instance) do
    %{instance | completed?: true}
  end


  @doc """
  Rewinds the instance to the state the instance was in when it had the specified version.
  It will not recieve the specified version as new version.

  """
  def rewind(instance, version) do

  end

  defp history(data) do
    %{version: 0.0, step: [{:event, :start}], data: data}
  end

  defp update_history(instance) do
    new_entry = %{
      version: instance.version,
      status: [{:event, :start}],
      data: instance.data
    }
    [new_entry | instance.history]
  end

  defp version_update(instance) do
    [
      update: instance.version[:update] + 1,
      branch: instance.version[:branch]
    ]
  end

  defp version_branch(instance) do
    [
      update: instance.version[:update] ,
      branch: instance.version[:branch] + 1
    ]
  end


end

