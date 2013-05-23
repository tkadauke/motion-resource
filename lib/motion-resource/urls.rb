module MotionResource
  class Base
    class_attribute :collection_url, :member_url
    class_attribute :root_url, :default_url_options
    class_attribute :extension
    self.extension = '.json'
    
    class << self
      def custom_urls(params = {})
        params.each do |name, url_format|
          define_method name do |params = {}|
            url_format.fill_url_params(params, self)
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
      self.class.collection_url_or_default.fill_url_params(params, self)
    end

    def member_url(params = {})
      self.class.member_url_or_default.fill_url_params(params, self)
    end
  end
end
