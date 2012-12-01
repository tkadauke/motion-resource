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

    private
      def complete_url(fragment)
        if fragment[0..3] == "http"
          return fragment
        end
        (self.root_url || MotionResource::Base.root_url) + fragment
      end

      def http_call(method, url, call_options = {}, &block)
        options = call_options 
        options.merge!(MotionResource::Base.default_url_options || {})
        url += self.extension
        if query = options.delete(:query)
          if url.index("?").nil?
            url += "?"
          end
          url += query.map{|k,v| "#{k}=#{v}"}.join('&')
        end
        if self.default_url_options
          options.merge!(self.default_url_options)
        end
        logger.log "#{method.upcase} #{complete_url(url)}"
        BubbleWrap::HTTP.send(method, complete_url(url), options) do |response|
          if response.ok?
            body = response.body.to_str.strip rescue nil
            logger.log "response: #{body}"
            if body.blank?
              block.call(response, {})
            else
              block.call response, BubbleWrap::JSON.parse(body)
            end
          else
            block.call response, nil
          end
        end
      end
    end
  end
end
