package views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.baseComponent.LoopAtlas;
	import core.baseComponent.MusicPlayer;
	import core.cache.CacheData;
	import core.tween.TweenLite;
	
	import models.KmjPointMd;
	import models.TravelItemMd;
	import models.TravelPicMd;
	import models.YAConst;
	
	public class TravelDetalView extends Sprite
	{
		private var md:TravelItemMd;
		public var hotspotMdArray:Array;
		public function TravelDetalView(_md:TravelItemMd)
		{
			super();
			
			md = _md;
			
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = "source/travel/son/bg.jpg";
			addChild(bgImg);
			
			contain = new Sprite();
			contain.x = 100;
			contain.y = 30;
			this.addChild(contain);
			
			contain.graphics.beginFill(0xffffff);
			contain.graphics.drawRect(0,0,1720,930);
			contain.graphics.endFill();
			
			bottomContain = new Sprite();
			contain.addChild(bottomContain);
			bottomContain.y = 594 + 20 + margin;
			bottomContain.x = margin + 10;;
			
			initLoop();
			initBottom();
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			spotContain = new Sprite();
			addChild(spotContain);
		}
		private var spotContain:Sprite;
		private var bottomContain:Sprite;
		private var contain:Sprite;
		private var loop:LoopAtlas;
		private var videoContain:Sprite;
		private var videoView:VideoView;
		private function loopPlayVideo(event:MouseEvent):void
		{
			pauseMusic();
			var ctimg:CImage = event.currentTarget as CImage;
			if(!videoContain)
			{
				videoContain = new Sprite();
				videoContain.graphics.beginFill(0x000,.7);
				videoContain.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
				videoContain.graphics.endFill();
				addChild(videoContain);
			}
			videoContain.visible = true;
			videoView = new VideoView();
			videoView.videoName = md.name + "宣传片欣赏";
			videoView.addEventListener(Event.REMOVED_FROM_STAGE,clearVideo);
			videoView.addEventListener(VideoView.VIDEO_PLAY_OVER,playOverHandler);
			videoView.url = ctimg.data;
			videoContain.addChild(videoView); 
			videoView.x = 448;
			videoView.y = 100;
		}
		private function clearVideo(event:Event):void
		{
			videoContain.visible = false;
			videoView = null;
		}
		private function playOverHandler(event:Event):void
		{
			
		}
		private function initLoop():void
		{
			
			var imgArr:Array = [];
			var img:CImage;
			for each(var pmd:TravelPicMd in md.pics)
			{
				img = new CImage(1219,594,false,false);
				
				img.url = pmd.url;
				imgArr.push(img);
				if(pmd.data && pmd.data != "")
				{
					img.data = pmd.data;
					img.addEventListener(MouseEvent.CLICK,loopPlayVideo);
				}
			}
			
			loop = new LoopAtlas(imgArr,true);
			loop.addEventListener(Event.REMOVED_FROM_STAGE,clearLoop);
			loop.size = new Point(1219,594);
			loop.showTipCircle = true;
			contain.addChild(loop);
			loop.x = margin;
			loop.y = margin;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(1,0xaaaaaa);
			line.graphics.moveTo(1219 + margin,margin);
			line.graphics.lineTo(1720 - margin,margin);
			line.graphics.lineTo(1720 - margin,margin + 594);
			line.graphics.lineTo(1219 + margin,margin + 594);
			line.graphics.endFill();
			contain.addChild(line);
			
			var dscContain:Sprite = new Sprite();
			var hscroller:HScroller = new HScroller(440,496);
			hscroller.target = dscContain;
			hscroller.y = margin + 10;
			contain.addChild(hscroller);
			
			var nameTxt:TextField = new TextField();
//			nameTxt.y = margin + 10;
			nameTxt.y = 0;
			nameTxt.text = md.name;
			nameTxt.height = 40;
			
			var dscTxt:TextField = new TextField();
			dscTxt.y = nameTxt.y + nameTxt.height + 10;
			dscTxt.text = md.desc;
			dscTxt.wordWrap = true;
			dscTxt.height = 594 - dscTxt.y + margin;
			
			dscTxt.width = nameTxt.width = 460 - 20;
			hscroller.x = 1219 + margin + 10 + 8;
//			dscTxt.x = nameTxt.x = 1219 + margin + 10;
			
			var nameFormat:TextFormat = new TextFormat(null,30,true);
			var dscFormat:TextFormat = new TextFormat(null,26);
			dscFormat.indent = 50;
			dscFormat.leading = 4;
			dscFormat.letterSpacing = 2;
			
			nameTxt.setTextFormat(nameFormat);
			dscTxt.setTextFormat(dscFormat);
			
			nameTxt.selectable = dscTxt.selectable = false;
			
//			contain.addChild(nameTxt);
//			contain.addChild(dscTxt);
			dscContain.addChild(nameTxt);
			dscContain.addChild(dscTxt);
			
			if(md.audio && md.audio !== "")
			{
				musicView = new MusicView2(md.audio);
				musicView.spotName = md.name;
				contain.addChild(musicView);
				musicView.x = hscroller.x;
				musicView.y = 594 - 98 + 10;
			}
			
			
			
//			audio = new MusicPlayer(md.audio,false);
//			audio.addEventListener(MusicPlayer.PLAY_OVER,audipPlayOver);
//			var audioSkin:Array = ["source/travel/son/audio_n.png","source/travel/son/audio_d.png"];
//			audioBtn = new CButton(audioSkin,false,true,true);
//			contain.addChild(audioBtn);
//			audioBtn.x = 1219 + margin - 176 - 15;
//			audioBtn.y = 594 + margin - 66 - 15;
//			audioBtn.addEventListener(MouseEvent.CLICK,playAudio);
		}
		private var musicView:MusicView2;
		private var audioBtn:CButton;
		private var audio:MusicPlayer;
		private function playAudio(event:MouseEvent):void
		{
			if(audio.isPause)
			{
				audio.play();
			}else{
				audio.pause();
			}
			
		}
		private function audipPlayOver(event:Event):void
		{
			audioBtn.select(false);
		}
		private var margin:int = 20;
		private var hotContain:Sprite;
		private function initBottom():void
		{
			var icon:CImage = new CImage(256,183,false,false);
			icon.url = md.icon;
			icon.y = 40;
			bottomContain.addChild(icon);
			
			var hotImg:CImage = new CImage(143,41,false,false);
			hotImg.url = "source/travel/son/hotspot.png";
			bottomContain.addChild(hotImg);
			hotImg.x = 256 + 10;
			
			hotContain = new Sprite();
			hotContain.x = hotImg.x + 10 + 143;
			bottomContain.addChild(hotContain);
			
			var btn:CButton;
			var i:int = 0;
			var cellspace:int = 10;
			for each(var bo:TravelPicMd in md.hotspots)
			{
				btn = new CButton([bo.url,bo.url],false,false);
				btn.data = int(bo.data);
				hotContain.addChild(btn);
				btn.x = i * (276 + cellspace);
				btn.addEventListener(MouseEvent.CLICK,enterSpot);
				i++;
			}
			
			if(md.hotspots.length > 4)
			{
				var maskS:Shape = new Shape();
				maskS.graphics.beginFill(0xaacc00,.3);
				maskS.graphics.drawRect(0,0,276 * 4 + 3 * cellspace,300);
				maskS.graphics.endFill();
				bottomContain.addChild(maskS);
				maskS.x = hotContain.x;
				hotContain.mask = maskS;
				
				leftX = maskS.x -(md.hotspots.length - 4)*(276 + cellspace);
				
				var lb:CButton = new CButton(["source/travel/son/left_arrow.png","source/travel/son/left_arrow.png"],false,false);
				lb.addEventListener(MouseEvent.CLICK,scrollHandler);
				lb.data = -1;
				lb.x = hotContain.x - 86;
				
				var rb:CButton = new CButton(["source/travel/son/right_arrow.png","source/travel/son/right_arrow.png"],false,false);
				rb.addEventListener(MouseEvent.CLICK,scrollHandler);
				rb.x = hotContain.x + 276 * 4 + 3 * cellspace + 20;
				rb.data = 1;
				
				rb.y = lb.y = 105;
				
				bottomContain.addChild(lb);
				bottomContain.addChild(rb);
			}
			
		}
		private var leftX:int = 0;
		private var direction:int = 0;
		private function enterSpot(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			trace(cb.data);
			
			if(hotspotMdArray && hotspotMdArray.length >= cb.data)
			{
				var hmd:KmjPointMd = hotspotMdArray[cb.data];
				spotDetailView = new KmjDetailView(hmd.detailmd);
				spotDetailView.addEventListener(Event.REMOVED_FROM_STAGE,clearDetailView);
				spotContain.addChild(spotDetailView);
				spotContain.visible = true;
				
				pauseMusic();
				
				
//				if(audio)
//				{
//					if(!audio.isPause)
//					{
//						audio.pause();
//						audioBtn.select(false);
//					}
//				}
			}
		}
		private function clearDetailView(event:Event):void
		{
			if(spotDetailView)
			{
				spotDetailView = null;
			}
			spotContain.visible = false;
		}
		private var spotDetailView:KmjDetailView;
		private function scrollHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			trace(cb.data);
			var endX:int = hotContain.x - cb.data * (276 + 10) * 2;
			if(endX < leftX)
			{
				endX = leftX;
			}
			if(endX > 419)
			{
				endX = 419;
			}
			TweenLite.to(hotContain,.5,{x:endX});
			
		}
		private function clearLoop(event:Event):void
		{
			if(loop)
			{
				loop.clear();
				loop = null;
			}
		}
		private function pauseMusic():void
		{
			if(musicView)
			{
				if(!musicView.isPause)
				{
					musicView.pauseMusic();
				}
			}
		}
		private function backHandler(event:MouseEvent):void
		{
			if(musicView)
			{
				musicView.clear();
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
//			dispatchEvent(new Event("backHome",true));
		}
		public function clear():void
		{
			if(spotDetailView)
			{
				spotDetailView.clear();
			}
			if(videoView)
			{
				videoView.clear();
			}
			backHandler(null);
		}
	}
}