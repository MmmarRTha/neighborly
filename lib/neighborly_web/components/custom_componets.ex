defmodule NeighborlyWeb.CustomComponets do
  use NeighborlyWeb, :html

  attr :status, :atom, required: true, values: [:pending, :resolved, :canceled]

  def badge(assigns) do
    ~H"""
    <div class={[
      "inline-block px-3 py-1 text-xs font-medium uppercase rounded-xl text-white",
      @status == :resolved && "bg-lime-600",
      @status == :pending && "bg-amber-600",
      @status == :canceled && "bg-gray-600"
    ]}>
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :tagline

  def headline(assigns) do
    assigns = assign(assigns, :emoji, ~w(😎 🤩 🥳) |> Enum.random())

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={tagline <- @tagline} class="tagline">
        {render_slot(tagline, @emoji)}
      </div>
    </div>
    """
  end
end
