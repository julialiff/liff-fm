module Resources
  module HttpClient
    extend ActiveSupport::Concern

    included do
      attr_accessor :connection_prt

      def connection
        @connection_prt || @connection_prt = Faraday.new(url: base_url) do |faraday|
          faraday.use Faraday::Response::RaiseError
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end

      def contextualize_options(method, options)
        # Decomposing the hash here, so that we can
        # better arrange validations and stuff
        url = options[:url].to_s
        headers = basic_headers.to_h.merge(options[:headers].to_h)
        payload = options[:payload].to_s
        params = options[:params].nil? ? {} : options[:params]
        internal_options = OpenStruct.new(default_options.merge(options[:options].to_h))

        connection.send(method.to_sym) do |req|
          req.url(url)
          req.headers = headers
          req.body = payload
          req.params = params
          req.options = internal_options
        end
      end

      def post(options)
        contextualize_options(:post, options)
      end

      def get(options)
        contextualize_options(:get, options)
      end

      def delete(options)
        contextualize_options(:delete, options)
      end

      def put(options)
        contextualize_options(:put, options)
      end

      def default_options
        {
          timeout: 20,
          open_timeout: 2
        }
      end

      def parse_json_response(response)
        parsed_response = JSON.parse(response.body)
        if parsed_response.class == Array
          parsed_response.map(&:deep_symbolize_keys)
        else
          parsed_response.deep_symbolize_keys
        end
      end

      def expect_success(response, _payload = nil)
        return if response.success?
        raise response.try(:body) || 'HttpClient ERROR'
      end

      private

      def response_values(env)
        { status: env.status, headers: env.response_headers, body: env.body }
      end
    end
  end
end
