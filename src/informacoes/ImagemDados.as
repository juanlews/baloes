package informacoes 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ImagemDados 
	{
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
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
			this.x = dados.x;
			this.y = dados.y;
			// outras propriedades aqui
		}
		
		/**
		 * Limpa informações sobre este objeto.
		 */
		public function clear():void
		{
			this.x = 0;
			this.y = 0;
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