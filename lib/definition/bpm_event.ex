defmodule Definition.BPMEvent do

  @moduledoc """
    This module represents a BPM event. The incoming and outgoing are of type sequenceflow.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []

end
