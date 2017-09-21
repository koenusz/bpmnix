defmodule ProcessLibrary do
  @moduledoc """
  Provides an exhaustive collection of all Process Definition that
  have been parsed from bpmn files that are located in the configured paths.
  """

  @bpmns ["test"]

  for directory <- @bpmns do

    for bpmnLocation <- Path.wildcard(directory <> "/*.bpmn") do
      IO.puts("processing #{inspect(bpmnLocation)}")
      {:ok, xml} = BPMNParser.read_file(bpmnLocation)
      definition = BPMNParser.process_definition(xml)

      def process_by_id(unquote(definition.id)),
          do: {:ok, unquote(Macro.escape(definition))}
    end
  end

  def process_by_id(id), do: {:error, "no process with id #{inspect(id)}"}

  @doc """
  The function scans the directory and returns a
  list of all the .bpmn files located in the directory.

  The function does not recursively scan subdirectories in the directory.

  Example:
  iex> find_bpmn(./bpmn)
    {:error, reason}

  iex> find_bpmn(./test)
    {:ok, files}

  """
  def find_bpmn(location) do
    Path.wildcard(location <> "*.bpmn")
  end


  @doc """
  Returns a ProcessDefinition by its id
  """
  #  def process_by_id(id), do: {:error, "process with id: #{id} not found" }

end
