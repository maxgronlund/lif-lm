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
  ~w[landing_page about_page become_member_page training_page contact_page calendar_page races_page ]

for page <- pages do
  query = from b in Run.Admin.Blog, where: b.page == ^page

  if(Repo.exists?(query)) do
    Repo.one!(query)
  else
    Repo.insert!(%Run.Admin.Blog{
      page: page,
      title: page,
      description: page
    })
  end
end

# # build default club
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
