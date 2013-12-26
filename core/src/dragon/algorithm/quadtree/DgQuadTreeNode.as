package dragon.algorithm.quadtree
{
	import dragon.core.DgRectangle;
	
	import flash.geom.Point;
	
	
	/**
	 * 4叉树节点
	 * 
	 * @author Tiago
	 */
	public class DgQuadTreeNode
	{	
		/**
		 * 当前节点深度
		 */
		public var deep:int;
		/**
		 * 标识属于四叉中个哪个位置，用于调试
		 */
		public var idx:int;
		/**
		 * 当前节点所包含的区域
		 */
		public var rect:DgRectangle;
		/**
		 * 当前节点的子节点列表
		 */
		public var childList:Vector.<DgQuadTreeNode>;
		/**
		 * 叶子节点中所存放的叶子列表
		 * 叶子是指实现 IQuadTreeLeaf 接口的对象
		 */
		public var leafList:Vector.<DgIQuadTreeLeaf>;
		/**
		 * 对象缓存
		 * 为避免搜索中递归调用时使用同一个对象造成的冲突， 
		 * 该属性不能设置为静态属性
		 */
		private var _cachePoint:Point;
		
		
		/**
		 * 构造
		 * 注：子树的生成并没有做成动态的， 这是因为动态树的实现效率并不会更高， 尤其在更新叶子的时候
		 * 而且动态生成的树需要实时监听叶子的情况，用以回收叶子为空的树， 在实现上相当麻烦
		 * 
		 * 
		 * @param pRect		当前节点包含的矩形区域
		 * @param pMyDeep		当前节点的深度
		 * @param pMaxDeep	允许的最大深度
		 * @param pIdx			当前节点属于4叉中的哪叉
		 */
		public function DgQuadTreeNode( pRect:DgRectangle, pMyDeep:int, pMaxDeep:int, pIdx:int )
		{
			rect 			= pRect;
			idx				= pIdx;
			deep			= pMyDeep;
			_cachePoint	= new Point();
			if( pMyDeep == pMaxDeep ) {
				leafList		= new Vector.<DgIQuadTreeLeaf>();
				// 以下代码吗仅仅用来调试
//				TouchTest.inst.graphics.beginFill(DgMath.randRange(0, 0xFFFFFF));
//				TouchTest.inst.graphics.drawRect( pRect.x, pRect.y, pRect.w, pRect.h );
//				TouchTest.inst.graphics.endFill();
				return;
			}
			childList		= new Vector.<DgQuadTreeNode>();
			childList[0]	= new DgQuadTreeNode( new DgRectangle(rect.x, rect.y, rect.w_1_2, rect.h_1_2), deep + 1, pMaxDeep, 1 );
			childList[1]	= new DgQuadTreeNode( new DgRectangle(rect.x + rect.w_1_2, rect.y, rect.w_1_2, rect.h_1_2), deep + 1, pMaxDeep, 2 );
			childList[2]	= new DgQuadTreeNode( new DgRectangle(rect.x, rect.y + rect.h_1_2, rect.w_1_2, rect.h_1_2), deep + 1, pMaxDeep, 3 );
			childList[3]	= new DgQuadTreeNode( new DgRectangle(rect.x + rect.w_1_2, rect.y + rect.h_1_2, rect.w_1_2, rect.h_1_2), deep + 1, pMaxDeep, 4 );
		}
		
		
		/**
		 * 向当前节点添加叶子
		 * 注：当前节点必须是叶子节点
		 * 
		 * @param pLeaf 叶子
		 */
		public function addLeaf( pLeaf:DgIQuadTreeLeaf ):void
		{
			if( !isLeafNode ) {
				trace( '4叉树添加叶子错误，尝试将叶子插入到非最深层次的节点中，该叶子节点将被抛弃' ); 
				return;
			}
			leafList.push( pLeaf );
			pLeaf.node = this;
		}
		
		/**
		 * 移除叶子
		 * 
		 * @param pLeaf 叶子
		 */
		public function removeLeaf( pLeaf:DgIQuadTreeLeaf ):void
		{
			if( !isLeafNode ) {
				trace( '4叉树删除叶子错误，尝试将叶子从非最深层次的节点中移除' ); 
				trace( pLeaf.qtX, pLeaf.qtY );
				return;
			}
			
			if( -1 == leafList.indexOf( pLeaf ) ) {
				trace( '4叉树删除叶子错误，叶子不在当前节点中' ); 
				return;
			}
			
			leafList.splice( leafList.indexOf( pLeaf ), 1 );
			pLeaf.node = null;
		}
		
		
		
		/**
		 * 根据位置信息，获取响应的叶子节点
		 * 
		 * @param pPos		位置信息
		 * @param pNode	开始搜索的节点
		 */
		public function getLeafNodeByPos( pPos:Point, pNode:DgQuadTreeNode ):DgQuadTreeNode
		{
			var child:DgQuadTreeNode, res:DgQuadTreeNode;
			
			if( !pNode.rect.containsPoint( pPos ) ) {
				return null;
			}
			
			if( pNode.isLeafNode ) {
				return pNode;
			}
			
			for each( child in pNode.childList ) {
				if( (res = getLeafNodeByPos( pPos, child )) != null ) {
					return res;
				}
			}
			
			return null;
		}
		
		
		/**
		 * 判断当前节点是否是叶子节点
		 */
		public function get isLeafNode():Boolean
		{
			return  leafList? true : false;
		}
		
		
		
		/**
		 * 从当前节点开始搜索满足条件的所有叶子
		 * 
		 * @param pRect 搜索区域
		 * @return 返回搜索区域内的节点列表， 如果没有满足条件的叶子， 返回列表的长度为0
		 */
		public function searchNode( pRect:DgRectangle ):Vector.<DgIQuadTreeLeaf>
		{
			var a_node:Vector.<DgIQuadTreeLeaf>, b_node:Vector.<DgIQuadTreeLeaf>;
			var c_node:Vector.<DgIQuadTreeLeaf>, d_node:Vector.<DgIQuadTreeLeaf>;
			
			
			if( !rect.intersects( pRect ) ) {
				return new Vector.<DgIQuadTreeLeaf>;
			}
			
			if( isLeafNode ) {
				return getLeafByRect( pRect );
			}
			a_node = childList[0].searchNode( pRect );
			b_node = childList[1].searchNode( pRect );
			c_node = childList[2].searchNode( pRect );
			d_node = childList[3].searchNode( pRect );
			return a_node.concat( b_node, c_node, d_node );
		}
		
		
		
		/**
		 * 从叶子节点中获取满足条件的叶子列表
		 * 
		 * @param pRect 搜索区域
		 * @return 返回搜索区域内的节点列表， 如果没有满足条件的叶子， 返回列表的长度为0
		 */
		private function getLeafByRect( pRect:DgRectangle ):Vector.<DgIQuadTreeLeaf>
		{
			var leaf:DgIQuadTreeLeaf;
			var res:Vector.<DgIQuadTreeLeaf>;
			
			if( pRect.containsRect( rect ) ) {
				return leafList.concat( );
			}
			
			res	= new Vector.<DgIQuadTreeLeaf>;
			for each( leaf in leafList ) {
				_cachePoint.x = leaf.qtX;
				_cachePoint.y = leaf.qtY;
				if( pRect.containsPoint( _cachePoint ) ) {
					res.push( leaf );
				}
			}
			
			return res;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}