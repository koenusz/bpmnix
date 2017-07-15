defmodule BPMGatewayTest do
  use ExUnit.Case, async: true

alias Definition.BPMProcess
alias Definition.BPMGateway


setup do
  {:ok, process} = BPMProcess.start_link
  {:ok, process: process}
end



  def add_2_gateways(process) do
    gateway = %BPMGateway{id: 1, name: "myGateway1"}
    gateway2 = %BPMGateway{id: 2, name: "myGateway2"}

    BPMProcess.add_gateway(process, gateway)
    BPMProcess.add_gateway(process, gateway2)

  end


test "store a list of gateways", %{process: process} do
  assert BPMProcess.get_gateways(process) == %{}
  add_2_gateways(process)
  gateways = BPMProcess.get_gateways(process)

   Map.keys(gateways)
      |> length
      |> (fn length -> length == 2  end).()
      |> assert
end


test "get gateway by id", %{process: process} do

  add_2_gateways(process)
  assert BPMProcess.get_gateway_by_id(process, 1).name == "myGateway1"

end

test "delete gateway", %{process: process} do

  add_2_gateways(process)

  gateways_before = BPMProcess.get_gateways(process)
  BPMProcess.delete_gateway(process, gateways_before[1].id)
  gatewaysAfter = BPMProcess.get_gateways(process)

  Map.keys(gatewaysAfter)
     |> length
     |> (fn length -> length == 1  end).()
     |> assert
end

test "update gateway" , %{process: process} do

  add_2_gateways(process)

  gateways_before = BPMProcess.get_gateways(process)
  BPMProcess.delete_gateway(process, gateways_before[1].id)
  updated = %{gateways_before[1] | name: "this is updated"}
  BPMProcess.update_gateway(process, updated)
  gatewaysAfter = BPMProcess.get_gateways(process)
  assert gatewaysAfter[1].name == "this is updated"

end

end
