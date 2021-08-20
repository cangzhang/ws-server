defmodule MinimalServer.Repo do
  use Ecto.Repo,
    otp_app: :minimal_server,
    adapter: Ecto.Adapters.Postgres

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "people" do
    field(:name, :string, null: false)
    field(:age, :integer, default: 0)
    field(:created_at, :time)

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(person, params \\ %{}) do
    person
    |> cast(params, [:name, :age, :created_at])
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
  end

  def create(params) do
    cs =
      changeset(
        %MinimalServer.Repo{},
        %{
          "name" => params["name"],
          "age" => params["age"],
          "created_at" => DateTime.utc_now()
        }
        |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      )
      |> validate_required(params)

    if cs.valid? do
      {:error} = MinimalServer.Repo.insert(cs)
      true
    else
      false
    end
  end
end
