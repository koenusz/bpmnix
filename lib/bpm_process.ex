defmodule   BPMProcess do
  @moduledoc """
    This module provides macro's for creating a process implementation.
  """

  Module.register_attribute BPMProcess, :paths, accumulate: true

  defmacro __using__(path) do
    IO.puts("adding  #{path}")
    quote do
      import unquote(__MODULE__)
      add_process_definitions(unquote(path))
      Module.register_attribute __MODULE__, :steps, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def print_steps do
        IO.puts "steps registered are (#{inspect @steps})"
      end

    end

  end


  defmacro add_process_definitions(path) do
    case path do
      [] -> {:ok, "no path added"}
      "" <> rest ->
        path =
          unless String.ends_with?(path, ".bpmn") do
            path <> "/*.bpmn"
          else
            path
          end

        for bpmnLocation <- Path.wildcard(path) do
          IO.puts("processing #{inspect(bpmnLocation)}")
          {:ok, xml} = BPMNParser.read_file(bpmnLocation)
          definition = BPMNParser.process_definition(xml)
          quote do
            def definition ,
                do: unquote(Macro.escape(definition))
          end
        end
    end
  end

  defmacro task(id, do: implementation) do
    quote do: step({:task, unquote(id)}, do: unquote(implementation))
  end

  defmacro event(id, do: implementation) do
    quote do: step({:event, unquote(id)}, do: unquote(implementation))
  end

  defmacro gateway(id, do: implementation) do
    quote do: step({:gateway, unquote(id)}, do: unquote(implementation))
  end

  defmacro step({type, id}, do: implementation) do

    function_name =
      Atom.to_string(type) <> "_" <> Atom.to_string(id)
      |> String.to_atom

    quote do
      @steps{unquote(id)}
      def unquote(function_name)(), do: unquote implementation
    end
  end
end