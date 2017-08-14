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

  def start_process(id: id, process_definition: definition) do
    Supervisor.start_child(__MODULE__, [[id: id, process_definition: definition]])
  end

  def init(:ok) do

    children = [
      worker(ProcessInstanceAgent, [], restart: :temporary)
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end

end