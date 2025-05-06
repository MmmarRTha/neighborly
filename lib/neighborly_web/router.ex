defmodule NeighborlyWeb.Router do
  use NeighborlyWeb, :router

  import NeighborlyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NeighborlyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NeighborlyWeb do
    pipe_through :browser

    # get "/", PageController, :home
    get "/tips", TipController, :index
    get "/tips/:id", TipController, :show

    live "/", IncidentLive.Index
    live "/effort", EffortLive
    live "/incidents", IncidentLive.Index
    live "/incidents/:id", IncidentLive.Show
  end

  scope "/", NeighborlyWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    live_session :admin,
      on_mount: [
        {NeighborlyWeb.UserAuth, :ensure_authenticated},
        {NeighborlyWeb.UserAuth, :ensure_admin}
      ] do
      live "/admin/incidents", AdminIncidentLive.Index
      live "/admin/incidents/new", AdminIncidentLive.Form, :new
      live "/admin/incidents/:id/edit", AdminIncidentLive.Form, :edit

      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Form, :new
      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/edit", CategoryLive.Form, :edit
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", NeighborlyWeb.Api do
    pipe_through :api

    get "/incidents", IncidentController, :index
    get "/incidents/:id", IncidentController, :show
    post "/incidents", IncidentController, :create

    get "/categories/:id/incidents", CategoryController, :show
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:neighborly, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NeighborlyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NeighborlyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{NeighborlyWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/reset-password", UserLive.ForgotPassword, :new
      live "/users/reset-password/:token", UserLive.ResetPassword, :edit
    end

    post "/users/log-in", UserSessionController, :create
  end

  scope "/", NeighborlyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{NeighborlyWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end
  end

  scope "/", NeighborlyWeb do
    pipe_through [:browser]

    delete "/users/log-out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{NeighborlyWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserLive.Confirmation, :edit
      live "/users/confirm", UserLive.ConfirmationInstructions, :new
    end
  end
end
