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

<!-- 	<div class="simple_popup01">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">인증번호 입력</p>
					<a class="title_close" data-role="button"><img src="/petmd/common/template/images/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<p class="popup_inner_msg01">SMS 문자서비스를 통해 받으신 인증번호를 입력해 주세요.</p>
					<div class="btn_area02">
						<div class="l_60 input02">
							<p class="inner_input"><input type="text" placeholder="인증번호를 입력해주세요."></p>
						</div>
						<p class="r_40 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>재발송 요청</span></a>
						</p>
					</div>
					<p class="remain_time01">
						<img src="/petmd/common/template/images/common/icon_time.png" height="20px"/>
						<span class="time">05:00분</span>
						<span>&nbsp;남음</span>
					</p>
					<p class="btn_bar_red btn_bar_shape01">
						<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>인증번호 확인</span></a>
					</p>
				</div>
			</div>
		</div>
	</div> -->

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button"><img height="100%" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			마이페이지
		</div>

		<div class="a_type02">
			<div class="name_area_personal_edit">
				<p class="name">홍길동(크리스탈)</p>
				<p class="email mt05">gildong@google.com</p>
			</div>
			<table class="edit_table01 mt20">
				<colgroup>
					<col width="23%">
					<col width="*">
				</colgroup>
				<tr>
					<th>생년월일</th>
					<td>1990년 11월 10일. 만 24세</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>남</td>
				</tr>
				<tr>
					<th>휴대폰</th>
					<td class="btn_area01">
						<div class="rate75">
							<div class="input01">
								<p class="inner_input"><input type="text" placeholder="휴대폰번호"></p>
							</div>
						</div>
						<p class="rate25 btn_bar_black btn_bar_shape02">
							<a data-role="button"><span>변경</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td class="btn_area01">
						<div class="rate75">
							<p class="readonly_input01">
								서울시 강남구 역삼동
							</p>
						</div>
						<p class="rate25 btn_bar_red btn_bar_shape02">
							<a data-role="button"><span>변경</span></a>
						</p>
					</td>
				</tr>
			</table>
		</div>
		<div class="a_type02">
			<h3><img src="/petmd/common/template/images/common/bu_tt.png" alt="" width="16" height="14" />비밀번호 변경</h3>
			<table class="edit_table01 mt20">
				<colgroup>
					<col width="35%">
					<col width="*">
				</colgroup>
				<tr>
					<th>기존 비밀번호</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
				<tr>
					<th>새 비밀번호</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
				<tr>
					<th>새 비밀번호 재입력</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
			</table>
			
			<p class="btn_bar_red btn_bar_shape01 mt15">
				<a data-role="button"><span>비밀번호 변경</span></a>
			</p>
		</div>
	
	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
