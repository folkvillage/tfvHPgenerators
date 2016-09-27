#!/usr/local/bin/ruby
# coding: UTF-8

require "cgi"
#require_relative "../.login/login.rb"
require_relative "../../generate.rb"

# 表示するページのソース
SrcStr = Generate.readFile("src/villagers/shashinkan/index.html.erb")

# LOGINチェック
login = LOGIN.new(CGI.new, true);
exit if !login.state?

page = {}
if login.state?("kiroku")
	page[:login_kiroku] = true;
end


# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print Generate.html(SrcStr, "", page)	# ページ生成

