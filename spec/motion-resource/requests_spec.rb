describe "requests" do
  extend WebStub::SpecHelpers

  it "should define GET method on instance and class" do
    Comment.new.should.respond_to :get
    Comment.should.respond_to :get
  end

  it "should define POST method on instance and class" do
    Comment.new.should.respond_to :post
    Comment.should.respond_to :post
  end

  it "should define PUT method on instance and class" do
    Comment.new.should.respond_to :put
    Comment.should.respond_to :put
  end

  it "should define DELETE method on instance and class" do
    Comment.new.should.respond_to :delete
    Comment.should.respond_to :delete
  end

  it "should add query string" do
    stub_request(:get, "http://example.com/comments/10.json?foo=bar").to_return(json: { id: 10 })
    Comment.new.get("comments/10", :query => { :foo => 'bar' }) do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should.not.be.nil
    end
  end

  it "should parse JSON in response" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(json: { id: 10, foo: 'bar' })
    Comment.new.get("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should == { "id" => 10, "foo" => "bar" }
    end
  end

  it "should yield empty hash if response is blank" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(body: "")
    Comment.new.get("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should == {}
    end
  end

  it "should yield nil if response is not ok" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(status_code: 404)
    Comment.new.get("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should.be.nil
    end
  end

  it "should get attributes" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(json: { id: 10, text: "Hello" })
    Comment.new.get("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result["text"].should == "Hello"
    end
  end

  it "should post" do
    stub_request(:post, "http://example.com/comments.json").to_return(json: { id: 10 })
    Comment.post("comments") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should.not.be.nil
    end
  end

  it "should put" do
    stub_request(:put, "http://example.com/comments/10.json").to_return(json: { id: 10 })
    Comment.new.put("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should.not.be.nil
    end
  end

  it "should delete" do
    stub_request(:delete, "http://example.com/comments/10.json").to_return(json: { id: 10 })
    Comment.new.delete("comments/10") do |response, json|
      @result = json
      resume
    end

    wait_max 1.0 do
      @result.should.not.be.nil
    end
  end

  it "should call a block given to on_auth_failure on 401" do
    stub_request(:get, "http://example.com/comments/10.json").to_return(status_code: 401)
    @fail = false
    Comment.on_auth_failure{ @fail = true }

    Comment.new.get("comments/10") do |response, json|
      resume
    end

    wait_max 1.0 do
      @fail.should == true
    end
  end
end
