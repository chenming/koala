package dragon.core
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 * 系统全局时间触发器
	 * 
	 * 由于大规模应用中大量使用timer会导致性能消耗过大， 而且不准确
	 * 所以封装了全局时间类， 同于统一控制应用中的时间触发
	 * 
	 * @author Tiago
	 * 
	 * @example
	 * 1、每1000ms触发一次函数
	 * 		DgTimer.add( my_func, DgTimer.milliToFrame(1000) );
	 * 
	 * 2、每1000ms触发一次函数， 触发3次
	 * 		DgTimer.add( my_func, DgTimer.milliToFrame(1000), 3 );
	 * 
	 * 3、1000ms后触发一次函数， 只触发1次
	 * 		DgTimer.quickAdd( my_func, 1000 );
	 */
	public class DgTimer
	{
		/**
		 * 保存当前帧事件触发的时间
		 * 这个属性用于表面应用程序产生大量的Date实例
		 */
		public static var curTime:Number = new Date().time;
		/**
		 * 每帧需要的毫秒数 
		 */
		public static var frameMspf:int;
		/**
		 * 从程序运行到现在， 执行了多少帧 
		 */
		public static var frameCount:uint;
		/**
		 * 距离上次触发经过了多少毫秒 
		 */
		public static var frameItvl:int;
		private static var _frameRate:int = 30;
		/**
		 * 游戏帧频
		 * 具体应用程序必须设置改值， 才能达到真正的帧频， 在其他地方调用无效
		 */
		public static function get frameRate():int
		{
			return _frameRate;
		}
		public static function set frameRate(pVal:int):void
		{
			_frameRate = pVal;
			frameMspf	= 1000 / pVal;
		}
		
		/**
		 * 任务列表
		 */
		private static var _list:Dictionary;
		/**
		 * 时间触发器
		 */
		private static var _timer:MovieClip;
		/**
		 * 用于计算getTimer的时间误差 
		 */
		private static var _timeDiff:Number;
		
		/**
		 * 开始时间触发
		 */
		public static function start() : void
		{
			_timer.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			_timeDiff = new Date().time - getTimer();
			trace('[DgTimer Start]');
		}
		
		/**
		 * 暂停时间触发
		 */
		public static function pause() : void
		{
			_timer && _timer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 添加定时处理到队列
		 * 
		 * @param	pCb 		回调
		 * @param	pDelay    延时，这里是以帧时间为单位，即默认为1/24s
		 * @param	pRepeat   是否等待帧次数，最终的延时操作事件为 pDelay * pRepeat，如果为0则是无限循环，即setInterval
		 */
		public static function add(pCb:Function, pDelay:int = 1, pRepeat:int = 0) : void
		{
			var dtl:TimerData;
			
			if ( pCb == null ) {
				return;
			}
			
			if ( !_timer ) {
				_list 		= new Dictionary();
				_timer 		= new MovieClip();
				start();
			}
			dtl = TimerData.createInstance(pCb, pDelay, pRepeat);
			if ( !dtl ) {
				return;
			}
			
			_list[pCb] = dtl;
		}
		

		/**
		 * 删除定时任务
		 * 
		 * @param	pCb	任务回调
		 */
		public static function remove(pCb:Function) : void
		{
			if ( !_list || !(_list[pCb]) ) 
			{
				return;
			}
			_list[pCb] = null;
			delete _list[pCb];
		}
		
		/**
		 * 提供一个快速定时回调的方法
		 * 该方法根据设定的毫秒时间， 触发单次回调
		 * 
		 * @param pCb		回调函数
		 * @param pDelay	延迟（毫秒）
		 */
		public static function quickAdd( pCb:Function, pDelay:int = 0 ) : void 
		{
			if ( pCb == null ) {
				return;
			}
			add( pCb, milliToFrame(pDelay), 1 );
		}
		
		
		/**
		 * 将毫秒转换成帧数, 
		 * 例如在24的fps下41毫秒等于1帧
		 * 
		 * @param	pMtime	毫秒数
		 * @param 	pFps	需要转换的fps
		 * @return 帧数
		 */
		public static function milliToFrame( pMtime:int, pFps:int = 0 ) : int
		{
			 return pMtime * (pFps? pFps : frameRate) * 0.001 ;
		}
		
		
		/**
		 * 将 fps 转换为 msfp 
		 */
		public static function fpsToMspf( pFps:int ):int
		{
			return 1000 / pFps;
		}
		
		
		/**
		 * 将 mspf 转换为多少帧刷新一次 
		 */
		public static function mspfToFrame( pMspf:int ):int
		{
			return Math.ceil( pMspf / frameMspf );
		}
		
		
		/**
		 * 获取一个回调被调用的次数
		 */
		public static function getCounter( pCb:Function ) : int
		{
			if( !(pCb in _list) ) {
				return - 1;
			}
			return TimerData(_list[pCb]).counter;
		}
		
		/**
		 * 重新设置回调
		 * 该方法只有在回调函数最后一次被执行前调用才有效
		 * 因为超过最后一次执行时机后， DgTimer将释放相关的内存
		 */
		public static function reset(pCb:Function) : void
		{
			var dtl:TimerData;
			dtl = _list[pCb];
			add(pCb, dtl.delay, dtl.repeat);
		}
		
		/**
		 * 定时器促发函数
		 */
		private static function onEnterFrame( pEvt:Event ) : void
		{
			var key:Object;
			var dtl:TimerData;
			
			frameCount++;
			frameItvl =  _timeDiff + getTimer() - curTime;
			curTime = _timeDiff + getTimer(); 
			
			for ( key in _list ) {
				dtl = TimerData(_list[key]);
				
				// 对只调用一次触发的快速处理
				if( dtl.exprTime ) {
					if( dtl.exprTime <= curTime ) {
						DgObject.unsetKey(_list, key);
						dtl.cb();
					}
					continue;
				}
				
				if( --dtl.lastFrame ) {
					continue;
				}
				
				//tiago at 6.14
				//回调函数必须放在删除dtl前，否则最后一次触发时将导致 getCounter返回-1
				//当然， 这么做导致回调函数内部运行直接重新调用add方法
				dtl.cb();
				(dtl.repeat && ++dtl.counter >= dtl.repeat)? 
					DgObject.unsetKey(_list, key) : dtl.lastFrame = dtl.delay;
				
			}
		}
		
		
	}
}
import dragon.core.DgTimer;



