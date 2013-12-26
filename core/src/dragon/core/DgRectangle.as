package dragon.core 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 轻量级矩形类
	 */
	public class DgRectangle
	{
		public var x:Number, y:Number, w:Number, h:Number;
		// 常用矩形宽高比
		public var w_1_2:Number, w_3_4:Number;
		public var h_1_2:Number, h_3_4:Number;
		
		public function DgRectangle(pX:Number = 0, pY:Number = 0, pW:Number = 0, pH:Number = 0) 
		{
			x		= pX;
			y 		= pY;
			w 		= pW;
			h 		= pH;
			w_1_2 	= w * 0.5;
			w_3_4	= w * 0.75;
			h_1_2	= h * 0.5;
			h_3_4	= h * 0.75;
		}
		
		
		/**
		 * 实现和 Rectangle 的快速转换
		 */
		public function get rectangle():Rectangle
		{
			return new Rectangle(x, y, w, h);
		}
		
		
		/**
		 * 检测当前矩形是否和参数定义的矩形是否相交
		 * 通常将这个函数用于碰撞检测
		 * 
		 * @param	pRect	需要检测的其他矩形
		 */
		final public function intersects(pRect:DgRectangle) : Boolean
		{
			return !( x > pRect.x + pRect.w ||
					  y > pRect.y + pRect.h ||
					  x + w < pRect.x		 ||
					  y + h < pRect.y );
		}
		
		/**
		 * 检查是否和参数矩形的一半相交
		 */
		public function intersectsHalf( pRect:DgRectangle ) : Boolean
		{
			return !( x > pRect.x + pRect.w_3_4 ||
					  y > pRect.y + pRect.h_3_4 ||
					  x + w < pRect.x + pRect.w_1_2  ||
					  y + h < pRect.y + pRect.h_1_2  );
		}
		
		public function clone() : DgRectangle
		{
			return new DgRectangle(x, y, w, h);
		}
		
		
		
		/**
		 * 矩形区域内是否包含指定的点
		 */
		public function containsPoint(pPoint:Point) : Boolean
		{
			return !(pPoint.x < x	|| pPoint.x > x + w || pPoint.y < y || pPoint.y > y + h);
		}
		
		/**
		 * 判断参数指定的矩形， 是否被当前矩形完全包围
		 */
		public function containsRect(pRect:DgRectangle):Boolean
		{
			return ( x <= pRect.x &&
					 y <= pRect.y &&
					 x + w >= pRect.x + pRect.w &&
					 y + h >= pRect.y + pRect.h );
		}
		
		
		public function toString() : String
		{
			return 'DgRectangle : x = ' + x + ', y = ' + y + ', w = ' + w + ', h = ' + h;
		}
	}

}