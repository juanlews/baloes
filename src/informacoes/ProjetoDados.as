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
		
		
		public function ProjetoDados()
		{
			
			this.clear();
			//this.paginas.push(new PaginaDados());
			//this.paginas.push(new PaginaDados());
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
				this.titulo = dados.titulo;
				this.tags = dados.tags;
				this.id = dados.id;
				for (var i:int = 0; i < dados.paginas.length; i++)
				{
					
					this.paginas.push(new PaginaDados(dados.paginas[i]));
				}
			}
			
			return (retorno);
		}
		
		public function clear():void
		{
			this.tags = new Array();
			this.id = String(new Date().getTime());
			this.titulo = '';
			while (this.tags.length > 0)
			{
				this.tags.shift();
			}
			while (this.paginas.length > 0)
			{
				this.paginas.shift().dispose();
			}
			
			this.paginas.push(new PaginaDados());
			
			this.paginas.push(new PaginaDados());
			this.paginas.push(new PaginaDados());
			
			this.pasta = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + this.id);
		
		}
		
		public function salvarDados():void
		{
			
			if (!this.pasta.isDirectory)
			{
				this.pasta.createDirectory();
			}
			
			var objetoSalvar:Object = new Object();
			objetoSalvar.id = this.id;
			objetoSalvar.titulo = this.titulo;
			objetoSalvar.tags = this.tags.join(',');
			
			var paginasTXT:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < this.paginas.length; i++)
			{
				paginasTXT.push(this.paginas[i]);
			}
			objetoSalvar.paginas = paginasTXT.join(':|:');
			
			var stringSave:String = JSON.stringify(objetoSalvar);
			
			var arquivo:File = this.pasta.resolvePath('projeto.json');
			var stream:FileStream = new FileStream();
			stream.open(arquivo, FileMode.WRITE);
			stream.writeUTFBytes(stringSave);
			stream.close();
			
			var pastaImagens:File = this.pasta.resolvePath('imagens');
			if (!pastaImagens.isDirectory) pastaImagens.createDirectory();
		}
		
		/**
		 * Guarda informações sobre uma página.
		 * @param	pagina	informações sobre a página
		 * @return	TRUE se os dados enviados estiverem de acordo com a estrutura de página
		 */
		public function guardaPagina(pagina:PaginaDados):Boolean
		{
			if (pagina.numero >= 0) { // somente guardar páginas com número maior ou igual a zero
				// verificar a lista de páginas
				for (var i:int = 0; i <= pagina.numero; i++) {
					// percorrer o vetor de páginas e criar as páginas inexistentes até o número da recebida
					if (this.paginas[i] == null) this.paginas[i] = new PaginaDados();
				}
				// guardar as informações da página no local certo
				return(this.paginas[pagina.numero].processar(pagina));
			} else {
				return (false);
			}
		}
	
	}

}