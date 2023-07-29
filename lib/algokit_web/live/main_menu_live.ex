defmodule AlgokitWeb.MainMenuLive do
  alias Algokit.Algorithms
  use AlgokitWeb, :live_view
  alias Algokit.Categories

  def render(assigns) do
    ~H"""
      <p class="text-xl">メイン画面</p>

      <!-- 各種カテゴリへのリンク -->
      <div class="grid grid-cols-3 gap-3 p-4">
        <%= for category <- @categories do %>
          <.link class="block rounded-lg bg-blue-400 hover:bg-blue-500 text-white font-medium text-center py-3 min-h-[100px]" href={~p"/category/#{category.id}"}><%= category.name %></.link>
        <% end %>
      </div>

      <!-- 最近閲覧したものを表示 -->
      <p>閲覧履歴</p>
      <%= if @sorted_algorithms != nil do %>
        <ul>
          <%= for algorithm <- @sorted_algorithms do %>
            <li>
              <.link href={~p"/category/#{algorithm.category_id}/algorithm/#{algorithm.id}"}>
                <%= algorithm.name %>:<%= "#{algorithm.last_viewed_date.year}年#{algorithm.last_viewed_date.month}月#{algorithm.last_viewed_date.day}日" %>
              </.link>
            </li>
          <% end %>
        </ul>
      <% end %>
    """
  end

  def mount(_params, _session, socket) do
    categories = Categories.list_categories()
    sorted_algorithms = Algorithms.fetch_recent_last_viewed_date()

    {:ok, assign(socket,
      categories: categories,
      sorted_algorithms: sorted_algorithms
    )}
  end
end
