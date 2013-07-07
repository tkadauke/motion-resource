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

## URL encoding

A different url encoding implementation can be substituted by setting MotionResource::Base.url_encoder.
For instance to include the fixed parameter 'foo' on every request:

    class CustomEncoder < MotionResource::UrlEncoder
        def build_query_string(url, params = {})
            params[:foo] => 42
            super(url,params)
        end
    end
    MotionResource::Base.url_encoder = CustomEncoder.new

## Error Handling

Pass a second block parameter to capture error information:

    User.find_all do |users, response|
      if response.ok?
        puts users.inspect
      else
        App.alert response.error_message
      end
    end

`response` will be an instance of [BubbleWrap::HTTP::Response](http://rdoc.info/github/rubymotion/BubbleWrap/master/file/README.md#HTTP)

## Reachability

It's important to check the reachability status of a host before making a request, or you may get intermitent connectivity errors.
For an example of how to do so, see `when_reachable` in [TinyMon](https://github.com/tkadauke/TinyMon).

## Setup

You can configure every model separately; however you will most likely want to configure things like the root_url the same for every model:

    MotionResource::Base.root_url = "http://localhost:3000/"

Don't forget the trailing '/' here!

# Forking

Feel free to fork and submit pull requests!

