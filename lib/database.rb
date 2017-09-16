require 'yaml'
require 'fileutils'

class Database
  class BadDatabase < StandardError; end

  def initialize(database_path)
    @database_path = database_path
  end

  def add_record(url:, state: 'open')
    create_database_if_it_does_not_exist

    new_record = Record.new(tag: available_tag, url: url, state: state)
    write_record(new_record)
    new_record
  end

  private

  def create_database_if_it_does_not_exist
    FileUtils.touch(@database_path)
  end

  def write_record(record)
    File.write(@database_path, records_to_yaml(all_records + [record]))
  end

  def available_tag
    all_tags = all_records.map(&:tag)

    tag = 'A'
    tag.succ! while all_tags.include?(tag)

    tag
  end

  def all_records
    @all_records ||= database_from_yaml.map do |tag, attrs|
      Record.new(tag: tag, url: attrs["url"], state: attrs["state"])
    end
  end

  def database_from_yaml
    raw_database = File.read(@database_path)

    begin
      YAML.safe_load(raw_database)
    rescue
      raise BadDatabase, 'Could not parse database as YAML'
    end
  end

  def records_to_yaml(records)
    all_record_hash = records.map(&:to_h).reduce({}) { |a, e| a.merge(e) }
    YAML.dump(all_record_hash)
  end
end

class Database::Record
  def initialize(tag:, url:, state:)
    @tag = tag
    @url = url
    @state = state
  end

  attr_reader :tag, :url, :state

  def to_h
    {
      @tag => {
        "url" => @url,
        "state" => @state,
      }
    }
  end
end
