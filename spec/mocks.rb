module Scorecard
  class MockExample
    attr_accessor :description, :exception

    def initialize(opts={})
      @description, @exception = opts[:description], opts[:exception]
    end
  end

  class MockExampleGroup
    attr_accessor :description

    def initialize(opts={})
      @description = opts[:description]
    end
  end

  class MockFailure
    attr_accessor :exception, :pending_fixed

    def initialize(opts={})
      @exception = MockException.new(opts[:exception_message])
      @pending_fixed = opts[:pending_fixed]
    end
    
    def pending_fixed?
      @pending_fixed
    end
  end

  class MockException < NameError
    def backtrace
      []
    end
  end
end
