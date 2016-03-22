package telas
{
	import componentes.BotaoIcone;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaVisualizar extends Tela
	{
		
		private var _imagem:Loader;
		private var _link:String;
		private const link:String = 'http://192.168.10.159/';
		private var _voltar:BotaoIcone;
		
		public function TelaVisualizar(funcMudaTela:Function)
		{
			super(funcMudaTela);
			_voltar = new BotaoIcone(Graficos.ImgPBOK);
			_imagem = new Loader();
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);

			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
			
			_voltar.width = stage.stageWidth / 5;
			_voltar.scaleY = _voltar.scaleX;
			_voltar.x = stage.stageWidth / 2 - _voltar.width / 2;
			_voltar.y = stage.stageHeight - _voltar.height;
			
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
				this._imagem.scaleY = this._imagem.scaleX;
				this._imagem.y = stage.stageHeight / 2 - _imagem.height / 2;
				this._imagem.x = 0;
			}
			addChild(_voltar);
			
			_voltar.addEventListener(MouseEvent.CLICK, voltar);
		
		}
		
		private function voltar(evento:MouseEvent):void
		{
			this.mudaTela('lista', null);
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void
		{
		
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void
		{
		
		}
		
		override public function recebeDados(dados:Object):void
		{
			this._imagem.contentLoaderInfo.addEventListener(Event.INIT, imagemCarregada);
			_link = link + 'baloes/gravados/';
			if (dados != null)
			{
				_link += dados.link as String;
				_imagem.load(new URLRequest(_link));
				trace("tela visualizar:", _link);
			}
		
			// add child _image
		
		}
		
		private function imagemCarregada(evento:Event):void
		{
			trace('carregou', _link)
			addChild(this._imagem);
			desenho();
		}
	
	}

}