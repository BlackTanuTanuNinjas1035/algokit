defmodule AlgokitWeb.DetailLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Bookmarks
  require Logger
  def render(assigns) do
    ~H"""
      <div class="flex justify-between py-2 px-2 align_bottom">
        <.link
          href={~p"/category/#{@category_id}"}
          class="flex justify-center items-center max-[500px]:min-h-[50px] max-[500px]:min-w-[100px] min-[500px]:min-h-[80px] min-[500px]:min-w-[160px] bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
        >
          戻る
        </.link>

        <button class="flex-grow min-[500px]:max-h-[80px] max-[500px]:max-h-[50px] min-[500px]:max-w-[80px] max-[500px]:max-w-[50px]" phx-click="push_bookmark_button">
          <img src=
            {
              if @bookmark, do: ~p"/images/スターの枠アイコン(たぬ).png", else: ~p"/images/ICOOON_MONO/スターの枠アイコン.png"
            }
            class=""
          />
        </button>


      </div>


      <div class=" w-full  max-[500px]:px-2">

        <!-- 名前とカテゴリ -->
        <div class="flex justify-center mb-1">
          <div class="max-w-max min-w-[40%] border-[3px] border-pink-200">
            <div class="bg-white p-4 shadow min-[500px]">
              <p class="text-3xl lg:text-4xl text-center text-black font-semibold mb-2"><%= @algorithm.name %></p>
              <p class="text-base text-center text-gray-600"><%= "カテゴリー: #{@algorithm.category.name}" %></p>
            </div>
          </div>
        </div>

        <!-- Description -->
        <div class="w-full mb-2">

          <div class="flex mr-2 min-[500px]:justify-center min-[500px]:my-1">
            <p class="text-3xl max-[500px]:text-2xl mr-2  border-b-2 border-gray-500">1. 説明</p>
            <p class="text-red-500 hidden max-[500px]:block text-sm pt-2">※クリックで詳細</p>
          </div>

          <!-- スマホ画面 -->
          <button
            type="button"
            data-hs-overlay="#description-overlay"
            class="min-[500px]:hidden w-auto mx-auto p-4 mt-2 rounded-lg border-yellow-500 bg-white shadow min-[500px]"
          >
            <p class=" text-xl text-center cursor-pointer"
            >
              <%= String.slice(@algorithm.description, 0, 50) <> "..." %>
            </p>
          </button>

          <!-- 横画面 -->
          <div class="flex justify-center w-full max-[500px]:hidden ">
            <div class=" overflow-auto bg-white max-[500px]:hidden min-[500px]:w-[80%]  border-[3px] border-yellow-200">
              <%= for line <- String.split(@algorithm.description, "\n") do %>
                <div class="text-base min-[500px]:text-2xl"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>


        <!-- Discription 詳細 -->
        <div id="description-overlay" class="[--overlay-backdrop:true] hs-overlay hs-overlay-open:translate-y-0 -translate-y-full fixed top-0 inset-x-0 transition-all duration-300 transform max-h-max h-full w-full z-[60] bg-white border-b dark:bg-gray-800 dark:border-gray-700 hidden" tabindex="-1">
          <div class="flex justify-between items-center py-3 px-4 border-b dark:border-gray-700 bg-blue-300">
            <h3 class="font-bold text-gray-800 dark:text-white">
              説明
            </h3>
            <button type="button" class="inline-flex flex-shrink-0 justify-center items-center h-8 w-8 rounded-md text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 focus:ring-offset-white text-sm dark:text-gray-500 dark:hover:text-gray-400 dark:focus:ring-gray-700 dark:focus:ring-offset-gray-800" data-hs-overlay="#description-overlay">
              <span class="sr-only">Close modal</span>
              <svg class="w-3.5 h-3.5" width="8" height="8" viewBox="0 0 8 8" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M0.258206 1.00652C0.351976 0.912791 0.479126 0.860131 0.611706 0.860131C0.744296 0.860131 0.871447 0.912791 0.965207 1.00652L3.61171 3.65302L6.25822 1.00652C6.30432 0.958771 6.35952 0.920671 6.42052 0.894471C6.48152 0.868271 6.54712 0.854471 6.61352 0.853901C6.67992 0.853321 6.74572 0.865971 6.80722 0.891111C6.86862 0.916251 6.92442 0.953381 6.97142 1.00032C7.01832 1.04727 7.05552 1.1031 7.08062 1.16454C7.10572 1.22599 7.11842 1.29183 7.11782 1.35822C7.11722 1.42461 7.10342 1.49022 7.07722 1.55122C7.05102 1.61222 7.01292 1.6674 6.96522 1.71352L4.31871 4.36002L6.96522 7.00648C7.05632 7.10078 7.10672 7.22708 7.10552 7.35818C7.10442 7.48928 7.05182 7.61468 6.95912 7.70738C6.86642 7.80018 6.74102 7.85268 6.60992 7.85388C6.47882 7.85498 6.35252 7.80458 6.25822 7.71348L3.61171 5.06702L0.965207 7.71348C0.870907 7.80458 0.744606 7.85498 0.613506 7.85388C0.482406 7.85268 0.357007 7.80018 0.264297 7.70738C0.171597 7.61468 0.119017 7.48928 0.117877 7.35818C0.116737 7.22708 0.167126 7.10078 0.258206 7.00648L2.90471 4.36002L0.258206 1.71352C0.164476 1.61976 0.111816 1.4926 0.111816 1.36002C0.111816 1.22744 0.164476 1.10028 0.258206 1.00652Z" fill="currentColor"/>
              </svg>
            </button>
          </div>
          <div class="p-4 bg-blue-100">
            <div class="text-gray-800 dark:text-gray-400">
              <%= for line <- String.split(@algorithm.description, "\n") do %>
                <div class="text-base"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>



        <!-- Pseudocode -->
        <div class="w-full mb-2">

          <div class="flex mr-2 min-[500px]:justify-center min-[500px]:my-1">
            <p class="text-3xl max-[500px]:hidden max-[500px]:text-2xl mr-2  border-b-2 border-gray-500">2. 疑似コード</p>
          </div>

          <div class="flex justify-center w-full mb-2 min-[500px]:hidden">
            <button
              type="button"
              data-hs-overlay="#pseudocode-overlay"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            >
              疑似コードを見る
            </button>
          </div>

          <!-- 横画面 -->
          <div class="flex justify-center w-full max-[500px]:hidden">
            <div class="overflow-auto bg-white max-[500px]:hidden min-[500px]:w-[80%] border-[3px] border-blue-200">
              <%= for line <- String.split(@algorithm.pseudocode, "\n") do %>
                <div class="text-base min-[500px]:text-2xl"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- 詳細 -->
        <div id="pseudocode-overlay" class="[--overlay-backdrop:true] hs-overlay hs-overlay-open:translate-y-0 -translate-y-full fixed top-0 inset-x-0 transition-all duration-300 transform max-h-max h-full w-full z-[60] bg-white border-b dark:bg-gray-800 dark:border-gray-700 hidden" tabindex="-1">
          <div class="flex justify-between items-center py-3 px-4 border-b dark:border-gray-700 bg-yellow-300">
            <h3 class="font-bold text-gray-800 dark:text-white">
              疑似コード
            </h3>
            <button type="button" class="inline-flex flex-shrink-0 justify-center items-center h-8 w-8 rounded-md text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 focus:ring-offset-white text-sm dark:text-gray-500 dark:hover:text-gray-400 dark:focus:ring-gray-700 dark:focus:ring-offset-gray-800" data-hs-overlay="#pseudocode-overlay">
              <span class="sr-only">Close modal</span>
              <svg class="w-3.5 h-3.5" width="8" height="8" viewBox="0 0 8 8" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M0.258206 1.00652C0.351976 0.912791 0.479126 0.860131 0.611706 0.860131C0.744296 0.860131 0.871447 0.912791 0.965207 1.00652L3.61171 3.65302L6.25822 1.00652C6.30432 0.958771 6.35952 0.920671 6.42052 0.894471C6.48152 0.868271 6.54712 0.854471 6.61352 0.853901C6.67992 0.853321 6.74572 0.865971 6.80722 0.891111C6.86862 0.916251 6.92442 0.953381 6.97142 1.00032C7.01832 1.04727 7.05552 1.1031 7.08062 1.16454C7.10572 1.22599 7.11842 1.29183 7.11782 1.35822C7.11722 1.42461 7.10342 1.49022 7.07722 1.55122C7.05102 1.61222 7.01292 1.6674 6.96522 1.71352L4.31871 4.36002L6.96522 7.00648C7.05632 7.10078 7.10672 7.22708 7.10552 7.35818C7.10442 7.48928 7.05182 7.61468 6.95912 7.70738C6.86642 7.80018 6.74102 7.85268 6.60992 7.85388C6.47882 7.85498 6.35252 7.80458 6.25822 7.71348L3.61171 5.06702L0.965207 7.71348C0.870907 7.80458 0.744606 7.85498 0.613506 7.85388C0.482406 7.85268 0.357007 7.80018 0.264297 7.70738C0.171597 7.61468 0.119017 7.48928 0.117877 7.35818C0.116737 7.22708 0.167126 7.10078 0.258206 7.00648L2.90471 4.36002L0.258206 1.71352C0.164476 1.61976 0.111816 1.4926 0.111816 1.36002C0.111816 1.22744 0.164476 1.10028 0.258206 1.00652Z" fill="currentColor"/>
              </svg>
            </button>
          </div>
          <div class="p-4 bg-yellow-100">
            <div class="text-gray-800 dark:text-gray-400">
              <%= for line <- String.split(@algorithm.pseudocode, "\n") do %>
                <div class="text-base"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Example -->
        <div class="overflow-y-scroll">
          <div class="max-w min-[500px] mx-auto p-4 rounded-lg border-yellow-500 bg-white shadow min-[500px]:w-[80%]">
            <div class="max-[500px]:text-base min-[500px]:text-xl font-semibold mb-1">使用例</div>
            <div class="aspect-w-16 aspect-h-9 rounded-lg overflow-hidden">
              <video controls autoplay loop class="w-full h-full">
                <source src="/videos/calc_angle.mp4" type="video/mp4">
              </video>
            </div>
          </div>
        </div>

      </div>
    """
  end

  def mount(%{"category_id" => category_id, "algorithm_id" => algorithm_id}, _session, socket) do
    algorithm_id = String.to_integer(algorithm_id)

    algorithm =
      algorithm_id
      |> Algorithms.get()

    # 最終閲覧日入力処理
    case Algorithms.update_last_viewed_date(algorithm, Date.utc_today()) do
      {:ok, _} ->
        Logger.info("最終閲覧日の更新に成功")
      {:error, _} ->
        Logger.info("最終閲覧日の更新に失敗")

    end

    Logger.info("Mounted DetailLive.")

    {:ok, assign(socket,
      category_id: category_id,
      algorithm_id: algorithm_id,
      algorithm: algorithm,
      bookmark: Bookmarks.exists_bookmark?(algorithm_id)
    )}
  end

  # ブックマークから削除したり追加したり
  def handle_event("push_bookmark_button", _values, socket) do

    # ブックマークに登録されている
    if Bookmarks.exists_bookmark?(socket.assigns.algorithm_id) do
      socket.assigns.algorithm_id
      |> Bookmarks.delete_bookmark()
      |> case do
        {:ok, _} ->
          Logger.info("Bookmark deleted successfully.")
          {:noreply, assign(socket,
            bookmark: false
          )}
        {:error, _} ->
          Logger.info("Bookmark deleted failed.")
          {:noreply, socket}
      end
    # ブックマークに登録されていない
    else
      socket.assigns.algorithm_id
      |> Bookmarks.add_bookmark()
      |> case do
        {:ok, _} ->
          Logger.info("Bookmark registered successfully.")
          {:noreply, assign(socket,
            bookmark: true
          )}
        {:error, _} ->
          Logger.info("Bookmark registered failed.")
          {:noreply, socket}
      end
    end
  end

  # ブックマークボタンに移動
  def handle_event("visit_bookmark", _value, socket) do
    Logger.info("visit /category/:category_id/algorithm/:algorithm_id/bookmark route.")
    {:noreply, push_navigate(socket, to: ~p"/category/#{socket.assigns.category_id}/algorithm/#{socket.assigns.algorithm_id}/bookmark")}
  end

  # infoから終了ボタンを押す
  def handle_event("exit_app", _value, socket) do
    Logger.info("exit app.")
    Desktop.Window.quit()
    {:noreply, socket}
  end
end
