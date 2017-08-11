defmodule Calendar.ESpec.Assertions do

  alias Calendar.ESpec.Assertions

  def be_dated(operator, value) when operator in [:before, :after, :before_or_at, :after_or_at, :at, :not_at] do
    {Assertions.BeDated, [operator, value]}
  end

end