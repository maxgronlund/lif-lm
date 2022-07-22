defmodule UserFixtures do
  # import Ecto.Query, warn: false
  alias Run.Repo

  def admin_fixture(params \\ %{}) do
    params
    |> Enum.into(params(:admin))
    |> Repo.insert!()
  end

  def params() do
    %{
      username: "TestUser #{System.unique_integer()}",
      email: "test@user-#{System.unique_integer()}.io",
      hashed_password: Bcrypt.hash_pwd_salt("test-passwword-0987")
    }
  end

  def params(:admin) do
    params |> Enum.into(params(), %{admin: true})
  end

  def params(:super) do
    params |> Enum.into(params(:admin), %{super: true})
  end
end
