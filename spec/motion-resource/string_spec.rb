class DelegateObject
  attr_accessor :id, :name
end

describe "String" do
  it "should fill url params from params hash" do
    string = "accounts/:id/users/:name".fill_url_params(id: 10, name: 'john')
    string.should == "accounts/10/users/john"
  end

  it "should insert an extension if missing" do
    string = "accounts/fabulous".insert_extension!(".json")
    string.should == "accounts/fabulous.json"
  end

  it "should not insert extension if it is blank" do
    string = "accounts/fabulous".insert_extension!("")
    string.should == "accounts/fabulous"
  end

  it "should add a query string for non-url params" do
    string = "accounts/fabulous".build_query_string!(foo: 10, moo: "rar")
    string.should == "accounts/fabulous?foo=10&moo=rar"
  end

  it "should not add a ? when building a query string if it exists" do
    string = "accounts/fabulous?".build_query_string!(foo: 10, moo: "rar")
    string.should == "accounts/fabulous?foo=10&moo=rar"
  end

  it "should tag new query params onto existing ones" do
    string = "accounts/fabulous?moo=rar".build_query_string!(foo: 10)
    string.should == "accounts/fabulous?moo=rar&foo=10"
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
