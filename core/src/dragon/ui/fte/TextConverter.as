package dragon.ui.fte
{
	import flash.text.Font;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;
	import flash.utils.Dictionary;
	
	import dragon.ui.image.DgBitmap;

	/**
	 * html 文本解析工具
	 * 
	 * @author feather
	 */
	internal class TextConverter
	{
		/**
		 * 单例 
		 */
		private static var _inst:TextConverter;
		/**
		 * 嵌入字体列表
		 * @example: TextConverter.embed_fonts.font_name = true;
		 */
		private static var _embedFonts:Object;
		
		/**
		 * 将HTML语句转换成可见元素，
		 * 支持的类型有:b,i,font(color,face,size),a(href),img(src,width,height)
		 * 
		 * @param html 所需转换的HTML语句
		 * @param defaultFormat 显示所需的基本字体格式 ，支持类型有color, fontSize, fontName, fontWeight, fontPosture
		 * @param graphicDict HTML语句中所需要的特殊转换资源，如果为空，则默认使用DgGraphicDict.inst中的资源，具体使用方法请参考DgGraphicDict类
		 */
		public static function conver(pHtml:String, pDefFormat:Object = null, pDgGraphicDict:DgIDgGraphicDict = null):Vector.<ContentElement>
		{
			
			pHtml = pHtml.replace(/<br\s*\/?>/ig, '\n'); //将<br/>替换为换行符
			pHtml = pHtml.replace(/>([^<]+)</g, ">($1)<"); //将<TAG></TAG>中的内容用括号括起来，解决空格等字符被XML过滤的问题

			
			_inst || ( _inst = new TextConverter );
			_inst.elements 		= new Vector.<ContentElement>();
			_inst.linkData 		= new Dictionary(true);
			_inst.graphicDict	= pDgGraphicDict? pDgGraphicDict : DgGraphicDict.inst;
			
			
			if (pDefFormat != null)
			{
				_inst.color 		= pDefFormat.color? pDefFormat.color : 0x000000;
				_inst.fontSize 		= pDefFormat.fontSize? pDefFormat.fontSize : 12;
				_inst.fontName 		= pDefFormat.fontName? pDefFormat.fontName : "_serif";
				_inst.fontWeight 	= pDefFormat.fontWeight == "bold"? "bold" : "normal";
				_inst.fontPosture 	= pDefFormat.fontPosture == "italic"? "italic" : "normal";
			}
			else
			{
				_inst.color 		= 0x000000;
				_inst.fontSize 		= 12;
				_inst.fontName 		= "_serif";
				_inst.fontWeight 	= "normal";
				_inst.fontPosture 	= "normal";
			}
			try
			{
				_inst.parseHtml(XML(pHtml), []);
			}
			catch (e:Error) 
			{
				trace( '【错误：】 XML解析异常 ', pHtml);
			}
			var elements:Vector.<ContentElement> = _inst.elements;
			_inst.elements = null;
			_inst.linkData = null;
			_inst.graphicDict = null;
			return elements;
		}


		private var elements:Vector.<ContentElement>;
		private var linkData:Dictionary;
		private var graphicDict:DgIDgGraphicDict;
		/**
		 * 字体颜色 
		 */
		private var color:uint;
		/**
		 * 字体大小 
		 */
		private var fontSize:int;
		/**
		 * 字体名称 
		 */
		private var fontName:String;
		/**
		 * 是否加粗 
		 */
		private var fontWeight:String;
		/**
		 * 是否斜体 
		 */
		private var fontPosture:String;

		/**
		 * html文本解析
		 *  
		 * @param xml		html内容
		 * @param parents	父容器
		 */
		private function parseHtml(pRoot:XML, pParents:Array):void
		{
			var item:XML;
			var name:String;
			var parentsClone:Array;

			for each ( item in pRoot.children() )
			{
				if (item.hasComplexContent())
				{
					parentsClone = pParents.slice();
					parentsClone.push(pRoot);
					parseHtml(item, parentsClone);
					continue;
				}

				name = String(item.localName()).toLowerCase();
				
				//图像
				if (name == 'img') 
				{
					parseImage( item, parentsClone );
					continue;
				}
				// 文本
				parentsClone 	= pParents.slice();
				parseText( pRoot, name, item, parentsClone );
			}
		}
		
		
		
		/**
		 * 解析 img 格式的 xml 
		 */
		private function parseImage( pItem:XML, parentsClone:Array ):void
		{
			var key:String;
			var graphicElement:GraphicElement;
			var grh:DgBitmap;
			var parent:XML;
			
			if( !graphicDict )
				return;
			
			key = pItem.@src;
			if( graphicDict.hasItem(key) )
			{
				graphicElement = new GraphicElement(graphicDict.getItem(key), Number(pItem.@width), Number(pItem.@height));
			}
			else
			{
				grh = new DgBitmap();
				grh.load(key);
				graphicElement = new GraphicElement(grh, Number(pItem.@width), Number(pItem.@height));
			}
			
			
			for each (parent in parentsClone)
			{
				if (parent != null && String(parent.localName()).toLowerCase() == 'a')
				{
					!graphicElement.userData || ( graphicElement.userData = {} );
					!linkData[parent] || ( linkData[parent] = { href: String( parent.@href ) } );
					graphicElement.userData['data'] = linkData[parent];
					break;
				}
			}
			graphicElement.elementFormat = new ElementFormat();
			elements.push(graphicElement);
		}
		
		
		
		/**
		 * 解析文本 
		 */
		private function parseText(pRoot:XML, pName:String, pItem:XML, parentsClone:Array ):void
		{
			var text:String;
			var fontDescription:FontDescription;
			var elementFormat:ElementFormat;
			var textElement:TextElement;
			var parent:XML;
			
			text = pItem.toString();
			//内容为空
			if (text.length <= 2) 
				return;
			
			text 			= text.slice(1, -1);
			fontDescription = new FontDescription(fontName, fontWeight, fontPosture);
			elementFormat 	= new ElementFormat(null, fontSize, color);
			textElement 	= new TextElement(text);
			pName == null ? parentsClone.push(pRoot) : parentsClone.push(pRoot, pItem);
			
			for each (parent in parentsClone)
			{
				if (parent == null)
					continue;
				
				switch ( String(parent.localName()).toLowerCase() )
				{
					case 'b':
						fontDescription.fontWeight = FontWeight.BOLD;
						break;
					
					case 'i':
						fontDescription.fontPosture = FontPosture.ITALIC;
						break;
					
					case 'a':
						textElement.userData || ( textElement.userData = {} );
						linkData[parent] || ( linkData[parent] = {href: String(parent.@href), hover: String(parent.@hover)} );
						textElement.userData['data'] = linkData[parent];
						break;
					
					case 'font':
						if (parent.hasOwnProperty('@color'))
							elementFormat.color = uint(String(parent.@color).replace('#', '0x'));
						if (parent.hasOwnProperty('@face'))
							fontDescription.fontName = String(parent.@face);
						if (parent.hasOwnProperty('@size'))
							elementFormat.fontSize = Number(parent.@size);
						break;
					
					case 'p' :
						break;
					
					default :
//						trace('TextConverter 【错误】无法解析节点', String(parent.localName()).toLowerCase() );
						break;
				}
			}
			
			_embedFonts || searchEmbedFonts();
			_embedFonts[fontDescription.fontName] && ( fontDescription.fontLookup = FontLookup.EMBEDDED_CFF );
			elementFormat.fontDescription = fontDescription;
			textElement.elementFormat = elementFormat;
			elements.push(textElement);
		}
		
		
		/**
		 * 搜索可用的嵌入字体，并将其存储到字体列表中 
		 */
		private function searchEmbedFonts():void
		{
			var font:Font;
			var fontList:Array;
			
			if( _embedFonts )
				return;
			
			_embedFonts = {};
			
			fontList = Font.enumerateFonts(false);
			
			for each( font in fontList )
			{
				_embedFonts[font.fontName] = true;
			}
		}
		
		
		
		
		
		
		
		

	}
}