defmodule Calendar.ESpec.Assertions.BeTimedBetween do
  @moduledoc """
  Defines 'be_timed_between' assertion.

  it do: expect(~N[2017-01-02 10:00:00]).to be_timed_between(~N[2017-01-01 10:00:00], ~N[2017-01-03 10:00:00])
  """
  use ESpec.Assertions.Interface

  Enum.each [Date, Time, DateTime, NaiveDateTime], fn (module) ->
    defp match(%unquote(module){} = subject, [l, r]) do
      to_l = unquote(module).compare(subject, l) in [:gt, :eq]
      to_r = unquote(module).compare(subject, r) in [:lt, :eq]
      result = to_l and to_r
      {result, result}
    end
  end

  defp success_message(subject, [l, r], _result, positive) do
    to = if positive, do: "is", else: "is not"
    "`#{inspect subject}` #{to} between `#{inspect l}` and `#{inspect r}`."
  end

  defp error_message(subject, [l, r], result, positive) do
    to = if positive, do: "to", else: "not to"
    but = if result, do: "it is", else: "it isn't"
    "Expected `#{inspect subject}` #{to} be between `#{inspect l}` and `#{inspect r}`, but #{but}."
  end
end
