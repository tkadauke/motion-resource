module MotionResource
  class Base
    def save(&block)
      run_callbacks :save do
        @new_record ? create(&block) : update(&block)
      end
    end
    
    def update(&block)
      run_callbacks :update do
        self.class.put(member_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
          self.class.request_block_call(block, json.blank? ? self : self.class.instantiate(json), response) if block
        end
      end
    end
  
    def create(&block)
      # weird heisenbug: Specs crash without that line :(
      dummy = self
      run_callbacks :create do
        self.class.post(collection_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
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
  end
end
