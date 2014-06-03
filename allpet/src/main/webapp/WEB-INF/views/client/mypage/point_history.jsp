<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
 
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>포인트 상세 내역</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<script>

var pageNumber = parseInt("${params.pageNumber}");
var totalPage = parseInt("${params.pageCount}");

function expand(){
	
	pageNumber++;
	if(pageNumber > totalPage){
		pageNumber = totalPage;
		alert('더 이상 항목이 없습니다.');
		$('#more_btn').attr('disabled',true);
		$('#more_btn').off('click');
		$('#more_btn').remove();
		return;
	}
	
	$.mobile.showPageLoadingMsg('a','목록을 불러오는 중입니다.');
	
	$.ajax({
		url:'myPagePointHistory.latte',
		type:'POST',
		data:{pageNumber:pageNumber,
			sid:'${params.sid}',
			period:'${params.period}'},
		dataType:'text',
		success:function(response,status,xhr){
			
			$('#pointList').append($(response));
			
			$.mobile.hidePageLoadingMsg();
			
			if(pageNumber >= totalPage){
				pageNumber = totalPage;
				$('#more_btn').attr('disabled',true);
				$('#more_btn').off('click');
				$('#more_btn').remove();
				return;
			}
		},
		error:function(xhr,status,error){
			
			$.mobile.hidePageLoadingMsg();
		}
	});
}

function moveTop(){

	$('html,body').animate( { 'scrollTop': 0 }, 'fast' );
}

</script>

</head>
<body>

<div id="page" data-role="page">

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div class="mypage_header">
			<div class="back"><a data-role="button" data-rel="back"><img height="100%" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
			포인트 상세 내역
		</div>
		
		<div class="tab02">
			<ul>
				<li class="first"><a onclick="goPage('myPagePointHistory.latte?sid=${params.sid}&period=7');" <c:if test='${params.period eq "7"}'>class="on"</c:if>><span>최근 일주일</span></a></li>
				<li><a onclick="goPage('myPagePointHistory.latte?sid=${params.sid}&period=30');" <c:if test='${params.period eq "30"}'>class="on"</c:if>><span>최근 1개월</span></a></li>
				<li><a onclick="goPage('myPagePointHistory.latte?sid=${params.sid}&period=90');" <c:if test='${params.period eq "90"}'>class="on"</c:if>><span>최근 3개월</span></a></li>
				<li><a onclick="goPage('myPagePointHistory.latte?sid=${params.sid}');" <c:if test="${empty params.period}">class="on"</c:if>><span>전체</span></a></li>
			</ul>
		</div>
		
		<div class="a_type03">
			총 <b><fmt:formatNumber value="${total.cnt}" pattern="#,###"/><c:if test="${empty total.cnt}">0</c:if></b> 건
			<p class="rb_tag">
				현재 보유 포인트&nbsp;<span><fmt:formatNumber value="${total.sum_pt}" pattern="#,###"/><c:if test="${empty total.sum_pt}">0</c:if></span>&nbsp;<img style="" src="${con.IMGPATH}/common/icon_point.png" alt="" height="16px" />
			</p>
		</div>
		
		<ul id="pointList">
			<jsp:include page="point_history_item.jsp"/>
		</ul>
		
		<div class="more_top_area01">
			<div class="more"><a data-role="button" id="more_btn">더보기</a></div>
			<div class="top" onclick="moveTop();"><a data-role="button">맨위로</a></div>
		</div>
	</div>
	<!-- contents 끝 -->
	
	<jsp:include page="../include/mypage_footer.jsp"/>
	
</div>

<script>

$('#more_btn').on('click',function(){
	expand();
});

if(totalPage==1){
	$('#more_btn').remove();
};

</script>

</body>
</html>