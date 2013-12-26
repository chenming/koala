package dragon.algorithm.quadtree
{
	/**
	 * 四叉搜索树叶子接口
	 * 改接口定义了叶子需要提供的方法，
	 * 任何需要使用四叉树的进行搜索的类， 都必须实现改接口
	 * 
	 * @author Tiago
	 */
	public interface DgIQuadTreeLeaf
	{
		/**
		 * 获取对象当前x坐标
		 */
		function get qtX():Number;
		
		/**
		 * 获取对象当前y坐标
		 */
		function get qtY():Number;
		
		/**
		 * 保持当前对象所属节点
		 * 具体实现类， 只要定义一个属性， 
		 * 在 set 方法被调用时保存pVal， 并在 get方法被调用时返回即可
		 */
		function set node( pVal:DgQuadTreeNode ):void
			
		/**
		 * 获取对象当前所属节点
		 */
		function get node():DgQuadTreeNode;
		
	}
}