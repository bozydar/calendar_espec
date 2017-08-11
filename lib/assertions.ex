defmodule Calendar.ESpec.Assertions do

  alias Calendar.ESpec.Assertions

  def be_timed(operator, value) do
    {Assertions.BeTimed, [operator, value]}
  end

end