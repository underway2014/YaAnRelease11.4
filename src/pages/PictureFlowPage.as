package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.interfaces.PageClear;
	
	import models.AtlaMd;
	import models.YAConst;
	
	import views.PicTxtView;
	
	public class PictureFlowPage extends Sprite implements PageClear
	{
		private var content:Sprite;
		
		private var drag:CDrag;
		public function PictureFlowPage(arr:Array)
		{
			super();
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			this.graphics.endFill();
			
			content = new Sprite();
//			addChild(content);
			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,true);
			addChild(drag);
			
			
			initContent(arr);
			
			var arrS:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arrS,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 20;
		}
	
		private function initContent(_arr:Array):void
		{
			
			var i:int = 0;
			var view:PicTxtView;
			for each(var md:AtlaMd in _arr)
			{
				view = new PicTxtView(md);
				content.addChild(view);
				view.x = i * view.wwidth;
				i++;
			}
			drag.target = content;
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
				this.parent.removeChild(this);
			}
		}
		public function clearAll():void
		{
			
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
		}
	}
}