defmodule Calendar.ESpec.Assertions.BeTimedCloseToSpec do
  use ESpec, async: true
  use Calendar.ESpec

  describe "Calendar.ESpec.Assertions.BeTimedCloseToSpec" do
    describe "Success" do
      it "checks success with `to` and Date" do
        message = expect(~D[2017-01-02]).to be_timed_close_to ~D[2017-01-01], days: 1
        expect(message)
        |> to(eq "`~D[2017-01-02]` is close to `~D[2017-01-01]`. The difference is `days: 1`.")

      end

      it "checks success with `to` and NaiveDateTime" do
        message = expect(~N[2017-01-03 13:04:05.006007]).to be_timed_close_to ~N[2017-01-01 10:00:00], [
          days: 2,
          hours: 3,
          minutes: 4,
          seconds: 5,
          milliseconds: 6,
          microseconds: 7
        ]
        expect(message)
        |> to(
             eq "`~N[2017-01-03 13:04:05.006007]` is close to `~N[2017-01-01 10:00:00]`. The difference is " <>
                "`days: 2, hours: 3, minutes: 4, seconds: 5, milliseconds: 6, microseconds: 7`."
           )
      end

      it "checks success with `to` and DateTime" do
        message = expect(
          DateTime.from_naive!(~N[2017-01-03 13:04:05.006007], "Etc/UTC")
        ).to be_timed_close_to DateTime.from_naive!(~N[2017-01-01 10:00:00], "Etc/UTC"), [
          days: 2,
          hours: 3,
          minutes: 4,
          seconds: 5,
          milliseconds: 6,
          microseconds: 7
        ]

        expect(message)
        |> to(
             eq("`#DateTime<2017-01-03 13:04:05.006007Z>` is close to `#DateTime<2017-01-01 10:00:00Z>`. " <>
                  "The difference is `days: 2, hours: 3, minutes: 4, seconds: 5, milliseconds: 6, microseconds: 7`.")
           )
      end

      it "checks success with `to` and Time" do
        message = expect(~T[13:04:05.006007]).to be_timed_close_to ~T[10:00:00], [
          hours: 3,
          minutes: 4,
          seconds: 5,
          milliseconds: 6,
          microseconds: 7
        ]

        expect(message)
        |> to(eq("`~T[13:04:05.006007]` is close to `~T[10:00:00]`. The difference is " <>
                 "`hours: 3, minutes: 4, seconds: 5, milliseconds: 6, microseconds: 7`."))
      end
    end

    context "Error" do
      it "checks error message" do
        try do
          expect(~N[2017-01-04 13:04:05.006008]).to(
            be_timed_close_to(
              ~N[2017-01-01 10:00:00],
              [days: 2]
            )
          )
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(
                 eq(
                   "Expected `~N[2017-01-04 13:04:05.006008]` to be close to `~N[2017-01-01 10:00:00]`. " <>
                     "The difference is `days: 3, hours: 3, minutes: 4, seconds: 5, milliseconds: 6, microseconds: 8` what is " <>
                     "`days: 1, hours: 3, minutes: 4, seconds: 5, milliseconds: 6, microseconds: 8` above the delta."
                 )
               )
        end
      end
    end
  end
end
