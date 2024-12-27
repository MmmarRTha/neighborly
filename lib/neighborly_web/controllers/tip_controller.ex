defmodule NeighborlyWeb.TipController do
  use NeighborlyWeb, :controller

  alias Neighborly.Tips

  def index(conn, _params) do
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)

    tips = Tips.list_tips()

    render(conn, :index, emojis: emojis, tips: tips)
  end
end
