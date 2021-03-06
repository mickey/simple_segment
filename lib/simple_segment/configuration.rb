module SimpleSegment
  class Configuration
    include SimpleSegment::Utils

    attr_reader :write_key, :on_error

    def initialize(settings = {})
      symbolized_settings = symbolize_keys(settings)
      @write_key = symbolized_settings[:write_key]
      @on_error = symbolized_settings[:on_error] || proc {}
      raise ArgumentError, 'Missing required option :write_key' unless @write_key
    end
  end
end
