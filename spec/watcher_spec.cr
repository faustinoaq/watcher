require "./spec_helper"

describe Watcher do
  it "create timestamps correctly" do
    TIMESTAMP.size.should eq(18)
  end

  it "verify Watcher::WatchEvent.event.change" do
    Watcher.watch(TEST_FILE) do |event|
      event.changed = true
      event.changed.should eq(true)
      break
    end
  end

  it "verify Watcher::WatchEvent.event.files" do
    Watcher.watch(TEST_FILE) do |event|
      event.files.should eq({TEST_FILE => {true, TIMESTAMP}})
      break
    end
  end

  it "verify default WatcherEvent interval" do
    Watcher.watch(TEST_FILE) do |event|
      event.interval.should eq(1)
      break
    end
  end

  it "change WatcherEvent interval" do
    Watcher.watch(TEST_FILE, interval: 0.5) do |event|
      event.interval.should eq(0.5)
      break
    end
  end

  it "more than one watcher" do
    spawn do
      Watcher.watch(TEST_FILE) do |event|
        sleep 1
        File.delete("spec/foo").should eq(nil)
        break
      end
    end
    Watcher.watch(TEST_FILE) do |event|
      File.write("spec/foo", "")
      sleep 2
      break
    end
  end
end
