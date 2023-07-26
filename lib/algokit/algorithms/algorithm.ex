defmodule Algokit.Algorithms.Algorithm do
  use Ecto.Schema
  import Ecto.Changeset
  alias Alogokit.Categories

  schema "algorithms" do
    field :description, :string
    field :example, :string
    field :last_viewed_date, :date
    field :name, :string
    field :pseudocode, :string

    belongs_to :category, Categories.Category

    timestamps()
  end

  @doc false
  def changeset(algorithm, attrs) do
    algorithm
    |> cast(attrs, [:name, :description, :pseudocode, :example, :last_viewed_date, :category_id])
    |> validate_required([:name, :description, :pseudocode, :example, :category_id])
  end
end
