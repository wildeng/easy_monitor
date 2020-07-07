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
To check if ActiveRecord is working:

```bash
curl -v http://localhost:3000/easy_monitor/health_checks/active_record_alive
```

All responses come back with an HTTP code and a message using a JSON format, so that any kind of client can be used with it.
There's a WIP part that uses TOTP to validate the call adding a security layer.
TODO: a file with a list of trusted IP from where the request can come.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'easy_monitor', github: 'wildeng/easy_monitor'
```

And then execute:
```bash
$ bundle
```

After installing the gem, open your Rails application routes file and add:
```ruby
mount EasyMonitor::Engine => '/easy_monitor'
```
This will mount the engine routes and you will be able to check the health status of your application.

## InfluxDb

TODO

There's a WIP part using influxdb-rails gem.
I'm using it with a local docker container for InfluxDb:

```bash
docker pull influxdb
docker run --name <your_name> -p 8086:8086 influxdb
```

this will generate a container called <your_name> which can be used together with easy_monitor.
Remember that unless you don't mount a volume, the container data is not persistent and
whenever you delete the container, the data goes with it!

You can, however use a different way such as self hosting, aws etc.
There's a WIP rake task that will create an influxdb called easy_monitor and you can pass your
own host and port. It defaults to localhost and 8086:

```bash
bundle exec rake app:easy_monitor:easydb 
```

## Docker version for development

TODO

## Contributing
If you want to contribute to the project clone the repository, work on it and open a PR for your changes.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
