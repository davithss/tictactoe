defmodule StateTest do
  use ExUnit.Case
  doctest Client
  alias Client.State

  describe "starting new state" do
    test "new_state without ui" do
      assert {:ok, %State{}} = State.new
    end

    test "new_state with ui" do
      ui = &Client.Prompter.handle/2
      assert {:ok, %State{ui: ui}} = State.new(ui: ui)
    end
  end

  describe "checking the event states" do
    test "when choose player is valid" do
      state = %State{status: :initializing}
      {:ok, player} = State.event(state, {:choose_player, :x})
      assert player.status == :playing
      assert player.turn == :x
    end

    test "when choose player is invalid" do
      state = %State{status: :playing}
      assert {:error, :invalid_player} = State.event(state, {:play, :xz})
    end

    test "play when is your turn" do
      state = %State{status: :playing, turn: :x}
      {:ok, other_player} = State.event(state, {:play, :x})
      assert other_player.turn == :o
    end

    test "play out of turn" do
      state = %State{status: :playing}
      assert {:error, :out_of_turn} = State.event(state, {:play, :x})
    end

    test "checking winner" do
      state = %State{status: :playing}
      {:ok, check} = State.event(state, {:check_winner, :x})
      assert check.winner == :x
      assert check.status == :game_over
    end

    test "checking when the game was tie" do
      state = %State{status: :game_over, winner: :tie}
      {:ok, check} = State.event(state, {:game_over?, :game_over})
      assert check.status == :game_over
      assert check.winner == :tie
    end

    test "checking if the game is not over" do
      state = %State{status: :playing}
      {:ok, check} = State.event(state, {:game_over?, :not_over})
      assert check.status == :playing
    end

    test "invalid game over statuses" do
      state = %State{status: :playing}
      assert {:error, :invalid_game_over_statuse} = State.event(state, {:game_over?, nil})
    end

    test "checking other player" do
      assert State.other_player(:x) == :o
    end
  end
end
