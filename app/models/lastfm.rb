module Lastfm
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Lastfm::Configuration.new
    yield(configuration)
  end
end
