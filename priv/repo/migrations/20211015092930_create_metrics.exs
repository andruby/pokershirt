defmodule Pokershirt.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create table(:metrics) do
      add :key, :string
      add :int_value, :integer

      timestamps()
    end
    create index(:metrics, [:key], unique: true)
  end
end
