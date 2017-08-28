defmodule ProcessEngine do
  use GenServer


  defstruct auto_id: 1

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
  Starts the engine.
  """
  def start_link(args) do
    {:ok, pid} = ProcessInstanceSupervisor.start_process(args)
    GenServer.start_link(__MODULE__, pid , name: args.business_id)
  end


  def execute_task(implementation, task_id, args) do
    task = "task_" <> Atom.to_string(task_id)
    |> String.to_atom
    apply(implementation, task, args)
  end




  @doc """
  Recieves events targeted at the
  """
  def event(event, pid) do
    GenServer.cast(pid, {:event, event})
  end

  def handle_cast({:event}, _from, engine) do
  end


  @doc """
  Creates a new account process, based on the `process_id` integer.
  Returns a tuple such as `{:ok, process_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  #  def create_bpm_process_process(engine_server) do
  #
  #
  #  end


  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      type: :worker
    }
  end

end
