defmodule NeighborlyWeb.Api.CategoryJSON do
  def show(%{category: category}) do
    %{
      category: %{
        id: category.id,
        name: category.name,
        slug: category.slug
      }
    }
  end
end