/**
 * DgTimer内部用到的VO
 */
class TimerData
{
	/**
	 * 触发时间
	 */
	public var delay:int;
	/**
	 * 距离下次触发的帧数
	 */
	public var lastFrame:int;
	/**
	 * 触发次数
	 */
	public var repeat:int;
	/**
	 * 已经触发的次数
	 */
	public var counter:int;
	/**
	 * 回调函数
	 */
	public var cb:Function;
	/**
	 * 回调过期时间， 这个属性只用在对时间要求严格的情况下
	 * 目前对时间严格的判定是只触发一次
	 */
	public var exprTime:Number;
	
	
	/**
	 * 创建并初始化数据VO实例
	 * @return	如果创建成功， 返回TimerData， 否则返回NULL
	 */
	public static function createInstance( pCb:Function, pDelay:int, pRepeat:int ) : TimerData
	{
		var inst:TimerData;
		
		if( pCb == null ) {
			return null;
		}
		
		inst 			= new TimerData();
		inst.delay		= pDelay;
		inst.lastFrame	= pDelay;
		inst.repeat		= pRepeat;
		inst.counter	= 0;
		inst.cb			= pCb;
		inst.exprTime	= pRepeat == 1 ? DgTimer.curTime + pDelay * 1000 / DgTimer.frameRate : 0;
		return inst;
	}
	
	
}





























