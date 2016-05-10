# Stati

Stati is a set of macros to do simple state manipulation, where state is a mixture
of encapsulated maps and arrays.

Lets assume there is a variable state with the value

```elixir
  state = %{ user: %{name: "foo", password: "bar"}, something: %{else: "bar"} }
```

and you want to change the password to "BAR" then you would normally do

```elixir
  ${state | user: %{ state.user | password: "BAR" }}
```

which is kind of ugly and becomes even worse if you have more levels.

```elixir
  Stati.change(state.user.password, "BAR")
```

Right now that only works with maps. Plan is to support lists as well.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add stati to your list of dependencies in `mix.exs`:

        def deps do
          [{:stati, "~> 0.0.1"}]
        end

  2. Ensure stati is started before your application:

        def application do
          [applications: [:stati]]
        end
