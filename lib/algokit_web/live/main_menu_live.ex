defmodule AlgokitWeb.MainMenuLive do
  use AlgokitWeb, :live_view
  alias Algokit.Categories

  def render(assigns) do
    ~H"""
    <div class="h-full w-full">
      <p class="text-xl">メイン画面</p>

      <div class="grid grid-cols-3 gap-4">
          <%= for category <- @categories do %>
            <!-- <button phx-click="select_category" phx-value-category_id={category.id} class="bg-blue-200 p-4"><%= category.name %></button> -->
            <.link class="bg-blue-200 p-4" href={~p"/category/#{category.id}"}><%= category.name %></.link>
          <% end %>
        </div>



      <.link
        href={~p"/detail"}
      >
      詳細ページ
      </.link>

      <p>最近表示したもの</p>
      <ul>
        <li>アレ</li>
      </ul>

    </div>
    """
  end

  def mount(_params, _session, socket) do
    categories = Categories.list_categories()
    {:ok, assign(socket,
      categories: categories
    )}
  end
end
