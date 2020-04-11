defmodule Platform.GameLive do
  use Phoenix.LiveView
  alias Platform.Games
  alias Platform.Games.GameServer

  def render(assigns), do: PlatformWeb.GameView.render("show.html", assigns)

  def mount(params, %{"game_id" => game_id, "current_player_id" => current_player_id, "current_player_name" => current_player_name}, socket) do
    players_visible = false

    IO.inspect game_id
    IO.inspect current_player_id

    #{:ok, _pid} =
    #  DynamicSupervisor.start_child(Platform.GameSupervisor, {GameServer, name: GameServer.via_tuple(game_id)})

    game =
      Games.new()
      |> Games.add_player(current_player_id, current_player_name)

    current_player = Games.current_player(socket, game)

    {:ok,
     assign(socket, %{
       game: game,
       current_player: current_player,
       players_visible: players_visible
     })}
  end

  def handle_event("start_round", %{}, socket) do
    new_game =
      socket.assigns.game
      |> Games.start_round()

    {:noreply, assign(socket, %{game: new_game})}
  end

  def handle_event("toggle_players_visible", %{}, socket) do
    players_visible = !socket.assigns.players_visible

    {:noreply, assign(socket, %{players_visible: players_visible})}
  end

  def handle_event("reset_white_cards", %{}, socket) do
    new_game =
      socket.assigns.game
      |> Games.player_reset_white_cards(socket.assigns.current_player)

    {:noreply, assign(socket, %{game: new_game})}
  end

  def handle_event("select_card", %{"card-id" => card_id}, socket) do
    new_game =
      socket.assigns.game
      |> Games.select_white_card(socket.assigns.current_player, String.to_integer(card_id))

    current_player = Games.current_player(socket, new_game)

    {:noreply, assign(socket, %{game: new_game, current_player: current_player})}
  end
end
