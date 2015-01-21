package views
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.date.CDate;
	import core.loadEvents.CLoaderMany;
	
	/**
	 *加载FLV 
	 * @author bin.li
	 * 
	 */	
	public class VideoView extends Sprite
	{
		/**
		 * FLV播放路径
		 * **/
		private var _url:String;
		
		private var video:Video;
		
		private var connection:NetConnection;
		private var _width:int;
		private var _height:int;
		/**
		 * 
		 * @param w
		 * @param h
		 * @param showBar	是否显示拖动条
		 * 
		 */		
		public function VideoView(w:int = 1024,h:int = 768,showBar:Boolean = false,controlArr:Array = null)
		{
			super();
			
			var bgShape:Shape = new Shape();
			bgShape.graphics.lineStyle(2,0xffffff,.6);
			bgShape.graphics.beginFill(0xffffff,.1);
			bgShape.graphics.drawRect(0,0,w + 90,h + 70);
			bgShape.graphics.endFill();
			addChild(bgShape);
			bgShape.x = -45;
			bgShape.y = -35;
			video = new Video(w,h);
			addChild(video);
			//			this.addEventListener(MouseEvent.CLICK,soundCloseHandler);
			//			this.addEventListener(MouseEvent.DOUBLE_CLICK,soundOpenHandler);
			
			_width = w;
			_height = h;
			
			txtFormat = new TextFormat(null,23,0xffffff,true);
			
//			if(showBar&&controlArr)
//			{
//				controlUrlArr = controlArr;
//			}
				initBar();
		}
		private var controlUrlArr:Array;
		//------------------------------------------------------------
		private var barSprite:Sprite;
		private var sliderSprite:Sprite;
		private var barLoader:CLoaderMany;
		private var musicLoader:CLoaderMany;
		private function initBar():void
		{
			barSprite = new Sprite();
			addChild(barSprite);
			
			sliderSprite = new Sprite();
			barSprite.addChild(sliderSprite);
			sliderSprite.addEventListener(Event.ENTER_FRAME,updateSlider);
			
//			sliderSprite.addEventListener(MouseEvent.MOUSE_DOWN,sliderStartHandler);
//			sliderSprite.addEventListener(MouseEvent.MOUSE_UP,sliderStopHandler);
//			sliderSprite.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			barSprite.y = _height - 100;
//			
//			barLoader = new CLoaderMany();
//			barLoader.load([controlUrlArr[0],controlUrlArr[1]]);
//			barLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,barLoadOkHandler);
			var arr:Array = ["source/public/video_play.png","source/public/video_pause.png"];
			stopBtn = new CButton(arr,false,true,true);
			stopBtn.addEventListener(MouseEvent.CLICK,stopPlayHandler);
			addChild(stopBtn);
			stopBtn.select(true);
			
			controlSprite = new Sprite();
			addChild(controlSprite);
			controlSprite.y = _height - 65;
			controlSprite.addChild(stopBtn);
			controlSprite.x = 20;
			
			var rsprite:Sprite = new Sprite();
			rsprite.x = 73;
			rsprite.y = 10;
			controlSprite.addChild(rsprite);
			var rbg:Shape = new Shape();
			rbg.graphics.lineStyle(2,0xffffff,.2);
			rbg.graphics.beginFill(0xffffff,.2);
			rbg.graphics.drawRoundRect(-10,-10,712 + 210,38,38,38);
			rbg.graphics.endFill();
			rsprite.addChild(rbg);
			
			
			var proShape:Shape = new Shape();
			
			proShape.graphics.beginFill(0x000000);
			proShape.graphics.drawRoundRect(0,0,712,19,20,20);
			proShape.graphics.endFill();
			rsprite.addChild(proShape);
			
			var proImg:CImage = new CImage(712,19,false,false);
			proImg.url = "source/public/video_progress.png";
			rsprite.addChild(proImg);
//			proImg.x = -1;
//			proImg.x = proShape.x = 63;
//			proImg.y = proShape.y = 10;
			
			maskShape = new Shape();
			rsprite.addChild(maskShape);
			proImg.mask = maskShape;
			
			proView = new ProgressView();
			rsprite.addChild(proView);
			proView.x = -30;
			proView.y = -40;
			
			
			
//			rsprite.addChild(txt);
//			txt.y = -5;
//			txt.x = 712 + 10;
			
//			maskShape.x = 63;
//			maskShape.y = 40;
			
			timePro = new TextField();
			timePro.selectable = false;
			timePro.width = 170;
			rsprite.addChild(timePro);
			timePro.text = "";
			timePro.y = -5;
			timePro.x = 712 + 30;
			timePro.setTextFormat(txtFormat);
			
			
			var closeArr:Array = ["source/public/video_close.png","source/public/video_close.png"];
			var closeBtn:CButton = new CButton(closeArr,false,false,false);
			closeBtn.addEventListener(MouseEvent.CLICK,closeVideoHandler);
			addChild(closeBtn);
			closeBtn.x = _width - 27;
			closeBtn.y = -25;
			
//			var bottomBg:CImage = new CImage(1430,124,false,false);
//			bottomBg.url = "source/public/video_bottom.png";
//			addChildAt(bottomBg,0);
//			bottomBg.y = _height - 10;
//			bottomBg.x = (_width - 1430) / 2;
		}
		private var _videoName:String
		private var txtFormat:TextFormat;
		private var timePro:TextField;
		private var proView:ProgressView;
		private var maskShape:Shape;
		private var controlSprite:Sprite;
		private var stopBtn:CButton;
		private function stopPlayHandler(event:MouseEvent):void
		{
			videoPauseHandler(null);
		}
		private var isMusicDown:Boolean;
		private function musicDownHandler(event:MouseEvent):void
		{
			isMusicDown = true;
			musicBarSprite.startDrag(false);
		}
		private function musicUpHandler(event:MouseEvent):void
		{
			isMusicDown = false;
			musicBarSprite.stopDrag();
		}
		private function musicOutHandler(event:MouseEvent):void
		{
			if(isMouseDown)
				musicUpHandler(null);
		}
		private var musicSprite:Sprite;
		private var barBgSprite:Sprite;
		private var musicBarSprite:Sprite;
		private function musicOkHandler(event:Event):void
		{
			musicSprite.addChild(musicLoader._loaderContent[0]);
			barBgSprite.addChildAt(musicLoader._loaderContent[1],0);
			musicBarSprite.addChild(musicLoader._loaderContent[2]);
			musicBarSprite.y = musicLoader._loaderContent[1].height - musicBarSprite.height;
		}
		private function showMusicHandler(event:Event):void
		{
			if(barBgSprite.visible)
			{
				barBgSprite.visible = false;
			}
			else
			{
				barBgSprite.visible = true;
			}
		}
		
		
		private function dragChangeHandler(event:Event):void
		{
			stream.seek(sliderSprite.x/(_width - sliderSprite.width)*duration);
			trace("stream.time==n==",stream.time);
		}
		private function barLoadOkHandler(event:Event):void
		{
			barLoader._loaderContent[0].width = _width;
			barSprite.addChildAt(barLoader._loaderContent[0],0);
			sliderSprite.addChild(barLoader._loaderContent[1]);
			dragRect = new Rectangle(0,0,_width - sliderSprite.width,0)
		}
		//更新进度块的位置
		private function updateSlider(event:Event):void
		{
			
			maskShape.graphics.clear();
			var longS:int = 712*(stream.time/duration);
			maskShape.graphics.beginFill(0x00ff00);
			maskShape.graphics.drawRect(0,0,longS,19);
			maskShape.graphics.endFill();
			
			proView.text = Math.floor(stream.time/duration * 100) + "%";
			proView.x = longS - 30;
			
			timePro.text = CDate.timeFormate(stream.time) + " / " + CDate.timeFormate(duration);
			timePro.setTextFormat(txtFormat);
		}
		
		private var dragRect:Rectangle;
		private var isMouseDown:Boolean;
		//开始拖动
		private function sliderStartHandler(event:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,dragChangeHandler);
			isMouseDown = true;
			sliderSprite.removeEventListener(Event.ENTER_FRAME,updateSlider);
			sliderSprite.startDrag(false,dragRect);
			videoPauseHandler(null);
			
		}
		private var drag:int;	//防止反弹的
		private function sliderStopHandler(event:MouseEvent):void
		{
			drag = 2;
			this.removeEventListener(Event.ENTER_FRAME,dragChangeHandler);
			isMouseDown = false;
			sliderSprite.stopDrag();
			setPositinAndPlay();
		}
		private function outHandler(event:MouseEvent):void
		{
			if(isMouseDown)
			{
				sliderStopHandler(null);
			}
		}
		private function setPositinAndPlay():void
		{
			stream.seek(sliderSprite.x/(_width - sliderSprite.width)*duration);
			//			stream.togglePause();
			videoPauseHandler(null);
			sliderSprite.addEventListener(Event.ENTER_FRAME,updateSlider);
		}
		
		//---------------------------------------------------------------------
		
		private var isPause:Boolean;	//视频当前是否暂停
		public function soundOpenHandler(event:Event):void
		{
			stream.soundTransform = new SoundTransform(1);
		}
		public function soundCloseHandler(event:Event):void
		{
			stream.soundTransform = new SoundTransform(0);
		}
		private var _volume:Number;	//音量大小
		public function videoPauseHandler(event:MouseEvent):void
		{
			if(isPlayOver)
			{
				stream.play(url);
				isPlayOver = false;
			}else{
				if(!isPause)
				{
					stream.pause();
					sliderSprite.removeEventListener(Event.ENTER_FRAME,updateSlider);
					isPause = true;
				}
				else
				{
					stream.resume();
					sliderSprite.addEventListener(Event.ENTER_FRAME,updateSlider);
					isPause = false;
				}
			}
		}
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					connectStream();
					dispatchEvent(new Event(VIDEO_CONNECT_SUCCESS));
					break;
				case "NetStream.Play.StreamNotFound":
					throw new Error("Stream not found: " + _url);
					break;
				case "NetStream.Play.Stop" :
					if(_loop)
					{
						trace("重播放。。。");
						stream.play(url);
					}
					else
					{
//						reset();
						dispatchEvent(new Event(VIDEO_PLAY_OVER));
						trace("player over.....");
						if(!_isList)
							playOverHandler();
					}
					break;
			}
		}
		private var isPlayOver:Boolean = false;
		/**
		 * 循环播放
		 */		
		private var _loop:Boolean;	//
		/**
		 * 播放内容是否有多个
		 */		
		private var _isList:Boolean; 	//
		
		public static const VIDEO_PLAY_OVER:String = "playover";
		public static const VIDEO_PLAY_PAUSE:String = "playpause";
		public static const VIDEO_PLAY_RESET:String = "replay";
		public static const VIDEO_CONNECT_SUCCESS:String = "connectsuccess";
		
		private var stream:NetStream;
		private function connectStream():void
		{
			if(stream)
			{
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.close();
				stream = null;
			}
			
			var obj:Object=new Object(); 
			obj.onMetaData = onMetaData; 
			
			stream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.client = obj;
			video.attachNetStream(stream);
			stream.play(_url);
			stream.inBufferSeek = true;
			//			soundtransform = new SoundTransform(1);
			//			soundtransform = stream.soundTransform;
			
		}
		public function getInfo(type:int):String
		{
			switch(type)
			{
				case 0:
					//					return "加载字节数："+stream.bytesLoaded+"/"+stream.bytesTotal+"time:"+stream.time+"totaltime:"+duration;
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
			}
			return null;
		}
		//		private var soundtransform:SoundTransform;
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			throw new Error(_url + "	:securityError....");
		}
		
		/**
		 *清除视频 ,且停止数据流
		 * **/
		public function playOverHandler():void
		{
			isPause = false;
			isPlayOver = true;
			stopBtn.select(false);
//			close();
			clear();
		}
		private function closeVideoHandler(event:MouseEvent):void
		{
			if(stream)
			{
				stream.close();
			}
			if(this.parent)
			{
				this.parent.visible = false;
				this.parent.removeChild(this);
			}
		}
		public function clear():void
		{
//			stream.close();
			closeVideoHandler(null);
		}
