defmodule Calendar.ESpec.Assertions.BeDated do
  @moduledoc """
  Defines 'be_dated' assertion.
  
  it do: expect(~D[2017-01-01]).to be_dated :after, ~D[2016-12-31]
  """
  use ESpec.Assertions.Interface

  Calendar.ESpec.Assertions.Comparision.match(Date)

  defp success_message(subject, [op, val], _result, positive) do
    "`#{inspect subject} is #{op} #{inspect val}` is #{positive}."
  end  

  defp error_message(subject, [op, val], _result, positive) do
    "Expected `#{inspect subject} is #{op} #{inspect val}` to be `#{positive}` but got `#{!positive}`."
  end
end
