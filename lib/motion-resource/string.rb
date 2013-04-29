class String
  # Takes in a hash and spits out the formatted string
  # Checks the delegate first
  def fill_url_params(params = {}, delegate = nil)
    params ||= {}
    split = self.split '/'
    url = split.collect { |path|
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
    url.build_query_string! params
  end

  def build_query_string!(params = {})
    return self if params.keys.empty?
    # fake a url so we avoid regex nastiness with URL's
    url = NSURL.URLWithString("http://blah.com/#{self}")
    # build our query string (needs encoding support!)
    query_string = params.map{|k,v| "#{k}=#{v}"}.join('&')
    if url.query.nil? || url.query.empty?
      # strip the beginning / and add the query
      self.replace "#{url.path[1..-1]}?#{query_string}"
    else
      self.replace "#{url.path[1..-1]}?#{url.query}&#{query_string}"
    end
  end

  def insert_extension!(extension)
    return self if extension.blank?
    
    url = NSURL.URLWithString(self)
    extension = extension.gsub(".", "")
    self.replace url.URLByAppendingPathExtension(extension).absoluteString
  end
end
