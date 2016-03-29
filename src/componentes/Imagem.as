package componentes 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author 
	 */
	public class Imagem extends Sprite 
	{
		
		public var loader:Loader;
		private var _id:int;
		
		public function Imagem(id:int) {
			
			super();
			this._id = id;
			this.loader = new Loader();
			this.addChild(this.loader);
		}
		
		public function get id():int {
			
			return(_id);
			
		}
		
		public function centraliza(refStage:Stage):void {
			this.loader.x = -this.loader.width / 2;
			this.loader.y = -this.loader.height / 2;
			
			this.x = refStage.stageWidth / 2;
			this.y = refStage.stageHeight / 2;
		}
		
	}

}