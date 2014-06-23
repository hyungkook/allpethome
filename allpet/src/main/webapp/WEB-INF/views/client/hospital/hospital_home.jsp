<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<c:if test="${not empty hospitalInfo.s_keyword}">
<meta name="robots" content="ALL">
<meta name="keywords" content="${hospitalInfo.s_keyword}">
<meta name="description" content="${fn:replace(fn:replace(hospitalInfo.s_introduce,crlf,' '),quot,'')}">
</c:if>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<script type="text/javascript" src="${con.JSPATH}/jquery.event.drag-1.5.min.js?v=1402180"></script>
<script type="text/javascript" src="${con.JSPATH}/jquery.touchSlider.js?v=1402180"></script>
<script type="text/javascript" src="${con.JSPATH}/jquery.commonAssistant-1.0.js?v=1402181"></script>

<style>
/* .test1 {background:black; width:100px; height:100px; margin:0px; padding:0px; border-radius:50%; line-height:0; font-size:0px; box-shadow:none; -webkit-box-shadow:none; behavior:url(../common/template/css/test.htc);} */
</style>

<!-- Facebook Conversion Code for 동물병원 -->
<script type="text/javascript">
var fb_param = {};
fb_param.pixel_id = '6013956040648';
fb_param.value = '0.01';
fb_param.currency = 'KRW';
(function(){
var fpw = document.createElement('script');
fpw.async = true;
fpw.src = '//connect.facebook.net/en_US/fp.js';
var ref = document.getElementsByTagName('script')[0];
ref.parentNode.insertBefore(fpw, ref);
})();
</script>
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/offsite_event.php?id=6013956040648&amp;value=0.01&amp;currency=KRW" /></noscript>

<script>

	$.removeCookie('pet_homepage');
	$.cookie('pet_homepage', 'hospitalHome.latte?idx=${params.idx}', {expires:1});
	
	var lastIndex = 1;
	
	var h = 0;
	
	$(window).resize(function(){
		
		$('#touchSlider ul').height($('#touchSlider ul li img').height());
	});
		
	$(document).ready(function(){
	
		lastIndex = 1;
		
		$("#touchSlider").touchSlider({
			flexible : true,
			btn_prev : $("#aprev"),
			btn_next : $("#anext"),
			counter : function (e) {
				pageDotChange(e.current-1);
				lastIndex = e.current;
				// ("current : " + e.current + ", total : " + e.total);
			}
		});
		
		if(parseBool('${fn:length(importantBoardList)>1}'))
			setInterval(function(){ noticeRoll(); }, 5000);
	});
	
	$(window).load(function(){
	
		$('#touchSlider ul').height($('#touchSlider ul li img').height());
		
		var isLogin = '${params.isLogin}';
		if( isLogin != 'Y'){
			alert('로그인 하시면 동물 수첩 기능을 사용하실 수 있습니다.');
		}else{
			if( window.hybrid ){
				var msg = '{"type" : "LOGIN","userId" : "' + '${params.userId}' + '"}';
				window.hybrid.setMessage(msg);
			}
		}
	});
	
	function goPageChange(index){
		
		var c = index - lastIndex;
		if(c > 0){
			for(var i = 0; i < c; i++){
				$("#anext").click();
			}
		}
		if(c < 0){
			for(var i = 0; i < -c; i++){
				$("#aprev").click();
			}
		}
	}
	
	function pageDotChange(index) {
		
		for (var i=0; i<=parseInt('${fn:length(introImageList)}'); i++){
			$("#paging_img_" + i).attr("src","${con.IMGPATH}/common/paging_off.png");
		}
		$("#paging_img_" + (index + 1)).attr("src","${con.IMGPATH}/common/paging_on${personalLayout}.png");
	}
	
	function noticeRoll(){
		var $t = $('#ticker_notice li:first'); 
		$t.attr('data-margin-top',$t.css('margin-top'));
		$t.animate({
			'margin-top':-$t.height()+"px"
		},800,function () {
			$(this).css('margin-top',$(this).attr('data-margin-top'));
			$(this).appendTo($('#ticker_notice'));
		});
	}
	
</script>

</head>

