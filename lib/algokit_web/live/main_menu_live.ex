defmodule AlgokitWeb.MainMenuLive do
  use AlgokitWeb, :live_view
  alias Algokit.Categories
  alias Algokit.Algorithms
  require Logger

  def render(assigns) do
    ~H"""
      <!-- ヘッダー -->
      <header class="py-3 w-full border-b border-gray-300">
        <p class="text-3xl font-bold text-center text-indigo-600"
          style="text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);"
        >
          Algokit
        </p>
        <p class="text-base text-center">〜ゲーム制作支援アルゴリズム手帳〜</p>
      </header>

      <!-- 最近閲覧したものを表示 -->
      <p class="text-center text-2xl my-2">閲覧履歴</p>
      <%= if @sorted_algorithms != nil do %>
        <div class="flex items-center justify-center px-2">
          <div
            class="w-full min-[500px]:p-4 max-[500px]:p-2  flex flex-col overflow-hidden min-[500px]:max-w-[80%] rounded-lg shadow-lg"
            style="background-image: url('/images/free-texture.net/CorkBoard02.jpg'); background-size: cover;"
          >
            <%= for algorithm <- @sorted_algorithms do %>
              <.link
                href={~p"/category/#{algorithm.category_id}/algorithm/#{algorithm.id}"}
                class="inline-flex  max-[500px]:justify-between items-center gap-x-2 py-3 px-4 text-sm font-medium bg-white hover:bg-gray-100 border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white"
              >
                <p class="min-[500px]:w-1/3 min-[500px]:text-base  text-left"><%= algorithm.name %></p>
                <p class="max-[500px]:hidden min-[500px]:w-1/3 text-center text-base"><%= algorithm.category.name %></p>
                <p class="min-[500px]:text-base min-[500px]:w-1/3 text-right"><%= "#{algorithm.last_viewed_date.year}年#{algorithm.last_viewed_date.month}月#{algorithm.last_viewed_date.day}日" %></p>
              </.link>
            <% end %>
          </div>
        </div>
      <% else %>
        <p>履歴なし</p>
      <% end %>

      <p class="text-2xl text-center my-2">カテゴリー一覧</p>
      <!-- カテゴリ選択 -->
      <%= if Enum.count(@categories) == 0 do %>
        <p class="text-center">登録されていません。</p>
      <% else %>
        <!-- カテゴリー一覧 -->
        <div class="flex items-center justify-center px-2">
          <div class="p-2 min-[500px]:grid min-[500px]:grid-cols-3 min-[500px]:gap-2 bg-gray-200 min-[500px]:min-w-[80%] max-[500px]:w-full">
            <%= for category <- @categories_all do %>
              <!-- カテゴリー -->
              <div class="shadow-md hover:bg-gray-100 flex items-center gap-x-2 py-3 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
                  <.link
                    class="flex justify-between w-full"
                    href={~p"/category/#{category.id}"}
                  >
                    <%= category.name %>
                    <span class="inline-flex items-center py-1 px-2 rounded-full text-xs font-medium bg-blue-500 text-white h-auto"
                    >
                      <%= category.count %>
                    </span>
                  </.link>
              </div>
            <% end %>
          </div>
        </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    categories =
      Categories.list_categories()
      |> Enum.map(fn c -> Map.put(c, :count, Algorithms.count_by_category(c.id)) end)

    sorted_algorithms = Algorithms.fetch_recent_last_viewed_date()

    Logger.info("Mounted ManMenuLive.")
    {:ok, assign(socket,
      categories: categories |> Enum.chunk_every(9),
      categories_all: categories,
      index: 0,
      sorted_algorithms: sorted_algorithms
    )}
  end

  # ブックマークボタンに移動
  def handle_event("visit_bookmark", _value, socket) do
    Logger.info("visit /bookmark route.")
    {:noreply, push_navigate(socket, to: ~p"/bookmark")}
  end

  # infoから終了ボタンを押す
  def handle_event("exit_app", _value, socket) do
    Logger.info("exit app.")
    Desktop.Window.quit()
    {:noreply, socket}
  end

end
