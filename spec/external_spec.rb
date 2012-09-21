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

      def with_hash(param, options={})
        "#{param} #{options.map{ |k,v| "#{k}: #{v}" }.join(" ")}"
      end

      export :static, :dynamic, :other, :with_hash
    end

    instance = klass.new

    exec(%Q|{{ ext.static }}|, ext: instance).should == 'hello'
    exec(%Q|{{ ext.other.static }}|, ext: instance).should == 'hello'
    expect { exec(%Q|{{ ext.dynamic }}|, ext: instance) }.to raise_error
    exec(%Q|{{ ext.dynamic() }}|, ext: instance).should == ' world'
    exec(%Q|{{ ext.dynamic('bye') }}|, ext: instance).should == 'bye world'
    exec(%Q|{{ ext.with_hash("1" two: "3") }}|, ext: instance).should == "1 two: 3"
  end

  it "should support indexing" do
    klass = Class.new do
      include Liquor::External

      def [](index)
        "element #{index}"
      end
      export :[]
    end

    instance = klass.new

    exec(%Q|{{ ext[10] }}|, ext: instance).should == 'element 10'
  end

  it "should wrap host errors" do
    klass = Class.new do
      include Liquor::External

      def fail
        Time.parse("nothing")
      end
      export :fail
    end

    instance = klass.new

    expect {
      exec(%Q|{{ ext.fail }}|, ext: instance)
    }.to raise_error(Liquor::HostError)
  end

  it "should index chained externals" do
    klass = Class.new do
      include Liquor::External

      def other
        self
      end

      def [](index)
        index
      end

      export :other, :[]
    end

    instance = klass.new

    exec(%Q|{{ ext.other[5] }}|, ext: instance).should == '5'
  end
end