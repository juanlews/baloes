package telas
{
	import componentes.Balao;
	import componentes.Imagem;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.Event;
	import componentes.BotaoIcone;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	
	public class TelaEditBalao extends Tela
	{
		
		private var _imagem:Imagem;
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		private var _oRotacao:Number;
		private var _oPosicao:Point;
		private var _oZoom:Number;
		
		private var _balao:Balao;
		
		public function TelaEditBalao(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			this.addChild(this._ok);
			this.addChild(this._cancelar);
			
			this._ok.width = stage.stageWidth / 6;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 8;
			this._ok.y = stage.stageHeight - this._ok.width;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / 6;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth / 1.4;
			this._cancelar.y = stage.stageHeight - this._cancelar.height;
			
			if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
			{
				
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				this._balao.addEventListener(MouseEvent.MOUSE_DOWN, dragBalaoStart);
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
				stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
				stage.addEventListener(MouseEvent.MOUSE_UP, dragBalaoStop);
				
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
		}
		
		override public function recebeDados(dados:Object):void
		{
			if (dados != null)
			{
				if (dados.balao != null)
				{
					this._balao = dados.balao as Balao;
					this._oPosicao = new Point(this._balao.x, this._balao.y);
					this._oRotacao = this._balao.rotation;
					this._oZoom = this._balao.scaleX;
					
					addChild(this._balao);
					
				}
				if (dados.imagem != null)
				{
					this._imagem = dados.imagem as Imagem;
					addChild(_imagem);
					
				}
			}
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('fotorecuperada', null);
		
		}
		
		private function cliqueOk(evento:MouseEvent):void
		{
			this.mudaTela('fotorecuperada', null);
		
		}
		
		private function dragBalaoStart(evento:MouseEvent):void
		{
			
			this._balao.startDrag();
		}
		
		private function dragBalaoStop(evento:MouseEvent):void
		{
			
			this._balao.stopDrag();
		}
		
		private function zoomBalao(evento:TransformGestureEvent):void
		{
			_balao.scaleX *= evento.scaleX;
			_balao.scaleY = _balao.scaleX;
		}
		
		private function rotacaoBalao(evento:TransformGestureEvent):void
		{
			_balao.rotation += evento.rotation;
		
		}
	
	}

}