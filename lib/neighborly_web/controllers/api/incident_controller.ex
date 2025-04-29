defmodule NeighborlyWeb.Api.IncidentController do
  use NeighborlyWeb, :controller

  alias Neighborly.Admin

  def index(conn, _params) do
    incidents = Admin.list_incidents()

    render(conn, :index, incidents: incidents)
  end

  def show(conn, %{"id" => id}) do
    incident = Admin.get_incident!(id)

    render(conn, :show, incident: incident)
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: NeighborlyWeb.ErrorJSON)
      |> render(:"404")
  end
end
