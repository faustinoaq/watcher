require "./watcher/*"

module Watcher
  TIMESTAMPS = {} of String => String

  # Class to save file changes
  private class WatchEvent
    property status = false, files = {} of String => String
    getter interval

    def initialize(@interval : Int32)
    end

    # Allow to yield a block when a file changes
    def on_change
      yield files if status
    end
  end

  # Get file timestamp using File.stat
  def self.timestamp_for(file : String)
    File.stat(file).mtime.to_s("%Y%m%d%H%M%S.%L")
  end

  private def self.scanner(files, event)
    event.status = false
    Dir.glob(files) do |file|
      timestamp = timestamp_for(file)
      if (TIMESTAMPS[file]? && TIMESTAMPS[file] != timestamp) || TIMESTAMPS[file]?.nil?
        TIMESTAMPS[file] = timestamp
        event.status = true
        event.files[file] = timestamp
      end
    end
    event
  end

  # Allow to watch file changes using Watcher.watch
  def self.watch(files, interval = 1)
    event = WatchEvent.new(interval)
    loop do
      event = scanner(files, event)
      yield event
      event.files.clear
      sleep event.interval
    end
  end
end

# Allow to watch file changes
def watch(files)
  Watcher.watch(files) do |event|
    yield event
  end
end
