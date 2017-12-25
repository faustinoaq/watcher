require "spec"
require "../src/watcher"

TEST_FILE = "src/watcher.cr"
TIMESTAMP = Watcher.timestamp_for(TEST_FILE)
