package fte
{
	import flash.display.Sprite;
	import flash.sampler.getSize;
	import flash.text.TextField;
	
	import dragon.core.DgString;
	import dragon.ui.fte.DgTextField;
	
	public class FteDemo extends Sprite
	{
		
		private var _fte:DgTextField;
		private var _lb:TextField;
		private var _mem:DgTextField;
		
		public function FteDemo()
		{
			super();
			
			_fte		= new DgTextField;
			_fte.text 	= '<font size="20">This is Fte Text Field</font>';
			addChild( _fte );
			
			_lb			= new TextField;
			_lb.width	= 150;
			_lb.y 		= 100;
			_lb.htmlText= '<font size="20">This is Text Field</font>';
			addChild( _lb );
			
			_mem		= new DgTextField;
			_mem.y		= 200;
			_mem.text	= DgString.substitute(
				'<font size="20" color="#FF0000">fte use memory: {0} byte,</font><br /><font size="20" color="#FF0000">text field use memory: {1} byte</font>',
				getSize( _fte ),
				getSize( _lb )
			);
			addChild( _mem );
		}
		
		
		
		
		
		
	}
}