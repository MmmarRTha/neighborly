defmodule Neighborly.ResponsesTest do
  use Neighborly.DataCase

  alias Neighborly.Responses
  alias Neighborly.Admin

  describe "responses" do
    alias Neighborly.Responses.Response

    import Neighborly.ResponsesFixtures
    import Neighborly.AccountsFixtures
    import Neighborly.CategoriesFixtures

    @invalid_attrs %{status: nil, note: nil}

    setup do
      user = user_fixture()
      category = category_fixture()

      # Create an incident for testing
      {:ok, incident} =
        Admin.create_incident(%{
          name: "Test Incident",
          description: "Test description that is long enough",
          priority: 1,
          status: :pending,
          image_path: "/images/placeholder.jpg",
          category_id: category.id
        })

      %{user: user, incident: incident}
    end

    test "list_responses/0 returns all responses", %{user: _user, incident: _incident} do
      response = response_fixture()
      assert [returned_response] = Responses.list_responses()
      assert returned_response.id == response.id
    end

    test "get_response!/1 returns the response with given id", %{user: _user, incident: _incident} do
      response = response_fixture()
      assert returned_response = Responses.get_response!(response.id)
      assert returned_response.id == response.id
    end

    test "create_response/3 with valid data creates a response", %{user: user, incident: incident} do
      valid_attrs = %{status: :enroute, note: "some note"}

      assert {:ok, %Response{} = response} = Responses.create_response(incident, user, valid_attrs)
      assert response.status == :enroute
      assert response.note == "some note"
    end

    test "create_response/3 with invalid data returns error changeset", %{user: user, incident: incident} do
      assert {:error, %Ecto.Changeset{}} = Responses.create_response(incident, user, @invalid_attrs)
    end

    test "update_response/2 with valid data updates the response", %{user: _user, incident: _incident} do
      response = response_fixture()
      update_attrs = %{status: :arrived, note: "some updated note"}

      assert {:ok, %Response{} = response} = Responses.update_response(response, update_attrs)
      assert response.status == :arrived
      assert response.note == "some updated note"
    end

    test "update_response/2 with invalid data returns error changeset", %{user: _user, incident: _incident} do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Responses.update_response(response, @invalid_attrs)
      assert Responses.get_response!(response.id).id == response.id
    end

    test "delete_response/1 deletes the response", %{user: _user, incident: _incident} do
      response = response_fixture()
      assert {:ok, %Response{}} = Responses.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Responses.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset", %{user: _user, incident: _incident} do
      response = response_fixture()
      assert %Ecto.Changeset{} = Responses.change_response(response)
    end
  end
end
