defmodule ProcessTest do
  use ExUnit.Case, async: true

alias Definition

  setup do
    process = TestUtils.simpleProcess
    {:ok, process: process}
  end




end
