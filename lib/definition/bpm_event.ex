defmodule Definition.BPMEvent do

  @moduledoc """
    This module represents a BPM event. The incoming and outgoing are of type sequenceflow.
  """
  defstruct id: nil, name: nil, incoming: [], outgoing: []

end
