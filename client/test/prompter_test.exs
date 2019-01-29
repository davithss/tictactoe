defmodule PrompterTest do
  use ExUnit.Case, async: true
  import Mimic

  alias Client.{Prompter, State}

  describe "handle states" do
    #MOCK IO.gets
    test "get_player" do
      #MFA
      #IO => module, :GETS => FUNCTION, FN => ARGS
      expect(IO, :gets, 1, fn _ -> "x" end)
      assert Prompter.handle(%State{status: :initializing}, :get_player) == :x
    end

    test "when is playing" do
      expect(IO, :gets, fn _ -> "1" end)
      expect(IO, :gets, fn _ -> "2" end)
      assert Prompter.handle(%State{status: :playing}, :make_move) == {1, 2}
    end

    test "when game is done" do
      assert Prompter.handle(%State{status: :game_over, winner: :x}, :game_over) == "Player x, you won!!!"
    end
  end
end
