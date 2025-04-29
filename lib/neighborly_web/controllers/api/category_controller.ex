defmodule NeighborlyWeb.Api.CategoryController do
  use NeighborlyWeb, :controller

  alias Neighborly.Categories

  def show(conn, %{"id" => id}) do
    category = Categories.get_category_with_incidents!(id)

    render(conn, :show, category: category)
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: NeighborlyWeb.ErrorJSON)
      |> render(:"404")
  end
end
