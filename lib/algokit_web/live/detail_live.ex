defmodule AlgokitWeb.DetailLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Bookmarks
  require Logger
  def render(assigns) do
    ~H"""
      <header class="flex justify-between py-2 px-2 h-[10%]">
        <.link
          href={~p"/category/#{@category_id}"}
          class="py-3 px-8 inline-flex justify-center items-center gap-2 rounded-full border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800"
        >
          戻る
        </.link>
        <button class=" " phx-click="push_bookmark_button">
          <img src={~p"/images/ICOOON_MONO/スターの枠アイコン.png"} class="block w-full h-auto max-h-[50px] max-w-[50px]" />
        </button>
      </header>

      <div class="h-[15%] bg-yellow-200">
        <p class="text-3xl text-center px-2"><%= @algorithm.name %></p>
        <p class="text-xl text-center px-2"><%= "カテゴリー: #{@algorithm.category.name}" %></p>
        <p class="text-base text-center">
          <%= if @bookmark, do: "お気に入り登録済み" %>
        </p>
      </div>

      <div class="px-3 h-[75%] w-full">

        <!-- Description -->
        <div>
          <div class="flex mr-2">
            <p class="text-3xl">説明</p><p class="pt-2">クリックで詳細</p>
          </div>
          <!-- description表示ボタン -->
          <p onclick="toggleDescription()" class="bg-red-100"><%= String.slice(@algorithm.description, 0, 50) <> "..." %></p>

          <!-- Description詳細表示 -->
          <div id="DescriptionContainer" class="description-container hidden fixed top-1/2 left-1/2 w-[100vw] h-[100vh] transform -translate-x-1/2 -translate-y-1/2 p-4 bg-gray-200 border-2 border-gray-300 rounded">
            <div class="flex justify-between mb-2 h-[7%]">
              <div class="text-2xl">説明</div>
              <button onclick="toggleDescription()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                  戻る
              </button>
            </div>

              <div class="h-[90%] overflow-auto bg-white">
                <%= for line <- String.split(@algorithm.description, "\n") do %>
                  <div class="text-base"><%= line %></div>
                <% end %>
              </div>
          </div>
        </div>

        <!-- Pseudocode -->
        <div>
          <div class="text-3xl">疑似コード</div>
          <!-- Pseudocode表示ボタン -->
          <button onclick="togglePseudocode()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            疑似コードを見る
          </button>

          <div id="PseudocodeContainer" class="pseudocode-container hidden fixed top-1/2 left-1/2 w-[100vw] h-[100%] transform -translate-x-1/2 -translate-y-1/2 p-4 bg-gray-200 border-2 border-gray-300 rounded">
            <div class="flex justify-between mb-2 h-[7%]">
              <div class="text-2xl text-center">疑似コード</div>
              <button onclick="togglePseudocode()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-0 px-4 rounded">
                  戻る
              </button>
            </div>
            <!-- テキスト -->
            <div class="h-[90%] overflow-auto bg-white">
              <%= for line <- String.split(@algorithm.pseudocode, "\n") do %>
                <div class="text-base"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Example -->
          <div class="text-3xl">使用例</div>
          <video controls autoplay loop>
            <source src={~p"/videos/calc_angle.mp4"} type="video/mp4">
              ...
          </video>
      </div>

      <script>
      function togglePseudocode() {
          var pseudocodeContainer = document.getElementById("PseudocodeContainer");
          pseudocodeContainer.classList.toggle("hidden");
      }

      function toggleDescription() {
        var descriptionContainer = document.getElementById("DescriptionContainer");
        descriptionContainer.classList.toggle("hidden");
      }
      </script>
    """
  end

  def mount(%{"category_id" => category_id, "algorithm_id" => algorithm_id}, _session, socket) do
    algorithm = Algorithms.get(algorithm_id)
    IO.inspect(algorithm)

    # 最終閲覧日入力処理
    case Algorithms.update_last_viewed_date(algorithm, Date.utc_today()) do
      {:ok, _} ->
        Logger.info("最終閲覧日の更新に成功")
      {:error, _} ->
        Logger.info("最終閲覧日の更新に失敗")

    end

    {:ok, assign(socket,
      category_id: String.to_integer(category_id),
      algorithm_id: String.to_integer(algorithm_id),
      algorithm: algorithm,
      bookmark: Bookmarks.exists_bookmark?(algorithm_id)
    )}
  end

  # ブックマークから削除したり追加したり
  def handle_event("push_bookmark_button", _values, socket) do
    if Bookmarks.exists_bookmark?(socket.assigns.algorithm_id) do
      socket.assigns.algorithm_id
      |> Bookmarks.delete_bookmark()
      |> case do
        {:ok, _} ->
          Logger.info("ブックマークの削除に成功。")
          {:noreply, assign(socket,
            bookmark: false
          )}
        {:error, _} ->
          Logger.info("ブックマークの削除に失敗。")
          {:noreply, socket}
      end
    else
      socket.assigns.algorithm_id
      |> Bookmarks.add_bookmark()
      |> case do
        {:ok, _} ->
          Logger.info("ブックマークの登録に成功。")
          {:noreply, assign(socket,
            bookmark: true
          )}
        {:error, _} ->
          Logger.info("ブックマークの登録に失敗。")
          {:noreply, socket}
      end
    end
  end
end
