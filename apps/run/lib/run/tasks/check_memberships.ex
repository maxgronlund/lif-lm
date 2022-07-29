defmodule Run.CheckMemberships do
  @moduledoc """
  The purpose of this module is to keep track of expiring memberships
  """
  import Ecto.Query, warn: false
  alias Run.Repo

  alias Run.Accounts.User
  alias Run.Club.Membership

  # def list_users_with_memberships() do
  #   membership_query =
  #     from m in Membership,
  #       where: m.state == ^"valid" or m.state == "payed"

  #   user_query = from(u in User, preload: [memberships: ^membership_query])

  #   Repo.all(user_query)
  # end

  defp one_hour_ago do
    Timex.now()
    |> Timex.shift(hours: -1)
    |> Timex.to_datetime()
  end

  defp one_year_ago do
    Timex.now()
    |> Timex.shift(years: -1)
    |> Timex.to_datetime()
  end

  defp one_year_from_today do
    Timex.now()
    |> Timex.shift(years: 1)
    |> Timex.to_datetime()
  end

  defp today, do: Timex.now() |> Timex.to_datetime()

  def run do
    # for user <- list_users_with_memberships() do
    #   check_membership(user.memberships, false)
    #   |> update_valid_member(user)
    # end

    update_memberships()
    update_users()
  end

  defp update_memberships do
    expired()
    |> Repo.update_all(set: [state: "expired"])

    future()
    |> Repo.update_all(set: [state: "future"])

    valid()
    |> Repo.update_all(set: [state: "valid"])

    pending()
    |> Repo.delete_all()
  end

  defp expired do
    from m in Membership, where: m.state != ^"expired" and m.end_date < ^today()
  end

  defp future do
    from m in Membership, where: m.state != ^"expired" and m.start_date > ^today()
  end

  defp valid do
    from m in Membership,
      where:
        m.state != ^"expired" and
          m.start_date >= ^one_year_ago() and
          m.end_date < ^one_year_from_today()
  end

  defp pending do
    from m in Membership,
      where: m.state == ^"pending" and is_nil(m.end_date) and m.inserted_at < ^one_hour_ago()
  end

  defp users_with_valid_memberships do
    # from m in Membership, where: m.state == "valid", select: m.user_id
    from u in User,
      join: m in Membership,
      on: m.user_id == u.id,
      where: m.state == "valid"
  end

  defp valid_members do
    from u in User, where: u.valid_member == ^true
  end

  defp update_users do
    valid_members() |> Repo.update_all(set: [valid_member: false])

    users_with_valid_memberships()
    |> Repo.update_all(set: [valid_member: true])
  end

  # defp update_memberships do
  #   memberships = Repo.all()
  # end

  # defp check_membership(_, true), do: true
  # defp check_membership([], _), do: false

  # defp check_membership([membership | t], false) do
  #   case Timex.between?(Timex.today(), membership.start_date, membership.end_date) do
  #     true ->
  #       true

  #     false ->
  #       expire_membership(membership)

  #       check_membership(t, false)
  #   end
  # end

  # defp update_valid_member(valid_membership, user) do
  #   case valid_membership do
  #     true when user.valid_member ->
  #       user

  #     true ->
  #       update_user(user, true)

  #     false when user.valid_member ->
  #       update_user(user, false)

  #     false ->
  #       user
  #   end
  # end

  # defp update_user(user, valid_member) do
  #   User.membership_changeset(user, %{valid_member: valid_member})
  #   |> Repo.update!()
  # end

  # defp expire_membership(membership) do
  #   if(Timex.before?(membership.end_date, Timex.today())) do
  #     Membership.expire_changeset(membership)
  #     |> Repo.update()
  #   end
  # end
end
