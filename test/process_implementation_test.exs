defmodule GatewayImplementationTest do
   use ExUnit.Case, async: true

    import ExUnit.CaptureIO

         @functions_in_implementation  [print_steps: 0,
                                  task_mytestingId: 0,
                                  task_taskId: 0,
                                  event_start: 0,
                                  gateway_decide: 0
                                  ]

      test "the helper has all the functions" do
        assert (@functions_in_implementation -- Support.GatewayImplementation.__info__ :functions)  == []
      end

      test "create a step" do
       assert capture_io(fn ->
            Support.GatewayImplementation.task_mytestingId
           end) == "Support.GatewayImplementation testing this step" <> "\n"
      end

      test "create a task" do
          assert capture_io(fn ->
            Support.GatewayImplementation.task_taskId
           end) == "Support.GatewayImplementation testing this task" <> "\n"
      end

      test "print steps" do

         assert capture_io(fn ->
              Support.GatewayImplementation.print_steps
             end) == "steps registered are ([{:decide}, {:start}, {:taskId}, {:mytestingId}])" <> "\n"
      end

   test "get a process definition by its process Id" do
     definition = Support.GatewayImplementation.definition
     assert definition.id == :Process_1

   end

end