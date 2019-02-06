defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck_length = length(Cards.create_deck())
    assert deck_length == 20
  end

  test "shuffling a deck randomizes it" do
    deck = Cards.create_deck()
    refute deck == Cards.shuffle(deck)
  end

  test "create_hand splits deck into hand and remaining" do
    hand_size = 5
    {hand, _remaining} = Cards.create_hand(hand_size)
    assert length(hand) == hand_size
  end

end
