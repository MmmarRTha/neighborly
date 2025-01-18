defmodule NeighborlyWeb.IncidentLive.Show do
  use NeighborlyWeb, :live_view

  alias Neighborly.Incidents
  import NeighborlyWeb.CustomComponets

  def mount(%{"id" => id}, _session, socket) do
    incident = Incidents.get_incident(id)

    socket =
      socket
      |> assign(:incident, incident)
      |> assign(:page_title, incident.name)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <div class="... text-lime-600 border-lime-600">
            <.badge status={@incident.status} />
          </div>
          <header>
            <h2>{@incident.name}</h2>
            <div class="priority">
              {@incident.priority}
            </div>
          </header>
          <div class="description">
            {@incident.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <%!-- render urgent incidents here --%>
        </div>
      </div>
    </div>
    """
  end
end
