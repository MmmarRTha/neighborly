defmodule NeighborlyWeb.IncidentLive.Show do
  use NeighborlyWeb, :live_view

  alias Neighborly.Incidents
  import NeighborlyWeb.CustomComponets

  def mount(_params, _session, socket) do
    socket = assign(socket, :form, to_form(%{}))
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident!(id)

    socket =
      socket
      |> assign(:incident, incident)
      |> assign(:page_title, incident.name)
      # |> assign(:urgent_incidents, Incidents.urgent_incidents(incident))
      |> assign_async(:urgent_incidents, fn ->
        {:ok, %{urgent_incidents: Incidents.urgent_incidents(incident)}}
      end)

    {:noreply, socket}
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
            <div>
              <h2>{@incident.name}</h2>
              <h3>{@incident.category.name}</h3>
            </div>
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
        <div class="left">
          <%= if @current_user do %>
            <.form for={@form} id="response-form">
              <.input
                field={@form[:status]}
                type="select"
                prompt="Choose a status"
                options={[:enroute, :arrived, :departed]}
              />

              <.input field={@form[:note]} type="textarea" placeholder="Note..." autofocus />
            </.form>
          <% end %>
        </div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
      <.back navigate={~p"/incidents"}>All Incidents</.back>
    </div>
    """
  end

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <.async_result :let={result} assign={@incidents}>
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed">
            {reason}
          </div>
        </:failed>
        <ul class="incidents">
          <li :for={incident <- result}>
            <.link navigate={~p"/incidents/#{incident}"}>
              <img src={incident.image_path} />
            </.link>
            {incident.name}
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end
end
