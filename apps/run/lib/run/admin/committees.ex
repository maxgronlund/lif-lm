defmodule Run.Admin.Committees do
  @moduledoc """
  The Admin Committees context.
  """

  import Ecto.Query, warn: false
  alias Run.Repo

  alias Run.Committee
  alias Run.CommitteeMember
  alias Run.CommitteeMeeting
  alias Run.CommitteeMessage
  alias Run.Accounts.User

  @doc """
  Returns the list of committees.

  ## Examples

      iex> list_committees()
      [%Committee{}, ...]

  """
  def list do
    Repo.all(Committee)
  end

  @doc """
  Gets a single committee.

  Raises `Ecto.NoResultsError` if the Committee does not exist.

  ## Examples

      iex> get_committee!(123)
      %Committee{}

      iex> get_committee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_committee!(id) do
    query =
      from(
        c in Committee,
        where: c.id == ^id,
        select: c,
        preload: [
          committee_members: [:user],
          committee_meetings: ^from(m in CommitteeMeeting, order_by: [desc: m.date])
        ]
      )

    Repo.one(query)
  end

  @doc """
  Creates a committee.

  ## Examples

      iex> create_committee(%{field: value})
      {:ok, %Committee{}}

      iex> create_committee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_committee(attrs \\ %{}) do
    %Committee{}
    |> Committee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a committee.

  ## Examples

      iex> update_committee(committee, %{field: new_value})
      {:ok, %Committee{}}

      iex> update_committee(committee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_committee(%Committee{} = committee, attrs) do
    committee
    |> Committee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a committee.

  ## Examples

      iex> delete_committee(committee)
      {:ok, %Committee{}}

      iex> delete_committee(committee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_committee(%Committee{} = committee) do
    Repo.delete(committee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking committee changes.

  ## Examples

      iex> change_committee(committee)
      %Ecto.Changeset{source: %Committee{}}

  """
  def change_committee(%Committee{} = committee) do
    Committee.changeset(committee, %{})
  end

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings do
    Repo.all(Meeting)
  end

  @doc """
  Returns a list of meetings for a given user.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_user_meetings(user_id, today) do
    query =
      from(mt in CommitteeMeeting,
        where: mt.date >= ^today,
        join: c in assoc(mt, :committee),
        join: mb in assoc(c, :committee_members),
        where: mb.user_id == ^user_id,
        distinct: true
      )

    meetings =
      query
      |> Repo.all()
      |> Repo.preload(:committee)

    if Enum.any?(meetings), do: meetings, else: false
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(id) do
    Repo.get!(CommitteeMeeting, id)
    |> Repo.preload(:moderator)
    |> Repo.preload(:minutes_taker)
    |> Repo.preload(committee: [:committee_members])
  end

  @doc """
  Creates a meeting.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(attrs \\ %{}) do
    %CommitteeMeeting{}
    |> CommitteeMeeting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%CommitteeMeeting{} = meeting, attrs) do
    meeting
    |> CommitteeMeeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%CommitteeMeeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{source: %Meeting{}}

  """
  def change_meeting(%CommitteeMeeting{} = meeting) do
    CommitteeMeeting.changeset(meeting, %{})
  end

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members(committee_id) do
    query =
      from(m in CommitteeMember,
        where: m.committee_id == ^committee_id
      )

    Repo.all(query)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id) do
    CommitteeMember
    |> Repo.get!(id)
    |> Repo.preload(:committee)
  end

  @doc """
  Creates a member.

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %CommitteeMember{}
    |> CommitteeMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%CommitteeMember{} = member, attrs) do
    member
    |> CommitteeMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%CommitteeMember{} = committee_member) do
    Repo.delete(committee_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_committee_member(%CommitteeMember{} = committee_member) do
    CommitteeMember.changeset(committee_member, %{})
  end

  def change_committee_member(params) do
    IO.inspect(params)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(prefix, committee_id) do
    query =
      from(m in CommitteeMessage,
        where: m.committee_id == ^committee_id,
        order_by: [desc: m.posted_at]
      )

    query
    |> Repo.all()
    |> Repo.preload(:committee)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(prefix, id) do
    CommitteeMessage
    |> Repo.get!(id)
    |> Repo.preload(committee: [:committee_members])
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %CommitteeMessage{}
    |> CommitteeMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%CommitteeMessage{} = message, attrs) do
    message
    |> CommitteeMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%CommitteeMessage{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%CommitteeMessage{} = message, attrs \\ %{}) do
    CommitteeMessage.changeset(message, attrs)
  end

  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single committee member.

  Raises `Ecto.NoResultsError` if the CommitteeMember does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(prefix, id) do
    CommitteeMember
    |> Repo.get!(id)
    |> Repo.preload(:committee)
  end
end
