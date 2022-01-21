defmodule Pokershirt.Pokershirt.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "metrics" do
    field :int_value, :integer
    field :key, :string

    timestamps()
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:key, :int_value])
    |> validate_required([:key, :int_value])
  end
end
