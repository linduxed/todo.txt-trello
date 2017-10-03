class TodoFile
  class BadTodoNumber < StandardError; end

  def initialize(todo_file_path)
    @todo_file_path = todo_file_path
  end

  def add_tag_to_todo(todo_number:, trello_tag:)
    valid_todo_number?(todo_number) or raise BadTodoNumber

    original_todo = read_todo(number: todo_number)
    todo_with_tag = original_todo.chomp + " tr:#{trello_tag}" + "\n"

    overwrite_todo(number: todo_number, new_todo: todo_with_tag)
  end

  def find_todo(number:)
    valid_todo_number?(number) or raise BadTodoNumber

    read_todo(number: number)
  end

  private

  def overwrite_todo(number:, new_todo:)
    todos = File.readlines(@todo_file_path)
    todos[number - 1] = new_todo
    File.write(@todo_file_path, todos.join)
  end

  def read_todo(number:)
    todos = File.readlines(@todo_file_path)
    todos[number - 1].chomp
  end

  def valid_todo_number?(number)
    todo_count = File.readlines(@todo_file_path).count

    number > 0 && number <= todo_count
  end
end
