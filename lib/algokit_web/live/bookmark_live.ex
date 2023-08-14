defmodule AlgokitWeb.BookmarkLive do
  use AlgokitWeb, :live_view
  alias Algokit.Bookmarks
  require Logger

  def render(assigns) do
    ~H"""
      <div class="flex justify-between py-2 px-2 align_bottom">
        <.link
          href={
            cond do
              @algorithm_id && @category_id -> ~p"/category/#{@category_id}/algorithm/#{@algorithm_id}"
              @category_id -> ~p"/category/#{@category_id}"
              true -> ~p"/"
            end
          }
          class="flex justify-center items-center text-center h-[50px] w-[100px] md:max-h-[80px] md:min-w-[140px] bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
        >
          戻る
        </.link>

        <p class="hidden md:block text-black opacity-[10%]">大画面モード</p>
        <p class="md:hidden text-black opacity-[10%]">小画面モード</p>

      </div>


      <p class="text-2xl text-center my-2">ブックマーク一覧</p>
      <%= if Enum.count(@bookmarks) == 0 do%>
        <div class="flex justify-center">
          <div class="p-2 md:min-w-[70%] flex flex-col overflow-hidden">
            <p
              class="inline-flex items-center justify-between gap-x-2 py-3 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white"
            >ないよ</p>
          </div>
        </div>
      <% else %>
      <div class="flex justify-center">
        <div class="p-2 md:min-w-[70%] flex flex-col overflow-hidden">
          <%= for bookmark <- @bookmarks do%>
            <.link
              href={~p"/category/#{bookmark.algorithm.category_id}/algorithm/#{bookmark.algorithm_id}"}
              class="inline-flex items-center justify-between gap-x-2 py-3 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white"
            >
              <div >
                <p class="text-xs text-blue-500">名前</p>
                <p class=""><%= bookmark.algorithm.name %></p>
              </div>
              <div class="hidden">
                <p class="text-xs text-blue-500">カテゴリ</p>
                <p><%= bookmark.algorithm.category.name %></p>
              </div>
              <div>
                <p class="text-xs text-blue-500">登録日</p>
                <p><%= bookmark.added_date %></p>
              </div>
            </.link>
          <% end %>
        </div>
      </div>
      <% end %>
    """
  end

  # detailから
  def mount(%{"category_id" => category_id, "algorithm_id" => algorithm_id}, _session, socket) do

    Logger.info("Mounted from DetailLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    {:ok, assign(socket,
      category_id: String.to_integer(category_id),
      algorithm_id: String.to_integer(algorithm_id),
      bookmarks: bookmarks
    )}
  end

  # sub_menuから
  def mount(%{"category_id" => category_id}, _session, socket) do

    Logger.info("Mounted from SubMenuLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    {:ok, assign(socket,
      category_id: String.to_integer(category_id),
      algorithm_id: nil,
      bookmarks: bookmarks
    )}
  end

  # menuから
  def mount(%{}, _session, socket) do

    Logger.info("Mounted from MainMenuLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    {:ok, assign(socket,
      category_id: nil,
      algorithm_id: nil,
      bookmarks: bookmarks
    )}
  end

  # ブックマークボタンを押しても何もしない
  def handle_event("visit_bookmark", _value, socket) do
    {:noreply, socket}
  end

  # infoから終了ボタンを押す
  def handle_event("exit_app", _value, socket) do
    Logger.info("exit app.")
    Desktop.Window.quit()
    {:noreply, socket}
  end

end
