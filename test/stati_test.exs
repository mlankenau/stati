defmodule StatiTest do
  use ExUnit.Case
  require Stati
  doctest Stati

  test "simple case" do
    mymap = %{val: 4}
    newmap = Stati.change(mymap.val, 5)
    assert newmap == %{val: 5}
  end

  test "double encapsulation" do
    mymap = %{ childmap: %{ val: 4} }
    newmap = Stati.change(mymap.childmap.val, 5)
    assert newmap == %{childmap: %{ val: 5}}
  end

  test "triple encapsulation" do
    mymap = %{ childmap: %{ subchildmap: %{ val: 4} } }
    newmap = Stati.change(mymap.childmap.subchildmap.val, 5)
    assert newmap == %{childmap: %{ subchildmap: %{ val: 5}}}
  end
end
