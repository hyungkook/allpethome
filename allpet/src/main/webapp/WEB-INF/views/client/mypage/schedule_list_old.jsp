<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<script>
var year = '';
var month = '';

function getPreDDayList(){
	/* if(curNode.pre!=null){
		curNode=curNode.pre;
		getDDayList(curNode.val);
	} */
}

function getPostDDayList(){
	if(curNode.post!=null){
		curNode=curNode.post;
		getDDayList(curNode.val);
	}
}

function getDDayList(monthdate){
	
	$.ajax({
		url:'ajaxMyPageSchedule.latte',
		type:"POST",
		//url:'hospitalServiceMenuEdit.latte',
		data:{
			date:monthdate,
			type:'month'
		},
		//dataType:'text',
		success:function(response, status, xhr){
			
			$('#month_select').html(curNode.val);
			$('#ddaylist').empty();
			$('#ddaylist').append(response);
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var DateNode = function(val,pre){
	this.val = val;
	this.pre = pre;
	this.post = null;
	
	this.setPost=function(post){
		this.post = post;
	};
};

var dnode = null;
var curNode = null;

$(document).ready(function(){
	$('#month_select').html(curNode.val);
});

function moveTop(){

	$('html,body').animate( { 'scrollTop': 0 }, 'fast' );
}

</script>

</head>
<body>

	<div id="page" data-role="page">

		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<c:set var="pre_date" value=""/>
			
			<c:forEach var="item" items="${monthList}">
				<script>
				if(dnode==null){
					dnode=new DateNode('${item.date}', null);
				}
				else{
					var d = dnode;
					dnode = new DateNode('${item.date}', d);
					d.setPost(dnode);
				}
				<c:if test="${item.date eq selectedDate}">curNode=dnode;</c:if>
				</script>
			</c:forEach>
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				스케줄
			</div>
			
			<div class="schedule_top">
				<div class="calendar">
					<a data-role="button"><img src="${con.IMGPATH}/btn/btn_calendar.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="add">
					<a data-role="button" onclick="goPage('myPageScheduleEdit.latte')"><img src="${con.IMGPATH}/btn/btn_plus.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="center">
					<div class="paging">
						<p><a data-role="button" onclick="getPreDDayList();"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
						<span id="month_select" class="headline_white" style="display:inline-block;"><!-- 2014.01 --></span>
						<p><a data-role="button" onclick="getPostDDayList();"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
					</div>
				</div>
				
			</div>
			
			<div class="a_type02" id="ddaylist">
				<jsp:include page="schedule_list_item.jsp"/>
			</div>
			
			<div class="more_top_area01">
				<!-- <div class="more"><a data-role="button">더보기</a></div> -->
				<div class="top"><a data-role="button" onclick="moveTop();">맨위로</a></div>
			</div>
			
			<%-- <div style="display:inline-block; width:70%;">
			<select id="month_select" onchange="getDDayList($(this).val());">
				<c:forEach var="item" items="${monthList}">
					<option value="${item.date}" <c:if test="${item.date eq selectedDate}">selected="selected"</c:if>>${item.date}</option>
				</c:forEach>
			</select>
			</div>
			
			<a onclick="goPage('myPageScheduleEdit.latte')">등록</a>
			
			<div id="ddaylist" style="margin:5px 5px;">
				<jsp:include page="schedule_list_item.jsp"/>
			</div> --%>
			
		</div>
	
	</div>

</body>
</html>