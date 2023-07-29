defmodule Algokit.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :added_date, :date

      add :algorithm_id, references(:algorithms), null: false

      timestamps()
    end

    # ブックマーク中にアルゴリズムは一意
    create unique_index(:bookmarks, [:algorithm_id])
  end
end
