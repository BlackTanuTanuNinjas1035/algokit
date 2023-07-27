defmodule Algokit.Algorithms do
  alias Algokit.Repo
  alias Algokit.Algorithms.Algorithm
  import Ecto.Query
  require Logger

  def init() do
    if Enum.count(Repo.all(Algorithm)) == 0 do
      Repo.insert %Algorithm{name: "あれをする方法", category_id: 1, description: "あれをするよ。", pseudocode: "疑似コードです", example: "実装例。", last_viewed_date: nil}
    else
      Logger.debug("すでに初期化済みです。")
    end
  end

  def list_algorithms_by_category_id(id) do
    Algorithm
    |> where([a], a.category_id == ^id)
    |> preload([c], [:category])
    |> Repo.all
  end

  def get(id) do
    Repo.get(Algorithm, id)
  end

  def update_last_viewed_date(algorithm, date) do
    Ecto.Changeset.change(algorithm, last_viewed_date: date)
    |> Repo.update()
  end
end
