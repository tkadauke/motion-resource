describe "find" do
  extend WebStub::SpecHelpers

  it "should find single record" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(json: { id: 10 })
    Comment.find(10) do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.is_a Comment
    end
  end

  it "should find collection" do
    stub_request(:get, "http://example.com/comments.json").to_return(json: [{ id: 10 }])
    Comment.find_all do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.is_a Array
      @result.first.should.is_a Comment
    end
  end

  it "should fetch member with custom URL" do
    stub_request(:get, "http://example.com/foo.json").to_return(json: { id: 10 })
    Comment.fetch_member("foo") do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.is_a Comment
    end
  end

  it "should give nil object if fetching single member fails" do
    stub_request(:get, "http://example.com/foo.json").to_return(status_code: 404)
    Comment.fetch_member("foo") do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.be.nil
    end
  end

  it "should fetch collection with custom URL" do
    stub_request(:get, "http://example.com/bar.json").to_return(json: [{ id: 10 }])
    Comment.fetch_collection("bar") do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.is_a Array
      @result.first.should.is_a Comment
    end
  end

  it "should allow hash JSON response with model name as root" do
    stub_request(:get, "http://example.com/bar.json").to_return(json: { comments: [{ id: 10 }] })
    Comment.fetch_collection("bar") do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.is_a Array
      @result.first.should.is_a Comment
    end
  end

  #it "should allow hash JSON response with custom JSON root" do
    #stub_request(:get, "http://example.com/bar.json").to_return(json: { custom: [{ id: 10, text: '42' }] })
    #CustomRootComment.fetch_collection("bar") do |result|
      #@result = result
      #resume
    #end

    #wait_max 1.0 do
      #@result.should.is_a Array
      #@result.first.should.is_a CustomRootComment
      #@result.first.text.should == '42'
    #end
  #end

  it "should give nil object if fetching collection fails" do
    stub_request(:get, "http://example.com/bar.json").to_return(status_code: 404)
    Comment.fetch_collection("bar") do |result|
      @result = result
      resume
    end

    wait_max 1.0 do
      @result.should.be.nil
    end
  end
end
