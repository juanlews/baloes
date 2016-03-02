package componentes 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class Balao extends Sprite  
	{
		
		// imagens balao
		private var _imgsBalao:Vector.<Bitmap>;
		private var _tipo:int;
		private var _texto:TextField;
		private var _corAzul:int;
		private var _corVermelho:int;
		private var _corVerde:int;
		private var _corDoTexto:int;
		
		
		public function Balao(tipo:int = 0) 
		{
			super();
			
			this._imgsBalao = new Vector.<Bitmap>();
			this._imgsBalao.push(new Graficos.ImgBalao01() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao02() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao03() as Bitmap);
			this._tipo = tipo;
			this.addChild(this._imgsBalao[tipo]);
			
			this._texto = new TextField();
			this._texto.width = 100;
			this._texto.height = 50;
			this._texto.x = 50;
			this._texto.y = 50;
			this._texto.maxChars = 100;
			this._texto.multiline = true;
			this._texto.embedFonts = true;
			this._texto.defaultTextFormat = new TextFormat('Pfennig', 16, 0);
			this.addChild(this._texto);
			
			this.mouseChildren = false;
		}
		
		public function get tipo():int {
			return (this._tipo);
		}
		public function set tipo(para:int):void {
			if (para >= this._imgsBalao.length) {
				para = this._imgsBalao.length - 1;
			} else if (para < 0) {
				para = 0;
			}
			this.removeChildren();
			this.addChild(this._imgsBalao[para]);
			this._tipo = para;
			this.addChild(this._texto);
		}
		
		public function get texto():String {
			return(this._texto.text);
		}
		public function set texto(para:String):void {
			this._texto.text = para;
		}
		
		public function get corTexto():int {
			return (this._texto.textColor);
		}
		
		public function get vermelho():int {
			return(this._imgsBalao[0].transform.colorTransform.redOffset);
		}
		
		public function get verde():int {
			return(this._imgsBalao[0].transform.colorTransform.greenOffset);
		}
		
		public function get azul():int {
			return(this._imgsBalao[0].transform.colorTransform.blueOffset);
		}
		
		public function setCor(vermelho:int, verde:int, azul:int, ctexto:int):void {
			if (vermelho < 0) vermelho = 0;
			if (vermelho > 255) vermelho = 255;
			if (verde < 0) verde = 0;
			if (verde > 255) verde = 255;
			if (azul < 0) azul = 0;
			if (azul > 255) azul = 255;
			for (var i:int = 0; i < this._imgsBalao.length; i++) {
				this._imgsBalao[i].transform.colorTransform = new ColorTransform(1, 1, 1, 1, vermelho, verde, azul);
			}
			this._texto.textColor = ctexto;
		}
		
		public function copyProp(origem:Balao):void {
			this.tipo = origem.tipo;
			this.setCor(origem.vermelho, origem.verde, origem.azul, origem.corTexto);
			this.texto = origem.texto;
		}
		
		
		public function flipH():void {
			for (var i:int = 0; i < this._imgsBalao.length; i++) {
				this._imgsBalao[i].scaleX = -this._imgsBalao[i].scaleX;
			}
		}
		
		public function flipV():void {
			for (var i:int = 0; i < this._imgsBalao.length; i++) {
				this._imgsBalao[i].scaleY = -this._imgsBalao[i].scaleY;
			}
		
		}
		
		public function get xml():String {
		
			return('');
		
		
		}

		
	}

}