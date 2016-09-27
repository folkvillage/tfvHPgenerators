#!/usr/bin/env ruby
# coding: UTF-8

begin

require 'fileutils'
require 'erb'
require 'csv'

module Generate		# モジュール定義
	class << self	#この中で定義されるメソッドは、クラスメソッドとなる

		@@DefaultHTML = File.read(File.expand_path('../src/default.html.erb', __FILE__), encoding: 'utf-8') # default.htmlの読み込み
		@@tableFromCSV_func = nil	# tableタグを生成する関数
		@@rootdir = ""	# ドキュメントルート(ページ毎の階層によって変わる)
		@@default_page = {	:title => "つくばフォーク村 - 筑波大学軽音楽サークル",
							:meta_viewport => "width=device-width,initial-scale=1.0",		#スマホに対応
						}

		PageSettingfilename = 'data/page_setting.rb'  # 設定ファイル名

		# html合成
		# page		このhashにはページごとの設定等を代入ください。
		# 			{title: ページタイトル, tableFromCSV: CSVからhtmlのtableタグを生成するときの処理(Proc)}
		def generate_html(srcStr, documentroot, page = {})
			page = @@default_page.merge(
				eval readFile(PageSettingfilename)  # 設定ファイル読み込み
			).merge( page )		# ページごとの設定
			@@tableFromCSV_func = page[:tableFromCSV] # CSVからtableタグを生成する処理用関数
			@@rootdir = rootdir = "../" * documentroot	# ドキュメントルートを設定
			
			srcStr.gsub!(/　/, "  ")	#全角スペースを半角スペースに置換
			content = ERB.new(srcStr).result(binding)	#ソースの処理

			page[:title] << " - つくばフォーク村" if page[:title] != @@default_page[:title]	# タイトルの編集
			
			return ERB.new(@@DefaultHTML).result(binding)	# 合成
		end

		# generate_htmlの補助
		# CSVからtableタグを生成する関数(erb実行時に使える)
		# page[:tableFromCSV]が指定されている場合はそれを実行します
		def tableFromCSV(csvFilename, idname = "")
			if @@tableFromCSV_func.is_a? Proc 
				return @@tableFromCSV_func.call(csvFilename, idname)
			end
			table = CSV.read(csvFilename, {encoding: 'utf-8', skip_blanks: true})
			ERB.new(<<-EOS,nil,'-').result(binding)
				<table<% if !idname.empty? then %><%= ' id="'+idname+'"' %><% end %>>
					<thead>
						<tr>
							<%- table[0].each.with_index { |h,i| -%>
								<th<%= ' class="table_ordernum"' if i==0 %>><%=h%></th>
							<%- } -%>
						</tr>
					</thead>
					<tbody>
					<%- table.each.with_index { |row, index|	-%>
					<%-	next if index == 0 -%>
						<tr>
							<%- row.each.with_index{ |d, i| -%>
								<td<%= ' class="table_ordernum"' if i==0 %>><%= d %></td>
							<%- } -%>
						</tr>
					<%- } -%>
					</tbody>
				</table>
			EOS
		end

		# generate_htmlの補助
		# aタグを生成する。
		# hrefに'/'から始まるパスを渡すと、rootdirをつけてくれる
		def alink(href, value = "")
			if href[0] == '/'
				href = @@rootdir + href[1..-1]
			end
			"<a href=\"#{href}\">#{value}</a>"
		end


		# generate処理(htmlやcssの生成処理)
		# infilename :	ソースファイル名
		# outfilename :	出力ファイル名
		# pflag :		標準出力に出力するかどうか
		# pflag=trueの時でもoutfilenameの指定が必要です。(documentrootを求めるため)
		def generate(infilename, outfilename, pflag=false)
			# src読み出し
			srcStr = File.open(infilename, 'r:utf-8').read

			# 生成処理
			documentroot = getDocumentroot(outfilename)
			case File.extname(infilename)
			when ".erb"
				out = generate_html( srcStr, documentroot )
				outfilename.slice!(-4,4)	# .erbの部分を削除
			#when ".html"
			#	out = generate_html( srcStr, documentroot )
			when ".js", ".rb", ".png"
				out = srcStr	# ただのコピー
			end

			# 出力
			if pflag
				print out
			else
				FileUtils::mkdir_p( File.dirname(outfilename) )
				open( outfilename, 'w:utf-8') do |file|
					file.write(out)
				end
			end
		end

		# Main処理(引数解析等)
		def main(argv = [])
			# 生成
			Dir::glob( [ "src/**/*.html.erb",
#				"src/**/*.html",
				"src/**/*.rb" ,
			]).each { |fn|
				fn.slice!(0,4)	# "src/"の部分を削除
				puts fn
				generate("src/"+fn, fn)
			}
		end

		# 外部から呼び出し用
		# srcStr :	ソース文字列
		# outfilename :	出力ファイル名(省略可)
		# page :	ページに渡すハッシュ。ERBの処理の時に使われる。
		# documentroot :		ルートからのディレクトリの深さ(省略可)
		# documentrootを省略すると、outputfileまたは呼び出し元のパスから判断します。
		def html(srcStr, outfilename = "", page = {}, documentroot=-1)
			# ドキュメントルートからの深さを調べる
			documentroot = getDocumentroot(outfilename) if documentroot < 0

			# 生成
			out = generate_html(srcStr, documentroot, page)

			# 書き込み
			if !outfilename.empty?
				FileUtils::mkdir_p( File.dirname(outfilename) )
				open( outfilename, 'w:utf-8') do |file|
					file.write(out)
				end
			end

			return out	# 結果を返す
		end
		
		# ドキュメントルートからの深さを調べる
		def getDocumentroot( outfilename="" )
			File.expand_path(outfilename.empty? ? $0 : outfilename).count('/') - File.expand_path(__FILE__).count('/')
		end

		# ドキュメントルートを相対的に指す
		def getRootdir( outfilename="" )
			"../" * getDocumentroot(outfilename)	# ドキュメントルートを返す
		end

		# generate.rbからの相対パスを絶対パスになおす
		def expand_path( filename = "" )
			File.expand_path( '../' + filename, __FILE__)
		end

		# generate.rbからの相対パスでファイルを開いて読み込む
		def readFile( filename = "" )
			File.read( expand_path(filename), encoding: 'utf-8')
		end
	end
end

require_relative ".login.rb"

#
# Main
#
if __FILE__ == $0
	if ARGV[0] == "pass"
		if ARGV.size == 4
			login = LOGIN.new
			print login.updatePass( ARGV[1], ARGV[2], ARGV[3] )
		else
			puts "generate.rb pass [LoginUser名] [ID] [パスワード]"
			puts ""
			puts "ログイン用IDとパスワードを更新します。"
			puts "詳しくは、LOGIN::updatePassを参照してください。"
		end
	else
		print "Content-Type: text/plain; charset=UTF-8\n\n"
		Generate.main()
	end
end

rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end
