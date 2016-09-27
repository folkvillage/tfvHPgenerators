#!/usr/local/bin/ruby
# encoding: UTF-8

# htmlは静的に生成するようにする




begin	# デバッグ用

require "cgi"
require 'csv'
require 'json'
#require_relative ".login/login.rb"
require_relative "../generate.rb"

# 設定ファイル
Setting_filename = Generate.getRootdir + 'data/entry/entry_setting.rb'

# デフォルト設定
default_setting = {
	tableCSV_num_row: 0,
	tableCSV_name_row: 2,
}
# 設定ファイル読み取り
Setting = default_setting.merge( eval File.read(Setting_filename, encoding: 'utf-8') )
PAreq_data = JSON.parse( File.read(Generate.getRootdir + Setting[:pareq][:datafile], encoding: 'utf-8') )

# page変数定義
page = {}

# PA表内容
pareq = {
	"num" => "0",
	"name" => "empty",
	"orig" => "",
	"members" => [
		{
			"name" => "",
			"part" => "",
			"mic" => false,
			"amp" => "",
			"monitor" => [],
			"detail" => "",
		},
	],
	"tunes" => [
		{
			"name" => "",
			"mc" => false,
			"detail" => "",
		},
	],
	"remarks" => "",
}

if false
	PAreq_data = {
		#'livename' => "ライブ名",
		'livename' => "サマフェス",
		'pareqs' => [],
	}
	35.times do
		PAreq_data['pareqs'].push( pareq )
	end
	File.write(Generate.getRootdir + Setting[:pareq][:datafile], JSON.pretty_generate(PAreq_data), encoding: 'utf-8')
end

# CGI
cgi = CGI.new

# ログインチェック
login = LOGIN.new(cgi, true);
exit if !login.state?


# GETリクエスト読み取り
num = cgi['num'].to_s		#編集する番号
edit = cgi['edit'].to_s		#編集するかどうか
send_data = cgi['send_data'].to_s		#編集後のデータ

# データの保存処理を行う
if !send_data.empty?
	data = JSON.parse(send_data.to_s)
	# 完成度チェック
#	if !data["name"].empty? && data["name"] != "empty"
#		data["complete"] = true;
#		if data["members"][0]["name"].empty?
#			data["complete"] = false;	 # メンバーがひとりもいない場合
#		end
#		for member in data["members"]
#			if member["name"].empty? ^ member["part"].empty?
#				data["complete"] = false;	 # 名前とパートのどちらかが埋まっていなかった場合
#			end
#		end
#		if data["tunes"][0]["name"].empty?
#			data["complete"] = false;	 # 曲がひとつもない場合
#		end
#	end
	# 保存
	PAreq_data['pareqs'][data['num'].to_i] = data
	File.write(Generate.getRootdir + Setting[:pareq][:datafile], JSON.pretty_generate(PAreq_data), encoding: 'utf-8')
end

# 処理分岐
if num.empty?	# 初期状態。一覧を表示する
	# 出力
	# レスポンスヘッダ
	print "Content-Type: text/html; charset=UTF-8\n"
	print login.setCookie_header()
	print "\n"	#レスポンスヘッダ終了
	
	# HTML本体
	page[:title] = "PA表"
	print Generate.html(<<-EOS, "", page)
		<h3>PA表</h3><br>
		<h3>#{PAreq_data['livename']}</h3><br>
		<div id="pareq_wrap" style="margin: auto;">
			<table style="margin: 20px auto; border-spacing: 0;">
				<thead>
					<tr>
						<th>出演順</th>
						<th>名前</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
				<% PAreq_data['pareqs'].each.with_index { |pareq,index| %>
					<% if index > 0 %>
					<tr>
						<td class="table_ordernum"><%= index %></td>
						<td class="table_name">
							<a href="pa-req.rb?num=<%= index %>&edit=1">
								<%= pareq['name'] %>
							</a>
						</td>
						<td class="table_view <%= (pareq['complete']==nil ? "":(pareq['complete']?"comp":"uncomp")) %>">
							<a href="pa-req.rb?num=<%= index %>">見る</a>
						</td>
					</tr>
					<% end %>
				<% } %>
				</tbody>
			</table>
		</div>
		<style>
		#pareq_wrap { max-width: 500px; }
		.table_ordernum{ padding: 7px; }
		.table_name{ width: 200px; }
		.table_view a{ display: block; width: 60px; height: 100%;/*border-radius: 5px;*/ background-color: rgba(255,255,255,0.5); }
		.comp a{ background-color: rgba(0,255,255,0.5); }
		.uncomp a{ background-color: rgba(255,50,0,0.5); }
		#pareq_wrap tr:nth-child(even) { background-color: rgba(255,255,255,0.5); }
		#pareq_wrap tr:nth-child(odd) { background-color: rgba(255,255,255,0.1); }
		</style>
		<script type="text/javascript"> $(function(){ switch_smartphone(); }); </script>
	EOS
	exit
elsif edit == "1"	# 編集ページを表示する
	page[:pareq_edit] = true
	page[:pareq] = pareq.merge( PAreq_data['pareqs'][num.to_i] )
	page[:pareq]['num'] = num
else	# 内容を見るだけ
	page[:pareq_edit] = false
	page[:pareq] = pareq.merge( PAreq_data['pareqs'][num.to_i] )
end


# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print Generate.html( File.read("../src/villagers/pa-req.html.erb", encoding: 'utf-8'), "", page)

# デバッグ用
rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end

