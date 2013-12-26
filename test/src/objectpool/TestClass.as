package objectpool
{
	import dragon.objectpool.DgObjectPool;

	/**
	 *  
	 * @author tiago
	 */
	internal class TestClass
	{
		
		/**
		 * get TestClass instance from object pool 
		 * we can do some init in this function
		 */
		public static function getInst():TestClass
		{
			var inst:TestClass;
			
			inst 			= DgObjectPool.getObject( TestClass ) as TestClass;
			inst._initTime 	= new Date;
			return inst;
		}
		
		/**
		 * when object is unused, send it back to object pool 
		 */
		public static function freeInst( pInst:TestClass ):void
		{
			DgObjectPool.freeObject( TestClass, pInst );
			pInst._initTime	= null;
		}
		
		
		private var _initTime:Date;
		
		public function TestClass()
		{
			trace( 'Create new instance!' );
		}
		
		
		public function toString():String
		{
			return _initTime.time.toString();
		}
		
		
		
		
	}
}