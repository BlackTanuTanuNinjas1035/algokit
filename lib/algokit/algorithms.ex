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
      Repo.insert(%Algorithm{
        name: "ガンスプライト角度計算",
        category_id: 1,
        description:
          "プレイヤーの位置とマウスカーソルの位置から、銃のスプライトの向きを計算する。\n" <>
          "入力:\n" <>
          "* playerの位置: 浮動小数点(x, y)\n" <>
          "* cursorの位置: 浮動小数点(x, y)\n" <>
          "* gunの位置: 浮動小数点数(x, y)\n" <>
          "* 出力: 銃のスプライトの向き(度数法)\n" <>
          "なお例では度数法に変換せずラジアンで使用している。",
        pseudocode:
          "関数 ガンスプライト角度計算(プレイヤー, マウスカーソル, 銃):\n" <>
          "    ベクトル = (\n" <>
          "        マウスカーソル位置.x - ( プレイヤー.x + 銃の位置オフセット.x),\n" <>
          "        マウスカーソル位置.y - (プレイヤー位置.y + 銃の位置オフセット.y)\n" <>
          "    )\n" <>
          "    角度ラジアン = atan2(ベクトル.y, ベクトル.x)\n" <>
          "    角度度数法 = to_degrees(角度ラジアン)\n" <>
          "    戻り値 角度度数法",
        example: "calc_angle.mp4"
      })
      # サンプルデータ
      Repo.insert(%Algorithm{
        name: "サンプル1",
        category_id: 1,
        description:
          "サンプル1",
        pseudocode:
          "サンプル1",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル2",
        category_id: 1,
        description:
          "サンプル2",
        pseudocode:
          "サンプル2",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル3",
        category_id: 1,
        description:
          "サンプル4",
        pseudocode:
          "サンプル4",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル4",
        category_id: 1,
        description:
          "サンプル4",
        pseudocode:
          "サンプル4",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル5",
        category_id: 1,
        description:
          "サンプル5",
        pseudocode:
          "サンプル5",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル6",
        category_id: 1,
        description:
          "サンプル6",
        pseudocode:
          "サンプル6",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル7",
        category_id: 1,
        description:
          "サンプル7",
        pseudocode:
          "サンプル7",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル8",
        category_id: 1,
        description:
          "サンプル8",
        pseudocode:
          "サンプル8",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル9",
        category_id: 1,
        description:
          "サンプル9",
        pseudocode:
          "サンプル9",
        example: "calc_angle.mp4"
      })
      Repo.insert(%Algorithm{
        name: "サンプル10",
        category_id: 1,
        description:
          "サンプル10",
        pseudocode:
          "サンプル10",
        example: "calc_angle.mp4"
      })
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
  def get(algorithm_id) do
    Algorithm
    |> where([a], a.id == ^algorithm_id)
    |> preload([:category])
    |> Repo.one()
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
  def fetch_recent_last_viewed_date(limit \\ 3) do
    Algorithm
    |> order_by(desc: :last_viewed_date)
    |> where([a], is_nil(a.last_viewed_date) == false)
    |> preload([:category])
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  指定した単語を含む名前のアルゴリズムを取得。
  なお未入力("")で全部取得する
  """
  def search_name_with_keywords(id, keyword) do
    list_algorithms_by_category_id(id)
    |> Enum.filter(fn algorithm -> String.match?(algorithm.name, ~r/#{keyword}/) end)
  end

  @doc """
  カテゴリーごとのアルゴリズムの数を取得
  """
  def count_by_category(id) do
    Algorithm
    |> where(category_id: ^id)
    |> Repo.all()
    |> Enum.count()
  end
end
