defmodule MinimalServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("starting server at port: #{cowboy_port()}")
    Supervisor.start_link(children(), opts())
  end

  defp children do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MinimalServer.Endpoint,
        options: [
          dispatch: dispatch(),
          port: cowboy_port()
        ]
      ),
      MinimalServer.Repo
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: MinimalServer.Application
    ]
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws", MinimalServer.Sockethandler, []},
         {:_, Plug.Cowboy.Handler, {MinimalServer.Endpoint, []}}
       ]}
    ]
  end

  defp cowboy_port do
    Application.get_env(:minimal_server, :cowboy_port, 4000)
  end
end
