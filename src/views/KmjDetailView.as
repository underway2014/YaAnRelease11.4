   package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.baseComponent.LoopAtlas;
	import core.loadEvents.CLoader;
	
	import models.KMJWalkLineMd;
	import models.KmjPointDetailMd;
	import models.KmjPointMd;
	import models.PublicMd;
	import models.YAConst;
	import models.YFontFormat;
	
	public class KmjDetailView extends Sprite
	{
		private var md:KmjPointDetailMd;
		private var selfWidth:int = 1710 + 35;
		private var selfHeight:int = 900;
		private var parentMd:KmjPointMd;
		public function KmjDetailView(_md:KmjPointMd)
		{
			super();
			parentMd = _md;
			md = _md.detailmd;
			
			yarr = [];
			for each(var x:int in md.scrollArr)
			{
				yarr.push(x + 594);
			}
			
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = md.bg;
			addChild(bgImg);
			contain = new Sprite();
			
			var sbg:Sprite = new Sprite();
			sbg.graphics.beginFill(0xffffff);
			sbg.graphics.drawRect(-17,-15,selfWidth,selfHeight + 50);
			sbg.graphics.endFill();
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			scroller = new HScroller(selfWidth,selfHeight + 30,sbar);
			scroller.barX = selfWidth + 20;
			scroller.target = contain;
			
			sbg.addChild(scroller);
			
			sbg.x = (YAConst.SCREEN_WIDTH - selfWidth) / 2 + 10;
			sbg.y = 35;
			addChild(sbg);
			
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.BACKBUTTONX;
			backBtn.y = YAConst.BACKBUTTONY;
			
			initHead();
			navContain = new Sprite();
			navContain.x = 40;
			addNavgation();
			
			detailContain = new Sprite();
			contain.addChild(detailContain);
			
//			detailContain.x = 150 -15;
			detailContain.y = currentY;
			detailContain.x = -17;
			
			
			initDetaiZS();
			
//			initDetai();
			addMusic();
			this.addChild(navContain);
			
		}
		private var navContain:Sprite;
		private var scroller:HScroller;
		private var yarr:Array;
		private function addNavgation():void
		{
			var narr:Array = ["spot_recomend.png","spot_play.png","spot_food.png","spot_techan.png","spot_zhusu.png","spot_info.png"];
			
			var nbtn:CButton;
			var i:int = 0;
			for each(var str:String in narr)
			{
				nbtn = new CButton(["source/public/" + str,"source/public/" + str],false);
				nbtn.data = i;
				nbtn.addEventListener(MouseEvent.CLICK,gotoIndex);
				i++;
				navContain.addChild(nbtn);
				nbtn.y = i * 76;
			}
		}
		private function gotoIndex(evt:MouseEvent):void
		{
			var cbtn:CButton = evt.currentTarget as CButton;
			scroller.scrollTo(yarr[cbtn.data]);
		}
		private var musicView:MusicView;
		private function addMusic():void
		{
			if(!md.music || md.music == "")
			{
				return;
			}
			musicView = new MusicView(md.music);
			detailContain.addChild(musicView);
			musicView.x = 450 + 60;
			musicView.y = 45;
			
//			music = new MusicPlayer("source/lookSpot/dongls/1.mp3",false,false);
//			music.addEventListener(MusicPlayer.MUSIC_LOAD_COMPLETE,musicLoadOk);
//			var marr:Array = ["source/public/music_play.png","source/public/music_pause.png"];
//			var mbtn:CButton = new CButton(marr,false,true,true);
//			mbtn.addEventListener(MouseEvent.CLICK,playHandler);
//			mbtn.y = 20;
//			mbtn.x = 300;
//			detailContain.addChild(mbtn);
//			
//			nowTimeTxt = new TextField();
//			nowTimeTxt.width = 50;
//			nowTimeTxt.text = 0 + "";
//			detailContain.addChild(nowTimeTxt);
//			nowTimeTxt.x = 700;
//			nowTimeTxt.y = 20;
			
			
		}
		private var nowTimeTxt:TextField;
		private var totalTimeTxt:TextField;
		private var detailContain:Sprite;
		private var contain:Sprite;
		private function initHead():void
		{
			
			var imgArr:Array = [];
			var img:CImage;
			for each(var str:String in md.headArr)
			{
				img = new CImage(1710,594,false,false);
				img.url = str;
				imgArr.push(img);
				if(md.video && md.video != "")
				{
					img.addEventListener(MouseEvent.CLICK,loopPlayVideo);
				}
			}
			
			loop = new LoopAtlas(imgArr,true);
			loop.addEventListener(Event.REMOVED_FROM_STAGE,clearLoop);
			loop.size = new Point(1670,589);
			loop.showTipCircle = true;
			contain.addChild(loop);
			loop.x = 15;
			loop.y = 15;
			
			currentY = 594;
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
			videoView.videoName = parentMd.name + "宣传片欣赏";
			videoView.addEventListener(Event.REMOVED_FROM_STAGE,clearVideo);
			videoView.addEventListener(VideoView.VIDEO_PLAY_OVER,playOverHandler);
			videoView.url = md.video
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
		private var currentY:int;
		private function initDetai():void
		{
			currentY += 40;
			
			var titleTxt:TextField = new TextField();
			titleTxt.width = 1000;
			titleTxt.text = md.name;
			titleTxt.setTextFormat(YFontFormat.mainTitle);
			detailContain.addChild(titleTxt);
			titleTxt.y = currentY;
			
			currentY += 50;
			
			var mainDsc:TextField = new TextField();
			mainDsc.width = selfWidth - 150 * 2;
			mainDsc.text = md.desc;
			mainDsc.setTextFormat(YFontFormat.mainDsc);
			mainDsc.height = mainDsc.textHeight + 20;
			detailContain.addChild(mainDsc);
			mainDsc.y = currentY;
			
			currentY += mainDsc.height + 30;
			// init recomend
			var recomendSprite:Sprite = new Sprite();
			detailContain.addChild(recomendSprite);
			recomendSprite.y = currentY;
			var recomendIcon:CImage = new CImage(54,67,false,false);
			recomendIcon.url = "source/public/star.png";
			recomendSprite.addChild(recomendIcon);
			
			var recomendTitle:TextField = new TextField();
			recomendTitle.mouseEnabled = false;
			recomendTitle.text = "景区美食推荐";
			recomendTitle.width = selfWidth - 200;
			recomendTitle.setTextFormat(YFontFormat.modeTitle);
			recomendSprite.addChild(recomendTitle);
			recomendTitle.x = 80;
			
			var recomendView:KMJDetailRecomendView;
			var i:int = 0;
			for each(var remd:PublicMd in md.recomend)
			{
				recomendView = new KMJDetailRecomendView(remd);
				recomendSprite.addChild(recomendView);
				recomendView.x = (i % 2) * 710;
				recomendView.y = Math.floor(i / 2) * 560 + 80;
				i++;
			}
			
			currentY += Math.ceil(md.recomend.length / 2) * 640;
			
//			return;
			// play expericence
			var playSprite:Sprite = new Sprite();
			playSprite.y = currentY;
			detailContain.addChild(playSprite);
			
			var playIcon:CImage = new CImage(54,67,false,false);
			playIcon.url = "source/public/star.png";
			playSprite.addChild(playIcon);
			
			var playTitle:TextField = new TextField();
			playTitle.text = "游玩必体验";
			playTitle.setTextFormat(YFontFormat.modeTitle);
			
			var playDscTxt:TextField = new TextField();
			playDscTxt.text = md.play.desc;
			var playView:KMJDetailPlayView;
			i = 0;
			for each(var plMd:PublicMd in md.play.items)
			{
				playView = new KMJDetailPlayView(plMd);
				playSprite.addChild(playView);
				playView.y = i * 200;
				i++;
			}
			currentY += md.play.items.length * 200 + 100;
			
			return;
			//walk line
			var walkSprite:Sprite = new Sprite();
			detailContain.addChild(walkSprite);
			walkSprite.y = currentY;
			
			var walkIcon:CImage = new CImage(50,50,false,false);
			walkIcon.url = "source/public/star.png";
			walkSprite.addChild(walkIcon);
			
			var walkView:KMJWalkLineView;
			i = 0;
			for each(var wmd:KMJWalkLineMd in md.walkLine)
			{
				walkView = new KMJWalkLineView(wmd,i);
				walkSprite.addChild(walkView);
				walkSprite.y = i * 300;
				i++;
			}
			
			currentY += Math.floor(md.walkLine.length / 2)  * 300;
			
			//spot info
			var infoSprite:Sprite = new Sprite();
			detailContain.addChild(infoSprite);
			infoSprite.y = currentY;
			var infoIcon:CImage = new CImage(50,50,false,false);
			infoIcon.url = "source/public/star.png";
			infoSprite.addChild(infoIcon);
			
			var infoTxt:TextField = new TextField();
			infoTxt.text = md.info.desc;
			infoSprite.addChild(infoTxt);
			

		}
		private var loop:LoopAtlas;
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
			
		}
		private function clearLoop(event:Event):void
		{
			if(loop)
			{
				loop.clear();
				loop = null;
			}
		}
		
		
		private var loader:CLoader;
		private function initDetaiZS():void
		{
			loader = new CLoader();
			loader.load(md.name);
			loader.addEventListener(CLoader.LOADE_COMPLETE,loadOkHandler);
		}
		private function loadOkHandler(event:Event):void
		{
			detailContain.addChildAt(loader._loader,0);
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,setDetailNull);
		}
		private function setDetailNull(evet:Event):void
		{
			if(loader._loader)
			{
				loader._loader = null;
			}
		}
		public function clear():void
		{
			if(videoView)
			{
				videoView.clear();
			}
			backHandler(null);
		}
		
	}
}