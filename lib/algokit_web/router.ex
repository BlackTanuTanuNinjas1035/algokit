defmodule AlgokitWeb.Router do
  use AlgokitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AlgokitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AlgokitWeb do
    pipe_through :browser

    live "/", MainMenuLive
    live "/detail", AlgoDetailLive
    live "/category/:category_id", SubMenuLive
    live "/category/:category_id/algorithm/:algorithm_id", DetailLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", AlgokitWeb do
  #   pipe_through :api
  # end
end
