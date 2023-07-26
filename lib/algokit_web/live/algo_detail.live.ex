defmodule AlgokitWeb.AlgoDetailLive do
  use AlgokitWeb, :live_view

  def render(assigns) do
    ~H"""
    <.link
      href={~p"/"}
    >
    戻る
    </.link>

    <p class="text-3xl">アルゴリズム詳細ページ</p>
    <button>&#9734;</button>

    <p>ここに説明</p>
    <p>ここにコード</p>
    <div>ここに動画</div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
