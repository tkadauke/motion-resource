module MotionResource

  class UrlEncoder

    def fill_url_params( url, params = {}, delegate = nil)
      params ||= {}
      url = url.split( '/' ).collect { |path|
        ret = path
        if path[0] == ':'
          path_sym = path[1..-1].to_sym

          curr = nil
          if delegate && delegate.respond_to?(path_sym)
            curr = delegate.send(path_sym)
          end

          ret = (curr || params.delete(path_sym) || path).to_s
        end

        ret
      }.join '/'
      self.build_query_string( url, params )
    end

    def build_query_string(url, params = {})
      return url if params.keys.empty?
      # fake a url so we avoid regex nastiness with URL's
      url = NSURL.URLWithString("http://blah.com/#{url}")
      # build our query string (needs encoding support!)
      query_string = params.to_query
      if url.query.nil? || url.query.empty?
        # strip the beginning / and add the query
        "#{url.path[1..-1]}?#{query_string}"
      else
        "#{url.path[1..-1]}?#{url.query}&#{query_string}"
      end
    end

    def insert_extension(url,extension)
      return url if extension.blank?

      url = NSURL.URLWithString(url)
      extension = extension.gsub(".", "")
      url.URLByAppendingPathExtension(extension).absoluteString
    end

  end

end
