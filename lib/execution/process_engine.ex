defmodule ProcessEngine do
  use GenServer

  import Logger

  @moduledoc """
  An engine is responsible for facilitating interaction of a process instance
  with the outside world and executing the implementation steps.

  When a step finishes the engine will call next step on the ProcessInstanceAgent and will
  cast an event towards itself indicating which step to take next.

  This module is responsible for everything relating to the execution of a process.
    This includes:
    - deligating the execution of the steps to their implementation, each in their own process
    - processing incoming and outgoing events
    - logging errors
    - collecting metadata
  """


  @doc """
  Starts the engine. The state of the genserver is the process id.
  """
  def start_link(process_id, process_implementation) do
    {:ok, _pid} = ProcessInstanceSupervisor.start_process([process_id, process_implementation])
    GenServer.start_link(__MODULE__, process_id)
  end



  @doc """
  This function retrieves the current state of the process instance.

  During execution this is the safest way of retrieving state, this call
  prevents race conditions that are possible when adressing the ProcessInstanceAgent directly.
  """
  def process_instance(engine_pid) do
    GenServer.call(engine_pid, :instance)
  end


  @doc """
  Execute a step.
  """
  def execute_steps(engine_pid, step_type_ids) do
    for step_type_id <- step_type_ids do
      GenServer.cast(engine_pid, {:execute, step_type_id})
    end
  end

  def complete_step(engine_pid, step_type_id) do
    GenServer.cast(engine_pid, {:complete, step_type_id})
  end


  #  callbacks
  #handle the task response
  def handle_info(msg, {process_id, executing}) do
    Logger.debug "Engine: received #{inspect msg}"
  end


  def handle_cast({:complete, step_type_id}, state) do
    Logger.debug("Engine: completing #{inspect step_type_id}")
    ProcessInstanceAgent.complete_step(state, step_type_id)
    if ProcessInstanceAgent.end_event?(state, step_type_id) do
      ProcessInstanceAgent.complete(state)
      Logger.debug("Engine: detected end event, stopping engine")
    else
      ProcessInstanceAgent.next_step(state, step_type_id)
      |> fn next -> execute_steps self(), next  end.()
    end
    {:noreply, state}
  end

  def handle_cast({:execute, step_type_id}, state) do
    Logger.debug("Engine: executing #{inspect step_type_id}")
    ProcessInstanceAgent.execute_step(state, step_type_id)
    |> case do
         :ok -> complete_step(self(), step_type_id)
         :error -> GenServer.stop(self(), :execution_error)
       end
    {:noreply, state}
  end

  def handle_call(:instance, _from, process_id) do
    instance = ProcessInstanceAgent.get process_id
    {:reply, instance, process_id}
  end

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      type: :worker
    }
  end

end
