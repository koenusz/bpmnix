defmodule Definition.BPMGateway do

  require Logger

  @moduledoc """
    This module represents a BPM gateway. The incoming and outgoing are of type sequenceflow.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []

  def default(gateway_id) do
    Logger.warn("Missing implementation for gateway #{inspect gateway_id}")
  end


end
