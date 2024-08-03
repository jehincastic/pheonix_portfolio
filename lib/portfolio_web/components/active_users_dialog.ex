defmodule PortfolioWeb.ActiveUsersDialogComponent do
  use PortfolioWeb, :live_component
  alias PortfolioWeb.{Presence}

  def mount(socket) do
    {:ok, assign(socket, open: false)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div
        :if={@live_reading !== 0}
        class="fixed bottom-3 right-3 z-50 flex h-2 items-center justify-center rounded-full bg-gray-800 dark:bg-white p-3 font-mono text-xs text-white dark:text-gray-800 cursor-pointer"
        phx-click="open"
        phx-target={@myself}
      >
        <div class="flex items-center">
          <span><%= @live_reading %> active user(s)</span>
          <span class="relative flex h-2 w-2 ml-2">
            <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-green-400 opacity-75 duration-500"></span>
            <span class="relative inline-flex h-2 w-2 rounded-full bg-green-500"></span>
          </span>
        </div>
      </div>
      <dialog open={@open} class="relative z-[100]">
        <div class="fixed inset-0 bg-gray-500 dark:bg-gray-400 dark:bg-opacity-60 bg-opacity-75 transition-opacity"></div>
        <div class="fixed inset-0 z-[100] w-screen overflow-y-auto">
          <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
            <div class="text-black dark:text-white relative transform overflow-hidden rounded-lg bg-gray-100 dark:bg-gray-900 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
              <div class="px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                  <div class="mt-3 text-center flex-grow sm:ml-4 sm:mt-0 sm:text-left">
                    <div class="flex justify-between">
                      <h3 class="text-base font-semibold leading-6">
                        <%= @title %>
                      </h3>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        aria-hidden="true"
                        class="w-6 h-6 cursor-pointer"
                        phx-click="close"
                        phx-target={@myself}
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M6 18L18 6M6 6l12 12"
                        >
                        </path>
                      </svg>
                    </div>
                    <div class="relative overflow-x-auto py-2">
                      <table class="w-full text-sm text-left rtl:text-right border">
                        <thead class="text-xs uppercase border-b">
                          <tr>
                            <th scope="col" class="px-6 py-3 border-r">
                              Page
                            </th>
                            <th scope="col" class="px-6 py-3">
                              No of Active user(s)
                            </th>
                          </tr>
                        </thead>
                        <tbody>
                        <%= for user_info <- @live_visitors do %>
                          <tr>
                            <th
                              scope="row"
                              class="px-6 py-4 font-medium whitespace-nowrap border-r border-b"
                            >
                              <%= user_info["page"] %>
                            </th>
                            <td class="px-6 py-4 font-medium whitespace-nowrap border-b">
                              <%= user_info["count"] %>
                            </td>
                          </tr>
                        <% end %>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </dialog>
    </div>
    """
  end

  def handle_event("open", _params, socket) do
    socket =
      socket
      |> assign(open: true)
      |> assign(active_users: Presence.get_active_list())

      {:noreply, socket}
  end

  def handle_event("close", _params, socket) do
    socket =
      socket
      |> assign(open: false)
      |> assign(active_users: [])

    {:noreply, socket}
  end
end
