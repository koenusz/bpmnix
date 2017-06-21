defmodule BPMGatewayTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMGateway


setup do
  {:ok, process} = BPMProcess.start_link
  {:ok, process: process}
end



  def add2Gateways(process) do
    gateway = %BPMGateway{id: 1, name: "myGateway1"}
    gateway2 = %BPMGateway{id: 2, name: "myGateway2"}

    BPMProcess.addGateway(process, gateway)
    BPMProcess.addGateway(process, gateway2)

  end


test "store a list of gateways", %{process: process} do
  assert BPMProcess.getGateways(process) == %{}
  add2Gateways(process)
  gateways = BPMProcess.getGateways(process)

   Map.keys(gateways)
      |> length
      |> (fn length -> length == 2  end).()
      |> assert
end


test "get gateway by id", %{process: process} do

  add2Gateways(process)
  assert BPMProcess.getGatewayById(process, 1).name == "myGateway1"

end

test "delete gateway", %{process: process} do

  add2Gateways(process)

  gatewaysBefore = BPMProcess.getGateways(process)
  BPMProcess.deleteGateway(process, gatewaysBefore[1].id)
  gatewaysAfter = BPMProcess.getGateways(process)

  Map.keys(gatewaysAfter)
     |> length
     |> (fn length -> length == 1  end).()
     |> assert
end

test "update gateway" , %{process: process} do

  add2Gateways(process)

  gatewaysBefore = BPMProcess.getGateways(process)
  BPMProcess.deleteGateway(process, gatewaysBefore[1].id)
  updated = %{gatewaysBefore[1] | name: "this is updated"}
  BPMProcess.updateGateway(process, updated)
  gatewaysAfter = BPMProcess.getGateways(process)
  assert gatewaysAfter[1].name == "this is updated"

end

end
