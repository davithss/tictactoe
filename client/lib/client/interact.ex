defmodule Client.Interact do
  alias Tictac.Game
  alias Client.State

  def start(ui) do
    new_game()
    with {:ok, game} <- State.new(ui),
         player      <- ui.(game, :get_player),
         {:ok, game} <- State.event(game, {:choose_player, player}),
    do: handle(game), else: (error -> error)
  end

  def handle(%{status: :playing} = game) do
    player = game.turn
    with {col, row}   <- game.ui.(game, :make_move),
         {:ok, board} <- Game.play_at(game.board, col, row, game.turn),
         {:ok, game}  <- State.event(%{game | board: board}, {:play, game.turn}),
         won?         <- Game.win_check(board, player),
         {:ok, game}  <- State.event(game, {:check_winner, won?}),
         over?        <- Game.game_over?(game),
         {:ok, game}  <- State.event(game, {:game_over?, over?}),
    do: handle(game), else: (error -> error)
  end

  def handle(%{status: :game_over} = game) do
    game.ui.(game, nil)
  end

  def new_game() do
    Node.connect(:"tictac@#{get_hostname}")
    :rpc.call(:"tictac@#{get_hostname}",
      Tictac,
      :new_game,
      [])
  end

  def get_hostname() do
    {:ok, hostname} = :inet.gethostname
    hostname
  end
end
