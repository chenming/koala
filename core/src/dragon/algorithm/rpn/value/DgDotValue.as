package dragon.algorithm.rpn.value
{
	internal class DgDotValue
	{
		/**
		 * 若为叶子节点，则存储值 
		 */
		public var nvalue:Number;
		
		/**
		 * 左子节点 
		 */
		private var _leftChild:DgDotValue;
		
		/**
		 * 右子节点 
		 */
		private var _rightChild:DgDotValue;
		
		/**
		 * 操作符 
		 */
		public var _op:int
		
		/**
		 * 构造 
		 */
		public function DgDotValue()
		{
		}
		
		/**
		 * 设置操作数
		 *  
		 * @param pValue 操作数
		 */
		public function set value( pValue:Number ):void
		{
				nvalue = pValue;
		}
		
		/**
		 * 设置操作符号节点
		 *  
		 * @param pCb 计算函数
		 * @param p_leftnode 左子节点
		 * @param p_rightnode 右子节点
		 */
		public function operate( pOp:int, p_leftnode:DgDotValue, p_rightnode:DgDotValue ):void
		{
			_op = pOp;
			_leftChild = p_leftnode;
			_rightChild = p_rightnode;
		}
		
		/**
		 * 计算返回本节点数值
		 */
		public function getvalue():void
		{
			nvalue = _op == 21 ? _rightChild.nvalue + _leftChild.nvalue :
				_op == 22 ? _rightChild.nvalue - _leftChild.nvalue :
				_op == 31 ? _rightChild.nvalue * _leftChild.nvalue :
				_op == 32 ? _rightChild.nvalue / _leftChild.nvalue :
				_op == 33 ? _rightChild.nvalue % _leftChild.nvalue :
				_op == 41 ? 0 - _leftChild.nvalue :
				_op == 42 ? Math.floor( _leftChild.nvalue ) :
				_op == 43 ? Math.ceil( _leftChild.nvalue ) :
				_op == 51 ? Math.pow(_rightChild.nvalue , _leftChild.nvalue) : NaN;
			
		}
		
		
		
		
		
	}
}