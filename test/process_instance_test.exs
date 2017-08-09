defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import Support.ProcessDefinition



    setup do
      instance = ProcessInstance.new_instance(1 , simple_process())
      {:ok, instance: instance}
    end

    test "create a new instance", %{instance: instance} do
        assert instance.id == 1
        assert instance.history == []
        assert instance.status == [{:event, :start}]
        assert instance.process_definition.id == :simple_process
    end

    test "go to the next step", %{instance: instance} do
        nextInstance = ProcessInstance.next_step(instance)

        assert nextInstance.status == [task: :task1]
        assert nextInstance.history == [event: :start]
    end


    test "complete a process", %{instance: instance} do
        refute instance
    end

    test "store an error", %{instance: instance} do
        refute instance
    end

end