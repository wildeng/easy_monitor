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
curl -v http://localhost:3000/easy_monitor/caching_checks/redis_alive
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
gem 'easy_monitor', github: 'git://github.com/wildeng/easy_monitor.git.', tag: "0.2.0"
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
## Fixing Nokogiri on Apple Silicon

When bundle install fails on an M4 Mac with errors like fatal error: 'nokogiri_gumbo.h' file not found or issues with openssl@1.1, it is usually due to stale Intel-based configuration paths.

1. Clean Stale Configurations
Remove any global or local build flags that might be forcing the compiler to look for Intel libraries (like OpenSSL 1.1).

```bash
bundle config unset build.nokogiri
bundle config unset --global build.nokogiri
```

2. Install Native ARM Dependencies
Ensure you have the Apple Silicon versions of the required system libraries via Homebrew.

```bash
brew install libxml2 libxslt openssl@3
```

3. Manual Native Gem Installation
Manually install the gem while explicitly pointing to the ARM-native Homebrew prefixes. This bypasses Bundler's detection issues.

```bash
gem install nokogiri --version 1.19.3 -- \
  --use-system-libraries \
  --with-xml2-dir=$(brew --prefix libxml2) \
  --with-xslt-dir=$(brew --prefix libxslt) \
  --with-cflags="-I$(brew --prefix libxml2)/include" \
  --with-ldflags="-L$(brew --prefix libxml2)/lib"
```

4. Lockfile Alignment
Bundler will often try to re-compile if the Gemfile.lock allows the generic ruby platform. Force it to use the arm64-darwin platform.

Open Gemfile.lock.

Under the PLATFORMS section (at the bottom), remove ruby.

Ensure arm64-darwin is present.

Run the following:

```bash
# Tell bundler to prefer platform-specific gems
bundle config set --local force_ruby_platform false

# Finalize the install
bundle install
```

5. Verification
Confirm you are running the ARM-native version of the gem:

```bash
gem list nokogiri
# Expected output: nokogiri (1.19.3 arm64-darwin)
```

## Docker version for development

TODO

## Contributing
If you want to contribute to the project clone the repository, work on it and open a PR for your changes.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
