module MotionResource
  class Base
    class_attribute :collection_url, :member_url
    class_attribute :root_url, :default_url_options
    class_attribute :extension
    class_attribute :url_encoder

    self.extension = '.json'
    self.url_encoder = UrlEncoder.new

    class << self
      def custom_urls(params = {})
        params.each do |name, url_format|
          define_method name do | method_params = {} |
            self.url_encoder.fill_url_params( url_format, method_params, self )
          end
          define_singleton_method name do
            url_format
          end
        end
      end
      
      def collection_url_or_default
        collection_url || name.underscore.pluralize
      end
      
      def member_url_or_default
        member_url || "#{name.underscore.pluralize}/:#{primary_key}"
      end

    end

    def collection_url(params = {})
      self.class.url_encoder.fill_url_params( self.class.collection_url_or_default, params, self )
    end

    def member_url(params = {})
      self.class.url_encoder.fill_url_params( self.class.member_url_or_default, params, self )
    end
  end
end
