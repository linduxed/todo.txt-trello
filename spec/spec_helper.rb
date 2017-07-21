require 'open3'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.disable_monkey_patching!
end

class Executable
  def self.run(args_string = '')
    new(args_string).tap(&:run)
  end

  def initialize(args_string)
    @args_string = args_string
  end

  def run
    _, @stdout, @stderr, @wait_thr = Open3.popen3(
      "#{binary_location} #{@args_string}"
    )
  end

  def lines
    @lines ||= @stdout.readlines.map(&:chomp)
  end

  def error
    @error ||= @stderr.read
  end

  def exit_code
    @wait_thr.value.exitstatus
  end

  private

  def binary_location
    File.expand_path('../../bin/trello', __FILE__)
  end
end
