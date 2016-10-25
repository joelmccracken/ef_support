defmodule EfSupport.Task do
  use EfSupport.Web, :model

  schema "tasks" do
    field :name, :string
    field :complete, :integer
    belongs_to :user, EfSupport.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :complete])
    |> validate_required([:name, :complete])
  end
end
