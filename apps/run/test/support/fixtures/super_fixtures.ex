defmodule Run.SuperFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Run.Super` context.
  """

  import Ecto.Query, warn: false
  alias Run.Repo

  @doc """
  Generate a configuration.
  """
  def configuration_fixture(attrs \\ %{}) do
    query = from c in Run.Super.Configuration, select: 1

    if !Repo.exists?(query) do
      Repo.insert!(%Run.Super.Configuration{invoice_nr: 1000})
    end
  end
end
