defmodule Bpmnix do
  use GenServer
  @moduledoc """
  This module creates a beam process to execute a BPMprocess
  """

  @doc """
  Hello world.

  ## Examples

      iex> Bpmnix.hello
      :world

  """
  def hello do
    :world
  end

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def read(pid) do
  GenServer.call(pid, {:read})
end

def add(pid, item) do
  GenServer.cast(pid, {:add, item})
end




end
