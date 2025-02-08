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
      <.header>
        {@page_title}
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">
            New Incident
          </.link>
        </:actions>
      </.header>
      <.table id="incidents" rows={@streams.incidents}>
        <:col :let={{_dom_id, incident}} label="Name">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.badge status={incident.status} />
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
          {incident.priority}
        </:col>
        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident}/edit"}>
            Edit
          </.link>
        </:action>
      </.table>
    </div>
    """
  end
end
