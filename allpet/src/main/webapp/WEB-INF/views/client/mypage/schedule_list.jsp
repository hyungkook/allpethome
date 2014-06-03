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

<script src="${con.JSPATH}/dateFunctions.js"></script>

<script>

var _y = parseInt("${params.year}");
var _m = parseInt("${params.month}");

if(_m < 10)
	_m = parseInt("0"+_m);

var dayoftheweek = ['MON','TUE','WED','THU','FRI','SAT','SUN'];

var startLimit = 0;//20130915;
var endLimit = 99999999;//20131115;

var disableMap = new Array();

var scheduleMap;

var cacheKey = "";

function createCalendar(year,month,anniversary){
	
	var pre_year = year;
	var pre_month = month-1;
	var next_year = year;
	var next_month = month+1;
	
	if(pre_month<1){
		pre_month=12;
		pre_year--;
	}
	
	if(next_month>12){
		next_month=1;
		next_year++;
	}
	
	var searchKey = year;
		
	// 연단위로 받아옴
	if(cacheKey != searchKey){
		cacheKey = searchKey;
		
		// 동기식으로 휴일/스케줄 정보를 받아옴.
		$.ajax({
			type:'POST',
			async:false,
			url:'ajaxRequestAnniversary.latte',
			data:{month:year+"-"+twoDigits(month)},
			dataType:'text',
			success:function(response, status, xhr){
				
				var json = $.parseJSON(response);
				
				scheduleMap= json;
				
				//disableMap['20131022']='e';
			},
			error:function(xhr, status, error){
				
				alert(status+","+error);
			}
		});
	}
	
	var first = 6; // 0 = monday, 6 = sunday
	
	var ml = getLastDate(year,month);
	var pre_ml = getLastDate(pre_year,pre_month);
	var week = getFirstDateWeek(year,month);
	var map = scheduleMap;
	
	//console.log(ml+","+week);
	var tag = '<div class="header">';
	/* for(var i = first; i != (first+6)%7; i=(i+1)%7){
		tag+='<div class="calrendar_cell">'+dayoftheweek[i]+'</div>';
		console.log("h"+i);
	} */
	var row;
	for(var i = 0; i < 7; i++){
		if((i+first)%7==5){
			tag+='<p class="sat">'+dayoftheweek[(i+first)%7]+'</p>';
		}
		else if((i+first)%7==6){
			tag+='<p class="sun">'+dayoftheweek[(i+first)%7]+'</p>';
		}
		else{
			tag+='<p class="other">'+dayoftheweek[(i+first)%7]+'</p>';
		}
		//console.log("h"+(i+first)%7);
	}
	tag+='</div>';
	//tag+='<div style="display:table-row;">';
	tag+='<div class="body">';
	var tail = 0;
	if(week<first)
		tail = pre_ml - (week+7-first)+1;
	else
		tail = pre_ml - (week-first)+1;
	for(var i = first; i != (week)%7; i=(i+1)%7){
		var d = pre_year+twoDigits(pre_month)+twoDigits(tail);
		tag+='<p class="external" id="'+d+'" onclick="createPreMonthCalendar('+d+')"><label>'+tail+'</label></p>';
		tail++;
	}
	for(var i = 0; i < ml; i++){
		week=week%7;
		//console.log("d"+i+","+week);
		if(week==first){
			//tag+='</div>';
			//tag+='<div>';
		}
		var d = year+twoDigits(month)+twoDigits(i+1);
		
		tag+='<p id="'+d+'" onclick="selectDate('+d+');">';
		if(map[d]!=null){
			var cssclass = "";
			var holiday = false;
			var name = "";
			var scheduleCnt = 0;
			for(var j = 0; j < map[d].length; j++){
				if(map[d][j].type=='h'){//휴일
					holiday = true;
					name += map[d][j].comment;
				}
				else if(map[d][j].type=='s'){//스케줄
					scheduleCnt++;
				}
			}
			if(holiday){
				cssclass = ' class="red"';
			}
			if(scheduleCnt > 0){
				tag+='<span class="number_tag">'+scheduleCnt+'</span>';
			}
			tag+='<label'+cssclass+'>'+(i+1)+'</label>';
		}
		else{
			tag+='<label>'+(i+1)+'</label>';
		}
		tag+="</p>";
		week++;
	}
	var head_d = 1;
	for(var i = week; i != first%7; i=(i+1)%7){
		var d = next_year+twoDigits(next_month)+twoDigits(head_d);
		tag+='<p class="external" id="'+d+'" onclick="createNextMonthCalendar('+d+')"><label>'+head_d+'</label></p>';
		/* if(i==6)
			tag+='<div id="'+d+'" class="calendar_outer_holiday_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>';
		else if(i==5)
			tag+='<div id="'+d+'" class="calendar_outer_sat_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>';
		else
			tag+='<div id="'+d+'" class="calendar_outer_normal_cell" onclick="createNextMonthCalendar('+d+')">'+head_d+'</div>'; */
		head_d++;
		//console.log("b"+i);
	}
	tag+='</div>';
	$('#schedule_calendar').append(tag);
	
	curDateUpdate(currentDate);
}

