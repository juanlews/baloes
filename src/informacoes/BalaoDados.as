package informacoes 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class BalaoDados 
	{
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var width:Number = 0;
		
		public var height:Number = 0;
		
		public var rotation:Number = 0;
		
		public var scaleX:Number = 0;
		
		public var scaleY:Number = 0;
		
		public var tipo:int = 0;
		
		public var texto:String = '';
		
		public var idCor:int;
		
		public var corAzul:int = 0;
		
		public var corVermelho:int = 0;
		
		public var corVerde:int = 0;
		
		public var flipV:Boolean = false;
		
		public var flipH:Boolean = false;
		
		public var corTexto:int = 0;
		
		public var id:int = 0;
		
		
		
		public function BalaoDados(objeto:Object = null) 
		{
			if (objeto != null) this.processar(objeto);
		}
		
		/**
		 * Processa informações sobre um balão.
		 * @param	dados	informações sobre um objeto de dados de balão
		 */
		public function processar(dados:Object):void
		{
			this.clear();
			this.x = dados.x;
			this.y = dados.y;
			this.width = dados.width;
			this.height = dados.height;
			this.rotation = dados.rotation;
			this.scaleX = dados.scaleX;
			this.scaleY = dados.scaleY;
			this.tipo = dados.tipo;
			this.flipH = dados.flipH;
			this.flipV = dados.flipV;
			this.texto = dados.texto;
			this.idCor = dados.idCor;
			this.corAzul = dados.corAzul;
			this.corVermelho = dados.corVermelho;
			this.corVerde = dados.corVerde;
			this.corTexto = dados.corTexto;
			this.id = dados.id;
		}
		
		/**
		 * Limpa informações sobre este objeto.
		 */
		public function clear():void
		{
			this.x = 0;
			this.y = 0;
			this.width = 0;
			this.height = 0;
			this.rotation = 0;
			this.scaleX = 0;
			this.scaleY = 0;
			this.tipo = 0;
			this.texto = '';
			this.corAzul = 0;
			this.corVermelho = 0;
			this.corVerde = 0;
			this.corTexto = 0;
			this.id = 0;
		}
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			// variáveis numéricas ou booleanas não precisam ser igualadas a null
			this.texto = null;
		}
	}

}