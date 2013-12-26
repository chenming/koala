package dragon.ui.fte
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.engine.ContentElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;

	/**
	 * A simple textlines container, use FTE.
	 *
	 * @example
	 * var text:TextBase = new TextBase();
	 * text.content = new GroupElement(...);
	 * text.initialize();
	 * addChild(text);
	 *
	 * @author feather
	 */
	internal class TextBase extends Sprite
	{
		
		/**
		 * textAlign : left | center | right
		 * @default left
		 */
		public var textAlign:String;
		/**
		 * Just set textline's width less than width
		 * @default true
		 */
		public var autoSize:Boolean;
		/**
		 * Content
		 */
		public var content:ContentElement;
		/**
		 * Line's Space
		 */
		public var leading:int;
		/**
		 * initialized
		 */
		protected var _initialized:Boolean;

		
		public function TextBase()
		{
			mouseChildren = mouseEnabled = false;
			textAlign	= 'left';
			autoSize	= true;
			_textBlock 	= new TextBlock();
//			_textBlock.textJustifier = new EastAsianJustifier("chi", LineJustification.UNJUSTIFIED);
		}


		public function get initialized():Boolean
		{
			return _initialized;
		}

		
		protected var _textBlock:TextBlock;
		
		/**
		 * TextBlock
		 * @default TextBlock
		 */
		public function get textBlock():TextBlock
		{
			return _textBlock;
		}

		protected var _width:Number = 1000;
		
		/**
		 * Textline's width
		 * <font color=red><br />
		 *  不同的字体在取宽度和高度不一样， 所以这个类最好子类自己重写
		 * </font>
		 */
		override public function get width():Number
		{
			return autoSize ? super.width : _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
		}

		
		/**
		 * Initialize display
		 */
		public function initialize():void
		{
			clear();
			createLines();

			if (textAlign != "left")
			{
				var center:Boolean = (textAlign == "center");
				var child:DisplayObject;
				var i:int;
				var len:int = numChildren;
				for (i = 0; i < len; i++)
				{
					child = getChildAt(i);
					child.x = center ? ((width - child.width) >> 1) : (width - child.width);
				}
			}
			
			if (!autoSize)
			{
				with (graphics)
				{
					beginFill(0, 0);
					drawRect(0, 0, _width, height);
					endFill();
				}
			}

			_initialized = true;
		}
		
		/**
		 * Clear
		 */ 
		public function clear():void
		{
			while (numChildren)
			{
				removeChildAt(0);
			}
			
			graphics.clear();
			releaseLines();
		}

		/**
		 * Destory all
		 */
		public function dispose():void
		{
			releaseLines();
			content 		= null;
			_textBlock 		= null;
			_initialized 	= false;
		}

		private function releaseLines():void
		{
			var firstLine:TextLine = _textBlock.firstLine;
			firstLine && _textBlock.releaseLines(firstLine, _textBlock.lastLine);
		}

		private function createLines():void
		{
			var textLine:TextLine;
			
			_textBlock.content = content;
			textLine = _textBlock.createTextLine(textLine, _width);
			if (textLine == null)
				return;
			textLine.y = textLine.height;
			addChild(textLine);

			while (true)
			{
				textLine = _textBlock.createTextLine(textLine, _width);
				if (textLine == null)
					break;
				textLine.y = textLine.height + height + leading;
				addChild(textLine);
			}
		}
	}
}