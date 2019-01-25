defmodule TictacTest do
  use ExUnit.Case
  doctest Tictac
  alias Tictac.Game

  describe "starting play game with Supervisor" do
    test "new game" do
      assert {:ok, pid} = Tictac.new_game
    end

    test "play at using game_pid" do
      {:ok, pid} = Tictac.new_game
      board = Game.new_board
      game = Tictac.play_at(pid, board, 1, 1, :x)
      %{%Game{col: 1, row: 1} => player} = game
      assert player == :x
    end
  end
end
