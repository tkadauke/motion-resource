describe "crud" do
  extend WebStub::SpecHelpers
  
  describe "create" do
    it "should create on save if record is new" do
      stub_request(:post, "http://example.com/comments.json").to_return(json: { id: 1 })
      comment = Comment.new
      comment.save do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end
  
    it "should create with json in response" do
      stub_request(:post, "http://example.com/comments.json").to_return(json: { id: 1 })
      comment = Comment.new
      comment.create do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end
  
    it "should create without json in response" do
      stub_request(:post, "http://example.com/comments.json").to_return(body: "")
      comment = Comment.new
      comment.create do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.be.nil
      end
    end
  end
  
  describe "update" do
    it "should update on save if record already exists" do
      stub_request(:put, "http://example.com/comments/10.json").to_return(json: { id: 10 })
      comment = Comment.instantiate(:id => 10)
      comment.save do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end

    it "should update with json in response" do
      stub_request(:put, "http://example.com/comments/10.json").to_return(json: { id: 10 })
      comment = Comment.instantiate(:id => 10)
      comment.update do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end
  
    it "should update without json in response" do
      stub_request(:put, "http://example.com/comments/10.json").to_return(body: "")
      comment = Comment.instantiate(:id => 10)
      comment.update do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.be.nil
      end
    end
  end

  describe "destroy" do
    it "should destroy with json in response" do
      stub_request(:delete, "http://example.com/comments/10.json").to_return(json: { id: 10 })
      comment = Comment.instantiate(:id => 10)
      comment.destroy do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end
  
    it "should destroy without json in response" do
      stub_request(:delete, "http://example.com/comments/10.json").to_return(body: "")
      comment = Comment.instantiate(:id => 10)
      comment.destroy do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.be.nil
      end
    end
  end

  describe "reload" do
    it "should reload with json in response" do
      stub_request(:get, "http://example.com/comments/10.json").to_return(json: { id: 10 })
      comment = Comment.instantiate(:id => 10)
      comment.reload do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.not.be.nil
      end
    end
  
    it "should reload without json in response" do
      stub_request(:get, "http://example.com/comments/10.json").to_return(body: "")
      comment = Comment.instantiate(:id => 10)
      comment.reload do |result|
        @result = result
        resume
      end
    
      wait_max 1.0 do
        @result.should.be.nil
      end
    end
  end
end
