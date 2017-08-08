defmodule BPMProcess do
  @moduledoc """
  This module provides macro's for creating a process implementation.
"""


  defmacro __using__(_options) do
          quote do
              import unquote(__MODULE__)
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