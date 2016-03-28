package telas
{
	import caurina.transitions.Tweener;
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
	import flash.geom.Point;
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
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		private var _addBalao:BotaoIcone;
		
		// balão
		private var _balao:Vector.<Balao>;
		
		// imagem
		private var _imagem:Imagem;
		private var _bmpData:BitmapData;
		
		private var _tipobalao:int;
		private var _dados:Object;
		private var btscala:Number;
		
		public function TelaFotoRecuperada(funcMudaTela:Function)
		{
			btscala = 10;
			super(funcMudaTela);
			
			// criar balão
			this._balao = new Vector.<Balao>;
			
			// criar botões
			this._addBalao = new BotaoIcone(Graficos.ImgAddBalao);
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			this._propBalao = new BotaoIcone(Graficos.ImgPropBalao);
			this._ajusteBalao = new BotaoIcone(Graficos.ImgAjusteBalao);
			this._ajusteImagem = new BotaoIcone(Graficos.ImgAjusteImagem);
			this._salvar = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			
			_dados = new Object();
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			if ((evento != null) && (evento.type == Event.RESIZE))
			{
				// centralizar imagem
				
			}
			
			this._galeria.x = stage.stageWidth / 20;
			this._galeria.y = stage.stageHeight / 40;
			this._galeria.width = stage.stageWidth / btscala;
			this._galeria.scaleY = this._galeria.scaleX;
			
			//botão propiedades balão
			this._propBalao.x = (this._galeria.width + this._galeria.x) + stage.stageWidth / 20;
			this._propBalao.y = stage.stageHeight / 40;
			this._propBalao.width = stage.stageWidth / btscala;
			this._propBalao.scaleY = this._propBalao.scaleX;
			
			//botão ajuste do balão
			this._ajusteBalao.width = stage.stageWidth / btscala;
			this._ajusteBalao.scaleY = this._ajusteBalao.scaleX;
			this._ajusteBalao.x = (this._propBalao.width + this._propBalao.x) + stage.stageWidth / 20;
			this._ajusteBalao.y = stage.stageHeight / 40;
			
			//botão ajuste imagem
			this._ajusteImagem.x = (this._ajusteBalao.width + this._ajusteBalao.x) + stage.stageWidth / 20;
			this._ajusteImagem.y = stage.stageHeight / 40;
			this._ajusteImagem.width = stage.stageWidth / btscala;
			this._ajusteImagem.scaleY = this._ajusteImagem.scaleX;
			//add Balao
			this._addBalao..x = (this._ajusteImagem.width + this._ajusteImagem.x) + stage.stageWidth / 20;
			this._addBalao.y = stage.stageHeight / 40;
			this._addBalao.width = stage.stageWidth / btscala;
			this._addBalao.scaleY = this._addBalao.scaleX;
			//camera
			this._camera.width = stage.stageWidth / btscala;
			this._camera.scaleY = this._camera.scaleX;
			this._camera.x = stage.stageWidth - _camera.width - stage.stageWidth / 20;
			this._camera.y = stage.stageHeight / 40;
			//botão salvar			
			this._salvar.width = stage.stageWidth / btscala;
			this._salvar.scaleY = this._salvar.scaleX;
			this._salvar.x = stage.stageWidth / 20;
			this._salvar.y = stage.stageHeight - this._salvar.width - (stage.stageHeight / 40);
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - (stage.stageHeight / 40);
			
			//imagem recuperada
			
			// adicionar listeners dos cliques dos botões
			if (!this._salvar.hasEventListener(MouseEvent.CLICK))
			{
				
				this.addChild(this._imagem);
				this.addChild(linhabaixo);
				this.addChild(linhacima);
				
				for (var i:int = 0; i < _balao.length; i++)
				{
					this.addChild(this._balao[i]);
				}
				this.addChild(this._propBalao);
				this.addChild(this._ajusteBalao);
				this.addChild(this._ajusteImagem);
				this.addChild(this._salvar);
				this.addChild(this._cancelar);
				this.addChild(this._addBalao);
				this.addChild(this._camera);
				this.addChild(this._galeria);
				
				this._salvar.addEventListener(MouseEvent.CLICK, cliqueSalvar);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				this._propBalao.addEventListener(MouseEvent.CLICK, cliquePropB);
				this._ajusteBalao.addEventListener(MouseEvent.CLICK, cliqueAjusteB);
				this._ajusteImagem.addEventListener(MouseEvent.CLICK, cliqueAjusteImg);
				this._addBalao.addEventListener(MouseEvent.CLICK, addBalao);
				
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		
		}
		
		private function addBalao(evento:MouseEvent):void
		{
			
			this._balao[_balao.length] = new Balao(_balao.length);
			this._balao[_balao.length - 1].width = 200;
			this._balao[_balao.length - 1].scaleY = this._balao[_balao.length - 1].scaleX;
			this._balao[_balao.length - 1].x = stage.stageWidth / 4;
			this._balao[_balao.length - 1].y = stage.stageHeight / 4;
			addChild(_balao[_balao.length - 1]);
		
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('inicial', null);
		
		}
		
		private function cliquePropB(evento:MouseEvent):void
		{
			
			trace('click propB');
			
			this._dados.balao = this._balao as Vector.<Balao>;
			this.mudaTela('propriedadesbalao', _dados);
		}
		
		private function cliqueAjusteB(evento:MouseEvent):void
		{
			trace('click ajustB');
			this._dados.balao = _balao as Vector.<Balao>;
			this._dados.imagem = this._imagem;
			this.mudaTela('editbalao', _dados);
		}
		
		private function cliqueAjusteImg(evento:MouseEvent):void
		{
			trace('click ajusteImg');
			
			this._dados.balao = _balao as Vector.<Balao>;
			this._dados.imagem = this._imagem;
			this.mudaTela('editimagem', _dados);
		
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
			this._addBalao.removeEventListener(MouseEvent.CLICK, addBalao);
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
		
		override public function recebeDados(dados:Object):void
		{
			
			if (dados != null)
			{
				if (dados.imagem != null)
				{
					trace('tem Imagem');
					this._imagem = dados.imagem as Imagem;
				}
				if (dados.balaoProp != null)
				{
					this._balao[dados.indice].copyProp(dados.balaoProp as Balao);
				}
				if (dados.balao != null)
				{
					trace('tem Balao');
					//for (var i:int; i < dados.indice; i++)
					
						this._balao = dados.balao as Vector.<Balao>;
					
					
				}
				
				// add child _image
				addChild(this._imagem);
				//addChild(this._balao[0]);
				
			}
		}
		
		private function removeBotoes():void
		{
			this.removeChild(this._propBalao);
			this.removeChild(this._ajusteBalao);
			this.removeChild(this._ajusteImagem);
			this.removeChild(this._cancelar);
			this.removeChild(this._salvar);
			this.removeChild(this._addBalao);
			this.removeChild(this._galeria);
			this.removeChild(this._camera);
		
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