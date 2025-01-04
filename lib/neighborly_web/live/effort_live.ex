defmodule NeighborlyWeb.EffortLive do
  use NeighborlyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, responders: 2, minutes_per_responder: 10)
    {:ok, socket}
  end

  # render de liveview current state
  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
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
    </div>
    """
  end
end
