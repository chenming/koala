package dragon.ui.fte
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	
	/**
	 * html与图片的转换器
	 * 在textcomponent中所使用到的特殊图片，都会经过这里进行解析
	 * 
	 * @author tomas
	 */	
	public class DgGraphicDict implements DgIDgGraphicDict
	{
		public static var inst:DgGraphicDict = new DgGraphicDict;
		
		/**
		 * 资源列表 
		 */ 
		private var _dict:Object 				= {};
		
		/**
		 * 需要被记录的资源
		 * 
		 * @param pKey 索引
		 * @param pVal 资源信息
		 * { 
		 * 		className 	: 可以生成资源的class类型（必须）, 
		 * 		width 		: 资源宽度（必须），
		 * 		height		: 资源高度（必须）
		 * }
		 */		
		public function add( pKey:String, pVal:Object ):void
		{
			if( _dict.hasOwnProperty(pKey) ) {
				trace('警告，资源池中已经存在同名资源');
				return;
			}
			
			if( !checkConfig(pVal) ) {
				trace('警告，DgGraphicDict传入的参数不正确');
				return;				
			}
			
			_dict[pKey] = pVal;
		}
		
		/**
		 * 获取资源列表中的一个资源
		 * @param pKey 
		 */		
		public function getItem(pKey:String):DisplayObject
		{
			var obj:DisplayObject;
			
			if( !_dict.hasOwnProperty(pKey) ) {
				return null;
			}
			
			obj = new (_dict[pKey].className as Class)();
			obj is InteractiveObject &&	(InteractiveObject(obj).mouseEnabled = false);
			obj is DisplayObjectContainer && (DisplayObjectContainer(obj).mouseChildren = false);
			return obj;
		}
		
		/**
		 * 是否存在该资源 
		 */		
		public function hasItem(pKey:String):Boolean
		{
			return _dict.hasOwnProperty(pKey);
		}
		
		private function checkConfig( pVal:Object ):Boolean
		{
			return pVal.hasOwnProperty('className') && pVal.hasOwnProperty('width') && pVal.hasOwnProperty('height');
		}
	}
}