<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script>

function SlideMenu(menuCount){
	
	var existMenuPositionCookie = true;
	var menuPosition = $.cookie('menuPosition');
	
	if(menuPosition==null){	menuPosition = 1;existMenuPositionCookie=false;}
	else{$.removeCookie('menuPosition');}
	
	var movingDistance = 0;//parseFloat('${100.0 / fn:length(menuList)}');
	//var menuCount = parseInt('${fn:length(menuList)}');
	
	(function(){
		
		if(isMobileDevice()){
			$('#list').bind("touchstart", function(e){touchstart(e);});
			$('#list').bind("touchmove", function(e){e.preventDefault();});
			$('#list').bind("touchend", function(e){touchend(e);});
		}
		else{
			$('#list').bind("mousedown", function(e){touchstart(e);});
			$('#list').bind("mouseup", function(e){touchend(e);});
		}
		
		$('#right_btn').on('click',function(){moveRight();});
		$('#left_btn').on('click',function(){moveLeft();});
		
//		movingDistance = parseInt($('#center').width()*parseInt(100.0 / menuCount, 10)/100.0,10);
		movingDistance = Math.floor(p_acc*(100.0 / menuCount) /100.0);
		//alert($('#center').width()+'   '+p_acc+','+menuCount+','+movingDistance);
		
		if(existMenuPositionCookie){savedLock();}
		else{centerLock();};

		validateBtn();
	}());

	function centerLock(){//가운데고정//
		
		var seq = parseInt('${boardInfo.sequence}')-2;
		var len = parseInt('${fn:length(menuList)}');
		if(seq<0) seq=0;
		if(seq>len-3) seq=len-3;
		$('#center').css('margin-left',(movingDistance*-seq)+10);//+'%');
	}

	function savedLock(){//마지막누른위치//
		
		var seq = -(parseInt(menuPosition)+1-2);
		$('#center').css('margin-left',(movingDistance*seq)+10);//+'%');
	}

	var isMoving = false;

	function moveRight(){
		
		if(isMoving)
			return;
		
		var ml = parseInt($('#center').css('margin-left'));

		if(ml > -1)
			return;
		
		isMoving = true;
		
		$('#center').animate({
			'margin-left':'+='+movingDistance//+'%'
		},'fast',function(){

			validateBtn();
			menuPosition--;
			
			isMoving = false;
		});
	}

	function moveLeft(){
		
		if(isMoving)
			return;
		
		var ml = parseInt($('#center').css('margin-left'));
		var ll = -((menuCount-1-2) * movingDistance-1)+10;
		
		if(ml < ll)
			return;
		isMoving = true;
		//alert(movingDistance);
		
		$('#center').animate({
			'margin-left':'-='+movingDistance
		},'fast',function(){

			validateBtn();
			menuPosition++;
			
			isMoving = false;
			
			//alert($('#center').css('margin-left'));
		});
	}

	function validateBtn(){
		
		var ml = parseInt($('#center').css('margin-left'));
		var ll = -((menuCount-1-2) * movingDistance-1)+10;

		if(ml < ll){$('#left_btn').hide();
		}else{$('#left_btn').show();}
		
		if(ml > -1){$('#right_btn').hide();
		}else{$('#right_btn').show();}
	}

	var start_x = 0;
	var move_x = 0;

	function touchstart(e){
		
		try{
			start_x = e.pageX || e.originalEvent.touches[0].pageX || e.originalEvent.changedTouches[0];
		}catch(e){}
	}

	function touchend(e){
		
		try{
			var _x = e.pageX || e.originalEvent.changedTouches[0].pageX || e.originalEvent.changedTouches[0];
			move_x = _x - start_x;
			
			if(move_x > -5 && move_x < 5)
				;
			else if(move_x < 0){
				moveLeft();
			}else{
				moveRight();
			};
		}catch(e){}
	}

	this.goMenuLink = function(url){
		
		// 임계값
		if(move_x < 5 && move_x > -5){
			$.cookie('menuPosition', menuPosition, {expires:1});
			goPage(url);
		}
	};
};

</script>