defmodule Algokit.Categories do
  alias Algokit.Repo
  alias Algokit.Categories.Category
  import Ecto.Query
  require Logger

  def init() do
    if Enum.count(Repo.all(Category)) == 0 do
      Repo.insert %Category{name: "探索"}
      Repo.insert %Category{name: "ソート"}
      Repo.insert %Category{name: "グラフ"}
      Repo.insert %Category{name: "パスファインディング"}
      Repo.insert %Category{name: "衝突検出"}
      Repo.insert %Category{name: "3Dレンダリング"}
      Repo.insert %Category{name: "物理シミュレーション"}
      Repo.insert %Category{name: "乱数生成"}
      Repo.insert %Category{name: "なんとかアルゴリズム"}
      Repo.insert %Category{name: "なんとかアルゴリズム"}
    else
      Logger.info("すでに初期化済みです。")
    end
  end

  def list_categories() do
    Repo.all Category
  end
end
