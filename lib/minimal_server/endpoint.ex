defmodule MinimalServer.Endpoint do
  use Plug.Router

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

  def start_link(_opts),
    do: Plug.Adapters.Cowboy.http(__MODULE__, [])
end
