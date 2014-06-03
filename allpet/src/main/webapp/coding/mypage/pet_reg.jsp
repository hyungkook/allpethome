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
			마이페이지
		</div>

		<div class="a_type02">
			
			<h2>입력하신 정보에 따라 필요한 정보를 제공해 드립니다.</h2>
			
			<table class="edit_table01 mt20 select01">
				<colgroup>
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>종류</th>
					<td class="btn_area01">
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>강아지</span></a>
						</p>
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>고양이</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>품종</th>
					<td>
						<select>
							<option value="">선택해주세요.</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td class="btn_area01">
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>남아</span></a>
						</p>
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>여아</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>펫이름</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
				<tr>
					<th>생일</th>
					<td class="btn_area01">
						<div class="rate30 thin_select">
						<select>
							<option value="2013">2013</option>
						</select>
						</div>
						<div class="ratefree center_align">
							<span>년&nbsp;</span>
							<span class="aligner"></span>
						</div>
						<div class="rate18 nobtn_select">
							<select>
								<option value="01">01</option>
							</select>
						</div>
						<div class="ratefree center_align">
							<span>월&nbsp;</span>
							<span class="aligner"></span>
						</div>
						<div class="rate18 nobtn_select">
							<select>
								<option value="01">01</option>
							</select>
						</div>
						<div class="ratefree center_align">
							<span>일</span>
							<span class="aligner"></span>
						</div>
					</td>
				</tr>
				<tr>
					<th>중성화</th>
					<td class="btn_area01">
						<p class="rate33 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>예정</span></a>
						</p>
						<p class="rate33 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>완료</span></a>
						</p>
						<p class="rate34 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>해당없음</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>등록번호</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
			</table>
			
			<p class="btn_bar_red btn_bar_shape01 mt15">
				<a data-role="button"><span>등록</span></a>
			</p>
		</div>
		
		<div class="a_type02">
			
			입력하신 정보에 따라 필요한 정보를 제공해 드립니다.
			
			<table class="edit_table01 mt20 select01">
				<colgroup>
					<col width="20%">
					<col width="*">
				</colgroup>
				<tr>
					<th>종류</th>
					<td class="btn_area01">
						<p class="rate50 btn_bar_black btn_bar_shape02">
							<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm02.png" alt="" height="20px"/>&nbsp;<span>강아지</span></a>
						</p>
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>고양이</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>품종</th>
					<td>
						<select>
							<option value="">선택해주세요.</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td class="btn_area01">
						<p class="rate50 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>남아</span></a>
						</p>
						<p class="rate50 btn_bar_black btn_bar_shape02">
							<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm02.png" alt="" height="20px"/>&nbsp;<span>여아</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>펫이름</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
				<tr>
					<th>생일</th>
					<td class="btn_area01">
						<div class="rate30 thin_select">
						<select>
							<option value="2013">2013</option>
						</select>
						</div>
						<div class="ratefree center_align">
							<span>년&nbsp;</span>
							<span class="aligner"></span>
						</div>
						<div class="rate18 nobtn_select">
							<select>
								<option value="01">01</option>
							</select>
						</div>
						<div class="ratefree center_align">
							<span>월&nbsp;</span>
							<span class="aligner"></span>
						</div>
						<div class="rate18 nobtn_select">
							<select>
								<option value="01">01</option>
							</select>
						</div>
						<div class="ratefree center_align">
							<span>일</span>
							<span class="aligner"></span>
						</div>
					</td>
				</tr>
				<tr>
					<th>중성화</th>
					<td class="btn_area01">
						<p class="rate33 btn_bar_black btn_bar_shape02">
							<a data-role="button"><img src="/petmd/common/template/images/btn/btn_confirm02.png" alt="" height="20px"/>&nbsp;<span>예정</span></a>
						</p>
						<p class="rate33 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>완료</span></a>
						</p>
						<p class="rate34 btn_bar_gray btn_bar_shape02">
							<a data-role="button"><span>해당없음</span></a>
						</p>
					</td>
				</tr>
				<tr>
					<th>등록번호</th>
					<td>
						<div class="input01">
							<p class="inner_input"><input type="text"></p>
						</div>
					</td>
				</tr>
			</table>
			
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
		</div>
	
	</div>
	<!-- ///// content 끝-->

</div>
</body>
</html>
