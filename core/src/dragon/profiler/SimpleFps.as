package dragon.profiler
{
	import dragon.core.DgTimer;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * 简化的FPS监视窗口
	 * 主要是用在移动开发上
	 * 
	 * @author Tiago
	 */
	public class SimpleFps extends Sprite
	{
		/**
		 * 刷新显示的间隔（帧数)
		 */
		public static const STEP:int = 8;
		/**
		 * 用于显示消息的文本 
		 */
		private var label:TextField;
		/**
		 * 上次执行的时间
		 */
		private var _preTime:int;
		
		
		/**
		 * 构造 
		 *  
		 * @param pContainer 	显示容器
		 * @param pPosition	显示位置
		 */
		public function SimpleFps(pContainer:DisplayObjectContainer, pPosition:Point = null)
		{
			mouseChildren = mouseEnabled = false;
			pContainer.addChild(this);
			
			label 		= new TextField();
			label.width = 200;
			addChild(label);
			
			!pPosition && ( pPosition = new Point(20, 20) ) ;
			_preTime 	= getTimer();
			x 			= pPosition.x;
			y 			= pPosition.y;
			DgTimer.add(onEnterFrame, STEP);
		}
		
		private function onEnterFrame():void
		{	
			var curTime:int;
			curTime = getTimer();
			label.htmlText = '<font color="#FF0000" size="16"> FPS: ' + int( 1000 / ( (curTime - _preTime) / STEP ) ) + '</font>\n' +
							 '<font color="#FF0000" size="16"> INTERVAL: ' + int((curTime - _preTime) / STEP ) + '</font>\n' + 
						 	 '<font color="#FF0000" size="16"> MEMORY: ' + int(System.totalMemory/1024/1024) + '</font>';
			_preTime = curTime;
		}
	}
}