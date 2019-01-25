defmodule Client.State do
  alias Tictac.Game
  alias Client.State

  @players [:x, :o]

  defstruct(
    status: :initializing,
    turn: nil,
    winner: nil,
    board: Game.new_board(),
    ui: nil,
  )

  def new(), do: {:ok, %State{}}
  def new(ui), do: {:ok, %State{ui: ui}}

  def event(%State{status: :initializing} = state, {:choose_player, player}) do
    case Game.check_player(player) do
      {:ok, player} -> {:ok, %State{state | status: :playing, turn: player}}
      _ -> {:error, :invalid_player}
    end
  end

  def event(%State{status: :playing}, {:play, player}) when player not in @players do
    {:error, :invalid_player}
  end

  def event(%State{status: :playing, turn: player} = state, {:play, player}) do
    {:ok, %State{state | turn: other_player(player)}}
  end

  def event(%State{status: :playing}, {:play, _}), do: {:error, :out_of_turn}

  def event(%State{status: :playing} = state, {:check_winner, winner}) do
    win_state = %State{state | status: :game_over, turn: nil, winner: winner}
    case winner do
      :x -> {:ok, win_state}
      :o -> {:ok, win_state}
      _  -> {:ok, state}
    end
  end

  def event(%State{status: :playing} = state, {:game_over?, :not_over}), do: {:ok, state}

  def event(%State{status: :playing} = state, {:game_over?, :game_over}),
    do: {:ok, %State{state | status: :game_over, winner: :tie}}

  def event(%State{status: :playing}, {:game_over?, _}), do: {:error, :invalid_game_over_statuse}
  def event(%State{status: :game_over} = state, {:game_over?, _}), do: {:ok, state}

  def event(state, action) do
    {:error, {:invalid_state_transition, %{status: state.status, action: action}}}
  end

  def other_player(:o), do: :x
  def other_player(:x), do: :o
  def other_player(_), do: :invalid_player
end
