<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page import = "java.util.Calendar" %>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
</jsp:scriptlet>

<c:set var="cur_year" value="<%= Calendar.getInstance().get(Calendar.YEAR) %>"/>
<c:set var="year_term" value="${cur_year - 1983}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>반려동물 정보</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<style type="text/css">

/* .ui-select .ui-btn-inner {padding:10px 0px;}
.ui-select div {margin:0px; padding:0px;} */

</style>

<script src="${con.JSPATH}/dateFunctions.js"></script>

<script>

var g_species;
var g_gender;
var g_breed;
var g_neutralize;

function btnOn(id){
	$('#'+id).removeClass('btn_bar_gray');
	$('#'+id).addClass('btn_bar_black');
	$('#'+id+' img').show();
	var span = $('#'+id+' img').parent().find('span'); 
	if(span.html().indexOf('&nbsp;')<0){
		span.html('&nbsp;'+span.html());
	}
}

function btnOff(id){
	$('#'+id).removeClass('btn_bar_black');
	$('#'+id).addClass('btn_bar_gray');
	$('#'+id+' img').hide();
	var span = $('#'+id+' img').parent().find('span');
	if(span.html().indexOf('&nbsp;')>-1){
		span.html(span.html().substr(6,span.html().length-6));
	}
}

function selectSpecies(species){
	
	if(species=='dog'){
		btnOn('dog_btn');
		btnOff('cat_btn');
		$('#dog_list').show();
		$('#cat_list').hide();
		$('#breed').val($('#dog_list select').val());
	}
	else if(species=='cat'){
		btnOff('dog_btn');
		btnOn('cat_btn');
		$('#dog_list').hide();
		$('#cat_list').show();
		$('#breed').val($('#cat_list select').val());
	}
	$('#species').val(species);
}

function selectGender(gender){
	
	if(gender=='male'){
		btnOn('male_btn');
		btnOff('female_btn');
	}
	else if(gender=='female'){
		btnOff('male_btn');
		btnOn('female_btn');
	}
	$('#gender').val(gender);
}

function selectNeutralize(neut){
	
	if(neut=='rsv'){
		btnOn('rsv_btn');
		btnOff('done_btn');
		btnOff('na_btn');
	}
	else if(neut=='done'){
		btnOff('rsv_btn');
		btnOn('done_btn');
		btnOff('na_btn');
	}
	else if(neut=='na'){
		btnOff('rsv_btn');
		btnOff('done_btn');
		btnOn('na_btn');
	}
	$('#neutralize').val(neut);
}

function selectMonth(month, selectedDate){
	
	$('#birth_day').remove();
	$('#birth_day_div').empty();
	
	var lastDate = getLastDate($('#birth_year').val(),month);
	
	//console.log($('#birth_year').val()+" "+month+" "+lastDate);
	
	var $select = $('<select/>');
	$select.attr('id','birth_day');
	
	for(var i = 0; i < lastDate; i++){
		
		var $option = $('<option/>');
		$option.attr('value',(i+1));
		if(selectedDate==(i+1))
			$option.attr('selected',true);
		$option.text(i+1);
		
		$select.append($option);
	}
	
	$('#birth_day_div').append($select);
	$('#birth_day_div').trigger('create');
}

var allowReg = true;

function register(){
	
	if(!allowReg)
		return;
	
	if(isNoValue("species")){
		showDialog("반려동물의 종을 선택하세요.");
		return;
	}
	
	if($('#breed').val()=='none'){
		showDialog("반려동물의 품종을 선택하세요.");
		return;
	}
	
	if(isNoValue("gender")){
		showDialog("반려동물의 성별을 선택하세요.");
		return;
	}
	
	if(isNoValue("pet_name")){
		showDialog("반려동물의 이름을 입력하세요.");
		return;
	}
	
	if(isNoValue("neutralize")){
		showDialog("반려동물의 중성화 여부를 선택하세요.");
		return;
	}
	
	allowReg = false;
	
	$('#birthday').val($('#birth_year').val()+'-'+$('#birth_month').val()+'-'+$('#birth_day').val());
	
	$.mobile.showPageLoadingMsg('a','데이터를 전송하고 있습니다.');
	
	//setTimeout(function(){
	$.ajax({
		url:'petRegExecute.latte',
		type:'POST',
		data:$(form).serialize()+
		"&first_base="+$('#first_base').val()+
		"&base_year="+$('#base_year').val()+
		"&base_month="+$('#base_month').val()+
		"&base_day="+$('#base_day').val()+
		"&new_drf_year="+$('#dirofilaria_year').val()+
		"&new_drf_month="+$('#dirofilaria_month').val()+
		"&new_drf_day="+$('#dirofilaria_day').val()
		,
		dataType:'json',
		success:function(response,status,xhr){
			
			$.mobile.hidePageLoadingMsg();
			
			allowReg = true;
			
			if(response.result=='${codes.SUCCESS_CODE}'){
				
				showDialog('저장되었습니다.','default',function(){
					
					goPage('myPageHome.latte');
				});
				
				$('#pid').val(response.pid);
				$('#pet_title').html('반려동물 정보');
				$('#new_btn_area').hide();
				$('#modify_btn_area').show();
			}
			else if(response.result=='${codes.ERROR_UNAUTHORIZED}'){
				
				goPage('myPageHome.latte');
			}
			else
				alert('데이터 입력을 실패하였습니다. code:'+response.result+','+response.result_detail);
		},
		error:function(xhr,status,error){
			
			$.mobile.hidePageLoadingMsg();
			
			allowReg = true;
			
			alert('데이터 입력을 실패하였습니다. status:'+status+', error:'+error);
		}
	});
	//},1000);
}

