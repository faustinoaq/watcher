require "./watcher/*"

module Watcher
  TIMESTAMPS = {} of String => String

  private class WatchEvent
    property change = false, files = {} of String => String
    def on_change
      yield files if change
    end
  end

  # Get file timestamp using File.stat
  def self.timestamp_for(file : String)
    File.stat(file).mtime.to_s("%Y%m%d%H%M%S")
  end

  # Allow to watch file changes using Watcher.watch
  def self.watch(files)
    files = Dir.glob(files)
    files.each do |file|
      TIMESTAMPS[file] = timestamp_for(file)
    end
    event = WatchEvent.new
    loop do
      event.change = false
      event.files.clear
      files.each do |file|
        timestamp = timestamp_for(file)
        if TIMESTAMPS[file]? != timestamp
          TIMESTAMPS[file] = timestamp
          event.change = true
          event.files[file] = timestamp
        end
      end
      yield event
      sleep 1
    end
  end
end

# Allow to watch file changes
def watch(files)
  Watcher.watch(files)
end
