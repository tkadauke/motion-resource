class DelegateObject
  attr_accessor :id, :name
end

describe "url encoder" do

  before do
     @encoder = MotionResource::Base.url_encoder
  end

  it "should fill url params from params hash" do
    string = @encoder.fill_url_params( "accounts/:id/users/:name", { id: 10, name: 'john' } )
    string.should == "accounts/10/users/john"
  end

  it "should insert an extension if missing" do
    string = @encoder.insert_extension("accounts/fabulous",".json")
    string.should == "accounts/fabulous.json"
  end

  it "should not insert extension if it is blank" do
    string = @encoder.insert_extension("accounts/fabulous","")
    string.should == "accounts/fabulous"
  end

  it "should add a query string for non-url params" do
    string = @encoder.build_query_string("accounts/fabulous",{foo: 10, moo: "rar"})
    string.should == "accounts/fabulous?foo=10&moo=rar"
  end

  it "should not add a ? when building a query string if it exists" do
    string = @encoder.build_query_string("accounts/fabulous?",{foo: 10, moo: "rar"})
    string.should == "accounts/fabulous?foo=10&moo=rar"
  end

  it "should tag new query params onto existing ones" do
    string = @encoder.build_query_string("accounts/fabulous?moo=rar",{foo: 10})
    string.should == "accounts/fabulous?moo=rar&foo=10"
  end

  it "should fill url params from delegate object" do
    obj = DelegateObject.new
    obj.id = 10
    obj.name = 'john'
    string = @encoder.fill_url_params( "accounts/:id/users/:name", {}, obj)
    string.should == "accounts/10/users/john"
  end

  it "should not crash when a param is unknown" do
    lambda { @encoder.fill_url_params("accounts/:id",{}) }.should.not.raise
  end

  it "should not crash when params hash contains an unused value" do
    lambda { @encoder.fill_url_params("accounts",{foo:'bar'}) }.should.not.raise
  end

end
