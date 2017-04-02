require "spec"
require "../src/watcher"

TEST_FILE = "src/watcher.cr"

module Watcher

  # Allow to read interval value
  def self.interval
    @@interval
  end
end
