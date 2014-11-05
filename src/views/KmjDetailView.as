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
	
	import models.KMJWalkLineMd;
	import models.KmjPointDetailMd;
	import models.PublicMd;
	import models.YAConst;
	import models.YFontFormat;
	
	public class KmjDetailView extends Sprite
	{
		private var md:KmjPointDetailMd;
		private var selfWidth:int = 1710 + 30;
		private var selfHeight:int = 900;
		public function KmjDetailView(_md:KmjPointDetailMd)
		{
			super();
			
			md = _md;
			
//			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
//			bgImg.url = md.bg;
//			addChild(bgImg);
			contain = new Sprite();
			
			var sbg:Sprite = new Sprite();
			sbg.graphics.beginFill(0xffffff);
			sbg.graphics.drawRect(-15,-15,selfWidth,selfHeight + 20);
			sbg.graphics.endFill();
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			var scroller:HScroller = new HScroller(selfWidth,selfHeight,sbar);
			scroller.barX = selfWidth + 30;
			scroller.target = contain;
			
			sbg.addChild(scroller);
			
			sbg.x = (YAConst.SCREEN_WIDTH - selfWidth) / 2;
			sbg.y = 50;
			addChild(sbg);
			
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = YAConst.SCREEN_WIDTH - 100;
			
			initHead();
			
			detailContain = new Sprite();
			contain.addChild(detailContain);
			
			detailContain.x = 150 -15;
			
			initDetai();
			
			
		}
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
	}
}