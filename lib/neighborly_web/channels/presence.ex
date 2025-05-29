defmodule NeighborlyWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :neighborly,
    pubsub_server: Neighborly.PubSub

  def track_user(id, current_user) do
    {:ok, _} =
      track(self(), topic(id), current_user.username, %{
        online_at: System.system_time(:second)
      })
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(Neighborly.PubSub, "updates:" <> topic(id))
  end

  def list_users(id) do
    list(topic(id))
    |> Enum.map(fn {username, %{metas: metas}} ->
      %{id: username, metas: metas}
    end)
  end

  defp topic(incident_id) do
    "incident_onlookers:#{incident_id}"
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    for {username, _presence} <- joins do
      presence = %{id: username, metas: Map.fetch!(presences, username)}

      msg = {:user_joined, presence}

      Phoenix.PubSub.local_broadcast(Neighborly.PubSub, "updates:" <> topic, msg)
    end

    for {username, _presence} <- leaves do
      metas =
        case Map.fetch(presences, username) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      presence = %{id: username, metas: metas}

      msg = {:user_left, presence}

      Phoenix.PubSub.local_broadcast(Neighborly.PubSub, "updates:" <> topic, msg)
    end

    {:ok, state}
  end
end
