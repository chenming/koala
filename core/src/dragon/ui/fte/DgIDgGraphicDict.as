package dragon.ui.fte
{
	import flash.display.DisplayObject;

	/**
	 * Interface for graphic's dict.
	 * 
	 */				 
	public interface DgIDgGraphicDict
	{
		/**
		 * hasItem
		 */ 
		function hasItem(key:String):Boolean;
		
		/**
		 * getItem
		 */
		function getItem(key:String):DisplayObject;
	}
}