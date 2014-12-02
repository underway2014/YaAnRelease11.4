package views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.MusicPlayer;
	import core.date.CDate;
	
	public class MusicView extends Sprite
	{
		private var music:MusicPlayer;
		public function MusicView(_url:String)
		{
			super();
			
			var bgImg:CImage = new CImage(985,50,false,false);
			bgImg.url = "source/public/music_bg.png";
			addChild(bgImg);
			
//			var nfromat:TextFormat = new TextFormat(null,18,0x000000,null);
//			var txt:TextField = new TextField();
//			txt.text = "音频——景点描述";
//			txt.width = 300;
//			addChild(txt);
//			txt.setTextFormat(nfromat);
//			txt.x = 25;
//			txt.y = 10;
			
			
			timeFormat = new TextFormat(null,16,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			currentTimeTxt = new TextField();
			currentTimeTxt.width = 65;
			currentTimeTxt.text = "00:00";
			currentTimeTxt.setTextFormat(timeFormat);
			currentTimeTxt.y = 13;
			addChild(currentTimeTxt);
			
			var probgImg:CImage = new CImage(856,8,false,false);
			probgImg.url = "source/public//music_progressbg.png";
			addChild(probgImg);
			var proImg:CImage = new CImage(856,8,false,false);
			proImg.url = "source/public/music_progress.png";
			addChild(proImg);
			
			
			music = new MusicPlayer(_url,false,false);
			music.addEventListener(MusicPlayer.MUSIC_LOAD_COMPLETE,musicLoadOk);
			music.addEventListener(MusicPlayer.PLAY_OVER,playOverHandler);
			var marr:Array = ["source/public/music_play.png","source/public/music_pause.png"];
			mbtn = new CButton(marr,false,true,true);
			mbtn.addEventListener(MouseEvent.CLICK,playHandler);
			mbtn.y = 0;
			mbtn.x = -50;
			addChild(mbtn);
			
			progressShape = new Shape();
			addChild(progressShape);
			probgImg.x = progressShape.x = proImg.x = 65;
			probgImg.y = progressShape.y = proImg.y = 21;
			proImg.mask = progressShape;
		}
		private var timeFormat:TextFormat;
		private var mbtn:CButton;
		private var currentTimeTxt:TextField;
		private function playOverHandler(event:Event):void
		{
			progressShape.graphics.clear();
			progressShape.graphics.endFill();
			currentTimeTxt.text = "00:00";
			currentTimeTxt.setTextFormat(timeFormat);
			this.clear();
			mbtn.select(false);
		}
		private var progressShape:Shape;
		private var totalTime:int;
		
		private function musicLoadOk(event:Event):void
		{
//			var timeformat:TextFormat = new TextFormat(null,18,0xa69c91);
			
			var totalTimeTxt:TextField = new TextField();
			totalTimeTxt.width = 65;
			totalTimeTxt.text = CDate.timeFormate(music.length / 1000);
			totalTimeTxt.x = 920;
			totalTimeTxt.y = 13;
			totalTimeTxt.setTextFormat(timeFormat);
			addChild(totalTimeTxt);
			totalTime = music.length;
		}
		private function playHandler(evet:MouseEvent):void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,changeSoundTime);
			}
			if(music.isPause)
			{
				music.play();
			}else{
				music.pause();
			}
		}
		private function changeSoundTime(event:Event):void
		{
			progressShape.graphics.clear();
			progressShape.graphics.beginFill(0xaacc00);
			progressShape.graphics.drawRect(0,0,music.currentPosition / totalTime * 856,10);
			progressShape.graphics.endFill();
			
			currentTimeTxt.text = CDate.timeFormate(music.currentPosition / 1000);
			currentTimeTxt.setTextFormat(timeFormat);
		}
		public function clear():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,changeSoundTime);
			}
			music.clear();
		}
	}
}