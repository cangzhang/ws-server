defmodule MinimalServer.Endpoint do
  use Plug.Router
  use Plug.ErrorHandler
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
    port = cowboy_port()
    Logger.info("Starting server at http://localhost:#{port}")

    Plug.Adapters.Cowboy.http(
      __MODULE__,
      [],
      port: port
    )
  end

  defp cowboy_port do
    Application.get_env(:minimal_server, :cowboy_port, 4000)
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)

    send_resp(conn, conn.status, "something went wrong.")
  end
end
