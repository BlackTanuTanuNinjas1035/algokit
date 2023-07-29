defmodule AlgokitWeb.BookmarkLive do
  use AlgokitWeb, :live_view
  alias Algokit.Bookmarks

  def render(assigns) do
    ~H"""
      <p class="text-xl">ブックマーク一覧</p>
      <%= if Enum.count(@bookmarks) == 0 do%>
        <p>ないよ</p>
      <% else %>
        <%= for bookmark <- @bookmarks do%>
          <.link href={~p"/category/#{bookmark.algorithm.category_id}/algorithm/#{bookmark.algorithm_id}"}>
            <%= bookmark.algorithm.name %>:<%= bookmark.added_date %>
          </.link>
        <% end %>
      <% end %>
    """
  end

  def mount(_pparams, _session, socket) do
    bookmarks = Bookmarks.list_bookmarks()
    {:ok, assign(socket,
      bookmarks: bookmarks
    )}
  end

end
