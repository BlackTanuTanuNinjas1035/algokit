defmodule AlgokitWeb.BookmarkLive do
  use AlgokitWeb, :live_view
  alias Algokit.Bookmarks

  def render(assigns) do
    ~H"""
      <p class="text-xl">ブックマーク一覧</p>
      <%= if Enum.count(@bookmarks) == 0 do%>
        <p>ないよ</p>
      <% else %>
        <div class="ax-w-xs flex flex-col max-h-[28%] overflow-hidden">
          <%= for bookmark <- @bookmarks do%>
            <.link
              href={~p"/category/#{bookmark.algorithm.category_id}/algorithm/#{bookmark.algorithm_id}"}
              class="inline-flex items-center gap-x-3.5 py-3 px-4 text-sm font-medium border text-blue-600 -mt-px first:rounded-t-lg first:mt-0 last:rounded-b-lg focus:z-10 focus:outline-none focus:ring-2 focus:ring-blue-600 dark:border-gray-700"
            >
              <%= bookmark.algorithm.name %>:<%= bookmark.added_date %>
            </.link>
          <% end %>
        </div>
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
