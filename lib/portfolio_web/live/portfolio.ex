defmodule PortfolioWeb.Portfolio do
  use PortfolioWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias Portfolio.{Messaging}
  alias PortfolioWeb.{Presence}

  @projects [
    %{
      name: "Portfolio",
      description: "My personal website made using Phoenix Live View.",
      git_url: "https://github.com/jehincastic/pheonix_portfolio",
      project_url: "https://jehincastic.dev",
    },
  ]


  def mount(_params, _session, socket) do
    if connected?(socket) do
      Messaging.subscribe("theme")
      Presence.start("portfolio")
    end

    {live_reading, live_visitors} = Presence.get_active_list()
    theme = Portfolio.ThemeState.get()


    socket =
      socket
      |> assign(page_title: "Portfolio")
      |> assign(theme: theme)
      |> assign(live_reading: live_reading)
      |> assign(live_visitors: live_visitors)
      |> assign(projects: @projects)
      |> assign(title: "Projects 📚")
      |> assign(sub_title: "A selection of projects I've worked on, during my career as a Software Engineer.")

    {:ok, socket}
  end

  def handle_event("theme_toggle", %{"next-theme" => theme}, socket) do
    socket =
      socket
      |> assign(theme: theme)

    Messaging.notify_subscribers({theme, socket.id}, "theme", :theme_change)

    {:noreply, socket}
  end

  def handle_info({:theme_change, {theme, socketId}}, socket) do
    old_theme = socket.assigns.theme
    socket =
      socket
      |> assign(theme: theme)
      |> push_event("theme-toggled", %{
        theme: theme
      })
    Portfolio.ThemeState.update(theme)
    socket = if socketId !== socket.id and old_theme !== theme do
      put_flash(socket, :info, "Someone updated the theme")
    else
      socket
    end

    {:noreply, socket}
  end

  def handle_info(%Broadcast{event: "presence_diff"} = _event, socket) do
    {live_reading, live_visitors} = Presence.get_active_list()

    socket =
      socket
      |> assign(live_reading: live_reading)
      |> assign(live_visitors: live_visitors)
    {:noreply, socket}
  end
end
