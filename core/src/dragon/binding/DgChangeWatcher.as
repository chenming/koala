package dragon.binding
{
	/**
	 * 监听器句柄
	 *  
	 * @author Tiago
	 */
	public class DgChangeWatcher
	{
		/**
		 * bindProperty 时的目标对象
		 */
		public var tarObj:Object;
		/**
		 * bindProperty 时的目标对象属性名
		 */
		public var tarProp:String;
		/**
		 * bindSetter 时的回调
		 */
		public var tarSetter:Function;
		/**
		 * 源对象
		 */
		public var srcObj:Object;
		/**
		 * 源对象属性名
		 */
		public var srcProp:String;
		
		
		public function DgChangeWatcher( pTargetObj:Object, pTargetProp:String, pCb:Function, pSrcObj:Object, pSrcProp:String )
		{
			tarObj		= pTargetObj;
			tarProp		= pTargetProp;
			tarSetter	= pCb;
			srcObj		= pSrcObj;
			srcProp		= pSrcProp;
		}
		
		
		/**
		 * 取消监听
		 */		
		public function unwatch():void
		{
			tarObj && DgBindingUtils.unbindProperty( tarObj, tarProp, srcObj, srcProp );
			tarSetter && DgBindingUtils.unbindSetter( tarSetter, srcObj, srcProp );
			tarObj		= null;
			tarProp		= null;
			tarSetter	= null;
			srcObj		= null;
			srcProp		= null;
		}
		
		
		
	}
}








