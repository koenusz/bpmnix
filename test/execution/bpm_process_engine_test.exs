defmodule Execution.BPMProcessEngineTest do
  use ExUnit.Case, async: true

alias Execution.BPMProcessEngine, as: Engine

  setup do
    # children = [
    #   supervisor(Registry, [:unique, :bpm_process_registry]),
    #   supervisor(Execution.BPMProcessEngine, [:bpm_engine])
    # ]
    #
    # opts = [strategy: :one_for_one, name: BPMnix.Supervisor]
    # Supervisor.start_link(children, opts)

    {:ok, engine} = Engine.start_link(:bpm_engine)
    {:ok, engine: engine}
  end

  test "start a process", %{engine: engine} do
    # {:ok, process_id}
    anyt = Engine.create_bpm_process_process(engine)
    IO.inspect(anyt)
    # assert Engine.bpm_process_process_exists(process_id)
    # assert engine.auto_id == 2
  end



  # test "start 2 engines", %{engine: engine} do
  #
  #   {:ok, engine2} = Engine.start_link("engine2")
  #   IO.inspect(engine)
  # end
  #
  # test "start 2 processes on different engines", %{engine: engine} do
  #
  # end

end
