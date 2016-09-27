#!/usr/local/bin/ruby
# coding: UTF-8

#begin	# デバッグ用


require "cgi"
require_relative ".login/login.rb"

# 保存ファイル名
Data_filename = [
	Generate.expand_path('data/a-room/Friday.csv'),
	Generate.expand_path('data/a-room/Saturday.csv'),
	Generate.expand_path('data/a-room/Tuesday.csv'),
]

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
Data_text = [
	cgi['Data_text0'].to_s,
	cgi['Data_text1'].to_s,
	cgi['Data_text2'].to_s,
]
if !Data_text[0].empty?
	for num in 0..2 do
		File.write(Data_filename[num], Data_text[num])
	end
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
	edit_data: [
		File.read(Data_filename[0], encoding: 'utf-8'),
		File.read(Data_filename[1], encoding: 'utf-8'),
		File.read(Data_filename[2], encoding: 'utf-8'),
	]
}

# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print Generate.html(DATA.read, "", page)	# ページ生成

# デバッグ用
#rescue => evar
#	print "Content-Type: text/plain; charset=UTF-8\n\n"
#	p evar
#end

__END__

<%
	page[:title] = "編集 - A室枠表"
%>

<h2>A室枠表(編集)</h2>

<br>
<div id="aroom_edit">
	<form name="edit" method="post" action="a-room-edit-raw.rb">
		<% for num in 0..2 %>
		<textarea name="Data_text<%= num %>" cols=40 rows=20>
<%= page[:edit_data][num] %></textarea>
		<% end %>
		<br>
		<input type="submit" value="更新(保存してgenerate.rbを実行)">
	</form>
</div>

<style>
#aroom_edit form textarea {
	text-align: left;
	tab-size: 2;
}
</style>

<script>
$(function() {
	switch_smartphone();
});
</script>
