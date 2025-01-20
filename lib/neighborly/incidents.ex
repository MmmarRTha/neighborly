defmodule Neighborly.Incidents do
  alias Neighborly.Repo
  alias Neighborly.Incidents.Incident

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(incident) do
    list_incidents() |> List.delete(incident)
  end
end
