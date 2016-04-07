package informacoes
{
	import informacoes.PaginaDados;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ProjetoDados
	{
		
		public var titulo:String = '';
		
		public var tags:Array;
		
		public var id:String = '';
		
		public var pasta:File;
		
		public var paginas:Vector.<PaginaDados> = new Vector.<PaginaDados>();
		//public var pagina:PaginaDados;
		
		public function ProjetoDados()
		{
			
			this.clear();
		
		}
		
		public function arquivoImagem(length:int):File
		{
			return (this.pasta.resolvePath('imagens/pagina/' +  (length - 1) + '.jpg'));
		}
		
				
		public function parse(strdados:String):Boolean
		{
			
			var retorno:Boolean = false;
			var dados:Object;
			try
			{
				dados = JSON.parse(strdados);
				retorno = true;
			}
			catch (e:Error)
			{
				// nada
			}
			
			if (retorno)
			{
				
				this.clear(dados.id);
				
				this.titulo = dados.titulo;
				this.tags = dados.tags;
				this.id = dados.id;
				for (var i:int = 0; i < dados.paginas.length; i++)
				{
					
					this.paginas.push(new PaginaDados(dados.paginas[i]));
				}
			}
			
			return (this.salvarDados());
			//return (retorno);
		}
		
		public function clear(id:String = null):void
		{
			this.tags = new Array();
			if (id == null) {
				this.id = String(new Date().getTime());
			} else {
				this.id = id;
			}
			this.titulo = '';
			while (this.tags.length > 0)
			{
				this.tags.shift();
			}
			while (this.paginas.length > 0)
			{
				this.paginas.shift().dispose();
			}
			
			
			
			this.pasta = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + this.id);
			
			trace ('pasta', this.pasta.url);
		
		}
		
		public function salvarDados():Boolean
		{
			
			
			if (!this.pasta.isDirectory)
			{
				this.pasta.createDirectory();
			}
			
		var pastaImagens:File = this.pasta.resolvePath('imagens');
		
			if (!pastaImagens.isDirectory)
			{
				pastaImagens.createDirectory();
				
			}
			
			
			var stringSave:String = JSON.stringify(this);
			var arquivo:File = this.pasta.resolvePath('projeto.json');
			var stream:FileStream = new FileStream();
		    stream.open(arquivo, FileMode.WRITE);
			stream.writeUTFBytes(stringSave);
			stream.close();
			
			return(true);
		
		}
		
		/**
		 * Guarda informações sobre uma página.
		 * @param	pagina	informações sobre a página
		 * @return	TRUE se os dados enviados estiverem de acordo com a estrutura de página
		 */
		public function guardaPagina(pagina:PaginaDados):Boolean
        {
            if (pagina.numero >= 0)
            { // somente guardar páginas com número maior ou igual a zero
                // o número da página indicada ainda não existe
                while (this.paginas.length < (pagina.numero + 1)) {
                    this.paginas.push(new PaginaDados());
                }
                // guardar as informações da página no local certo
                return (this.paginas[pagina.numero].processar(pagina));
            }
            else
            {
                return (false);
            }
        }
		
		public function carregaProjeto(id:String):Boolean
		{
			var json:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + id + '/projeto.json');
			if (json.exists) {
				var stream:FileStream = new FileStream();
				stream.open(json, FileMode.READ);
				var jsonText:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				return (this.parse(jsonText));
			} else {
				return (false);
			}
		}
	
	}

}