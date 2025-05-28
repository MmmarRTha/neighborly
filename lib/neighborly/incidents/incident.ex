defmodule Neighborly.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incidents" do
    field :name, :string
    field :priority, :integer, default: 1
    field :status, Ecto.Enum, values: [:pending, :resolved, :canceled], default: :pending
    field :description, :string
    field :image_path, :string, default: "/images/placeholder.jpg"

    belongs_to :category, Neighborly.Categories.Category
    has_many :responses, Neighborly.Responses.Response
    belongs_to :heroic_response, Neighborly.Responses.Response

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [
      :name,
      :description,
      :priority,
      :status,
      :image_path,
      :category_id,
      :heroic_response_id
    ])
    |> validate_required([:name, :description, :priority, :status, :image_path, :category_id])
    |> validate_length(:description, min: 10)
    |> validate_number(:priority,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 3,
      message: "must be between 1 and 3"
    )
    |> assoc_constraint(:category)
  end
end
