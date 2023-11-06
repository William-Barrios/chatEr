defmodule ChatEr.Repo do
  use Ecto.Repo,
    otp_app: :chatEr,
    adapter: Ecto.Adapters.Postgres
end
