package componentes
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import informacoes.ImagemDados;
	
	/**
	 * ...
	 * @author
	 */
	public class Imagem extends Sprite
	{
		
		public var loader:Loader;
		private var _id:int;
		
		public function Imagem(id:int = 0)
		{
			
			super();
			this._id = id;
			this.loader = new Loader();
			this.addChild(this.loader);
		}
		
		public function get id():int
		{
			
			return (_id);
		
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
			
			// acrescentar aqui todas as outras propriedades a salvar
			
			return (dados);
		}
		
		public function dispose():void
		{
			this.removeChildren();
			this.loader.unload();
			this.loader = null;
		}
		
		public function recebeDados(dados:ImagemDados):void
		{
			
			this._id = dados.id;
			this.x = dados.x;
			this.y = dados.y;
			
			trace ('carregando', Main.projeto.pasta.resolvePath('imagens/pagina/' + _id + '.jpg').url);
			
			this.loader.load(new URLRequest(Main.projeto.pasta.resolvePath('imagens/pagina/' + _id + '.jpg').url));
			
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			// acrescentar aqui todas as outras propriedades a salvar
		
		}
		
		private function complete(evt:Event):void {
			this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			(this.loader.content as Bitmap).smoothing = true;
		}
	
	}

}