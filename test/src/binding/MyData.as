package binding
{
	import dragon.binding.DgBindingUtils;

	/**
	 * Vo Demo
	 *  
	 * @author tiago
	 */
	internal class MyData
	{
		private var _value:int;
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value( pVal:int ):void
		{
			if( _value == pVal )
				return;
			_value = pVal;
			DgBindingUtils.propertyChanged( this, 'value' );
		}
		
		
		
		
	}
}