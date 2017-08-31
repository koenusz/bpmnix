defmodule ProcessInstance do

  @moduledoc"""
    Represent an instance of the process definition.

    Process instances have time travelling built into them. The rewind function
    can pring the process instance into a previous state.

    The versioning is semantic, it is a list consisting of two items. The
    first item represents the amount of updates done in the current branch.
    The second number is the branch number. The branch number starts at 0 and
    is increased by 1 every time the rewind function is called.

  """

  @enforce_keys [:id, :process_definition, :data]
  defstruct id: nil,
            version: %{
              update: 0,
              branch: 0
            },
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
  Updates the data map in the data field, adds a new history item and increases
  the update in the version by 1.
  """

  def update_data(instance, %{} = data) do
    %{instance | data: data, history: update_history(instance), version: version_update(instance)}
  end

  @doc """
  Stores an error that occured in the system on the process instance.
  """
  def register_error(instance, step_id,  message) do
    %BPMTaskError{ step_id: step_id, instance_version: instance.version  , error_message: message}
    |> fn error ->  [error] ++ instance.errors end.()
    |> fn errors -> %{instance | errors: errors} end.()

  end

  @doc """
  Completes the process instance.
  """
  #  TODO: probably send the instance to permanent storage.
  def complete(instance) do
    %{instance | history: update_history(instance), completed?: true}
  end


  @doc """
  Rewinds the instance to the state the instance was in when it had the specified version.
  It will not recieve the specified version as new version. Rather it will set the update to 0
  and use the branch of the instance + 1. The state of the instance will be reset to the way
  it was during the specified version.

  The history of the instance will not be deleted. A rewind creates its own history update.
  """
  def rewind(instance, to_version) do


    case history_item(instance.history, to_version) do
      {:ok, %{data: data, status: _, version: _}} ->
        %{
          instance
        |
          data: data,
          history: update_history(instance),
          version: version_new_branch(instance)
        }
        {:error, message} ->  {:error, message}
    end
  end

  @doc"""
  Returns the history item associated with the version.
  """
  def history_item(history, version) do
    filtered = history
    |> Enum.filter(fn history -> history.version == version end)

    case length(filtered) do
    x when x > 1 -> {:error, "multiple history items in history for version #{inspect version}"}
    x when x == 0 -> {:error, "no history items for version #{inspect version}"}
    x when x == 1 -> {:ok, Enum.at(filtered, 0)}
    end
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
    %{
      update: instance.version[:update] + 1,
      branch: instance.version[:branch]
    }
  end

  defp version_new_branch(instance) do
    %{
      update: 0,
      branch: instance.version[:branch] + 1
    }
  end

end

