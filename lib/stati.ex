defmodule Stati do
  @doc ~S"""
    change an element in an hierarchie of maps

    iex> mymap = %{ childmap: %{ other_val: 'foo', val: 4} }
    iex> Stati.change(mymap.childmap.val = 5)
    %{childmap: %{ other_val: 'foo', val: 5}}

    iex> mymap = %{ childmap: %{ other_val: 'foo', val: [1,2,3]} }
    iex> Stati.change(mymap.childmap.val | 0)
    %{childmap: %{ other_val: 'foo', val: [0,1,2,3]}}

    iex> mymap = %{ childmap: %{ other_val: 'foo', list: [4]} }
    iex> Stati.change(mymap.childmap -- :list)
    %{childmap: %{ other_val: 'foo'}}
  """
  defmacro change(cmd) do
    {path, val, op} = case cmd do
      {:=, _, [path, val]} ->
        {
          path,
          val,
          fn(m, s, val, path) -> "%{ #{generate_path(path)}#{m} | #{s}: #{val}}" end
        }
      {:|, _, [path, val]} ->
        {
          path,
          val,
          fn(m, s, val, path) -> "%{ #{generate_path(path)}#{m} | #{s}: [#{val} | #{generate_path(path)}#{m}.#{s}]}" end
        }
      {:--, _, [path, val]} ->
        {
          path,
          val,
          fn(m, s, val, path) -> "%{ #{generate_path(path)}#{m} | #{s}: Map.delete(#{generate_path(path)}#{m}.#{s}, :#{val})}" end
        }
    end
    plan = parse(path)
    code = generate(plan, val, [], op)
    Code.string_to_quoted(code) |> elem(1)
  end


  @doc ~S"""
    parse the syntax-tree and create a list of accessors

    iex> Stati.parse(quote do foo.bar.tralala end)
    [:foo, :bar, :tralala]
  """
  def parse(param, list \\ []) do
    case param do
      {{:., _line, [map, sub]}, _, []} ->
        parse(map, [sub | list])
      {name, _line, _} ->
        [name | list]
    end
  end

  defp generate_path([]) do
    ""
  end

  defp generate_path([h | t]) do
    "#{generate_path(t)}#{h}."
  end

  defp generate([m, s], val, path, final_op) do
    final_op.(m, s, val, path)
  end

  defp generate([m, s | t], val, path, final_op) do
    "%{ #{generate_path(path)}#{m} | #{s}: #{generate([s|t], val, [m | path], final_op)} }"
  end
end
