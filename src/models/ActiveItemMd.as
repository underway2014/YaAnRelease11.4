package models
{
	import flash.geom.Point;

	public class ActiveItemMd
	{
		public function ActiveItemMd()
		{
		}
		public var name:String;
		public var label:String;
		public var desc:String;
		public var content:String;
		public var coordXY:Point;
		public var son:ActiveItemDetailMd;
	}
}