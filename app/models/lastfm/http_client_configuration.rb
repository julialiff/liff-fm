module Lastfm
  module HttpClientConfiguration
    private

    def base_url
      Lastfm.configuration.base_url
    end

    def auth_header
      { 'token' => Lastfm.configuration.token }
    end

    def basic_headers
      { 'User-Agent' => 'liff-fm-integration',
        'Content-Type' => 'application/json',
        'Accept' => 'application/json' }.merge(auth_header)
    end
  end
end
