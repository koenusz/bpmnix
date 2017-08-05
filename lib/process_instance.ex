defmodule ProcessInstance do

  @moduledoc"""
    Represent an instance of the process definition.
"""

     @enforce_keys [:id, :history, :status, :process_definition]
    defstruct id: nil, history: [] , status: [{:event, :start}], process_definition: nil


    defmacro __using__(_options) do
        quote do
            import unquote(__MODULE__)
            Module.register_attribute __MODULE__, :steps, accumuilate: true
            @before_compile unquote(__MODULE__)
        end
    end

    defmacro __before_compile__(_env) do
        quote do
              def print_steps do
#                IO.puts "steps registered are (#{inspect @steps})"
              end
        end

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

