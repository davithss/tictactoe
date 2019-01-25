defmodule Tictac.Server do
  alias Tictac.Game
  use GenServer

  # create new process
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  # return a new game
  def init(_) do
    {:ok, Game.new_game}
  end

  def handle_call({:play_at, board, col, row, player}, _from, _) do
    {game, state} = Game.play_at(board, col, row, player)
    {:reply, state, game}
  end
end
