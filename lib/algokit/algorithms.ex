defmodule Algokit.Algorithms do
  alias Algokit.Repo
  alias Algokit.Algorithms.Algorithm
  import Ecto.Query
  require Logger


  @doc """
  Algorithmsテーブルを初期化します。
  init algorithms table.
  """
  def init() do
    if Enum.count(Repo.all(Algorithm)) == 0 do
      Repo.insert %Algorithm{name: "あれをする方法", category_id: 1, description: "あれをするよ。", pseudocode: "疑似コードです", example: "実装例。", last_viewed_date: nil}
    else
      Logger.debug("すでに初期化済みです。")
    end
  end

  @doc """
  Algorithmsテーブルからidと一致するカテゴリーIDをもつアルゴリズムを取得します。
  Retrieve algorithm from the algorithms table that have a matching category ID with 'id'.

  ## Example
    iex> list_algorithms_by_category_id(id)

  """
  def list_algorithms_by_category_id(id) do
    Algorithm
    |> where([a], a.category_id == ^id)
    |> preload([c], [:category])
    |> Repo.all
  end

  @doc """
  説明不要(あんまりこんなこと書くのはよくないけど)

  ## Example
    iex> get(1)
    %Algoritm{}

    iex> get(999)
    nil
  """
  def get(id) do
    Repo.get(Algorithm, id)
  end

  @doc """
  アルゴリズムの最終閲覧日(last_viewed_date)を更新します。
  update the last viewed date of the algoritm.

  ## Example
      iex> update_last_viewed_date(algorithm, date)
      {:ok, %Account{}}

      iex> update_last_viewed_date(algorithm, date)
      {:error, %Ecto.Changeset{}}

  """
  def update_last_viewed_date(algorithm, date) do
    Ecto.Changeset.change(algorithm, last_viewed_date: date)
    |> Repo.update()
  end

  @doc """
  最終閲覧日が近いアルゴリズムを取得します。
  デフォルトで5件取得。
  Retrieve algorithms that the most recent last viewed date.
  By default, fetch 5 records.
  """
  def fetch_recent_last_viewed_date(limit \\ 5) do
    Algorithm
    |> order_by(desc: :last_viewed_date)
    |> where([a], is_nil(a.last_viewed_date) == false)
    |> preload([:category])
    |> limit(^limit)
    |> Repo.all()
  end
end
