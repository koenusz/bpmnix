# see https://virviil.github.io/2016/10/26/Elixir-Testing-without-starting-supervision-tree.html
# this starts all the dependencies of the application
# for app <- Application.spec(:bpmnix,:applications) do #(1)
#   Application.ensure_all_started(app)
# end

ExUnit.start(colors: [enabled: true])
