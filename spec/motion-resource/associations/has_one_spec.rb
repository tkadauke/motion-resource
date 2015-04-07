describe "has_one" do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
  end
  
  it "should define reader" do
    User.new.should.respond_to :profile
  end
  
  it "should define writer" do
    User.new.should.respond_to :profile=
  end
  
  it "should define reset method" do
    User.new.should.respond_to :reset_profile
  end
  
  it "should by default return nil" do
    User.new.profile.should.be.nil
  end
  
  it "should reset" do
    user = User.new
    user.profile = Profile.new
    user.reset_profile
    user.profile.should.be.nil
  end
  
  describe "writer" do
    it "should create model when assigned with hash" do
      user = User.new
      user.profile = { :id => 1, :name => 'John', :email => 'doe@example.com' }
      user.profile.should.is_a Profile
    end
    
    it "should set attributes when assigned with hash" do
      user = User.new
      user.profile = { :id => 1, :name => 'John', :email => 'doe@example.com' }
      user.profile.name.should == 'John'
      user.profile.email.should == 'doe@example.com'
    end
    
    it "should use identity map when assigned with hash" do
      profile = Profile.instantiate(:id => 10)
      user = User.new
      user.profile = { :id => 10 }
      user.profile.should == profile
    end
    
    it "should act like a regular setter when assigned with object" do
      profile = Profile.new
      user = User.new
      user.profile = profile
      user.profile.should == profile
    end
  end
  
  describe "piggybacking" do
    it "should set association when returned with model" do
      stub_request(:get, "http://example.com/users/1.json").to_return(json: { id: 1, profile: { id: 2, name: 'John' } })
      User.find(1) do |result|
        @result = result
        resume
      end
      
      wait_max 1.0 do
        @result.profile.name.should == 'John'
      end
    end
  end
end
