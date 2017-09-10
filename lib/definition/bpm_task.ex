defmodule Definition.BPMTask do


  @moduledoc """
    This module represents a BPM Task.
  """
  @enforce_keys [:id, :type]
  defstruct id: nil, type: nil, name: nil, incoming: [], outgoing: []


end
