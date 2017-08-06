defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import Support.ProcessDefinition

    @functions_in_instance  [print_steps: 0,
                            task_mytestingId: 0,
                            task_taskId: 0,
                            event_start: 0,
                            gateway_decide: 0
                            ]

    setup do
      instance = ProcessInstance.new_instance(:testId, simple_process())
      {:ok, instance: instance}
    end

    test "create a new instance", %{instance: instance} do
        assert instance.id == :testId
        assert instance.history == []
        assert instance.status == [{:event, :start}]
        assert instance.process_definition.id == :simple_process
    end

    test "go to the next step", %{instance: instance} do
        nextInstance = ProcessInstance.next_step(instance)

        assert nextInstance.status == [task: :task1]
        assert nextInstance.history == [event: :start]
    end


#    test "complete a process", %{instance: instance} do
#
#    end

    test "the helper has all the functions" do
      assert (@functions_in_instance -- Support.ProcessImplementation.__info__ :functions)  == []
    end

    test "create a step" do
     assert capture_io(fn ->
          Support.ProcessImplementation.task_mytestingId
         end) == "testing this step" <> "\n"
    end

    test "create a task" do
        assert capture_io(fn ->
          Support.ProcessImplementation.task_taskId
         end) == "testing this task" <> "\n"
    end

    test "print steps" do

       assert capture_io(fn ->
            Support.ProcessImplementation.print_steps
           end) == "steps registered are ([{:decide}, {:start}, {:taskId}, {:mytestingId}])" <> "\n"
    end

end