defmodule MinimalServer.Endpoint do
  use Plug.Router
  require Logger

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  forward("/api", to: MinimalServer.Router)

  match _ do
    send_resp(conn, 404, "not found.")
  end

  @spec child_spec(any) :: %{
          id: MinimalServer.Endpoint,
          start: {MinimalServer.Endpoint, :start_link, [...]}
        }
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    # port = "PORT" |> System.get_env() |> String.to_integer()
    port = 4000
    Logger.info("Starting server at http://localhost:#{port}")

    Plug.Adapters.Cowboy.http(
      __MODULE__,
      [],
      port: port
    )
  end
end
