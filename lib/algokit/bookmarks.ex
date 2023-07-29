defmodule Algokit.Bookmarks do
  alias Algokit.Repo
  alias Algokit.Bookmarks.Bookmark
  import Ecto.Query

  def list_bookmarks() do
    Bookmark
    |> preload([:algorithm, [algorithm: :category]])
    |> Repo.all()
  end

  def add_bookmark(id) do
    Repo.insert(%Bookmark{added_date: Date.utc_today(), algorithm_id: id})
  end
end
