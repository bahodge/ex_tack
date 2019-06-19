
[![CircleCI](https://circleci.com/gh/bahodge/ex_tack/tree/master.svg?style=svg)](https://circleci.com/gh/bahodge/ex_tack/tree/master)

# ExTack

ExTack is a simple, lightweight and entirely elixir changelog library. Its purpose is to add support to create changelog files. Each release version is exported as a markdown file. These **UNMODIFIED** release files can be read in and interpreted.

### Future Plans

In the future, I want to add support for git hooks, deploy hooks and CI integration. I will also add support to exporting to CSV, PDF and txt file types.

## Installation

[Hex Docs](https://hex.pm/packages/ex_tack) -> Check out the documentation

```elixir
def deps do
  [
    {:ex_tack, "~> 0.0.1"}
  ]
end
```

## Get Started

- `mix deps.get`
- `iex -S mix # => Compiles the project and opens the interactive shell`
- `iex> ExTack.init() # => Creates the required directory structure`

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
