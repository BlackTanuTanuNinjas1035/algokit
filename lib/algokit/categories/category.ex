defmodule Algokit.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Algokit.Algorithms

  schema "categories" do
    field :name, :string
    has_many :algorithm, Algorithms.Algorithm

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
