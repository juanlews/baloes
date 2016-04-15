package componentes 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class BotaoIcone extends Sprite 
	{
		private var bmp:Bitmap;
		
		public function BotaoIcone(imagem:Class) 
		{
			super();
			bmp = new imagem() as Bitmap;
			this.addChild(bmp);
			
		}
		public function dispose():void{
			removeChildren();
			bmp.bitmapData.dispose();
			bmp = null;
		}
	}

}