require "./watcher/*"

module Watcher
  TIMESTAMPS = {} of String => String

  # Class to save file changes
  private class WatchEvent
    property changed = false, files = {} of String => String
    getter interval

    def initialize(@interval : Int32 | Float64)
    end

    # Allow to yield a block when a file changes
    def on_change
      yield files if changed
    end
  end

  # Get file timestamp using File.stat
  def self.timestamp_for(file : String)
    File.stat(file).mtime.to_s("%Y%m%d%H%M%S.%L")
  end

  private def self.scanner(files, event)
    event.changed = false
    Dir.glob(files) do |file|
      timestamp = timestamp_for(file)
      if (TIMESTAMPS[file]? && TIMESTAMPS[file] != timestamp) || TIMESTAMPS[file]?.nil?
        TIMESTAMPS[file] = timestamp
        event.changed = true
        event.files[file] = timestamp
      end
    end
    event
  end

  # Allow to watch file changes using Watcher.watch
  def self.watch(files, interval : Int32 | Float64)
    event = WatchEvent.new(interval)
    loop do
      event = scanner(files, event)
      yield event
      event.files.clear
      sleep event.interval
    end
  end

  def self.watch(files)
    self.watch(files, 1)
  end
end

# Allow to watch file changes
def watch(files, interval)
  Watcher.watch(files, interval) do |event|
    yield event
  end
end

# :ditto:
def watch(files)
  watch(files, 1)
end
