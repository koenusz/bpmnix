defmodule ProcessImplementationTest do
   use ExUnit.Case, async: true

    import ExUnit.CaptureIO

         @functions_in_implementation  [print_steps: 0,
                                  task_mytestingId: 0,
                                  task_taskId: 0,
                                  event_start: 0,
                                  gateway_decide: 0
                                  ]

      test "the helper has all the functions" do
        assert (@functions_in_implementation -- Support.ProcessImplementation.__info__ :functions)  == []
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

   test "get a process definition by its process Id" do
     definition = Support.ProcessImplementation.definition
     assert definition.id == :Process_1

   end

end