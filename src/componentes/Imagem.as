package componentes
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import informacoes.ImagemDados;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author
	 */
	public class Imagem extends Sprite
	{
		
		public var loader:Loader;
		private var _id:int;
		private var btExcImagem:BotaoIcone;
		
		public function Imagem(id:int = 0)
		{
			super();
			this._id = id;
			this.loader = new Loader();
			this.btExcImagem = new BotaoIcone(Graficos.excImagem);
			this.addChild(this.loader);
			addChild(this.btExcImagem);
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			this.btExcImagem.visible = false;
		
		}
		
		public function get id():int
		{
			return (_id);
		}
		public function set id(para:int):void
		{
			this._id = para;
		}
		public function centraliza(refStage:Stage):void
		{
			this.loader.x = -this.loader.width / 2;
			this.loader.y = -this.loader.height / 2;
			
			this.x = refStage.stageWidth / 2;
			this.y = refStage.stageHeight / 2;
		}
		
		/**
		 * Recuperando informações da imagem na forma de um objeto ImagemDados.
		 * @return	objeto ImagemDados com informações sobre esta imagem
		 */
		public function recuperaDados():ImagemDados
		{
			var dados:ImagemDados = new ImagemDados();
			dados.id = this._id;
			dados.x = this.x;
			dados.y = this.y;
			dados.rotation = this.rotation;
			dados.scaleX = this.scaleX;
			dados.scaleY = this.scaleY;
			
			// acrescentar aqui todas as outras propriedades a salvar
			mouseChildren = true;
			return (dados);
		}
		
		public function dispose():void
		{
			this.removeChildren();
			this.loader.unload();
			if (this.loader.hasEventListener(Event.COMPLETE))
			{
				try
				{
					this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
				}
				catch (e:Error)
				{
				}
			}
			this.loader = null;
		}
		
		public function recebeDados(dados:ImagemDados, pagina:int):void
		{
			
			this._id = dados.id;
			this.x = dados.x;
			this.y = dados.y;
			this.rotation = dados.rotation;
			this.scaleX = dados.scaleX;
			this.scaleY = dados.scaleY;
			
			trace('carregando', Main.projeto.pasta.resolvePath('imagens/pagina' + pagina + '/' + _id + '.jpg').url);
			
			this.loader.load(new URLRequest(Main.projeto.pasta.resolvePath('imagens/pagina' + pagina + '/' + _id + '.jpg').url));
		
			// acrescentar aqui todas as outras propriedades a salvar
		
		}
		
		public function exclui(ativo:Boolean = false):void
		{
			if (ativo == true)
			{
				this.btExcImagem.visible = true;
				this.btExcImagem.x = loader.x;
				this.btExcImagem.y = loader.y;
				this.btExcImagem.addEventListener(MouseEvent.CLICK, excluiImagem);
				
			}
			else
			{
				this.btExcImagem.visible = false
				
			}
		
		}
		
		private function excluiImagem(evento:MouseEvent):void
		{
			dispatchEvent(new Event(String(_id), true));
			this.dispose();
			this.btExcImagem.dispose();
		
		}
		
		public function redefineId(id:int, nPag:int):void{
			
			var arquivoAtual:File = Main.projeto.pasta.resolvePath('imagens/pagina' + nPag + '/' + _id + '.jpg');
			var arquivoFinal:File = Main.projeto.pasta.resolvePath('imagens/pagina' + nPag + '/' + id + '.jpg');
			arquivoAtual.moveTo(arquivoFinal, true);
			this._id = id;
			
		}
		
		private function complete(evt:Event):void
		{
			(this.loader.content as Bitmap).smoothing = true;
			this.loader.x = -this.loader.width / 2;
			this.loader.y = -this.loader.height / 2;
		}
	
	}

}