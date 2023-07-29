defmodule Algokit.Repo do
  use Ecto.Repo,
    otp_app: :algokit,
    adapter: Ecto.Adapters.SQLite3

  alias Algokit.Categories
  alias Algokit.Algorithms
  alias Algokit.Bookmarks


  @doc """
  初期化処理
  """
  def initialize() do
    Ecto.Migrator.up(Algokit.Repo, 20_230_726_062_245, Algokit.Migrations.CreateCategories)
    Ecto.Migrator.up(Algokit.Repo, 20_230_726_062_702, Algokit.Migrations.CreateAlgorithms)
    Ecto.Migrator.up(Algokit.Repo, 20_230_729_083_549, Algokit.Migrations.CreateBookmarks)
    Categories.init()
    Algorithms.init()
  end
end
