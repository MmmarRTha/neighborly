defmodule Neighborly.Incidents do
  alias Neighborly.Repo
  alias Neighborly.Incidents.Incident
  import Ecto.Query

  def subscribe(incident_id) do
    Phoenix.PubSub.subscribe(Neighborly.PubSub, "incident:#{incident_id}")
  end

  def broadcast(incident_id, message) do
    Phoenix.PubSub.broadcast(Neighborly.PubSub, "incident:#{incident_id}", message)
  end

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

    query
    |> join(:inner, [i], c in assoc(i, :category))
    |> where([i, c], c.slug == ^slug)
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort(query, "name"), do: order_by(query, :name)
  defp sort(query, "priority_desc"), do: order_by(query, desc: :priority)
  defp sort(query, "priority_asc"), do: order_by(query, asc: :priority)

  defp sort(query, "category") do
    query
    |> join(:inner, [i], c in assoc(i, :category))
    |> order_by([i, c], asc: c.name)
  end

  defp sort(query, _), do: order_by(query, :id)

  def get_incident!(id) do
    Repo.get!(Incident, id)
    |> Repo.preload([:category, heroic_response: :user])
  end

  def list_responses(incident) do
    incident
    |> Ecto.assoc(:responses)
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
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
