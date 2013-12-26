package binding
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import dragon.binding.DgBindingUtils;
	import dragon.binding.DgChangeWatcher;
	import dragon.ui.fte.DgTextField;
	
	public class BindingDemo extends Sprite
	{
		
		private var _lb1:DgTextField;
		private var _w1:DgChangeWatcher;
		
		private var _lb2:DgTextField;
		private var _w2:DgChangeWatcher;
		
		private var _vo:MyData;
		
		
		public function BindingDemo()
		{
			super();
			
			_vo				= new MyData;
			
			_lb1			= new DgTextField;
			_lb1.defFormat	= { fontSize : 100 };
			_w1 			= DgBindingUtils.bindProperty( _lb1, 'text', _vo, 'value', true );
			addChild(_lb1);
			
			
			_lb2			= new DgTextField;
			_lb2.defFormat	= { fontSize : 100 };
			_lb2.y			= 100;
			_w2 			= DgBindingUtils.bindSetter( onValueChanged, _vo, 'value', true );
			addChild(_lb2);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onEnterFrame( pEvt:Event ):void
		{
			if( _vo.value > 50 )
			{
				_w1.unwatch();
				_w2.unwatch();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			_vo.value++;
		}
		
		private function onValueChanged( pVal:int ):void
		{
			_lb2.text = pVal.toString();
		}
		
		
		
		
		
		
	}
}