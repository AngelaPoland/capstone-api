require "test_helper"

describe Intake do
  let(:intake) { Intake.new }

  it "must be valid" do
    value(intake).must_be :valid?
  end
end
