defmodule Client do
  defdelegate play(), to: Client.Prompter
end
