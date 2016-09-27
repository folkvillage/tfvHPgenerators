
// ヘッダーのメニューの高さ調整用の変数
topbar_min_height = 85;
topbar_move_height = 15;
topbar_move_top = 25;
// ウィンドウ全体の幅と高さ
window_width = $(window).width();
window_height = $(window).height();

$(function(){
	// スマホ用の処理
	if( !switch_smartphone() && window_width <= 1000 ){
//		$('meta[name="viewport"]').attr('content', 'width=1000');
		$('#wrapper').css('min-width', window_width+'px');
	}

	// スクロールしたときの処理(メニューの大きさ変更)
	$(window).scroll(function () {
		var ScrTop = $(document).scrollTop();

		if( ScrTop < 100 ){
			he = topbar_min_height + (topbar_move_height * (100-ScrTop) / 100.0);
			to = topbar_move_top * (ScrTop / 100.0);
			$('#header').css('height', he + 'px');
			$('#header').css('top', '-' + to + 'px');
		}else{
			$('#header').css('height', topbar_min_height + 'px');
			$('#header').css('top', '-'+ topbar_move_top +'px');
		}
	});

	// ウィンドウのサイズが変わった時の処理(要素のサイズ調整)
	$(window).on('load resize', function() {
		$('#wrapper').height( $('#contentWrapper').outerHeight() + $('#footer').outerHeight() );
	});
});

// スマホ用の処理
function switch_smartphone() {
	if( window_width < 980 ){
		menu_itemnum = Math.ceil(5 / Math.floor(window_width / 135));
		header_h = 50 + menu_itemnum * 50;
		header_h += $('#menu_fornew').height(); //新歓ページ
		menu_w = Math.floor(window_width / 135) * 135 + 5;
		//$('#wrapper').css('min-width','0');
		$('#header_wrapper').css('height',header_h+'px');
		//$('#header').css('position','static');
//		$('#header').css('height',header_h+'px');
		//$('#TFV').css('position','static');
		//$('#TFV').css('margin','0 auto');
		//$('#TFV img').css('position','static');
		//$('#menu').css('position','static');
		//$('#menu').css('margin','0 auto');
		$('#menu').css('width',menu_w+'px');
		$('#menulist').css('width',menu_w+'px');
//		$('#pagetitle img').css('width', (window_width - 10)+'px');
		topbar_min_height = header_h;
		topbar_move_height = 0;
		topbar_move_top = 0;
		return true;
	}
	return false;
}
