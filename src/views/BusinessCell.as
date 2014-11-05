package views
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	
	import models.BusinessItemMd;
	
	public class BusinessCell extends Sprite
	{
		private var md:BusinessItemMd;
		private var SELF_WIDTH:int = 450;
		private var SELF_HIEGHT:int = 100;
		
		private var headSize:int = 80;
		public var data:*;
		public function BusinessCell(_md:BusinessItemMd)
		{
			super();
			
			md = _md;
			
			this.graphics.lineStyle(2,0x000);
			this.graphics.drawRoundRect(0,0,SELF_WIDTH,SELF_HIEGHT,10,10);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xcc00cc,.3);
			this.graphics.drawRoundRect(0,0,SELF_WIDTH,SELF_HIEGHT,10,10);
			this.graphics.endFill();
			
			var headImg:CImage = new CImage(headSize,headSize,false,false);
			headImg.url = md.icon;
			this.addChild(headImg);
			headImg.x = headImg.y = 10;
			
			var name:TextField = new TextField();
			name.text = md.name;
			addChild(name);
			name.x = 100;
			name.y = 10;
			
			var adressImg:CImage = new CImage(20,20,false,false);
			adressImg.url = "";
			addChild(adressImg);
			
			var adressText:TextField = new TextField();
			adressText.text = md.adress;
			addChild(adressText);
			
			adressImg.y = adressText.y = 40;
			
			
			
			var telIcon:CImage = new CImage(20,20,false,false);
			telIcon.url = "";
			addChild(telIcon);
			
			var telText:TextField = new TextField();
			telText.text = md.tel;
			addChild(telText);
			
			telIcon.y = telText.y = 60;
			
			telText.x = adressText.x = 130;
			telIcon.x = adressImg.x = name.x = 100;
			
		}
		
		
	}
}