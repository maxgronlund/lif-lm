defmodule RunWeb.Admin.UsersView do
  use RunWeb, :view

  def format_date(date) do
    case Timex.format(date, "{D}-{0M}-{YYYY}") do
      {:ok, formated} -> formated
      _ -> "-"
    end
  end

  def valid?(membership) do
    start = Timex.shift(membership.start, days: 1)
    IO.inspect(Timex.after?(start, Timex.today()))
    # IO.inspect(Timex.after?(membership.end, Timex.today()))
    # with membership do
    #   {}
    # end
  end
end
