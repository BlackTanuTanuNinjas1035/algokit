defmodule Algokit.Repo do
  use Ecto.Repo,
    otp_app: :algokit,
    adapter: Ecto.Adapters.SQLite3
end
