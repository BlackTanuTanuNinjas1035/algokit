defmodule AlgokitWeb.DetailLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Bookmarks
  require Logger
  def render(assigns) do
    ~H"""
      <header class="flex justify-between py-2 px-2 max-[500px]:h-[10%]">
        <.link
          href={~p"/category/#{@category_id}"}
          class="w-[10%] inline-block rounded-lg bg-yellow-400 px-4 py-2 shadow-lg hover:shadow-xl transition duration-300 ease-in-out transform hover:-translate-y-1 hover:scale-110"
        >
          戻る
        </.link>

        <button class=" " phx-click="push_bookmark_button">
          <img src=
            {
              if @bookmark, do: ~p"/images/ICOOON_MONO/スターの枠アイコン(たぬ).png", else: ~p"/images/ICOOON_MONO/スターの枠アイコン.png"
            }
            class="block w-full h-auto max-h-[50px] max-w-[50px]"
          />
        </button>
      </header>


      <div class="px-3 max-[500px]:h-[90%]  w-full">

        <!-- 名前とカテゴリ -->
        <div class="border-[3px] border-pink-200 my-2">
          <div class="w-auto bg-white p-4 shadow-md">
            <p class="text-3xl lg:text-4xl text-center text-black font-semibold mb-2"><%= @algorithm.name %></p>
            <p class="text-base text-center text-gray-600"><%= "カテゴリー: #{@algorithm.category.name}" %></p>
          </div>
        </div>

        <!-- Description -->
        <div class="">

          <div class="flex mr-2">
            <p class="text-3xl max-[500px]:text-2xl mr-2  border-b-2 border-gray-500">1. 説明</p>
            <p class="text-red-500 hidden max-[500px]:block text-sm pt-2">※クリックで詳細</p>
          </div>

          <!-- スマホ画面 -->
          <div class="min-[500px]:hidden w-auto max-w-md mx-auto p-4 my-2 rounded-lg border-yellow-500 bg-white shadow-md">
            <p onclick="toggleDescription()" class=" text-xl text-center cursor-pointer"
            >
              <%= String.slice(@algorithm.description, 0, 50) <> "..." %>
            </p>
          </div>

          <!-- 詳細 -->
          <div id="DescriptionContainer" class="description-container hidden z-20 fixed top-1/2 left-1/2 w-[100vw] h-[100vh] transform -translate-x-1/2 -translate-y-1/2 p-4 bg-gray-200 border-2 border-gray-300 rounded">
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

          <!-- 横画面 -->
          <div class="h-[90%] overflow-auto bg-white max-[500px]:hidden">
            <%= for line <- String.split(@algorithm.description, "\n") do %>
              <div class="text-base"><%= line %></div>
            <% end %>
          </div>
        </div>

        <!-- Pseudocode -->
        <div class="w-full">
          <!-- <div class="text-3xl max-[500px]:text-xl">疑似コード</div> -->

          <div class="flex justify-center w-full mb-2">
            <button onclick="togglePseudocode()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
              疑似コードを見る
            </button>
          </div>

          <!-- 詳細 -->
          <div id="PseudocodeContainer" class="pseudocode-container hidden fixed top-1/2 left-1/2 w-[100vw] h-[100%] transform -translate-x-1/2 -translate-y-1/2 p-4 bg-gray-200 border-2 border-gray-300 rounded">
            <div class="flex justify-between mb-2 h-[7%]">
              <div class="text-2xl text-center">疑似コード</div>
              <button onclick="togglePseudocode()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-0 px-4 rounded">
                  戻る
              </button>
            </div>

            <div class="h-[90%] overflow-auto bg-white">
              <%= for line <- String.split(@algorithm.pseudocode, "\n") do %>
                <div class="text-base"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Example -->

          <div class="max-w-md mx-auto p-4 rounded-lg border-yellow-500 bg-white shadow-md">
            <!-- <div class="text-3xl font-semibold mb-1">使用例</div> -->
            <div class="aspect-w-16 aspect-h-9 rounded-lg overflow-hidden">
              <video controls autoplay loop class="w-full h-full">
                <source src="/videos/calc_angle.mp4" type="video/mp4">
                <!-- 他の動画フォーマットに対するsourceタグを追加することもできます -->
              </video>
            </div>
          </div>
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
    IO.puts "id: #{socket.assigns.algorithm_id}"
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
