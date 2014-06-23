<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name = "format-detection" content = "telephone=no">
	<title>동물병원</title>

	<script src="/petmd/common/template/js/jquery-1.6.4.js"></script>
	<script src="/petmd/common/template/js/jquery.mobile-1.2.0.js"></script>
	
	<link rel="stylesheet" href="/petmd/common/template/css/jquery.mobile-1.2.0.css" type="text/css"/>
	<link rel="stylesheet" href="/petmd/common/template/css/common.css" type="text/css"/>
	<link rel="stylesheet" href="/petmd/common/template/css/style.css" type="text/css"/>
	
	<style>
	
	
	</style>
	
</head>

<body>
<div data-role="page">

	<div class="simple_popup01">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">카카오톡 바로가기</p>
					<a class="title_close" data-role="button"><img src="/petmd/common/template/images/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center kakaopopup">
					<p class="title01">
						카카오톡 ID : <b>DOGlove</b>
					</p>
					<p class="detail01">
						위 아이디를 카카오톡 친구찾기에서 친구 등록하시면 병원진료 관련 무료 상담 도움 드립니다!
					</p>
					<p class="go_btn">
						<a data-role="button"><img src="/petmd/common/template/images/btn/btn_kakao02.png" alt="" height="24px"/>&nbsp;<span>카카오톡 바로가기</span></a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="login_area">
		
			<p class="login_title">
				<span>LOG-IN</span>
			</p>
			
			
			<div class="login_icon_area">
					
				<div class="btn_list">
				<ul>
					<li>
						<p class="btn_cir_red"><a data-role="button"><img src="/petmd/common/template/images/common/login_schedule.png" alt="" width="100%" /></a></p>
					</li>
					<li>
						<p class="btn_cir_yellow"><a data-role="button"><img src="/petmd/common/template/images/common/login_mypoint.png" alt="" width="100%"/></a></p>
					</li>
					<li>
						<p class="btn_cir_skyblue"><a data-role="button"><img src="/petmd/common/template/images/common/login_mypet.png" alt="" width="100%"/></a></p>
					</li>
				</ul>
				</div>
			</div>
			
			<p class="login_msg1">
				로그인을 하시면 <span>개인 일정관리, 포인트 적립, 반려동물 등록</span> 등 다양한 서비스를 만나보실 수 있습니다.
			</p>
			
			<div class="login_input">
				<p class="search_input"><input type="text" placeholder="아이디"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="text" placeholder="비밀번호"></p>
			</div>
			
			<div class="login_btn">
				<p class="btn_bar_red btn_bar_shape01">
					<a data-role="button"><img src="/petmd/common/template/images/common/login_btn.png" alt="" height="20px"/>&nbsp;<span>로그인</span></a>
				</p>
			</div>
			
			<p class="id_search">
				<a><span>아이디 찾기</span></a>&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;<a><span>비밀번호 찾기</span></a>
			</p>
		</div>
	
		<p class="new_join">
			<img src="/petmd/common/template/images/common/login_join.png" alt="" height="20px"/>&nbsp;<span style="">신규회원가입</span>
		</p>
	
	</div>
	<!-- ///// content 끝-->
	
	<div id="footer">
		<p class="login_footer">
			하나의 계정으로 <b>ALLPET의 모든 동물병원 싸이트</b>를 이용하실 수 있습니다.
		</p>
	</div>

</div>
</body>
</html>
