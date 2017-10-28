defmodule BPMNParserTest do
  use ExUnit.Case, async: true
  @moduledoc """
    This module takes in bpmn files and parses it into a ProcessDefinition.
  """
  import ExUnit.CaptureLog
  require Logger
  alias Definition.BPMEvent

  @file_location Path.expand("./test/resources/simple_gateway.bpmn")
  @incorrect_file_location Path.expand("./notThere.bpmn")


  setup do
    {:ok, doc} = BPMNParser.read_file @file_location
    {:ok, doc: doc}
  end

  test "read the file" do
    {:ok, doc} = BPMNParser.read_file @file_location
    refute doc == nil
  end

  test "read the file has an error" do
    assert capture_log(
             fn ->
               BPMNParser.read_file @incorrect_file_location
             end
           ) =~ "Could not open file"
  end

  test "get the start events", %{doc: doc} do
    assert BPMNParser.start_events(doc) == [
             %BPMEvent{id: :start, type: :startEvent, name: "Start", outgoing: []}
           ]
  end

  test "get the end events", %{doc: doc} do
    assert BPMNParser.end_events(doc) == [
             %BPMEvent{id: :EndEvent_019ow9h, type: :endEvent},
             %BPMEvent{id: :EndEvent_1hwhq9d, type: :endEvent}
           ]
  end

  test "get the events", %{doc: doc} do
    assert BPMNParser.events(doc) == [
             %Definition.BPMEvent{id: :start, incoming: [], name: "Start", outgoing: [], type: :startEvent},
             %Definition.BPMEvent{id: :EndEvent_019ow9h, incoming: [], name: nil, outgoing: [], type: :endEvent},
             %Definition.BPMEvent{id: :EndEvent_1hwhq9d, incoming: [], name: nil, outgoing: [], type: :endEvent}
           ]
  end

  test "get a list of tasks", %{doc: doc} do
    assert BPMNParser.tasks(doc) == [
             %Definition.BPMTask{
               id: :task1,
               incoming: [],
               name: "task 1",
               outgoing: [],
               type: :task
             },
             %Definition.BPMTask{
               id: :success,
               incoming: [],
               name: "handle success",
               outgoing: [],
               type: :task
             },
             %Definition.BPMTask{
               id: :faillure,
               incoming: [],
               name: "handle failure",
               outgoing: [],
               type: :task
             }
           ]
  end

  test "get the gateways", %{doc: doc} do
    assert BPMNParser.gateways(doc) == [
             %Definition.BPMGateway{
               id: :decide,
               incoming: [],
               name: nil,
               outgoing: [],
               type: :exclusiveGateway
             }
           ]
  end

  test "get the sequence flows", %{doc: doc} do
    assert BPMNParser.sequence_flows(doc) == [
             {:SequenceFlow_1bqc04t, :start, :task1},
             {:SequenceFlow_1trdcoy, :task1, :decide},
             {:SequenceFlow_0byeq17, :decide, :success},
             {:SequenceFlow_19mi11y, :success, :EndEvent_019ow9h},
             {:SequenceFlow_1eecs6l, :decide, :faillure},
             {:SequenceFlow_1ahnvqs, :faillure, :EndEvent_1hwhq9d}
           ]
  end

  test "find a step by id in the steplist" do

  end

  test "create a process", %{doc: doc} do
    assert BPMNParser.process_definition(doc) ==
             %ProcessDefinition{
               id: :Process_1,
               events: %{
                 EndEvent_019ow9h: %Definition.BPMEvent{
                   id: :EndEvent_019ow9h,
                   name: nil,
                   outgoing: [],
                   type: :endEvent,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_19mi11y,
                       source: {:task, :success},
                       target: {:event, :EndEvent_019ow9h}
                     }
                   ]
                 },
                 EndEvent_1hwhq9d: %Definition.BPMEvent{
                   id: :EndEvent_1hwhq9d,
                   name: nil,
                   outgoing: [],
                   type: :endEvent,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1ahnvqs,
                       source: {:task, :faillure},
                       target: {:event, :EndEvent_1hwhq9d}
                     }
                   ]
                 },
                 start: %Definition.BPMEvent{
                   id: :start,
                   incoming: [],
                   name: "Start",
                   type: :startEvent,
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1bqc04t,
                       source: {:event, :start},
                       target: {:task, :task1}
                     }
                   ]
                 }
               },
               gateways: %{
                 decide: %Definition.BPMGateway{
                   id: :decide,
                   name: nil,
                   type: :exclusiveGateway,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1trdcoy,
                       source: {:task, :task1},
                       target: {:gateway, :decide}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_0byeq17,
                       source: {:gateway, :decide},
                       target: {:task, :success}
                     },
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1eecs6l,
                       source: {:gateway, :decide},
                       target: {:task, :faillure}
                     }
                   ]
                 }
               },
               tasks: %{
                 task1: %Definition.BPMTask{
                   id: :task1,
                   name: "task 1",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1bqc04t,
                       source: {:event, :start},
                       target: {:task, :task1}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1trdcoy,
                       source: {:task, :task1},
                       target: {:gateway, :decide}
                     }
                   ]
                 },
                 success: %Definition.BPMTask{
                   id: :success,
                   name: "handle success",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_0byeq17,
                       source: {:gateway, :decide},
                       target: {:task, :success}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_19mi11y,
                       source: {:task, :success},
                       target: {:event, :EndEvent_019ow9h}
                     }
                   ]
                 },
                 faillure: %Definition.BPMTask{
                   id: :faillure,
                   name: "handle failure",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1eecs6l,
                       source: {:gateway, :decide},
                       target: {:task, :faillure}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1ahnvqs,
                       source: {:task, :faillure},
                       target: {:event, :EndEvent_1hwhq9d}
                     }
                   ]
                 }
               }
             }
  end

  test "find a process by process id" do

  end

end
