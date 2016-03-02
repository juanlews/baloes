package componentes 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class BotaoLista extends Sprite 
	{
		
		private var _texto:TextField;
		
		public function BotaoLista(texto:String, imagem:Class = null, propTexto:TextFormat = null, posTexto:Rectangle = null ) 
		{
			super();
			mouseChildren = false;
			if (imagem != null) {
				var bmp:Bitmap = new imagem() as Bitmap;
				this.addChild(bmp);
			}
			
			this._texto = new TextField();
			if (propTexto != null) {
				this._texto.defaultTextFormat = propTexto;
			} 
			else {
				// define propriedades padrão do texto
				this._texto.defaultTextFormat = new TextFormat(null, 50, null);
				


			}
			
			if (posTexto != null) {
				this._texto.x = posTexto.x;
				this._texto.y = posTexto.y;
				this._texto.width = posTexto.width;
				this._texto.height = posTexto.height;
			
				
			}
			else{
				this._texto.width = bmp.width;
			}
			this._texto.text = texto;			
			this.addChild(this._texto);
			this._texto.x = bmp.width / 6;
			this._texto.y = bmp.height / 2;
			
			
 		}
		
		public function get texto():String {
			return (this._texto.text);
		}
		
		public function set texto(para:String):void {
			this._texto.text = para;
		}
		
		
		
	}

}