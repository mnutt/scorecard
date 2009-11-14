require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Scorecard::Formatter do

  before do
    @named_pipe_path = File.join(File.dirname(__FILE__), '..', '..', 'sandbox', 'named-pipe')
    
    # Remove any stale files
    FileUtils.rm(@named_pipe_path) if File.exist?(@named_pipe_path)
    ENV['SPEC_PIPE'] = @named_pipe_path
  end
  
  describe "named pipe" do
    it "should open on initialization" do
      File.exist?(@named_pipe_path).should be_false
      @formatter = Scorecard::Formatter.new(nil, nil)
      File.exist?(@named_pipe_path).should be_true
    end

    it "should close and remove" do
      @formatter = Scorecard::Formatter.new(nil, nil)
      File.exist?(@named_pipe_path).should be_true
      @formatter.close
      File.exist?(@named_pipe_path).should be_false
    end

    it "should not remove an existing pipe" do
      FileUtils.touch(@named_pipe_path)
      @formatter = Scorecard::Formatter.new(nil, nil)
      @formatter.close
      File.exist?(@named_pipe_path).should be_true
    end
  end

  describe "the start message" do
    before do
      @formatter = Scorecard::Formatter.new(nil, nil)
    end
    
    it "should display the correct example count" do
      @formatter.start(25)
      json_from_pipe['example_count'].should == 25
    end

    it "should pass the start event" do
      @formatter.start(1)
      json_from_pipe['event'].should == 'start'
    end
  end

  describe "examples" do
    before do
      @formatter = Scorecard::Formatter.new(nil, nil)
    end

    describe "a passing example" do
      before do
        @example = Scorecard::MockExample.new(:description => 'it should work')
        @example_group = Scorecard::MockExampleGroup.new(:description => 'passing examples')
        @formatter.start(1)
        @formatter.example_group_started(@example_group)
        @formatter.example_passed(@example)
      end

      it "should have a passing status" do
        json_from_pipe['status'].should == 'passed'
      end

      it "should have the correct group" do
        json_from_pipe['group'].should == "passing examples"
      end

      it "should have the correct description" do
        json_from_pipe['description'].should == 'it should work'
      end
    end

    describe "a failing example" do
      before do
        @failure = Scorecard::MockFailure.new(:exception_message => "This is an exception")
        
        @example = Scorecard::MockExample.new(:description => 'it might work')
        @example_group = Scorecard::MockExampleGroup.new(:description => 'questionable examples')
        
        @formatter.start(1)
        @formatter.example_group_started(@example_group)
        @formatter.example_failed(@example, 0, @failure)
      end

      it "should have a failing status" do
        json_from_pipe['status'].should == 'failed'
      end

      it "should have the correct group" do
        json_from_pipe['group'].should == 'questionable examples'
      end

      it "should have the correct description" do
        json_from_pipe['description'].should == 'it might work'
      end

      it "should have an exception message" do
        json_from_pipe['message'].should == "This is an exception"
      end
    end
  end

  def json_from_pipe
    json_string = `tail -n 1 #{@named_pipe_path}`
    JSON.parse(json_string)
  end

end
