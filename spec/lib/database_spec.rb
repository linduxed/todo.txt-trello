require 'spec_helper'
require 'database'

RSpec.describe Database do
  describe '#add_record' do
    it 'creates database if not already present' do
      file_name = random_file_name
      allow(FileUtils).to receive(:touch)
      allow(File).to receive(:write)
      allow(File).to receive(:read).with(file_name).and_return('foo: bar')
      db = Database.new(file_name)

      db.add_record(url: 'foo.bar')

      expect(FileUtils).to have_received(:touch).with(file_name)
    end
  end

  def random_file_name
    "foo-#{(Random.rand * 10_000).truncate}.bar"
  end
end
