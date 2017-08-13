require 'yaml'

class Database
  def initialize(database_path)
    @database_path = database_path
  end

  def add_record(url:, state: 'open')
    new_record = Record.new(tag: available_tag, url: url, state: state)
    write_record(new_record)
    new_record
  end

  private

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
    @all_records ||=
      YAML.safe_load(File.read(@database_path)).map do |tag, attrs|
        Record.new(tag: tag, url: attrs["url"], state: attrs["state"])
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
