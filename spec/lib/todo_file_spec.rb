require 'spec_helper'
require 'todo_file'

RSpec.describe TodoFile do
  describe '#add_tag_to_todo' do
    it 'appends tag the end of a line in the TODO file' do
      file_name = 'some_file_name'
      allow(File).to receive(:write)
      allow(File).to receive(:readlines).with(file_name).and_return(
        [
          "First TODO\n",
          "Second TODO\n",
          "Third TODO\n",
        ]
      )
      todo_file = TodoFile.new(file_name)

      todo_file.add_tag_to_todo(todo_number: 2, trello_tag: 'ABC')

      expect(File).to have_received(:write).with(
        file_name,
        "First TODO\n" \
          "Second TODO tr:ABC\n" \
          "Third TODO\n"
      )
    end
  end

  describe '#find_todo' do
    it 'returns a TODO corresponding to the provided TODO number' do
      file_name = 'some_file_name'
      allow(File).to receive(:readlines).with(file_name).and_return(
        [
          "First TODO\n",
          "Second TODO\n",
          "Third TODO\n",
        ]
      )
      todo_file = TodoFile.new(file_name)

      found_todo = todo_file.find_todo(number: 2)

      expect(found_todo).to eq('Second TODO')
    end
  end
end
