# Load another ".iex.exs" file
import_file "~/.iex.exs"

# Print something before the shell starts
IO.puts "Importing support modules"

# Import some module from lib that may not yet have been defined
import_if_available Support.ProcessDefinition