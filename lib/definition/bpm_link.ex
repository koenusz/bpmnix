defprotocol Definition.BPMLink do



  def link(source, target, linkId)
end

defimpl Definition.BPMLink, for: [Definition.BPMTask, Definition.BPMEvent, Definition.BPMGateway] do
  def link(source, target, linkId) do

    sequence_flow = %Definition.BPMSequenceFlow{
      id: linkId,
      source: get_identity(source),
      target: get_identity(target)
    }
    {
      %{source | outgoing: source.outgoing ++ [sequence_flow]},
      %{target | incoming: target.incoming ++ [sequence_flow]}
    }
  end

  defp get_identity(%Definition.BPMTask{} = step)  do
    {:task, step.id}
  end

  defp get_identity(%Definition.BPMEvent{} = step)  do
    {:event, step.id}
  end

  defp get_identity(%Definition.BPMGateway{} = step)  do
    {:gateway, step.id}
  end
end
