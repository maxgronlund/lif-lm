defmodule RunWeb.Admin.UsersView do
  use RunWeb, :view

  def format_date(date) do
    case Timex.format(date, "{D}-{0M}-{YYYY}") do
      {:ok, formated} -> formated
      _ -> "-"
    end
  end

  def valid?(%Run.Club.Membership{start_date: _start_date, end_date: nil}), do: false

  def valid?(%Run.Club.Membership{start_date: start_date, end_date: end_date}) do
    start_date = Timex.shift(start_date, days: -1)
    Timex.between?(Timex.today(), start_date, end_date)
  end
end
