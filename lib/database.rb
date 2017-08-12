require 'yaml'

class Database
  def initialize(database_path)
    @database_path = database_path
  end

  def add_record(url:, state: 'open')
    new_record = {
      available_tag => {
        'url' => url,
        'state' => state,
      }
    }

    new_database_contents = new_record.merge(database_contents)

    File.write(@database_path, YAML.dump(new_database_contents))

    new_database_contents
  end

  private

  def available_tag
    all_tags = database_contents.keys

    tag = 'A'
    tag.succ! while all_tags.include?(tag)

    tag
  end

  def database_contents
    @database_contents ||= YAML.safe_load(File.read(@database_path))
  end
end
