# MotionResource

This is a library for using JSON APIs in RubyMotion apps. It is based on [RemoteModel](https://github.com/clayallsopp/remote_model), however it is an almost complete rewrite. Also, it is inspired by ActiveResource.

## Installation

Add MotionResource to your Gemfile, like this:

    gem "motion-resource"

## Example

Consider this example for a fictional blog API.

    class User < MotionResource::Base
      attr_accessor :id

      has_many :posts

      self.collection_url = "users"
      self.member_url = "users/:id"
    end

    class Post < MotionResource::Base
      attr_accessor :id
      attribute :user_id, :title, :text

      belongs_to :user

      self.collection_url = "users/:user_id/posts"
      self.member_url = "users/:user_id/posts/:id"
    end

Only attributes declared with `attribute` are transmitted on save. I.e. attributes declared with `attr_accessor` are considered read-only with respect to the JSON API.

Now, we can access a user's posts like that:

    User.find(1) do |user|
      user.posts do |posts|
        puts posts.inspect
      end
    end

Note that the blocks are called asynchronously.

## Setup

You can configure every model separately; however you will most likely want to configure things like the root_url the same for every model:

    MotionResource::Base.root_url = "http://localhost:3000/"

Don't forget the trailing '/' here!

# Forking

Feel free to fork and submit pull requests!
