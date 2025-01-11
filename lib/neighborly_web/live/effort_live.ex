defmodule NeighborlyWeb.EffortLive do
  use NeighborlyWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket = assign(socket, responders: 0, minutes_per_responder: 10, page_title: "Effort")
    {:ok, socket}
  end

  # render de liveview current state
  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>

      <section>
        <button phx-click="add" phx-value-quantity="1">
          +
        </button>
        <div>
          {@responders}
        </div>
        &times
        <div>
          {@minutes_per_responder}
        </div>
        =
        <div>
          {@responders * @minutes_per_responder}
        </div>
      </section>

      <form phx-submit="recalculate">
        <label for="">Minutes Per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    # responders = socket.assigns.responders + 1
    # socket = assign(socket, :responders, responders)

    socket = update(socket, :responders, &(&1 + String.to_integer(quantity)))
    {:noreply, socket}
  end

  def handle_event("recalculate", %{"minutes" => minutes_per_responder}, socket) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes_per_responder))
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :responders, &(&1 + 10))}
  end
end
