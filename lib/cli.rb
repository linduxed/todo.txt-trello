require_relative './constants'

# Main class for user interaction.
class CLI
  def run
    output =
      case
      when usage_requested_from_todo_help?
        usage_message
      when %w(usage -h --help).include?(ARGV[1])
        usage_message
      when %w(-v --version).include?(ARGV[1])
        version_message
      end

    $stdout.puts output
    exit 0
  end

  private

  def usage_requested_from_todo_help?
    # Normally the add-on will be invoked as a subcommand (like
    # `todo.sh trello foo`), meaning that the actual trello-action, along with
    # its various arguments, will be placed in ARGV[1] and higher.
    #
    # The only exception to this case is when the add-on is invoked through
    # `todo.sh help`. This command will iterate through all available add-ons
    # and invoke them like `trello usage`, meaning that the action will be
    # present in ARGV[0].

    ARGV[0] == 'usage'
  end

  def usage_message
    usage_message = <<-EOF
      Trello intergration:
        Provides a way to synchronize the state of tasks with Trello cards on
        a specified board, as set up in the trello_config.yml file.

        Synchronization state between the tasks in the TODO_FILE and the
        various cards on the configured Trello board is stored in the
        trello_cards.yml file.

        trello [-h|--help|-v|--version]

        -h, --help      Displays help message.
        -v, --version   Displays version information.
    EOF

    # Remove leading indentation
    usage_message.gsub(/^#{usage_message.scan(/^[ \t]*(?=\S)/).min}/, '')
  end

  def version_message
    "trello #{Constants::VERSION}"
  end
end
