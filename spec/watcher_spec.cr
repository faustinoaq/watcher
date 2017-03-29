require "./spec_helper"

describe Watcher do
  it "create timestamps correctly" do
    timestamp = Watcher.timestamp_for(TEST_FILE)
    timestamp.size.should eq(14)
  end

  it "verify Watcher::WatchEvent.event.change" do
    Watcher.watch TEST_FILE do |event|
      event.change = true
      event.change.should eq(true)
      break
    end
  end

  it "verify Watcher::WatchEvent.event.files" do
    Watcher.watch TEST_FILE do |event|
      event.files[TEST_FILE] = timestamp = Watcher.timestamp_for(TEST_FILE)
      event.files.should eq({TEST_FILE => timestamp})
      break
    end
  end
end
