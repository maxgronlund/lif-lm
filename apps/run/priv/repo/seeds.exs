# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Run.Repo.insert!(%Run.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query, warn: false
alias Run.Repo
# TODO take name and email from environment variables
query =
  from u in Run.Accounts.User,
    where: u.email == "admin@synthmax.dk"

super_admin =
  if(Repo.exists?(query)) do
    Repo.one!(query)
  else
    Repo.insert!(%Run.Accounts.User{
      username: "Max",
      email: "admin@synthmax.dk",
      admin: true,
      super: true,
      hashed_password: "-"
    })
  end

pages =
  ~w[landing_page about_page sign_up_page training_page contact_page calendar_page races_page payment_completed ]

for page <- pages do
  query = from b in Run.Admin.Blog, where: b.identifier == ^page

  if(Repo.exists?(query)) do
    Repo.one!(query)
  else
    Repo.insert!(%Run.Admin.Blog{
      page: page,
      title: page,
      description: page,
      identifier: page
    })
  end
end

query = from c in Run.Super.Configuration, select: 1

if !Repo.exists?(query) do
  Repo.insert!(%Run.Super.Configuration{invoice_nr: 1000})
end

# query = from c in Run.ClubAdmin.Club, where: c.name == "system"
#
# club =
#   if(Repo.exists?(query)) do
#     Repo.one!(query)
#   else
#     Repo.insert!(%Run.ClubAdmin.Club{
#       name: "system",
#       description: "super club for system administrator"
#     })
#   end
#
# # build system settings
# query = from(s in Run.SuperAdmin.System)
#
# system =
#   if(Repo.exists?(query)) do
#     Repo.one!(query)
#   else
#     Run.Repo.insert!(%Run.SuperAdmin.System{
#       default_club_id: club.id,
#       super_admin_id: super_admin.id
#     })
#   end
#
