defmodule Algokit.Bookmarks.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Algokit.Algorithms

  schema "bookmarks" do
    field :added_date, :date

    belongs_to :algorithm, Algorithms.Algorithm

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:added_date, :algorithm_id])
    |> validate_required([:added_date, :algorithm_id])
  end
end
