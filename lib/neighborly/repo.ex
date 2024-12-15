defmodule Neighborly.Repo do
  use Ecto.Repo,
    otp_app: :neighborly,
    adapter: Ecto.Adapters.Postgres
end
