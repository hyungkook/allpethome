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

<script>
$(window).load(function(){
	var mh = $('.mypage_header').find('img');
	mh.height($('.mypage_header').find('a').height());
	mh.width($('.mypage_header').find('a').height());
});

</script>

<body>
<div data-role="page">

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button"><img height="0" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			스케줄
		</div>
		
		<div class="schedule_top">
			<div class="calendar">
				<a data-role="button"><img src="/petmd/common/template/images/btn/btn_calendar.png" alt="" width="100%" height="100%" /></a>
			</div>
			<div class="add">
				<a data-role="button"><img src="/petmd/common/template/images/btn/btn_plus.png" alt="" width="100%" height="100%" /></a>
			</div>
			<div class="center">
				<div class="paging">
					<p><a data-role="button"><img src="/petmd/common/template/images/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
					<span class="headline_white" style="display:inline-block;">2014.01</span>
					<p><a data-role="button"><img src="/petmd/common/template/images/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
				</div>
			</div>
			
		</div>
		
		<div class="a_type02">
			<div class="round_list">
				<div class="tag"><img src="/petmd/common/template/images/common/icon_schedule_off.png" alt="" width="24" height="24"/></div>
				<table>
					<colgroup>
						<col width="25%"><col width="*">
					</colgroup>
					<tr>
						<td rowspan="3" class="dday"><span>종료</span></td>
						<td class="title">강남동물병원</td>
					</tr>
					<tr>
						<td class="contents">뽀미 심장 사상충 1차 예방 접종 예약 일거에요</td>
					</tr>
					<tr>
						<td class="time">[2014-02-28 06:00]</td>
					</tr>
				</table>
			</div>
			<div class="round_list">
				<div class="tag"><img src="/petmd/common/template/images/common/icon_schedule_on.png" alt="" width="24" height="24"/></div>
				<table>
					<colgroup>
						<col width="25%"><col width="*">
					</colgroup>
					<tr>
						<td rowspan="3" class="dday_red"><div>D-day<br/><span>12</span></div></td>
						<td class="title">강남동물병원</td>
					</tr>
					<tr>
						<td class="contents">뽀미 심장 사상충 1차 예방 접종 예약</td>
					</tr>
					<tr>
						<td class="time">[2014-02-28 06:00]</td>
					</tr>
				</table>
			</div>
			<div class="round_list">
				<table>
					<colgroup>
						<col width="25%"><col width="*">
					</colgroup>
					<tr>
						<td rowspan="3" class="dday"><div>D-day<br/><span>20</span></div></td>
						<td class="title">강남동물병원</td>
					</tr>
					<tr>
						<td class="contents">뽀미 심장 사상충 1차 예방 접종 예약</td>
					</tr>
					<tr>
						<td class="time">[2014-02-28 06:00]</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="more_top_area01">
			<div class="more"><a data-role="button">더보기</a></div>
			<div class="top"><a data-role="button">맨위로</a></div>
		</div>
	
	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
