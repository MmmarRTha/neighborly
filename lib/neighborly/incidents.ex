defmodule Neighborly.Incidents do
  alias Neighborly.Repo
  alias Neighborly.Incidents.Incident
  alias Neighborly.Categories.Category
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> with_category(filter["category"])
    |> sort(filter["sort_by"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_category(query, slug) when slug in ["", nil], do: query

  defp with_category(query, slug) do
    # from i in query,
      # join: c in Category,
      # on: i.category_id == c.id,
      # where: c.slug == ^slug

      from i in query,
      join: c in assoc(i, :category),
      where: c.slug == ^slug
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort(query, sort_by) do
    order_by(query, ^sort_option(sort_by))
  end

  defp sort_option("name"), do: :name
  defp sort_option("priority_desc"), do: [desc: :priority]
  defp sort_option("priority_asc"), do: [asc: :priority]
  defp sort_option(_), do: :id

  def get_incident!(id) do
    Repo.get!(Incident, id)
    |> Repo.preload(:category)
  end

  def urgent_incidents(incident) do
    # list_incidents() |> List.delete(incident)
    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(:priority)
    |> limit(3)
    |> Repo.all()
  end

  def status_options do
    Ecto.Enum.values(Incident, :status)
  end
end