function createPreMonthCalendar(selectedDate){
	
	_m--;
	if(_m==0){_y--;_m = 12;}
	
	$('#schedule_calendar').empty();
	createCalendar(_y,_m,'');
	
	updateDateTags(_y,_m);
	
	if(selectDate!=null){
		selectDate(selectedDate);
	}
	//alert(_y+"-"+twoDigits(_m));
	if(view_type=='month'){
		getDDayList(_y+"-"+twoDigits(_m));
	}
}

function createNextMonthCalendar(selectedDate){
	
	_m++;
	if(_m==13){_y++;_m = 1;}
	
	$('#schedule_calendar').empty();
	createCalendar(_y,_m,'');
	
	updateDateTags(_y,_m);
	
	if(selectDate!=null){
		selectDate(selectedDate);
	}
	
	//alert(_y+"-"+twoDigits(_m));
	if(view_type=='month'){
		getDDayList(_y+"-"+twoDigits(_m));
	}
}

function updateDateTags(cur_year,cur_month){
	
	$('#title').html(cur_year+'.'+cur_month+'');
}

onload = function(){

	createCalendar(_y,_m,'');
	
	var date = new Date();
	date.setFullYear(parseInt("${params.year}"),parseInt("${params.month}")-1,parseInt("${params.day}"));
	
	var defaultDate = date.format('yyyymmdd');
	
	//selectDate(defaultDate);
};

var currentDate;
var g_rownum = "${params.rownum}";

function curDateUpdate(d){
	
	if(d!=null){
		currentDate = d;
	
		var y = d / 10000;
		$('#year').val(y - y % 1);
		var m = (d % 10000) / 100;
		$('#month').val(m = m - m % 1);
		$('#day').val(d % 100);
		$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
		
		//$('#smsList').find('th');
		var llen = $('#selectedLayer').length;
		var tlen = $('#'+d).length;
		
		if(llen==0 || tlen==0){
			//$('#'+d).append("<div id='selectedLayer' style='width:100%; height:100%; filter:alpha(opacity=50); opacity:0.5; background-color:red; position:absolute; top:0; left:0; bottom:0; right:0;'></div>");
			
			$('#'+d).prepend($(
			'<span class="selected" id="selectedLayer">'
				+'<span class="type01">'
					+'<span class="inner"></span>'
					+'<label>'+(d%100)+'</label>'
				+'</span>'
			+'</span>'));
		}
		else{
			var l = $('#selectedLayer').detach();
			l.find('label').html(d%100+'');
			$('#'+d).append(l);
		}
	}
}

