require 'erb'
require 'spec/runner/formatter/base_text_formatter'
require 'spec/runner/formatter/no_op_method_missing'

class CukeappFormatter < Spec::Runner::Formatter::BaseTextFormatter
  include ERB::Util # for the #h method
  include Spec::Runner::Formatter::NOOPMethodMissing
  include Spec::Runner::Formatter
  
  def initialize(options, output)
    super
    @pipe = open(ENV['SPEC_PIPE'] || "/tmp/spec-pipe", "w+")
    at_exit { @pipe.close }
    @example_group_number = 0
    @example_number = 0
    @header_red = nil
  end
  
  # The number of the currently running example_group
  def example_group_number
    @example_group_number
  end
  
  # The number of the currently running example (a global counter)
  def example_number
    @example_number
  end
  
  def start(example_count)
    @example_count = example_count
  end

  def example_group_started(example_group)
    super
    @example_group_red = false
    @example_group_number += 1
  end

  def start_dump
    # no-op
  end

  def example_started(example)
    @example_number += 1
  end

  def example_passed(example)
    move_progress
    passed = {
      'status' => 'passed',
      'group' => @example_group.description,
      'description' => h(example.description)
    }
    @pipe.puts(passed.to_json)
    @pipe.flush
  end

  def example_failed(example, counter, failure)
    move_progress

    extra = extra_failure_content(failure)
    failure_style = failure.pending_fixed? ? 'pending_fixed' : 'failed'
    failed = {
      'status' => 'failed',
      'group' => @example_group.description,
      'description' => example.description,
      'message' => failure.exception.message,
      'backtrace' => format_backtrace(failure.exception.backtrace),
      'snippet' => extra
    }
    @pipe.puts(failed.to_json)
    @pipe.flush
  end

  def example_pending(example, message, deprecated_pending_location=nil)
    move_progress

    pending = {
      'status' => 'pending',
      'description' => example.description,
      'message' => h(message)
    }
    @pipe.puts(@pending.to_json)
    @pipe.flush
  end

  # Override this method if you wish to output extra HTML for a failed spec. For example, you
  # could output links to images or other files produced during the specs.
  #
  def extra_failure_content(failure)
    require 'spec/runner/formatter/snippet_extractor'
    @snippet_extractor ||= Spec::Runner::Formatter::SnippetExtractor.new
    @snippet_extractor.snippet(failure.exception)
  end
  
  def move_progress
    progress = { 'progress' => percent_done }
    @pipe.puts(progress.to_json)
    @pipe.flush
  end

  def percent_done
    result = 100.0
    if @example_count != 0
      result = ((example_number).to_f / @example_count.to_f * 1000).to_i / 10.0
    end
    result
  end

  def dump_failure(counter, failure)
    #no-op
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    if dry_run?
      totals = "This was a dry-run"
    else
      totals = "#{example_count} example#{'s' unless example_count == 1}, #{failure_count} failure#{'s' unless failure_count == 1}"
      totals << ", #{pending_count} pending" if pending_count > 0  
    end
  end
end