<body style="overflow-x:auto;">
		
	<div data-role="page" id="home">
	
		<jsp:include page="/include/client/INC_INSTANCE_DIALOG.jsp"/>
		<%-- <jsp:include page="/include/client/INC_IMAGE_CROP.jsp"></jsp:include> --%>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<div class="test1"></div>
			
			<!-- 상단 이미지 영역 -->
			<jsp:include page="main_header.jsp"/>
			
			<!-- 메인 메뉴 -->
			<jsp:include page="../include/main_menu.jsp">
				<jsp:param value="N" name="jsp_move_start_position"/>
			</jsp:include>
			
			<!-- 중요 공지사항 롤링 -->
			<div class="prev_notice">
				<p class="icon"><img src="${con.IMGPATH}/common/icon_notice.png" alt="" width="9" height="10"/></p>
				<ul id="ticker_notice">
					<c:forEach items="${importantBoardList}" var="list" varStatus="c"><li>
						<c:set var="ymd" value="${fn:split(list.d_reg_date,' ')[0]}"/>
						<a onclick="goPage('hospitalBoardDetail.latte?idx=${params.idx}&cmid=${list.s_group}&bid=${list.s_bid}');" >${list.s_subject}&nbsp;<c:if test="${list.reg_date_diff < 7}"><img src="${con.IMGPATH}/common/icon_new.png" alt="" width="13" height="13"/></c:if><span>${ymd}</span></a></li>
					</c:forEach>
				</ul>
			</div>
				
			<!-- 병원소개-->
			<div class="a_type01_b">
				<c:if test="${not empty hospitalInfo.s_shortIntroduce}">
					<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />인사말</h3>
					<p class="txt_type01 mt10">
						${fn:replace(fn:replace(hospitalInfo.s_shortIntroduce,'<','&lt;'),crlf,'<br/>')}
					</p>
				</c:if>
				<c:if test="${empty hospitalInfo.s_introduce}">
				</c:if>
				
				<!-- 소개사진-->
				<c:choose>
				<%-- 소개 이미지 2장 이상에서만 슬라이드 활성화 --%>
				<c:when test="${fn:length(introImageList)>1}">
					<div class="photo_area">
						<p class="btn_l btn"><a id="aprev" data-role="button"><img src="${con.IMGPATH}/btn/btn_photo_l.png" alt="" width="46" height="46" /></a></p>
						<p class="btn_r btn"><a id="anext" data-role="button"><img src="${con.IMGPATH}/btn/btn_photo_r.png" alt="" width="46" height="46" /></a></p>
						<div class="img_area">
							<div id="touchSlider">
								<ul style="position:relative;">
									<c:forEach items="${introImageList}" var="list" varStatus="c">
									<li style="position:absolute; left:0; top:0;">
										<img src="${con.img_dns}${list.s_image_path}" width="100%"  />
									</li>
									</c:forEach>
								</ul>
							</div>
						</div>
						<div class="paging">
							<ul>
								<c:forEach items="${introImageList}" var="list" varStatus="c">
								<li><a><img onClick="goPageChange('${c.count}')" id="paging_img_${c.count}" src="${con.IMGPATH}/common/paging_off.png" width="10" height="10" /></a></li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</c:when>
				<%-- 이미지가 없을 경우 기본 이미지 --%>
				<c:when test="${empty introImageList}">
					<div class="photo_area">
						<div class="img_area">
							<ul><li><img src="${con.IMGPATH}/noimages/no_thumbnail_800x450.jpg" width="100%" /></li></ul>
						</div>
					</div>
				</c:when>
				<%-- 이미지 1장 --%>
				<c:otherwise>
					<div class="photo_area">
						<div class="img_area">
							<ul><li><img src="${con.img_dns}${introImageList[0].s_image_path}" width="100%" /></li></ul>
						</div>
					</div>
				</c:otherwise>
				</c:choose>
				<!-- //소개사진 끝-->
			</div>
			<div class="a_type01_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />병원 소개
				<span style="float:right; font-size: 12px; font-weight: normal;">${hospitalInfo.s_represent_staff_name} 외 ${hospitalInfo.s_staff_count - 1}명</span>
				<span style="float:right; margin-right: 5px; font-size: 12px; font-weight: normal;">[스탭]</span>
				</h3>
				<p class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.s_introduce}">
						${fn:replace(fn:replace(hospitalInfo.s_introduce,'<','&lt;'),crlf,'<br/>')}
					</c:if>
					<c:if test="${empty hospitalInfo.s_introduce}">
						등록된 정보가 없습니다.
					</c:if>
				</p>
			</div>
			
			<!-- 진료시간-->
			<div class="a_type01_b">
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />진료시간</h3>
				<div class="txt_type01 mt10">
					<c:forEach items="${workingTimeList}" var="list">
					<dl>
						<c:if test="${list.s_allday eq 'Y'}">
							<dt>연중무휴</dt>
							<dd>
								<c:if test="${list.s_alltime ne 'Y' and not empty list.s_start_time}">
									${list.s_start_time} ~ ${list.s_end_time}
								</c:if>
								<c:if test="${list.s_alltime eq 'Y'}">
									24시간 영업
								</c:if>
								&nbsp;
							</dd>
						</c:if>
						<c:if test="${list.s_allday ne 'Y'}">
							<dt>${list.s_name}</dt>
							<dd>
							<c:if test="${list.s_alltime ne 'Y' and not empty list.s_start_time}">
								${list.s_start_time} ~ ${list.s_end_time}
							</c:if>
							<c:if test="${list.s_alltime eq 'Y'}">
								24시간 영업
							</c:if>
							<c:if test="${list.s_dayoff eq 'Y'}">
								휴무
							</c:if>
							
							<c:if test="${not empty list.s_comment && list.s_comment ne '' && list.s_comment ne ' '}">
								&nbsp;(${list.s_comment})
							</c:if>
							</dd>
						</c:if>
						</dl>
					</c:forEach>
				</div>
			</div>
			
			<!-- 보유장비 -->
			<c:if test="${hospitalInfo.EQUIPMENT_status eq'Y'}">
			<div class="a_type01_b">
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />보유장비</h3>
				<p class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.EQUIPMENT}">${fn:replace(hospitalInfo.EQUIPMENT,crlf,'<br/>')}</c:if>
					<c:if test="${empty hospitalInfo.EQUIPMENT}">등록된 정보가 없습니다.</c:if>
				</p>
			</div>
			</c:if>
			
			<!-- 부가정보-->
			<div class="a_type01_b">
				<h3 onclick=";"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />부가정보</h3>
				<div class="txt_type01 mt10">
					<c:if test="${not empty hospitalInfo.s_display_tel}">
					<dl>
						<dt>연락처</dt>
						<dd>
							${hospitalInfo.s_display_tel}
						</dd>
					</dl>
					</c:if>
					<c:if test="${not empty hospitalInfo.s_parking_info}">
					<dl>
						<dt>주차</dt>
						<dd>
							${fn:replace(fn:replace(hospitalInfo.s_parking_info,'<','&lt;'),crlf,'<br/>')}
						</dd>
					</dl>
					</c:if>
					<c:if test="${not empty hospitalInfo.s_credit_info}">
					<dl>
						<dt>신용카드</dt>
						<dd>
							${fn:replace(fn:replace(hospitalInfo.s_credit_info,'<','&lt;'),crlf,'<br/>')}
						</dd>
					</dl>
					</c:if>
				</div>
			</div>
			
			<div class="a_type01_b">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />바로가기</h3>
				<div class="btn_list mt10">
					<ul>
						<c:forEach var="site_item" items="${siteList}" varStatus="c">
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_HOMEPAGE}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link01.png"/>
							<c:set var="site_class" value="btn_red"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_BLOG}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link02.png"/>
							<c:set var="site_class" value="btn_green"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_FACEBOOK}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link03.png"/>
							<c:set var="site_class" value="btn_purple"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_TWITTER}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link04.png"/>
							<c:set var="site_class" value="btn_blue"/>
						</c:if>
						<c:if test="${site_item.s_type eq codes.ELEMENT_HOSPITAL_SITE_CAFE}">
							<c:set var="site_icon" value="${con.IMGPATH}/btn/go_link05.png"/>
							<c:set var="site_class" value="btn_black"/>
						</c:if>
						<li>
							<p class="${site_class}"><a href="${site_item.s_url}" data-role="button" target="_blank"><img src="${site_icon}" alt="" width="100%" /></a></p>
							<p class="txt01">${site_item.s_type_name}</p>
						</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
		<!-- ///// content 끝-->
		
		<div id="footer">
			<p class="txt01">
				<span class="border_r">법인(상호)명 : <label>${hospitalInfo.s_company_name}</label></span>
				<span>사업자등록번호 : <label>${hospitalInfo.s_corp_reg_number}</label></span>
			</p>
			<c:choose>
			<c:when test="${empty hospitalInfo.s_email and empty hospitalInfo.s_fax}">
			<p class="txt01">
				<span>대표자 : <label>${hospitalInfo.s_president}</label></span>
			</p>
			</c:when>
			<c:when test="${empty hospitalInfo.s_email and not empty hospitalInfo.s_fax}">
			<p class="txt01">
				<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
				<span>FAX : <label> ${hospitalInfo.s_fax}</label></span>
			</p>
			</c:when>
			<c:when test="${not empty hospitalInfo.s_email and empty hospitalInfo.s_fax}">
			<p class="txt01">
				<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
				<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
			</p>
			</c:when>
			<c:otherwise>
			<p class="txt01">
				<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
				<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
			</p>
			<p class="txt01">
				<span>FAX : <label> ${hospitalInfo.s_fax}</label></span>
			</p>
			</c:otherwise>
			</c:choose>
			<p class="txt02 mt10">본 사이트에서 사용된 모든 일러스트, 그래픽 이미지와 내용의 무단 도용을 금합니다.</p>
			<p class="txt03 mt05">copyrightⓒ${hospitalInfo.s_company_name} all rights reserved</p>
			<p class="txt03">
				<span class="border_r">Hosting by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
				<span>Designed by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
			</p>
		</div>

		<!-- footer -->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp" />

	</div>

</body>
</html>
