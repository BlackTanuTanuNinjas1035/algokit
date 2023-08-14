defmodule AlgokitWeb.SubMenuLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Categories
  alias Algokit.Bookmarks
  require Logger

  def render(assigns) do
    ~H"""
      <div class="flex justify-between py-2 px-2 align_bottom">
        <.link
        href={~p"/"}
          class="flex justify-center items-center text-center min-[500px]:min-h-[80px] min-[500px]:min-w-[160px] max-[500px]:min-h-[50px] max-[500px]:min-w-[100px] bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
        >
          戻る
        </.link>

      </div>

      <!--カテゴリ名 -->
      <div class="max-[500px]:w-full flex justify-center mb-2">
        <div class="flex flex-col bg-yellow-100 border shadow-sm rounded-xl dark:bg-gray-800 dark:border-gray-700 dark:shadow-slate-700/[.7]">
          <div class="bg-yellow-200 border-b rounded-t-xl py-3 px-4 md:py-4 md:px-5 dark:bg-gray-800 dark:border-gray-700">
            <p class="mt-1 text-sm text-gray-500 dark:text-gray-500">
              カテゴリー
            </p>
          </div>
          <div class="p-4 md:p-5">
            <h3 class="text-2xl text-center text-gray-800 dark:text-white">
              <%= "#{@category.name}" %>
            </h3>
          </div>
        </div>
      </div>

      <!-- 検索フォーム -->
      <.form
        :let={f}
        phx-submit="search_by_keyword"
        class="max-[500px]:w-full"
      >
        <div class="mb-2 w-screen flex justify-center items-center">
          <label for="hs-trailing-button-add-on-with-icon" class="sr-only">Label</label>
          <div class="flex rounded-md shadow-sm">
            <.input type="text" field={f[:keyword]} id="hs-trailing-button-add-on-with-icon"
              class="text-xl px-4 block  max-[500px]:min-h-[50px] min-[500px]:min-w-[400px] min-[500px]:min-h-[80px] border-gray-200 shadow-sm rounded-l-md text-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
              placeholder="単語で検索"
            />
            <.button
              class="max-[500px]:min-h-[50px] min-[500px]:min-h-[80px] min-[500px]:min-w-[80px] inline-flex flex-shrink-0 justify-center items-center h-[2.875rem] w-[2.875rem] rounded-r-md border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-sm"
            >
              <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
              </svg>
            </.button>
          </div>
        </div>
      </.form>

      <!-- PrevとNext sm -->
      <%= if Enum.count(@algorithms_list_sm) != 0 do %>
        <div class="flex justify-center mb-2 min-[500px]:hidden">
          <div class="bg-white justify-center inline-flex -space-x-0 divide-x divide-gray-300 overflow-hidden rounded-lg border border-gray-300 shadow-sm">
            <%= if @index_sm != 0 do %>
              <button type="button" phx-click="change_index_sm" phx-value-diff="-1" class="bg-green-200 px-6 py-3 text-center text-base font-medium text-secondary-700 hover:bg-green-300">Prev</button>
            <% else %>
              <button type="button" class="opacity-[30%] px-6 py-3 text-center text-base font-medium text-secondary-700" disabled>Prev</button>
            <% end %>
            <span class="px-6 py-3 text-center text-base font-medium text-secondary-700"><%= "#{@index_sm + 1}ページ目" %> </span>
            <%= if @index_sm < Enum.count(@algorithms_list_sm) - 1 do %>
              <button type="button" phx-click="change_index_sm" phx-value-diff="1" class="bg-blue-200 px-6 py-3 text-center text-base font-medium text-secondary-700 hover:bg-blue-300">Next</button>
            <% else %>
              <button type="button" class="opacity-[30%] px-6 py-3 text-center text-base font-medium text-secondary-700" disabled>Next</button>
            <% end %>
          </div>
        </div>
      <% end %>

      <!-- PrevとNext md -->
      <%= if Enum.count(@algorithms_list_md) != 0 do %>
        <div class="inline-flex rounded-md shadow-sm w-full justify-between min-h-[80px] max-[500px]:hidden px-2">
          <!-- Prev ボタン -->
          <%= if @index_md != 0 do %>
            <button type="button" phx-click="change_index_md" phx-value-diff="-1" class="w-[30%] py-3 px-4 inline-flex justify-center items-center gap-2 -ml-px first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-green-200 text-gray-700 align-middle hover:bg-green-300 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
              Prev
            </button>
          <% else %>
            <button type="button" disabled class="opacity-[30%] w-[30%] py-3 px-4 inline-flex justify-center items-center gap-2 -ml-px first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-white text-gray-700 align-middle focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">

            </button>
          <% end %>

          <!-- Index -->
          <div class="w-[40%] py-3 px-4 inline-flex justify-center items-center gap-2 -ml-px first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-white text-gray-700 align-middle focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
            <%= "#{@index_md + 1}ページ目" %>
          </div>

          <!-- Next ボタン -->
          <%= if @index_md < Enum.count(@algorithms_list_md) - 1 do %>
            <button type="button" phx-click="change_index_md" phx-value-diff="1" class="w-[30%] py-3 px-4 inline-flex justify-center items-center gap-2 -ml-px first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-blue-200 text-gray-700 align-middle hover:bg-blue-300 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
              Next
            </button>
          <% else %>
            <button type="button" disabled class="opacity-[30%] w-[30%] py-3 px-4 inline-flex justify-center items-center gap-2 -ml-px first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-white text-gray-700 align-middle focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
            </button>
          <% end %>
        </div>
      <% end %>

      <!-- カテゴリー一覧 -->
      <%= if Enum.count(@algorithms_list_sm) == 0 do %>
        <p class="text-center">登録されていません。</p>
      <% else %>
        <!-- スマホ用(5つ) -->
        <div class="flex justify-center">
          <ul class="max-w-xs flex flex-col w-full px-2 min-[500px]:hidden">
            <%= for algorithm <- Enum.at(@algorithms_list_sm, @index_sm) do %>
              <li class="inline-flex items-center gap-x-2 py-3 px-4 text-sm font-medium bg-white hover:bg-gray-100 border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">
                <.link
                  href={~p"/category/#{@category_id}/algorithm/#{algorithm.id}"}
                  class="block w-full cursor-pointer rounded-lg bg-primary-100 p-4 text-primary-600 text-center"
                >
                  <%= algorithm.name %>
                </.link>
                <%= if algorithm.is_bookmark do %>
                  <img src={~p"/images/スターの枠アイコン(たぬ).png"}
                    class="bookmark max-h-[50px] max-w-[50px] max-w-[50px]"
                    alt="星"
                  />
                <% end %>
              </li>
            <% end %>
          </ul>
        </div>

        <!-- 横画面以上用(10) -->
        <div class="flex justify-center max-[500px]:hidden">
          <ul class="max-w-[80%] flex flex-col w-full px-2 ">
            <%= for algorithm <- Enum.at(@algorithms_list_md, @index_md) do %>
              <li class="inline-flex items-center gap-x-2 py-3 px-4 text-sm font-medium bg-white border text-gray-800 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white">

                <.link
                  href={~p"/category/#{@category_id}/algorithm/#{algorithm.id}"}
                  class="block w-full cursor-pointer rounded-lg bg-primary-100 p-4 text-primary-600 text-center text-3xl"
                >
                  <%= algorithm.name %>
                </.link>
                <%= if algorithm.is_bookmark do %>
                  <img src={~p"/images/スターの枠アイコン(たぬ).png"}
                    class="bookmark  max-h-[80px] max-w-[80px]"
                    alt="星"
                  />
                <% end %>
              </li>
            <% end %>
          </ul>
        </div>
      <% end %>
    """
  end

  def mount(%{"category_id" => category_id}, _session, socket) do
    category_id = String.to_integer(category_id)

    category = Categories.get(category_id)

    algorithms_list =
      category_id
      |> Algorithms.list_algorithms_by_category_id()
      |> Enum.map(fn a -> Map.put(a, :is_bookmark, Bookmarks.exists_bookmark?(a.id)) end)

    # スマホ用
    algorithms_list_sm =
      algorithms_list
      |> Enum.chunk_every(5)

    # 横画面以上用
    algorithms_list_md =
      algorithms_list
      |> Enum.chunk_every(10)

      Logger.info("Mounted SubMenuLive.")

    {:ok, assign(socket,
      category_id: category_id,
      category: category,
      index_sm: 0,
      index_md: 0,
      algorithms_list_sm: algorithms_list_sm,
      algorithms_list_md: algorithms_list_md
    )}
  end

  # 縦画面用
  def handle_event("change_index_sm", %{"diff" => diff}, socket) do
    {:noreply, assign(socket,
      index_sm: socket.assigns.index_sm + String.to_integer(diff)
    )}
  end

  # 横画面用
  def handle_event("change_index_md", %{"diff" => diff}, socket) do
    {:noreply, assign(socket,
      index_md: socket.assigns.index_md + String.to_integer(diff)
    )}
  end

  # 単語を入力して検索
  def handle_event("search_by_keyword", %{"keyword" => keyword}, socket) do

    algorithms_list_sm =
      Algorithms.search_name_with_keywords(socket.assigns.category_id, keyword)
      |> Enum.map(fn a -> Map.put(a, :is_bookmark, Bookmarks.exists_bookmark?(a.id)) end)
      |> Enum.chunk_every(5)

    algorithms_list_md =
      Algorithms.search_name_with_keywords(socket.assigns.category_id, keyword)
      |> Enum.map(fn a -> Map.put(a, :is_bookmark, Bookmarks.exists_bookmark?(a.id)) end)
      |> Enum.chunk_every(10)


    {:noreply, assign(socket,
      algorithms_list_sm: algorithms_list_sm,
      algorithms_list_md: algorithms_list_md,
      index_sm: 0,
      index_md: 0
    )}
  end

  # ブックマークボタンに移動
  def handle_event("visit_bookmark", _value, socket) do
    Logger.info("visit /category/:category_id/bookmark route.")
    {:noreply, push_navigate(socket, to: ~p"/category/#{socket.assigns.category_id}/bookmark")}
  end

  # infoから終了ボタンを押す
  def handle_event("exit_app", _value, socket) do
    Logger.info("exit app.")
    Desktop.Window.quit()
    {:noreply, socket}
  end
end
