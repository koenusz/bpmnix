defmodule Definition.BPMSequenceFlow do


@moduledoc """
This module represents links between tasks and events.
"""
   @enforce_keys [:id, :source, :target]

  defstruct @enforce_keys

end
