package dragon.core
{
	import flash.utils.ByteArray;

	/**
	 * 封装常用的字符串操作
	 * 
	 * @author Tiago
	 */
	public class DgString
	{
		/**
		 * ByteArray实例缓存
		 * 用于获取字符串实际占用字节数
		 */
		private static const  _BY:ByteArray	= new ByteArray();
		
		
		/**
		 * 自定义字符串替换函数， 通常用于模板
		 * 
		 * @param	string	pStr		
		 * @param	object	pContent
		 * @return	pStr被pContent替换后的值
		 * @example
		 *  var tpl = 'Hi {you}, I am {me}. ';
		 * 	trace( strReplace(tpl, {you: 'JJC', 'me' : 'Tiago'}) );
		 */
		static public function strReplace(pStr:String, pContent:Object):String
		{
			var idx :String;
			for ( idx in pContent ) {
				while ( pStr.search('{' + idx + '}') != -1 )
					pStr = pStr.replace('{' + idx + '}', pContent[idx] );
			}
			return pStr;
		}
		
		
		/**
		 * 简化的字符串模式替换函数，
		 * 通常用于将游戏中指定的字符串转换为特殊信息
		 * 改方法只能匹配大括号内的信息
		 * 
		 * @param pStr 需要查找的内容
		 * @param pCb	匹配后的回调函数
		 * @return	替换后的值
		 * @example
		 *  var cb:Function = function( pType:String, pVal:String ):String {
		 * 		switch( pType ) {
		 * 			case 'map' : return '福州';
		 * 			case 'npc' : return 'Tiago';
		 * 		}
		 * 		return '';
		 *  }
		 * 	var desc = search( '请到 {map_1} 找 {npc_3}', cb );
		 *  trace( desc ); //  请到 福州  找 Tiago 
		 */
		static public function strReplace2( pStr:String, pCb:Function ):String
		{
			if( !pStr || pCb == null ) {
				return '';
			}
			return pStr.replace(/{.*?}/g, function( pKey:String, pIdx:int, pStr:String ):String {
				var arr:Array;
				pKey 	= pKey.replace('{', '');
				pKey 	= pKey.replace('}', '');
				arr 	= pKey.split( '_' );
				return pCb( arr[0], arr[1] );
			} );
		}
		
		
		
		/**
		 * 字符串头尾空白字符过滤
		 * 如果是flex工程， 请使用StringUtil.trim代替这个函数
		 */
		static public function trim(pStr:String):String
		{
			return pStr? pStr.replace(/^\s+|\s+$/g, '') : ''; 
		}
		
		/**
		 * 清除字符串中的所有空格
		 */
		public static function trimAll(pStr:String):String
		{
			return pStr ? pStr.replace( /([ ]{1})/g, '' ) : '';
		}
		
		
		
		/**
		 * 获取字符串占用的实际字节数
		 */
		public static function getStringSize( pStr:String ) : int 
		{
			_BY.length = 0;
			_BY.writeUTFBytes( pStr );
			return _BY.length;
		}
		
		/**
		 * 获取将对象转换成amf格式后需要的字节数
		 */
		public static function getAmfSize( pObj:Object ) : int 
		{
			_BY.length = 0;
			_BY.writeObject( pObj );
			return _BY.length;
		}
		
		
		/**
		 * 哈希函数
		 * @param	pStr String
		 */
		public static function hash(pStr:String):Number
		{ 
			var hash:Number = 5381;
			_BY.length = 0;
			_BY.writeUTFBytes(pStr);
			_BY.position = 0;
			while (_BY.bytesAvailable) {
				hash = ( ( hash << 5 ) + hash ) + _BY.readUTFBytes(1).charCodeAt(0);
			}
			return hash;
		}
		
		/**
		 * 标记字符串是否为整数 
		 */
		public static function isInt( pStr:String ):Boolean
		{
			var res:int = int( pStr );
			
			if( res || ( pStr.length == 0 && pStr.charAt(0) == '0' ) ) {
				return true;
			}
			
			return false;
		}
		
		/**
		 * 字符串替换， 功能和 StringUtil.substitute一样
		 */		
		public static function substitute(pStr:String, ... pArg):String
		{
			// Replace all of the parameters in the msg string.
			var len:int, i:int;
			var args:Array;
			
			if (pStr == null) return '';
			
			len = pArg.length;
			args = pArg;
			
			for (i = 0; i < len; i++){
//				pStr = pStr.replace('{' + i + '}', args[i]);
				pStr = pStr.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			
			return pStr;
		}
		
		public static function repeat( pStr:String, pN:int):String
		{
			var s:String;
			
			if ( !pN )
				return "";
			
			s = pStr;
			for( ; pN > 1; --pN ) {
				s += pStr;
			}
			return s;
		}
		
		
		
		
	}
}