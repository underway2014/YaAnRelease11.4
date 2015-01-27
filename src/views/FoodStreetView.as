package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	
	import models.AtlaMd;
	import models.FoodStreetMd;
	import models.YAConst;
	
	
	public class FoodStreetView extends Sprite
	{
		private var modeArray:Array;
		private var SELF_WIDHT:int = 1000 + 14;
		private var SELF_HEIGHT:int = 800;
		private var detailSprite:Sprite;
		private var cscroll:CCScrollBar;
		private var loopAtl:LoopAtlas;
		private var md:FoodStreetMd;
		public function FoodStreetView(_md:FoodStreetMd)
		{
			super();
			
			md = _md;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			bgImg.url = _md.bg;
			addChild(bgImg);
			initContent();
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
		}
		private function backHandler(event:MouseEvent):void
		{
			this.visible = false;
			loopAtl.gotoPage(0);
			dispatchEvent(new Event("foodback",true));
		}
		private function closeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private var scrollSrpte:Sprite;
		private function initContent():void
		{
			var imgArr:Array = new Array();
			var img:CImage;
			for each(var amd:AtlaMd in md.itemArr)
			{
				img = new CImage(1693,917,false,false);
				img.url = amd.url;
				imgArr.push(img);
			}
			loopAtl = new LoopAtlas(imgArr,false);
			loopAtl.size = new Point(1693,917);
			loopAtl.x = (YAConst.SCREEN_WIDTH - loopAtl.size.x) / 2;
			loopAtl.y = 50;
			addChild(loopAtl);
			
			initPageButton();
		}
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			addChild(nextBtn);
			addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 90 - 88) / 2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 90;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAtl.next();
			}else{
				loopAtl.prev();
			}
		}
	}
}