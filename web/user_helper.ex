defmodule EFSupport.UserHelpers do
  def current_user(conn) do
    Map.merge(
      %EFSupport.User{},
      Addict.Helper.current_user(conn)
    )
  end

  def logged_in?(conn) do
    Addict.Helper.is_logged_in(conn)
  end
end
