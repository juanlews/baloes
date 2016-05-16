package informacoes 
{
	import informacoes.BalaoDados;
	import informacoes.ImagemDados;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class PaginaDados 
	{
		/**
		 * Número da página, começando em 0 (números negativos indicam que a página não contém dados).
		 */
		public var numero:int = -1;
		
		/**
		 * Informações sobre as imagens da página.
		 */
		public var imagens:Vector.<ImagemDados> = new Vector.<ImagemDados>();
		
		/**
		 * Informações sobre os balões da página.
		 */
		public var baloes:Vector.<BalaoDados> = new Vector.<BalaoDados>();
		
		/**
		 * A página tem uma moldura?
		 */
		public var moldura:Boolean = false;
		
		
		public function PaginaDados(objeto:Object = null) 
		{
			if (objeto != null) this.processar(objeto);
		}
		
		/**
		 * Processa um objeto com dados de uma página, recriando as informações na estrutura comum.
		 * @param	dados	objeto com informações sobre a página
		 * @return	TRUE se o objeto trouxer informações que possam ser usadas
		 */
		public function processar(dados:Object):Boolean
		{
			// verificando se o objeto de dados traz todos os campos necessários
			if ((dados.numero != null) && (dados.imagens != null) && (dados.baloes != null)) {
				// limpando quaisquer dados anteriores
				this.clear();
				// número da página
				this.numero = dados.numero;
				// imagens
				for (var i:int = 0; i < dados.imagens.length; i++) this.imagens.push(new ImagemDados(dados.imagens[i]));
				// balões
				for (i = 0; i < dados.baloes.length; i++) this.baloes.push(new BalaoDados(dados.baloes[i]));
				// moldura
				if (dados.moldura != null) this.moldura = Boolean(dados.moldura);
				// página recriada
				return (true);
			} 
			else {
				// o objeto de dados não traz informações de uma página
				return (false);
			}
		}
		
		/**
		 * Limpando informações deste objeto.
		 */
		public function clear():void
		{
			this.numero = -1; // número de página = -1 indica que não há informações carregadas
			while (this.imagens.length > 0) this.imagens.shift().dispose();
			while (this.baloes.length > 0) this.baloes.shift().dispose();
		}
		
		/**
		 * Liberando recursos usado por este objeto.
		 */
		public function dispose():void{
			while (this.imagens.length > 0) {
			  this.imagens.shift().dispose();	
			}
			while (this.baloes.length > 0 ) {
				this.baloes.shift().dispose();
				
			}
			this.imagens = null;
			this.moldura = null;
			this.baloes = null;
		}
		
	}

}