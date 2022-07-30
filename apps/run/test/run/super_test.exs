defmodule Run.SuperTest do
  use Run.DataCase

  alias Run.Super

  describe "configurations" do
    alias Run.Super.Configuration

    import Run.SuperFixtures

    @invalid_attrs %{invoice_id: nil}

    test "list_configurations/0 returns all configurations" do
      configuration = configuration_fixture()
      assert Super.list_configurations() == [configuration]
    end

    test "get_configuration!/1 returns the configuration with given id" do
      configuration = configuration_fixture()
      assert Super.get_configuration!(configuration.id) == configuration
    end

    test "create_configuration/1 with valid data creates a configuration" do
      valid_attrs = %{invoice_id: 42}

      assert {:ok, %Configuration{} = configuration} = Super.create_configuration(valid_attrs)
      assert configuration.invoice_id == 42
    end

    test "create_configuration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Super.create_configuration(@invalid_attrs)
    end

    test "update_configuration/2 with valid data updates the configuration" do
      configuration = configuration_fixture()
      update_attrs = %{invoice_id: 43}

      assert {:ok, %Configuration{} = configuration} = Super.update_configuration(configuration, update_attrs)
      assert configuration.invoice_id == 43
    end

    test "update_configuration/2 with invalid data returns error changeset" do
      configuration = configuration_fixture()
      assert {:error, %Ecto.Changeset{}} = Super.update_configuration(configuration, @invalid_attrs)
      assert configuration == Super.get_configuration!(configuration.id)
    end

    test "delete_configuration/1 deletes the configuration" do
      configuration = configuration_fixture()
      assert {:ok, %Configuration{}} = Super.delete_configuration(configuration)
      assert_raise Ecto.NoResultsError, fn -> Super.get_configuration!(configuration.id) end
    end

    test "change_configuration/1 returns a configuration changeset" do
      configuration = configuration_fixture()
      assert %Ecto.Changeset{} = Super.change_configuration(configuration)
    end
  end
end
