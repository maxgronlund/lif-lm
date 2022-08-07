defmodule RunWeb.Committees.MessageController do
  use RunWeb, :controller

  alias RunWeb.Users.Auth
  plug Auth
  plug :authorize_volunteer when action in [:show, :index, :new, :create]
  plug :navbar when action in [:index, :new, :show]

  alias Run.Committees
  alias Run.CommitteeMessage

  def index(conn, %{"committee_id" => committee_id}) do
    prefix = conn.assigns.prefix
    messages = Committees.list_messages(prefix, committee_id)
    committee = Committees.get_committee!(prefix, committee_id)

    if member_of_committee(conn, committee) do
      render(conn, "index.html", committee: committee, messages: messages)
    else
      forbidden(conn)
    end
  end

  def new(conn, %{"committee_id" => committee_id}) do
    prefix = conn.assigns.prefix
    committee = Committees.get_committee!(prefix, committee_id)

    if member_of_committee(conn, committee) do
      changeset = Committees.change_message(%CommitteeMessage{})
      render(conn, "new.html", changeset: changeset, committee: committee)
    else
      forbidden(conn)
    end
  end

  def create(conn, %{"committee_id" => committee_id, "message" => message_params}) do
    committee = Committees.get_committee!(conn.assigns.prefix, committee_id)

    if member_of_committee(conn, committee) do
      message_params =
        Map.merge(
          message_params,
          %{
            "committee_id" => committee_id,
            "from" => conn.assigns.current_user.username
          }
        )

      create_message(conn, committee, message_params)
    else
      forbidden(conn)
    end
  end

  defp create_message(conn, committee, message_params) do
    case Committees.create_message(conn.assigns.prefix, message_params) do
      {:ok, message} ->
        send_notification(conn, committee, message)

        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: Routes.committee_committee_message_path(conn, :index, committee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"committee_id" => _committee_id, "id" => id}) do
    message = Committees.get_message!(conn.assigns.prefix, id)

    if member_of_committee(conn, message.committee) do
      render(conn, "show.html", committee: message.committee, message: message)
    else
      forbidden(conn)
    end
  end

  defp send_notification(conn, committee, message) do
    message_url =
      RunWeb.Router.Helpers.url(conn) <>
        conn.request_path <>
        "/" <>
        message.id

    association_name = conn.assigns.association_name

    for member <- committee.members do
      send_email(association_name, message_url, member.user)
    end
  end

  defp send_email(association_name, message_url, user) do
    username_and_email = {user.username, user.email}

    RunWeb.EmailController.message_notification(
      association_name,
      username_and_email,
      message_url
    )
    |> RunWeb.Mailer.deliver_now()
  end

  # def edit(conn, %{"id" => id}) do
  #   message = Committees.get_message!(id)
  #   changeset = Committees.change_message(message)
  #   render(conn, "edit.html", message: message, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "message" => message_params}) do
  #   message = Committees.get_message!(id)

  #   case Committees.update_message(message, message_params) do
  #     {:ok, message} ->
  #       conn
  #       |> put_flash(:info, "Message updated successfully.")
  #       |> redirect(to: Routes.message_path(conn, :show, message))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", message: message, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   message = Committees.get_message!(id)
  #   {:ok, _message} = Committees.delete_message(message)

  #   conn
  #   |> put_flash(:info, "Message deleted successfully.")
  #   |> redirect(to: Routes.message_path(conn, :index))
  # end

  defp authorize_volunteer(conn, _opts) do
    if conn.assigns.volunteer || conn.assigns.admin do
      conn
    else
      forbidden(conn)
    end
  end

  defp member_of_committee(conn, committee) do
    user = conn.assigns.current_user
    members = committee.members
    Enum.any?(members, fn member -> member.user_id == user.id end)
  end

  defp forbidden(conn) do
    conn
    |> put_status(401)
    |> put_view(RunWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end

  defp navbar(conn, _opts) do
    assign(conn, :selected_menu_item, :about_aoff)
  end
end
