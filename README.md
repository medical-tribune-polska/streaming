# Streaming
Adds streaming functionality to MT applications

## Usage
`/admin/stream/events`

`/stream/:slug`

## Updating gem
___
To copy migration to current application
```bash
rake streaming_engine:install:migrations
```

## Installation
___
Add this line to your application's Gemfile:

```ruby
gem 'streaming', git: 'git@github.com:medical-tribune-polska/streaming.git'
```

And then execute:
```bash
$ bundle
```

Add to `config/initializers/assets.rb`
```ruby
Rails.application.config.assets.precompile += %w[
  streaming/stream.js
  streaming/admin/stream.css
]
```

Add to `config/application`
```ruby
config.railties_order = [Streaming::Engine, :main_app, :all]
```
