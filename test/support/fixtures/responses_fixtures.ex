defmodule Neighborly.ResponsesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Neighborly.Responses` context.
  """

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        note: "some note",
        status: :enroute
      })
      |> Neighborly.Responses.create_response()

    response
  end
end
