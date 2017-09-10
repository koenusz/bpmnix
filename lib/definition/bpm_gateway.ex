defmodule Definition.BPMGateway do


  @moduledoc """
    This module represents a BPM gateway. The incoming and outgoing are of type sequenceflow.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []



end
