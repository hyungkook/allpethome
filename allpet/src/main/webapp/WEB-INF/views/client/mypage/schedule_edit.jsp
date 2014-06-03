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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<title>스케줄</title>

<script src="${con.JSPATH}/dateFunctions.js"></script>

<script>

var _y = parseInt("${params.year}",10);
var _m = parseInt("${params.month}",10);

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
//				var json = $.parseJSON(decodeURIComponent(response));
				
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
	
	selectDate(old_date,'old');
	selectDate(currentDate);
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
}

function updateDateTags(cur_year,cur_month){
	
	$('#title').html(cur_year+'.'+cur_month+'');
}

var old_date = '';

onload = function(){
	
	var date = new Date();
	date.setFullYear(parseInt("${params.year}",10),parseInt("${params.month}",10)-1,parseInt("${params.day}",10));
	
	var defaultDate = date.format('yyyymmdd');
	
	old_date = defaultDate+"";
	
	createCalendar(_y,_m,'');
	
	var type = "${params.type}";
	
	if(type=="new"){
		openCreateSchedule(defaultDate);
	}
	else if(type=="modify"){
		openModifySchedule(defaultDate);
	}
};

function openCreateSchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').show();
	$('#modify_btn_area').hide();
	
	$('#comment').val('');
	selectDate(d);
}

function openModifySchedule(d){
	
	$('#modify_common_area').show();
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
	;
	$('#comment').val('${fn:replace(schedule.s_comment,lf,"\\n")}');//getScheduleValue(d).comment);
	selectDate(d);
}

function transitionModifySchedule(){
	
	$('#reg_btn_area').hide();
	$('#modify_btn_area').show();
	
	$("#header_title").html("스케줄 변경");
}

function getScheduleValue(d){
	
	for(var j = 0; j < scheduleMap[d].v.length; j++){
		if(scheduleMap[d].v[j].type=='s'){
			return scheduleMap[d].v[j];
		}
	}
}