function removePet(){
	
	if(!confirm('반려동물 정보를 삭제하시겠습니까?'))
		return;
	
	$.mobile.showPageLoadingMsg('a','잠시만 기다려주십시오.');
	
	$.ajax({
		url:'petRemoveExecute.latte',
		type:'POST',
		data:$(form).serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			$.mobile.hidePageLoadingMsg();
			
			if(response.resultCode=='${codes.SUCCESS_CODE}'){
				
				showDialog("삭제되었습니다.",'default',function(){goPage(response.redirect);});
			}
			else if(response.resultCode=='${codes.ERROR_UNAUTHORIZED}'){
				
				goPage('myPageHome.latte');
			}
			else
				alert('삭제에 실패하였습니다. code:'+response.resultCode);
		},
		error:function(xhr,status,error){
			
			$.mobile.hidePageLoadingMsg();
			
			alert('삭제에 실패하였습니다. status:'+status+', error:'+error);
		}
	});
}

$(document).ready(function(){
	
	toggleBasic();
	toggleDirofilaria();
	toggleOther();
	$('#pet_vaccine').hide();
	
	//$('body').touchmove(function(){
	//	alert(1);
	//});
	
	//setInterval(function(){
	//	$('body').trigger('touchmove');
	//},1000);
});

function toggleArea(id){
	
	if($('#'+id+'_body').is(':visible')){
		$('#'+id+'_body').hide();
		$('#'+id+'_title #close_btn').hide();
		$('#'+id+'_title #open_btn').show();
	}
	else{
		$('#'+id+'_body').show();
		$('#'+id+'_title #close_btn').show();
		$('#'+id+'_title #open_btn').hide();
	}
}

function toggleBasic(){
	
	toggleArea('basic');
}

function toggleDirofilaria(){
	
	toggleArea('dirofilaria');
}

function toggleOther(){
	
	toggleArea('other');
}

if(location.hash!=''&&location.hash!='#'){
	history.back();
}


var basic_len = 0;
var basic_term = 0;
var basic_term_type = '';

var antibody_term = 0;
var antibody_term_type = 0;
var added_term = 0;
var added_term_type = 0;

var dirofilaria_term = 0;
var dirofilaria_term_type = 0;

var dirofilaria_last_year = 0;
var dirofilaria_last_month = 0;
var dirofilaria_last_day = 0;



