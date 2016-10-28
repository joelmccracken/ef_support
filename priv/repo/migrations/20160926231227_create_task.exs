defmodule EFSupport.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :complete, :integer

      timestamps()
    end

  end
end
