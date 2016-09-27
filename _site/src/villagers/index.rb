#!/usr/local/bin/ruby
# encoding: UTF-8

#
# villagers/ 以下の.htmlへのアクセスがあった場合、このスクリプトが処理します。
# (.htaccessに設定あり)
#

begin

require "cgi"
#require_relative ".login/login.rb"
require_relative "../generate.rb"


# CGI
cgi = CGI.new

# ログイン用データ読み取り
login = LOGIN.new(cgi);

# showリクエスト読み取り
show = cgi['show'].to_s

# ログインチェック(A室枠表の表示はログインチェック不要)
if !login.state? && File.basename(show) != "a-room.html"
	show = "villagers.html"
end

# showリクエストに応える
if !show.empty? && File.exist?(show) && File.extname(show) == ".html"
	print login.setCookie_header()
	print "Content-Type: text/html; charset=UTF-8\n\n"
	print `cat #{show}`
	exit
end

# ログイン状態を調べる
page = {loginstate_html: ""}
if login.state?("kiroku")
	page[:loginstate_html] << "<p>login: kiroku</p>"
end
if login.state?("admin")
	page[:loginstate_admin] = true
	page[:loginstate_html] << "<p>login: admin</p>"
end

# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了
# HTML本体
print Generate.html(Generate.readFile("src/villagers/index.html.erb"), "", page)


rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end

