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
          class="flex justify-center items-center text-center md:min-h-[50px] md:min-w-[100px] min-h-[50px] min-w-[100px] bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
        >
          戻る
        </.link>

        <p class="hidden md:block text-black opacity-[10%]">大画面モード</p>
        <p class="md:hidden text-black opacity-[10%]">小画面モード</p>

      </div>

      <!--カテゴリ名 -->
      <div class="w-full flex justify-center mb-2">
        <div class="flex flex-col bg-yellow-100 border shadow-sm rounded-xl dark:bg-gray-800 dark:border-gray-700 dark:shadow-slate-700/[.7]">
          <div class="bg-yellow-200 border-b rounded-t-xl py-1 px-4 md:py-4 md:px-5 dark:bg-gray-800 dark:border-gray-700">
            <p class="mt-1 text-sm text-gray-500 dark:text-gray-500">
              カテゴリー
            </p>
          </div>
          <div class="p-3 md:p-5">
            <h3 class="text-xl text-center text-gray-800 dark:text-white">
              <%= "#{@category.name}" %>
            </h3>
          </div>
        </div>
      </div>

      <%= if @algorithms_list_sm != [] && @algorithms_list_md != [] do %>
        <!-- 検索フォーム -->
        <.form
          :let={form}
          for={}
          phx-submit="search_by_keyword"
          class="w-full"
        >
          <div class="w-screen flex justify-center items-center">
            <label for="hs-trailing-button-add-on-with-icon" class="sr-only">Label</label>
            <div class="flex rounded-md shadow-sm">
              <.input type="text" field={form[:keyword]} id="hs-trailing-button-add-on-with-icon"
                class="text-xl px-4 block  max-h-[50px] md:min-w-[400px] md:max-h-[50px] border-gray-200 shadow-sm rounded-l-md text-sm focus:z-10 focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
                placeholder="単語で検索"
              />
              <.button
                class="max-h-[50px] md:max-h-[50px] md:min-w-[80px] inline-flex flex-shrink-0 justify-center items-center h-[2.875rem] w-[2.875rem] rounded-r-md border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-sm"
              >
                <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                  <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                </svg>
              </.button>
            </div>
          </div>
        </.form>

        <!-- ソート -->
        <div class="flex justify-center items-center my-1">
          <div class="hs-dropdown relative inline-flex">
            <!-- ソート ボタン -->
            <button id="hs-dropdown-default" type="button" class="hs-dropdown-toggle py-3 px-4 inline-flex justify-center items-center gap-2 rounded-md border font-medium bg-white text-gray-700 shadow-sm align-middle hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-white focus:ring-blue-600 transition-all text-sm dark:bg-slate-900 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400 dark:hover:text-white dark:focus:ring-offset-gray-800">
              ソート
              <svg class="hs-dropdown-open:rotate-180 w-2.5 h-2.5 text-gray-600" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M2 5L8.16086 10.6869C8.35239 10.8637 8.64761 10.8637 8.83914 10.6869L15 5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </button>


            <div
              class="hs-dropdown-menu bg-white absolute left-[100px]  transition-[opacity,margin] duration-[10.1ms] hs-dropdown-open:opacity-100 opacity-0 max-w-max z-10 mt-2  shadow-md rounded-lg p-2 dark:bg-gray-800 dark:border dark:border-gray-700 dark:divide-gray-700 transform -translate-x-1/2"
              aria-labelledby="sort-dropdown"
              style="background-image: url('/images/gahag-0017080331.png'); background-size: cover; background-position: center; position: absolute; top: 0; left: 0; width: 100%; height: auto; margin: 0; overflow: hidden;"
            >
              <div class="flex">
                <!-- ソート リスト -->
                <ul>
                  <li
                    class="flex items-center mb-2 gap-x-3.5 py-2 px-3 text-md text-gray-800 bg-white hover:bg-yellow-100 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="name"
                    phx-value-order="asc"
                  >
                    名前
                  </li>
                  <li
                    class="flex items-center mb-2 gap-x-3.5 py-2 px-3 text-md text-gray-800 bg-white hover:bg-yellow-100 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="id"
                    phx-value-order="asc"
                  >
                    ID
                  </li>
                  <li
                    class="flex items-center gap-x-3.5 py-2 px-3 text-md text-gray-800 bg-white hover:bg-yellow-100 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="bookmark"
                    phx-value-order="desc"
                  >
                    ブックマーク順
                  </li>
                </ul>
                <!-- 反転 -->
                <ul>
                  <li
                    class="max-w-max flex mb-2 items-center gap-x-3.5 py-2 px-3 text-md text-white bg-red-500 hover:bg-red-300 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="name"
                    phx-value-order="desc"
                  >
                    反転
                  </li>
                  <li
                    class="max-w-max flex mb-2 items-center gap-x-3.5 py-2 px-3  text-md text-white bg-red-500 hover:bg-red-300 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="id"
                    phx-value-order="desc"
                  >
                    反転
                  </li>
                  <li
                    class="max-w-max flex items-center gap-x-3.5 py-2 px-3  text-md text-white bg-red-500 hover:bg-red-300 focus:ring-2 focus:ring-blue-500 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-gray-300"
                    phx-click="sort_list"
                    phx-value-key="bookmark"
                    phx-value-order="asc"
                  >
                    反転
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      <% end %>

      <!-- PrevとNext sm -->
      <%= if Enum.count(@algorithms_list_sm) != 0 do %>
        <div class="flex justify-center mb-2 md:hidden">
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
        <div class="flex justify-center items-center  text-cneter rounded-md shadow-sm  hidden md:block w-full">

          <div class=" flex justify-center items-center text-center w-full">

            <!-- Prev ボタン -->
            <%= if @index_md != 0 do %>
              <button type="button" phx-click="change_index_md" phx-value-diff="-1" class="w-[120px] h-[50px] h-full py-3 px-4  inline-flex justify-center items-center first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-green-200 text-gray-700 align-middle hover:bg-green-300 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
                Prev
              </button>
            <% else %>
              <button type="button" disabled class="bg-gray-200 w-[120px] h-[50px] opacity-[70%]  py-3 px-4 inline-flex justify-center items-center  first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-white text-gray-700 align-middle focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">

              </button>
            <% end %>

            <!-- Index -->
            <div class="w-[120px] h-[50px] inline-flex flex justify-center items-center bg-white">
              <%= "#{@index_md + 1}ページ目" %>
            </div>

            <!-- Next ボタン -->
            <%= if @index_md < Enum.count(@algorithms_list_md) - 1 do %>
              <button type="button" phx-click="change_index_md" phx-value-diff="1" class="w-[120px] h-[50px] py-3 px-4 inline-flex justify-center items-center   first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-blue-200 text-gray-700 align-middle hover:bg-blue-300 focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
                Next
              </button>
            <% else %>
              <button type="button" disabled class="bg-gray-200 w-[120px] h-[50px] opacity-[70%]  py-3 px-4 inline-flex justify-center items-center   first:rounded-l-lg first:ml-0 last:rounded-r-lg border font-medium bg-white text-gray-700 align-middle focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 transition-all text-sm dark:bg-gray-800 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400">
              </button>
            <% end %>
          </div>
        </div>
      <% end %>

      <!-- カテゴリー一覧 -->
      <%= if Enum.count(@algorithms_list_sm) == 0 do %>
        <div class="flex flex-col justify-center items-center">
          <div class="m-3 max-w-max text-center text-xl p-3 rounded-lg border border-gray-500 shadow-lg bg-white">
            <p>登録されていません。</p>
            <p class="text-right text-sm text-gray-500">by tanuki</p>
          </div>
          <img class=""
            src={~p"/images/たぬ(素材).png"}
            style="max-width:30%; max-height:30%; object-fit:contain;"
            alt="Image Description"
          >
        </div>
      <% else %>
        <!-- スマホ用(5つ) -->
        <div class="flex justify-center block md:hidden">
          <ul class="max-w-xs flex flex-col w-full px-2 ">
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

        <ul class="w-full text-center hidden md:flex flex-col m-2">
        <%= for algorithm <- Enum.at(@algorithms_list_md, @index_md) do %>
          <li class="flex justify-center items-cetner min-w-[50px] max-h-max mb-1">
              <.link
                href={~p"/category/#{@category_id}/algorithm/#{algorithm.id}"}
                class="block w-[60%] bg-yellow-500 cursor-pointer rounded-lg bg-primary-100 p-4 text-primary-600 text-center text-xl flex justify-center items-cetner gap-x-2"
              >
                <p class="flex justify-center items-cetner"><%= algorithm.name %></p>
                <%= if algorithm.is_bookmark do %>
                  <img src={~p"/images/スターの枠アイコン(たぬ).png"}
                    class="bookmark max-h-[30px] max-w-[30px] inline-flex "
                    alt="星"
                  />
                <% end %>
              </.link>

          </li>
        <% end %>
      </ul>


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
      |> Enum.map(fn a -> Map.put(a, :added_date, Bookmarks.get_date(a.id)) end)

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

  # アルゴリズムリストをソート
  def handle_event("sort_list", %{"key" => key, "order" => order}, socket) do

    sorted_algorithms_list_sm = socket.assigns.algorithms_list_sm
      |> List.flatten
      |> Enum.sort(
          case order do
            "asc" ->
              case key do
                "name"     -> &(&1.name <= &2.name)
                "id"       -> &(&1.id <= &2.id)
                "bookmark" -> &(&1.added_date <= &2.added_date)
              end
            "desc" ->
              case key do
                "name"     -> &(&1.name >= &2.name)
                "id"       -> &(&1.id >= &2.id)
                "bookmark" -> &(&1.added_date >= &2.added_date)
              end
          end)
      |> Enum.chunk_every(5)

    sorted_algorithms_list_md = socket.assigns.algorithms_list_md
    |> List.flatten
    |> Enum.sort(
      case order do
        "asc" ->
          case key do
            "name"     -> &(&1.name <= &2.name)
            "id"       -> &(&1.id <= &2.id)
            "bookmark" -> &(&1.added_date <= &2.added_date)
          end
        "desc" ->
          case key do
            "name"     -> &(&1.name >= &2.name)
            "id"       -> &(&1.id >= &2.id)
            "bookmark" -> &(&1.added_date >= &2.added_date)
          end
      end)
    |> Enum.chunk_every(10)


    {:noreply, assign(socket,
      algorithms_list_sm: sorted_algorithms_list_sm,
      algorithms_list_md: sorted_algorithms_list_md
    )}

  end
end
