defmodule NeighborlyWeb.AdminIncidentLive.Index do
  alias Neighborly.Admin
  use NeighborlyWeb, :live_view
  import NeighborlyWeb.CustomComponets

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
          time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div class="hidden joke" id="joke">
        What's a tree's favorite drink?
      </div>
      <.header>
        {@page_title}
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            New Incident
          </.link>
        </:actions>
      </.header>

      <div class="p-4 mt-4 bg-white rounded-xl overscroll-auto">
        <.table
          id="incidents"
          rows={@streams.incidents}
          row_click={fn {_, incident} -> JS.navigate(~p"/incidents/#{incident}") end}
        >
          <:col :let={{_dom_id, incident}} label="Name">
            <.link navigate={~p"/incidents/#{incident}"} class="text-zinc-900 hover:text-zinc-600">
              {incident.name}
            </.link>
          </:col>
          <:col :let={{_dom_id, incident}} label="Status">
            <.badge status={incident.status} />
          </:col>
          <:col :let={{_dom_id, incident}} label="Priority">
            <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-md bg-zinc-50 text-zinc-600 ring-1 ring-inset ring-zinc-500/10">
              {incident.priority}
            </span>
          </:col>
          <:col :let={{_dom_id, incident}} label="Response#">
            {incident.heroic_response_id}
          </:col>
          <:action :let={{_dom_id, incident}}>
            <.link
              navigate={~p"/admin/incidents/#{incident}/edit"}
              class="inline-flex items-center px-3 py-2 m-0 text-sm font-medium transition-colors duration-200 rounded-md hover:bg-white"
            >
              <.icon name="hero-pencil-square" class="w-4 h-4 mr-1" />
              <span class="hidden sm:inline">Edit</span>
            </.link>
          </:action>
          <:action :let={{dom_id, incident}}>
            <.link
              phx-click={delete_and_hide(dom_id, incident)}
              data-confirm="Do you want to delete it?"
              class="inline-flex items-center px-3 py-2 m-0 text-sm font-medium transition-colors duration-200 rounded-md hover:bg-red-50"
            >
              <.icon name="hero-trash" class="w-4 h-4 mr-1" />
              <span class="hidden sm:inline">Delete</span>
            </.link>
          </:action>
          <:action :let={{_dom_id, incident}}>
            <.link
              phx-click="draw-response"
              phx-value-id={incident.id}
              class="inline-flex items-center px-3 py-2 m-0 text-sm font-medium transition-colors duration-200 rounded-md hover:bg-green-50"
            >
              <.icon name="hero-sparkles" class="w-4 h-4 mr-1" />
              <span class="hidden sm:inline">Draw Response</span>
            </.link>
          </:action>
        </.table>
      </div>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)

    {:noreply, stream_delete(socket, :incidents, incident)}
  end

  def handle_event("draw-response", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)

    case Admin.draw_heroic_response(incident) do
      {:ok, incident} ->
        socket =
          socket
          |> put_flash(:info, "Heroic response drawn!")
          |> stream_insert(:incidents, incident)

        {:noreply, socket}

      {:error, error} ->
        {:noreply, put_flash(socket, :error, error)}
    end
  end

  def delete_and_hide(dom_id, incident) do
    JS.push("delete", value: %{id: incident.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
