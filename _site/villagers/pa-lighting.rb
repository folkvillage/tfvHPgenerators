#!/usr/local/bin/ruby
# encoding: UTF-8

# htmlは静的に生成するようにする




begin	# デバッグ用

require "cgi"
require 'csv'
require_relative ".login/login.rb"

# 設定ファイル
Setting_filename = Generate.getRootdir + 'data/entry/entry_setting.rb'

# デフォルト設定
default_setting = {
	tableCSV_num_row: 0,
	tableCSV_name_row: 2,
}
# 設定ファイル読み取り
Setting = default_setting.merge( eval File.read(Setting_filename, encoding: 'utf-8') )
PAreq_data = eval File.read(Generate.getRootdir + Setting[:pareq][:datafile], encoding: 'utf-8')

# page変数定義
page = {}

page[:pareq_available] = Setting[:pareq][:pareq_available]

# PA表内容
pareq = {
	name: "",
	members: [
		{
			name: "",
			instrument: "",
			detail: "",
		},
	],
	tunes: [
		{
			name: "",
			artists: "",
			song: "",
			detail: "",
		},
	],
	remarks: "",
}

# CGI
cgi = CGI.new

# ログインチェック
login = LOGIN.new(cgi);
#exit if !login.state?


# GETリクエスト読み取り
num = cgi['num'].to_s		#編集する番号
edit = cgi['edit'].to_s		#編集するかどうか
data = cgi['send_data'].to_s		#編集後のデータ

# 処理分岐
if num.empty?	# 初期状態。一覧を表示する
	# 出力
	# レスポンスヘッダ
	print "Content-Type: text/html; charset=UTF-8\n"
	print login.setCookie_header()
	print "\n"	#レスポンスヘッダ終了
	
	# HTML本体
	print Generate.html(<<-EOS, "", page)
		<h3>PA表</h3>
		<h3>ライブ名</h3>
		<div id="pareq_wrap">
			<table>
				<thead>
					<tr>
						<th></th>
						<th>名前</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
				<% PAreq_data.each.with_index { |pareq,index| %>
					<tr>
						<td class="table_ordernum"><%= index %></td>
						<td class="table_name">
							<a href="pa-lighting.rb?num=<%= index %>&edit=1">
								<%= pareq[:name] %>
							</a>
						</td>
						<td class="table_view">
							<a href="pa-lighting.rb?num=<%= index %>">見る</a>
						</td>
					</tr>
				<% } %>
				</tbody>
			</table>
		</div>
	EOS
	exit
elsif edit == "1"	# 編集ページを表示する
	page[:pareq_available] = {
		members: true,
		tunes: true,
	}
	page[:pareq_edit] = true
	page[:pareq] = pareq.merge( PAreq_data[num.to_i] );
else	# 内容を見るだけ
	page[:pareq_edit] = false
	page[:pareq] = pareq.merge( PAreq_data[num.to_i] );
end

# データの保存処理を行う
if !send_data.empty?
end

# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print Generate.html( File.read("../src/villagers/pa-lighting-edit.html.erb", encoding: 'utf-8'), "", page)

# デバッグ用
rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end

