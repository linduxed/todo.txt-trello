class TodoFile
  def initialize(todo_file_path)
    @todo_file_path = todo_file_path
  end

  def add_tag_to_todo(todo_number:, trello_tag:)
    todos = File.readlines(@todo_file_path)
    original_todo = todos[todo_number - 1]

    todo_with_tag = original_todo.chomp + " tr:#{trello_tag}" + "\n"

    todos[todo_number - 1] = todo_with_tag
    File.write(@todo_file_path, todos.join)
  end

  def find_todo(number:)
    todos = File.readlines(@todo_file_path)
    todos[number - 1].chomp
  end
end
