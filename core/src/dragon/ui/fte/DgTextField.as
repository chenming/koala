package dragon.ui.fte
{
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	
	/**
	 * 文本组件， 用于替换TextField
	 * 该组件默认不响应鼠标事件
	 *  
	 * @author Tiago
	 */
	public class DgTextField extends TextBase	
	{
		/**
		 * 设置当前组件的默认样式
		 * 支持fontFize, fontName, color
		 * 这些属性一样可以通过设置 <font> 节点的属性来设置 
		 */
		public var defFormat:Object;
		/**
		 * 当前显示文本
		 */
		private var _text:String;
		
		/**
		 * 构造
		 */
		public function DgTextField()
		{
			super();
		}
		
		
		/**
		 * 设置文本
		 * 默认已经支持了 html 格式， 所以不再封装 htmlText
		 */
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(pHtml:String):void
		{
			var elements:Vector.<ContentElement>;
			
			_text = pHtml;
			if( _text && _text.length ) 
			{
				if( _text.indexOf('<p>') == -1 ||  _text.indexOf('<P>') == -1 ) 
				{
					_text = "<p>" + _text + "</p>";
				}
				elements = TextConverter.conver( _text, defFormat );
				content	= (elements.length == 1) ? elements[0] : new GroupElement(elements);
				initialize();
				return;
			}
			clear();
		}
		
		
		
		public override function get height():Number
		{
			// 父类高度存在5像素的差值
			return _text? super.height + 5 : 0;
		}
		
		
		
		
		
		
		
	}
}
		
		
		
		