package telas 
{
	import componentes.BotaoIcone;
	import flash.display.Loader;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaVisualizar extends Tela 
	{
		
		private var _imagem:Loader;
		private var _voltar:BotaoIcone;
		
		public function TelaVisualizar(funcMudaTela:Function) 
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
		
	}

}