package telas
{
	import flash.display.Shape;
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
		protected var linhacima:Shape;
		protected var linhabaixo:Shape;
		
		public function Tela(funcMudaTela:Function)
		{
			super();
			
			this.mudaTela = funcMudaTela;
			
			this.addEventListener(Event.ADDED_TO_STAGE, desenho);
			this.addEventListener(Event.REMOVED_FROM_STAGE, escondendo);
			
			linhabaixo = new Shape();
			linhacima = new Shape();
			addChild(linhacima);
			addChild(linhabaixo);
		}
		
		public function desenho(evento:Event = null):void
		{
			// desenhar a tela
			if (linhacima.width == 0) {
				linhacima.graphics.beginFill(0xFF9900);
				linhacima.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight / 10);
				linhacima.graphics.endFill();
				
				linhabaixo.graphics.beginFill(0xFF0000);
				linhabaixo.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight / 10);
				linhabaixo.graphics.endFill();
			}
			
			
			linhabaixo.y = stage.stageHeight - stage.stageHeight / 10;
			linhabaixo.x = 0;
		
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