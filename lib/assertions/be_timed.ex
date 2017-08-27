defmodule Calendar.ESpec.Assertions.BeTimed do
  @moduledoc """
  Defines 'be' assertion.
  
  it do: expect(~D[2017-01-01]).to be_timed :after, ~D[2016-12-31]
  """
  use ESpec.Assertions.Interface

  Enum.each [Date, Time, DateTime, NaiveDateTime], fn (module) ->
    defp match(%unquote(module){} = subject, [op, val]) do
      result = case unquote(module).compare(subject, val) do
        :gt -> op in [:>, :>=, :!=, :after, :after_or_at, :not_at]
        :lt -> op in [:<, :<=, :!=, :before, :before_or_at, :not_at]
        :eq -> op in [:==, :>=, :<=, :at, :before_or_at, :after_or_at]
      end
      {result, result}
    end
  end

  defp success_message(subject, [op, val], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} #{op} `#{inspect val}`."
  end  

  defp error_message(subject, [op, val], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"
    "Expected `#{inspect subject}` #{to} be #{op} `#{inspect val}`, but #{but}."
  end
end
