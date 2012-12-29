
#register new content type for Rails respond to. I'm not sure, this is needed:)
Mime::Type.register "text/rhtml", :erb

#register new content type for working with files
MIME::Types.add(MIME::Type.from_array("text/rhtml", %(erb)))