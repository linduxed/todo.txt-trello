class TodoFile
  class BadTodoNumber < StandardError; end

  def initialize(todo_file_path)
    @todo_file_path = todo_file_path
  end

  def add_tag_to_todo(todo_number:, trello_tag:)
    valid_todo_number?(todo_number) or raise BadTodoNumber

    todos = File.readlines(@todo_file_path)
    original_todo = todos[todo_number - 1]

    todo_with_tag = original_todo.chomp + " tr:#{trello_tag}" + "\n"

    todos[todo_number - 1] = todo_with_tag
    File.write(@todo_file_path, todos.join)
  end

  def find_todo(number:)
    valid_todo_number?(number) or raise BadTodoNumber

    todos = File.readlines(@todo_file_path)
    todos[number - 1].chomp
  end

  private

  def valid_todo_number?(number)
    todo_count = File.readlines(@todo_file_path).count

    number > 0 && number <= todo_count
  end
end
