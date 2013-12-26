package objectpool
{
	import flash.display.Sprite;
	
	/**
	 * Object Pool Test
	 *  
	 * @author tiago
	 */
	public class ObjectPoolDemo extends Sprite
	{
		private var _obj:TestClass;
		
		
		public function ObjectPoolDemo()
		{
			super();
			
			// get inst from pool
			_obj	= TestClass.getInst();
			trace( _obj );
			
			// free when unused
			TestClass.freeInst( _obj );
			_obj = null
			
			// get inst from pool, this time we will reuse instance which created before
			_obj	= TestClass.getInst();
			trace( _obj );
		}
		
		
		
		
		
		
	}
}