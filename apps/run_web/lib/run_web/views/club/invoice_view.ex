defmodule RunWeb.Club.InvoiceView do
  use RunWeb, :view

  def format_date(date) do
    case Timex.format(date, "{D}-{0M}-{YYYY}") do
      {:ok, formated} -> formated
      _ -> "-"
    end
  end

  def format_price(membership) do
    "#{membership.amount},00 DKK"
  end

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end
end
