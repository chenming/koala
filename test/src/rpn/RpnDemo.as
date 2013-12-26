package rpn
{
	import flash.display.Sprite;
	
	import dragon.algorithm.rpn.DgRpn;
	import dragon.core.DgString;
	import dragon.ui.fte.DgTextField;
	
	public class RpnDemo extends Sprite
	{
		
		[SWF(width="800", height="600", frameRate="60", backgroundColor="#222222")]
		public function RpnDemo()
		{ 
			var expr:DgRpn;
			 
			super();
			
			expr	= new DgRpn('1 + 2 - 3 * 4 / 5 ');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('3 ^ ( 1 + 1 )');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('15 % 2');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('[0.3');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn(']0.3');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('100 > 10');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('10 > 100');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('10 == 100');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('100 == 100');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('0 || 1');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('0 && 1');
			showExpr(expr.expresstion, expr.calculate() );
			
			expr	= new DgRpn('a * x + 3');
			showExpr(expr.expresstion, expr.calculateByObj({a : 3, x : 6}));
			
			expr	= new DgRpn('a * x + 3');
			showExpr(expr.expresstion, expr.calculateByFunc( function( pCh:String ):Number{
				if( pCh == 'a' )
					return 10;
				if( pCh == 'x' )
					return 100;
				return 0;
			}));
		}
		
		
		private function showExpr( pExpr:String, pVal:Number ):void
		{
			var lb:DgTextField;
			
			lb		= new DgTextField;
			lb.y	= numChildren * 30;
			lb.text	= DgString.substitute( 
				'<font size="20" color="#FF">{0}</font>' +
				'<font size="20" color="#FF0000"> = </font>' +
				'<font size="20" color="#FF00FF">{1}</font>', 
				pExpr, 
				pVal );
			addChild( lb );
		}
		
		
		
		
		
	}
}