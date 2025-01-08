defmodule NeighborlyWeb.IncidentLive.Index do
  use NeighborlyWeb, :live_view

  alias Neighborly.Incidents
  import NeighborlyWeb.CustomComponets

  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, Neighborly.Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} alt="image" />
      <h2>{@incident.name}</h2>
      <div class="details">
        <.badge status={@incident.status} />
        <div class="priority">
          {@incident.priority}
        </div>
      </div>
    </div>
    """
  end
end
