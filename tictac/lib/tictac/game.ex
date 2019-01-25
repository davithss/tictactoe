defmodule Tictac.Game do
  alias Tictac.Game
  @players [:x, :o]
  @board_limit 1..3

  defstruct [:row, :col]

  def new_game(), do: {:ok, %Game{}}

  def new_game(col, row) when col in @board_limit and row in @board_limit do
    {:ok, %Game{row: row, col: col}}
  end

  def new_game(_col, _row), do: {:error, :invalid_game}

  def play_at(board, col, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, game}         <- new_game(col, row),
         {:ok, new_board}    <- place_piece(board, game, valid_player),
    do: {:ok, new_board}
  end

  def check_player(player) when player in @players do
    {:ok, player}
  end

  def check_player(_player), do: {:error, :invalid_player}

  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  def squares do
    for col <- @board_limit, row <- @board_limit, into: MapSet.new(), do: %Game{col: col, row: row}
  end

  def game_over?(game) do
    board_full = Enum.all?(game.board, fn {_, v} -> v != :empty end)
    if board_full or game.winner do
      :game_over
    else
      :not_over
    end
  end

  def get_col(board, col) do
    for {%{col: c, row: _}, v} <- board, col == c, do: v
  end

  def get_row(board, row) do
    for {%{col: _, row: r}, v} <- board, row == r, do: v
  end

  def get_diagonals(board) do
    [(for {%{col: c, row: r}, v} <- board, c == r, do: v),
     (for {%{col: c, row: r}, v} <- board, c + r == 4, do: v)]
  end

  def place_piece(board, game, player) do
    case board[game] do
      nil -> {:error, :invalid_location}
      :x  -> {:error, :occupied}
      :o  -> {:error, :occupied}
      :empty -> {:ok, %{board | game => player} }
    end
  end

  def win_check(board, player) do
    cols = Enum.map(@board_limit, &get_col(board, &1))
    rows = Enum.map(@board_limit, &get_row(board, &1))
    diagonals = get_diagonals(board)
    win? = Enum.any?(cols++rows++diagonals, &won_line(&1, player))
    if win?, do: player, else: false
  end

  def won_line(line, player), do: Enum.all?(line, &(player == &1))
end
