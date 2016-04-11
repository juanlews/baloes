package informacoes 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ImagemDados 
	{
		public var id:int;
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var rotation:Number = 0;
		
		public var scaleX:Number = 0;
		
		public var scaleY:Number = 0;
		
		public function ImagemDados(objeto:Object = null) 
		{
			if (objeto != null) this.processar(objeto);
		}
		
		/**
		 * Processa informações sobre uma imagem.
		 * @param	dados	informações sobre um objeto de dados de imagem
		 */
		public function processar(dados:Object):void
		{
			this.clear();
			this.id = dados.id
			this.x = dados.x;
			this.y = dados.y;
			this.rotation = dados.rotation;
			this.scaleX = dados.scaleX;
			this.scaleY = dados.scaleY;
			
			// outras propriedades aqui
		}
		
		/**
		 * Limpa informações sobre este objeto.
		 */
		public function clear():void
		{
			this.id = 0;
			this.x = 0;
			this.y = 0;
			this.rotation = 0;
			this.scaleX = 0;
			this.scaleY = 0;
			// outras propriedades aqui
		}
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			// liberar variáveis aqui
		}
	
		
		
	}

}