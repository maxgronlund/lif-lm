defmodule Run.CheckMembershipsTest do
  use Run.DataCase

  alias Run.Accounts

  import Run.AccountsFixtures
  import Run.ClubFixtures
  # alias Run.Accounts.{User, UserToken}

  describe "users where valid_member are set to false" do
    setup do
      user = user_fixture(%{valid_member: false})

      %{user: user}
    end

    test "are update to true when there is a valid membership", %{user: user} do
      create_expired_membership(user)
      create_valid_membership(user)
      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      assert user.valid_member
    end

    test "keep valid_member set to false when there are no memberships", %{user: user} do
      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      assert !user.valid_member
    end

    test "keep valid_member set to false when there only are future memberships", %{user: user} do
      membership = create_future_membership(user)
      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      membership = Run.Club.get_membership!(membership.id)

      assert membership.state == "future"
      assert !user.valid_member
    end

    test "keep valid_member set to false when there only are expired memberships", %{user: user} do
      create_expired_membership(user)
      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      assert !user.valid_member
    end
  end

  describe "memberships" do
    setup do
      user = user_fixture()
      %{user: user}
    end

    test "are set to expired if the end date are before today", %{user: user} do
      membership = create_expired_membership(user)

      Run.CheckMemberships.run()

      membership = Run.Club.get_membership!(membership.id)

      assert membership.state == "expired"
    end
  end

  describe "users where valid_member are set to true" do
    setup do
      user = user_fixture(%{valid_member: true})

      %{user: user}
    end

    test "keep valid membership set to true when there are a valid membership", %{user: user} do
      create_valid_membership(user)

      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      assert user.valid_member
    end

    test "are updated to false when the membership expires", %{user: user} do
      create_expired_membership(user)
      Run.CheckMemberships.run()
      user = Accounts.get_user!(user.id)

      assert !user.valid_member
    end
  end

  def create_future_membership(user) do
    start_date = Timex.shift(Timex.today(), years: 2)
    end_date = Timex.shift(start_date, years: 1)
    create_membership(start_date, end_date, user, "pending")
  end

  def create_expired_membership(user) do
    start_date = Timex.shift(Timex.today(), years: -2)
    end_date = Timex.shift(start_date, years: 1)
    create_membership(start_date, end_date, user, "pending")
  end

  def create_valid_membership(user) do
    start_date = Timex.shift(Timex.today(), days: -1)
    end_date = Timex.shift(start_date, years: 1)
    create_membership(start_date, end_date, user, "pending")
  end

  def create_membership(start_date, end_date, user, state) do
    membership_fixture(%{
      start_date: start_date,
      end_date: end_date,
      user_id: user.id,
      state: state
    })
  end
end
