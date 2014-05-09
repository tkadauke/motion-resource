describe "belongs_to" do
  extend WebStub::SpecHelpers
  
  it "should define reader" do
    Comment.new.should.respond_to :post
  end
  
  it "should define writer" do
    Comment.new.should.respond_to :post=
  end
  
  it "should define reset method" do
    Comment.new.should.respond_to :reset_post
  end
  
  it "should reset" do
    comment = Comment.new
    comment.post = Post.new
    comment.reset_post
    comment.post.should.be.nil
  end
  
  describe "reader" do
    extend WebStub::SpecHelpers
    
    before do
      stub_request(:get, "http://example.com/posts/1.json").to_return(json: { id: 1, text: 'Hello' })
    end
    
    it "should by default return nil when called without a block" do
      Comment.new.post.should.be.nil
    end
    
    it "should return any cached values when called without a block" do
      comment = Comment.new
      post = Post.new
      comment.post = post
      comment.post.should == post
    end
    
    it "should fetch resource when called with a block" do
      @comment = Comment.new(:post_id => 1)
      @comment.post do |result|
        @result = result
        resume
      end
      
      wait_max 1.0 do
        @result.text.should == 'Hello'
      end
    end
    
    it "should return cached resource immediately if exist when called with a block" do
      post = Post.new
      @comment = Comment.new
      @comment.post = post
      @comment.post do |result|
        result.should == post
      end
    end
    
    it "should give cached HTTP response immediately if exist when called with a block" do
      @comment = Comment.new
      @comment.post = Post.new
      @comment.instance_variable_set(:@post_response, "Test response")
      @comment.post do |result, response|
        response.should == "Test response"
      end
    end
    
    it "should cache resource after fetching" do
      @comment = Comment.new(:post_id => 1)
      @comment.post do |result|
        @result = result
        resume
      end
      
      wait_max 1.0 do
        @comment.post.should == @result
      end
    end
  
    it "should give HTTP response to block" do
      @comment = Comment.new(:post_id => 1)
      @comment.post do |results, response|
        @response = response
        resume
      end
      
      wait_max 1.0 do
        @response.should.be.success
      end
    end

    it "should return correct type of object" do
      stub_request(:get, "http://example.com/users/1.json").to_return(json: { id: 1, text: 'Hello' })
      @comment = Comment.new(:account_id => 1)
      @comment.account do |results, response|
        @account = results
        @response = response
        resume
      end
      wait_max 1.0 do
        @response.should.be.success
        @account.class.should == User
      end
    end

  end
  
  describe "writer" do
    it "should create model when assigned with hash" do
      comment = Comment.new
      comment.post = { :id => 1, :text => 'Hello' }
      comment.post.should.is_a Post
    end

    it "should convert hash to proper type" do
      comment = Comment.new
      comment.account = { :id => 1, :text => 'Hello' }
      comment.account.class.should == User
    end
    
    it "should set attributes when assigned with hash" do
      comment = Comment.new
      comment.post = { :id => 1, :text => 'Hello' }
      comment.post.text.should == 'Hello'
      comment.post.class.should == Post
    end
    
    it "should use identity map when assigned with hash" do
      post = Post.instantiate(:id => 10)
      comment = Comment.new
      comment.post = { :id => 10 }
      comment.post.should == post
    end
    
    it "should act like a regular setter when assigned with object" do
      post = Post.new
      comment = Comment.new
      comment.post = post
      comment.post.should == post
    end
    
    it "should set association id when assigned with hash" do
      comment = Comment.new
      comment.post = { :id => 10 }
      comment.post_id.should == 10
    end
    
    it "should set association id when assigned with object" do
      comment = Comment.new
      comment.post = Post.new(:id => 10)
      comment.post_id.should == 10
    end
  end
  
  describe "piggybacking" do
    it "should set association when returned with model" do
      stub_request(:get, "http://example.com/comments/1.json").to_return(json: { id: 1, post: { id: 2, text: 'Hello' } })
      Comment.find(1) do |result|
        @result = result
        resume
      end
      
      wait_max 1.0 do
        @result.post.text.should == 'Hello'
      end
    end
  end
end
