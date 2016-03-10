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
		private var _texto:TextField;
		private var _textfundo:BotaoIcone;
		private var _id:String;
		
		public function TxBox(fontsize:int = 25, borderColor:int = 0, background:Boolean = true, corFundo:int = 0xFFFFFF, cortexto:int = 0x000000, fonte:String = 'Pfennig') 
		{
		    
			this._textfundo = new BotaoIcone(Graficos.ImgBarra);
			this._texto = new TextField();
			this._texto.type = TextFieldType.INPUT;
			this._texto.borderColor = borderColor;
			this._texto.defaultTextFormat = new TextFormat(fonte, fontsize, cortexto);
			this._texto.embedFonts = true;
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.background = background;
			this._texto.backgroundColor = corFundo; 
			//this._texto.autoSize = TextFieldAutoSize.LEFT
			this._texto.needsSoftKeyboard = true;
			this._texto.maxChars = 40;
			this._texto.selectable = true;
			this._texto.border = false;
			
			
			addChild(this._textfundo);
			addChild(this._texto);
		}
		override public function get height():Number 
		{
			return (this._texto.height);
		}
		
		override public function set height(value:Number):void 
		{
			this._texto.height = value;
			this._textfundo.height = value + value;
			this._textfundo.y = -value / 2; 
			
		}
		public function get text():String{
			return (this._texto.text);
		}
		
		override public function get width():Number 
		{
			return (this._texto.width);
		}
		
		override public function set width(value:Number):void 
		{
			this._texto.width = value;
			this._textfundo.x = this._texto.x - (value / 8);
			this._textfundo.width = value + (value / 4);
			
			
		}
		
	}

}