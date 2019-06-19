# ExTack

**TODO: Add description**

## Installation

[Hex Docs](https://hex.pm/packages/ex_tack) -> Check out the documentation

```elixir
def deps do
  [
    {:ex_tack, "~> 0.0.1"}
  ]
end
```

Install the package with

- `mix deps.get`

## ExTack is simple to use

Version numbers should be in the following format.

- `"v1.2.3"` -> `"v1.2.3"`
- `"v1.2"`-> `"v1.2.0"`
- `"v1"`-> `"v1.0.0"`
- `"1"`-> `"v1.0.0"`
- `"1.1"`-> `"v1.1.0"`
- `"1.1.2"`-> `"v1.1.2"`

Line content should be expressed as binaries

- "Hello World"

```elixir
ExTack.create("v1.3.2") # => :ok

ExTack.update_or_create("v1.3.2", "my first change") # => :ok
```
