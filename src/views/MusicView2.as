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
	
	public class MusicView2 extends Sprite
	{
		private var music:MusicPlayer;
		private var _isPause:Boolean;
		public function MusicView2(_url:String)
		{
			super();
			
			var bgImg:CImage = new CImage(440,98,false,false);
			bgImg.url = "source/travel/son/musicBg.png";
			addChild(bgImg);
//			this.graphics.beginFill(0xaacc00);
//			this.graphics.drawRect(0,0,440,98);
//			this.graphics.endFill();
			
			//			var nfromat:TextFormat = new TextFormat(null,18,0x000000,null);
			//			var txt:TextField = new TextField();
			//			txt.text = "音频——景点描述";
			//			txt.width = 300;
			//			addChild(txt);
			//			txt.setTextFormat(nfromat);
			//			txt.x = 25;
			//			txt.y = 10;
			
			
			timeFormat = new TextFormat(null,16,0x000000,null,null,null,null,null,TextFormatAlign.RIGHT);
			currentTimeTxt = new TextField();
			currentTimeTxt.width = 60;
			currentTimeTxt.text = "00:00";
			currentTimeTxt.setTextFormat(timeFormat);
			currentTimeTxt.y = 25;
			currentTimeTxt.x = 310;
			addChild(currentTimeTxt);
			
			var probgImg:CImage = new CImage(310,21,false,false);
			probgImg.url = "source/travel/son/audioprobg.png";
			addChild(probgImg);
			var proImg:CImage = new CImage(310,21,false,false);
			proImg.url = "source/travel/son/audiopro.png";
			addChild(proImg);
			
			
			music = new MusicPlayer(_url,false,false);
			music.addEventListener(MusicPlayer.MUSIC_LOAD_COMPLETE,musicLoadOk);
			music.addEventListener(MusicPlayer.PLAY_OVER,playOverHandler);
			var marr:Array = ["source/travel/son/audioN.png","source/travel/son/audioD.png"];
			mbtn = new CButton(marr,false,true,true);
			mbtn.addEventListener(MouseEvent.CLICK,playHandler);
			mbtn.y = 7;
			mbtn.x = 20;
			addChild(mbtn);
			
			
			progressShape = new Shape();
			addChild(progressShape);
			probgImg.x = progressShape.x = proImg.x = 114;
			probgImg.y = progressShape.y = proImg.y = 55;
			proImg.y = 56;
			proImg.mask = progressShape;
		}
		private var spotFormat:TextFormat;
		private var spotNameTxt:TextField;
		private var _spotName:String;
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
			var totaltimeFormat:TextFormat = new TextFormat(null,16,0x000000,null,null,null,null,null,TextFormatAlign.LEFT);
			var totalTimeTxt:TextField = new TextField();
			totalTimeTxt.width = 60;
			totalTimeTxt.text = "/ " + CDate.timeFormate(music.length / 1000);
			totalTimeTxt.x = 370;
			totalTimeTxt.y = 25;
			totalTimeTxt.setTextFormat(totaltimeFormat);
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
		public function pauseMusic():void
		{
			music.pause();
			mbtn.select(false);
			
		}
		private function changeSoundTime(event:Event):void
		{
			progressShape.graphics.clear();
			progressShape.graphics.beginFill(0xaacc00);
			progressShape.graphics.drawRect(0,0,music.currentPosition / totalTime * 310,30);
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

		public function get isPause():Boolean
		{
			return music.isPause;
		}

		public function set isPause(value:Boolean):void
		{
			_isPause = value;
		}

		public function get spotName():String
		{
			return _spotName;
		}

		public function set spotName(value:String):void
		{
			_spotName = value;
			
			spotFormat = new TextFormat(null,22);
			spotNameTxt = new TextField();
			spotNameTxt.text = "听听" + value;
			spotNameTxt.selectable = false;
			spotNameTxt.x = 120;
			spotNameTxt.y = 22;
			spotNameTxt.height = 30;
			spotNameTxt.width = 300;
			spotNameTxt.setTextFormat(spotFormat);
			addChild(spotNameTxt);
		}


	}
}