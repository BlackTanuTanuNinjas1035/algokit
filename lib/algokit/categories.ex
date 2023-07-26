defmodule Algokit.Categories do
  alias Algokit.Repo
  alias Algokit.Categories.Category

  import Logger

  def init() do
    if Enum.count(Repo.all(Category)) do
      Repo.insert %Category{name: "なんとかアルゴリズム"}
    else
      Logger.info("すでに初期化済みです。")
    end
  end
end