function createSchedule(){
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	$.ajax({
		type:'POST',
		url:'ajaxMyPageScheduleRegist_v2.latte',
		data:{
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:h,
			minute:$('#reg_minute').html(),
			comment:$('#comment').val()
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.code=='${codes.SUCCESS_CODE}'){
				
				showDialog('등록되었습니다.','default',function(){
					transitionModifySchedule();
					g_rownum = json.rownum;
					
					goPage('myPageSchedule.latte?type=month');
					//history.back();
				});
			}
			else{
				alert('등록에 실패하였습니다.\n에러코드:'+json.resultCode);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

function modifySchedule(){
	
	if(isNoValue('comment')){
		alert('설명을 입력하세요.');
		return;
	}
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	$.ajax({
		type:'POST',
		url:'ajaxMyPageScheduleModify_v2.latte',
		data:{
			rownum:g_rownum,
			year:$('#year').val(),
			month:$('#month').val(),
			day:$('#day').val(),
			hour:h,
			minute:$('#reg_minute').html(),
			comment:$('#comment').val()
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.code=='${codes.SUCCESS_CODE}'){
				
				showDialog('수정되었습니다.','default',function(){
					goPage('myPageSchedule.latte?type=month');
				});
			}
			else{
				alert('수정에 실패하였습니다.\n에러코드:'+json.resultCode);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

function removeSchedule(){
	
	if(!confirm('스케줄을 삭제하시겠습니까?'))
		return;
	
	$.ajax({
		type:'POST',
		url:'ajaxMyPageScheduleRemove_v2.latte',
		data:{
			rownum:g_rownum
		},
		dataType:'text',
		success:function(response, status, xhr){
			
			var json = $.parseJSON(response);
			
			if(json.code=='${codes.SUCCESS_CODE}'){
				
				showDialog('삭제되었습니다.','default',function(){
					goPage('myPageSchedule.latte?type=month');
				});
			}
			else{
				alert('삭제에 실패하였습니다.\n에러코드:'+json.resultCode);
			}
		},
		error:function(xhr, status, error){
			
			alert(status+","+error);
		}
	});
}

var currentDate;
var g_rownum = "${params.rownum}";

function selectDate(d,type){//year, month, day){
	
	if(d!=null){
		
		var llen = 0;
		var tlen = $('#'+d).length;
		
		if(type=='old'){
			llen = $('#oldSelector').length;
			if(llen==0 || tlen==0){
				$('#'+d).prepend($(
						'<span class="selected" id="oldSelector">'
							+'<span class="type02">'
								+'<span class="inner"></span>'
							+'</span>'
						+'</span>'));
			}
			else{
				var l = $('#oldSelector').detach();
				l.find('label').html(d%100+'');
				$('#'+d).append(l);
			}
		}
		else{
			currentDate = d;
			var y = d / 10000;
			$('#year').val(y - y % 1);
			var m = (d % 10000) / 100;
			$('#month').val(m = m - m % 1);
			$('#day').val(d % 100);
			$('#todo_date').html($('#year').val()+"년 "+$('#month').val()+"월 "+$('#day').val()+"일");
			
			llen = $('#selectedLayer').length;
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
}

$(document).ready(function(){
	
	var h = parseInt('${params.hour}');
	var m = parseInt('${params.minute}');
	
	var ap = (h+1) / 12;
	
	m = parseInt(m / 10) * 10;
	
	if(ap > 0)
		selectPM();
	else
		selectAM();
	
	selectHour(h%12);
	selectMinute(twoDigits(m));
	
	if((location.hash==''||location.hash=='#')){
		simple_completeTimePopup();
	}
});

function openTimePopup(){
	
	if($('#reg_ampm').html()=='PM')
		selectPM();
	else
		selectAM();
	
	selectHour($('#reg_hour').html());
	selectMinute($('#reg_minute').html());
	
	location.hash="time";
	$('#time_popup').show();
}

function closeTimePopup(){
	
	$('#time_popup').hide();
	history.back();
}

$(window).load(function(){
	
	if((location.hash==''||location.hash=='#')){
	//	openTimePopup();
	}
});

$(window).on('hashchange',function(){
	
	if((location.hash==''||location.hash=='#')){
		$('#time_popup').hide();
	}
});

function simple_completeTimePopup(){
	
	$('#reg_ampm').html($('#btn_am p').attr('class')=='on'?'AM':'PM');
	$('#reg_hour').html($('#h_selector').parent().find('label').html());
	$('#reg_minute').html($('#m_selector').parent().find('label').html());
	
	var tw = 0;
	if($('#reg_ampm').html()=='PM'){
		tw = 12;
	}
	var h = parseInt($('#reg_hour').html());
	h = h+tw;
	h = h % 24;
	
	$('#print_time').html(twoDigits(h)+':'+$('#reg_minute').html());
	
	$('#time_popup').hide();
}

function completeTimePopup(){
	
	simple_completeTimePopup();
	history.back();
}

function selectAM(){
	$('#btn_am p').attr('class','on');
	$('#btn_pm p').attr('class','off');
}

function selectPM(){
	$('#btn_am p').attr('class','off');
	$('#btn_pm p').attr('class','on');
}

function selectHour(h){
	
	var llen = $('#h_selector').length;
	var tlen = $('#h'+h).length;
	
	if(llen==0 || tlen==0){
		
		$('#h'+h).append($(
		'<span class="selected" id="h_selector">'
			+'<span class="type01">'
				+'<span class="inner"></span>'
				+'<label>'+h+'</label>'
			+'</span>'
		+'</span>'));
	}
	else{
		var l = $('#h_selector').detach();
		l.find('label').html(h+'');
		$('#h'+h).append(l);
	}
	
	$('#popup_hour').html(twoDigits(h));
}

function selectMinute(m){
	
	var llen = $('#m_selector').length;
	var tlen = $('#m'+m).length;
	
	if(llen==0 || tlen==0){
		
		$('#m'+m).append($(
		'<span class="selected" id="m_selector">'
			+'<span class="type01">'
				+'<span class="inner"></span>'
				+'<label>'+m+'</label>'
			+'</span>'
		+'</span>'));
	}
	else{
		var l = $('#m_selector').detach();
		l.find('label').html(m+'');
		$('#m'+m).append(l);
	}
	
	$('#popup_minute').html(m);
}

</script>

</head>
<body>

	<div id="page" data-role="page">
	
		<jsp:include page="/include/client/INC_INSTANCE_DIALOG.jsp"/>
		
		<div class="simple_popup01" id="time_popup">
			<div class="bg"></div>
			<div class="c_area_l1">
				<span class="aliner"></span>
				<div class="c_area_l2">
					<div class="title_bar">
						<p class="title_name">시간 설정</p>
						<a class="title_close" data-role="button" onclick="closeTimePopup();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
					</div>
					<div class="center">
						<div class="schedule_time_ampm">
							<a data-role="button" id="btn_am" onclick="selectAM();"><p class="on">
								<span class="inner"></span>
								<label>AM</label>
							</p></a>
							<a data-role="button" id="btn_pm" onclick="selectPM();"><p class="off">
								<span class="inner"></span>
								<label>PM</label>
							</p></a>
							<span class="time" id="popup_hour">09</span>
							<span class="time">:</span>
							<span class="time" id="popup_minute">00</span>
						</div>
						<p class="select_time_msg01">▼ 시간을 선택해주세요</p>
						<p class="select_table_header">시</p>
						<div class="select_table">
							<p id="h0" onclick="selectHour(0);"><label>0</label></p>
							<p id="h1" onclick="selectHour(1);"><label>1</label></p>
							<p id="h2" onclick="selectHour(2);"><label>2</label></p>
							<p id="h3" onclick="selectHour(3);"><label>3</label></p>
							<p id="h4" onclick="selectHour(4);"><label>4</label></p>
							<p id="h5" onclick="selectHour(5);"><label>5</label></p>
						</div>
						<div class="select_table">
							<p id="h6" onclick="selectHour(6);"><label>6</label></p>
							<p id="h7" onclick="selectHour(7);"><label>7</label></p>
							<p id="h8" onclick="selectHour(8);"><label>8</label></p>
							<p id="h9" onclick="selectHour(9);"><label>9</label></p>
							<p id="h10" onclick="selectHour(10);"><label>10</label></p>
							<p id="h11" onclick="selectHour(11);"><label>11</label></p>
						</div>
						<p class="select_table_header">분</p>
						<div class="select_table">
							<p id="m00" onclick="selectMinute('00');"><label>00</label></p>
							<p id="m10" onclick="selectMinute('10');"><label>10</label></p>
							<p id="m20" onclick="selectMinute('20');"><label>20</label></p>
							<p id="m30" onclick="selectMinute('30');"><label>30</label></p>
							<p id="m40" onclick="selectMinute('40');"><label>40</label></p>
							<p id="m50" onclick="selectMinute('50');"><label>50</label></p>
						</div>
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" onclick="completeTimePopup();"><img src="${con.IMGPATH}/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>설정 완료</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>

		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				스케줄 <c:if test="${params.type eq \"new\"}">등록</c:if><c:if test="${params.type eq \"modify\"}">편집</c:if>
				<div class="menu1"><a data-role="button" onclick="goPage('myPageHome.latte');"><img height="0" src="${con.IMGPATH}/btn/btn_home.png"/></a></div>
			</div>
			
			<div class="schedule_top">
				<div class="center">
					<div class="paging">
						<p><a data-role="button" id="pre_btn" onclick="createPreMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_l03.png" width="29" height="29"/></a></p>
						<span class="headline_white" id="title"></span>
						<p><a data-role="button" id="next_btn" onclick="createNextMonthCalendar(null);"><img src="${con.IMGPATH}/btn/btn_arrow_r03.png" width="29" height="29"/></a></p>
					</div>
				</div>
			</div>
			
			<div class="calendar" id="schedule_calendar"></div>
			
			<div class="schedule_time_select">
				<table>
					<colgroup>
						<col width="50%"/><col width="*"/>
					</colgroup>
					<tr>
						<td class="title">
							<img src="${con.IMGPATH}/common/icon_time.png" height="20px"/>
							<span>예약시간 설정</span>
						</td>
						<td class="time">
							<span id="reg_ampm">AM</span>
							<span id="reg_hour">07</span>
							<span>:</span>
							<span id="reg_minute">00</span>
							<img onclick="openTimePopup();" src="${con.IMGPATH}/btn/btn_time_edit.png" height="30px"/>
						</td>
					</tr>
				</table>
			</div>
			
			<input type="hidden" id="year"/>
			<input type="hidden" id="month"/>
			<input type="hidden" id="day"/>
			
			<div class="a_type02">
				<c:if test="${schedule.s_type eq codes.REGISTRANT_TYPE_HOSPITAL}">
					<p class="title01">[${schedule.s_registrant_name}]</p>
				</c:if>
				<h3><span id="todo_date">2014년 1월 5일</span> (<span id="print_time">07:00</span>)일정</h3>
				<p class="textarea01">
					<textarea id="comment" rows="3" placeholder="스케줄 내용을 입력해 주세요."></textarea>
				</p>
				<p id='reg_btn_area' class="btn_bar_red btn_bar_shape02 mt08">
					<a data-role="button" id="reg_btn"><span>일정 등록</span></a>
				</p>
				<div id='modify_btn_area'>
					<%-- 유저가 등록했고 시간이 아직 유효할 경우 or 새로 등록하는 경우 --%>
					<c:if test="${schedule.s_type eq codes.REGISTRANT_TYPE_USER and schedule.timeout_flag eq 'N' or params.type eq 'new'}">
					<div class="btn_area02 mt08">
						<div class="l_30">
							<p class="btn_bar_black btn_bar_shape02">
								<a data-role="button" onclick="removeSchedule();"><span>삭제</span></a>
							</p>
						</div>
						<div class="r_70">
							<p class="btn_bar_red btn_bar_shape02">
								<a data-role="button" id="modify_btn" onclick="modifySchedule();"><span>수정</span></a>
							</p>
						</div>
					</div>
					</c:if>
					<%-- 병원에서 등록했거나 시간이 유효하지 않을 경우 --%>
					<c:if test="${schedule.timeout_flag eq 'Y' and empty schedule.s_vaccine_group}">
					<p class="btn_bar_black btn_bar_shape02 mt08">
						<a data-role="button" onclick="removeSchedule();"><span>삭제</span></a>
					</p>
					</c:if>
				</div>
			</div>
		</div>
		<!-- contents 끝 -->
		
		<jsp:include page="../include/mypage_footer.jsp"/>
		
	</div>

<script>

updateDateTags(_y,_m);

$('#modify_common_area').hide();
$('#reg_btn_area').hide();
$('#modify_btn_area').hide();

$('#reg_btn').bind('click',createSchedule);

</script>

</body>
</html>