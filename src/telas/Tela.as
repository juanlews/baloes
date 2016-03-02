package telas
{
	import flash.display.Sprite;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	
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
			
			this.mudaTela = funcMudaTela;
			
			this.addEventListener(Event.ADDED_TO_STAGE, desenho);
			this.addEventListener(Event.REMOVED_FROM_STAGE, escondendo);
		
		}
		
		public function desenho(evento:Event = null):void
		{
			// desenhar a tela
			//this.stage.color = 0XE8E8E8;
		
		}
		
		public function escondendo(evento:Event):void
		{
			// remove elementos
		
		}
		
		public function recebeDados(dados:Object):void
		{
		
		}
	
	}

}