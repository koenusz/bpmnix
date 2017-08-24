defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import Support.ProcessDefinition

  @first_step_history_with_data [
    %{
      data: %{
        name: "my_data"
      },
      status: [
        event: :start
      ],
      version: [
        update: 0,
        branch: 0
      ]
    }
  ]

  @first_step_history_no_data [
    %{
      data: %{
      },
      status: [
        event: :start
      ],
      version: [
        update: 0,
        branch: 0
      ]
    }
  ]


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
    assert nextInstance.history == @first_step_history_no_data
    assert nextInstance.version == [update: 1, branch: 0]
  end

  test "add data to an instance" do
    with_data = ProcessInstance.new_instance(1, simple_process(), %{name: "my_data"})
    assert with_data.data == %{name: "my_data"}
    assert with_data.history == []
  end

  test "update data" do
    with_data = ProcessInstance.new_instance(1, simple_process(), %{name: "my_data"})
    assert with_data.data == %{name: "my_data"}
    assert with_data.history == []
    with_new_data = ProcessInstance.update_data(with_data, %{name: "updated"})
    assert with_new_data.data == %{name: "updated"}
    assert with_new_data.history == @first_step_history_with_data
    assert with_new_data.version == [update: 1, branch: 0]
  end

  test "complete a process", %{instance: instance} do
    returned_instance = ProcessInstance.complete(instance)
    assert returned_instance.completed?
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

  test "rewind to a previous step and start a new branch", %{instance: instance} do
    nextInstance = ProcessInstance.next_step(instance)
    assert nextInstance.version == 1.0

    to_version = 0.0
    rewinded = ProcessInstance.rewind(nextInstance, to_version)
    assert rewinded.version == 0.1
  end

  test "rewind fails due to version unknown", %{instance: instance} do
    nextInstance = ProcessInstance.next_step(instance)
    assert nextInstance.version == 1.0

    to_version = 2.0
    {:error, :version_not_in_instance} = ProcessInstance.rewind(instance, to_version)

  end



end