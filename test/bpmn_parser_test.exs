defmodule BPMNParserTest do
  use ExUnit.Case, async: true
  @moduledoc """
    This module takes in bpmn files and parses it into a ProcessDefinition.
  """
  import ExUnit.CaptureLog
  require Logger
  alias Definition.BPMEvent

  @file_location Path.expand("./test/simple_gateway.bpmn")
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
             %BPMEvent{id: :StartEvent_1, type: :startEvent, name: "Start", outgoing: []}
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
             %Definition.BPMEvent{id: :StartEvent_1, incoming: [], name: "Start", outgoing: [], type: :startEvent},
             %Definition.BPMEvent{id: :EndEvent_019ow9h, incoming: [], name: nil, outgoing: [], type: :endEvent},
             %Definition.BPMEvent{id: :EndEvent_1hwhq9d, incoming: [], name: nil, outgoing: [], type: :endEvent}
           ]
  end

  test "get a list of tasks", %{doc: doc} do
    assert BPMNParser.tasks(doc) == [
             %Definition.BPMTask{
               id: :Task_0fsoe1r,
               incoming: [],
               name: "task 1",
               outgoing: [],
               type: :task
             },
             %Definition.BPMTask{
               id: :Task_0rsgnlx,
               incoming: [],
               name: "handle success",
               outgoing: [],
               type: :task
             },
             %Definition.BPMTask{
               id: :Task_1gfqk0h,
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
               id: :ExclusiveGateway_08pnq7v,
               incoming: [],
               name: nil,
               outgoing: [],
               type: :exclusiveGateway
             }
           ]
  end

  test "get the sequence flows", %{doc: doc} do
    assert BPMNParser.sequence_flows(doc) == [
             {:SequenceFlow_1bqc04t, :StartEvent_1, :Task_0fsoe1r},
             {:SequenceFlow_1trdcoy, :Task_0fsoe1r, :ExclusiveGateway_08pnq7v},
             {:SequenceFlow_0byeq17, :ExclusiveGateway_08pnq7v, :Task_0rsgnlx},
             {:SequenceFlow_19mi11y, :Task_0rsgnlx, :EndEvent_019ow9h},
             {:SequenceFlow_1eecs6l, :ExclusiveGateway_08pnq7v, :Task_1gfqk0h},
             {:SequenceFlow_1ahnvqs, :Task_1gfqk0h, :EndEvent_1hwhq9d}
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
                       source: {:task, :Task_0rsgnlx},
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
                       source: {:task, :Task_1gfqk0h},
                       target: {:event, :EndEvent_1hwhq9d}
                     }
                   ]
                 },
                 StartEvent_1: %Definition.BPMEvent{
                   id: :StartEvent_1,
                   incoming: [],
                   name: "Start",
                   type: :startEvent,
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1bqc04t,
                       source: {:event, :StartEvent_1},
                       target: {:task, :Task_0fsoe1r}
                     }
                   ]
                 }
               },
               gateways: %{
                 ExclusiveGateway_08pnq7v: %Definition.BPMGateway{
                   id: :ExclusiveGateway_08pnq7v,
                   name: nil,
                   type: :exclusiveGateway,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1trdcoy,
                       source: {:task, :Task_0fsoe1r},
                       target: {:gateway, :ExclusiveGateway_08pnq7v}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_0byeq17,
                       source: {:gateway, :ExclusiveGateway_08pnq7v},
                       target: {:task, :Task_0rsgnlx}
                     },
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1eecs6l,
                       source: {:gateway, :ExclusiveGateway_08pnq7v},
                       target: {:task, :Task_1gfqk0h}
                     }
                   ]
                 }
               },
               tasks: %{
                 Task_0fsoe1r: %Definition.BPMTask{
                   id: :Task_0fsoe1r,
                   name: "task 1",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1bqc04t,
                       source: {:event, :StartEvent_1},
                       target: {:task, :Task_0fsoe1r}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1trdcoy,
                       source: {:task, :Task_0fsoe1r},
                       target: {:gateway, :ExclusiveGateway_08pnq7v}
                     }
                   ]
                 },
                 Task_0rsgnlx: %Definition.BPMTask{
                   id: :Task_0rsgnlx,
                   name: "handle success",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_0byeq17,
                       source: {:gateway, :ExclusiveGateway_08pnq7v},
                       target: {:task, :Task_0rsgnlx}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_19mi11y,
                       source: {:task, :Task_0rsgnlx},
                       target: {:event, :EndEvent_019ow9h}
                     }
                   ]
                 },
                 Task_1gfqk0h: %Definition.BPMTask{
                   id: :Task_1gfqk0h,
                   name: "handle failure",
                   type: :task,
                   incoming: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1eecs6l,
                       source: {:gateway, :ExclusiveGateway_08pnq7v},
                       target: {:task, :Task_1gfqk0h}
                     }
                   ],
                   outgoing: [
                     %Definition.BPMSequenceFlow{
                       id: :SequenceFlow_1ahnvqs,
                       source: {:task, :Task_1gfqk0h},
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
