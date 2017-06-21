defmodule Definition.BPMTask do


@moduledoc """
  This module represents a BPM Task.
"""
   @derive [Definition.BPMLink]
  defstruct id: nil, name: nil, incoming: [], outgoing: []


end
