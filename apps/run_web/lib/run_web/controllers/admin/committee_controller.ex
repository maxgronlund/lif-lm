defmodule RunWeb.Admin.CommitteeController do
  use RunWeb, :controller

  alias Run.Admin.Committees
  alias Run.Committee

  def index(conn, _params) do
    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "index.html",
      committees: Committees.list()
    )
  end

  def new(conn, _params) do
    changeset = Committees.change_committee(%Committee{})

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "new.html",
      changeset: changeset
    )
  end

  def create(conn, %{"committee" => committee_params}) do
    case Committees.create_committee(committee_params) do
      {:ok, committee} ->
        conn
        |> put_flash(:info, gettext("Committee created successfully."))
        |> redirect(to: Routes.admin_committee_path(conn, :show, committee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn
          |> assign(:breadcrumbs, breadcrumbs(conn))
          |> assign(:tabs, tabs(conn)),
          "new.html",
          changeset: changeset
        )
    end
  end

  def show(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "show.html",
      committee: committee
    )
  end

  def edit(conn, %{"id" => id}) do
    committee = Committees.get_committee!(id)
    changeset = Committees.change_committee(committee)

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "edit.html",
      committee: committee,
      changeset: changeset
    )
  end

  def update(conn, %{"committee" => committee_params, "id" => id}) do
    committee = Committees.get_committee!(id)

    case Committees.update_committee(committee, committee_params) do
      {:ok, _committee} ->
        conn
        |> put_flash(:info, gettext("Committee updated successfully."))
        |> redirect(to: Routes.admin_committee_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn
          |> assign(:breadcrumbs, breadcrumbs(conn))
          |> assign(:tabs, tabs(conn)),
          "edit.html",
          committee: committee,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    Committees.get_committee!(id)
    |> Committees.delete_committee()

    render(
      conn
      |> assign(:breadcrumbs, breadcrumbs(conn))
      |> assign(:tabs, tabs(conn)),
      "index.html",
      committees: Committees.list()
    )
  end

  defp breadcrumbs(conn) do
    %{
      show: true,
      root: %{title: gettext("home"), path: Routes.landing_page_path(conn, :index)},
      links: [],
      current_page: gettext("admin")
    }
  end

  defp tabs(conn) do
    [
      %{label: gettext("admin"), link: Routes.admin_path(conn, :index), active: false},
      %{label: gettext("blogs"), link: Routes.admin_blogs_path(conn, :index), active: false},
      %{label: gettext("users"), link: Routes.admin_users_path(conn, :index), active: false},
      %{
        label: gettext("committees"),
        link: Routes.admin_committee_path(conn, :index),
        active: true
      }
    ]
  end
end
