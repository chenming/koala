package dragon.core
{
	import avmplus.getQualifiedClassName;
	
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * 封装常用对象操作
	 *  
	 * @author Tiago
	 */
	public class DgObject
	{
		
		/**
		 * ByteArray实例缓存
		 * 用于获取字符串实际占用字节数
		 */
		private static const  _BY:ByteArray	= new ByteArray();
		
		/**
		 * 强制调用垃圾回收机制
		 */
		static public function doClearance():void
		{
			try{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			}catch (error : Error) {
				
			}
		}
		
		/**
		 * 将一个对象的内容， 拷贝到另一个对象
		 */
		public static function copy( pFrom:Object, pTo:Object ):void
		{
			var key:String;
			for( key in pFrom ) {
				pTo[key] = pFrom[key];
			}
		}
		
		
		/**
		 * 对动态对象进行复制
		 * @update 2010.11.30 by feather
		 */
		public static function cloneObject( pObj:Object, pIsClass:Boolean = false ) :Object 
		{
			if ( pIsClass ) {
				//获取全名
				var typeName:String = getQualifiedClassName(pObj);
				//切出包名
				var packageName:String = typeName.split("::")[0];
				//获取Class
				var type:Class = getDefinitionByName(typeName) as Class;
				//注册Class
				registerClassAlias(packageName, type);
			}
			//复制对象
			_BY.length = 0;
			_BY.writeObject(pObj);
			_BY.position = 0;
			return _BY.readObject();
		}
		
		
		/**
		 * 快速删除指定对象中的key
		 * 
		 * @param	pObj	指定对象
		 * @param	pKey	需要删除的key
		 */
		public static function unsetKey( pObj:Object, pKey:* ) : void 
		{
			if ( !pObj )
				return;
			pObj[pKey] = null;
			delete pObj[pKey];
		}
		
		
		/**
		 * 检查一个对象是否为空
		 * 
		 * @param	pData	被检查对象， 该函数类似php的empty
		 * @return	空放回true， 否则返回false
		 */
		public static function empty(pData:*) : Boolean 
		{
			var i:String;
			
			if ( !pData )
				return true;
			
			switch( typeof(pData) ) {
				case 'string' :
					return (pData == '' || pData == '0' );
				case 'int' :
				case 'uint' :
				case 'number' :
				case 'boolean' :
					return false;
				default :
					break;
			}
			
			if ( pData is EventDispatcher == false ) {
				i = null;
				for ( i in pData )
					break;
				if ( i == null ) {
					return true;
				}
			}
			
			return false;
		}
		
	}
}