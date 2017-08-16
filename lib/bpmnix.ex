defmodule BPMnix do

  @moduledoc """
  This module provides the main entrypoint for the BPM Application.

  It is a bit unfortunate that the bpm terminology also contains the word process. Within an elixir environment
  this can become confusing. Therefore as a matter of convention within this application,
  every beam process is referred to as 'process' and every bpm process is referred to as 'BPMProcess'.
  """
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications


  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
#    children = []


    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    ProcessInstanceSupervisor.start_link
  end


end
