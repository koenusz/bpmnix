defmodule ProcessEngine do
  use GenServer

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
  def start_link(process_id, process_implementation) do
    {:ok, _pid} = ProcessInstanceSupervisor.start_process([process_id, process_implementation])
    GenServer.start_link(__MODULE__, process_id)
  end

  @doc """
  Executes the implementation of a task with the associated task_id.
  """
  #TODO get the implemetation from the state.
  def execute_task(implementation, task_id, args) do
    task = "task_" <> Atom.to_string(task_id)
           |> String.to_atom
    apply(implementation, task, args)
  end

  @doc """
  This function retrieves the current state of the process instance.

  During execution this is the safest way of retrieving state, this call
  prevents race conditions that are possible when adressing the ProcessInstanceAgent directly.
  """
  def process_instance(pid) do
    GenServer.call(pid, :instance)
  end


  @doc """
  Recieves events targeted at the
  """
  def event(pid, event) do
    GenServer.cast(pid, event)
  end

  @doc """
  First call the process instance agent to determine the next step(s) in the process,
  then call self to execute these steps.
  """

  def next_step(process_id) do
    :ok = ProcessInstanceAgent.next_step process_id
    status = ProcessInstanceAgent.getStatus process_id
    for state <- status  do
      case state do
        {:event, event_Id} -> :ok
        {:task, task_id} -> :ok
      end
    end



    #    case for task, event or gateway
    #    call the appropriate function
  end



  #  callbacks

  def handle_cast({:event, event}, process_id) do
    present = ProcessInstanceAgent.getStatus(process_id)
              |> Enum.member?({:event, event})
    if present do
      next_step process_id
    else
      ProcessInstanceAgent.register_error(
        process_id,
        event,
        "Event #{event} not present in statuslist of process Instance #{process_id}"
      )
    end

    {:noreply, process_id}
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
