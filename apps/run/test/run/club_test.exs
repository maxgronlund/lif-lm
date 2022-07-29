defmodule Run.ClubTest do
  use Run.DataCase
  import Run.AccountsFixtures

  alias Run.Club

  def valid_membership_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      start_date: ~D[2021-05-16],
      end_date: ~D[2022-05-16],
      amount: 500,
      currency: "dkk",
      type: "some-type",
      state: "pending"
    })
  end

  def invalid_membership_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      start: nil,
      end: nil,
      amount: nil,
      currency: nil,
      type: nil,
      state: nil
    })
  end

  setup do
    %{user: user_fixture()}
  end

  describe "membership" do
    test "create_membership/1 with valid data creates a membership", %{user: user} do
      attrs = valid_membership_attrs(%{user_id: user.id})
      {:ok, membership} = Club.create_membership(attrs)
      assert membership.start_date == attrs.start_date
    end

    test "register_member/1 with invalid password confirmation", %{user: user} do
      attrs = valid_membership_attrs(%{password_confirmation: "ups", user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Club.register_member(attrs)
    end
  end

  describe "memberships" do
    alias Run.Club.Membership

    import Run.ClubFixtures

    @invalid_attrs %{end: nil, start: nil, type: nil}

    def valid_attrs(user_id) do
      %{
        end_date: ~D[2023-07-16],
        start_date: ~D[2022-07-16],
        amount: 500,
        currency: "dkk",
        type: "membership",
        state: "pending",
        user_id: user_id
      }
    end

    test "list_memberships/0 returns all memberships", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})
      assert Club.list_memberships() == [membership]
    end

    test "get_membership!/1 returns the membership with given id", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})
      assert Club.get_membership!(membership.id) == membership
    end

    test "create_membership/1 with valid data creates a membership", %{user: user} do
      attrs = valid_attrs(user.id)

      assert {:ok, %Membership{} = membership} = Club.create_membership(attrs)
      assert membership.end_date == attrs.end_date
      assert membership.start_date == attrs.start_date
      assert membership.amount == attrs.amount
      assert membership.type == attrs.type
    end

    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Club.create_membership(@invalid_attrs)
    end

    test "update_membership/2 with valid data updates the membership", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})

      update_attrs = %{
        end_date: ~D[2022-07-17],
        start_date: ~D[2022-07-17],
        type: "some updated type"
      }

      assert {:ok, %Membership{} = membership} = Club.update_membership(membership, update_attrs)
      assert membership.end_date == ~D[2022-07-17]
      assert membership.start_date == ~D[2022-07-17]
      assert membership.type == "some updated type"
    end

    test "update_membership/2 with invalid data returns error changeset", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Club.update_membership(membership, @invalid_attrs)
      assert membership == Club.get_membership!(membership.id)
    end

    test "delete_membership/1 deletes the membership", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})
      assert {:ok, %Membership{}} = Club.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Club.get_membership!(membership.id) end
    end

    test "change_membership/1 returns a membership changeset", %{user: user} do
      membership = membership_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Club.change_membership(membership)
    end
  end
end
