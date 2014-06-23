<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<!DOCTYPE html>
<html lang="ko">
<head>
<title>회원가입</title>	
	 	<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/> 
		
		<script>
		
		var nickChk = 0;
		
		$(document).ready(function($) {
			$('#pop_downbox').attr("style", "display:none");
		});
		
		function onPopDropdown() {
			
			if ($('#pop_downbox').css('display') == 'none') {
				$('#pop_downbox').attr("style", "display:block");
			} else {
				$('#pop_downbox').attr("style", "display:none");
			}
			
		}
		
		function onButtonSelect(id, nm) {
			
			$('#popSel').html(nm);
			$('#pop_downbox').attr("style", "display:none");
			
			if (id == 'pop1') $('#s_recom_type').val('1');
			if (id == 'pop2') $('#s_recom_type').val('2');
			if (id == 'pop3') $('#s_recom_type').val('3');
			
			
		}
		
		function goDuplication() {
			
			var nick = $('#s_nickname').val();
			
			if (nick == "") {
				alert("닉네임을 입력해주세요.");
				return;
			}
			
			var pattern =  /[^(가-힣a-zA-Z0-9)]/;
			var patternSpace =  /\s/g;
			
			if (patternSpace.test(nick)) { 
			    alert("닉네임에 공백을 포함할 수 없습니다"); 
			    return;
			}

			if (pattern.test(nick)) { 
			    alert("닉네임에 완성된 한글과 알파벳, 숫자만 사용할 수 있습니다"); 
			    return;
			}
			
			if (nick.length < 2 || nick.length > 11) {
				alert("닉네임을 2자이상 10자 이하로 작성해 주세요");
				return;
			}
			
			if (nick == "라떼스타일" || nick == "lattestyle" || nick == "LatteStyle" || nick == "LATTESTYLE"){
				alert("사용할수 없는 닉네임 입니다.");
				return;
			}
			
			nickChk = 0;
			jQuery.ajax({
				type:"POST",
				url:"ajaxNickCheck.latte",
				data:({nick : nick}),
				
				success:function(msg){

					if(msg == "0000") {
						nickChk = 1;
						alert("사용 가능한 닉네임입니다.");
						$("input[name=s_nickname]").attr("readonly",true);
						return;
					}
					
					if(msg == "1000") {
						nickChk = 0;
						alert("이미 사용중인 닉네임입니다. 다시 시도해주세요.");
						return;
					}
					
					if(msg == "2000") {
						nickChk = 0;
						alert("사용하실 수 없는 닉네임입니다.");
						return;
					}
					
				}, error: function(xhr,status,error){
					alert(error);
				}
			}); 	
		}
		
		function goRecom() {
			
			var recom = $('#s_recommender').val();
			
			if(recom == ""){
				return true;
			}
			
			var recom_type = $('#s_recom_type').val();
			
			
			jQuery.ajax({
				type:"POST",
				url:"ajaxRecomCheck.latte",
				async:false,
				data:{
						type : recom_type,
						recom : recom
					},
				
				success:function(msg_recom) {
					
					
					if(msg_recom == "0000") {
						$('#s_recom_result').val('Y');
					}
					
					if(msg_recom == "1000") {
						$('#s_recom_result').val('N');
					}
					
				}, error: function(xhr,status,error){
					alert(error);
				}
			});
		}
		
		function goStep4() {
			
			var nm = $('#s_name').val();
			if (!nm) {
				alert("이름(실명)을 입력해주세요.");
				return;
			}
			
			var pattern =  /[^(가-힣a-zA-Z)]/;
			var patternSpace =  /\s/g;
			
			if (patternSpace.test(nm)) { 
			    alert("이름에 공백을 포함할 수 없습니다"); 
			    return;
			}
			
			if (pattern.test(nm)) { 
			    alert("이름에 완성된 한글과 알파벳만 사용할 수 있습니다"); 
			    return;
			}
			
			if (nm.length < 2 || nm.length > 11){
				alert("이름을 2자이상 10자 이하로 작성해 주세요");
				return;
			}
			
			if ($('#s_nickname').val() == '') {
				alert("닉네임(별명)을 입력해주세요.");
				return;
			}

			if (nickChk == 0) {
				alert("닉네임 중복확인을 해주세요.");
				return;
			}

			if ($('#s_recommender').val() != '' && $('#s_recom_type').val() == '0') {
				alert("추천인 방식을 선택해주세요.");
				return;
			}
			
			if ($('#s_recommender').val() != '' && $('#s_recom_type').val() != '0') {
				
				goRecom();
				
				if ($('#s_recom_result').val() == 'N') {
					alert('추천인 정보가 없습니다.');
					return;
				}
			}
			
			document.getElementById("form").action = "joinStep.latte?step=4";
			document.getElementById("form").submit();
			
		}
		
		</script>
