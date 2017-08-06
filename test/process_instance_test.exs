defmodule ProcessInstanceTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import Support.ProcessDefinition

    @functions_in_instance  [print_steps: 0,
                            task_mytestingId: 0,
                            task_taskId: 0,
                            event_start: 0,
                            gateway_decide: 0,
                            new_instance: 2
                            ]

    defmodule ProcessInstanceTestHelper do
        use ProcessInstance

          step({:task, :mytestingId}) do
            IO.puts("testing this step")
          end

          task(:taskId) do
           IO.puts("testing this task")
           end

           event(:start) do
            IO.puts("testing this event")
           end

           gateway(:decide) do
            IO.puts("testing this gateway")
           end
    end


    test "create a new instance" do
      instance = ProcessInstanceTestHelper.new_instance :newId, simple_process()
      assert instance.id == :newId
      assert instance.history == []
      assert instance.status == [{:event, :start}]
      assert instance.process_definition.id == :simple_process
    end

    test "the helper has all the functions" do
      assert (@functions_in_instance -- ProcessInstanceTestHelper.__info__ :functions)  == []
    end

    test "create a step" do
     assert capture_io(fn ->
          ProcessInstanceTestHelper.task_mytestingId
         end) == "testing this step" <> "\n"
    end
    
    test "create a task" do
        assert capture_io(fn ->
          ProcessInstanceTestHelper.task_taskId
         end) == "testing this task" <> "\n"
    end

    test "print steps" do

       assert capture_io(fn ->
            ProcessInstanceTestHelper.print_steps
           end) == "steps registered are ([{:decide}, {:start}, {:taskId}, {:mytestingId}])" <> "\n"
    end

end