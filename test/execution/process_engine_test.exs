defmodule ProcessEngineTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO


  setup do
  start_supervised(ProcessInstanceSupervisor)
  engine_supervisor = start_supervised(ProcessEngineSupervisor)

  {:ok, engine_supervisor: engine_supervisor}
  end
#  When a user of the library fires up a start event, a new engine,
#  and process instance should be started with the approprate definition.
  test "Recieve a start event", %{engine_supervisor: engine_supervisor} do
#    engine_supervisor.start_engine []
  end

  test "recieve a ... event" do

  end

  test "execute a task" do

    assert capture_io(fn ->
             ProcessEngine.execute_task(Support.ProcessImplementation, :taskId, [])
             end) == "testing this task" <> "\n"

  end

  test "recieve a stop event" do

  end

  test "recover from crashing task execution" do

  end


end