function changeBaseDate(){
	
	//alert(1);
	
	var c = parseInt($('#first_base').val(),10);
	
	//alert(c);
	var y = parseInt($('#base_year').val(),10);
	var m = parseInt($('#base_month').val(),10);
	var d = parseInt($('#base_day').val(),10);
	
	//alert(c+","+y+","+m+","+d);
	
	var date = new Date();
	
	var _y = 0;
	var _m = 0;
	var _d = 0;
	
	for(var i=0; i < basic_len; i++){
		
		date.setFullYear(y,m-1,d);

		var t = (basic_term_type=='DAY')?(basic_term*86400000):(basic_term_type=='WEEK')?(basic_term*7*86400000):(basic_term_type=='MONTH')?(basic_term*30*86400000):(basic_term_type=='YEAR')?(basic_term*365*86400000):0;
		if(t==0){alert('에러');return;}
		t = ((i+1) - c) * t;
		
		//alert(t);
		date.setTime(date.getTime()+t);
		_y = date.getFullYear();
		_m = (date.getMonth()+1);
		_d = date.getDate();
		
		$('#base_year_'+i).val(_y);
		$('#base_year_'+i).selectmenu("refresh");
		
		$('#base_month_'+i).val(_m);
		$('#base_day_'+i).val(_d);
		
		//console.log(_y+"."+_m+"."+_d);
	}
	
	date.setFullYear(_y,_m-1,_d);

	var t = (antibody_term_type=='DAY')?(antibody_term*86400000):(antibody_term_type=='WEEK')?(antibody_term*7*86400000):(antibody_term_type=='MONTH')?(antibody_term*30*86400000):(antibody_term_type=='YEAR')?(antibody_term*365*86400000):0;
	if(t==0){alert('에러');return;}
	//t = (basic_len - c) * t;
	
	date.setTime(date.getTime()+t);
	
	$('#antibody_year').val(date.getFullYear());
	$('#antibody_year').selectmenu("refresh");
	
	$('#antibody_month').val((date.getMonth()+1));
	$('#antibody_day').val(date.getDate());
	
	date.setFullYear(_y,_m-1,_d);

	var t = (added_term_type=='DAY')?(added_term*86400000):(added_term_type=='WEEK')?(added_term*7*86400000):(added_term_type=='MONTH')?(added_term*30*86400000):(added_term_type=='YEAR')?(added_term*365*86400000):0;
	if(t==0){alert('에러');return;}
	//t = (basic_len - c) * t;
	
	date.setTime(date.getTime()+t);
	
	$('#added_year').val(date.getFullYear());
	$('#added_year').selectmenu("refresh");
	
	$('#added_month').val((date.getMonth()+1));
	$('#added_day').val(date.getDate());
}

function insert_year_options(select_id, y, m, d){
	
	var select = '';
	for(var j = 0; j < 10; j++){
		var o_y = parseInt($('#birth_year').val(),10);
		//var sel = (y==(o_y+j))?'selected="selected"':'';
		select += '<option value="'+(o_y+j)+'">'+(o_y+j)+'</option>';
	}
	
	$('#'+select_id+'_year').append($(select));
	
	$('#'+select_id+'_year').val(y);
	$('#'+select_id+'_year').selectmenu("refresh");
	
	$('#'+select_id+'_month').val(m);
	$('#'+select_id+'_day').val(d);
}

function update_year_select(id, onchange){
	
}

