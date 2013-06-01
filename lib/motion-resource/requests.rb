module MotionResource
  class Base
    HTTP_METHODS = [:get, :post, :put, :delete]

    HTTP_METHODS.each do |method|
      define_method method do |*args, &block|
        self.class.send(method, *args, &block)
      end
    end

    class << self
      def get(url, params = {}, &block)
        http_call(:get, url, params, &block)
      end

      def post(url, params = {}, &block)
        http_call(:post, url, params, &block)
      end

      def put(url, params = {}, &block)
        http_call(:put, url, params, &block)
      end

      def delete(url, params = {}, &block)
        http_call(:delete, url, params, &block)
      end

      def on_auth_failure(&block)
        @on_auth_failure = block
      end

      protected

      def decode_response( response, url, options )
        if response.ok?
          body = response.body.to_str.strip rescue nil
          logger.log "response: #{body}"
          if body.blank?
            return {}
          else
            return BubbleWrap::JSON.parse(body)
          end
        else
          if response.status_code.to_s =~ /401/ && @on_auth_failure
            @on_auth_failure.call
          end
          return nil
        end
      end

      private

      def complete_url(fragment)
        if fragment[0..3] == "http"
          return fragment
        end
        (self.root_url || MotionResource::Base.root_url) + fragment
      end

      def http_call(method, url, call_options = {}, &block)
        url = complete_url(url)

        options = call_options
        options.merge!(MotionResource::Base.default_url_options || {})
        if query = options.delete(:query)
          url = self.url_encoder.build_query_string(url, query)
        end
        if self.default_url_options
          options.merge!(self.default_url_options)
        end

        url = self.url_encoder.insert_extension(url, self.extension)

        logger.log "#{method.upcase} #{url}"
        logger.log "payload: #{options[:payload]}" if options[:payload]

        BubbleWrap::HTTP.send(method, url, options) do |response|
          block.call response, decode_response( response, url, options )
        end
      end
    end
  end
end
