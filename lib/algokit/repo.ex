defmodule Algokit.Repo do
  use Ecto.Repo,
    otp_app: :algokit,
    adapter: Ecto.Adapters.SQLite3

  def initialize() do
    Ecto.Migrator.up(Algokit.Repo, 20_230_726_062_245, Algokit.Migrations.CreateCategories)
    Ecto.Migrator.up(Algokit.Repo, 20_230_726_062_702, Algokit.Migrations.CreateAlgorithms)
  end
end
