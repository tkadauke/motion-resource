describe "scope" do
  extend WebStub::SpecHelpers

  before do
    stub_request(:get, "http://example.com/comments/recent.json").to_return(json: [{ id: 1, text: 'Whats up?' }])
  end

  it "should define a custom url" do
    Comment.should.respond_to :recent_url
  end

  #TODO
  #it "should fetch collection" do
    #Comment.recent do |results|
      #@results = results
      #resume
    #end

    #wait_max 1.0 do
      #@results.size.should == 1
      #@results.first.text.should == 'Whats up?'
    #end
  #end

  #TODO
  #it "should give HTTP response to block" do
    #Comment.recent do |results, response|
      #@response = response
      #resume
    #end

    #wait_max 1.0 do
      #@response.should.be.success
    #end
  #end
end
