defmodule Algokit do
  use Application

  def config_dir() do
    Path.join([Desktop.OS.home(), ".config", "todo_app"])
  end

  @app Mix.Project.config()[:app]
  def start(:normal, []) do
    # configフォルダを掘る
    File.mkdir_p!(config_dir())

    # DBの場所を指定
    Application.put_env(:todo_app, Algokit.Repo,
      database: Path.join(config_dir(), "/database.sq3")
    )

    # session用のETSを起動
    :session = :ets.new(:session, [:named_table, :public, read_concurrency: true])

    children = [
      Algokit.Repo,
      {Phoenix.PubSub, name: Algokit.PubSub},
      AlgokitWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Algokit.Supervisor]
    # メインのsuperviser起動
    {:ok, sup} = Supervisor.start_link(children, opts)

    # DBのマイグレーション実行
    Algokit.Repo.initialize()

    # phoenixサーバーが起動中のポート番号を取得
    port = :ranch.get_port(AlgokitWeb.Endpoint.HTTP)
    # メインのsuperviserの配下にElixirDesktopのsuperviserを追加
    {:ok, _} =
      Supervisor.start_child(sup, {
        Desktop.Window,
        [
          app: @app,
          id: AlgokitWindow,
          title: "Algokit",
          size: {400, 800},
          url: "http://localhost:#{port}"
        ]
      })
  end

  def config_change(changed, _new, removed) do
    AlgokitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
