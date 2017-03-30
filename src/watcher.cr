require "./watcher/*"

module Watcher
  TIMESTAMPS = {} of String => String

  private class WatchEvent
    property status = false, files = {} of String => String
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
      if TIMESTAMPS[file]? && TIMESTAMPS[file] != timestamp
        TIMESTAMPS[file] = timestamp
        event.status = true
        event.files[file] = timestamp
        puts "🤖  #{file}"
      elsif TIMESTAMPS[file]?.nil?
        TIMESTAMPS[file] = timestamp
        event.status = true
        event.files[file] = timestamp
        puts "🤖  watching file: #{file}"
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
      sleep 1
    end
  end
end

# Allow to watch file changes
def watch(files)
  Watcher.watch(files) do |event|
    yield event
  end
end
