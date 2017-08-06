defmodule TaskTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

    @functions_in_instance  [print_steps: 0,
                            task_mytestingId: 0,
                            task_taskId: 0,
                            event_start: 0,
                            gateway_decide: 0
                            ]

    defmodule TaskTestHelper do
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


    test "the helper has all the functions" do
      assert (@functions_in_instance -- TaskTestHelper.__info__ :functions) == []
    end

    test "create a step" do
     assert capture_io(fn ->
          TaskTestHelper.task_mytestingId
         end) == "testing this step" <> "\n"
    end
    
    test "create a task" do
        assert capture_io(fn ->
          TaskTestHelper.task_taskId
         end) == "testing this task" <> "\n"
    end

    test "print steps" do

       assert capture_io(fn ->
            TaskTestHelper.print_steps
           end) == "steps registered are ([{:decide}, {:start}, {:taskId}, {:mytestingId}])" <> "\n"
    end

end