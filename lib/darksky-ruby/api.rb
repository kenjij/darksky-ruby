# darksky-ruby - Pure simple Ruby based Dark Sky API gem
# Copyright (c) 2019 Ken J.

require 'json'

class DarkSkyAPI
  VERSION = '1.0.2'
  DARKSKY_URL = 'https://api.darksky.net/'
  DARKSKY_PATH_TEMPLATE = '/forecast/%{key}/%{loc}'
  DARKSKY_BLOCK_NAMES = [
    :currently, :minutely, :hourly, :daily, :alerts, :flags
  ]

  attr_accessor :key, :latitude, :longitude, :location, :time, :options

  def initialize(key:, options: {})
    @key = key
    @options = options
  end

  def forecast(lat: @latitude, lon: @longitude, loc: @location, ts: @time)
    loc = "#{lat},#{lon}" if lat && lon
    loc = loc.gsub(/\s+/, '')
    raise ArgumentError, 'No location given to forecast' if loc.nil?
    ts = ts.to_i if ts.class == Time
    request(loc, ts)
  end

  def timemachine(lat: @latitude, lon: @longitude, loc: @location, ts:)
    forecast(lat: lat, lon: lon, loc: loc, ts: ts)
  end

  def blocks
    exc = options[:exclude]
    exc = (exc.nil? ? [] : exc.split(',').map { |n| n.to_sym })
    h = {}
    DARKSKY_BLOCK_NAMES.each { |n| h[n] = !exc.include?(n) }
    h
  end

  def blocks=(h)
    exc = DARKSKY_BLOCK_NAMES.select { |n| h[n] == false }
    options[:exclude] = exc.join(',')
  end

  def include_only(inc = [:currently])
    exc = DARKSKY_BLOCK_NAMES.select { |n| !inc.include?(n) }
    options[:exclude] = exc.join(',')
  end

  private

  def request(loc, ts)
    path = DARKSKY_PATH_TEMPLATE % {key: key, loc: loc}
    path += ",#{ts}" if ts
    o = (options.empty? ? nil : options)
    data = http.get(path: path, params: o)
    handle_response_data(data)
  end

  def http
    @http ||= Neko::HTTP.new(DARKSKY_URL)
  end

  def format_path(path)
    path = '/' + path unless path.start_with?('/')
    path + '.json'
  end

  def handle_response_data(data)
    if data[:code] != 200
      msg = "HTTP response error: #{data[:code]}\n#{data[:message]}"
      Neko.logger.error(msg)
      return nil
    end
    JSON.parse(data[:body], symbolize_names: true)
  end
end
