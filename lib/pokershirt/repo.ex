defmodule Pokershirt.Repo do
  use Ecto.Repo,
    otp_app: :pokershirt,
    adapter: Ecto.Adapters.Postgres
end
