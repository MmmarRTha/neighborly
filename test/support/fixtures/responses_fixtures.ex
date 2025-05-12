defmodule Neighborly.ResponsesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Neighborly.Responses` context.
  """

  import Neighborly.AccountsFixtures
  import Neighborly.CategoriesFixtures
  alias Neighborly.Incidents
  alias Neighborly.Admin

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    # If an incident_id wasn't provided, create an incident
    {incident, attrs} = if Map.has_key?(attrs, :incident_id) do
      {Incidents.get_incident!(attrs.incident_id), Map.delete(attrs, :incident_id)}
    else
      incident_attrs = %{
        name: "Test Incident",
        description: "Test description that is long enough",
        priority: 1,
        status: :pending,
        image_path: "/images/placeholder.jpg",
        category_id: category_fixture().id
      }
      {:ok, incident} = Admin.create_incident(incident_attrs)
      {incident, attrs}
    end

    # If a user_id wasn't provided, create a user
    {user, attrs} = if Map.has_key?(attrs, :user_id) do
      {Neighborly.Accounts.get_user!(attrs.user_id), Map.delete(attrs, :user_id)}
    else
      user = user_fixture()
      {user, attrs}
    end

    # Create the response with the incident and user
    {:ok, response} =
      attrs
      |> Enum.into(%{
        note: "some note",
        status: :enroute
      })
      |> then(fn params -> Neighborly.Responses.create_response(incident, user, params) end)

    response
  end
end
