package componentes
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author
	 */
	public class TxBox extends Sprite
	{
		private var _fonte:String;
		private var _fontsize:int;
		private var _cortexto:int;
		private var _texto:TextField;
		private var _textfundo:BotaoIcone;
		private var _id:String;
		
		public var oWidth:Number;
		public var oHeight:Number;
		
		public function TxBox(fontsize:int = 120, borderColor:int = 0, background:Boolean = true, corFundo:int = 0xFFFFFF, cortexto:int = 0x000000, fonte:String = 'Pfennig')
		{
			_fontsize = fontsize;
			_cortexto = cortexto;
			_fonte = fonte;
			
			this._textfundo = new BotaoIcone(Graficos.ImgBarra);
			this._texto = new TextField();
			
			this._texto.height = this._textfundo.height / 2;
			this._texto.width = this._textfundo.width * 5 / 6;
			
			this._texto.x = this._textfundo.x + ((this._textfundo.width - this._texto.width) / 2);
			this._texto.y = this._textfundo.y + ((this._textfundo.height - this._texto.height) / 2);
			
			this._texto.type = TextFieldType.INPUT;
			this._texto.borderColor = borderColor;
			this._texto.defaultTextFormat = new TextFormat(_fonte, _fontsize,_cortexto);
			this._texto.embedFonts = true;
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.background = background;
			this._texto.backgroundColor = corFundo;
			this._texto.needsSoftKeyboard = true;
			this._texto.maxChars = 40;
			this._texto.selectable = true;
			this._texto.border = false;
			
			addChild(this._textfundo);
			addChild(this._texto);
			
			this.oWidth = this._textfundo.width;
			this.oHeight = this._textfundo.height;
		}
		
		/*
		override public function get height():Number
		{
			return (this._texto.height);
		}
		
		override public function set height(value:Number):void
		{
			//this._texto.height = value;
			//this._texto.defaultTextFormat = new TextFormat(_fonte, _fontsize + value / 5, _cortexto);
			//this._texto.defaultTextFormat = new TextFormat(_fonte, _fontsize + value / 5, _cortexto);
			//this._texto.text = this._texto.text;			
			//this._textfundo.height = value + value;
			//this._textfundo.y = -value / 2;
			super.height = value;
		}
		*/
		
		public function get text():String
		{
			return (this._texto.text);
		}
		
		public function set text(para:String):void
		{
			this._texto.text = para;
		}
		
		/*
		override public function get width():Number
		{
			return (this._texto.width);
		}
		
		override public function set width(value:Number):void
		{
			//this._texto.width = value;
			//this._textfundo.x = this._texto.x - (value / 8);
			//this._textfundo.width = value + (value / 4);
			super.width = value;
		}
		*/
	
	}

}