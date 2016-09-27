#!/usr/bin/env ruby
# coding: UTF-8

require 'webrick'
include WEBrick

# .rbファイルもcgiと認識する
module WEBrick::HTTPServlet
	FileHandler.add_handler('rb', CGIHandler)
end

s = HTTPServer.new(
	:Port => 8000,
	:DocumentRoot => File.join(Dir::pwd, "/_site/"),
#	:CGIInterpreter => "/usr/bin/ruby -Eutf-8:utf-8",
)
trap("INT"){ s.shutdown }
s.start
