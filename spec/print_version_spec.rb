require 'spec_helper'

RSpec.describe 'Printing version' do
  context 'user requests version with "todo.sh trello -v"' do
    specify 'version message is printed' do
      executable = Executable.run('-v')

      expect(executable.error).to be_empty, "Error:\n#{executable.error}"
      expect(executable.exit_code).to eq(0)
      expect(executable.lines).to include(/trello.+v\d+\.\d+\.\d+/)
    end
  end
end
