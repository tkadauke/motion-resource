module CallbackSpec
  class Model < MotionResource::Base
    self.member_url = 'models/:id'
    self.collection_url = 'models'

    before_create { |m| m.history << "before_create" }
    after_create { |m| m.history << "after_create" }
    before_save { |m| m.history << "before_save" }
    after_save { |m| m.history << "after_save" }
    before_update { |m| m.history << "before_update" }
    after_update { |m| m.history << "after_update" }
    before_destroy { |m| m.history << "before_destroy" }
    after_destroy { |m| m.history << "after_destroy" }

    def history
      @history ||= []
    end
  end
end

describe "base" do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers

  describe "callbacks" do
    it "should run create callbacks" do
      stub_request(:post, "http://example.com/models.json").to_return(json: {})
      @model = CallbackSpec::Model.create { |obj| resume }
      wait_max 1.0 do
        @model.history.should == ['before_create', 'after_create']
      end
    end

    it "should run create and save callbacks on first save" do
      stub_request(:post, "http://example.com/models.json").to_return(json: {})
      @model = CallbackSpec::Model.new
      @model.save { |obj| resume }
      wait_max 1.0 do
        @model.history.should == ['before_save', 'before_create', 'after_create', 'after_save']
      end
    end

    it "should run update and save callbacks on subsequent save" do
      stub_request(:put, "http://example.com/models/10.json").to_return(json: {})
      @model = CallbackSpec::Model.instantiate(:id => 10)
      @model.save { |obj| resume }
      wait_max 1.0 do
        @model.history.should == ['before_save', 'before_update', 'after_update', 'after_save']
      end
    end

    it "should run update callbacks" do
      stub_request(:put, "http://example.com/models/10.json").to_return(json: {})
      @model = CallbackSpec::Model.instantiate(:id => 10)
      @model.update { |obj| resume }
      wait_max 1.0 do
        @model.history.should == ['before_update', 'after_update']
      end
    end

    it "should run destroy callbacks" do
      stub_request(:delete, "http://example.com/models/10.json").to_return(json: {})
      @model = CallbackSpec::Model.instantiate(:id => 10)
      @model.destroy { |obj| resume }
      wait_max 1.0 do
        @model.history.should == ['before_destroy', 'after_destroy']
      end
    end
  end
end
