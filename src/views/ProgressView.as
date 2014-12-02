package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.baseComponent.CImage;
	
	public class ProgressView extends Sprite
	{
		private var progressTxt:TextField;
		public function ProgressView()
		{
			super();
			
			var bg:CImage = new CImage(59,38,false,false);
			bg.url = "source/public/video_progressBg.png";
			addChild(bg);
			
			formate = new TextFormat(null,20,0x000000);
			formate.align = TextFormatAlign.CENTER;
			
			progressTxt = new TextField();
			progressTxt.text = "0%";
			progressTxt.width = 59;
			progressTxt.selectable = false;
			addChild(progressTxt);
			progressTxt.setTextFormat(formate);
			
		}
		private var _text:String;
		private var formate:TextFormat;

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			progressTxt.text = value;
			progressTxt.setTextFormat(formate);
		}

	}
}