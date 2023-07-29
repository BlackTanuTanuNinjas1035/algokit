defmodule AlgokitWeb.DetailLive do
  use AlgokitWeb, :live_view
  alias Algokit.Algorithms
  alias Algokit.Bookmarks
  require Logger
  def render(assigns) do
    ~H"""
    <.link href={~p"/category/#{@category_id}"}>戻る</.link>
    <p class="text-3xl"><%= @algorithm.name %></p>
    <button class="" phx-click="push_bookmark_button">a</button>
    <div>説明</div>
    <p class="text-base"><%= @algorithm.description %></p>
    <div>処理</div>
    <p class="text-base"><%= @algorithm.pseudocode %></p>
    <div>使用例</div>
    <p class="text-base"><%= @algorithm.example %></p>
    """
  end

  def mount(%{"category_id" => category_id, "algorithm_id" => algorithm_id}, _session, socket) do
    algorithm = Algorithms.get(algorithm_id)

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
      algorithm: algorithm
    )}
  end

  def handle_event("push_bookmark_button", _values, socket) do
    socket.assigns.algorithm_id
    |> Bookmarks.add_bookmark()
    |> case do
      {:ok, _} ->
        Logger.info("ブックマークの登録に成功。")
      {:error, _} ->
        Logger.info("ブックマークの登録に失敗。")
    end

    {:noreply, socket}
  end
end
