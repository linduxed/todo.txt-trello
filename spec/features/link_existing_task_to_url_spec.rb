require 'spec_helper'
require 'yaml'

RSpec.describe 'Link existing task to card URL' do
  context 'user provides task number and card URL' do
    it 'adds new task to database and modifies task in TODO_FILE' do
      todos = <<-EOF
        (A) Important email +read
        2016-11-26 Make phone call @personal
      EOF
      database_entries = <<-EOF
        ABC:
          url: "https://foo.bar/baz/quux"
          state: open
      EOF
      input_url = 'https://url.to/some/card'

      with_todo_file_and_database(todos, database_entries) do |todo_file, database, env_extension|
        executable = Executable.run(
          "link 2 #{input_url}",
          env_extension: env_extension,
        )

        expect(executable.error).to be_empty, "Error:\n#{executable.error}"
        expect(executable.exit_code).to eq(0)

        trello_tag_regex = /tr:([A-Z]+)/
        expect(executable.lines).to include(trello_tag_regex)
        expect(executable.lines).to include(/Make phone call/)
        new_trello_tag = executable.lines.join.match(trello_tag_regex)[1]

        parsed_db = YAML.safe_load(database)
        expect(parsed_db).to have_key(new_trello_tag)
        stored_db_entry = parsed_db.fetch(new_trello_tag)
        expect(stored_db_entry.fetch('url')).to eq(input_url)

        new_trello_tag_with_prefix = "tr:#{new_trello_tag}"
        all_todos = todo_file.readlines
        expect(all_todos).to include(/#{new_trello_tag_with_prefix}/)
        modified_todo = all_todos.find do |todo|
          todo.match(/#{new_trello_tag_with_prefix}/)
        end
        expect(modified_todo).to match(/Make phone call/)
      end
    end
  end
end
