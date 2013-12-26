package dragon.objectpool
{
	import flash.utils.Dictionary;
	
	import dragon.core.DgTimer;

	/**
	 * 游戏对象池
	 * 用于在游戏中重用某些经常被复用的实例， 例如玩家、怪物、宠物等
	 * 
	 * @author Tiago
	 */
	public class DgObjectPool
	{
		/**
		 * 缺省的垃圾回收器执行间隔
		 * 当前为3分钟
		 */
		private static const DEFAULT_GC_INTERVAL:int = 10;
		
		/**
		 * GC执行间隔，单位：毫秒
		 * getObject()被调用时触发，非精确调用
		 * 手动GC可直接调用gc()
		 */
		public static var gcInterval:int 			= DEFAULT_GC_INTERVAL;
		/**
		 * 对象池
		 */
		private static var _pool:Dictionary	 		= new Dictionary();
		/**
		 * GC是否启动
		 */		
		private static var _gcStarted:Boolean;
		
		
		/**
		 * 对象生成器，用于当对象池中无空闲对象时调用生成新对象
		 * 
		 * @param pCls			类名称
		 * @param pInitCb		初始化方法，参数是实例化对象和pArg
		 * @param pArg			传递给初始化方法的参数
		 */
		public static function getObject(pCls:Class, pInitCb:Function = null, pArg:* = null):Object
		{
			var obj:Object;
			var container:Vector.<Object>;
			
			if (!_gcStarted) {
				DgTimer.add(gc, DgTimer.milliToFrame(gcInterval * 60000));
				_gcStarted = true;
			}
			
			container = _pool[pCls] as Vector.<Object>;
			
			if (container && container.length > 0) {
				obj = container.pop();
			} else {
				obj = new pCls();
			}
			
			if( pInitCb != null ) {
				pArg? pInitCb(obj, pArg) : pInitCb(obj);
			}
			return obj;
		}
		
		
		
		/**
		 * 回收对象
		 * 
		 * @param p_category 对象类别，用于区分要复用的对象
		 * @param pObj      要回收的对象
		 * @param pCb		  回收时，调用的析构函数
		 */
		public static function freeObject(pCls:Class, pObj:Object, pCb:Function = null):void
		{
			var container:Vector.<Object>;
			
			if( !pObj ) {
				return;
			}
			pCb && pCb( pObj );
			
			container = _pool[pCls];
			if (container == null) {
				container = new Vector.<Object>();
				_pool[pCls] = container;
			}
			
			container.indexOf(pObj) == -1 && container.push(pObj);
		}
		
		//======================================================================
		// GC相关
		//======================================================================
		
		/**
		 * 回收无用对象
		 */
		public static function gc():void
		{
			_pool = new Dictionary();
		}
	}
}