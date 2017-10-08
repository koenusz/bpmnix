defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import Support.SimpleImplementation

  @first_step_history_with_data [
    %{
      data: %{
        name: "start_data"
      },
      status: [
        event: :start
      ],
      version: %{
        update: 0,
        branch: 0
      }
    }
  ]


  setup do
    instance = ProcessInstance.new_instance(1, Support.SimpleImplementation, %{name: "start_data"})
    {:ok, instance: instance}
  end

  test "create a new instance", %{instance: instance} do
    assert instance.id == 1
    assert instance.history == []
    assert instance.status == [{:event, :start}]
    assert instance.process_implementation.definition.id == :simple_process
  end

  test "go to the next step", %{instance: instance} do
    nextInstance = ProcessInstance.complete_step(instance, {:event, :start})
    assert nextInstance.status == [task: :task1]
    assert nextInstance.history == @first_step_history_with_data
    assert nextInstance.version == %{update: 1, branch: 0}
  end

  test "add data to an instance" do
    with_data = ProcessInstance.new_instance(1, Support.SimpleImplementation, %{name: "my_data"})
    assert with_data.data == %{name: "my_data"}
    assert with_data.history == []
  end

  test "update data" do
    with_data = ProcessInstance.new_instance(1, Support.SimpleImplementation, %{name: "start_data"})
    assert with_data.data == %{name: "start_data"}
    assert with_data.history == []
    with_new_data = ProcessInstance.update_data(with_data, %{name: "updated"})
    assert with_new_data.data == %{name: "updated"}
    assert with_new_data.history == @first_step_history_with_data
    assert with_new_data.version == %{update: 1, branch: 0}
  end

  test "complete a process", %{instance: instance} do
    returned_instance = ProcessInstance.complete(instance)
    assert returned_instance.completed?
  end

  test "store an error", %{instance: instance} do
    with_error = ProcessInstance.register_error(instance, :start, "starting failed")
    assert length(with_error.errors) > 0
  end

  test "collect step metrics", %{instance: instance} do
    #    TODO waiting on Phoenix 1.4 apm implementation
    #    assert instance.task.endtime > 0
  end

  test "rewind to a previous step and start a new branch", %{instance: instance} do
    with_new_data = ProcessInstance.update_data(instance, %{name: "updated"})
    nextInstance = ProcessInstance.complete_step(with_new_data, {:event, :start})
    rewound = ProcessInstance.rewind(nextInstance, %{update: 0, branch: 0})

    assert nextInstance.version == %{update: 2, branch: 0}
    assert nextInstance.data == %{name: "updated"}

    assert rewound.version == %{update: 0, branch: 1}
    assert rewound.data == %{name: "start_data"}
  end

  test "rewind fails due to version unknown", %{instance: instance} do
    with_new_data = ProcessInstance.update_data(instance, %{name: "updated"})
    nextInstance = ProcessInstance.complete_step(with_new_data, {:event, :start})

    assert nextInstance.version == %{update: 2, branch: 0}
    assert nextInstance.data == %{name: "updated"}

    {:error, message} = ProcessInstance.rewind(nextInstance, %{update: 10, branch: 0})
    assert message == "no history items for version %{branch: 0, update: 10}"
  end



end