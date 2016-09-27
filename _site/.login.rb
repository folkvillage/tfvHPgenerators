#!/usr/bin/env ruby
# coding: UTF-8


require "cgi"
require 'digest/sha2'
require 'securerandom'
#require_relative "./generate.rb"


# ログイン状態を管理するクラス
# セッションIDは、クッキー等でクライアントに保存して使ってください
# LOGIN.new([CGIのインスタンス], [ログインに失敗している時loginPageを表示するかどうか], [ログアウトするかどうか])
# 引数は省略可。省略時はfalse。CGIのインスタンスは必須
# 例)
# require "login.rb"
# login = LOGIN.new(CGI.new)
# if !login.state?
# 	print login.loginPage()
# 	return
# end
# print login.setCookie_header()
# print "Content-Type: text/html; charset=UTF-8\n\n"
# print `cat index.html`
class LOGIN
	# セッションの有効期限(分)
	SessionLimit = 30

	# ユーザー識別名一覧
	LoginUser = [
		"villagers",
		"admin",
		"kiroku",
	]

	# Cookieの有効path
	if ENV['REQUEST_URI'].to_s.index('~fmura')      # 本番環境か判定
		CookiePath = "/~fmura/villagers/"
	else
		CookiePath = "/villagers/"
	end


	# データ保存ファイル
	Data_pass = Generate.readFile('data/.login/.ht_pass').strip
	Data_salt = Generate.readFile('data/.login/.ht_salt').strip
	Filename_session = Generate.expand_path('data/.login/.ht_session')	# 有効なセッションを記録しておく
	Data_session = File.read( Filename_session, encoding: 'utf-8').strip	# 有効なセッションを記録しておく
	
	def initialize(cgi = nil, printLoginPage = false, logout = false)
		# フォームからのデータ受け取り
		cgi = CGI.new if cgi == nil
		idname = CGI.escape( cgi['login_id'] )
		pass = CGI.escape( cgi['login_pass'] )
		session_id = CGI.escape( cgi.cookies['session_ID'].first.to_s )

		# ログアウト
		if logout
			idname = "0"
			pass = ""
		end

		# ユーザーのログイン状態
		@loginstate = false
		#@login_admin = false	# 1 管理者
		#@login_kiroku = false	# 2 記録係
		@login = {}		# ログインユーザーの種類
		LoginUser.each { |usr|
			@login[ usr ] = false;
		}

		# ユーザーのセッションID
		@session_id = ""

		# 現在の有効セッションすべて
		sessionIDs = ""

		# ログイン認証を行なうかどうか
		login = (!idname.empty? || !pass.empty?)

		# ログイン認証
		if login
			#cPASS = File.read(Filename_pass, encoding: 'utf-8').strip.split
			dig = Digest::SHA256.hexdigest( idname+Data_salt+pass )
			pass = Digest::SHA256.hexdigest( dig+Data_salt )
			Data_pass.each_line.with_index { |cPass, index|
				if( pass == cPass.strip )
					# ログイン成功
					@loginstate = true
					@login[ LoginUser[index] ] = true;
					
					# セッションの作成
					@session_id = SecureRandom.hex(32)
					sessionIDs += "#{Digest::SHA256.hexdigest(@session_id+Data_salt)} #{index} #{(Time.now.to_i + 60*SessionLimit).to_s}\n"
					
					break
				end	
			}
		end

		# セッションの照合とセッションの有効期限をチェック
		Data_session.each_line { |line|
				sline = line.split
				if sline.last.to_i > Time.now.to_i	#有効期限チェック
					if Digest::SHA256.hexdigest(session_id+Data_salt) == sline.first && session_id.length > 60
						# セッションの照合成功
						if !login	# ログイン認証を行っていない場合(セッション継続)
							@loginstate = true
							@login[ LoginUser[sline[1].to_i] ] = true;
							@session_id = session_id
							sessionIDs += "#{sline.first} #{sline[1]} #{(Time.now.to_i + 60*SessionLimit).to_s}\n"
						end
					else
						# 有効期限が切れていないセッションはそのまま
						sessionIDs += line
					end
				end
		}

		# セッション情報保存
		File.write(Filename_session, sessionIDs, encoding: 'utf-8' )

		# ログインページの表示
		if printLoginPage && !@loginstate
			print loginPage()
		end
	end

	# ログイン状態を取得する(bool)
	def state( usr = "" )
		if @login.has_key?(usr)
			return @login[usr]
		end
		return @loginstate
	end
	alias state? state	# メソッドの別名の定義

	# 現在のユーザーのセッションIDを取得する
	def session_id()
		return @session_id
	end

	# レスポンスヘッダに渡すSet-Cookieの文字列を返す
	def setCookie_header()
		return "Set-Cookie: session_ID=#{@session_id}; path=#{CookiePath}; HttpOnly\n"#; secure\n"
	end

	# パスワードを更新する(generate.rb以外から呼び出さない)
	# usr: ユーザー識別名(LoginUserの名前)
	def updatePass(usr, idname, pass)
		out = ""
		LoginUser.each.with_index { |lusr, index|
			if usr == lusr
				dig = Digest::SHA256.hexdigest( idname+Data_salt+pass )
				cPASS = Digest::SHA256.hexdigest( dig+Data_salt )
				out += cPASS + "\n"
			else
				out += Data_pass.split("\n")[index].to_s + "\n"
			end
		}
		return out
	end

	# ログイン画面のHTMLを返す。レスポンスヘッダ付き
	def loginPage(srcStr = "")
		out = ""
		# 出力
		# レスポンスヘッダ
		out += setCookie_header()
		out += "Content-Type: text/html; charset=UTF-8\n"
		out += "\n"	#レスポンスヘッダ終了

		# HTML本体
		srcStr = DATA.read if srcStr.empty?
		out += Generate.html( srcStr )

		return out
	end
end


# このスクリプトが直接実行された時
if __FILE__ == $0
	# セッションの有効期限チェック
	LOGIN.new()
	# セッションの数を調べる
	session_num = `wc #{LOGIN::Filename_session}`.split.first

	# レスポンスヘッダ
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	# 内容
	print "現在のログイン人数: #{session_num}"
end


__END__
<%
	page[:title] = "ログイン"
%>
<h2>ログイン</h2>
<br>
<div id=\"login\">
	<form name=\"edit\" method=\"post\" action=\"#{File.basename($0)}\">
		<input type=\"text\" name=\"login_id\" placeholder=\"ID\">
		<input type=\"password\" name=\"login_pass\" placeholder=\"パスワード\">
		<input type=\"submit\" value=\"送信\">
	</form>
</div>
