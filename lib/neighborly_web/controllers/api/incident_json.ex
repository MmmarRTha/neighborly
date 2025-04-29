defmodule NeighborlyWeb.Api.IncidentJSON do
  def index(%{incidents: incidents}) do
    %{incidents: for(incident <- incidents, do: data(incident))}
  end

  def show(%{incident: incident}) do
    %{incident: data(incident)}
  end

  defp data(incident) do
    %{
      id: incident.id,
      name: incident.name,
      description: incident.description,
      priority: incident.priority,
      status: incident.status,
      category_id: incident.category_id
    }
  end
end
