defmodule EFSupport.API.TaskView do
  use EFSupport.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :complete, :inserted_at, :updated_at]

  has_one :user,
    field: :user_id,
    type: "user"

end
