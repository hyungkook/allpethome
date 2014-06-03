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
		data:$(form).serialize(),
		dataType:'json',
		success:function(response,status,xhr){
			
			$.mobile.hidePageLoadingMsg();
			
			allowReg = true;
			
			if(response.resultCode=='${codes.SUCCESS_CODE}'){
				
				showDialog('저장되었습니다.','default',function(){
					
					goPage('myPageHome.latte');
				});
				
				$('#pid').val(response.pid);
				$('#pet_title').html('반려동물 정보');
				$('#new_btn_area').hide();
				$('#modify_btn_area').show();
			}
			else if(response.resultCode=='${codes.ERROR_UNAUTHORIZED}'){
				
				goPage('myPageHome.latte');
			}
			else
				alert('데이터 입력을 실패하였습니다. code:'+response.resultCode);
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
					<a data-role="button" onclick="$('#main_div').hide();$('#vaccine_div').show();"><span>기초 접종 및 치료 일정 관리</span></a>
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
			
			<div class="a_type02" id="vaccine_div" style="display:none;">
			
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