defmodule NeighborlyWeb.IncidentLive.Index do
  use NeighborlyWeb, :live_view

  alias Neighborly.Incidents
  alias Neighborly.Categories
  import NeighborlyWeb.CustomComponets

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :category_options, Categories.category_names_and_slugs())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)
      |> assign(:page_title, "Incidents")
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </.headline>

      <.filter_form form={@form} category_options={@category_options} />

      <div class="incidents" id="incidents" phx-update="stream">
        <div id="empty" class="hidden no-results only:block">
          No incidents found. Try changing your filters.
        </div>
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  attr :form, :map
  attr :category_options, :map

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="500" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={Incidents.status_options()}
      />

      <.input type="select" field={@form[:category]} prompt="Category" options={@category_options} />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[
          Name: "name",
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc",
          Category: "category"
        ]}
      />

      <.link patch={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :incident, Neighborly.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident}"} id={@id}>
      <div class="card">
        <div class="category">
          {@incident.category.name}
        </div>
        <img src={@incident.image_path} alt="image" />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by category))
      |> Map.reject(fn {_, value} -> value == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
