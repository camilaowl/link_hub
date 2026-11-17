defmodule LinkHub.Repo do
  use Ecto.Repo,
    otp_app: :link_hub,
    adapter: Ecto.Adapters.Postgres
end
