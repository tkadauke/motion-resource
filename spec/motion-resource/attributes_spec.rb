describe "attributes" do
  it "should define reader per attribute" do
    Shape.new.should.respond_to :contents
  end

  it "should define writer per attribute" do
    Shape.new.should.respond_to :contents=
  end

  it "should duplicate array in setter" do
    contents = ['hello']
    shape = Shape.new
    shape.contents = contents
    shape.contents.object_id.should != contents.object_id
  end

  it "should duplicate hash in setter" do
    contents = { :foo => 'bar' }
    shape = Shape.new
    shape.contents = contents
    shape.contents.should.not.be.identical_to contents
  end

  it "should behave regularly for other values in setter" do
    shape = Shape.new
    shape.contents = "hello"
    shape.contents.should == "hello"
  end

  it "should store attribute names in accessor" do
    Shape.attributes.should.include :contents
  end

  it "should inherit attribute names from parent class" do
    Rectangle.attributes.should.include :contents
    Rectangle.attributes.should.include :size
  end

  it "should get hash of all attributes from instance" do
    shape = Shape.new
    shape.contents = "hello"
    shape.attributes[:contents].should == "hello"
  end

  describe "update_attributes" do
    it "should set attr_accessors" do
      time = Time.now
      shape = Shape.new
      shape.update_attributes(:created_at => time)
      shape.created_at.should == time
    end

    it "should set attributes" do
      shape = Shape.new
      shape.update_attributes(:position => "10,10")
      shape.position.should == "10,10"
    end

    it "should not crash when updating an unknown attribute" do
      shape = Shape.new
      lambda { shape.update_attributes(:foo => 'bar') }.should.not.raise
    end
  end
end
