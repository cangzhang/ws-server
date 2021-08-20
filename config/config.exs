import Config

config :minimal_server, MinimalServer.Repo,
  database: "minimal_server_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :minimal_server, ecto_repos: [MinimalServer.Repo]
