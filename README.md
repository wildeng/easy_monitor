# EasyMonitor
Easy monitor is a simple to use and install monitoring engine for Rails applications.
Its main goal is to add some endpoints that should give the heartbeat of the application,
check if the configured Redis server or Sidekiq are alive.

## Usage
After installing it, the plugin will add some namespaced routes that you can use to monitor your services.
Eg.

To check if your application is working:

```bash
curl -v http://localhost:3000/easy_monitor/health_checks/alive
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'easy_monitor'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install easy_monitor
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
