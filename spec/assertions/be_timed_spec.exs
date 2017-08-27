defmodule Calendar.ESpec.Assertions.BeTimedSpec do
  use ESpec, async: true
  use Calendar.ESpec   # , operators: false # by default this option is enabled

  describe "Calendar.ESpec.Assertions.BeTimedSpec" do
    context "Success" do
      it "checks success with `to`" do
        message = expect(~D[2017-01-01]).to be_timed :before, ~D[2017-01-02]
        expect(message) |> to(eq "`~D[2017-01-01]` is before `~D[2017-01-02]`.")
      end

      it "checks success with `not_to`" do
        message = expect(~D[2017-01-02]).to_not be_timed :after, ~D[2017-01-03]
        expect(message) |> to(eq "`~D[2017-01-02]` is not after `~D[2017-01-03]`.")
      end

      it do: expect(~D[2017-01-02]).to be_timed :after, ~D[2017-01-01]
      it do: expect(~D[2017-01-02]).to_not be_timed :after, ~D[2017-01-03]

      it do: expect(~D[2017-01-01]).to be_timed :not_at, ~D[2017-01-02]
      it do: expect(~D[2017-01-01]).to_not be_timed :not_at, ~D[2017-01-01]
    end

    context "Errors" do
      it "checks error message" do
        try do
          expect(~D[2017-01-03]).to be_timed :after, ~D[2017-01-03]
        rescue
          error in [ESpec.AssertionError] ->
            expect(error.message)
            |> to(eq "Expected `~D[2017-01-03]` to be after `~D[2017-01-03]`, but it isn't.")
        end
      end
    end
  end
end
