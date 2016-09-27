#!/usr/local/bin/ruby
# encoding: UTF-8

begin

require "cgi"
require_relative ".login/login.rb"

#データ保存ファイル名
filename = "../data/a-room/a-room.csv"

data = 1 #受け取ったデータが正しいか

cgi = CGI.new
$text = cgi["0"]
for i in 0...18 do
	#a0〜a18にデータを入れていく
	var = "@a#{i}"
	value = cgi[i]
	if i > 0 #csv形式に保存する変数text
		$text += "," + value
	end
	if value.empty? #データが不正ならbreak
		data = 0
		break
	end
	eval("#{var} = value")
end

$continue = cgi["continue"]#編集状態

#データ書き込み
if !$text.empty?
  open(filename, "w") do |file|
    file.write($text)
    end
end

print cgi.header("text/html; charset=utf-8")

if data==1
	# 新しいa-room.htmlを生成
#	src = File.read("a-room.html.erb", encoding: 'utf-8')
#	page = { 
#		aroom: [
#			{ CSV: "data/a-room/Friday.csv" },
#			{ CSV: "data/a-room/Saturday.csv" },
#			{ CSV: "data/a-room/Tuesday.csv" },
#		]
#	}
#	Generate.html(src, outfilename, page)
	Generate.generate("../src/villagers/a-room.html.erb", "a-room.html");
	
=begin
# 新しいa-room.htmlを生成
Generate.html(<<EOS, "a-room.html")
<%
	page[:title] = "A室枠表"
%>
<h2>A室枠表</h2>
<table class="hoge" summary="A室枠表" border="1">
<tr><th colspan="2">日付(金)</th><th colspan="2">日付(土)</th><th colspan="2">日付(火)</th></tr>
<tr>
<th width="50">朝枠</th>
<td>#{a0}</td>
<th width="50">7:00〜</th>
<td>#{a8}</td>

<td colspan="2"></td>
</tr>
<tr>
<th>一限</th>
<td>#{a1}</td>
<th>9:00〜</th>
<td>#{a9}</td>
<td colspan="2"></td>
</tr>

<tr>
<th>二限</th>
<td>#{a2}</td>
<th>10:30〜</th>
<td>#{a10}</td>
<td colspan="2"></td>
</tr>

<tr>
<th>昼</th>
<td>#{a3}</td>
<td colspan="2"></td>

<td colspan="2"></td>
</tr>

<tr>
<th>三限</th>
<td>#{a4}</td>
<th>12:00〜</th>
<td>#{a11}</td>
<th  width="50">三限</th>
<td>#{a15}</td>
</tr>

<tr>
<th>四限</th>
<td>#{a5}</td>
<th>13:30〜</th>
<td>#{a12}</td>
<th>四限</th>
<td>#{a16}</td>
</tr>

<tr>
<th>五限</th>
<td>#{a6}</td>
<th>15:00〜</th>
<td>#{a13}</td>
<th>五限</th>
<td>#{a17}</td>
</tr>

<tr>
<th>六限</th>
<td>#{a7}</td>
<th>16:30〜</th>
<td>#{14}</td>
<th>六限</th>
<td>#{a18}</td>
</tr>

</table>
<p><br>
	<a href=\"a-room-edit.rb\">編集</a>
</p>
EOS
=end

else
# 出力
# レスポンスヘッダ
#print "Content-Type: text/html; charset=UTF-8\n\n"

# HTML本体
srcStr = File.read(Generate.getRootdir + 'src/villagers/a-room-edit.html.erb', encoding: 'utf-8')
print Generate.html(srcStr, "", page)	# ページ生成
end

rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end

