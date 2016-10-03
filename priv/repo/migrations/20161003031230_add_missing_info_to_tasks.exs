defmodule EfSupport.Repo.Migrations.AddMissingInfoToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :open_loop_id, references(:open_loops, on_delete: :nothing)
    end

    create index(:tasks, [:user_id])
    create index(:tasks, [:open_loop_id])
  end
end