</head>

<body>
<div data-role="page" style="background:#f7f3f4;">
	
	<c:if test="${empty appType}" >
    <!-- header 시작-->
    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>회원가입</h1>
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
    </div>
    <!-- ///// header 끝-->
    </c:if>
    
    <!-- content 시작-->
  	<form id="form" name="form" method="post">
  	<input type="hidden" id="s_recom_type" name="s_recom_type" value="0"/>
  	<input type="hidden" id="s_recom_result" name="s_recom_result" value="N"/>
	<div data-role="content" id="contents">
    	
        <div><img src="${con.IMGPATH}/common/step03.png" width="100%"/></div>
        
        <div class="st01">
            <h3>이름 (사용자실명)</h3>
            <p class="input_type01 mt05"><input type="text" id="s_name" name="s_name" placeholder="ex) 홍길동"></p>
            <p class="txt_type02 mt10">고객님의 이름은 서비스 이용 시 필요한 정보입니다.</p>
            
            <h3>닉네임 (별명)</h3>
            <table class="mt05">
            	<colgroup><col width="70%" /><col width="30%" /></colgroup>
            	<tr>
                	<td style="padding-right:4px;"><p class="input_type01"><input type="text" id="s_nickname" name="s_nickname" placeholder="00000000000"></p></td>
                    <td><p class="btn_type01"><a onclick="goDuplication();" data-role="button">중복확인</a></p></td>
                </tr>
            </table>
            <p class="txt_type02 mt10">각종 커뮤니티에 사용되는 정보입니다.</p>
            
            <h3>추천인</h3>
            <table class="mt05">
            	<colgroup><col width="35%" /><col width="65%" /></colgroup>
            	<tr>
                	<td>
                    <div class="btn_type01" style="position:relative;">
                    	<a id="layer_drop" href="javascript:onPopDropdown();" data-role="button"><span id="popSel">선택</span> <img src="${con.IMGPATH}/common/icon_arrow_b03.png" alt="shop" width="10" height="7"/></a>
                        
                        <!-- 레이어 박스-->
                        <div class="pop_downbox" id="pop_downbox">
                        	<ul>
                                <li class="btn_list01"><a onclick="onButtonSelect(this.id, '닉네임');" id="pop1" data-role="button">닉네임</a></li>
                            	<li class="btn_list01"><a onclick="onButtonSelect(this.id, '휴대폰번호');" id="pop2" data-role="button">휴대폰번호</a></li>
                                <li class="btn_list01"><a onclick="onButtonSelect(this.id, '이메일');" id="pop3" data-role="button">이메일</a></li>
                            </ul>
                        </div>
                        <!-- //레이어 박스 끝-->
                        
                    </div>
                    </td>
                    <td style="padding-left:4px;">
                    	<c:if test="${not empty event_friend_name}">
                    	<script>
                    		onButtonSelect('pop1', '닉네임');
                    		document.getElementById('layer_drop').href="javascript:alert('추천인을 변경하실 수 없습니다.');";
                    	</script>
                    	<p class="input_type01"><input type="text" id="s_recommender" name="s_recommender" readonly="readonly" value="${event_friend_name}" placeholder="00000000000"></p>
                    	</c:if>
                    	<c:if test="${empty event_friend_name}">
                    	<p class="input_type01"><input type="text" id="s_recommender" name="s_recommender" placeholder="00000000000"></p>
                    	</c:if>
                    </td>
                </tr>
            </table>
            <p class="txt_type02 mt10">추천인이 없는 경우 입력하시지 않으셔도 됩니다.</p>
            
            <p class="btn_type02 mt30"><a onclick="goStep4();"  data-role="button">다음</a></p>
        </div>
        <div style="font-size:12px; padding-top:100px; height:50px;">&nbsp;</div>
        
    </div>
    </form>
    <!-- ///// content 끝-->
    
    <!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> 
    <!-- ///// footer 끝-->

</div>
</body>
</html>