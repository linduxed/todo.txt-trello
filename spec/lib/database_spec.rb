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

    it 'raises error if database can not be parsed as a YAML file' do
      allow(FileUtils).to receive(:touch)
      allow(File).to receive(:read).and_return('foobar')
      allow(YAML).to receive(:safe_load).and_raise
      db = Database.new(random_file_name)

      expect { db.add_record(url: 'foo.bar') }.to raise_error(Database::BadDatabase)
    end

    it 'does not raise an error if database is empty' do
      allow(FileUtils).to receive(:touch)
      allow(File).to receive(:read).and_return('')
      allow(File).to receive(:write)
      db = Database.new(random_file_name)

      expect { db.add_record(url: 'foo.bar') }.not_to raise_error
    end
  end

  def random_file_name
    "foo-#{(Random.rand * 10_000).truncate}.bar"
  end
end