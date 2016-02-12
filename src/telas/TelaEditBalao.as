package telas 
{
	import componentes.Balao;
	import flash.display.Loader;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.Event;
	import componentes.BotaoIcone;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaEditBalao extends Tela 
	{
		
		private var _imagem:Loader;
		private var _balao:Balao;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		
		public function TelaEditBalao(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
		}
		
		override public function desenho(evento:Event = null):void 
		{
			super.desenho(evento);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
		}
		
		override public function escondendo(evento:Event):void 
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
		}
		
		private function zoomBalao(evento:TransformGestureEvent):void {
			
		}
		
		private function rotacaoBalao(evento:TransformGestureEvent):void {
			
		}
		
	}

}