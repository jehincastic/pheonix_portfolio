defmodule Portfolio.ThemeState do
  use GenServer

  @name __MODULE__

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def get(), do: GenServer.call(@name, :theme)

  def update(theme), do: GenServer.cast(@name, {:update_theme, theme})

  @impl true
  def init(nil) do
    {:ok, "light"}
  end

  @impl true
  def handle_call(:theme, _from, theme) do
    {:reply, theme, theme}
  end

  @impl true
  def handle_cast({:update_theme, new_theme}, _old_theme) do
    {:noreply, new_theme}
  end
end
