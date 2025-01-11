defmodule NeighborlyWeb.IncidentLive.Show do
    use NeighborlyWeb, :live_view

    def mount(%{"id" => id}, _session, socket) do

        {:ok, socket}
    end

    def render(assigns) do
        ~H"""
        <div class="incident-show">
            details
        </div>
        """
    end
end
