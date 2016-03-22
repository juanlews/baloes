package telas
{
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaEditImagem extends Tela
	{
		private var _imagem:Imagem;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		private var _oRotacao:Number;
		private var _oPosicao:Point;
		private var _oZoom:Number;
		private var dados:Object;
		private var btscala:Number;
		
		public function TelaEditImagem(funcMudaTela:Function)
		{
			super(funcMudaTela);
			dados = new Object();
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			btscala = 10;
			this.removeChild(linhacima);
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
			this._imagem.addEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
			
			this.addChild(this._ok);
			this.addChild(this._cancelar);
			
			this._ok.width = stage.stageWidth / btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 20;
			this._ok.y = stage.stageHeight - _ok.height - stage.stageHeight / 40;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - this.stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - stage.stageHeight / 40;
			
			if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
			{
				this.addChild(linhabaixo);
				
				this.addChild(this._ok);
				this.addChild(this._cancelar);
				
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		
		}
		
		private function cliqueOk(evento:MouseEvent):void
		{
			dados.imagem = _imagem;
			this.mudaTela('fotorecuperada', dados);
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('fotorecuperada', null);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
			this._imagem.removeEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
		
		private function dragImagemStart(evento:MouseEvent):void
		{
			trace('drag ', this._imagem.x += evento.movementX);
			this._imagem.startDrag();
		}
		
		private function dragImagemStop(evento:MouseEvent):void
		{
			
			trace(evento.movementX);
			this._imagem.stopDrag();
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void
		{
			_imagem.scaleX *= evento.scaleX;
			_imagem.scaleY = _imagem.scaleX;
		
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void
		{
			
			_imagem.rotation += evento.rotation;
		}
		
		override public function recebeDados(dados:Object):void
		{
			if (dados != null)
			{
				this._imagem = dados.imagem as Imagem;
				this._oPosicao = new Point(this._imagem.x, this._imagem.y);
				this._oRotacao = this._imagem.rotation;
				this._oZoom = this._imagem.scaleX;
				
			}
			
			else
			{
				
				trace('imagem nao carregada');
			}
			
			addChild(this._imagem);
		
		}
	}

}