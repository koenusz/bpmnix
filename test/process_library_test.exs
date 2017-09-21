defmodule ProcessLibraryTest do
  use ExUnit.Case, async: true
  @moduledoc false


  test "configure a directory where bpmn files can be read from" do

  end

  test "get a process definition by its process Id" do


    {:ok, proc} = ProcessLibrary.process_by_id(:Process_1)
    assert proc.id == :Process_1
    {:error, message} = ProcessLibrary.process_by_id("bad")
    assert message == "no process with id \"bad\""
  end

  test "get a list of all parsed processes" do

  end

end
