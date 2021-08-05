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

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)

    send_resp(conn, conn.status, "something went wrong.")
  end
end
