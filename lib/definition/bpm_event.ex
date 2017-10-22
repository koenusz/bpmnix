defmodule Definition.BPMEvent do

  require Logger

  @moduledoc """
    This module represents a BPM event. The incoming and outgoing are of type sequenceflow.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []

  def default(event_id) do
    Logger.warn("Missing implementation for event #{inspect event_id}")
  end

end
