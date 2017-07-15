defmodule BPMEventTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMEvent


setup do
  {:ok, process} = BPMProcess.start_link
  {:ok, process: process}
end



  def add_2_events(process) do
    event = %BPMEvent{id: 1, name: "myEvent1"}
    event2 = %BPMEvent{id: 2, name: "myEvent2"}

    BPMProcess.add_event(process, event)
    BPMProcess.add_event(process, event2)

  end


test "store a list of events", %{process: process} do
  assert BPMProcess.get_events(process) == %{}
  add_2_events(process)
  events = BPMProcess.get_events(process)
   Map.keys(events)
      |> length
      |> (fn length -> length == 2  end).()
      |> assert
end


test "get event by id", %{process: process} do

  add_2_events(process)
  assert BPMProcess.get_event_by_Id(process, 1).name == "myEvent1"

end

test "delete event", %{process: process} do

  add_2_events(process)

  events_before = BPMProcess.get_events(process)
  BPMProcess.delete_event(process, events_before[1].id)

  eventsAfter = BPMProcess.get_events(process)

  Map.keys(eventsAfter)
     |> length
     |> (fn length -> length == 1  end).()
     |> assert
end

test "update event" , %{process: process} do

  add_2_events(process)

  events_before = BPMProcess.get_events(process)
  BPMProcess.delete_event(process, events_before[1].id)

  updated = %{events_before[1] | name: "this is updated"}

  BPMProcess.updateEvent(process, updated)

  eventsAfter = BPMProcess.get_events(process)

  assert eventsAfter[1].name == "this is updated"


end

end
