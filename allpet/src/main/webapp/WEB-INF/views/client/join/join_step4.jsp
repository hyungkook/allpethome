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
			function goGenderSelect(typ) {
				
				var cImg = "<img src='${con.IMGPATH}/common/icon_check.png' width='18' height='18' />";
				
				if (typ == 'M') {
					$('#chk_gen_m').html(cImg);
					$('#chk_gen_f').html('');
					
					$('#s_gender').val('M');
				} else {
					$('#chk_gen_m').html('');
					$('#chk_gen_f').html(cImg);
					
					$('#s_gender').val('F');
				}
			}
			
			function getSelectLocationList() {
				
				var url="locationInfo.latte?type=init";
				
				$("#searchFrame").attr("src", url);
				$("#searchDiv").css("display","block");
				$("#wrap").css("display","none");
				
			}
			
			function closeSearchDiv(){
				
				$("#searchDiv").css("display","none");
				$("#wrap").css("display","block");
			}
		
			function getDocHeight(doc) {
			  var docHt = 0, sh, oh;
			  if (doc.height){
			    docHt = doc.height;
			  } else if (doc.body) {
			    if (doc.body.scrollHeight) docHt = sh = doc.body.scrollHeight;
			    if (doc.body.offsetHeight) docHt = oh = doc.body.offsetHeight;
			    if (sh && oh) docHt = Math.max(sh, oh);
			  }
			  return docHt;
			}
			
			function iframe_autoresize() {
				
				var arg = document.getElementById('searchFrame');
				var iframeWin = window.frames['searchFrame'];
			    arg.height = 0;
				var docHt = getDocHeight(iframeWin.document);
			    try{
			    	arg.height = (arg.document.body.scrollHeight);//IE에서만 먹힌다
			    }catch(e){
			   		arg.height = docHt;
			    };
			    
			}
			
			function setDate() {
				 
				  var current;
				  var year = document.getElementById("s_birth_year").value;
				  var month = document.getElementById("s_birth_month").value;;
				  var day = document.getElementById("s_birth_day").value;;
				  var days, i, j;
				  current = new Date();
				  days = new Date(new Date(year, month, 1)-86400000).getDate();
				  
				  document.getElementById("s_birth_day").length = 0;
				  for (i=0, j; i < days; i++) { 
				    j = (i < 9) ? '0'+(i+1) : i+1;
				    document.getElementById("s_birth_day").options[i+1] = new Option(j, j);
				  }
				  
				  document.getElementById("s_birth_day").options[0] = new Option("일", "");
				  //document.getElementById("s_birth_year").value = year;
				 
			}
			
			function goStep5(){
				
				if(document.getElementById("s_birth_year").value == ""){
					alert("생년월일의 연도를 선택해 주세요");
					return;
				}
				
				if(document.getElementById("s_birth_month").value == ""){
					alert("생년월일의 월을 선택해 주세요");
					return;
				}
				
				if(document.getElementById("s_birth_day").value == ""){
					alert("생년월일의 일을 선택해 주세요");
					return;
				}
				
				if(document.getElementById("s_do").value == "" 
						|| document.getElementById("s_sigu").value == "" 
						|| document.getElementById("s_dong").value == ""){
					alert("거주지역을 선택해 주세요");
					return;
				}
				
				document.getElementById("form").action = "joinStep.latte?step=5";
				document.getElementById("form").submit();
			}
		</script>
</head>

<body>
<div class="pop_area" id="searchDiv" style="display : none; margin: 0; padding: 0;">
	<iframe id="searchFrame" name="searchFrame" style="position: relative; width: 100%;  margin: 0; padding: 0; border: 0; overflow-y: auto;" onload="iframe_autoresize()"></iframe>
</div>



<div data-role="page" id="wrap" style="background:#f7f3f4;">
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
    	<input type="hidden" name="s_location" id="s_location"/>
	    <input type="hidden" name="s_do" id="s_do"/>
	    <input type="hidden" name="s_sigu" id="s_sigu"/>
	    <input type="hidden" name="s_dong" id="s_dong"/>
    	<input type="hidden" id="s_gender" name="s_gender" value="M"/>
    	
	<div data-role="content" id="contents">
    	
        <div><img src="${con.IMGPATH}/common/step04.png" width="100%"/></div>
        
        <div class="st01">

            <p class="txt_type02 mt30">부가정보는 보다 정확한 정보제공에 이용됩니다.</p>
            <table class="mt20">
            	<colgroup><col width="50%" /><col width="50%" /></colgroup>
            	<tr>
                	<td style="padding-right:2px;">
                    <div class="btn_type01" style="position:relative;">
                    	<a onclick="goGenderSelect('M');" data-role="button">남성</a>
                        <p class="btn_check" id="chk_gen_m"><img src="${con.IMGPATH}/common/icon_check.png" width="18" height="18" /></p>
                    </div>
                    </td>
                    <td style="padding-left:2px;">
                    <div class="btn_type01" style="position:relative;">
                    	<a onclick="goGenderSelect('F');" data-role="button">여성</a>
                    	<p class="btn_check" id="chk_gen_f"></p>
                        <!-- 체크 
                        <p style="position:absolute; top:11px; left:50%; margin-left:-36px;"><img src="/images/common/icon_check.png" width="18" height="18" /></p>
                        -->
                    </div>
                    </td>
                </tr>
            </table>
            <!-- <p class="btn_type01 mt10"><a href="index.html" data-role="button">생년월일 선택</a></p>  -->
            <h3>생년월일</h3>
             <table class="mt05">
            	<col width="32%" /><col width="32%" /><col width="32%" />
            	<tr>
                	<td>
                    <div class="btn_type01" style="position:relative;">
                    	<select name="s_birth_year" id="s_birth_year" class="select_type01" style="width:98%;" onchange="setDate();">
			            	<option value="">연도</option>
			            	<c:forEach var="list" begin="1900" end="${toYear }"  varStatus="c">
			            		<option value="${toYear - (c.count -1) }">${toYear - (c.count -1) }</option>
			            	</c:forEach>
			            </select>
                    </div>
                    </td>
                    <td style="padding-left:4px;">
                    <div class="btn_type01" style="position:relative;">
                    	 <select name="s_birth_month" id="s_birth_month"  class="select_type01" style="width:98%;" onchange="setDate();">
			            	<option value="">월</option>
			            	<c:forEach var="list" begin="1" end="12"  varStatus="c">
			            		<option value="${list }">${list }</option>
			            	</c:forEach>
			            </select>
			        </div>
                    </td>
                    <td style="padding-left:4px;">
                     <div class="btn_type01" style="position:relative;">
	                    <select name="s_birth_day" id="s_birth_day"  class="select_type01" style="width:98%;">
			            	<option value="">일</option>
			                <c:forEach var="list" begin="1" end="31"  varStatus="c">
			            		<option value="${list }">${list }</option>
			            	</c:forEach>
			            </select>
                   	</div>
                    </td>
                </tr>
            </table>
            
            <p class="btn_type01 mt10"><a onclick="getSelectLocationList();" data-role="button"><span id="locationView">거주지역 선택</span></a></p>
            <p class="btn_type02 mt30"><a onclick="goStep5();" data-role="button">다음</a></p>
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