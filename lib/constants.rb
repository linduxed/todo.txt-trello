module Constants
  VERSION = 'v0.0.1'.freeze
  CARD_DATABASE_PATH =
    ENV['TODO_TRELLO_DATABASE'] ||
    File.expand_path('trello_cards.yml', ENV['TODO_DIR'])
end
