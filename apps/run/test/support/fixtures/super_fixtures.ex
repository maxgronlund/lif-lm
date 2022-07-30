defmodule Run.SuperFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Run.Super` context.
  """

  @doc """
  Generate a configuration.
  """
  def configuration_fixture(attrs \\ %{}) do
    {:ok, configuration} =
      attrs
      |> Enum.into(%{
        invoice_id: 42
      })
      |> Run.Super.create_configuration()

    configuration
  end
end
