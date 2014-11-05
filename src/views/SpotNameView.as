package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class SpotNameView extends Sprite
	{
		private var view_hieght:int = 20;
		private var round:int = 15;
		private var jianW:int = 10;
		private var jianH:int = 15;
		private var _text:String;
		public function SpotNameView()
		{
			super();
		}

		public function get text():String
		{
			return _text;
		}

		private var tf:TextField;
		public function set text(value:String):void
		{
			if(tf)
			{
				removeChild(tf)
			}
			_text = value;
			this.graphics.clear();
			
			tf = new TextField();
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.wordWrap = false;
			tf.height = view_hieght + round * 2;
			tf.text = _text;
//			tf.y = 15;
			var format:TextFormat = new TextFormat(null,20,0xee7600,true,null,null,null,null,TextFormatAlign.CENTER,null,null,null);
			tf.setTextFormat(format);
			tf.y = (40 - tf.textHeight) /2 + 5;
			var txtWidth:int = tf.textWidth;
			if(txtWidth < 60)
			{
				txtWidth = 60;
			}
			tf.width = txtWidth + 2  * round;
			addChild(tf);
			
			
			this.graphics.lineStyle(2,0xeee9e9);
			this.graphics.moveTo(round,0);
			this.graphics.lineTo(txtWidth + round,0);
			this.graphics.curveTo(txtWidth + round * 2,0,txtWidth + round * 2,round);
			this.graphics.lineTo(txtWidth + round * 2,view_hieght + round);
			this.graphics.curveTo(txtWidth + round * 2,view_hieght + round * 2,txtWidth + round,view_hieght + round * 2);
			
			this.graphics.lineTo((txtWidth + round * 2) / 2 + jianW,view_hieght + round * 2);
			this.graphics.lineTo((txtWidth + round * 2) / 2,view_hieght + round * 2 + jianH);
			this.graphics.lineTo((txtWidth + round * 2) / 2 - jianW,view_hieght + round * 2);
			this.graphics.lineTo(round,view_hieght + round * 2);
			this.graphics.curveTo(0,view_hieght + round * 2,0,view_hieght + round);
			this.graphics.lineTo(0,round);
			this.graphics.curveTo(0,0,round,0);
		}

	}
}