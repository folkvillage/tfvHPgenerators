# coding: utf-8
# ページ設定ファイル
# よく変わる設定はこのファイルにかく
{

	# サイトの説明(トップページの検索結果に表示される)。120文字程度まで。
	meta_description: "筑波大学軽音楽サークル「つくばフォーク村」です。弾き語りやバンドなどの活動をおこなっています。",

	# トップページの設定
	nextlive: {
		nextlive_name:   "フェス",
		nextlive_href:   "#{rootdir}live/2016/1001.html",
		nextlive_detail: "10/1,2",
		nextlive2_name:   "the live",
		nextlive2_href:   "",
		nextlive2_detail: "10/8,9,10",
	},
	news: [
               { date: "2016/9/25", detatil:"10月1日,2日開催の<a href=\"#{rootdir}live/2016/1001.html\">フェス</a>の情報を更新しました。" },
               { date: "2016/9/25", detatil:"8月26日,27日開催の<a href=\"#{rootdir}live/2016/report/0826.html\">サマフェスライブレポート</a>の情報を更新しました。" },
               { date: "2016/8/25", detatil:"9月10日,11日開催の<a href=\"#{rootdir}live/2016/0910.html\">村TOJO合同ライブ</a>の情報を更新しました。" },
               { date: "2016/8/17", detatil:"8月26日,27日開催の<a href=\"#{rootdir}live/2016/0826.html\">サマフェス</a>の情報を更新しました。" },
                { date: "2016/7/6", detatil:"7月23日開催の<a href=\"#{rootdir}live/2016/0723.html\">Julive</a>の情報を更新しました。" },
                { date: "2016/4/17", detatil:"4月23日開催の<a href=\"#{rootdir}live/2016/0423.html\">aiモ弾き語りライブ</a>の情報を更新しました。" },
               { date: "2016/3/31", detatil:"4月7日から開催の<a href=\"#{rootdir}live/2016/0407.html\">新歓ライブ(石の広場,ブース,ミー後ライブ)</a>の情報を更新しました。" },
               { date: "2016/3/23", detatil:"3月29日開催の<a href=\"#{rootdir}live/2015/0329.html\">熱中唱</a>の情報を更新しました。" },
		{ date: "2016/2/22", detatil:"3月5日開催の<a href=\"#{rootdir}live/2015/0305.html\">さわこん</a>の情報を更新しました。" },
		{ date: "2016/2/5", detatil:"3月18日,19日,20日開催の<a href=\"#{rootdir}live/2015/0318.html\">39代追いコン</a>の情報を更新しました。" },
		{ date: "2016/1/16", detatil:"1月30日開催の<a href=\"#{rootdir}live/2015/0130.html\">寒フェス</a>の情報を更新しました。" },
		{ date: "2015/11/29", detatil:"12月12日,13日開催の<a href=\"#{rootdir}live/2015/1212.html\">ラブライブ</a>の情報を更新しました。" },
		{ date: "2015/11/11", detatil:"11月21日,22日開催の<a href=\"#{rootdir}live/2015/1121.html\">代替わりライブ</a>の情報を更新しました。" },
		{ date: "2015/10/26", detatil:"11月6日からの<a href=\"#{rootdir}live/2015/1106.html\">学園祭ライブ</a>の情報を更新しました。" },
		{ date: "2015/5/1", detatil:"5月5日の<a href=\"#{rootdir}for_new.html#daienkai\">新歓大宴会</a>についての情報を追記しました。" },
		{ date: "2015/4/6", detatil:"ホームページをリニューアルしました。旧ホームページは<a href=\"#{rootdir}link.html\">リンク</a>から参照できます。" },
	],
	fornew: false,	# 新入生向けのページを表示するかどうか

	# 画像のスライドショー(dirにある拡張子「.jpg」の画像をスライドショーします)
	top_image: {
		dir: 'img/top_image/',	# スライドショーに表示する画像があるディレクトリ
		fade_speed: 1000,		# 切り替わりのフェードのスピード(ms)
		interval: 10000,		# 切り替わりまでの間隔(ms)
	},



	# A室枠表の設定
	aroom: [
		{ CSV: "data/a-room/2016_0930.csv" },
		{ CSV: "data/a-room/2016_1001.csv" },
		{ CSV: "data/a-room/2016_1004.csv" },
	],
	aroom_comment: "7限:18-19.5   8限:19.5-21   9限:21-22 です。<br>火曜日は12:15分から村の枠なので注意！",

	# 長期休暇A室枠表の設定 表示するCSV一覧
	aroom_l: [
		{ CSV: "data/a-room/1229.csv" },
		{ CSV: "data/a-room/2016_0101.csv" },
		{ CSV: "data/a-room/2016_0102.csv" },
		{ CSV: "data/a-room/2016_0105.csv" },
		{ CSV: "data/a-room/2016_0108.csv" },
		{ CSV: "data/a-room/2016_0109.csv" },
		{ CSV: "data/a-room/2016_0112.csv" },
	],
	# 長期A室枠表のページに表示するリンク
	aroom_l_link: {
		#"A室枠希望表" => [
		#	{
		#		name: "test",
		#		href: "#",
		#	},
		#],
	},


	# エントリーシート
	spreadsheet: [
		#			{	url:"https://docs.google.com/spreadsheets/d/1Vh1tmrm0mryRvIb9CNtFx4Z6aqxaCs2-bBk7L6vAyHQ/",
		#				detail:"新歓エントリーシート"
		#			},
	]

}
