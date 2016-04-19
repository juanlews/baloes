package telas
{
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class Tela extends Sprite
	{
				
		protected var mudaTela:Function;
		protected var linhacima:Shape;
		protected var linhabaixo:Shape;
	    private var define:int = 0;
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
			if (linhacima.width == 0)
			{
				linhacima.graphics.beginFill(0xFF9900);
				linhacima.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight / 10);
				linhacima.graphics.endFill();
				
				linhabaixo.graphics.beginFill(0xDC143C);
				linhabaixo.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight / 10);
				linhabaixo.graphics.endFill();
			}
			
			linhabaixo.y = stage.stageHeight - stage.stageHeight / 10;
			linhabaixo.x = 0;
			
			if(define == 0){
			const area:Rectangle = new Rectangle(0, (0 + linhacima.height), stage.stageWidth, (stage.stageHeight - linhacima.height - linhabaixo.height));
			ObjetoAprendizagem.areaImagem.fitOnArea(area);
			define++;
			}
			this.addChild(ObjetoAprendizagem.areaImagem);
		    
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