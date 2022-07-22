defmodule RunWeb.Router do
  use RunWeb, :router

  import RunWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RunWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RunWeb.Page do
    pipe_through :browser

    get "/", LandingController, :index, as: :landing_page
    get "/about", AboutController, :index, as: :about_page
    get "/sign-up", SignUpController, :index, as: :sign_up_page
    get "/training", TrainingController, :index, as: :training_page
    get "/contact", ContactController, :index, as: :contact_page
    get "/calendar", CalendarController, :index, as: :calendar_page
    get "/events", EventsController, :index, as: :events_page
    get "/committees", CommitteesPageController, :index, as: :committees_page
  end

  # Other scopes may use custom stacks.
  # scope "/api", RunWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RunWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RunWeb.User do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", RegistrationController, :new, as: :user_registration
    post "/users/register", RegistrationController, :create, as: :user_registration
    get "/users/log_in", SessionController, :new, as: :user_session, as: :user_session
    post "/users/log_in", SessionController, :create, as: :user_session
    get "/users/reset_password", ResetPasswordController, :new, as: :user_reset_password
    post "/users/reset_password", ResetPasswordController, :create, as: :user_reset_password
    get "/users/reset_password/:token", ResetPasswordController, :edit, as: :user_reset_password
    put "/users/reset_password/:token", ResetPasswordController, :update, as: :user_reset_password
  end

  scope "/users", RunWeb.User do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings/confirm_email/:token", SettingsController, :confirm_email,
      as: :user_settings
  end

  scope "/user", RunWeb.User do
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", SettingsController, :edit, as: :user_settings
    put "/settings", SettingsController, :update, as: :user_settings

    get "/password", PasswordController, :edit, as: :password
    put "/password", PasswordController, :update, as: :password
  end

  scope "/", RunWeb.User do
    pipe_through [:browser]

    delete "/users/log_out", SessionController, :delete, as: :user_session
    get "/users/confirm", ConfirmationController, :new, as: :user_confirmation
    post "/users/confirm", ConfirmationController, :create, as: :user_confirmation
    get "/users/confirm/:token", ConfirmationController, :edit, as: :user_confirmation
    post "/users/confirm/:token", ConfirmationController, :update, as: :user_confirmation
  end

  scope "/admin", RunWeb.Admin do
    pipe_through [:browser, :require_admin]
    get "/", DashboardController, :index, as: :admin

    resources "/blogs", BlogController, as: :admin_blogs, only: [:index, :show, :edit, :update] do
      resources "/posts", PostController
    end

    resources "/users", UsersController, as: :admin_users
  end

  scope "/admin", RunWeb.Admin do
    pipe_through [:browser, :require_admin, :require_architect]
    resources "/blog", BlogController, as: :admin_blog, only: [:new, :create, :delete]
  end

  scope "/club", RunWeb.Club do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/member/new", MemberController, :new, as: :new_member
    post "/member", MemberController, :create, as: :new_member
  end

  scope "/member", RunWeb.Club do
    pipe_through [:browser, :require_authenticated_user]
    get "/edit", MemberController, :edit, as: :edit_member
    get "/", MemberController, :show, as: :show_member
    put "/", MemberController, :update, as: :update_member
  end

  scope "/super", RunWeb.Super do
    pipe_through [:browser, :require_super]
    get "/", DashboardController, :index, as: :super_dashboard

    resources "/users", UserController, as: :super_users
  end
end
