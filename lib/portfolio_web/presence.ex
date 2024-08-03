defmodule PortfolioWeb.Presence do
  alias Portfolio.Messaging
  use Phoenix.Presence,
    otp_app: :portfolio,
    pubsub_server: Portfolio.PubSub

  @presence_key "live_reading"
  @presence_topic "active_users"

  @self __MODULE__

  def start(page) do
    Messaging.subscribe(@presence_topic)
    {:ok, _ref} = @self.track(self(), @presence_topic, @presence_key, %{"current_page" => page})
  end

  def get_active_list() do
    case @self.list(@presence_topic) do
      %{@presence_key => %{metas: list}} -> parse_list(list)
      _other -> {0, []}
    end
  end

  defp parse_list(list) do
    page_map = %{
      "landing" => "Home",
      "not_found" => "Not Found",
      "portfolio" => "Portfolio",
      "timeline" => "Timeline",
    }
    updated_list =
      list
      |> Enum.reduce(%{}, fn(%{"current_page" => current_page}, acc) ->
        acc
        |> Map.update(
          current_page,
          %{"count" => 1, "page" => page_map[current_page]},
          fn(%{"count" => count, "page" => current_page}) ->
            %{"count" => count + 1, "page" => current_page}
          end
        )
      end)
      |> Map.values()
      |> Enum.sort(&(&1["count"] >= &2["count"]))
    {Enum.count(list), updated_list}
  end
end
