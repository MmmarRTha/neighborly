defmodule Neighborly.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :status, Ecto.Enum, values: [:enroute, :arrived, :departed]
    field :note, :string
    field :incident_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:note, :status])
    |> validate_required([:note, :status])
  end
end
