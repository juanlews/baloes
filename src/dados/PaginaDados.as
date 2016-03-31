package dados 
{
	/**
	 * ...
	 * @author 
	 */
	public class PaginaDados 
	{
		public var imagens:Vector.<ImagemDados>;
		public var baloes:Vector.<BalaoDados>;
		
		public function PaginaDados(json:String = null) 
		{
		 
			if (json == null) {
				// criar pagna vazia
			} else {
				// criar p´´agina a partir do json
				
			}
			
			this.imagens = new Vector.<ImagemDados>();
			this.baloes = new Vector.<BalaoDados>();
			
			
			this.imagens.push(new ImagemDados());
			this.baloes.push(new BalaoDados());
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
		
		public function toString():String {
			var objetoDados:Object = new Object();
			var imagensTXT:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < this.imagens.length; i++) {
				imagensTXT.push(this.imagens[i].toString());
			}
			objetoDados.imagens = imagensTXT.join(',');
			var baloesTXT:Vector.<String> = new Vector.<String>();
			for (i = 0; i < this.imagens.length; i++) {
				baloesTXT.push(this.baloes[i].toString());
			}
			objetoDados.baloes = baloesTXT.join(',');
			return (JSON.stringify(objetoDados));
		}
		
	}

}