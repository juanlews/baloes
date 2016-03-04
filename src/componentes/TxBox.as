package componentes 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author 
	 */
	public class TxBox extends Sprite
	{
		private var _texto:TextField;
		
		private var _id:String;
		
		public function TxBox(fontsize:int = 20, borderColor:int = 0, background:Boolean = true, corFundo:int = 0xFFFFFF, cortexto:int = 0xff0000, fonte:String = 'Pfennig') 
		{
		    
			
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
			this._texto.selectable = true;
			this._texto.border = false;
			
			
			addChild(_texto);
		}
		override public function get height():Number 
		{
			return super.height;
		}
		
		override public function set height(value:Number):void 
		{
			this._texto.height = value;
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			this._texto.width = value;
		}
		
	}

}