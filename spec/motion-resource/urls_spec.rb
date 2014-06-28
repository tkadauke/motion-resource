describe "urls" do
  it "should define collection url" do
    MotionResource::Base.should.respond_to :collection_url
  end

  it "should define member url" do
    MotionResource::Base.should.respond_to :member_url
  end

  it "should define root url" do
    MotionResource::Base.should.respond_to :root_url
  end

  it "should define url extension" do
    MotionResource::Base.should.respond_to :extension
  end

  it "should default to json for extension" do
    MotionResource::Base.extension.should == '.json'
  end

  it "should have a default collection URL" do
    Rectangle.collection_url_or_default.should == "rectangles"
  end

  it "should have a default member URL" do
    Rectangle.member_url_or_default.should == "rectangles/:id"
  end

  it "should have a default member URL with custom primary key" do
    Membership.member_url_or_default.should == "memberships/:membership_id"
  end

  it "should define custom url method" do
    comment = Comment.new
    comment.should.respond_to :by_user_url
    comment.by_user_url.should.is_a String
  end

  it "should accept params in custom url method" do
    comment = Comment.new
    comment.should.respond_to :by_user_url
    comment.by_user_url(name: "john").should == "comments/by_user/john"
  end

  it "should define custom url singleton method" do
    Comment.should.respond_to :by_user_url
    Comment.by_user_url.should.is_a String
  end

  it "should define convenience collection_url method" do
    comment = Comment.new
    comment.should.respond_to :collection_url
    comment.collection_url.should.is_a String
    comment.collection_url.should == 'comments'
  end

  it "should fall back to default URL in collection_url method" do
    rectangle = Rectangle.new
    rectangle.collection_url.should == 'rectangles'
  end

  it "should define convenience member_url method" do
    comment = Comment.new
    comment.should.respond_to :member_url
    comment.member_url.should.is_a String
    comment.member_url(id: 10).should == 'comments/10'
  end

  it "should fall back to default URL in collection_url method" do
    rectangle = Rectangle.new
    rectangle.member_url(:id => 10).should == 'rectangles/10'
  end

  it "should fall back to default URL in collection_url method with custom primary key" do
    membership = Membership.new
    membership.member_url(:membership_id => 10).should == 'memberships/10'
  end
end
