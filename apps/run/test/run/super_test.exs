defmodule Run.SuperTest do
  use Run.DataCase

  alias Run.Super

  describe "configurations" do
    alias Run.Super.Configuration

    import Run.SuperFixtures

    setup do
      configuration = configuration_fixture()
      %{configuration: configuration}
    end

    test "getting a new invoice nr" do
      number = Super.get_and_update_invoice_nr()
      next_number = Super.get_and_update_invoice_nr()
      assert number < next_number
    end
  end
end
