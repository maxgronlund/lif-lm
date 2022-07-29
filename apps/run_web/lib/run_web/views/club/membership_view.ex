defmodule RunWeb.Club.MembershipView do
  use RunWeb, :view

  def format_date(date) do
    case Timex.format(date, "{D}-{0M}-{YYYY}") do
      {:ok, formated} -> formated
      _ -> "-"
    end
  end
end
