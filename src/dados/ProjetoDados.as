package dados
{
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author
	 */
	public class ProjetoDados
	{
		public var id:String;
		public var titulo:String;
		public var tags:Vector.<String>;
		public var pasta:File;
		public var paginas:Vector.<PaginaDados>;
		
		public function ProjetoDados()
		{
			this.paginas = new Vector.<PaginaDados>();
			this.tags = new Vector.<String>();
			this.clear();
		}
		
		public function clear():void
		{
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

		public function salvarDados():void {
			
			if (!this.pasta.isDirectory)
			{
				this.pasta.createDirectory();
			}
		
			var objetoSalvar:Object = new Object();
			objetoSalvar.id = this.id;
			objetoSalvar.titulo = this.titulo;
			objetoSalvar.tags = this.tags.join(',');
			
			var paginasTXT:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < this.paginas.length; i++) {
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
		
		public function carregaProjeto(id:String):Boolean {
			var arquivoJSON:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + id + '/projeto.json');
			if (arquivoJSON.exists) {
				
				var stream:FileStream = new FileStream();
				stream.open(arquivoJSON, FileMode.READ);
				var textoJSON:String = stream.readUTFBytes(stream.bytesAvailable);
				
				var objetoCarregar:Object;
				try {
					objetoCarregar = JSON.parse(textoJSON);
				} catch (e:Error) {
					return (false);
				}
				
				if ((objetoCarregar.id != null) && (objetoCarregar.titulo != null) && (objetoCarregar.tags != null) && (objetoCarregar.paginas != null)) {
					
					this.id = String(objetoCarregar.id);
					this.titulo = String(objetoCarregar.titulo);
					
					while (this.tags.length > 0) this.tags.shift();
					var tagArray:Array = String(objetoCarregar.tags).split(',');
					for (var i:int = 0; i < tagArray.length; i++) {
						this.tags.push(tagArray[i]);
					}
					
					while (this.paginas.length > 0) this.paginas.shift().dispose();
					var pagArray:Array = String(objetoCarregar.paginas).split(':|:');
					for (var i:int = 0; i < pagArray.length; i++) {
						this.paginas.push(new PaginaDados(pagArray[i]));
					}
					
					
					return (true);
				} else {
					return (false);
				}
				
				
			} else {
				return (false);
			}
		}
		
	}

}