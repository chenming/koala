package  dragon.algorithm.rpn
{
	internal class DgDot
	{
		/**
		 * 若为叶子节点，则存储值 
		 */
		public var nvalue:Number;
		
		/**
		 * 左子节点 
		 */
		private var _leftChild:DgDot;
		
		/**
		 * 右子节点 
		 */
		private var _rightChild:DgDot;
		
		/**
		 * 操作符 
		 */
		public var _op:int
		
		/**
		 * 标识是否为逻辑运算符号 
		 */
		public var isLogic:Boolean;
		
		/**
		 * 构造 
		 */		
		public function DgDot()
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
		 * @param pLeftnode 左子节点(表达式中后一个参数)
		 * @param pRightnode 右子节点
		 */
		public function operate( pOp:int, pLeftnode:DgDot, pRightnode:DgDot ):void
		{
			_op = pOp;
			_leftChild = pLeftnode;
			_rightChild = pRightnode;
		}
		
		/**
		 * 计算返回本节点数值
		 */
		public function getvalue():void
		{
			var num:Number;
			var bol:Boolean;
			
			if( isLogic ){
				bol = _op == 31 ? _rightChild.nvalue > _leftChild.nvalue :
					_op == 32 ? _rightChild.nvalue >= _leftChild.nvalue :
					_op == 33 ? _rightChild.nvalue < _leftChild.nvalue :
					_op == 24 ? _rightChild.nvalue <= _leftChild.nvalue :
					_op == 35 ? _rightChild.nvalue != _leftChild.nvalue :
					_op == 21 ? _rightChild.nvalue && _leftChild.nvalue :
					_op == 22 ? _rightChild.nvalue || _leftChild.nvalue :
					_op == 36 ? _rightChild.nvalue == _leftChild.nvalue :
					_op == 41 ? !_leftChild.nvalue : undefined;
				nvalue = bol ? 1 : 0 ; 
				return;
			}
			
			num = _op == 51 ? _rightChild.nvalue + _leftChild.nvalue :
				_op == 52 ? _rightChild.nvalue - _leftChild.nvalue :
				_op == 61 ? _rightChild.nvalue * _leftChild.nvalue :
				_op == 62 ? _rightChild.nvalue / _leftChild.nvalue :
				_op == 63 ? _rightChild.nvalue % _leftChild.nvalue :
				_op == 71 ? 0 - _leftChild.nvalue :
				_op == 72 ? Math.floor( _leftChild.nvalue ) :
				_op == 73 ? Math.ceil( _leftChild.nvalue ) :
				_op == 81 ? Math.pow(_rightChild.nvalue , _leftChild.nvalue) : NaN;
			nvalue = num ; 
			
		}
		/**
		 * 如果后缀表达式为纯数值计算，则不加入逻辑符号判断 
		 */
		public function getPureValue():void
		{
			nvalue = _op == 51 ? _rightChild.nvalue + _leftChild.nvalue :
				_op == 52 ? _rightChild.nvalue - _leftChild.nvalue :
				_op == 61 ? _rightChild.nvalue * _leftChild.nvalue :
				_op == 62 ? _rightChild.nvalue / _leftChild.nvalue :
				_op == 63 ? _rightChild.nvalue % _leftChild.nvalue :
				_op == 71 ? 0 - _leftChild.nvalue :
				_op == 72 ? Math.floor( _leftChild.nvalue ) :
				_op == 73 ? Math.ceil( _leftChild.nvalue ) :
				_op == 81 ? Math.pow(_rightChild.nvalue , _leftChild.nvalue) : NaN;
		}
		
		
		
	}
}