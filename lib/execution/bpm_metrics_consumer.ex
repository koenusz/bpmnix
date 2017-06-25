defmodule Execution.BPMMetricsConsumer do

@moduledoc """
    Provides a behaviour for metrics consumers to implement. 

"""

  @callback consume(Keyword.t) :: nil

end