//		public function close():void
//		{
//			stream.close();
//		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
			if(connection)
			{
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection = null;
			}
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
			//			trace("connection is null");
		}
		private var duration:Number;
		public function onMetaData(infoObject:Object):void 
		{ 
			trace("metadata"); 
			duration=infoObject.duration;//获取总时间 
			
			timePro.text = "00:00 / " + CDate.timeFormate(duration);
		}
		public function get loop():Boolean
		{
			return _loop;
		}
		
		/**
		 *是否循环播放  
		 */			
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		public function get isList():Boolean
		{
			return _isList;
		}
		
		public function set isList(value:Boolean):void
		{
			_isList = value;
		}
		
		public function get volume():Number
		{
			//			trace("===音量大小===",stream.soundTransform.volume);
			if(stream)
			{
				_volume = stream.soundTransform.volume;
				return _volume;
			}
			return -1;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
		}

		public function get videoName():String
		{
			return _videoName;
		}

		public function set videoName(value:String):void
		{
			_videoName = value;
			
			
			var txt:TextField = new TextField();
			txt.text = value;//"雅安宣传片欣赏";
			txt.width = 270;
			txt.setTextFormat(txtFormat);
			txt.selectable = false;
			this.addChild(txt);
			txt.x = 30;
			txt.y = 30;
		}
		
		
	}
}
