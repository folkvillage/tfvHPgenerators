#!/usr/local/bin/ruby
# coding: UTF-8

# Web上でサイトの更新を行うページ。うまくうごかないため削除するかもしれない


begin	# デバッグ用


require "cgi"
require_relative ".login/login.rb"

# 保存ファイル名
Data_filename = Generate.expand_path('data/page_setting.rb')

# CGI
cgi = CGI.new

# ログインチェック
login = LOGIN.new(cgi);
exit if !login.state?
if !login.state?("admin")
	print login.loginPage()
	exit
end

# 更新ボタンが押されたか
Data_text = cgi['Data_text'].to_s
if !Data_text.empty?
	File.write(Data_filename, Data_text)
	#Generate.html(Src_filename, 'index.html')

	# 出力
	print login.setCookie_header()
	print "Content-Type: text/html; charset=UTF-8\n\n"
	print Generate.html(<<-EOS)
		<h2>更新完了</h2>
	EOS

	# 更新適用処理
	Dir.chdir(Generate.getRootdir) do
		`./generate.rb`
		# Generate.main()		# generate.rb実行
	end
	
	exit
end

page = {
	edit_data: File.read(Data_filename, encoding: 'utf-8'),
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
	page[:title] = "編集"
%>

<h2>編集</h2>

<br>
<div id="edit">
	<form name="edit" method="post" action="edit.rb">
		<textarea name="Data_text" cols=130 rows=40>
<%= page[:edit_data] %></textarea>
		<br>
		<input type="submit" value="更新(保存してgenerate.rbを実行)">
	</form>
</div>

<style>
#edit form textarea {
	text-align: left;
	tab-size: 2;
}
</style>
