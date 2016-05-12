defmodule StatiTest do
  use ExUnit.Case
  require Stati
  doctest Stati

  test "change, simple case" do
    mymap = %{val: 4}
    newmap = Stati.change(mymap.val = 5)
    assert newmap == %{val: 5}
  end

  test "change, double encapsulation" do
    mymap = %{ childmap: %{ val: 4} }
    newmap = Stati.change(mymap.childmap.val = 5)
    assert newmap == %{childmap: %{ val: 5}}
  end

  test "change, triple encapsulation" do
    mymap = %{ childmap: %{ subchildmap: %{ val: 4} } }
    newmap = Stati.change(mymap.childmap.subchildmap.val = 5)
    assert newmap == %{childmap: %{ subchildmap: %{ val: 5}}}
  end

  test "add_head, triple encapsulation" do
    mymap = %{ childmap: %{ subchildmap: %{ list: [1,2,3] } } }
    newmap = Stati.change(mymap.childmap.subchildmap.list | 0)
    assert newmap == %{childmap: %{ subchildmap: %{ list: [0,1,2,3]}}}
  end
end
