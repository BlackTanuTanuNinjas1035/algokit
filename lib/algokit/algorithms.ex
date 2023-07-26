defmodule Algokit.Algorithms do
  alias Algokit.Repo
  alias Algokit.Algorithms.Algorithm

  def init() do
    if Enum.count(Repo.all(Algorithm)) == 0 do
      Repo.insert %Algorithm{name: "あれをする方法", category_id: 1, description: "あれをするよ。", pseudocode: "疑似コードです", example: "実装例。", last_viewed_date: nil}
    else
      Logger.info("すでに初期化済みです。")
    end
  end
end
