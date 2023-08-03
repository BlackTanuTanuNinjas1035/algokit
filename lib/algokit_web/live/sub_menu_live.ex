defmodule AlgokitWeb.SubMenuLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Categories

  def render(assigns) do
    ~H"""
      <header class="flex py-2 px-2">
        <.link
          href={~p"/"}
          class="py-3 px-8 inline-flex justify-center items-center gap-2 rounded-full border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800"
        >
          戻る
        </.link>
      </header>


      <div class="text-2xl text-center"><%= "カテゴリー: #{@category.name}" %></div>

      <%= if Enum.count(@algorithms_list) == 0 do %>
        <p>登録されていません。</p>
      <% else %>
        <!-- インデックスの変更 -->
        <div class="flex">
          <%= if @index == 0 do %>
            <div class="w-1/2 text-left pl-2"></div>
          <% else %>
            <button phx-click="change_index" phx-value-diff="-1" class="w-1/2 text-left pl-2">＜＜戻る</button>
          <% end %>
          <%= if @index >= Enum.count(@algorithms_list) - 1 do %>
            <div class="w-1/2 text-right pr-2"></div>
          <% else %>
            <button phx-click="change_index" phx-value-diff="1" class="w-1/2 text-right pr-2">進む＞＞</button>
          <% end %>
        </div>

        <div class="w-full px-2">
          <%= for algorithm <- Enum.at(@algorithms_list, @index) do %>
            <.link
              href={~p"/category/#{@category_id}/algorithm/#{algorithm.id}"}
              class="block w-full cursor-pointer rounded-lg bg-primary-100 p-4 text-primary-600 text-center bg-yellow-100"
            >
              <%= algorithm.name %>
            </.link>
          <% end %>
        </div>
      <% end %>
    """
  end

  def mount(%{"category_id" => category_id}, _session, socket) do
    category = Categories.get(category_id)

    algorithms_list =
      category_id
      |> Algorithms.list_algorithms_by_category_id()
      |> Enum.chunk_every(10)

    {:ok, assign(socket,
      category_id: category_id,
      category: category,
      index: 0,
      algorithms_list: algorithms_list
    )}
  end

  def handle_event("change_index", %{"diff" => diff}, socket) do
    {:noreply, assign(socket,
      index: socket.assigns.index + String.to_integer(diff)
    )}
  end
end
