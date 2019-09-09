# darksky-ruby

[![Gem Version](https://badge.fury.io/rb/kajiki.svg)](http://badge.fury.io/rb/kajiki)

Pure simple Ruby based [Dark Sky API](https://darksky.net/dev/) gem

## Install

```
$ gem install darksky-ruby
```

## Use

### [Forecast Request](https://darksky.net/dev/docs#forecast-request)

Example of querying weather forecast for [SFO](https://www.airport-sfo.com/).

```ruby
require 'darksky-ruby'

api = DarkSkyAPI.new(key: 'Your_Dark_Sky_API_Secret_Key')
data = api.forecast(lat: 37.6211, lon: -122.383)
p data[:hourly][:summary]
# => "Partly cloudy throughout the day."
```

### [Time Machine Request](https://darksky.net/dev/docs#time-machine-request)

Requesting observed weather for noon of Jan. 1, 2018 at SFO.

```ruby
data = api.timemachine(lat: 37.6211, lon: -122.383, ts: Time.new(2018,1,1,12))
p data[:currently][:temperature]
# => 57.56
```

### [Response Format](https://darksky.net/dev/docs#response-format)

`data` in above examples would contain a Ruby Hash of the entire API response; all keys are symbolized.

### Options

You can limit the response data size by excluding unnecessary blocks.

```ruby
api.blocks = {minutely: false, hourly: false} # excludes blocks marked false
api.include_only([:currently, :alerts]) # excludes everything except specified
api.blocks
# => {:currently=>true, :minutely=>false, :hourly=>false, :daily=>false,
#     :alerts=>true, :flags=>false}
```

Hint, you can use `api.blocks` first to get a default Hash to get started. After you've modified the Hash, you can save it with `api.blocks =`.

Other options can be set like so.

```ruby
api.options = {lang: 'es', units: 'si'} # Spanish language, SI units
data = api.timemachine(lat: 37.6211, lon: -122.383, ts: Time.new(2018,1,1,12))
p data[:currently][:summary]
# => "Parcialmente Nublado"
p data[:currently][:temperature]
# => 14.2
```

## CLI

This gem includes an executable as an example.

```
$ darksky -h
darksky [options] <LAT,LON>
  -k, --key=<s>     API secret key
  -l, --loc=<s>     Location (latitude,longtitude)
  -o, --log=<s>     Log file
  -t, --time=<s>    Timestamp for Time Machine request
  -v, --verbose     Verbose mode
  -h, --help        Show this message
```

## More

Since this is a simple gem with no external dependencies, you can directly include the `lib` contents in your project if you prefer not to use Ruby Gems, such as in [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/ruby-package.html). If you do, be sure to include my copyright and license details.
