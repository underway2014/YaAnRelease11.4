package pages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.MusicPlayer;
	import core.filter.CFilter;
	import core.interfaces.PageClear;
	import core.tween.TweenLite;
	
	import models.AtlaMd;
	import models.PointMd;
	import models.YAConst;
	
	import views.SpotNameView;
	
	public class AtlasPage extends Sprite implements PageClear
	{
		private var pointMd:PointMd;
		private var contentContain:Sprite;
		public function AtlasPage(_pointMd:PointMd)
		{
			super();
			
			pointMd = _pointMd;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = "source/allSpots/bg/bg.jpg";
			addChild(bgImg);
			
			contentContain = new Sprite();
			contentContain.y = 150;
			addChild(contentContain);
			
			music = new MusicPlayer(pointMd.audioUrl,false,false);
			music.addEventListener(MusicPlayer.PLAY_OVER,musicOverHandler);
			var sArr:Array = ["source/atlas/play.png","source/atlas/pause.png"];
			audioButton = new CButton(sArr,true,true,true);
			audioButton.addEventListener(MouseEvent.CLICK,playMusicHandler);
			this.addChild(audioButton);
			audioButton.x = YAConst.SCREEN_WIDTH - 77;
			audioButton.y = 94;
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 20;
			
			initContent();
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				if(!music.isPause)
				{
					music.pause();
				}
				audioButton.select(-1);
				contentContain.x = 0;
				changeName(0);
				this.parent.removeChild(this);
			}
		}
		private var audioButton:CButton;
		private var music:MusicPlayer;
		private function playMusicHandler(event:MouseEvent):void
		{
			if(music.isPause)
			{
				music.play(0);
			}else{
				music.pause();
			}
		}
		private function musicOverHandler(event:Event):void
		{
			audioButton.select(false);
		}
		private var nameArr:Array;
		private function initContent():void
		{
			var atlasArr:Array = pointMd.atlasArr;
			
			var imgArr:Array = [];
			nameArr = new Array();
			var img:CImage;
			var i:int = 0;
			for each(var md:AtlaMd in atlasArr)
			{
				img = new CImage(atoDis,535,false,false);
				img.url = md.url;
				imgArr.push(img);
				nameArr.push(md.name);
				img.x = i * (atoDis + 4);
				img.filters = CFilter.photoBorderFilter;
				contentContain.addChild(img);
				i++;
			}
//			var loopAtlas:LoopAtlas = new LoopAtlas(imgArr);
//			contentContain.addChild(loopAtlas);
			contentContain.addEventListener(MouseEvent.MOUSE_DOWN,mouseDonwnHandler);
			contentContain.addEventListener(MouseEvent.MOUSE_UP,stopDrayHandler);
			contentContain.addEventListener(MouseEvent.MOUSE_OUT,stopDrayHandler);
			
			showLine();
		}
		private var lineWidth:int;
		private var currentPage:int = 0;
		private var segWdth:int;
		private function showLine():void
		{
			lineWidth = YAConst.SCREEN_WIDTH - 200;
			var hLine:Shape = new Shape();
			hLine.graphics.beginFill(0xf0f0f0);
			hLine.graphics.drawRoundRect(0,0,lineWidth,8,4,4);
			hLine.graphics.endFill();
			hLine.y = 120;
			hLine.x = 50;
			addChild(hLine);
			
			segWdth = lineWidth / nameArr.length;
			changeName(0);
		}
		private var nameView:SpotNameView;
		private function changeName(_index:int):void
		{
			if(!nameView)
			{
				nameView = new SpotNameView();
				addChild(nameView);
				nameView.y = 50;
			}
			nameView.text = nameArr[_index];
			var eX:int = _index *segWdth;
			TweenLite.to(nameView,.3,{x:eX});
		}
		private var atlasY:int = 150;
		private var beginX:int;
		private var dis:int = 15;
		private var disTime:Number = 300;
		private var beginTime:Number;
		private var atoDis:int = 800;
		private function mouseDonwnHandler(event:MouseEvent):void
		{
			beginX = this.mouseX;
			var dData:Date = new Date();
			beginTime = dData.getTime();
			contentContain.startDrag(false,new Rectangle(YAConst.SCREEN_WIDTH - contentContain.width,atlasY,contentContain.width - YAConst.SCREEN_WIDTH,0));
//			contentContain.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		private function mouseMoveHandler(event:MouseEvent):void
		{
			
		}
		private function stopDrayHandler(event:MouseEvent):void
		{
			var ed:Date = new Date();
			if(ed.getTime() - beginTime < disTime && Math.abs(beginX - this.mouseX) > dis)
			{
				var dir:int = 1;
				if(beginX > this.mouseX)
				{
					dir = -1;
				}
				var endX:int = contentContain.x + atoDis * dir;
				if(endX > 0)
				{
					endX = 0;
				}
				if(endX < -contentContain.width + YAConst.SCREEN_WIDTH)
				{
					endX = -contentContain.width + YAConst.SCREEN_WIDTH
				}
				TweenLite.to(contentContain,.3,{x:endX,onComplete:tweenOver});
			}else{
				tweenOver();
			}
			contentContain.stopDrag();
		}
		private function tweenOver():void
		{
			var cx:Number = contentContain.x;
			currentPage = Math.round(Math.abs(cx) / (atoDis * 1.0));
			if(Math.abs(cx) >= contentContain.width - YAConst.SCREEN_WIDTH - 50)
			{
				currentPage = nameArr.length - 1;
			}
			changeName(currentPage);
		}
		public function clearAll():void
		{
			
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