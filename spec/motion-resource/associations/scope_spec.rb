describe "scope" do
  extend WebStub::SpecHelpers
  
  it "should define a custom url" do
    Comment.should.respond_to :recent_url
  end
  
  it "should fetch collection" do
    stub_request(:get, "http://example.com/comments/recent.json").to_return(json: [{ id: 1, text: 'Whats up?' }])
    
    Comment.recent do |results|
      @results = results
      resume
    end
    
    wait_max 1.0 do
      @results.size.should == 1
      @results.first.text.should == 'Whats up?'
    end
  end
end
