defmodule Calendar.ESpec.Assertions.BeTimedCloseTo do

  @doc false
  defmodule Duration do
    defstruct microseconds: 0, milliseconds: 0, seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0

    def new(opts) do
      struct(__MODULE__, opts)
    end

    def to_microseconds(%__MODULE__{} = duration) do
      duration.microseconds + duration.milliseconds * 1_000 + duration.seconds * 1_000_000 +
        duration.minutes * 1_000_000 * 60 + duration.hours * 1_000_000 * 60 * 60 +
        duration.days * 1_000_000 * 60 * 60 * 24 + duration.weeks * 1_000_000 * 60 * 60 * 24 * 7
    end

    def diff(%__MODULE__{} = left, %__MODULE__{} = right) do
      micro = to_microseconds(left) - to_microseconds(right)
      new(microseconds: micro)
      |> normalize
    end

    def normalize(%__MODULE__{} = duration) do
      {milliseconds, microseconds} = divmod(duration.milliseconds, duration.microseconds, 1_000)
      {seconds, milliseconds} = divmod(duration.seconds, milliseconds, 1_000)
      {minutes, seconds} = divmod(duration.minutes, seconds, 60)
      {hours, minutes} = divmod(duration.hours, minutes, 60)
      {days, hours} = divmod(duration.days, hours, 24)
      {weeks, days} = divmod(duration.weeks, days, 7)

      new(
        weeks: weeks,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds
      )
    end

    defp divmod(initial, left, right), do: {initial + div(left, right), rem(left, right)}

    def to_nice_form(%__MODULE__{} = duration) do
      duration = normalize(duration)

      if to_microseconds(duration) != 0 do
        non_zero_units = ([]
        ++ (if duration.weeks != 0, do: ["weeks: #{duration.weeks}"], else: [])
        ++ (if duration.days != 0, do: ["days: #{duration.days}"], else: [])
        ++ (if duration.hours != 0, do: ["hours: #{duration.hours}"], else: [])
        ++ (if duration.minutes != 0, do: ["minutes: #{duration.minutes}"], else: [])
        ++ (if duration.seconds != 0, do: ["seconds: #{duration.seconds}"], else: [])
        ++ (if duration.milliseconds != 0,
                        do: ["milliseconds: #{duration.milliseconds}"], else: [])
        ++ (if duration.microseconds != 0,
                        do: ["microseconds: #{duration.microseconds}"], else: []))

        Enum.join(non_zero_units, ", ")
      else
        "microseconds: 0"
      end
    end
  end

  @moduledoc """
  Defines 'be_timed_close_to' assertion.

  it do: expect(~N[2017-01-02 10:00:00]).to be_timed_close_to(~N[2017-01-01 10:00:00], days: 1)
  """
  use ESpec.Assertions.Interface

  Enum.each([Time, DateTime, NaiveDateTime], fn (module) ->
    defp match(%unquote(module){} = subject, [val, delta]) do
      microseconds = unquote(module).diff(subject, val, :microseconds)
      diff = Duration.new(microseconds: microseconds)

      delta_micro =
        delta
        |> Duration.new
        |> Duration.to_microseconds

      result = abs(Duration.to_microseconds(diff)) <= abs(delta_micro)
      {result, diff}
    end
  end)

  defp match(%Date{} = subject, [val, delta]) do
    diff = Duration.new(days: Date.diff(subject, val))

    delta_micro =
      delta
      |> Duration.new
      |> Duration.to_microseconds

    result = abs(Duration.to_microseconds(diff)) <= abs(delta_micro)
    {result, diff}
  end

  defp success_message(subject, [val, _delta], diff, positive) do
    to = if positive, do: "is close to", else: "is not close to"
    "`#{inspect subject}` #{to} `#{inspect val}`. The difference is `#{Duration.to_nice_form(diff)}`."
  end

  defp error_message(subject, [val, delta], diff, positive) do
    to = if positive, do: "to", else: "not to"
    delta = Duration.new(delta)
    delta_diff_diff = Duration.diff(diff, delta)
    "Expected `#{inspect subject}` #{to} be close to `#{inspect val}`. The difference is `#{Duration.to_nice_form(diff)}` what is `#{Duration.to_nice_form(delta_diff_diff)}` above the delta."
  end
end
