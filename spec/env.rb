MotionResource::Base.root_url = 'http://example.com/'

class Post < MotionResource::Base
  attr_accessor :text
  
  self.member_url = 'posts/:id'
  
  has_many :comments
  has_many :parent_posts, :class_name => 'Post'
end

class Comment < MotionResource::Base
  attr_accessor :post_id, :text
  
  self.member_url = 'comments/:id'
  self.collection_url = 'comments'
  
  belongs_to :post
  
  scope :recent, :url => 'comments/recent'
  
  custom_urls :by_user_url => 'comments/by_user/:name'
end

class User < MotionResource::Base
  self.member_url = 'users/:id'
  
  has_one :profile
end

class Profile < MotionResource::Base
  attr_accessor :name, :email
end

class Shape < MotionResource::Base
  attribute :contents, :position
  attr_accessor :created_at
end

class Rectangle < Shape
  attribute :size
end

class Membership < MotionResource::Base
  self.primary_key = :membership_id
  attr_accessor :membership_id
end
