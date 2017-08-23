defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import Support.ProcessDefinition



  setup do
    instance = ProcessInstance.new_instance(1, simple_process())
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
    assert instance.is_completed
  end

  test "store an error", %{instance: instance} do
    assert length(instance.errors) > 0
  end

  test "execute a task", %{instance: instance} do
    assert instance.task.completed > 0
  end

  test "collect step metrics", %{instance: instance} do
    assert instance.task.endtime > 0
  end

end