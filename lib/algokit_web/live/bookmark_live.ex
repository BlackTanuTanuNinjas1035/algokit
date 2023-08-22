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

      <div class="flex justify-center items-center">
        <div class="flex items-center justify-center p-3 m-2 bg-green-200 rounded-md shadow-md border border-green-400">
          <img src={~p"/images/スターの枠アイコン(たぬ).png"}
            class="bookmark max-h-[30px] max-w-[30px]"
            alt="星"
          />
          <p class="text-xl text-center my-2">ブックマーク一覧</p>
        </div>
      </div>

      <%= if @bookmarks_sm != [] && @bookmarks_md != [] do %>
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

        <!-- ソート ボタン -->
          <div class="w-full flex justify-center my-2">
          <div class="hs-dropdown relative inline-flex">
            <button id="sort_dropdown" type="button" class="hs-dropdown-toggle py-3 px-4 inline-flex justify-center items-center gap-2 rounded-md border font-medium bg-white text-gray-700 shadow-sm align-middle hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-white focus:ring-blue-600 transition-all text-sm dark:bg-slate-900 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400 dark:hover:text-white dark:focus:ring-offset-gray-800">
              ソート
              <svg class="hs-dropdown-open:rotate-180 w-2.5 h-2.5 text-gray-600" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M2 5L8.16086 10.6869C8.35239 10.8637 8.64761 10.8637 8.83914 10.6869L15 5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </button>

            <div
              class="hs-dropdown-menu transition-[opacity,margin] duration-[0.1ms] hs-dropdown-open:opacity-100 opacity-0 hidden z-10 mt-2 bg-white shadow-lg shadow-gray-500 rounded-lg p-2 dark:bg-gray-800 dark:border dark:border-gray-700 dark:divide-gray-700"
              aria-labelledby="sort_dropdown"
              style="background-image: url('/images/gahag-0017080331.png'); background-size: cover; background-position: center; position: absolute; top: 0; left: 0; height: auto; margin: 0; overflow: hidden;"
            >
              <div
                class="grid grid-cols-2 grid-rows-3 gap-y-2"
              >
                <button class="bg-white hover:bg-gray-100 text-xl p-3 shadow-md shadow-gray-400 rounded-l-md"
                  phx-click="sort_list"
                  phx-value-key="name"
                  phx-value-order="asc"
                >
                名前
                </button>
                <button class="col-span-1 text-xl bg-red-200 hover:bg-red-300 p-3 shadow-md shadow-gray-400 rounded-r-md"
                  phx-click="sort_list"
                  phx-value-key="name"
                  phx-value-order="desc"
                >
                  反転
                </button>
                <button class="bg-white hover:bg-gray-100 text-xl p-3 shadow-md shadow-gray-400 rounded-l-md"
                  phx-click="sort_list"
                  phx-value-key="id"
                  phx-value-order="asc"
                >
                  ID
                </button>
                <button class="col-span-1 text-xl bg-red-200 hover:bg-red-300 p-3 shadow-md shadow-gray-400 rounded-r-md"
                  phx-click="sort_list"
                  phx-value-key="id"
                  phx-value-order="desc"
                >
                  反転
                </button>
                <button class="bg-white hover:bg-gray-100 text-xl p-3 shadow-md shadow-gray-400 rounded-l-md"
                  phx-click="sort_list"
                  phx-value-key="bookmark"
                  phx-value-order="asc"
                >
                  ブックマーク
                </button>
                <button class="col-span-1 bg-red-200 hover:bg-red-300 text-xl p-3 shadow-md shadow-gray-400 rounded-r-md"
                  phx-click="sort_list"
                  phx-value-key="bookmark"
                  phx-value-order="desc"
                >
                  反転
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>

      <!-- PrevとNext sm -->
      <%= if Enum.count(@bookmarks_sm) != 0 do %>
        <div class="flex justify-center mb-2 md:hidden">
          <div class="bg-white justify-center inline-flex -space-x-0 divide-x divide-gray-300 overflow-hidden rounded-lg border border-gray-300 shadow-sm">
            <%= if @index_sm != 0 do %>
              <button type="button" phx-click="change_index_sm" phx-value-diff="-1" class="bg-green-200 px-6 py-3 text-center text-base font-medium text-secondary-700 hover:bg-green-300">Prev</button>
            <% else %>
              <button type="button" class="opacity-[30%] px-6 py-3 text-center text-base font-medium text-secondary-700" disabled>Prev</button>
            <% end %>
            <span class="px-6 py-3 text-center text-base font-medium text-secondary-700"><%= "#{@index_sm + 1}ページ目" %> </span>
            <%= if @index_sm < Enum.count(@bookmarks_sm) - 1 do %>
              <button type="button" phx-click="change_index_sm" phx-value-diff="1" class="bg-blue-200 px-6 py-3 text-center text-base font-medium text-secondary-700 hover:bg-blue-300">Next</button>
            <% else %>
              <button type="button" class="opacity-[30%] px-6 py-3 text-center text-base font-medium text-secondary-700" disabled>Next</button>
            <% end %>
          </div>
        </div>
      <% end %>

      <!-- PrevとNext md -->
      <%= if Enum.count(@bookmarks_md) != 0 do %>
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
            <%= if @index_md < Enum.count(@bookmarks_md) - 1 do %>
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
      <%= if Enum.count(@bookmarks_sm) == 0 do %>
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
            <%= for bookmark <- Enum.at(@bookmarks_sm, @index_sm) do %>
              <li class="gap-x-2 py-1 text-sm font-medium bg-white hover:bg-gray-100 border text-gray-800 first:rounded-t-lg first:mt-0 last:rounded-b-lg dark:bg-gray-800 dark:border-gray-700 dark:text-white ">
                <.link
                  href={~p"/category/#{bookmark.algorithm.category_id}/algorithm/#{bookmark.algorithm_id}"}
                  class="block w-full cursor-pointer rounded-lg bg-primary-100 p-2 text-primary-600 text-center flex justify-between"
                >
                  <div>
                    <p class="text-xs text-blue-400 text-left">アルゴリズム名</p>
                    <p><%= bookmark.algorithm.name %></p>
                  </div>
                  <div>
                    <p class="text-xs text-blue-400 text-left">登録日</p>
                    <p><%= bookmark.added_date %></p>
                  </div>
                </.link>
              </li>
            <% end %>
          </ul>
        </div>

        <ul class="w-full text-center hidden md:flex flex-col m-2">
        <%= for bookmark <- Enum.at(@bookmarks_md, @index_md) do %>
          <li class="flex justify-center items-cetner min-w-[50px] max-h-max mb-1">
              <.link
                href={~p"/category/#{bookmark.algorithm.category_id}/algorithm/#{bookmark.algorithm_id}"}
                class="block w-[60%] bg-yellow-500 cursor-pointer rounded-lg bg-primary-100 p-4 text-primary-600 text-center text-xl flex justify-center items-cetner gap-x-2 flex justify-between"
              >
                <div class="">
                  <p class="text-xs text-blue-400 text-left">アルゴリズム名</p>
                  <p><%= bookmark.algorithm.name %></p>
                </div>
                <div>
                  <p class="text-xs text-blue-400 text-left">登録日</p>
                  <p><%= bookmark.added_date %></p>
                </div>
              </.link>

          </li>
        <% end %>
      </ul>


      <% end %>
    """
  end

  # detailから
  def mount(%{"category_id" => category_id, "algorithm_id" => algorithm_id}, _session, socket) do

    Logger.info("Mounted from DetailLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    bookmarks_sm =
      bookmarks
      |> Enum.chunk_every(5)

    bookmarks_md =
      bookmarks
      |> Enum.chunk_every(10)
    {:ok, assign(socket,
      category_id: String.to_integer(category_id),
      algorithm_id: String.to_integer(algorithm_id),
      bookmarks_sm: bookmarks_sm,
      bookmarks_md: bookmarks_md,
      index_sm: 0,
      index_md: 0
    )}
  end

  # sub_menuから
  def mount(%{"category_id" => category_id}, _session, socket) do

    Logger.info("Mounted from SubMenuLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    bookmarks_sm =
      bookmarks
      |> Enum.chunk_every(5)

    bookmarks_md =
      bookmarks
      |> Enum.chunk_every(10)

    {:ok, assign(socket,
      category_id: String.to_integer(category_id),
      algorithm_id: nil,
      bookmarks_sm: bookmarks_sm,
      bookmarks_md: bookmarks_md,
      index_sm: 0,
      index_md: 0
    )}
  end

  # menuから
  def mount(%{}, _session, socket) do

    Logger.info("Mounted from MainMenuLive to BookmarkLive.")

    bookmarks = Bookmarks.list_bookmarks()
    bookmarks_sm =
      bookmarks
      |> Enum.chunk_every(5)

    bookmarks_md =
      bookmarks
      |> Enum.chunk_every(10)

    {:ok, assign(socket,
      category_id: nil,
      algorithm_id: nil,
      bookmarks_sm: bookmarks_sm,
      bookmarks_md: bookmarks_md,
      index_sm: 0,
      index_md: 0
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


  # アルゴリズムリストをソート
  def handle_event("sort_list", %{"key" => key, "order" => order}, socket) do

    sorted_bookmarks_sm =
      socket.assigns.bookmarks_sm
      |> List.flatten
      |> Enum.sort(
        case order do
          "asc" ->
            case key do
              "name"     -> &(&1.algorithm.name <= &2.algorithm.name)
              "id"       -> &(&1.id <= &2.id)
              "bookmark" -> &(&1.added_date <= &2.added_date)
            end
          "desc" ->
            case key do
              "name"     -> &(&1.algorithm.name >= &2.algorithm.name)
              "id"       -> &(&1.id >= &2.id)
              "bookmark" -> &(&1.added_date >= &2.added_date)
            end
        end)
      |> Enum.chunk_every(5)

    sorted_bookmarks_md =
      socket.assigns.bookmarks_md
      |> List.flatten
      |> Enum.sort(
        case order do
          "asc" ->
            case key do
              "name"     -> &(&1.algorithm.name <= &2.algorithm.name)
              "id"       -> &(&1.id <= &2.id)
              "bookmark" -> &(&1.added_date <= &2.added_date)
            end
          "desc" ->
            case key do
              "name"     -> &(&1.algorithm.name >= &2.algorithm.name)
              "id"       -> &(&1.id >= &2.id)
              "bookmark" -> &(&1.added_date >= &2.added_date)
            end
        end)
      |> Enum.chunk_every(10)


    {:noreply, assign(socket,
      bookmarks_sm: sorted_bookmarks_sm,
      bookmarks_md: sorted_bookmarks_md
    )}
  end

end
