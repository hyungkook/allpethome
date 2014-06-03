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
</head>

<style>




</style>

<script>
$(window).load(function(){
	var mh = $('.mypage_header').find('img');
	mh.height($('.mypage_header').find('a').height());
	mh.width($('.mypage_header').find('a').height());
});

</script>

<body>
<div data-role="page">

	<div class="simple_popup01">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">시간 설정</p>
					<a class="title_close" data-role="button"><img src="/petmd/common/template/images/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<div class="schedule_time_ampm">
						<a data-role="button"><p class="on">
							<span class="inner"></span>
							<label>AM</label>
						</p></a>
						<a data-role="button"><p class="off">
							<span class="inner"></span>
							<label>PM</label>
						</p></a>
						<span class="time">09:00</span>
					</div>
					<p class="select_time_msg01">▼ 시간을 선택해주세요</p>
					<p class="select_table_header">시</p>
					<div class="select_table">
						<!-- <p class="selected">
							<span class=selector>
								<span class="aligner"></span>
								<label>1</label>
							</span>
						</p> -->
						<p>
							<span class="selected">
								<span class="type01">
									<span class="inner"></span>
									<label>1</label>
								</span>
							</span>
							<label>1</label>
						</p>
						<p><label>2</label></p>
						<p><label>3</label></p>
						<p><label>4</label></p>
						<p><label>5</label></p>
						<p><label>6</label></p>
					</div>
					<div class="select_table">
						<p><label>7</label></p>
						<p><label>8</label></p>
						<p><label>9</label></p>
						<p><label>10</label></p>
						<p><label>11</label></p>
						<p><label>12</label></p>
					</div>
					<p class="select_table_header">분</p>
					<div class="select_table">
						<!-- <p class="selected">
							<span class=selector>
								<span class="aligner"></span>
								<label>00</label>
							</span>
						</p> -->
						<p>
							<span class="selected">
								<span class="type01">
									<span class="inner"></span>
									<label>00</label>
								</span>
							</span>
							<label>00</label>
						</p>
						<p><label>10</label></p>
						<p><label>20</label></p>
						<p><label>30</label></p>
						<p><label>40</label></p>
						<p><label>50</label></p>
					</div>
					<p class="btn_bar_red btn_bar_shape01">
						<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>설정 완료</span></a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button"><img height="0" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			스케줄 조회/수정
		</div>
		
		<div class="schedule_top">
			<div class="center">
				<div class="paging">
					<p><a data-role="button"><img src="/petmd/common/template/images/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
					<span class="headline_white" style="display:inline-block;">2014.01</span>
					<p><a data-role="button"><img src="/petmd/common/template/images/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
				</div>
			</div>
		</div>
		
		<div class="calendar">
			<div class="header">
				<p class="sun">SUN
				</p><p class="other">MON
				</p><p class="other">TUE
				</p><p class="other">WED
				</p><p class="other">THU
				</p><p class="other">FRI
				</p><p class="sat">SAT</p>
			</div>
			<div class="body">
				<div>
					<p class="external">
						<label>29</label>
					</p><p class="external">
						<label>30</label>
					</p><p class="external">
						<label>31</label>
					</p><p>
						<label>1</label>
					</p><p>
						<label>2</label>
					</p><p>
						<label>3</label>
					</p><p>
						<label>4</label>
					</p>
				</div>
				<div>
					<p>
						<span class="selected">
							<span class="type02">
								<span class="inner"></span>
							</span>
						</span>
						<label>5</label>
					</p><p>
						<span class="number_tag">2</span>
						<label>6</label>
					</p><p>
						<label>7</label>
					</p><p>
						<label>8</label>
					</p><p>
						<label class="red">9</label>
					</p><p>
						<span class="selected">
							<span class="type01">
								<span class="inner"></span>
								<label>10</label>
							</span>
						</span>
						<span class="number_tag">2</span>
						<label>10</label>
					</p><p>
						<label>11</label>
					</p>
				</div>
			</div>
			
			
		</div>
		
		<div class="schedule_time_select">
			<table>
				<colgroup>
					<col width="50%"/><col width="*"/>
				</colgroup>
				<tr>
					<td class="title">
						<img src="/petmd/common/template/images/common/icon_time.png" height="20px"/>
						<span>예약시간 설정</span>
					</td>
					<td class="time">
						<span>AM</span>
						<span>07:00</span>
						<img src="/petmd/common/template/images/btn/btn_time_edit.png" height="30px"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="a_type02">
			<p class="title01">[그레이스 동물병원 등록]</p>
			<h3>2014년 1월 5일 (07:00)일정</h3>
			<p class="textarea01">
				<textarea rows="3" placeholder="스케줄 내용을 입력해 주세요."></textarea>
			</p>
			<p class="btn_bar_red btn_bar_shape01 mt08">
				<a data-role="button"><span>일정 등록</span></a>
			</p>
			<div class="btn_area02 mt08">
				<div class="l_30">
					<p class="btn_bar_black btn_bar_shape01">
						<a data-role="button"><span>삭제</span></a>
					</p>
				</div>
				<div class="r_70">
					<p class="btn_bar_red btn_bar_shape01">
						<a data-role="button"><span>수정</span></a>
					</p>
				</div>
			</div>
			<p class="btn_bar_black btn_bar_shape01 mt08">
				<a data-role="button"><span>삭제</span></a>
			</p>
		</div>

	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
