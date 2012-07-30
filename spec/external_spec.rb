require "spec_helper"

describe Liquor::External do
  it "should export methods" do
    klass = Class.new do
      include Liquor::External

      def yes(param)
        "result #{param}"
      end
      export :yes

      def no
        "not accessible"
      end
    end

    klass.should respond_to(:liquor_exports)
    klass.liquor_exports.should == Set[:yes]

    obj = klass.new
    obj.liquor_send(:yes, 1).should == "result 1"
    expect { obj.liquor_send(:no) }.to raise_error
    expect { obj.liquor_send("yes", 1) }.not_to raise_error
  end

  it "should correctly support inheritance" do
    klass = Class.new do
      include Liquor::External

      def first
      end
      export :first
    end

    klass2 = Class.new(klass) do
      def second
      end

      def third
      end

      export :second, :third
    end

    klass.liquor_exports.should == Set[:first]
    klass2.liquor_exports.should == Set[:first, :second, :third]
  end

  it "should be callable" do
    klass = Class.new do
      include Liquor::External

      def static
        "hello"
      end

      def dynamic(var)
        "#{var} world"
      end

      def other
        self
      end

      export :static, :dynamic, :other
    end

    instance = klass.new

    exec(%Q|{{ ext.static }}|, ext: instance).should == 'hello'
    exec(%Q|{{ ext.other.static }}|, ext: instance).should == 'hello'
    expect { exec(%Q|{{ ext.dynamic }}|, ext: instance) }.to raise_error
    exec(%Q|{{ ext.dynamic() }}|, ext: instance).should == ' world'
    exec(%Q|{{ ext.dynamic('bye') }}|, ext: instance).should == 'bye world'
  end
end