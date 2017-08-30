defmodule ProcessEngineTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  import Support.ProcessDefinition

  setup do
  start_supervised(ProcessInstanceSupervisor)
  start_supervised({Registry, [keys: :unique, name: :process_instance_registry]})
  start_supervised({ProcessEngineSupervisor, name: :process_engine_supervisor})
  {:ok, engine} = ProcessEngineSupervisor.start_engine([1, simple_process()])
  {:ok, engine: engine}
  end
#  When a user of the library fires up a start event, a new engine,
#  and process instance should be started with the approprate definition.
  test "Recieve a start event", %{engine: engine} do

    :ok = ProcessEngine.event( engine, {:event, :start})
    instance = ProcessEngine.process_instance(engine)

    assert instance.id == 1
    assert instance.status != [{:event, :start}]
    assert (length instance.history) > 0
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
