defmodule AlgokitWeb.MainMenuLive do
  alias Algokit.Algorithms
  use AlgokitWeb, :live_view
  alias Algokit.Categories

  def render(assigns) do
    ~H"""
      <!-- ヘッダー -->
      <header class="h-[12%] py-3 w-full border-b border-gray-300">
        <p class="text-3xl font-bold text-center text-indigo-600 ">Algokit</p>
        <p class="text-base text-center">〜ゲーム制作支援アルゴリズム手帳〜</p>
      </header>

      <!-- カテゴリ選択グリッド -->
      <%= if Enum.count(@categories) == 0 do %>
        <p>登録されていません。</p>
      <% else %>
        <div class="flex h-[5%]">
          <!-- prev -->
          <%= if @index == 0 do %>
            <div class="w-1/2 text-left pl-2"></div>
          <% else %>
            <button phx-click="change_index" phx-value-diff="-1" class="w-1/2 text-left pl-2">＜＜戻る</button>
          <% end %>
          <!-- next -->
          <%= if @index >= Enum.count(@categories) - 1 do %>
            <div class="w-1/2 text-right pr-2"></div>
          <% else %>
            <button phx-click="change_index" phx-value-diff="1" class="w-1/2 text-right pr-2">進む＞＞</button>
          <% end %>
        </div>

        <!-- 各種カテゴリへのリンクグリッド -->
        <div class="grid grid-cols-3 gap-2 p-3 border-b border-gray-300 h-[55%] bg-green-100">
          <%= for category <- Enum.at(@categories, @index) do %>
            <.link class="block rounded-lg bg-blue-400 hover:bg-blue-500 text-white font-medium text-center py-3 min-h-[100px] max-h-[30%]" href={~p"/category/#{category.id}"}><%= category.name %></.link>
          <% end %>
        </div>
      <% end %>

      <!-- 最近閲覧したものを表示 -->
      <p>閲覧履歴</p>
      <%= if @sorted_algorithms != nil do %>
        <div class="ax-w-xs flex flex-col max-h-[28%] overflow-hidden">
            <%= for algorithm <- @sorted_algorithms do %>
                <.link href={~p"/category/#{algorithm.category_id}/algorithm/#{algorithm.id}"}
                  class="inline-flex items-center gap-x-3.5 py-3 px-4 text-sm font-medium border text-blue-600 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 dark:border-gray-700"
                >
                  <%= algorithm.name %>:<%= "#{algorithm.last_viewed_date.year}年#{algorithm.last_viewed_date.month}月#{algorithm.last_viewed_date.day}日" %>
                </.link>
            <% end %>
        </div>
      <% else %>
        <p>履歴なし</p>
      <% end %>
      <!--
      <p>閲覧履歴</p>
      <%= if @sorted_algorithms != nil do %>
        <div class="mx-auto max-w-lg bg-red-200 buttom-0 h-[25%]">
          <ul class="bg-white divide-y divide-gray-200 rounded-xl border border-gray-200 shadow-sm">
            <%= for algorithm <- @sorted_algorithms do %>
              <li class="p-2">
                <.link href={~p"/category/#{algorithm.category_id}/algorithm/#{algorithm.id}"} class="text-gray-500">
                  <%= algorithm.name %>:<%= "#{algorithm.last_viewed_date.year}年#{algorithm.last_viewed_date.month}月#{algorithm.last_viewed_date.day}日" %>
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
      <% else %>
        <p>履歴なし</p>
      <% end %>
      -->
    """
  end

  def mount(_params, _session, socket) do
    categories =
      Categories.list_categories()
      |> Enum.chunk_every(9)


    sorted_algorithms = Algorithms.fetch_recent_last_viewed_date()

    {:ok, assign(socket,
      categories: categories,
      index: 0,
      sorted_algorithms: sorted_algorithms
    )}
  end

  def handle_event("change_index", %{"diff" => diff}, socket) do
    {:noreply, assign(socket,
      index: socket.assigns.index + String.to_integer(diff)
    )}
  end
end
