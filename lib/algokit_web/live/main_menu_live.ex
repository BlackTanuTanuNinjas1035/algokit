defmodule AlgokitWeb.MainMenuLive do
  use AlgokitWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full w-full">
      <p class="text-xl">メイン画面</p>

      <div>
        <select name="category" id="category">
          <option value="1">カテゴリーID:1</option>
          <option value="2">カテゴリーID:2</option>
          <option value="3">カテゴリーID:3</option>
        </select>
      </div>

      <.link
        href={~p"/detail"}
      >
      詳細ページ
      </.link>

      <p>最近表示したもの</p>
      <ul>
        <li>アレ</li>
      </ul>

    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