$(window).hashchange(function(){
	
	if(location.hash=='pet_vaccine'||location.hash=='#pet_vaccine'){
		
		if($('#add_basic_mark > div').length == 0){
		$.ajax({
			url:'vaccinationList.latte',
			data:{pid:$('#pid').val(),species:$('#species').val()},
			dataType:'text',
			success:function(response1,status,xhr){
				
				//alert(response1);
				
				var response = $.parseJSON(response1);
				
				// 접종 스케줄 개수 s_len = 0 스케줄 없음
				var s_len = response.s['BASIC_SET'].length;
				
				var y = 0;
				var m = 0;
				var d = 0;
				
				var date = new Date();
				
				//alert(response.v['BASIC']!=null?response.v['BASIC'][0].len:0);
				//alert(response.v['ANTIBODY']!=null?response.v['ANTIBODY'][0].len:0);
				//alert(response.v['ADDED']!=null?response.v['ADDED'][0].len:0);
				//alert(response.v['DIROFILARIA']!=null?response.v['DIROFILARIA'][0].len:0);
				
				if(s_len==0){
					
					$('#fisrt_title1').show();
					
					y = parseInt($('#birth_year').val(),10);
					m = parseInt($('#birth_month').val(),10);
					d = parseInt($('#birth_day').val(),10);
					date.setFullYear(y,parseInt(m,10)-1,parseInt(d,10));
					
					var select = '<select id="base_year" onchange="changeBaseDate();" data-icon="false" '+disabled+'>';
					for(var j = 0; j < 10; j++){
						var o_y = parseInt($('#birth_year').val(),10);
						var sel = (y==(o_y+j))?'selected="selected"':'';
						select += '<option value="'+(o_y+j)+'" '+sel+'>'+(o_y+j)+'</option>';
					}
					select += '</select>';
					
					var b_sel = '<select id="first_base" onchange="changeBaseDate();" data-icon="false" '+disabled+'>';
					for(var j = 0; j < response.v['BASIC'][0].len; j++){
						b_sel += '<option value="'+(j+1)+'">'+(j+1)+'차접종</option>';
					}
					b_sel += '</select>';
					
					$('#add_basic_mark').append($(
					'<div class="pet_ad00 mt10" id="basic'+i+'">\n'
						+'<span class="tt">기초접종</span>\n'
						+'<div class="btn_select04" style="width:100px; display:inline-block; vertical-align:middle;">\n'
							+'<a data-role="button" >'
							+b_sel
							+'</a>'
							+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
						+'</div>&nbsp;'
						+'<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">\n'
							+'<a data-role="button" >'
							+select
							+'</a>'
							+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
						+'</div> 년&nbsp;'
						+'<p class="input02" style="width:20px;"><input type="text" onchange="changeBaseDate();" id="base_month" value="'+m+'" '+disabled+'></p> 월&nbsp;'
						+'<p class="input02" style="width:20px;"><input type="text" onchange="changeBaseDate();" id="base_day" value="'+d+'" '+disabled+'></p> 일&nbsp;'
					+'</div>'));
				}
				//else{
					
				basic_len = response.v['BASIC'][0].len;
				basic_term = response.v['BASIC'][0].term;
				basic_term_type = response.v['BASIC'][0].term_type;
				
				antibody_term = response.v['ANTIBODY'][0].term;
				antibody_term_type = response.v['ANTIBODY'][0].term_type;
				
				added_term = response.v['ADDED'][0].term;
				added_term_type = response.v['ADDED'][0].term_type;
				
				dirofilaria_term = response.v['DIROFILARIA'][0].term;
				dirofilaria_term_type = response.v['DIROFILARIA'][0].term_type;
			
				for(var i=0; i < response.v['BASIC'][0].len;){
					
					if(i < s_len){
						var ymdhms = decodeURIComponent(response.s['BASIC_SET'][i].d).split('+');
						var ymd = ymdhms[0].split('-');
						date.setFullYear(ymd[0],parseInt(ymd[1],10)-1,parseInt(ymd[2],10));
						y = parseInt(ymd[0],10);
						m = parseInt(ymd[1],10);
						d = parseInt(ymd[2],10);
					}
					else{
						if(i==0){
							y = parseInt($('#birth_year').val(),10);
							m = parseInt($('#birth_month').val(),10);
							d = parseInt($('#birth_day').val(),10);
							date.setFullYear(y,parseInt(m,10)-1,parseInt(d,10));
						}
						else{
							var term_type = response.v['BASIC'][0].term_type;
							var term = parseInt(response.v['BASIC'][0].term,10);
							var t = (term_type=='DAY')?(term*86400000):(term_type=='WEEK')?(term*7*86400000):(term_type=='MONTH')?(term*30*86400000):(term_type=='YEAR')?(term*365*86400000):0;
							if(t==0){alert('에러');return;}
							date.setTime(date.getTime()+t);
							y = date.getFullYear();
							m = (date.getMonth()+1);
							d = date.getDate();
						}
					}
					
					var disabled = 'disabled="disabled"';
					
					var select = '<select id="base_year_'+i+'" data-icon="false" '+disabled+'>';
					for(var j = 0; j < 10; j++){
						var o_y = parseInt($('#birth_year').val(),10);
						var sel = (y==(o_y+j))?'selected="selected"':'';
						select += '<option value="'+(o_y+j)+'" '+sel+'>'+(o_y+j)+'</option>';
					}
					select += '</select>';
					
					$('#add_basic_mark').append($(
					'<div class="pet_ad00 mt10" id="basic'+i+'">\n'
						+'<span class="tt">'+(i+1)+"차접종"+'</span>\n'
						+'<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">\n'
							+'<a data-role="button" >'
							+select
							+'</a>'
							+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
						+'</div> 년&nbsp;'
						+'<p class="input02" style="width:20px;"><input type="text" id="base_month_'+i+'" value="'+m+'" '+disabled+'></p> 월&nbsp;'
						+'<p class="input02" style="width:20px;"><input type="text" id="base_day_'+i+'" value="'+d+'" '+disabled+'></p> 일&nbsp;'
					+'</div>'));
					
					if(s_len > 0){
						
					}
					
					i++;
				}
				
				$('#add_basic_mark').parent().trigger('create');
				
				if($('#antibody_year option').length==0){
					
					if(s_len > 0){
					
						var ymdhms = decodeURIComponent(response.s['BASIC_SET'][s_len-2].d).split('+');
						var ymd = ymdhms[0].split('-');
						date.setFullYear(ymd[0],parseInt(ymd[1],10)-1,parseInt(ymd[2],10));
						y = parseInt(ymd[0],10);
						m = parseInt(ymd[1],10);
						d = parseInt(ymd[2],10);
					}
					
					insert_year_options('antibody',y,m,d);
				}
					
				if($('#added_year option').length==0){
					
					if(s_len > 0){
					
						var ymdhms = decodeURIComponent(response.s['BASIC_SET'][s_len-1].d).split('+');
						var ymd = ymdhms[0].split('-');
						date.setFullYear(ymd[0],parseInt(ymd[1],10)-1,parseInt(ymd[2],10));
						y = parseInt(ymd[0],10);
						m = parseInt(ymd[1],10);
						d = parseInt(ymd[2],10);
					}
				
					insert_year_options('added',y,m,d);
				}
				
				var d_s_len = 0;
				if(response.s['DIROFILARIA'] != null){
					d_s_len = response.s['DIROFILARIA'].length;
				}
				
				if(d_s_len > 0){
					
					for(var sdi = 0; sdi < d_s_len; sdi++){
						
						var ymdhms = decodeURIComponent(response.s['DIROFILARIA'][sdi].d).split('+');
						var ymd = ymdhms[0].split('-');
						date.setFullYear(ymd[0],parseInt(ymd[1],10)-1,parseInt(ymd[2],10));
						y = parseInt(ymd[0],10);
						m = parseInt(ymd[1],10);
						d = parseInt(ymd[2],10);
						
						$('#dirofilaria_pre_area').append($(
								'<div class="pet_ad00 mt10">\n'
									+'<span class="tt">'+(sdi+1)+"차"+'</span>\n'
									+'<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">\n'
										+'<a data-role="button" >'
										+'<select data-icon="false" id="dirofilaria_pre'+sdi+'_year"></select>'
										+'</a>'
										+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
									+'</div> 년&nbsp;'
									+'<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_pre'+sdi+'_month" value="'+m+'" '+'></p> 월&nbsp;'
									+'<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_pre'+sdi+'_day" value="'+d+'" '+'></p> 일&nbsp;'
								+'</div>'));
						
						$('#dirofilaria_pre_area').trigger('create');
						
						insert_year_options('dirofilaria_pre'+sdi,y,m,d);
						
						dirofilaria_last_year = y;
						dirofilaria_last_month = m;
						dirofilaria_last_day = d;
					}
				}
				
				if(s_len==0){
					changeBaseDate();
				}
			},
			error:function(xhr,status,error){
				alert(xhr+"\n"+status+"\n"+error);
			}
		});
		}
		
		$('#fisrt_title1').hide();
		
		$('#pet_info').hide();
		$('#pet_vaccine').show();
		
		/* if($('#species').val()=='cat'){
			$('#dirofilaria_title').hide();
			$('#dirofilaria_body').hide();
		}
		else{
			$('#dirofilaria_title').show();
		} */
		if($('#species').val()=='cat'){
			//$('#dirofilaria_title').hide();
			$('#dirofilaria_body').hide();
			var label = $('#basic_title .ui-btn-text label').detach();
			$('#basic_title .ui-btn-text').html("고양이 기초 접종 일정 관리");
			$('#basic_title .ui-btn-text').append(label);
		}
		else{
			$('#dirofilaria_title').show();
			$('#dirofilaria_body').hide();
			var label = $('#basic_title .ui-btn-text label').detach();
			$('#basic_title .ui-btn-text').html("강아지 기초 접종 일정 관리");
			$('#basic_title .ui-btn-text').append(label);
		}
	}
	else{
		$('#pet_info').show();
		$('#pet_vaccine').hide();
	}
});


