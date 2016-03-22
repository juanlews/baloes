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
		
		private var dados:Object;
		private var btscala:Number;
		
		public function TelaEditBalao(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 10;
			dados = new Object();
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			this.removeChild(linhacima);
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
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
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragBalaoStop);
			stage.removeEventListener(Event.RESIZE, desenho);
			
			this._ok.removeEventListener(MouseEvent.CLICK, cliqueOk);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
			this._balao.removeEventListener(MouseEvent.MOUSE_DOWN, dragBalaoStart);
		
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
					
				}
				if (dados.imagem != null)
				{
					this._imagem = dados.imagem as Imagem;
					this._oPosicao = new Point(this._imagem.x, this._imagem.y);
					this._oRotacao = this._imagem.rotation;
					this._oZoom = this._imagem.scaleX;
					
				}
			}
			
			addChild(this._imagem);
			addChild(this._balao);
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			
			this.mudaTela('fotorecuperada', null);
		
		}
		
		private function cliqueOk(evento:MouseEvent):void
		{
			dados.imagem = _imagem;
			dados.balao = _balao;
			this.mudaTela('fotorecuperada', dados);
		
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