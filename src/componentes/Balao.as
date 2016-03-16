package componentes
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
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
		
		public var botaoCor:int;
		
		public function Balao(tipo:int = 0)
		{
			super();
			
			this.filters = new Array(new DropShadowFilter(4, 45, 0, 0.8, 4, 4, 1, 1, false), new DropShadowFilter(4, 225, 0, 0.8, 4, 4, 1, 1, false));
			
			this._imgsBalao = new Vector.<Bitmap>();
			this._imgsBalao.push(new Graficos.ImgBalao07() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao08() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao09() as Bitmap);
			/*this._imgsBalao.push(new Graficos.ImgBalao04() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao05() as Bitmap);
			this._imgsBalao.push(new Graficos.ImgBalao06() as Bitmap);
			*/		
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
			
			this.setCor(255, 255, 255, 5, 0);
			
			this.mouseChildren = false;
		}
		
		public function get tipo():int
		{
			return (this._tipo);
		}
		
		public function set tipo(para:int):void
		{
			if (para >= this._imgsBalao.length)
			{
				para = this._imgsBalao.length - 1;
			}
			else if (para < 0)
			{
				para = 0;
			}
			this.removeChildren();
			this.addChild(this._imgsBalao[para]);
			this._tipo = para;
			this.addChild(this._texto);
		}
		
		public function get texto():String
		{
			return (this._texto.text);
		}
		
		public function set texto(para:String):void
		{
			this._texto.text = para;
		}
		
		public function get corTexto():int
		{
			return (this._texto.textColor);
		}
		
		public function get vermelho():int
		{
			return (this._imgsBalao[0].transform.colorTransform.redOffset);
		}
		
		public function get verde():int
		{
			return (this._imgsBalao[0].transform.colorTransform.greenOffset);
		}
		
		public function get azul():int
		{
			return (this._imgsBalao[0].transform.colorTransform.blueOffset);
		}
		
		public function get flipadaH():Boolean {
			return (this._imgsBalao[0].scaleX < 0);
		}
		
		public function get flipadaV():Boolean {
			return (this._imgsBalao[0].scaleY < 0);
		}
		
		public function setCor(vermelho:int = 255, verde:int = 255, azul:int = 255, idCor:int = 1, ctexto:int = 0):void
		{
			if (vermelho < 0) vermelho = 0;
			if (vermelho > 255) vermelho = 255;
			if (verde < 0) verde = 0;
			if (verde > 255) verde = 255;
			if (azul < 0) azul = 0;
			if (azul > 255) azul = 255;
			for (var i:int = 0; i < this._imgsBalao.length; i++)
			{
				this._imgsBalao[i].transform.colorTransform = new ColorTransform(1, 1, 1, 1, vermelho, verde, azul);
			}
			this._texto.textColor = ctexto;
			this.botaoCor = idCor;
		}
		
		public function flipH():void
		{
			for (var i:int = 0; i < this._imgsBalao.length; i++)
			{
				this._imgsBalao[i].scaleX = -this._imgsBalao[i].scaleX;
				if (this._imgsBalao[i].scaleX < 0) {
					this._imgsBalao[i].x = this._imgsBalao[i].width;
					// mudar x da caixa de texto
				} else {
					this._imgsBalao[i].x = 0;
					// mudar x da caixa de texto
				}
			}
		}
		
		public function flipV():void
		{
			for (var i:int = 0; i < this._imgsBalao.length; i++)
			{
				this._imgsBalao[i].scaleY = -this._imgsBalao[i].scaleY;
				if (this._imgsBalao[i].scaleY < 0) {
					this._imgsBalao[i].y = this._imgsBalao[i].height;
					// mudar y da caixa de texto
				} else {
					this._imgsBalao[i].y = 0;
					// mudar y da caixa de texto
				}
			}
		
		}
		
		public function copyProp(origem:Balao):void
		{
			this.tipo = origem.tipo;
			this.setCor(origem.vermelho, origem.verde, origem.azul, origem.botaoCor, origem.corTexto);
			this.texto = origem.texto;
			if (origem.flipadaH != this.flipadaH) this.flipH();
			if (origem.flipadaV != this.flipadaV) this.flipV();
			
			
		}
		
		public function get xml():String
		{
			
			return ('');
		
		}
	
	}

}