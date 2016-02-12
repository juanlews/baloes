package telas 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class Tela extends Sprite 
	{
		
		protected var mudaTela:Function;
		
		public function Tela(funcMudaTela:Function) 
		{
			super();
			this.graphics.beginFill(0XE6E6E6);
			this.graphics.endFill();
			this.mudaTela = funcMudaTela;
			this.addEventListener(Event.ADDED_TO_STAGE, desenho);
			this.addEventListener(Event.REMOVED_FROM_STAGE, escondendo);
		}
		
		public function desenho(evento:Event = null):void {
			// desenhar a tela
		}
		
		public function escondendo(evento:Event):void {
			// remove elementos
		}
		
		public function recebeDados(dados:Object):void {
			
		}
		
	}

}