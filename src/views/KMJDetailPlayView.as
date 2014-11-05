package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	
	import models.KMJDetailplayMd;
	import models.PublicMd;

	/**
	 *游玩体验 
	 * @author jin.hu
	 * 
	 */	
	public class KMJDetailPlayView extends Sprite
	{
		private var md:PublicMd;
		public function KMJDetailPlayView(_md:PublicMd)
		{
			super();
			
			md = _md;
			
			var iconImg:CImage = new CImage(332,260,false,false);4
			iconImg.url = md.icon;
			addChild(iconImg);
			
			var titleTxt:TextField = new TextField();
			titleTxt.text = md.title;
			addChild(titleTxt);
			
			var dscTxt:TextField = new TextField();
			dscTxt.text = md.desc;
			addChild(dscTxt);
		}
	}
}