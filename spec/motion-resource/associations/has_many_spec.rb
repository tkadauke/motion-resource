describe "has_many" do
  extend WebStub::SpecHelpers
  
  it "should define reader" do
    Post.new.should.respond_to :comments
  end
  
  it "should define writer" do
    Post.new.should.respond_to :comments=
  end
  
  it "should define reset method" do
    Post.new.should.respond_to :reset_comments
  end
  
  it "should reset" do
    post = Post.new
    post.comments = [Comment.new]
    post.reset_comments
    post.comments.should == []
  end
  
  describe "reader" do
    extend WebStub::SpecHelpers
    
    before do
      stub_request(:get, "http://example.com/comments.json").to_return(json: [{ id: 1, text: 'Whats up?' }])
    end
    
    it "should by default return an empty array when called without a block" do
      Post.new.comments.should == []
    end
    
    it "should return any cached values when called without a block" do
      comment = Comment.new
      post = Post.new
      post.comments = [comment]
      post.comments.should == [comment]
    end
    
    it "should fetch resources when called with a block" do
      @post = Post.new
      @post.comments do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @results.size.should == 1
        @results.first.text.should == 'Whats up?'
      end
    end
    
    it "should return cached resources immediately if exist when called with a block" do
      comment = Comment.new
      @post = Post.new
      @post.comments = [comment]
      @post.comments do |results|
        results.should == [comment]
      end
    end
    
    it "should assign backward associations when fetching resources" do
      @post = Post.new
      @post.comments do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @results.first.post.should == @post
      end
    end
    
    it "should cache resources after fetching" do
      @post = Post.new
      @post.comments do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @post.comments.should == @results
      end
    end
  
    it "should give HTTP response to block" do
      @post = Post.new
      @post.comments do |results, response|
        @response = response
        resume
      end
      
      wait_max 1.0 do
        @response.should.be.ok
      end
    end
  end
  
  describe "writer" do
    it "should create model when assigned with hash" do
      post = Post.new
      post.comments = [{ :id => 1, :text => 'Whats up?' }]
      post.comments.first.should.is_a Comment
    end
    
    it "should set attributes when assigned with hash" do
      post = Post.new
      post.comments = [{ :id => 1, :text => 'Whats up?' }]
      post.comments.first.text.should == 'Whats up?'
    end
    
    it "should use identity map when assigned with hash" do
      comment = Comment.instantiate(:id => 10)
      post = Post.new
      post.comments = [{ :id => 10 }]
      post.comments.first.should == comment
    end
    
    it "should act like a regular setter when assigned with array" do
      post = Post.new
      post.comments = [Comment.new]
      post.comments.size.should == 1
    end
  end
  
  describe "piggybacking" do
    it "should set association when returned with model" do
      stub_request(:get, "http://example.com/posts/1.json").to_return(json: { id: 1, comments: [{ id: 2, text: 'Whats up?' }] })
      Post.find(1) do |result|
        @result = result
        resume
      end
      
      wait_max 1.0 do
        @result.comments.first.text.should == 'Whats up?'
      end
    end
  end
end
