defmodule Execution.BPMProcessEngine do
  use GenServer


defstruct auto_id: 1

@moduledoc """
  This module is responsible for everything relating to the execution of a process.
    This includes:
    - starting a process,
    - deligating the execution of the steps to their implementation,
    - processing incoming and outgoing events
    - logging errors
    - collecting metadata
"""


@doc """
Starts the Engine.
"""
def start_link(name) do
GenServer.start_link(__MODULE__, :ok, name: name)
end


@bpm_process_registry_name :bpm_process_registry

  # @doc """
  #   Starts a BPMProcess
  # """
  # def start_process(engine, %Definition.BPMProcess{} = process) do
  #
  # end
  #
  # @doc """
  #   Provides an abstraction point from withing a process step or an implementations to send data to metrics consumers.
  # """
  # def collect_metrics(engine, metric) do
  #
  # end
  #
  # @doc """
  #   Returns a list of processes in the specified state. Call with state [] to retrieve all processes.
  # """
  # def get_processes(engine, processState) do
  #
  # end

  @doc """
    Creates a new BPMProcess
  """
  def find_process(process_id) when is_integer(process_id) do

    case Registry.lookup(@bpm_process_registry_name, process_id) do
      [process] -> {:ok, process}
      [] -> {:error, "No process found for id #{process_id}"}
    end
  end

  @doc """
Determines if a `Execution.BpmProcess`  exists, based on the `process_id` provided.
Returns a boolean.
## Example
    iex> Execution.BpmProcess.BpmProcess_process_exists?(6)
    false
"""
def bpm_process_process_exists?(process_id) when is_integer(process_id) do
  case Registry.lookup(@bpm_process_registry_name, process_id) do
    [] -> false
    _ -> true
  end
end

@doc """
Creates a new account process, based on the `process_id` integer.
Returns a tuple such as `{:ok, process_id}` if successful.
If there is an issue, an `{:error, reason}` tuple is returned.
"""
def create_bpm_process_process(engine) do
  IO.puts("start")
  id = engine.auto_id
  IO.puts(id)
  case Supervisor.start_child(__MODULE__, [engine.auto_id]) do
    {:ok, _pid} -> {:ok, engine.auto_id, %{engine | auto_id: engine.auto_id + 1}}
    {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
    other -> {:error, other}
  end
end


end
