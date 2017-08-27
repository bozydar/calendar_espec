defmodule Calendar.ESpec.Assertions.Comparision do
  defmodule Date do
    if Keyword.has_key?(Elixir.Date.__info__(:functions), :diff) do
      def diff(left, right) do
        Elixir.Date.diff(left, right)
      end
    else
      def diff(%{calendar: Calendar.ISO, year: year1, month: month1, day: day1},
            %{calendar: Calendar.ISO, year: year2, month: month2, day: day2}) do
        Calendar.ISO.date_to_iso_days_days(year1, month1, day1) -
          Calendar.ISO.date_to_iso_days_days(year2, month2, day2)
      end

      def diff(%{calendar: calendar1} = date1, %{calendar: calendar2} = date2) do
        if Calendar.compatible_calendars?(calendar1, calendar2) do
          {days1, _} = to_iso_days(date1)
          {days2, _} = to_iso_days(date2)
          days1 - days2
        else
          raise ArgumentError, "cannot calculate the difference between #{inspect date1} and #{inspect date2} because their calendars are not compatible and thus the result would be ambiguous"
        end
      end

      defp to_iso_days(%{calendar: Calendar.ISO, year: year, month: month, day: day}) do
        {naive_datetime_to_iso_days(year, month, day), {0, 86400000000}}
      end
      defp to_iso_days(%{calendar: calendar, year: year, month: month, day: day}) do
        naive_datetime_to_iso_days(year, month, day, 0, 0, 0, {0, 0})
      end
      def naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond) do
        {date_to_iso_days_days(year, month, day),
          time_to_day_fraction(hour, minute, second, microsecond)}
      end
      def date_to_iso_days_days(0, 1, 1) do
        0
      end
      def date_to_iso_days_days(1970, 1, 1) do
        719528
      end
      def date_to_iso_days_days(year, month, day) do
        :calendar.date_to_gregorian_days(year, month, day)
      end
      def time_to_day_fraction(0, 0, 0, {0, _}) do
        {0, 86400000000}
      end

      @seconds_per_minute 60
      @seconds_per_hour 60 * 60
      @seconds_per_day 24 * 60 * 60 # Note that this does _not_ handle leap seconds.
      @microseconds_per_second 1_000_000
      def time_to_day_fraction(hour, minute, second, {microsecond, _}) do
        combined_seconds = hour * @seconds_per_hour + minute * @seconds_per_minute + second
        {combined_seconds * @microseconds_per_second + microsecond, @seconds_per_day * @microseconds_per_second}
      end
    end
  end

  defmodule DateTime do
    if Keyword.has_key?(Elixir.DateTime.__info__(:functions), :diff) do
      def compare(left, right, unit \\ :second) do
        Elixir.DateTime.diff(left, right, unit)
      end
    else
      def diff(%{utc_offset: utc_offset1, std_offset: std_offset1} = datetime1,
            %{utc_offset: utc_offset2, std_offset: std_offset2} = datetime2, unit \\ :second) do
        naive_diff =
          (datetime1 |> to_iso_days() |> Calendar.ISO.iso_days_to_unit(unit)) -
            (datetime2 |> to_iso_days() |> Calendar.ISO.iso_days_to_unit(unit))
        offset_diff =
          (utc_offset2 + std_offset2) - (utc_offset1 + std_offset1)
        naive_diff + System.convert_time_unit(offset_diff, :second, unit)
      end

      defp to_iso_days(%{calendar: calendar,year: year, month: month, day: day,
        hour: hour, minute: minute, second: second, microsecond: microsecond}) do
        calendar.naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond)
      end
    end
  end

  defmodule Time do
    if Keyword.has_key?(Elixir.Time.__info__(:functions), :compare) do
      def compare(left, right) do
        Elixir.DateTime.compare(left, right)
      end
    else
      def compare(time1, time2) do
        {parts1, ppd1} = to_day_fraction(time1)
        {parts2, ppd2} = to_day_fraction(time2)

        case {parts1 * ppd2, parts2 * ppd1} do
          {first, second} when first > second -> :gt
          {first, second} when first < second -> :lt
          _ -> :eq
        end
      end

      defp to_day_fraction(%{hour: hour, minute: minute, second: second, microsecond: {_, _} = microsecond, calendar: calendar}) do
        calendar.time_to_day_fraction(hour, minute, second, microsecond)
      end
    end
  end

  defmodule NaiveDateTime do
    if Keyword.has_key?(Elixir.NaiveDateTime.__info__(:functions), :compare) do
      def compare(left, right) do
        Elixir.DateTime.compare(left, right)
      end
    else
      def compare(%{calendar: calendar1} = naive_datetime1, %{calendar: calendar2} = naive_datetime2) do
        if Calendar.compatible_calendars?(calendar1, calendar2) do
          case {to_iso_days(naive_datetime1), to_iso_days(naive_datetime2)} do
            {first, second} when first > second -> :gt
            {first, second} when first < second -> :lt
            _ -> :eq
          end
        else
          raise ArgumentError, """
          cannot compare #{inspect naive_datetime1} with #{inspect naive_datetime2}.
          This comparison would be ambiguous as their calendars have incompatible day rollover moments.
          Specify an exact time of day (using `DateTime`s) to resolve this ambiguity
          """
        end
      end

      defp to_iso_days(%{calendar: calendar, year: year, month: month, day: day,
        hour: hour, minute: minute, second: second, microsecond: microsecond}) do
        calendar.naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond)
      end
    end
  end
end