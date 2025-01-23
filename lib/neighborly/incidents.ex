defmodule Neighborly.Incidents do
  alias Neighborly.Repo
  alias Neighborly.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents do
    Incident
    |> where(status: :resolved)
    |> where([i], ilike(i.name, "%IN%"))
    |> order_by(desc: :name)
    |> Repo.all()
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
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
