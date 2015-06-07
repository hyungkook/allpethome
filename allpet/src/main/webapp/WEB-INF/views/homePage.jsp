<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>올펫 홈페이지</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
    <script src="js/jquery-1.6.4.js"></script>    
	<script src="js/jquery.event.drag-1.5.min.js"></script>
    <script src="js/jquery.touchSlider.js"></script>


<script>
	$(document).ready(function(){
		$("#touchSlider").touchSlider({
			 flexible : true,
			 roll : true,
			 speed : 300,
			 btn_prev : $(".btn_prev"),
   			 btn_next : $(".btn_next"),
			 counter : function (e) {
			 	// current = parseInt(e.current);
			}
		});
		
		bannerInterval = setInterval(function(){ topBannerCount(); }, 3000);
	
		
		function topBannerCount() {
	
			$('#next_banner').trigger("click");
	   }
   
	});
	
	
	
	
</script>
    
    
</head>

<body>
<div id="wrap">
    
    
	<!------------------------------------------------------------------------------ head 영역 시작 ------------------------------------------------------------------------------>
    <div id="section00">
		<div class="top"><a href="mailTo:partner@allpethome.co.kr "><img src="images/btn_top.png" alt="" /></a></div>
    </div>
    <!------------------------------------------------------------------------------ // head 영역 끝 ------------------------------------------------------------------------------>
    
    
    
    <!------------------------------------------------------------------------------ 1번 영역 시작 ------------------------------------------------------------------------------>
    <div id="section01">
		<p class="c01"><img src="images/cont01.jpg" alt="" /></p>
    </div>
    <!------------------------------------------------------------------------------ //1번 영역 끝 ------------------------------------------------------------------------------>
    
    <!------------------------------------------------------------------------------ 2번 영역 시작 ------------------------------------------------------------------------------>
    <div id="section02">
		<p class="c01"><img src="images/cont02.jpg" alt="" /></p>

        <div class="c02">
        	<p class="t01"><img src="images/cont03.jpg" alt="" /></p>
            
            <!-- 버튼 시작-->
            <div class="btn_area" style="display:none;">
                 <button type="button" class="btn_prev">prev</button>
                 <button type="button" class="btn_next" id="next_banner">next</button>
            </div>
            <!-- 버튼 끝-->
            <!-- 롤링 시작-->
            <div class="roll_bg"><!-- 핸드폰 이미지-->
                <div class="roll" id="touchSlider" style="width:253px; margin:0; overflow:hidden; position:relative;">
                    <ul>
                        <li><img src="images/roll_img01.jpg" alt="" /></li>
                        <li><img src="images/roll_img02.jpg" alt="" /></li>
                        <li><img src="images/roll_img03.jpg" alt="" /></li>
                        <li><img src="images/roll_img04.jpg" alt="" /></li>
                        <li><img src="images/roll_img05.jpg" alt="" /></li>
                    </ul>
                </div>
            </div>
            <!-- 롤링 끝-->
            
        </div>
    </div>
    <!------------------------------------------------------------------------------ //2번 영역 끝 ------------------------------------------------------------------------------>
    
    <!------------------------------------------------------------------------------ 3번 영역 시작 ------------------------------------------------------------------------------>
    <div id="section03">
		<div class="c01">
        	<p class="t01"><img src="images/cont04.jpg" alt="" /></p>
            <p class="btn01"><a href="mailTo:partner@allpethome.co.kr"><img src="images/btn_b01.gif" alt="" /></a></p>
        </div>
    </div>
    <!------------------------------------------------------------------------------ //3번 영역 끝 ------------------------------------------------------------------------------>
    
    <!------------------------------------------------------------------------------ footer 시작 ------------------------------------------------------------------------------>
    <div id="footer">
		<div class="c01">
        	<p class="f_logo"><img src="images/footer_logo.gif" alt="" /></p>
        	<p class="t01">제휴 및 광고문의</p>
            <p class="t02">
            상호 : 올펫&nbsp;&nbsp;&nbsp;    주소 : 서울특별시 강남구 강남대로 94길 27-11 삼정빌딩 4층 (주)올펫<br />
            사업자등록번호 : 220-88-66318&nbsp;&nbsp;&nbsp;    전화번호 : 1666-1609 &nbsp;&nbsp;&nbsp;  팩스번호 : 02-6959-1996 &nbsp;&nbsp;&nbsp;   이메일 : info@allpethome.co.kr<br />
            대표자 : 성준석&nbsp;&nbsp;&nbsp;     개인정보 보호 관리자 : 허지원
            </p>
            <p class="t03">Copyright ⓒ ALL PET Inc. All rights Reserved.</p>
        </div>
    </div>
    <!------------------------------------------------------------------------------ //footer 끝 ------------------------------------------------------------------------------>
    
    
    
    
    
</div>
</body>
</html>