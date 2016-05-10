defmodule Stati do
  @doc ~S"""
    change an element in an hierarchie of maps

    iex> mymap = %{ childmap: %{ other_val: 'foo', val: 4} }
    iex> Stati.change(mymap.childmap.val, 5)
    %{childmap: %{ other_val: 'foo', val: 5}}
  """
  defmacro change(param, val) do
    plan = parse(param)
    code = generate(plan, val, [])
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

  defp generate([m, s], val, path) do
    "%{ #{generate_path(path)} #{m} | #{s}: #{val}}"
  end

  defp generate([m, s | t], val, path) do
    "%{ #{generate_path(path)}#{m} | #{s}: #{generate([s|t], val, [m | path] )} }"
  end
end