function selectDate(d){//year, month, day){
	
	if(d!=null){
		currentDate = d;
	
		var y = d / 10000;
		$('#year').val(y - y % 1);
		var m = (d % 10000) / 100;
		$('#month').val(m = m - m % 1);
		$('#day').val(d % 100);
		$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
		
		//$('#smsList').find('th');
		var llen = $('#selectedLayer').length;
		var tlen = $('#'+d).length;
		
		if(llen==0 || tlen==0){
			//$('#'+d).append("<div id='selectedLayer' style='width:100%; height:100%; filter:alpha(opacity=50); opacity:0.5; background-color:red; position:absolute; top:0; left:0; bottom:0; right:0;'></div>");
			
			$('#'+d).prepend($(
			'<span class="selected" id="selectedLayer">'
				+'<span class="type01">'
					+'<span class="inner"></span>'
					+'<label>'+(d%100)+'</label>'
				+'</span>'
			+'</span>'));
		}
		else{
			var l = $('#selectedLayer').detach();
			l.find('label').html(d%100+'');
			$('#'+d).append(l);
		}
		
		var dd = (y - y % 1)+"-"+twoDigits(m)+"-"+twoDigits(d % 100);
		
		$.ajax({
			url:'ajaxMyPageSchedule.latte',
			type:"POST",
			//url:'hospitalServiceMenuEdit.latte',
			data:{
				date:dd,
				type:view_type
			},
			success:function(response, status, xhr){
				
				/* if(response.replace(/(^\s*)|(\s*$)/gi, "")==''){
					$('#no_schedule').show();
				}
				else{
					$('#no_schedule').hide();
				} */
				
				$('#ddaylist').empty();
				$('#ddaylist').append(response);
				
				if($('#ddaylist > div').length > 0){
					$('#no_schedule').hide();
					$('#ddaylist').show();
				}else{
					$('#no_schedule').show();
					$('#ddaylist').hide();
				}
			},
			error:function(xhr, status, error){
				
				alert(status+","+error);
			}
		});
	}
}
</script>


<script>
var year = '';
var month = '';

function getDDayList(monthdate){
	
	$.ajax({
		url:'ajaxMyPageSchedule.latte',
		type:"POST",
		data:{
			date:monthdate,
			type:view_type
		},
		success:function(response, status, xhr){
			
			$('#ddaylist').empty();
			$('#ddaylist').append(response);
			
			if($('#ddaylist > div').length > 0){
				$('#no_schedule').hide();
				$('#ddaylist').show();
			}else{
				$('#no_schedule').show();
				$('#ddaylist').hide();
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var view_type = '${params.type}'; 

$(document).ready(function(){
	//$('#month_select').html(curNode.val);
	
	if(view_type!='day'){
		$('#type_day').hide();
	}
});

function moveTop(){

	$('html,body').animate( { 'scrollTop': 0 }, 'fast' );
}

function toggleType(){
	
	if(view_type=='month'){
		view_type='day';
		$('#ddaylist').empty();
		$('#ddaylist').hide();
		$('#type_day').show();
	}else{
		view_type='month';
		$('#type_day').hide();
		getDDayList(_y+"-"+twoDigits(_m));
	}
	
	if($('#ddaylist > div').length > 0){
		$('#no_schedule').hide();
	}else{
		$('#no_schedule').show();
	}
}

</script>

</head>
<body>

	<div id="page" data-role="page">

		<!-- content 시작-->
		<div data-role="content" id="contents" style="overflow: hidden">
		
			<c:set var="pre_date" value=""/>
			
			<%-- <c:forEach var="item" items="${monthList}">
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
			</c:forEach> --%>
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				스케줄
				<div class="menu1"><a data-role="button" onclick="goPage('myPageHome.latte');"><img height="0" src="${con.IMGPATH}/btn/btn_home.png"/></a></div>
			</div>
			
			<div class="schedule_top">
				<div class="calendar">
					<a data-role="button" onclick="toggleType();"><img id="vtype_btn" src="${con.IMGPATH}/btn/btn_calendar.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="add">
					<a data-role="button" onclick="goPage('myPageScheduleEdit.latte')"><img src="${con.IMGPATH}/btn/btn_plus.png" alt="" width="100%" height="100%" /></a>
				</div>
				<div class="center">
					<div class="paging">
						<p><a data-role="button" id="pre_btn" onclick="createPreMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
						<span class="headline_white" id="title"></span>
						<p><a data-role="button" id="next_btn" onclick="createNextMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
					</div>
				</div>
				
			</div>
			
			<div id="type_day">
				<div class="calendar" id="schedule_calendar"></div>
				
				
			</div>
			
			<div class="a_type01" id="no_schedule" style="display:none;">
				<p style="padding:50px 0; font-size:large; color:#727272; text-align:center;">
				등록된 일정이 없습니다.
				</p>
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
		<!-- contents 끝 -->
		
		<jsp:include page="../include/mypage_footer.jsp"/>
	
	</div>
	
<script>

updateDateTags(_y,_m);

</script>

</body>
</html>