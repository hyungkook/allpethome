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

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button"><img height="100%" src="/petmd/common/template/images/btn/btn_back.png"/></a></div>
			포인트 상세 내역
		</div>
		
		<div class="tab02">
			<ul>
				<li class="first"><a onclick="" class="on"><span>최근 일주일</span></a></li>
				<li><a onclick=""><span>최근 1개월</span></a></li>
				<li><a onclick=""><span>최근 3개월</span></a></li>
				<li><a onclick=""><span>전체</span></a></li>
			</ul>
		</div>
		
		<div class="a_type03">
			총 <b>123,456,789</b> 건
			<p class="rb_tag">
				현재 보유 포인트&nbsp;<span>123,456,789</span>&nbsp;<img style="" src="/petmd/common/template/images/common/icon_point.png" alt="" height="16px" />
			</p>
		</div>
		
		<ul>
			<li class="point_list">
				<p class="date">2013.12.29 (12:34)</p>
				<p class="title">20131201312013120131201312</p>
				<p class="point">
					<span class="aligner"></span>
					<span class="plus">+123,456,789</span>&nbsp;&nbsp;<img style="" src="/petmd/common/template/images/common/icon_point.png" alt="" height="18px" />
				</p>
			</li>
			
			<li class="point_list">
				<p class="date">2013.12.29 (12:34)</p>
				<p class="title">20131201312013120131201312</p>
				<p class="point">
					<span class="aligner"></span>
					<span class="minus">-123,456,789</span>&nbsp;&nbsp;<img style="" src="/petmd/common/template/images/common/icon_point.png" alt="" height="18px" />
				</p>
			</li>
		</ul>
		
		<div class="more_top_area01">
			<div class="more"><a data-role="button">더보기</a></div>
			<div class="top"><a data-role="button">맨위로</a></div>
		</div>
		
	</div>
	
</div>
</body>
</html>