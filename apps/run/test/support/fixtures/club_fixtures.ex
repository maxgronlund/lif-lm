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
        end: ~D[2022-07-16],
        start: ~D[2022-07-16],
        type: "some type"
      })
      |> Run.Club.create_membership()

    membership
  end
end
