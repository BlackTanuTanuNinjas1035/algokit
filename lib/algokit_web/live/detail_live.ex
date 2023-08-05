defmodule AlgokitWeb.DetailLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Bookmarks
  require Logger
  def render(assigns) do
    ~H"""
      <header class="flex justify-between  py-2 px-2 max-[500px]:h-[10%] min-[500px]:h-[80%] align_bottom">
        <.link
          href={~p"/category/#{@category_id}"}
          style="background-image: url('/images/消しゴム.png'); background-size: cover; background-position: center;"
          class="flex justify-center min-[500px]:text-2xl min-[500px]:pl-3 max-[500px]:w-[30%] min-[500px]:w-[20%] min-[500px]:max-h-[80px] flex items-center justify-center inline-block rounded-lg bg-yellow-400 shadow-lg hover:shadow-xl transition duration-300 ease-in-out transform hover:-translate-y-1 hover:scale-110"
        >
          <p class="bg-white  min-w-[40%] min-[500px]:p-3 text-center">戻る</p>
        </.link>

        <button class=" " phx-click="push_bookmark_button">
          <img src=
            {
              if @bookmark, do: ~p"/images/ICOOON_MONO/スターの枠アイコン(たぬ).png", else: ~p"/images/ICOOON_MONO/スターの枠アイコン.png"
            }
            class="block w-full max-[500px]:h-auto min-[500px]:max-h-[100px] min-[500px]:max-w-[100px] max-[500px]:max-h-[50px] max-[500px]:max-w-[50px]"
          />
        </button>
      </header>


      <div class="max-[500px]:h-[90%] w-full  max-[500px]:px-2">

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
          <div class="min-[500px]:hidden w-auto mx-auto p-4 mt-2 rounded-lg border-yellow-500 bg-white shadow min-[500px]">
            <p onclick="toggleDescription()" class=" text-xl text-center cursor-pointer"
            >
              <%= String.slice(@algorithm.description, 0, 50) <> "..." %>
            </p>
          </div>

          <!-- 横画面 -->
          <div class="flex justify-center w-full max-[500px]:hidden ">
            <div class="h-[90%] overflow-auto bg-white max-[500px]:hidden min-[500px]:w-[80%]  border-[3px] border-yellow-200">
              <%= for line <- String.split(@algorithm.description, "\n") do %>
                <div class="text-base min-[500px]:text-2xl"><%= line %></div>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Discription 詳細 -->
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

        <!-- Pseudocode -->
        <div class="w-full mb-2">

          <div class="flex mr-2 min-[500px]:justify-center min-[500px]:my-1">
            <p class="text-3xl max-[500px]:hidden max-[500px]:text-2xl mr-2  border-b-2 border-gray-500">2. 疑似コード</p>
          </div>

          <div class="flex justify-center w-full mb-2 min-[500px]:hidden">
            <button onclick="togglePseudocode()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
              疑似コードを見る
            </button>
          </div>

          <!-- 横画面 -->
          <div class="flex justify-center w-full max-[500px]:hidden">
            <div class="h-[90%] overflow-auto bg-white max-[500px]:hidden min-[500px]:w-[80%] border-[3px] border-blue-200">
              <%= for line <- String.split(@algorithm.pseudocode, "\n") do %>
                <div class="text-base min-[500px]:text-2xl"><%= line %></div>
              <% end %>
            </div>
          </div>

        </div>
        <!-- 詳細 -->
          <div id="PseudocodeContainer" class="z-20 pseudocode-container hidden fixed top-1/2 left-1/2 w-[100vw] h-[100%] transform -translate-x-1/2 -translate-y-1/2 p-4 bg-gray-200 border-2 border-gray-300 rounded">
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
