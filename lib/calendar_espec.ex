defmodule Calendar.ESpec do
  defmacro __using__(_) do
    quote do
      import Calendar.ESpec.Configuration
      import Calendar.ESpec.Assertions
    end
  end
end