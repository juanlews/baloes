package componentes 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author colaboa
	 */
	public class BotaoRadio extends BotaoIcone 
	{
		
		private var _selecionado:Boolean;
		
		public var grupo:Vector.<BotaoRadio> = new Vector.<BotaoRadio>();
		
		public var valor:String = '';
		
		public function BotaoRadio(imagem:Class, valor:String = '', inicial:Boolean = false) 
		{
			super(imagem);
			this._selecionado = inicial;
			this.valor = valor;
			
			if (!inicial) this.alpha = 0.5;
			
			if (!inicial) this.addEventListener(MouseEvent.CLICK, clique);
		}
		
		public function get marcado():Boolean {
			return (this._selecionado);
		}
		
		public function set marcado(para:Boolean):void {
			this._selecionado = para;
			
			if (this._selecionado) {
				this.alpha = 1;
				
				for (var i:int = 0; i < this.grupo.length; i++) {
					if (this.grupo[i] != this) this.grupo[i].marcado = false;
				}
				
			} else {
				this.alpha = 0.5;
				if (!this.hasEventListener(MouseEvent.CLICK)) {
					this.addEventListener(MouseEvent.CLICK, clique);
				}
			}
			
		}
		
		private function clique(evento:MouseEvent):void {
			this.marcado = true;
			this.removeEventListener(MouseEvent.CLICK, clique);
			this.dispatchEvent(new Event('marcado'));
			trace(marcado,'');
		}
		
	}

}