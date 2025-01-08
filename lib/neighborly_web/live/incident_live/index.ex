defmodule NeighborlyWeb.IncidentLive.Index do
  use NeighborlyWeb, :live_view

  alias Neighborly.Incidents

  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident}/>
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

  attr :status, :atom, required: true, values: [:pending, :resolved, :canceled]
  def badge(assigns) do
    ~H"""
    <div class="inline-block px-2 py-1 text-xs font-medium uppercase border rounded-md text-lime-600 border-lime-600">
      {@status}
    </div>
    """
  end
end
