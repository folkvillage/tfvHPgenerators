#!/usr/local/bin/ruby
# coding: UTF-8

begin

require_relative "../.login/login.rb"


# ログインチェック
login = LOGIN.new(nil, true);
exit if !login.state?



# 出力
# レスポンスヘッダ
print "Content-Type: text/html; charset=UTF-8\n"
print login.setCookie_header()
print "\n"	#レスポンスヘッダ終了

# HTML本体
print `cat index.html`


rescue => evar
	print "Content-Type: text/plain; charset=UTF-8\n\n"
	p evar
end


__END__
