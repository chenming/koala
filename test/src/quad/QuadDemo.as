package quad
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import dragon.algorithm.quadtree.DgIQuadTreeLeaf;
	import dragon.algorithm.quadtree.DgQuadtree;
	import dragon.core.DgRectangle;
	import dragon.core.DgTimer;
	import dragon.profiler.SimpleFps;
	
	/**
	 * Quad Search Tree Demo
	 * QST could find roles in the map so quick
	 *  
	 * @author tiago
	 */
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#222222")]
	public class QuadDemo extends Sprite
	{
		/**
		 * how many nodes used to test 
		 */
		public static const NODE_CNT:int		= 1000;
		/**
		 * screen width 
		 */
		public static const SCREEN_WIDTH:int	= 800;
		/**
		 * screen height
		 */
		public static const SCREEN_HEIGHT:int	= 600;
		/**
		 * hit test width 
		 */
		public static const HIT_TEST_WIDTH:int	= 100;
		/**
		 * hit test height
		 */
		public static const HIT_TEST_HEIGHT:int	= 100;
		
		
		/**
		 * stage instance 
		 */
		public static var inst:QuadDemo;
		/**
		 * quad tree instance 
		 */
		private var _quadTree:DgQuadtree;
		/**
		 * hit nodes preframe
		 */
		private var _preSelected:Vector.<DgIQuadTreeLeaf>;
		/**
		 * hit test border graphic
		 */
		private var _border:Shape;
		/**
		 * hit test rectangle 
		 */
		private var _hitRect:DgRectangle;
		
		
		
		public function QuadDemo()
		{
			super();
			stage? init(null) : addEventListener( Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init( pEvt:Event ):void
		{
			var idx:int;
			var leaf:LeafDemo;
			
			DgTimer.frameRate 	= stage.frameRate;
			inst				= this;
			_hitRect			= new DgRectangle(mouseX, mouseY, HIT_TEST_WIDTH, HIT_TEST_HEIGHT);
			_quadTree 			= new DgQuadtree(SCREEN_WIDTH, SCREEN_HEIGHT);
			
			for( idx = NODE_CNT; idx > 0; --idx ) 
			{
				_quadTree.pushLeaf( new LeafDemo( this, _quadTree ) );
			}
			
			_border = new Shape();
			_border.graphics.beginFill(0xAABCBC, 0.5);
			_border.graphics.drawRect(0, 0, HIT_TEST_WIDTH, HIT_TEST_HEIGHT);
			_border.graphics.endFill();
			addChild( _border );
			
			DgTimer.add( onEnterFrame );
			new SimpleFps( this );
			pEvt && removeEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		
		private function onEnterFrame( ):void
		{
			var curSlected:Vector.<DgIQuadTreeLeaf>;
			var leaf:LeafDemo;
			var preTime:int;
			
			_border.x 	= _hitRect.x = mouseX;
			_border.y 	= _hitRect.y = mouseY;
			preTime		= getTimer();
			curSlected	=  _quadTree.searchRect( _hitRect );
			trace( 'use: ', getTimer() - preTime + ' ms' );
			
			for each( leaf in _preSelected ) 
			{
				leaf.selected = false;
			}
			
			for each( leaf in curSlected)
			{
				leaf.selected = true;
			}
			
			_preSelected = curSlected
		}
		
		
		
		
	}
}