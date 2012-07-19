require "spec_helper"

describe Liquor::Tag do
  it "requires a body" do
    expect { Liquor::Tag.new("hello") }.to raise_error
  end
end