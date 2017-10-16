defmodule Definition.BPMTask do

  import Logger

  @moduledoc """
    This module represents a BPM Task.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []


  def default(task_id) do
    Logger.warn("Missing implementation for task #{inspect task_id}")
  end


end
