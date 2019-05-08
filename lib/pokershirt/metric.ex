defmodule Pokershirt.Metric do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pokershirt.Metric

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

  def increment(repo, key, delta \\ 1) when is_atom(key) do
    record =
      repo.insert!(%Metric{key: to_string(key), int_value: delta}, returning: true,
        on_conflict: [inc: [int_value: delta]], conflict_target: :key)
    new_value = record.int_value
    Phoenix.PubSub.broadcast(Pokershirt.PubSub, "metric:#{key}", {"metric_updated", key, new_value})
    new_value
  end

  def get(repo, key) when is_atom(key) do
    repo.get_by(Metric, key: to_string(key)).int_value
  end
end
