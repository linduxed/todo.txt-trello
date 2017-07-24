require 'open3'
require 'tempfile'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.disable_monkey_patching!
end

class Executable
  def self.run(args_string = '', env_extension: {})
    new(args_string, env_extension).tap(&:run)
  end

  def initialize(args_string, env_extension)
    @args_string = args_string
    @env_extension = env_extension
  end

  def run
    old_env = ENV.to_h
    ENV.update(@env_extension)

    # NOTE: The "padding" word in the following command is necessary because
    # regular invocations of the add-on will have all arguments placed on and
    # after ARGV[1]. For more information, read the comment in
    # CLI#usage_requested_from_todo_help?.
    command = "#{binary_location} padding #{@args_string}"

    _, @stdout, @stderr, @wait_thr = Open3.popen3(command)

    ENV.replace(old_env)
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

def with_todo_file(todos)
  todo_file = Tempfile.new('todo.txt')
  todos.gsub!(/^\s+/, '')
  todo_file.write(todos)
  todo_file.rewind

  env_extension = {
    'TODO_FILE' => todo_file.path,
  }

  yield(todo_file, env_extension)

  todo_file.delete
end
