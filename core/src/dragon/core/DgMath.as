package dragon.core
{
	import flash.geom.Point;

	/**
	 * 封装常用数学类
	 *  
	 * @author Tiago
	 */
	public class DgMath
	{
		/**
		 * 一角度的弧度值
		 */
		public static const ONE_RADIAN:Number = Math.PI / 180;
		
		/**
		 * 角度转换为弧度
		 */
		public static function angle2Radian( pVal:Number ):Number
		{
			return pVal * Math.PI / 180;
		}
		
		/**
		 * 将角度转换成弧度 
		 */		
		public static function radian2Angle( pVal:Number ):Number
		{
			return pVal * 180 / Math.PI;
		}
		
		/**
		 * 随机生成一个介于min和max之间的数
		 */
		public static function random(min:int, max:int):int 
		{
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
		
		
		/**
		 * 保留浮点数小数点后几位
		 */
		public static function toFixed( pNum:Number, pLen:int ):Number
		{
			return Number( pNum.toFixed(pLen) );
		}
		
		/**
		 * 判断点是否在线段上
		 * 如判定点处于两个线段的端点，也判定为在线段上
		 * 
		 * @param p_line_a 线段A点
		 * @param p_line_b 线段B点
		 * @param pC 需要进行判断的点
		 */		
		public static function pointInLine( pLineA:Point, pLineB:Point, pC:Point ):Boolean
		{
			if( pLineA.equals(pC) || pLineB.equals(pC) ) {
				return true;
			}
			
			return !xMult( pC, pLineA, pLineB ) &&
				(pLineA.x - pC.x) * ( pLineB.x - pC.x ) <= 0 &&
				(pLineA.y - pC.y) * ( pLineB.y - pC.y ) <= 0;
		}
		
		/**
		 * 判断点和线段的差乘
		 *  
		 * @param pA 外部一个点
		 * @param pB 线段上A点
		 * @param pC 线段上B点
		 */		
		public static function xMult( pA:Point, pB:Point , pC:Point ):Number
		{
			return (pA.x - pC.x) * (pB.y - pC.y) - (pA.y - pC.y) * (pB.x - pC.x);
		}
		
		/**
		 * 根据相对坐标，获取点的相对象限
		 * 注意，当两点的X坐标相同时，会被判定在第1或第4象限
		 *  
		 * @param p_center 相对中心点
		 * @param pPoint 进行比较的点
		 */		
		public static function getArea(p_center:Point, pPoint:Point):int
		{
			var tmpX:int = pPoint.x - p_center.x;
			var tmpY:int = pPoint.y - p_center.y;
			
			return tmpX >= 0 ? ( tmpY >= 0 ? 1 : 4 ) : ( tmpY >= 0 ? 2 : 3 );
		}
		

		/**
		 * 根据圆和圆外一点， 求圆周上的点
		 * 
		 * @param pA		圆外的点
		 * @param pB		圆心
		 * @param p_r		半径
		 * @param p_inner	true：返回在p_a和p_b之间的点， 否则返回另一个方向上的焦点
		 * @return	需要求的点
		 */
		public static function pointAndCircle( pA:Point, pB:Point, p_r:int, p_inner:Boolean = true):Point
		{
			var d:Number = Math.atan( ( pA.y - pB.y ) / ( pA.x - pB.x ) );
			return new Point(
				(p_inner? 1 : -1) * p_r * Math.cos( d ) + pB.x,
				(p_inner? 1 : -1) * p_r * Math.sin( d ) + pB.y
			);
		}
		
		
		/**
		 * 根据圆和圆外一点， 求切点
		 * 
		 * @param pA		圆外的点
		 * @param pB		圆心
		 * @param p_r		半径
		 * @param p_d		方向（1：左边切点，0：右边切点)
		 * @return	需要求的切点
		 */
		public static function tangentPoint( pA:Point, pB:Point, p_r:Number, p_d:int = 0 ):Point
		{
			var alpha:Number;

			alpha 	= p_d?
				Math.atan( (pB.y - pA.y) / (pB.x - pA.x) ) + Math.acos( p_r / Point.distance( pA, pB ) ):
				Math.atan( (pB.y - pA.y) / (pB.x - pA.x) ) - Math.acos( p_r / Point.distance( pA, pB ) );
			
			return new Point(
				pB.x + p_r * Math.cos( alpha ),
				pB.y + p_r * Math.sin( alpha )
			);
		}
		
		
		/**
		 * 计算点到直线的垂直点
		 *  
		 * @param pA	直线端点1
		 * @param pB	直线端点2
		 * @param pC	线外一点
		 */
		public static function verticalPoint( pA:Point, pB:Point, pC:Point ):Point
		{
			var k:Number, x:Number;
			
			if( pA.x == pB.x ) {
				return new Point( pA.x, pC.y );
			}
			
			if( pA.y == pB.y ) {
				return new Point (pC.x, pA.y );
			}
			
			k = (pA.y - pB.y) / (pA.x - pB.x);
			x = ( k * k * pA.x + k * ( pC.y - pA.y) + pC.x ) / ( k * k  + 1);
			return new Point( x, k * ( x - pA.x) + pA.y );
		}
		
		
		/**
		 * 判断点是否在指定的矩形范围之内
		 * 矩形的所在区域由两个点确定
		 *  
		 * @param pA	矩形顶点1
		 * @param pB	矩形顶点2
		 * @param pC	需要判断的点
		 */
		public static function pointInRect( pA:Point, pB:Point, pC:Point ):Boolean
		{
			if(  Math.min( pA.x, pB.x ) <= pC.x &&
				 Math.max( pA.x, pB.x ) >= pC.x &&
				 Math.min( pA.y, pB.y ) <= pC.y &&
				 Math.max( pA.y, pB.y ) >= pC.y ) {
				return true;
			}
			
			return false;
		}
		
		
		
		/**
		 * 根据三个点， 得到夹角
		 * 夹角为角ABC
		 * 返回弧度
		 */
		public static function getAngleBy3Point( pA:Point, pB:Point, pC:Point ):Number
		{
			var a:Number, b:Number, c:Number, r:Number;
			
			a = Point.distance( pB, pC );
			b = Point.distance( pA, pC );
			c = Point.distance( pA, pB );
			r = Math.acos( (a*a + c*c - b*b)/(2*a*c) );
			pA.y > pC.y && ( r = -r );
			return r;
		}
		
		
		/**
		 * 得到一个点进行坐标轴旋转后的新坐标
		 * 新坐标将覆盖原有坐标
		 *  
		 * @param pPoint 原坐标点
		 * @param pDegree 需要旋转的弧度
		 */		
		public static function pointRotate(pPoint:Point, pDegree:Number):void
		{
			var r:Number = getDist(0, 0, pPoint.x, pPoint.y);
			pPoint.x = r * Math.cos( pDegree );
			pPoint.y = r * Math.sin(pDegree);
		}
		
		
		/**
		 * 提供另一种参数的获取两点距离的方法 
		 */
		public static function getDist( pX1:int, pY1:int, pX2:int, pY2:int ):int
		{
			return Math.sqrt( (pX1 - pX2) * (pX1 - pX2) + (pY1 - pY2) * (pY1 - pY2) );
		}
		
		
		
		
		
		
		
		
	}
}