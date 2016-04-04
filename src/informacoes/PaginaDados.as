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
		
		public var imagens:Vector.<ImagemDados> = new Vector.<ImagemDados>();
		
		public var baloes:Vector.<BalaoDados> = new Vector.<BalaoDados>();
		
		public function PaginaDados(objeto:Object = null) 
		{
			if (objeto != null) {
				for (var i:int = 0; i < objeto.imagens.length; i++) {
					this.imagens.push(new ImagemDados(objeto.imagens[i]));
				}
				for (i = 0; i < objeto.baloes.length; i++) {
					this.baloes.push(new BalaoDados(objeto.baloes[i]));
				}
			}
		}
		public function dispose():void{
			while (this.imagens.length > 0) {
			  this.imagens.shift();	
				 
			}
			while (this.baloes.length > 0 ) {
				
				this.baloes.shift();
				
			}
			this.imagens = null;
			this.baloes = null;
		}
		
	}

}