# Calendar.ESpec
[![Build Status](https://travis-ci.org/bozydar/calendar_espec.svg?branch=master)](https://travis-ci.org/antonmi/espec)

## Installation

The package can be installed
by adding `calendar_espec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:calendar_espec, "~> 0.1.0", only: :test}
  ]
end
```

## Example

```elixir
defmodule Calendar.ESpec.Assertions.BeTimedSpec do
  use ESpec, async: true
  use Calendar.ESpec

  describe "Verifying a date" do
    it "checks a date`" do
      expect(~D[2017-01-01]).to be_timed :before, ~D[2017-01-02]        
    end
  end
end
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/calendar_espec](https://hexdocs.pm/calendar_espec).

