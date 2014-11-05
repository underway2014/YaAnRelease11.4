package core.loadEvents
{
	import core.xmlclass.XmlParse;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *加载多个	XML文件 
	 * @author Administrator
	 * 
	 */
	public class CXmlLoader extends EventDispatcher
	{
		private var loadOk:Boolean = false;
		public static const LOADER_COMPLETE:String = "loadercomplete";
		public static const LOADER_PROGRESS:String = "loaderprogress";
		public static const LOADER_ERROR:String = "loadererror";
		
		/**
		 *当前加载的XML数据 
		 */		
		private var _data:XML;
		public var dataArr:Vector.<XML> = new Vector.<XML>();//存入加载的各个XML数据
		//private var xmllists:Array = new Array();//存放待加载的XML
		private var xmlUrl:String;
		private var _loader:URLLoader;
		public function CXmlLoader()
		{
			xmlNamesArr = [];
			xmlUrlArr = [];
			xmlClassArr = [];
		}
		public function loader(xmlUrl:String):void
		{
			this.xmlUrl = xmlUrl;
			
			_loader = new URLLoader(new URLRequest(xmlUrl));
			//			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			_loader.addEventListener(Event.COMPLETE,completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);

		}
		private function realLoad():void
		{

		}
		private function completeHandler(event:Event):void
		{

			trace(_loader.data);
			_data = new XML(_loader.data);
			dataArr.push(_data);

			loadOk = true;
			dispatchEvent(new Event(LOADER_COMPLETE));
		}
		/**
		 *获得对应ID的DATA对象 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getDataById(id:int, name:String = null):Object
		{
			if (name != null)
				_data = getXmlByName(name);
			
			try
			{
//				trace("*##*==",_data);
				var xmllist:XMLList = _data.sample.(@sid==id);
				return XmlParse.parse(xmllist[0]);
			}
			catch(e:Error)
			{
				trace("sample sid = " + id + "不存在!");
				trace(_data.sample);
			} 
			return null;
		}
		
		public function getDataByAttribute(data:String, attri:String, name:String = null):Object
		{
			if (name != null)
				_data = getXmlByName(name);
			
			var xmllist:XMLList = _data.sample.(attribute(attri)== data);
			if (xmllist.length() == 0)
				return null;
			trace("=====*8xmllist.length()**==",xmllist.length());
			
			return XmlParse.parse(xmllist[0]);
		}
		
		private var xmlNamesArr:Array;
		private var xmlUrlArr:Array;
		private var xmlClassArr:Array;
		/**
		 *根据NAME 获得 XML 的路径 
		 * @param str
		 * @return 
		 * 
		 */		
		public function getUrlByName(str:String):String
		{
			if(!xmlNamesArr.length)
			{
				parseXmlList();
			}
			for(var i:int=0;i<xmlNamesArr.length;i++)
			{
				if(xmlNamesArr[i] == str)
				{
					return xmlUrlArr[i];
				}
			}
			throw new Error(str+".xml查无！");
		}
		/**
		 * 根据XML NAME获取相关XML数据
		 * **/
		public function getXmlByName(str:String):XML
		{
			if(!xmlNamesArr.length)
			{
				parseXmlList();
			}
			for(var i:int=0;i<xmlNamesArr.length;i++)
			{
				if(xmlNamesArr[i] == str)
				{
					return dataArr[i];
				}
			}
			throw new Error(str+".xml查无！");
		}
		public static const CLASS:String = "class";
		/**
		 *解析待加载的多个XML列表， 返回各个XML URL地址 
		 * @param getUrl	TRUE: URLARR 	FALSE:NAMEARR
		 * @return 
		 * 
		 */			
		public function parseXmlList(getUrl:Boolean = true):Array
		{
//			var xmlUrlArr:Array = [];
			var rootXml:XML = new XML(dataArr[0]);
			for each(var x:XML in rootXml.children())
			{
				xmlNamesArr.push(x.@name);
				xmlUrlArr.push(x.@file);
//				xmlClassArr.push(x.@CLASS);/////////////  10.8
			}
			if(getUrl)
			{
				return xmlUrlArr;
			}
			else
			{
				return xmlNamesArr;
			}
		}
		/**
		 *返回根结点属性值 
		 * @param _str
		 * @return 
		 * 
		 */		
		public function getRootAttribute(_str:String,_name:String = null):String
		{
			if(_name)	_data = getXmlByName(_name);
			return _data["@"+_str];
		}
		private function progressHandler(event:ProgressEvent):void
		{
			
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			throw new Error("加载："+xmlUrl+"出错！");
		}
		/**
		 * 返回 children 个数 
		 * @return 
		 * 
		 */		
		public function getLength(_name:String = null):uint
		{
			if(_name)	_data = getXmlByName(_name);
			return _data.children().length();
		}

//		public function get data():XML
//		{
//			return _data;
//		}
//
//		public function set data(value:XML):void
//		{
//			_data = value;
//		}


	}
}