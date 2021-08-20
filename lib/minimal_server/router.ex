defmodule MinimalServer.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/bot" do
    conn
    |> send_resp(200, Poison.encode!(%{text: "ok bot."}))
  end

  post "/bot" do
    body = conn.body_params

    create_person(body)

    conn
    |> send_resp(201, Poison.encode!(%{text: "WIP: create bot.", body: body}))
  end

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(message()))
  end

  defp message do
    %{
      response_type: "in_channel",
      text: "Hello :)"
    }
  end

  defp create_person(params) do
    MinimalServer.Repo.create(params)
  end
end
