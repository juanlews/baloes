	package telas
{
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaFotoRecuperada extends Tela
	{
		
		// botoes
		private var _propBalao:BotaoIcone;
		private var _ajusteBalao:BotaoIcone;
		private var _ajusteImagem:BotaoIcone;
		private var _salvar:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		// balão
		private var _balao:Balao;
		
		// imagem
		private var _imagem:Imagem;
		private var _bmpData:BitmapData;
		
		private var _tipobalao:int;
		private var _dados:Object;
		
		public function TelaFotoRecuperada(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			// criar balão
			this._balao = new Balao(0);
			
			// criar botões
			this._propBalao = new BotaoIcone(Graficos.ImgPropBalao);
			
			this._ajusteBalao = new BotaoIcone(Graficos.ImgAjusteBalao);
			
			this._ajusteImagem = new BotaoIcone(Graficos.ImgAjusteImagem);
			
			this._salvar = new BotaoIcone(Graficos.ImgPBOK);
			
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			
			_dados = new Object();
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			this.addChild(this._propBalao);
			this.addChild(this._ajusteBalao);
			this.addChild(this._ajusteImagem);
			this.addChild(this._salvar);
			this.addChild(this._cancelar);
			
			// posicionar e dimensionar botões	
			this._balao.tipo = this._balao.tipo;
			this._balao.width = 200;
			this._balao.scaleY = this._balao.scaleX;
			this._balao.x = stage.stageWidth / 3;
			this._balao.y = stage.stageHeight / 3;
			this.addChild(_balao);
			
			/*
			   if (this._imagem.width > this._imagem.height)
			   {
			   trace("largura");
			   this._imagem.width = stage.stageWidth;
			   this._imagem.scaleY = this._imagem.scaleX;
			   this._imagem.y = this.stage.stageHeight / 2 - this._imagem.height / 2;
			   this._imagem.x = 0;
			   }
			   else
			   {
			   trace('altura');
			   this._imagem.width = stage.stageWidth;
			   this._imagem.scaleX = this._imagem.scaleY;
			   this._imagem.y = this._cancelar.height;
			   this._imagem.x = 0;
			   }
			 */
			
			//botão propiedades balão
			this._propBalao.x = 0
			this._propBalao.width = stage.stageWidth / 3;
			this._propBalao.scaleY = this._propBalao.scaleX;
			
			//botão ajuste do balão
			this._ajusteBalao.x = this._propBalao.width;
			this._ajusteBalao.width = stage.stageWidth / 3;
			this._ajusteBalao.scaleY = this._ajusteBalao.scaleX;
			
			//botão ajuste imagem
			this._ajusteImagem.x = this._ajusteBalao.width * 2;
			this._ajusteImagem.width = stage.stageWidth / 3;
			this._ajusteImagem.scaleY = this._ajusteImagem.scaleX;
			
			//botão salvar			
			this._salvar.width = stage.stageWidth / 6;
			this._salvar.scaleY = this._salvar.scaleX;
			this._salvar.x = stage.stageWidth / 8;
			this._salvar.y = stage.stageHeight - this._salvar.width;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / 6;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth / 1.4;
			this._cancelar.y = stage.stageHeight - this._cancelar.height;
			
			//imagem recuperada
			
			// adicionar listeners dos cliques dos botões
			if (!this._salvar.hasEventListener(MouseEvent.CLICK))
			{
				
				this._salvar.addEventListener(MouseEvent.CLICK, cliqueSalvar);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				this._propBalao.addEventListener(MouseEvent.CLICK, cliquePropB);
				this._ajusteBalao.addEventListener(MouseEvent.CLICK, cliqueAjusteB);
				this._ajusteImagem.addEventListener(MouseEvent.CLICK, cliqueAjusteImg);
				
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('inicial', null);
		
		}
		
		private function cliquePropB(evento:MouseEvent):void
		{
			trace('click propB');
			this._dados.tipobalao = this._balao.tipo;
			this.mudaTela('propriedadesbalao', _dados);
		}
		
		private function cliqueAjusteB(evento:MouseEvent):void
		{
			trace('click ajustB');
			//this.mudaTela('editbalao', null);
		}
		
		private function cliqueAjusteImg(evento:MouseEvent):void
		{
			trace('click ajusteImg');
			//var dados:Object = new Object();
			_dados.imagem = this._imagem;
			this.mudaTela('editimagem', _dados);
			
			trace(evento.target);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			
			// remover listeners
			this._salvar.removeEventListener(MouseEvent.CLICK, cliqueSalvar);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
			this._propBalao.removeEventListener(MouseEvent.CLICK, cliqueAjusteB);
			this._ajusteBalao.removeEventListener(MouseEvent.CLICK, cliquePropB);
			this._ajusteImagem.removeEventListener(MouseEvent.CLICK, cliqueAjusteImg);
		
		}
		
		override public function recebeDados(dados:Object):void
		{
			
			trace('recebedados', dados.imagem, dados.tipobalao);
			
			if (dados != null)
			{
				if (dados.imagem != null)
				{
					this._imagem = dados.imagem as Imagem;
				}
				if (dados.tipobalao != null)
				{
					
					this._balao.tipo = dados.tipobalao as int;
					
				}
				
				// add child _image
				addChild(this._imagem);
				addChild(this._balao);
			}
		}
		
		private function removeBotoes():void
		{
			this.removeChild(this._propBalao);
			this.removeChild(this._ajusteBalao);
			this.removeChild(this._ajusteImagem);
			this.removeChild(this._cancelar);
			this.removeChild(this._salvar);
		
			// remove child em todos os outros botoes
		}
		
		private function cliqueSalvar(evento:MouseEvent):void
		{
			this.removeBotoes();
			this._bmpData = new BitmapData(stage.stageWidth, stage.stageHeight);
			this._bmpData.draw(stage);
			
			var bmpArray:ByteArray = this._bmpData.encode(new Rectangle(0, 0, this._bmpData.width, this._bmpData.height), new JPEGEncoderOptions(100));
			var bmpCache:File = File.cacheDirectory.resolvePath('bmptemp.jpg');
			var fstream:FileStream = new FileStream();
			fstream.open(bmpCache, FileMode.WRITE);
			fstream.writeBytes(bmpArray);
			fstream.close();
			
			this.mudaTela('salvar', null);
		}
	}

}