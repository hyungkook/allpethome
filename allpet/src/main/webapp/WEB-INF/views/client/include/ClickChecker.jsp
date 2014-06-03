<script>
//var cc = new ClickChecker($('#home'),isMobileDevice(),function(e,data){},123);
var ClickChecker = function($object,isMobile,fun,data){
	
	var _this = this;
	
	this.total_y = 0;
	this.viewport_y = 0;
	
	this.fun = fun;
	this.data = data;
	
	this.pts={
		tx:0,
		ty:0,
		vx:0,
		vy:0
	};
	
	this.clickStart = function (e){
		
		try{
			_this.total_y = e.pageY;
			_this.viewport_y = e.clientY;
			
			if(typeof _this.fun==='function')
				_this.fun(e,_this.data);
		}catch(e){}
	};

	this.touchstart = function (e){
		
		try{
			var oe = e.originalEvent;
			var tou = null;
			if(oe != null){
				tou = oe.touches;
				if(tou != null)
					tou = tou[0];
			}
			if(oe != null && tou == null){
				tou = oe.targetToches;
				if(tou != null)
					tou = tou[0];
			}
			if(oe != null && tou == null){
				tou = oe.changedTouches;
				if(tou != null)
					tou = tou[0];
			}
			_this.total_y = tou!=null?tou.pageY:null;
			_this.viewport_y = tou!=null?tou.screenY:null;
			
			if(typeof _this.fun==='function')
				_this.fun(e,_this.data);
		}catch(e){}
	};
	
	if(isMobileDevice())
		$object.on("touchstart", function(e){_this.touchstart(e);});
	else
		$object.on("mousedown", function(e){_this.clickStart(e);});
	
	this.getTotalY=function(){return _this.total_y;};
	this.getViewportY=function(){return _this.viewport_y;};
};
</script>