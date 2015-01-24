package views
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	
	import models.AtlaMd;
	import models.BusinessMd;
	import models.YAConst;
	
	public class BusinessView extends Sprite
	{
		private var SELF_WIDHT:int = 1000 + 14;
		private var SELF_HEIGHT:int = 800;
		private var md:BusinessMd;
		
		private var contain:Sprite;
		public function BusinessView(_md:BusinessMd)
		{
			super();
			
			md = _md;
			
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRoundRect(0,0,SELF_WIDHT,SELF_HEIGHT,20,20);
			this.graphics.endFill();
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			bg.url = md.bg;
			addChild(bg);
			
			init();
		}
		private var loopAtl:LoopAtlas;
		private function init():void
		{
			var imgArr:Array = new Array();
			var img:CImage;
			var pageSprite:Sprite;
			var i:int = 0;
			var n:int = 0;
			for each(var amd:AtlaMd in md.itemArr)
			{
				
				img = new CImage(1692,855,false,false);
				img.url = amd.url;
				img.y = 70;
				img.x = 110;
				if(n % 1 == 0)
				{
					pageSprite = new Sprite();
					imgArr.push(pageSprite);
					n = 0;
				}
				
				pageSprite.addChild(img);
				
				i++;
				n++;
			}
			loopAtl = new LoopAtlas(imgArr,false);
			loopAtl.size = new Point(1920,1080);
			addChild(loopAtl);
			
			initPageButton();
			
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
		private function clickHandler(evet:MouseEvent):void
		{
			
		}
	}
}