package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CImage;
	
	import models.AtlaMd;
	
	public class PicTxtView extends Sprite
	{
		public var wwidth:int = 700;
		private var hheight:int = 300;
		public function PicTxtView(_md:AtlaMd)
		{
			super();
			
			var img:CImage = new CImage(wwidth,hheight,false,false);
			img.url = _md.url;
			addChild(img);
			
			var txt:TextField = new TextField();
			txt.text = _md.desc;
			var format:TextFormat = new TextFormat(null,20,0x000000);
			txt.setTextFormat(format);
			addChild(txt);
			txt.width = wwidth;
			txt.height = 200;
			txt.y = hheight;
		}
	}
}