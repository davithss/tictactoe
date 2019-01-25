defmodule GameTest do
  use ExUnit.Case
  alias Tictac.Game

  describe "when create a new game" do
    test "without col and row" do
      {:ok, game} = Game.new_game
      assert game.col == nil
      assert game.row == nil
    end

    test "with col and row" do
      {:ok, game} = Game.new_game(1, 1)
      assert game.col == 1
      assert game.row == 1
    end

    test "with invalid col and row" do
      assert {:error, :invalid_game} = Game.new_game("x12", "y23")
    end
  end

  describe "when start playing" do
    setup do
      board = Game.new_board
      %{board: board, player: :x}
    end

    test "play at returns the board and player position", %{board: board} do
      {:ok, board} = Game.play_at(board, 1, 1, :x)
      %{%Game{col: 1, row: 1} => player} = board
      assert player == :x
    end

    test "play at returning an error", %{board: board} do
      assert {:error, :invalid_player} = Game.play_at(board, 4, 4, :z)
    end

    test "when place piece is invalid", %{board: board} do
      {:ok, game} = Game.new_game
      assert {:error, :invalid_location} = Game.place_piece(board, game, :x)
    end

    test "when place piece is occupied", %{board: board} do
      {:ok, game} = Game.new_game(1,1)
      assert {:ok, add_place} = Game.place_piece(board, game, :x)
      assert {:error, :occupied} = Game.place_piece(add_place, game, :o)
    end

    test "when check player is valid", %{player: player} do
      check_player = Game.check_player(player)
      assert check_player == {:ok, player}
    end

    test "when check player is invalid" do
      player = :xz
      assert {:error, :invalid_player} = Game.check_player(player)
    end
  end

  describe "checking if has winner or game over" do
    setup do
      board = Game.new_board
      %{board: board}
    end

    test "when has a winner", %{board: board} do
      board = Map.put(board, %Game{col: 1, row: 1}, :x)
      board = Map.put(board, %Game{col: 1, row: 2}, :o)
      board = Map.put(board, %Game{col: 1, row: 3}, :x)
      board = Map.put(board, %Game{col: 2, row: 1}, :o)
      board = Map.put(board, %Game{col: 2, row: 2}, :x)
      board = Map.put(board, %Game{col: 2, row: 3}, :o)
      board = Map.put(board, %Game{col: 3, row: 1}, :x)
      board = Map.put(board, %Game{col: 3, row: 2}, :o)
      board = Map.put(board, %Game{col: 3, row: 3}, :x)

      winner = Game.win_check(board, :x)
      assert winner == :x
    end

    test "when game is over" do
      board = for s <- Game.squares(), into: %{}, do: {s, Enum.random([:x, :o])}
      game_over = Game.game_over?(%{board: board})
      assert game_over == :game_over
    end

    test "when game is not over", %{board: board} do
      game_over = Game.game_over?(%{board: board, winner: nil})
      assert game_over == :not_over
    end
  end
end
