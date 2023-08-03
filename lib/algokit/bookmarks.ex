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

  def delete_bookmark(id) do
    bookmark = Repo.get_by(Bookmark, algorithm_id: id)
    if bookmark != nil do
      Repo.delete(bookmark)
    end
  end

  def exists_bookmark?(id) do
    # Repo.exists?(Bookmark, algorithm_id: id)
    Bookmark
    |> where(algorithm_id: ^id)
    |> Repo.all
    |> Enum.count()
    |> case do
      0 -> false
      _ -> true
    end
  end
end
