package dragon.algorithm.rpn 
{
	
	/**
	 * 转换中缀逻辑表达式为后缀表达式，并提供计算接口
	 * 当表达式包含逻辑运算时，返回值为0（false），1(true)
	 * 
	 * DgRpn 类包含了与 DgRpnValue 完全相同的函数接口
	 * 同时可以实现  ：  纯数值（DgRpnValue）计算 、 逻辑运算、混合计算的功能
	 * 因为要识别更多的操作符，所以在初始化的时候会花费更多的时间做判断
	 * 若需要初始化大量纯数值计算的表达式为，建议直接使用DgRpnValue
	 * 
	 */
	public class DgRpn
	{
		
		
		/**
		 * 操作符临时堆栈 
		 */
		private var _oprateArr:Vector.<int> = new Vector.<int>();
		/**
		 * 缓存操作符，用于保存多符号运算符 
		 */
		private var _tempOp:String = '';
		/**
		 * 缓存数值字符 ,用于保存长字符串变量
		 */
		private var _tempNum:String = '';
		
		/**
		 * 判断上一个操作符号是否为')' 
		 */
		private var _lastRight:Boolean;
		/**
		 * 输入数据临时存放数组 
		 */
		private var _srcArr:Array = [];
		/**
		 * 运算操作符堆栈栈顶标识临时存放 
		 */
		private var topOpe:int = 0;
		
		/**
		 * 操作堆栈长度 
		 */
		private var _len:int = 0;
		/**
		 * dot节点临时堆栈 
		 */
		private var _nodeArr:Vector.<DgDot> = new Vector.<DgDot>();
		
		/**
		 * 存储需要替换的变量 
		 */
		private var _xyz:Object = {};
		
		/**
		 * 存放表达式 
		 */
		private var _srcFormula:String;
		/**
		 * 标记表达式中是否含有逻辑运算 
		 */
		private var _consitLogic:Boolean;
		
		//========================================================================
		
		/**
		 * 操作符最终节点，用于存放计算结果 
		 */
		private var _rootNode:DgDot;
		
		/**
		 * 按照计算优先级存放操作符号节点，在计算时候 按照顺序遍历该容器内的子节点 
		 */
		private var _opDot:Vector.<DgDot> = new Vector.<DgDot>();
		
		
		
		/**
		 * 操作符节点数
		 */
		private var _opLen:int;
		
		/**
		 * 构造
		 *  
		 * @param pCh 输入中缀表达式
		 */
		public function DgRpn( pCh:String )
		{
			_srcFormula = pCh;
			convertString( pCh );
			_opLen =  _opDot.length;
		}
		
		/**
		 * 通过传入object 进行计算，object内为'key':1234567,
		 *  
		 * @param pData 传入参数object 用于替换变量符号
		 * @return  返回计算结果
		 */
		public function calculateByObj( pData:Object ):Number
		{
			var key:String;
			var dot:DgDot;
			
			for( key in pData ) {
				if( !pData.hasOwnProperty(key) ){
					trace('不存在变量: '+key);
					return NaN;
				}
				for each( dot in _xyz[key] ){
					dot.value = pData[key];
				}
			}
			return calculate();
		}
		
		/**
		 * 通过：传入函数，用于替换变量符号为数字 计算结果
		 * 表达式中每个非数字变量都会执行该回调函数
		 *  
		 * @param pCb 传入回调函数
		 * @return 返回计算结果
		 */
		public function calculateByFunc( pCb:Function ):Number
		{
			var key:String;
			var dot:DgDot;
			var tempValue:Number;
			
			for ( key in _xyz ){
				tempValue = pCb( key );
				
				for each( dot in _xyz[key] ){
					dot.value = tempValue;
				}
			}
			return calculate();
			
		}
		
		/**
		 * 直接计算结果，表达式中不含用变量符号
		 *  
		 * @return 计算结果 
		 */
		public function calculate():Number
		{
			
			var i:int;
			if( !_consitLogic ){
				for( i = 0; i < _opLen; ++i ){
					_opDot[i].getPureValue();
				}
				
				return _rootNode.nvalue;
			}
			
			
			for( i = 0; i < _opLen; ++i ){
				_opDot[i].getvalue();
			}
			
			return _rootNode.nvalue;
		}
		
		/**
		 * 返回该后缀表达式转换前对应的中缀表达式 
		 */
		public function get expresstion():String
		{
			return _srcFormula;
		}
		
		///////////////////////////////////////////////////////////////////
		
		//////					将中缀表达式转换成为后缀表达式  		//////////////////////
		
		///////////////////////////////////////////////////////////////////
		
		/**
		 * 将中缀表达式转换成为后缀表达式 
		 * 
		 * @param pCh 中缀表达式
		 */
		private function convertString( pCh:String ):void
		{
			var ch:String;
			var key:int;
			
			_srcArr = pCh.split('');
			
			for each ( ch in _srcArr ){
				//    每个字符检测
				compare(ch);
			}
			
			
			saveNum();
			//  输出操作数堆栈中的剩余操作符
			for ( var i:int = _len; i > 0; i-- ){
				var d:int = _oprateArr.pop();
				_len--;
				saveOP(d);
			}
			
		}
		
		
		/**
		 * 比较代码， 主要的计算函数，用于将中缀表达式转换会后缀表达式
		 *  
		 * @param pCh 输入字符
		 */
		private function compare( pCh:String ):void
		{
			var operateKey:int;
			
			if( !_tempOp.length ){
				
				switch( pCh ){
					case ' ':
						return;
					case '+':
						operateKey = 51;
						break;
					case '-':
						if ( _tempNum.length == 0 && !_lastRight){
							_tempNum = '0';
							// 可以将负号当作优先级最高的操作符直接推入
							operateKey = 71;
							break;
						}
						operateKey = 52;
						break;
					case '[':
						_tempNum = '0';
						// 向下取整
						operateKey = 72;
						break;
					case ']':
						_tempNum = '0';
						// 向上取整
						operateKey = 73;
						break;
					case '*':
						operateKey = 61;
						break;
					case '/':
						operateKey = 62;
						break;
					case '%':
						operateKey = 63;
						break;
					case '^':
						operateKey = 81;
						break;
					
					
					case '!':
						catchOp( pCh );
						break;
					case '>':
						catchOp( pCh );
						break;
					case '<':
						catchOp( pCh );
						break;
					case '=':
						catchOp( pCh );
						break;
					case '|':
						catchOp( pCh );
						break;
					case '&':
						catchOp( pCh );
						break;
					
					
					case '(':
						_oprateArr.push( 11 );
						_len++;
						return;
					case ')':
						saveNum();
						findLeft();
						_lastRight = true;
						return;
					default:
						catchNum( pCh );
						return ;
				}
				saveNum();
				_lastRight = false;
				
				if( !_tempOp.length ){
					compareOperate ( operateKey );
				}
				return;
			}else{
				switch( pCh ){
					case ' ':
						return;
					case '=':
						break;
					case '&':
						break;
					case '|':
						break;
					case '-':
						compareOperate ( compareDouble );
						_tempNum = '0';
						saveNum();
						compareOperate ( 71 );
						return;
					case '!':
						compareOperate ( compareDouble );
						_tempNum = '1';
						saveNum( );
						compareOperate ( 41 );
						return;
					case '(':
						compareOperate ( compareDouble );
						_oprateArr.push( 11 );
						_len++;
						return;
					default:
						catchNum( pCh );
						pCh = '';
						break;
				}
				catchOp( pCh );
				
				compareOperate ( compareDouble );
			}
			
		}
		/**
		 * 比较双字符操作符
		 */
		private function get compareDouble( ):int
		{
			var num:int = -1;
			switch( _tempOp ){
				case '>':
					num = 31;
					break;
				case '>=':
					num = 32;
					break;
				case '<':
					num = 33;
					break;
				case '<=':
					num = 34;
					break;
				case '!=':
					num = 35;
					break;
				case '&&':
					num = 21;
					break;
				case '||':
					num = 22;
					break;
				case '==':
					num = 36;
					break;
				case '!':
					_tempNum = '1';
					saveNum( );
					num = 41;
					break;
			}
			_tempOp  = '';
			return num;
		}
		
		/**
		 * 在操作符堆栈中查找左括号
		 * 若不是'('，则将栈顶操作符添加到输出表达式中
		 * 若为'(' ，则返回
		 */
		private function findLeft():void
		{
			var popOp:int;
			
			if ( _len > 0 ){
				popOp = _oprateArr.pop();
				_len--;
				//				topOpe = _oprateArr[len-2];
				if ( popOp == 11 ){
					return;
				}
				saveOP(popOp);
				findLeft();
			}
		}
		
		/**
		 * 查找操作堆栈顶部操作符 
		 */
		private function findTop():void
		{
			if ( _len > 0 ){
				topOpe = _oprateArr[_len-1];
				return;
			}
			topOpe = 0;
			
		}
		
		/**
		 * 保存操作符
		 *  
		 * @param pOp 操作符标志
		 */
		private function compareOperate( pOp:int ):void
		{
			findTop();
			if ( int(pOp/10) > int(topOpe/10) ){
				//  当前操作符 优先级别大于栈顶优先级时
				//  将当前操作符推入操作符堆栈
				//				_oprateArr.push( topOpe );
				_oprateArr.push( pOp );
				topOpe = pOp;
				_len++;
			} else {
				
				//  当前操作符级别小于等于栈顶操作优先级时
				//  取出栈顶操作符存入输出表达式  -----------将当前操作符存入堆栈
				
				//  循环   直至当前操作符优先级别大于栈顶操作符
				
				saveOP( _oprateArr.pop());
				_len--;
				if ( _len > 0 ){
					compareOperate( pOp );
				}else{
					_oprateArr.push( pOp );
					_len++;
					topOpe = pOp;
				}
				
			}
		}
		
		/**
		 * 保存数值字符到字符缓存
		 *  
		 * @param pCh 输入字符
		 */
		private function catchNum( pCh:String ):void
		{
			_tempNum += pCh;
		}
		/**
		 * 保存操作符字符到操作符缓存 , 主要用于识别双字符操作符  比如>= , <= , !=
		 */
		private function catchOp( pCh:String ):void
		{
			_consitLogic = true;	//  标记该表达式中含有逻辑运算
			_tempOp += pCh;
		}
		
		/**
		 * 保存操作数到输出 
		 */
		private function saveNum( ):void
		{
			_tempNum.length > 0 && numNode( _tempNum );
			_tempNum = '';
		}
		
		/**
		 * 保存操作符到输出 
		 * @param pOp 操作符标志
		 */
		private function saveOP( pOp:int ):void
		{
			opeNode( pOp )
		}
		
		///////////////////////////////////////////////////////////////////
		
		//////					转成二叉树 --堆栈  结构 		//////////////////////
		
		///////////////////////////////////////////////////////////////////
		
		/**
		 * 记录数node节点
		 *  
		 * @param pCh 操作数字符
		 */
		private function numNode(pCh:String):void
		{
			var node:DgDot = new DgDot();
			
			_nodeArr.push( node );
			
			if ( _nodeArr.length == 1 ){
				_rootNode = _nodeArr[0];
			}
			
			if ( !isNaN( Number( pCh ) ) ){
				node.value = Number( pCh );
				return;
			}
			
			if ( !_xyz.hasOwnProperty( pCh ) ){
				_xyz[ pCh ] = new Vector.<DgDot>();
			}
			
			_xyz[ pCh ].push( node );
		}
		
		/**
		 * 记录操作符号node节点
		 *  
		 * @param pOp 操作标识
		 */
		private function opeNode( pOp:int ):void
		{
			var node:DgDot = new DgDot();
			node.operate( pOp, _nodeArr.pop(), _nodeArr.pop() );
			
			if( pOp<50 ){
				node.isLogic = true;
			}
			_nodeArr.push( node );
			_opDot.push( node );
			
			_rootNode = node;
		}
		
		
		/**
		 * 每次计算完将变量重置为NAN 
		 */
		private function clear():void
		{
			var key:DgDot;
			var num:Number = NaN;
			for each (key in _xyz){
				key.nvalue = num;
			}
		}
	}
}
