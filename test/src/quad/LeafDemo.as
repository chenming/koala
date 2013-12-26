package quad
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import dragon.algorithm.quadtree.DgIQuadTreeLeaf;
	import dragon.algorithm.quadtree.DgQuadTreeNode;
	import dragon.algorithm.quadtree.DgQuadtree;
	import dragon.core.DgMath;
	import dragon.core.DgTimer;
	
	
	/**
	 * Leaf Node Demo
	 * implements DgIQuadTreeLeaf interface
	 * 
	 * @author tiago
	 */
	internal class LeafDemo extends Shape implements DgIQuadTreeLeaf
	{
		private static const _SELECT_FILGER:Array	= [new GlowFilter(0xFF0000, 1, 20, 20)];
		/**
		 * tree instance, call _tree.update(this) when position update 
		 */
		private var _tree:DgQuadtree;
		/**
		 * node reference 
		 */
		private var _noder:DgQuadTreeNode;
		/**
		 * move direction
		 */
		private var _dict:Point;
		
		
		public function LeafDemo( pParent:Sprite, pTree:DgQuadtree )
		{
			super();
			
			_tree 			= pTree;
			_dict 			= new Point( DgMath.random(-4, 4), DgMath.random(-4, 4) );
			graphics.beginFill(0xCCBBAA);
			graphics.drawRect(-5, -5, 10, 10);
			graphics.endFill();
			pParent.addChild( this );
			DgTimer.add( onEnterFrame );
		}
		
		public function set selected( pVal:Boolean ):void
		{
			this.filters = pVal? _SELECT_FILGER : null;	
		}
		
		public function get qtX():Number
		{
			return x;
		}
		
		public function get qtY():Number
		{
			return y;
		}
		
		public function set node(pVal:DgQuadTreeNode):void
		{
			_noder = pVal;
		}
		
		public function get node():DgQuadTreeNode
		{
			return _noder;
		}
		
		private function onEnterFrame( ):void
		{
			x += _dict.x;
			y += _dict.y;
			if( x < 0 || y < 0 || x > QuadDemo.SCREEN_WIDTH || y > QuadDemo.SCREEN_HEIGHT ) 
			{
				_dict 	= new Point( DgMath.random(-4, 4), DgMath.random(-4, 4) );
				x 		= DgMath.random( 10, QuadDemo.SCREEN_WIDTH );
				y 		= DgMath.random( 10, QuadDemo.SCREEN_HEIGHT );
				return;
			}
			_tree.updateNode( this );
		}
		
		
		
	}
}