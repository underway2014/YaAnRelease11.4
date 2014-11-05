package views
{
	import flash.display.Sprite;
	
	import models.BusinessItemMd;
	
	public class BusinessCellDetailView extends Sprite
	{
		private var md:BusinessItemMd;
		public function BusinessCellDetailView(_md:BusinessItemMd)
		{
			super();
			
			md = _md;
		}
	}
}