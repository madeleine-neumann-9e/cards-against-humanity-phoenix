defmodule Platform.Games.Player do
  defstruct [:id, :name, :all_white_cards, :points, :reader, :selected_white_cards]
  alias Platform.Cards

  def new(name) do
    white_cards =
      Cards.list_white_cards()
      |> Enum.take_random(10)

    %__MODULE__{
      id: :rand.uniform(10000),
      name: name,
      all_white_cards: white_cards,
      points: 0,
      selected_white_cards: []
    }
  end
end
