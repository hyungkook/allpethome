<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<title>Insert title here</title>

<style type="text/css">

/* .ui-select .ui-btn-inner {padding:10px 0px;}
.ui-select div {margin:0px; padding:0px; border:1px solid black;} */

</style>

<script type="text/javascript" src="${con.JSPATH}/jquery.event.drag-1.5.min.js?v=1402180"></script>
<script type="text/javascript" src="${con.JSPATH}/jquery.touchSlider.js?v=1402180"></script>

<script>

var lastIndex = 1;
var init = false;

$(document).ready(function(){
	
	init = false;
	staff_info_loaded = true;
	moving = false;
	
	$("#touchSlider").touchSlider({
		flexible : true,
		btn_prev : $("#aprev"),
		btn_next : $("#anext"),
		counter : function (e) {
			pageDotChange(e.current-1);
			lastIndex = e.current;
			//$("#count").html("current : " + e.current + ", total : " + e.total);
		}
	});
	
	$('#touchSlider ul').css('height', parseInt($('.doctor_info').css('height'))+parseInt($('.doctor_info').css('margin-top'))+parseInt($('.doctor_info').css('margin-bottom')));
	
	init = true;
	moving = false;
	
	tt=1;
});

var moving = false;

function goPageChange(index){
	
	var c = index - lastIndex;
	if(c > 0){
		moving = true;
		for(var i = 0; i < c; i++){
			if(i==(c-1))
				moving = false;
			$("#anext").click();
		}
	}
	if(c < 0){
		moving = true;
		for(var i = 0; i < -c; i++){
			if(i==(-c-1))
				moving = false;
			$("#aprev").click();
		}
	}
	//window.slider_i.slide(index - 1, 400);
}

var staff_info_loaded = true;

function pageDotChange(index) {
	
	for (var i=0; i<=parseInt('${fn:length(staffList)}'); i++){
		$("#paging_img_" + i).attr("src","${con.IMGPATH}/common/paging02_off.png");
	}
	$("#paging_img_" + (index + 1)).attr("src","${con.IMGPATH}/common/paging02_on.png");
	
	//$.ajax({async:false,url:'ajaxDevLog.latte',data:{index:index,init:init,moving:moving,staff_info_loaded:staff_info_loaded}});
	
	if(init && !moving && staff_info_loaded){
		loadingStaffInfo = false;
		$.ajax({
			url:'ajaxHospitalStaff.latte?idx=${params.idx}&category='+$('#staff_category').val()+'&seq='+(index+1),
			dataType:'text',
			success:function(response,status,xhr){
				$('#staff_info').empty();
				$('#staff_info').append(response);
				staff_info_loaded = true;
			},
			error:function(xhr,status,error){
				alert('에러');
				staff_info_loaded = true;
			}
		});
	}
}

</script>

</head>
<body style="overflow-x:auto;">
		
	<div data-role="page">
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 상단 이미지 영역 -->
			<jsp:include page="main_header.jsp"/>
		
			<jsp:include page="../include/main_menu.jsp"/>
			
			<div class="a_type01_b">
				<div class="btn_select">
					<a data-role="button">
					<select id="staff_category" data-icon="false" onchange="goPage('hospitalStaff.latte?idx=${params.idx}&cmid='+$(this).val());">
						<c:forEach var="item" items="${staffMenu}" varStatus="c">
							<option value="${item.s_cmid}" <c:if test="${categoryInfo.s_cmid eq item.s_cmid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				<div class="w_box mt20">
					<c:choose>
					<%-- 스태프 2명 이상일 경우만 슬라이드 활성화 --%>
					<c:when test="${fn:length(staffList)>1}">
						<p class="btn_l btn_img"><a id="aprev" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l.png" alt="" width="35" height="100"/></a></p>
						<p class="btn_r btn_img"><a id="anext" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r.png" alt="" width="35" height="100"/></a></p>
						
						<div id="touchSlider">
						<ul style="position:relative;">
						<c:forEach var="item" items="${staffList}">
						<li class="doctor_info" style="position:absolute; left:0; top:0;">
							<dl>
								<dt class="thum"><img src="<c:choose><c:when test="${empty item.image_path}">${con.IMGPATH}/common/default_logo.jpg</c:when><c:otherwise>${con.img_dns}${item.image_path}</c:otherwise></c:choose>" alt="" width="74" height="99"/></dt>
								<dt class="info mt04">${item.s_position}</dt>
								<dt class="mt04">${item.s_name}</dt>
								<dd class="mt08">현 ${hospitalInfo.s_hospital_name} 소속</dd>
								<dd>${item.s_specialty}</dd>
							</dl>
							</li>
							</c:forEach>
						</ul>
						</div>
					</c:when>
					<c:otherwise>
						<ul>
						<c:forEach var="item" items="${staffList}">
						<li class="doctor_info">
							<dl>
								<dt class="thum"><img src="<c:choose><c:when test="${empty item.image_path}">${con.IMGPATH}/common/default_logo.jpg</c:when><c:otherwise>${con.img_dns}${item.image_path}</c:otherwise></c:choose>" alt="" width="74" height="99"/></dt>
								<dt class="info mt04">${item.s_position}</dt>
								<dt class="mt04">${item.s_name}</dt>
								<dd class="mt08">현 ${hospitalInfo.s_hospital_name} 소속</dd>
								<dd>${item.s_specialty}</dd>
							</dl>
						</li>
						</c:forEach>
						</ul>
					</c:otherwise>
					</c:choose>
					
				</div>
				<c:if test="${fn:length(staffList)>1}">
				<div class="paging">
					<ul>
						<%-- <c:forEach begin="1" end="${params.totalCount}" varStatus="c"> --%>
						<c:forEach var="item" items="${staffList}" varStatus="c">
						<%-- <li><a onclick="goPage('hospitalStaff.latte?idx=${params.idx}&cmid=${categoryInfo.s_cmid}&pageNumber=${c.index}')"><img src="${con.IMGPATH}/common/paging02_<c:choose><c:when test="${c.index eq params.pageNumber}">on</c:when><c:otherwise>off</c:otherwise></c:choose>.png" alt="" width="10" height="10" /></a></li> --%>
						<li><a onclick="goPageChange(${c.count})"><img id="paging_img_${c.count}" src="${con.IMGPATH}/common/paging02_<c:choose><c:when test="${c.index eq params.pageNumber}">on</c:when><c:otherwise>off</c:otherwise></c:choose>.png" alt="" width="10" height="10" /></a></li>
						</c:forEach>
					</ul>
				</div>
				</c:if>
			</div>
			
			<div id="staff_info">
			<jsp:include page="hospital_staff_info.jsp"/>
			
			</div>
			
		</div>
		<!-- ///// content 끝-->
		
		<!-- footer -->
		<jsp:include page="/include/client/INC_FOOTER_COPYRIGHT.jsp"/>
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/>

	</div>

</body>
</html>