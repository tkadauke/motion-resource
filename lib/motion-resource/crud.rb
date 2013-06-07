module MotionResource
  class Base
    def save(options = {}, &block)
      run_callbacks :save do
        @new_record ? create(options, &block) : update(options, &block)
      end
    end
    
    def update(options = {}, &block)
      run_callbacks :update do
        self.class.put(member_url, :payload => build_payload(options)) do |response, json|
          self.class.request_block_call(block, json.blank? ? self : self.class.instantiate(json), response) if block
        end
      end
    end
  
    def create(options = {}, &block)
      # weird heisenbug: Specs crash without that line :(
      dummy = self
      run_callbacks :create do
        self.class.post(collection_url, :payload => build_payload(options)) do |response, json|
          self.class.request_block_call(block, json.blank? ? self : self.class.instantiate(json), response) if block
        end
      end
    end
    
    def self.create(attributes = {}, &block)
      new(attributes).tap do |model|
        model.create(&block)
      end
    end
  
    def destroy(&block)
      run_callbacks :destroy do
        self.class.delete(member_url) do |response, json|
          self.class.request_block_call(block, json.blank? ? nil : self.class.instantiate(json), response) if block
        end
      end
    end
    
    def reload(&block)
      self.class.get(member_url) do |response, json|
        self.class.request_block_call(block, json.blank? ? nil : self.class.instantiate(json), response) if block
      end
    end
    
  protected
    def build_payload(options)
      includes = Array(options[:include]).inject({}) do |hash, var|
        hash[var.to_s] = send(var).map(&:attributes)
        hash
      end
      
      { self.class.name.underscore => attributes.merge(includes) }
    end
  end
end
