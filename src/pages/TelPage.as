package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.bitmap.CBitmap;
	import core.interfaces.PageClear;
	import core.layout.Group;
	import core.loadEvents.CLoader;
	import core.loadEvents.Cevent;
	import core.tween.plugins.VolumePlugin;
	
	import models.AboutNavMd;
	import models.TelMd;
	import models.YAConst;
	
	public class TelPage extends Sprite implements PageClear
	{
		private var md:TelMd;
		private var imgContain:Sprite;
		public function TelPage(_md:TelMd)
		{
			super();
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false);
			bg.url = md.bg;
			addChild(bg);
			
			
			
//			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
//			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,sbar);
//			addChild(hscroll);
//			hscroll.barX = YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN;
//			imgContain = new Sprite();
//			hscroll.target = imgContain;
			
//			var loader:CLoader = new CLoader();
//			loader.load(md.url);
//			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			
			var img:CImage;
			var i:int = 0;
			var imgArr:Array = new Array();
			for each(var url:String in md.contentArr)
			{
				img = new CImage(1381,925,true,false);
				img.url = url;
				imgArr.push(img);
			}
			
			loop = new LoopAtlas(imgArr,false);
			loop.addEventListener("MOVE_OVER",moveOverHandler);
			loop.size = new Point(1381,925);
//			loop.size = new Point(1666,869);
			loop.x = (YAConst.SCREEN_WIDTH - loop.size.x) / 2;
			loop.y = 30;
			addChild(loop);
			
			var navContain:Sprite = new Sprite();
			navContain.x = loop.x + 1381 + 20;
			navContain.y = loop.y;
			addChild(navContain);
			
			var navBtn:CButton;
			navGroup = new Group();
			var ni:int = 0;
			for each(var nmd:AboutNavMd in md.navArr)
			{
				navBtn = new CButton(nmd.skin,false,true);
				navBtn.addEventListener(MouseEvent.CLICK,navClickHandler);
				navBtn.data = nmd;
				navGroup.add(navBtn);
				navContain.addChild(navBtn);
				navBtn.y = ni * (90 + 25);
				jxArr.push(new Point(nmd.begin,nmd.end));
				ni++;
			}
			navGroup.addEventListener(Cevent.SELECT_CHANGE,selectHandler);
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			this.dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
			initPageButton();
		}
		private function moveOverHandler(event:Event):void
		{
			var n:int = checkJX(loop.getCurrentPage());
			if(n != -1 && n != nowJX)
			{
				nowJX = n;
				isAutoSelect = true;
				navGroup.selectById(nowJX);
			}
		}
		private var isAutoSelect:Boolean = false;
		private var jxArr:Array = [];//界线 吃，住，行 页码
		private var navGroup:Group;
		private function navClickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			navGroup.selectByItem(cb);
		}
		private function selectHandler(event:Event):void
		{
			nowJX = navGroup.getCurrentId();
			if(isAutoSelect)
			{
				isAutoSelect = false;
				return;
			}
			var sb:CButton = navGroup.getCurrentObj() as CButton;
			var dataMd:AboutNavMd = sb.data;
			loop.gotoPage(dataMd.begin);
		}
			
		private var loop:LoopAtlas;
		private var nowJX:int = -1;
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
		private function checkJX(np:int):int
		{
			for(var k:int = 0;k < jxArr.length;k++)
			{
				var pmd:Point = jxArr[k];
				if(np >= pmd.x && np <= pmd.y)
				{
					return k;
				}
			}
			return -1;
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loop.next();
			}else{
				loop.prev();
			}
			
		}
		
		private function okHandler(event:Event):void
		{
			var el:CLoader = event.currentTarget as CLoader;
			imgContain.addChild(el._loader);
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
			dispatchEvent(new Event("backHome",true));
		}
		public function clearAll():void
		{
			loop.gotoPage(0);
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
		}
	}
}