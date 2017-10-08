defmodule ProcessEngineTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  import Support.SimpleImplementation

  setup do
  start_supervised(ProcessInstanceSupervisor)
  start_supervised({Registry, [keys: :unique, name: :process_instance_registry]})
  start_supervised({ProcessEngineSupervisor, name: :process_engine_supervisor})
  {:ok, engine} = ProcessEngineSupervisor.start_engine([1, Support.SimpleImplementation])
  {:ok, engine: engine}
  end
#  When a user of the library fires up a start event, a new engine,
#  and process instance should be started with the approprate definition.
  test "Recieve a start event", %{engine: engine} do

    ProcessEngine.execute_step( engine, {:event, :start})
    |> IO.inspect
    instance = ProcessEngine.process_instance(engine)
    |> IO.inspect
    assert instance.id == 1
    refute instance.status == [{:event, :start}]
    assert (length instance.history) > 0
  end

  test "Recieve a start event error case", %{engine: engine} do

    :ok = ProcessEngine.event( engine, {:event, :thisgivesanerror})
    Process.alive?(engine)
    instance = ProcessEngine.process_instance(engine)

    assert instance.id == 1
    assert (length instance.errors) > 0
  end

  test "recieve a ... event" do
    refute true
  end

  test "execute the whole process", %{engine: engine} do

    :ok = ProcessEngine.event( engine, {:event, :start})
    instance = ProcessEngine.process_instance(engine)

    assert instance.id == 1
    assert instance.completed? == true
    assert (length instance.history) == 4
  end

  test "recover from crashing task execution" do
    refute true
  end


end
