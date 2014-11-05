package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	
	import models.KMJWalkLineMd;
	
	public class KMJWalkLineView extends Sprite
	{
		private var md:KMJWalkLineMd;
		public function KMJWalkLineView(_md:KMJWalkLineMd,_index:int)
		{
			super();
			
			md = _md;
			
			var numSprite:Sprite = new Sprite();
			numSprite.graphics.beginFill(0x00aa00,.6);
			numSprite.graphics.drawCircle(0,0,10);
			numSprite.graphics.endFill();
			var numTxt:TextField = new TextField();
			numTxt.text = _index + "";
			numSprite.addChild(numTxt);
			addChild(numSprite);
			
			var iconImg:CImage = new CImage(689,344,false,false);
			iconImg.url = md.icon;
			addChild(iconImg);
			
			var txtContain:Sprite = new Sprite();
			addChild(txtContain);
			
			txtContain.graphics.beginFill(0x00aa00);
			txtContain.graphics.drawRect(0,0,200,100);
			txtContain.graphics.endFill();
			
			var timeTxt:TextField = new TextField();
			timeTxt.text = md.time;
			txtContain.addChild(timeTxt);
			
			var dscTxt:TextField = new TextField();
			dscTxt.text = md.desc;
			dscTxt.x = 100;
			txtContain.addChild(dscTxt);
			
			var costTxt:TextField = new TextField();
			costTxt.text = md.cost;
			txtContain.addChild(costTxt);
			
			var nameTxt:TextField = new TextField();
			nameTxt.text = md.name;
			txtContain.addChild(nameTxt);
			nameTxt.x = 300;
			nameTxt.y = 50;
		}
	}
}