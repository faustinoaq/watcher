# watcher

Crystal shard to watch file changes. This shard use the same code implemented [here (Guardian)](https://github.com/f/guardian/blob/master/src/guardian/watcher.cr#L45) and [here (Sentry)](https://github.com/samueleaton/sentry/blob/master/src/sentry.cr#L52).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  watcher:
    github: faustinoaq/watcher
```

## Usage

```crystal
require "watcher"

watch "src/assets/js/*.js" do |event|
  event.on_change do |files|
    files.each do |file, timestamp|
      puts "File #{file} has changed at #{timestamp}"
    end
    handle_change
  end
end
```

Use the keyword `watch` to watch files or file groups, for example:

```
watch ["src/assets/*.css", "src/views/*.html"] do |event|
  event.on_change do
    # ...
  end
end

watch "src/assets/bundle.js" do |event|
  event.on_change do
    # ...
  end
end
```

Also you can use `Watcher.watch` instead of `watch`.

# How does it work?

Watcher uses timestamps to check file changes every second, if you want some more advanced then you can use [Watchbird](https://github.com/agatan/watchbird) that uses `libnotify` to check events like modify, access and delete but just work in Linux for now.

## Contributing

1. Fork it ( https://github.com/faustinoaq/watcher/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [faustinoaq](https://github.com/faustinoaq) Faustino Aguilar - creator, maintainer
