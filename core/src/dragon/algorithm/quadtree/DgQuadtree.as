package dragon.algorithm.quadtree
{
	import dragon.core.DgRectangle;
	
	import flash.geom.Point;
	
	/**
	 * 4搜索叉树
	 * 主要用于快速搜索游戏地图上指定范围内的对象
	 * 
	 * @author Tiago
	 */
	public class DgQuadtree
	{
		
		/**
		 * 四叉树根节点
		 */
		private var _rootNode:DgQuadTreeNode;
		/**
		 * 位置缓存
		 */
		private var _cachePos:Point;
		
		/**
		 * 构造
		 * 
		 * @param pWw		世界区域的宽
		 * @param pWh 		世界区域的高
		 * @param pDeep		树的深度， 树的深度， 决定了叶子节点的数量，通常情况下， 改值不应该大于6
		 */
		public function DgQuadtree( pWorldWidth:int, pWorldHeight:int, pDeep:int = 4 )
		{
			_rootNode 	= new DgQuadTreeNode( new DgRectangle(0, 0, pWorldWidth, pWorldHeight), 0, pDeep, 0 );
			_cachePos	= new Point();
		}
		
		/**
		 * 向树中添加叶子
		 */
		public function pushLeaf( pLeaf:DgIQuadTreeLeaf ):void
		{
			var leaf_node:DgQuadTreeNode;
			_cachePos.x 	= pLeaf.qtX;
			_cachePos.y 	= pLeaf.qtY;
			leaf_node 		= _rootNode.getLeafNodeByPos( _cachePos, _rootNode );
			if( !leaf_node ) 
			{
				trace( '添加节点失败， getLeafNodeByPos 方法返回空: ', pLeaf, pLeaf.qtX, pLeaf.qtY);
				return;
			}
			
			leaf_node.addLeaf( pLeaf );
		}
		
		
		/**
		 * 从树中移除叶子
		 */
		public function removeNode( pLeaf:DgIQuadTreeLeaf ):void
		{
			if( !pLeaf.node ) {
				return;
			}
			
			pLeaf.node.removeLeaf( pLeaf );
		}
		
		
		/**
		 * 刷新叶子（叶子的坐标发生了变化）
		 * 改函数可以用来替换pushLeaf，因为改方法在叶子为加入树前， 会自动将其加入
		 */
		public function updateNode( pLeaf:DgIQuadTreeLeaf ):void
		{
			if( !pLeaf.node ) 
			{
				pushLeaf( pLeaf );
				return;
			}
			_cachePos.x 	= pLeaf.qtX;
			_cachePos.y 	= pLeaf.qtY;
			
			if( pLeaf.node.rect.containsPoint( _cachePos ) ) 
			{
				return;
			}
			
			pLeaf.node.removeLeaf( pLeaf );
			pushLeaf( pLeaf );
		}
		
		
		
		/**
		 * 搜索矩形范围内所有的叶子
		 * 
		 * @param pRect	按钮
		 * @param pMax	最大数量， 默认不限制
		 * @return 返回满足条件的叶子列表，  如果为空，那么返回的列表长度为0
		 */
		public function searchRect( pRect:DgRectangle, pMax:int = -1 ):Vector.<DgIQuadTreeLeaf>
		{
			var res:Vector.<DgIQuadTreeLeaf> =  _rootNode.searchNode( pRect );
			
			if( pMax != -1 && res.length > pMax ) 
			{
				res.splice( pMax - 1, res.length - pMax );
			}
			
			return res;
		}
		
		
		/**
		 * 搜索圆形范围内的所有叶子
		 * 
		 * @param p_center	圆心
		 * @param p_radius	半径
		 * @param pMax		最大数量
		 * @return 返回满足条件的叶子列表，  如果为空，那么返回的列表长度为0
		 */
		public function searchCircle( p_center:Point, p_radius:int, pMax:int = -1 ):Vector.<DgIQuadTreeLeaf>
		{
			var rect_res:Vector.<DgIQuadTreeLeaf>, circle_res:Vector.<DgIQuadTreeLeaf>;
			var rect:DgRectangle;
			var leaf:DgIQuadTreeLeaf;
			
			rect 		= new DgRectangle(p_center.x - p_radius, p_center.y - p_radius, p_center.x + p_radius * 2, p_center.y + p_radius * 2 );
			rect_res 	= searchRect( rect, pMax != -1? pMax * 1.3 : pMax );
			if( !rect_res.length ) 
			{
				return rect_res;
			}
			
			circle_res	= new Vector.<DgIQuadTreeLeaf>;
			for each( leaf in rect_res ) {
				_cachePos.x = leaf.qtX;
				_cachePos.y = leaf.qtY;
				if( Point.distance( p_center, _cachePos ) <= p_radius ) 
				{
					circle_res.push( leaf );
					if( pMax != -1 && circle_res.length == pMax ) 
					{
						break;
					}
				}
			}
			return circle_res;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}