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
    "`#{inspect subject} is #{op} #{inspect val}` is #{positive}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} is #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end

end
