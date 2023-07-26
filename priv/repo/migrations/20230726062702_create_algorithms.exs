defmodule Algokit.Repo.Migrations.CreateAlgorithms do
  use Ecto.Migration

  def change do
    create table(:algorithms) do
      add :name, :string
      add :description, :string
      add :pseudocode, :string
      add :example, :string
      add :last_viewed_date, :date, null: true

      add :category_id, references(:categories), null: false

      timestamps()
    end
  end
end
