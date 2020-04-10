defmodule Platform.Cards do
  alias Platform.Cards.WhiteCard

  def list_white_cards do
    File.read!("priv/cards/white.json")
    |> Jason.decode!
    |> Enum.with_index(1)
    |> Enum.map(fn {card, index} -> %WhiteCard{
      id: index,
      answer: card
    } end)
  end
end
