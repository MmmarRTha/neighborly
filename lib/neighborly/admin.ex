defmodule Neighborly.Admin do
  alias Neighborly.Repo
  alias Neighborly.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end
end
