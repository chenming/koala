package dragon.binding
{
	import flash.utils.Dictionary;
	
	import dragon.core.DgObject;
	
	
	/**
	 * 绑定组件
	 * 该组件用于实现类似flex的绑定效果
	 * 
	 * @author Tiago
	 */
	public class DgBindingUtils
	{
		/**
		 * 绑定监听列表
		 *  
		 * {
		 *	object {
		 * 		pro_watcher	: {
		 * 			propName	: [
		 * 				{
		 * 					target_obj 	: Object,
		 * 					target_prop	: String
		 * 				},
		 * 				……
		 * 			],
		 * 			……
		 * 		},
		 * 		cb_watcher	: {
		 * 			propName	: [ function, …… ],
		 * 			……
		 * 		}
		 * }
		 */
		private static var _list:Dictionary	= new Dictionary(true);
		
		
		/**
		 * 将当前对象的属性和另一个对象的属性进行绑定
		 * 类似：BindingUtils.bindProperty()
		 * 
		 * @param pTargetObj	目标对象
		 * @param pTargetProp	目标对象属性名
		 * @param pSrcObj		源对象
		 * @param pSrcProp	源对象属性名
		 * @param pNeedWatcher是否需要返回 DgChangeWatcher
		 */
		public static function bindProperty( pTargetObj:Object, pTargetProp:String, pSrcObj:Object, pSrcProp:String, pNeedWatcher:Boolean = false ):DgChangeWatcher
		{
			var pro_list:Object;
			
			if( !_list[ pSrcObj ] ) {
				_list[pSrcObj] = {
					pro_watcher	: {},
					cb_watcher	: {}
				};
			}
			
			pro_list = _list[pSrcObj].pro_watcher;
			pro_list[pSrcProp] || ( pro_list[pSrcProp] = [] );
			pro_list[pSrcProp].push( {
				target_obj	: pTargetObj,
				target_prop	: pTargetProp
			} );
			
			pTargetObj[pTargetProp] = pSrcObj[pSrcProp];
			
			return pNeedWatcher? new DgChangeWatcher( pTargetObj, pTargetProp, null, pSrcObj, pSrcProp ) : null;
		}

		
		/**
		 * 将当前对象的属性和一个回调函数进行绑定
		 * 类似：BindingUtils.bindSetter()
		 * 
		 * @param pCb			当属性发生变化时触发的回调函数
		 * @param pSrcObj		源对象
		 * @param pSrcProp		源对象属性名
		 * @param pNeedWatcher	是否需要返回 DgChangeWatcher
		 * @param pCallNow		是否需要马上触发一次回调
		 */
		public static function bindSetter( pCb:Function, pSrcObj:Object, pSrcProp:String, pNeedWatcher:Boolean = false, pCallNow:Boolean = true ):DgChangeWatcher
		{
			var cb_list:Object;
			
			if( !_list[ pSrcObj ] ) {
				_list[pSrcObj] = {
					pro_watcher	: {},
					cb_watcher	: {}
				};
			}
			
			cb_list = _list[pSrcObj].cb_watcher;
			cb_list[pSrcProp] || ( cb_list[pSrcProp] = [] );
			cb_list[pSrcProp].push( pCb );
			pCallNow && pCb( pSrcObj[pSrcProp] );
			return pNeedWatcher? new DgChangeWatcher( null, null, pCb, pSrcObj, pSrcProp ) : null;
		}
		
		
		/**
		 * 取消 bindProperty 的绑定
		 */
		public static function unbindProperty( pTargetObj:Object, pTargetProp:String, pSrcObj:Object, pSrcProp:String ):void
		{
			var pro_list:Object;
			var list:Array;
			var idx:int;
			var conf:Object;
			
			if( !_list[ pSrcObj ] ) {
				return;
			}
			
			pro_list = _list[pSrcObj].pro_watcher;
			
			if( !pro_list.hasOwnProperty( pSrcProp ) ){
				return;
			}
			
			list = pro_list[pSrcProp];
			for( idx = list.length - 1; idx >= 0; --idx ) {
				conf = list[idx];
				if( conf.target_obj == pTargetObj && conf.target_prop == pTargetProp ) {
					list.splice( idx, 1 );
					break;
				}
			}
			
			list.length || DgObject.unsetKey( _list[pSrcObj].pro_watcher, pSrcProp );
		}
		
		
		/**
		 * 取消 unbindSetter 的绑定
		 */
		public static function unbindSetter( pCb:Function, pSrcObj:Object, pSrcProp:String ):void
		{
			var cb_list:Object;
			var cb:Function;
			var list:Array;
			var idx:int;
			
			if( !_list[ pSrcObj ] ) {
				return;
			}
			
			cb_list = _list[pSrcObj].cb_watcher;
			if( !cb_list.hasOwnProperty( pSrcProp ) ){
				return;
			}
			
			list = cb_list[pSrcProp];
			for( idx = list.length - 1; idx >= 0; --idx ) {
				cb = list[idx];
				if( cb == pCb ) {
					list.splice( idx, 1 );
					break;
				}
			}
			
			list.length || DgObject.unsetKey( _list[pSrcObj].cb_watcher, pSrcProp );
		}

		
		/**
		 * 某个属性发生变化
		 */		
		public static function propertyChanged( pSrcObj:Object, pSrcProp:String ):void
		{
			var pro_list:Object;
			var cb_list:Object;
			
			if( !_list[pSrcObj] ) {
				return;
			}
			
			pro_list = _list[pSrcObj].pro_watcher;
			pro_list[pSrcProp] && callBindProperty( pSrcObj, pSrcProp, pro_list[pSrcProp] );
			
			cb_list = _list[pSrcObj].cb_watcher;
			cb_list[pSrcProp] && callBindSetter( pSrcObj, pSrcProp, cb_list[pSrcProp] );
		}
		
		
		/**
		 * 触发所有回调 
		 */
		private static function callBindProperty( pSrcObj:Object, pSrcProp:String, pList:Array ):void
		{
			var conf:Object;
			var pre_len:int;
			
			pre_len = pList.length;
			for each( conf in pList ) {
				conf.target_obj[conf.target_prop] = pSrcObj[pSrcProp];
			}
			
			// 如果回调函数在内部调用unbind， 由于数组在循环过程中长度发生改变，会导致部分内容没被循环到
			// 增加额外的长度判断避免这个问题
			pre_len != pList.length && callBindProperty( pSrcObj, pSrcProp, pList );
		}
		
		
		/**
		 * 触发所有回调 
		 */
		private static function callBindSetter( pSrcObj:Object, pSrcProp:String, pList:Array ):void
		{
			var cb:Function;
			var pre_len:int;
			
			pre_len = pList.length;
			for each( cb in pList ) {
				cb( pSrcObj[pSrcProp] );
			}
			
			// 如果回调函数在内部调用unbind， 由于数组在循环过程中长度发生改变，会导致部分内容没被循环到
			// 增加额外的长度判断避免这个问题
			pre_len != pList.length && callBindSetter( pSrcObj, pSrcProp, pList );
		}
		
		
		
		
		
		
	}
}
		
		
		
		
		
		
		
		
		