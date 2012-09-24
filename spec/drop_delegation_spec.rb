require 'liquor/drop'

describe Liquor::DropDelegation do
  before :all do
    class TestModel
      include Liquor::Dropable
    end

    class TestModelDrop < Liquor::Drop
    end
  end

  after :all do
    Object.send :remove_const, :TestModel
    Object.send :remove_const, :TestModelDrop
  end

  it "should correctly unwrap drop classes" do
    Liquor::DropDelegation.unwrap_drop_class(TestModelDrop).should == TestModel
  end
end