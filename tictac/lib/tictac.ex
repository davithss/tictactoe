defmodule Tictac do
  alias Tictac.Game

  def new_game() do
    pid = Supervisor.start_child(Tictacs.Supervisor, [])
    pid
  end

  def play_at(game_pid, board, col, row, player) do
    GenServer.call(game_pid, { :play_at, board, col, row, player })
  end
end
