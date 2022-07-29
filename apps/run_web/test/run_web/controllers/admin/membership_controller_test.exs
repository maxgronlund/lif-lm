# defmodule RunWeb.Admin.MembershipControllerText do
#   use RunWeb.ConnCase
#
#   import Run.GlubFixtures
#
#   @create_attrs %{name: "some name"}
#   @update_attrs %{name: "some updated name"}
#   @invalid_attrs %{name: nil}
#
#   describe "new nembership" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, Routes.membership_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Nembership"
#     end
#   end
#
#   describe "create nembership" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.membership_path(conn, :create), nembership: @create_attrs)
#
#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.membership_path(conn, :show, id)
#
#       conn = get(conn, Routes.membership_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Nembership"
#     end
#
#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.membership_path(conn, :create), nembership: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Nembership"
#     end
#   end
#
#   describe "edit nembership" do
#     setup [:create_nembership]
#
#     test "renders form for editing chosen nembership", %{conn: conn, nembership: nembership} do
#       conn = get(conn, Routes.membership_path(conn, :edit, nembership))
#       assert html_response(conn, 200) =~ "Edit Nembership"
#     end
#   end
#
#   describe "update nembership" do
#     setup [:create_nembership]
#
#     test "redirects when data is valid", %{conn: conn, nembership: nembership} do
#       conn =
#         put(conn, Routes.membership_path(conn, :update, nembership), nembership: @update_attrs)
#
#       assert redirected_to(conn) == Routes.membership_path(conn, :show, nembership)
#
#       conn = get(conn, Routes.membership_path(conn, :show, nembership))
#       assert html_response(conn, 200) =~ "some updated name"
#     end
#
#     test "renders errors when data is invalid", %{conn: conn, nembership: nembership} do
#       conn =
#         put(conn, Routes.membership_path(conn, :update, nembership), nembership: @invalid_attrs)
#
#       assert html_response(conn, 200) =~ "Edit Nembership"
#     end
#   end
#
#   describe "delete nembership" do
#     setup [:create_nembership]
#
#     test "deletes chosen nembership", %{conn: conn, nembership: nembership} do
#       conn = delete(conn, Routes.membership_path(conn, :delete, nembership))
#       assert redirected_to(conn) == Routes.membership_path(conn, :index)
#
#       assert_error_sent 404, fn ->
#         get(conn, Routes.membership_path(conn, :show, nembership))
#       end
#     end
#   end
#
#   defp create_nembership(_) do
#     nembership = membership_fixture()
#     %{nembership: nembership}
#   end
# end
#
