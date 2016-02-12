package componentes 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class AnimacaoFrames extends Sprite 
	{
		
		private var _frames:Vector.<Bitmap>;
		private var _atual:int;
		private var _timer:int;
		private var _tempo:int;
		
		public function AnimacaoFrames(imagens:Vector.<Class>, tempo:int) 
		{
			super();
			_tempo = tempo;
			
			this._frames = new Vector.<Bitmap>();
			
			for (var i:int = 0; i < imagens.length; i++) {
				this._frames.push(new imagens[i]() as Bitmap);
			}
			
			this.addChild(this._frames[0]);
			_atual = 0;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, visivel);
			
		}
		
		private function visivel(evento:Event):void {
			this._timer = setInterval(proximo, _tempo);
			this.addEventListener(Event.REMOVED_FROM_STAGE, invisivel);
			this.removeEventListener(Event.ADDED_TO_STAGE, visivel);
		}
		
		private function invisivel(evento:Event):void {
			clearInterval(this._timer);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, invisivel);
			this.addEventListener(Event.ADDED_TO_STAGE, visivel);
		}
		
		private function proximo():void {
			_atual++;
			if (_atual >= _frames.length) _atual = 0;
			this.removeChildren();
			this.addChild(this._frames[_atual]);
		}
		
		
	}

}