require "./watcher/*"

module Watcher
  TIMESTAMPS = {} of String => String

  @@interval = 1

  # Allow to change file scan time interval
  def self.interval=(value : Int32)
    @@interval = value
  end

  # Class to save file changes
  private class WatchEvent
    property status = false, files = {} of String => String

    # Allow to yield a block when a file changes
    def on_change
      yield files if status
    end
  end

  # Get file timestamp using File.stat
  def self.timestamp_for(file : String)
    File.stat(file).mtime.to_s("%Y%m%d%H%M%S")
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
  def self.watch(files)
    event = WatchEvent.new
    loop do
      event = scanner(files, event)
      yield event
      event.files.clear
      sleep @@interval
    end
  end
end

# Allow to watch file changes
def watch(files)
  Watcher.watch(files) do |event|
    yield event
  end
end
