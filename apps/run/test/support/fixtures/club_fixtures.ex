defmodule Run.ClubFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Run.Club` context.
  """

  @doc """
  Generate a member.
  """
  def membership_fixture(attrs \\ %{}) do
    {:ok, membership} =
      attrs
      |> Enum.into(%{
        end_date: ~D[2022-07-16],
        start_date: ~D[2023-07-16],
        type: "membership",
        amount: 500,
        currency: "dkk",
        state: "pending"
      })
      |> Run.Club.create_membership()

    membership
  end
end
