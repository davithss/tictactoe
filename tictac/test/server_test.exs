defmodule ServerTest do
  use ExUnit.Case
  alias Tictac.Server

  describe "starting the process" do
    test "start_link" do
      assert {:ok, pid} = Server.start_link
    end
  end
end
