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
		
		public function BotaoIcone(imagem:Class) 
		{
			super();
			var bmp:Bitmap = new imagem() as Bitmap;
			this.addChild(bmp);
			
		}
		
	}

}