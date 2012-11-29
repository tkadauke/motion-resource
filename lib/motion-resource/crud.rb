module MotionResource
  class Base
    def save(&block)
      @new_record ? create(&block) : update(&block)
    end
    
    def update(&block)
      self.class.put(member_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json.blank? ? nil : self.class.instantiate(json) if block
      end
    end
  
    def create(&block)
      # weird heisenbug: Specs crash without that line :(
      dummy = self
      self.class.post(collection_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json.blank? ? nil : self.class.instantiate(json) if block
      end
    end
  
    def destroy(&block)
      self.class.delete(member_url) do |response, json|
        block.call json.blank? ? nil : self.class.instantiate(json) if block
      end
    end
    
    def reload(&block)
      self.class.get(member_url) do |response, json|
        block.call json.blank? ? nil : self.class.instantiate(json) if block
      end
    end
  end
end
