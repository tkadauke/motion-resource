class DelegateObject
  attr_accessor :id, :name
end

describe "String" do
  it "should fill url params from params hash" do
    string = "accounts/:id/users/:name".fill_url_params(id: 10, name: 'john')
    string.should == "accounts/10/users/john"
  end
  
  it "should fill url params from delegate object" do
    obj = DelegateObject.new
    obj.id = 10
    obj.name = 'john'
    string = "accounts/:id/users/:name".fill_url_params({}, obj)
    string.should == "accounts/10/users/john"
  end
  
  it "should not crash when a param is unknown" do
    lambda { "accounts/:id".fill_url_params({}) }.should.not.raise
  end
  
  it "should not crash when params hash contains an unused value" do
    lambda { "accounts".fill_url_params(foo: 'bar') }.should.not.raise
  end
end
