defmodule Client.Prompter do
  alias Client.{Prompter, State, Interact}

  def play() do
    Interact.start(&Prompter.handle/2)
  end

  def handle(%State{status: :initializing}, :get_player) do
    IO.gets("What's gonna be your player x or o ?")
      |> String.trim
      |> String.to_atom
  end

  def handle(%State{status: :playing} = state, :make_move) do
    display_board(state.board)
    IO.puts("Hey #{state.turn}, What's your next move?")
    col = IO.gets("Col: ") |> String.trim |> String.to_integer
    row = IO.gets("Row: ") |> String.trim |> String.to_integer
    {col, row}
  end

  def handle(%State{status: :game_over} = state, _) do
    display_board(state.board)
    case state.winner do
      :tie -> "Tie? Shame of you!"
      _    -> "Player #{state.winner}, you won!!!"
    end
  end

  def show(board, c, r) do
  [item] = for {%{col: col, row: row}, v} <- board,
           col == c, row == r, do: v
  if item == :empty, do: "", else: to_string(item)
  end

  def display_board(board) do
    IO.puts """
      #{show(board,1,1)} | #{show(board,2,1)} | #{show(board,3,1)}
      ________
      #{show(board,1,2)} | #{show(board,2,2)} | #{show(board,3,2)}
      ________
      #{show(board,1,3)} | #{show(board,2,3)} | #{show(board,3,3)}
    """
  end
end
