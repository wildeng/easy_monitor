# EasyMonitor
Easy monitor is a simple to use and install monitoring engine for Rails applications.
Its main goal is to add some endpoints that will give the heartbeat of the application or checking if the configured Redis server or Sidekiq are alive.

## Usage
After installing it, the plugin will add some namespaced routes that you can use to monitor your services.
Eg.

To check if your application is working:

```bash
curl -v http://localhost:3000/easy_monitor/health_checks/alive
```
To check if Redis is working:

```bash
curl -v http://localhost:3000/easy_monitor/health_checks/redis_alive
```
To check if Sidekiq is alive:

```bash
curl -v http://localhost:3000/easy_monitor/health_checks/sidekiq_alive
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

After installing the gem, open your Rails application routes file and add:
```ruby
mount EasyMonitor::Engine => '/easy_monitor'
```
This will mount the engine routes and you will be able to check the health status of your application.

## Contributing
If you want to contribute to the project clone the repository, work on it and open a PR for your changes.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
