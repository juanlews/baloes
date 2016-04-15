package informacoes
{
	import informacoes.PaginaDados;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	import flash.utils.ByteArray;
	
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
			this.tags = new Array();
			this.clear();
		
		}
		
		public function arquivoImagem(length:int, numero:int):File
		{
			return (this.pasta.resolvePath('imagens/pagina' + numero + '/' +  (length - 1) + '.jpg'));
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
		
		/**
		 * Exporta o conteúdo do projeto atual na forma de um arquivo binário único compactado.
		 */
		public function exportar():void
		{
			// salvando o projeto atual
			this.salvarDados();
			// exportando
			this.exportarID(this.id);
		}
		
		/**
		 * Exporta o conteúdo do projeto com o ID indicado na forma de um arquivo binário único compactado.
		 * @param	prID	id do projeto a exportar
		 * @return	TRUE se o projeto existir e puder ser exportado
		 */
		public function exportarID(prID:String):Boolean
		{
			// o projeto existe?
			var pastaProj:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + prID);
			if (!pastaProj.isDirectory) {
				// a pasta do projeto indicado não foi encontrada
				return (false);
			} else {
				// verificando se existe o arquivo de informações do projeto
				var arqProj:File = pastaProj.resolvePath('projeto.json');
				if (!arqProj.exists) {
					// o arquivo de projeto não existe
					return (false);
				} else {
					// o arquivo de projeto está completo?
					var ok:Boolean = false;
					var json:Object;
					var stream:FileStream = new FileStream();
					stream.open(arqProj, FileMode.READ);
					var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();
					// recuperando o json
					try {
						json = JSON.parse(fileData);
						ok = true;
					} catch (e:Error) { }
					// json carregado
					if ((json.id == null) || (json.titulo == null) || (json.tags == null) || (json.paginas == null)) {
						// não há informações suficientes
						return (false);
					} else {
						// criando zip e arquivos para exportação
						var zip:FZip = new FZip();
						var fileBytes:ByteArray = new ByteArray();
						// adicionando arquivo de projeto
						stream.open(pastaProj.resolvePath('projeto.json'), FileMode.READ);
						fileBytes.clear();
						stream.readBytes(fileBytes);
						stream.close();
						zip.addFile((prID + '/projeto.json'), fileBytes);
						// adicionando arquivo de capa
						if (pastaProj.resolvePath('capa.jpg').exists) {
							stream.open(pastaProj.resolvePath('capa.jpg'), FileMode.READ);
							fileBytes.clear();
							stream.readBytes(fileBytes);
							stream.close();
							zip.addFile((prID + '/capa.jpg'), fileBytes);
						}
						// adicionando arquivos de imagem
						var pastaImagem:Array = pastaProj.resolvePath('imagens').getDirectoryListing();
						for (var indice:int = 0; indice < pastaImagem.length; indice++) {
							var pastaPagina:File = pastaImagem[indice] as File;
							if (pastaPagina.isDirectory) {
								var paginaLista:Array = pastaPagina.getDirectoryListing();
								for (var indiceLista:int = 0; indiceLista < paginaLista.length; indiceLista++) {
									var arqImagem:File = paginaLista[indiceLista] as File;
									stream.open(arqImagem, FileMode.READ);
									fileBytes.clear();
									stream.readBytes(fileBytes);
									stream.close();
									zip.addFile((prID + '/imagens/pagina' + indice + '/' + arqImagem.name), fileBytes);
								}
							}
						}
						// finalizando o arquivo zip
						stream.open(File.documentsDirectory.resolvePath(json.titulo + '.narrvisual'), FileMode.WRITE);
						zip.serialize(stream);
						stream.close();
						return (true);
					}
				}
			}
		}
		
		/**
		 * Importa o conteúdo de um projeto binário compactado.
		 * @param	origem	link para o local do arquivo binário
		 * @return	TRUE se o arquivo existir e puder ser aberto
		 */
		public function importar(origem:File):Boolean
		{
			// abrindo arquivo de origem
			if (origem.exists) {
				// criando pasta temporária de importação
				this._pastaTemp = File.createTempDirectory();
				// recuperando informações do arquivo
				var stream:FileStream = new FileStream();
				var fileBytes:ByteArray = new ByteArray();
				stream.open(origem, FileMode.READ);
				fileBytes.clear();
				stream.readBytes(fileBytes);
				stream.close();
				// abrindo zip
				var zip:FZip = new FZip();
				zip.addEventListener(FZipEvent.FILE_LOADED, onZipLoaded);
				zip.addEventListener(Event.COMPLETE, onUnzipComplete);
				zip.loadBytes(fileBytes);
				// começando importação
				return (true);
			} else {
				// o arquivo indicado não foi encontrado
				return (false);
			}
		}
		
		/**
		 * Um arquivo dentro do zip de importação foi retirado.
		 */
		private function onZipLoaded(evt:FZipEvent):void
		{
			var zipfile:FZipFile = evt.file;
			if (zipfile.sizeUncompressed == 0) {
				// arquivo sem dados: não recriar
			} else {
				// descompactando o arquivo em disco
				var stream:FileStream = new FileStream();
				stream.open(this._pastaTemp.resolvePath(zipfile.filename), FileMode.WRITE);
				stream.writeBytes(zipfile.content);
				stream.close();
			}
		}
		
		/**
		 * Todos os arquivos dentro do zip de importação foram extraídos.
		 */
		private function onUnzipComplete(evt:Event):void
		{
			// liberando arquivo zip
			var zip:FZip = evt.target as FZip;
			zip.removeEventListener(FZipEvent.FILE_LOADED, onZipLoaded);
			zip.removeEventListener(Event.COMPLETE, onUnzipComplete);
			// verificando integridade do projeto
			var pastas:Array = this._pastaTemp.getDirectoryListing();
			if (pastas.length != 1) {
				// o arquivo descompactado não contém uma única pasta: não é uma exportação válida
				this.dispatchEvent(new Event(Event.CANCEL));
			} else {
				// verificando a pasta de projeto encontrada
				var pastaProjeto:File = pastas[0] as File;
				if (!pastaProjeto.isDirectory) {
					// não há uma pasta recuperada de projeto
					this.dispatchEvent(new Event(Event.CANCEL));
				} else {
					// verificando se há um arquivo de projeto
					var arquivoProjeto:File = pastaProjeto.resolvePath('projeto.json');
					if (!arquivoProjeto.exists) {
						// não há um arquivo de projeto
						this.dispatchEvent(new Event(Event.CANCEL));
					} else {
						// o arquivo é um json válido?
						var stream:FileStream = new FileStream();
						stream.open(arquivoProjeto, FileMode.READ);
						var fdata:String = stream.readUTFBytes(stream.bytesAvailable);
						stream.close();
						var ok:Boolean = false;
						var json:Object;
						try {
							json = JSON.parse(fdata);
							ok = true;
						} catch (e:Error) { }
						if (!ok) {
							// o arquivo não traz um json válido
							this.dispatchEvent(new Event(Event.CANCEL));
						} else {
							if ((json.id == null) || (json.titulo == null) || (json.tags == null) || (json.paginas == null)) {
								// o arquivo json não traz as informações necessárias
								this.dispatchEvent(new Event(Event.CANCEL));
							} else {
								// projeto ok: copiar para a pasta de documentos
								pastaProjeto.moveTo(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + json.id), true);
								this.dispatchEvent(new Event(Event.COMPLETE));
							}
						}
					}
				}
			}
			// apagando pasta temporária
			this._pastaTemp.deleteDirectory(true);
		}
	
	}

}