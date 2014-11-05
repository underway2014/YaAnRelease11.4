package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	
	import models.AtlaMd;
	
	public class FoodStreetCell extends Sprite
	{
		private var cellMd:AtlaMd;
		private var _cellHeight:int;
		public function FoodStreetCell(_md:AtlaMd)
		{
			super();
			cellMd = _md;
			initImage();
			initTxt();
		}
		private var SELF_WIDTH:int = 1000 - 40;
		private var IMAGE_Y:int = 40;
		private function initImage():void
		{
//			if(!cellMd.articleIcon || cellMd.articleIcon == "")
//			{
//				IMAGE_Y = -240;
//				return;
//			}
			var image:CImage = new CImage(SELF_WIDTH,700,false,false);
			image.y = IMAGE_Y;
			image.url = cellMd.url;
//			var sj:Shape = new Shape();
//			sj.graphics.beginFill(0xe8e8e8);
//			sj.graphics.lineStyle(1,0xcdc9c9);
//			sj.graphics.moveTo(30,248 + IMAGE_Y - 2);
//			sj.graphics.lineTo(50,268 + IMAGE_Y - 2);
//			sj.graphics.lineTo(70,248 + IMAGE_Y - 2);
//			sj.graphics.lineTo(30,248 + IMAGE_Y - 2);
//			sj.graphics.endFill();
//			this.addChild(sj);
			this.addChild(image);
		}
		private function initTxt():void
		{
			var dscTxt:TextField = new TextField();
			dscTxt.text = cellMd.desc;
			dscTxt.setTextFormat(CFontFormat.getTravelDscFormat());
			dscTxt.width = SELF_WIDTH;
			dscTxt.wordWrap = true;
			dscTxt.multiline = true;
			dscTxt.mouseEnabled = false;
			dscTxt.height = dscTxt.textHeight + 50;
			this.addChild(dscTxt);
			dscTxt.y = IMAGE_Y + 732;
			//			dscTxt.backgroundColor = 0x00aacc;
			
			_cellHeight = IMAGE_Y + dscTxt.textHeight + 10 + 700 + 32;
		}
		
		public function get cellHeight():int
		{
			return _cellHeight;
		}
		
	}
}