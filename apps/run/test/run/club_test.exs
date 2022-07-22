defmodule Run.ClubTest do
  use Run.DataCase

  alias Run.Club

  def valid_member_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      start: ~D[2021-05-16],
      end: ~D[2022-05-16],
      type: "some-type"
    })
  end

  def invalid_member_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      start: nil,
      end: nil,
      type: nil
    })
  end

  describe "membership" do
    test "create_membership/1 with valid data creates a membership" do
      attrs = valid_member_attrs()
      {:ok, membership} = Club.create_membership(attrs)
      assert membership.start == attrs.start
    end

    test "register_member/1 with invalid password confirmation" do
      attrs = valid_member_attrs(%{password_confirmation: "ups"})
      assert {:error, %Ecto.Changeset{}} = Club.register_member(attrs)
    end
  end

  describe "memberships" do
    alias Run.Club.Membership

    import Run.ClubFixtures

    @invalid_attrs %{end: nil, start: nil, type: nil}

    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Club.list_memberships() == [membership]
    end

    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Club.get_membership!(membership.id) == membership
    end

    test "create_membership/1 with valid data creates a membership" do
      valid_attrs = %{end: ~D[2022-07-16], start: ~D[2022-07-16], type: "some type"}

      assert {:ok, %Membership{} = membership} = Club.create_membership(valid_attrs)
      assert membership.end == ~D[2022-07-16]
      assert membership.start == ~D[2022-07-16]
      assert membership.type == "some type"
    end

    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Club.create_membership(@invalid_attrs)
    end

    test "update_membership/2 with valid data updates the membership" do
      membership = membership_fixture()
      update_attrs = %{end: ~D[2022-07-17], start: ~D[2022-07-17], type: "some updated type"}

      assert {:ok, %Membership{} = membership} = Club.update_membership(membership, update_attrs)
      assert membership.end == ~D[2022-07-17]
      assert membership.start == ~D[2022-07-17]
      assert membership.type == "some updated type"
    end

    test "update_membership/2 with invalid data returns error changeset" do
      membership = membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Club.update_membership(membership, @invalid_attrs)
      assert membership == Club.get_membership!(membership.id)
    end

    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Club.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Club.get_membership!(membership.id) end
    end

    test "change_membership/1 returns a membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Club.change_membership(membership)
    end
  end
end