function addDirofilaria(){
	
	$('#dirofilaria_add_btn').hide();
	
	$('#dirofilaria_area').append($(
			'<div class="pet_ad00 mt10" id="dirofilaria">\n'
				+'<span class="tt">신규예약</span>\n'
				+'<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">\n'
					+'<a data-role="button" >'
					+'<select data-icon="false" id="dirofilaria_year"></select>'
					+'</a>'
					+'<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>'
				+'</div> 년&nbsp;'
				+'<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_month" value="'+m+'"></p> 월&nbsp;'
				+'<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_day" value="'+d+'"></p> 일&nbsp;'
			+'</div>'));
	
	var last_dirofilaria = new Date();
	
	last_dirofilaria.setFullYear(dirofilaria_last_year, dirofilaria_last_month-1, dirofilaria_last_day);
	
	last_dirofilaria.setTime(last_dirofilaria.getTime()+86400*1000*30);
			
	$('#dirofilaria_area').trigger('create');
	
	insert_year_options('dirofilaria', last_dirofilaria.getFullYear(), last_dirofilaria.getMonth()+1,last_dirofilaria.getDate());
}

</script>

</head>
<body>

	<div id="page" data-role="page">
	
		<jsp:include page="/include/client/INC_INSTANCE_DIALOG.jsp"/>
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="100%" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				<span id="pet_title"><c:if test="${params.type eq 'new'}">반려동물 등록</c:if>
				<c:if test="${params.type eq 'modify'}">반려동물 정보</c:if></span>
			</div>
			
			<div id="pet_info">
			
			<div class="a_type02" id="main_div">
			
				입력하신 정보에 따라 필요한 정보를 제공해 드립니다.
				
				<form name="form" method="post" action="petRegExecute.latte">
				<input type="hidden" id="pid" name="pid" value="${petInfo.s_pid}"/>
				<input id="species" name="species" type="hidden"/>
				<input id="breed" name="breed" type="hidden"/>
				<input id="gender" name="gender" type="hidden"/>
				<input id="birthday" name="birthday" type="hidden"/>
				<input id="neutralize" name="neutralize" type="hidden"/>
				
				<table class="edit_table01 mt20 select01">
					<colgroup>
						<col width="20%">
						<col width="*">
					</colgroup>
					<tr>
						<th>종류</th>
						<td class="btn_area01">
							<p class="rate50 btn_bar_gray btn_bar_shape02" id="dog_btn">
								<a data-role="button" onclick="selectSpecies('dog');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>&nbsp;강아지</span></a>
							</p>
							<p class="rate50 btn_bar_gray btn_bar_shape02" id="cat_btn">
								<a data-role="button" onclick="selectSpecies('cat');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>&nbsp;고양이</span></a>
							</p>
						</td>
					</tr>
					<tr>
						<th>품종</th>
						<td>
							<div id="dog_list">
								<select onchange="$('#breed').val($(this).val());">
									<!-- <option value="">선택해주세요.</option> -->
									<option value="none">- 선택 -</option>
									<c:forEach items="${dog_breed}" var="item">
									<option value="${item.s_key}" <c:if test="${petInfo.s_species eq 'DOG_SPECIES' and petInfo.s_breed eq item.s_key}">selected="selected"</c:if>>${item.s_value}</option>
									</c:forEach>
								</select>
							</div>
							<div id="cat_list">
								<select onchange="$('#breed').val($(this).val());">
									<!-- <option value="">선택해주세요.</option> -->
									<option value="none">- 선택 -</option>
									<c:forEach items="${cat_breed}" var="item">
									<option value="${item.s_key}" <c:if test="${petInfo.s_species eq 'CAT_SPECIES' and petInfo.s_breed eq item.s_key}">selected="selected"</c:if>>${item.s_value}</option>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th>성별</th>
						<td class="btn_area01">
							<p class="rate50 btn_bar_gray btn_bar_shape02" id="male_btn">
								<a data-role="button" onclick="selectGender('male');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>&nbsp;남아</span></a>
							</p>
							<p class="rate50 btn_bar_gray btn_bar_shape02" id="female_btn">
								<a data-role="button" onclick="selectGender('female');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>&nbsp;여아</span></a>
							</p>
						</td>
					</tr>
					<tr>
						<th>펫이름</th>
						<td>
							<div class="input01">
								<p class="inner_input"><input type="text" id="pet_name" name="pet_name" value="${petInfo.s_pet_name}" placeholder="펫이름을 입력하세요"></p>
							</div>
						</td>
					</tr>
					<c:set var="ymdhms" value="${fn:split(petInfo.d_birthday,' ')}"/>
					<c:set var="ymd" value="${fn:split(ymdhms[0],'-')}"/>
					<tr>
						<th>생일</th>
						<td class="btn_area01">
							<div class="rate25 nobtn_select">
							<select id="birth_year" onchange="selectMonth($('#birth_month').val(),1);">
								<c:forEach begin="0" end="${year_term}" varStatus="c">
								<option value="${cur_year-c.index}" <c:if test="${ymd[0] eq (cur_year-c.index)}">selected="selected"</c:if>>${cur_year-c.index}</option>
								</c:forEach>
							</select>
							</div>
							<div class="ratefree center_align">
								<span>년&nbsp;</span>
								<span class="aligner"></span>
							</div>
							<div class="rate18 nobtn_select">
								<select id="birth_month" onchange="selectMonth($(this).val(),1);">
									<c:forEach begin="1" end="12" varStatus="c">
									<option value="${c.index}" <c:if test="${ymd[1] eq (c.index)}">selected="selected"</c:if>>${c.index}</option>
									</c:forEach>
								</select>
							</div>
							<div class="ratefree center_align">
								<span>월&nbsp;</span>
								<span class="aligner"></span>
							</div>
							<div class="rate18 nobtn_select" id="birth_day_div">
								<select id="birth_day"></select>
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
							<p class="rate33 btn_bar_gray btn_bar_shape02" id="rsv_btn">
								<a data-role="button" onclick="selectNeutralize('rsv');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>예정</span></a>
							</p>
							<p class="rate33 btn_bar_gray btn_bar_shape02" id="done_btn">
								<a data-role="button" onclick="selectNeutralize('done');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>완료</span></a>
							</p>
							<p class="rate34 btn_bar_gray btn_bar_shape02" id="na_btn">
								<a data-role="button" onclick="selectNeutralize('na');"><img style="display:none;" src="${con.IMGPATH}/btn/btn_confirm02.png" alt="" height="20px"/><span>해당없음</span></a>
							</p>
						</td>
					</tr>
					<tr>
						<th>등록번호</th>
						<td>
							<div class="input01">
								<p class="inner_input"><input type="text" name="reg_number" value="${petInfo.s_reg_number}" placeholder="등록번호"></p>
							</div>
						</td>
					</tr>
				</table>
				
				</form>
				
				<p class="btn_bar_black btn_bar_shape01">
					<a data-role="button" onclick="location.hash='pet_vaccine';" id="ddd"><span>기초 접종 및 치료 일정 관리</span></a>
				</p>
				
				<p class="btn_bar_red btn_bar_shape01 mt15" id="new_btn_area" style="<c:if test="${params.type ne 'new'}">display:none;</c:if>">
					<a data-role="button" id="reg_btn"><span>등록</span></a>
				</p>
				
				<div class="btn_area02 mt08" id="modify_btn_area" style="<c:if test="${params.type ne 'modify'}">display:none;</c:if>">
					<div class="l_30">
						<p class="btn_bar_black btn_bar_shape01">
							<a data-role="button" id="del_btn"><span>삭제</span></a>
						</p>
					</div>
					<div class="r_70">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" id="modify_btn"><span>수정</span></a>
						</p>
					</div>
				</div>
			</div>
			
			<%-- <div class="a_type02" id="vaccine_div" style="display:none;">
			
				<p>강아지 기초 접종 일정 관리</p>
				<div class="btn_area02 mt08" id="modify_btn_area" style="<c:if test="${params.type ne 'modify'}">display:none;</c:if>">
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
			</div> --%>
			
			</div>
			
			<div id="pet_vaccine">
				<div class="pet_edit">
				<ul>
					<li class="btn" id="basic_title"><a onclick="toggleBasic();" data-role="button">강아지 기초 접종 일정 관리<label class="bu"><img id="close_btn" src="${con.IMGPATH}/btn/btn_arrow_t.png" width="24" height="24"/><img id="open_btn" src="${con.IMGPATH}/btn/btn_arrow_b.png" width="24" height="24"/></label></a></li>
					<li class="cont" id="basic_body">
						<p class="txt_gray11">※접종 일정을 선택하시면 자동으로 다음 일정이 예측되어 표시되며, 등록된 일정에 따라 스케줄에 자동 등록됩니다.</p>
						<!-- <p class="txt_gray11 mt10">※강아지 기초 접종 주기는 2주 간격입니다.</p> -->
						<p class="txt_gray11 mt10" id="fisrt_title1">※마지막 접종 날짜 또는 접종 예정일을 선택하세요.</p>
						
						<div id="basic_setting"></div>
						
						<div id="add_basic_mark"></div>
						
						<p class="txt_gray11 mt20">※항체가검사는 기초 접종완료 후 2주입니다.</p>
						<div class="pet_ad00 mt10">
							<span class="tt">항체가검사</span>
							<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">
								<a data-role="button" >
								<select data-icon="false" id="antibody_year"></select>
								</a>
								<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
							</div> 년
							<p class="input02" style="width:20px;"><input type="text" id="antibody_month" value="8"></p> 월
							<p class="input02" style="width:20px;"><input type="text" id="antibody_day" value="20"></p> 일
						</div>
						
						<p class="txt_gray11 mt20">※추가 접종 주기는 기초 접종완료 후 1년입니다.</p>
						<div class="pet_ad00 mt10">
							<span class="tt">추가접종</span>
							<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">
								<a data-role="button" >
								<select data-icon="false" id="added_year"></select>
								</a>
								<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
							</div> 년
							<p class="input02" style="width:20px;"><input type="text" id="added_month" value="8"></p> 월
							<p class="input02" style="width:20px;"><input type="text" id="added_day" value="20"></p> 일
						</div>
					</li>
					
					<li class="btn" id="dirofilaria_title"><a onclick="toggleDirofilaria();" data-role="button">심장 사상충 예방 접종 일정 관리<label class="bu"><img id="close_btn" src="${con.IMGPATH}/btn/btn_arrow_t.png" width="24" height="24"/><img id="open_btn" src="${con.IMGPATH}/btn/btn_arrow_b.png" width="24" height="24"/></label></a></li>
					<li class="cont" id="dirofilaria_body">
						<%-- <div class="pet_ad00">
							<span class="tt">마지막</span>
							<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">
								<a data-role="button" >
								<select data-icon="false" id="dirofilaria_pre_year"></select>
								</a>
								<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
							</div> 년
							<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_pre_month" value="8"></p> 월
							<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_pre_day" value="20"></p> 일
						</div> --%>
						<div id="dirofilaria_pre_area"></div>
						<%-- <div class="pet_ad00">
							<span class="tt">예정일</span>
							<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">
								<a data-role="button" >
								<select data-icon="false" id="dirofilaria_year"></select>
								</a>
								<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
							</div> 년
							<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_month" value="8"></p> 월
							<p class="input02" style="width:20px;"><input type="text" id="dirofilaria_day" value="20"></p> 일
						</div> --%>
						<p class="txt_gray11 mt10">※접종 주기는 한 달입니다.</p>
						<div id="dirofilaria_area"></div>
						<p class="btn_gray02 mt10" id="dirofilaria_add_btn" style="width:160px;"><a onclick="addDirofilaria();" data-role="button">일정 추가 하기</a></p>
					</li>
					
					<%-- <li class="btn" id="other_title"><a onclick="toggleOther();" data-role="button">기타 접종 및 치료<label class="bu"><img id="close_btn" src="${con.IMGPATH}/btn/btn_arrow_t.png" width="24" height="24"/><img id="open_btn" src="${con.IMGPATH}/btn/btn_arrow_b.png" width="24" height="24"/></label></a></li>
					<li class="cont" id="other_body">
						<p class="input01"><input type="text" placeholder="접종 또는 치료내역을 작성 해 주세요."></p>
						<div class="pet_ad00 mt10">
							<div class="btn_select04" style="width:80px; display:inline-block; vertical-align:middle;">
								<a data-role="button" >
								<select data-icon="false">
									<option value="">2014</option>
									<option value="">2015</option>
									<option value="">2016</option>
								</select>
								</a>
								<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
							</div> 년
							<p class="input02" style="width:20px;"><input type="text" value="8"></p> 월
							<p class="input02" style="width:20px;"><input type="text" value="20"></p> 일
							<p class="btn_admin01" style=" display:inline-block; vertical-align:middle; margin-top:-5px;"><a href="index.html" data-role="button"><img src="${con.IMGPATH}/btn/btn_d.png" alt="" width="31" height="31" /></a></p>
						</div>
						<p class="btn_gray02 mt10" style="width:160px;"><a href="#" data-role="button">일정 추가 하기</a></p>
					</li> --%>
				</ul>
			</div>
			
			<div class="btn_area03">
				<p class="btn_red02"><a onclick="history.back();" data-role="button">확인</a></p>
			</div>
		
		</div>
			
			
		</div>
		<!-- contents 끝 -->
		
		<jsp:include page="../include/mypage_footer.jsp"/>
		
	</div>
	
	<script>
	
	$('#cat_list').hide();
	
	$('#reg_btn').on('click',function(){
		register();
	});
	$('#modify_btn').on('click',function(){
		register();
	});
	$('#del_btn').on('click',function(){
		removePet();
	});
	
	var m = parseInt("${ymd[1]}",10);
	var d = parseInt("${ymd[2]}",10);
	if(isNaN(m)){m=getThisMonth();}
	if(isNaN(d)){d=getToday();}
	
	selectMonth(m,d);
	$('select[id=birth_month] option[value='+m+']').attr('selected',true);
	
	setInputConstraint('lengthLimit','pet_name',10);
	
	</script>
	
	<script>
	if(parseBool("${petInfo.s_species eq 'DOG_SPECIES'}")){
		selectSpecies('dog');
	}
	else if(parseBool("${petInfo.s_species eq 'CAT_SPECIES'}")){
		selectSpecies('cat');
	}
	<c:if test="${petInfo.s_gender eq 'M'}">
	selectGender('male');
	</c:if>
	<c:if test="${petInfo.s_gender eq 'F'}">
	selectGender('female');
	</c:if>
	<c:if test="${petInfo.s_neutralize eq 'R'}">
	selectNeutralize('rsv');
	</c:if>
	<c:if test="${petInfo.s_neutralize eq 'Y'}">
	selectNeutralize('done');
	</c:if>
	<c:if test="${petInfo.s_neutralize eq 'N'}">
	selectNeutralize('na');
	</c:if>
	</script>

</body>
</html>