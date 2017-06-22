defprotocol Definition.BPMLink do

# alias Definition.BPMTask


       def link(source, target, linkId)
end

defimpl Definition.BPMLink,  for: [Definition.BPMTask, Definition.BPMEvent, Definition.BPMGateway] do
    def link(source, target, linkId) do

        sequence_flow = %Definition.BPMSequenceFlow{id: linkId, sourceId: source.id, targetId: target.id}
        {%{source | outgoing: source.outgoing ++ [sequence_flow]},
        %{target | incoming: target.incoming ++ [sequence_flow]}}
    end
end
