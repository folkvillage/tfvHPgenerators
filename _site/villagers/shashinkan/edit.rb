#!/usr/local/bin/ruby
# coding: UTF-8

begin	# デバッグ用


require "cgi"
#require_relative "../.login/login.rb"
require_relative "../../generate.rb"

# 保存ファイル名
List_filename = Generate.expand_path('data/shashinkan/list.rb')
# htmlソースファイル名
Src_filename = Generate.expand_path('src/villagers/shashinkan/index.html.erb')

# CGI
cgi = CGI.new

# ログインチェック
login = LOGIN.new(cgi);
exit if !login.state?
if !login.state?("kiroku")
	print login.loginPage()
	exit
end

# 更新ボタンが押されたか
list_text = cgi['list_text'].to_s
if !list_text.empty?
	File.write(List_filename, list_text)
	Generate.html(Src_filename, 'index.html')

	# 出力
	print login.setCookie_header()
	print "Content-Type: text/html; charset=UTF-8\n\n"
	print Generate.html(<<-EOS)
		<h2>更新完了</h2>
		<br>
		<a href="index.rb">見る</a>
	EOS
	
	exit
end

page = {
	shashinkan_edit_data: File.read(List_filename, encoding: 'utf-8'),
}

# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print Generate.html(DATA.read, "", page)	# ページ生成

# デバッグ用
rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end

__END__

<%
	page[:title] = "編集 - 写真館"
%>

<h2>写真館(編集)</h2>

<br>
<div id="shashinkan_edit">
	<form name="edit" method="post" action="edit.rb">
		<textarea name="list_text" cols=130 rows=40>
<%= page[:shashinkan_edit_data] %></textarea>
		<br>
		<input type="submit" value="更新">
	</form>
</div>

<style>
#shashinkan_edit form textarea {
	text-align: left;
	tab-size: 2;
}
</style>
