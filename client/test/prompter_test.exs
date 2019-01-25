defmodule PrompterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Client.{Prompter, State}

  test "start play" do
    # {:ok, prompter} = Client.Prompter.play
  end

  describe "handle states" do
    #TODO How to test IO gets
    test "get_player" do
    end

    test "when is playing" do
    end

    test "when was game over" do
    end
  end
end
