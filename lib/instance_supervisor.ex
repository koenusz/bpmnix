defmodule ProcessInstanceSupervisor do
  use Supervisor
  @moduledoc """
    This supervisor supervises all the proces instances.
  """

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Starts a new process instance.

  ## Example usage


  """

  def start_process args do
    Supervisor.start_child(__MODULE__, args)
  end

  def init(:ok) do
    children = [
      ProcessInstanceAgent
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end

  def child_spec(_args) do
    %{id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      restart: :permanent,
      type: :supervisor}
  end

end