defmodule EFSupport.OpenLoopTest do
  use EFSupport.ModelCase

  alias EFSupport.OpenLoop

  @valid_attrs %{complete: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = OpenLoop.changeset(%OpenLoop{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OpenLoop.changeset(%OpenLoop{}, @invalid_attrs)
    refute changeset.valid?
  end
end
