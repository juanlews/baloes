package telas 
{
	import componentes.BotaoIcone;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaEditImagem extends Tela 
	{
		
		private var _imagem:Loader;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		private var _oRotacao:Number;
		private var _oPosicao:Point;
		private var _oZoom:Number;
		
		public function TelaEditImagem(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
		}
		
		override public function desenho(evento:Event = null):void 
		{
			super.desenho(evento);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
		}
		
		override public function escondendo(evento:Event):void 
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void {
			
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void {
			
		}
		
		override public function recebeDados(dados:Object):void 
		{
			this._imagem = dados.imagem as Loader;
			this._oPosicao = new Point(this._imagem.x, this._imagem.y);
			this._oRotacao = this._imagem.rotation;
			this._oZoom = this._imagem.scaleX;
		}
		
	}

}