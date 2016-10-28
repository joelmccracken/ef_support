defmodule EFSupport.Repo.Migrations.CreateOpenLoop do
  use Ecto.Migration

  def change do
    create table(:open_loops) do
      add :name, :string
      add :complete, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:open_loops, [:user_id])

  end
end
