require "spec_helper"

describe Liquor::SourceMappedError do
  it "decorates source" do
    source = "line 1\nthis is an error"
    error  = Liquor::SourceMappedError.new("error", line: 1, start: 11, end: 15)
    error.decorate(source).should == [
      "this is an error",
      "~~~~~~~~~~~^^^^^"
    ]
    error.as_json.should == {
      message:  'error',
      location: {
        line:  1,
        start: 11,
        end:   15
      }
    }
  end
end