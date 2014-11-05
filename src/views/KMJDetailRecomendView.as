package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	
	import models.PublicMd;
	import models.YFontFormat;
	
	public class KMJDetailRecomendView extends Sprite
	{
		private var md:PublicMd;
		public function KMJDetailRecomendView(_md:PublicMd)
		{
			super();
			
			md = _md;
			
			var iconImg:CImage = new CImage(369,559,false,false);
			iconImg.url = md.icon;
			addChild(iconImg);
			
			var rcontain:Sprite = new Sprite();
			addChild(rcontain);
			rcontain.x = 380;
			
			var titleBgImg:CImage = new CImage(315,52,false,false);
			titleBgImg.url = "source/public/foodTitleBg.png";
			rcontain.addChild(titleBgImg);
			
			var titleTxt:TextField = new TextField();
			titleTxt.width = 315;
			titleTxt.height = 50;
			titleTxt.text = md.name;
			titleTxt.setTextFormat(YFontFormat.kmjRecomendTitle);
			titleBgImg.addChild(titleTxt);
			
			var dscTxt:TextField = new TextField();
			dscTxt.wordWrap = true;
			dscTxt.width = 320;
			dscTxt.y = 52 + 10;
			dscTxt.width = 315;
			dscTxt.text = md.desc;
			dscTxt.setTextFormat(YFontFormat.kmjRecomendDsc);
			dscTxt.height = dscTxt.textHeight + 20;
			rcontain.addChild(dscTxt);
			
//			return;
			var otherContain:Sprite = new Sprite();
			rcontain.addChild(otherContain);
			var otherTxt:TextField = new TextField();
			otherTxt.width = 320;
			otherTxt.wordWrap = true;
			otherTxt.y = dscTxt.y + dscTxt.height + 20;
			otherTxt.text = md.other;
			otherTxt.setTextFormat(YFontFormat.kmjRecomendOther);
			otherTxt.height = otherTxt.textHeight + 20;
			otherContain.addChild(otherTxt);
			
			otherContain.graphics.beginFill(0xaacc00,.2);
			otherContain.graphics.drawRoundRect(0,0,320,otherTxt.height,10,10);
			otherContain.graphics.endFill();
			
		}
	}
}