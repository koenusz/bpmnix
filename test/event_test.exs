defmodule BPMEventTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMEvent


setup do
  {:ok, process} = BPMProcess.start_link
  {:ok, process: process}
end



  def add2Events(process) do
    event = %BPMEvent{id: 1, name: "myEvent1"}
    event2 = %BPMEvent{id: 2, name: "myEvent2"}

    BPMProcess.addEvent(process, event)
    BPMProcess.addEvent(process, event2)

  end


test "store a list of events", %{process: process} do
  assert BPMProcess.getEvents(process) == %{}
  add2Events(process)
  events = BPMProcess.getEvents(process)
   Map.keys(events)
      |> length
      |> (fn length -> length == 2  end).()
      |> assert
end


test "get event by id", %{process: process} do

  add2Events(process)
  assert BPMProcess.getEventById(process, 1).name == "myEvent1"

end

test "delete event", %{process: process} do

  add2Events(process)

  eventsBefore = BPMProcess.getEvents(process)
  BPMProcess.deleteEvent(process, eventsBefore[1].id)

  eventsAfter = BPMProcess.getEvents(process)

  Map.keys(eventsAfter)
     |> length
     |> (fn length -> length == 1  end).()
     |> assert
end

test "update event" , %{process: process} do

  add2Events(process)

  eventsBefore = BPMProcess.getEvents(process)
  BPMProcess.deleteEvent(process, eventsBefore[1].id)

  updated = %{eventsBefore[1] | name: "this is updated"}

  BPMProcess.updateEvent(process, updated)

  eventsAfter = BPMProcess.getEvents(process)

  assert eventsAfter[1].name == "this is updated"


end

end
