defmodule BPMTaskError do
  @moduledoc"""
  This module represents an error returned from a failing task.
"""
  @enforce_keys [:step_id, :instance_version, :error_message]
  defstruct step_id: nil, instance_version: nil , error_message: nil
  


end
