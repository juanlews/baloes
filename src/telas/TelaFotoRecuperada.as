
package telas
{
	import caurina.transitions.Tweener;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.ErrorEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import informacoes.PaginaDados;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaFotoRecuperada extends Tela
	{
		
		// botoes
		private var _propBalao:BotaoIcone;
		private var _ajusteBalao:BotaoIcone;
		private var _ajusteImagem:BotaoIcone;
		private var _salvar:BotaoIcone;
		private var _cancelar:BotaoIcone;
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		private var _addBalao:BotaoIcone;
		
		// balão
		private var _balao:Vector.<Balao>;
		
		// imagem
		private var _imagem:Vector.<Imagem>;
		private var _bmpData:BitmapData;
		
		private var _tipobalao:int;
		private var _dados:Object;
		private var btscala:Number;
		
		// galeria
		private var _roll:CameraRoll;
		private var _file:File;
		
		//camera
		private var camera:CameraUI;
		//
		private var _exc:int;
		
		//
		public function TelaFotoRecuperada(funcMudaTela:Function)
		{
			btscala = 10;
			super(funcMudaTela);
			
			// criar balão
			this._balao = new Vector.<Balao>;
			
			// criar botões
			this._addBalao = new BotaoIcone(Graficos.ImgAddBalao);
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			this._propBalao = new BotaoIcone(Graficos.ImgPropBalao);
			this._ajusteBalao = new BotaoIcone(Graficos.ImgAjusteBalao);
			this._ajusteImagem = new BotaoIcone(Graficos.ImgAjusteImagem);
			this._salvar = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			
			_dados = new Object();
			
			this._roll = new CameraRoll();
			this._file = File.documentsDirectory;
			
			this.camera = new CameraUI();
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			if ((evento != null) && (evento.type == Event.RESIZE))
			{
				// centralizar imagem	
			}
			
			this._galeria.x = stage.stageWidth / 20;
			this._galeria.y = stage.stageHeight / 40;
			this._galeria.width = stage.stageWidth / btscala;
			this._galeria.scaleY = this._galeria.scaleX;
			
			//botão propiedades balão
			//this._propBalao.x = (this._galeria.width + this._galeria.x) + stage.stageWidth / 20;
			//this._propBalao.y = stage.stageHeight / 40;
			//this._propBalao.width = stage.stageWidth / btscala;
			//this._propBalao.scaleY = this._propBalao.scaleX;
			
			//botão ajuste do balão
			this._ajusteBalao.width = stage.stageWidth / btscala;
			this._ajusteBalao.scaleY = this._ajusteBalao.scaleX;
			this._ajusteBalao.x = (this._galeria.width + this._galeria.x) + stage.stageWidth / 20;
			this._ajusteBalao.y = stage.stageHeight / 40;
			
			//botão ajuste imagem
			this._ajusteImagem.x = (this._ajusteBalao.width + this._ajusteBalao.x) + stage.stageWidth / 20;
			this._ajusteImagem.y = stage.stageHeight / 40;
			this._ajusteImagem.width = stage.stageWidth / btscala;
			this._ajusteImagem.scaleY = this._ajusteImagem.scaleX;
			
			//botão add Balao
			this._addBalao..x = (this._ajusteImagem.width + this._ajusteImagem.x) + stage.stageWidth / 20;
			this._addBalao.y = stage.stageHeight / 40;
			this._addBalao.width = stage.stageWidth / btscala;
			this._addBalao.scaleY = this._addBalao.scaleX;
			// botão camera
			this._camera.width = stage.stageWidth / btscala;
			this._camera.scaleY = this._camera.scaleX;
			this._camera.x = stage.stageWidth - _camera.width - stage.stageWidth / 20;
			this._camera.y = stage.stageHeight / 40;
			//botão salvar			
			this._salvar.width = stage.stageWidth / btscala;
			this._salvar.scaleY = this._salvar.scaleX;
			this._salvar.x = stage.stageWidth / 20;
			this._salvar.y = stage.stageHeight - this._salvar.width - (stage.stageHeight / 40);
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - (stage.stageHeight / 40);
			
			//imagem recuperada
			
			// adicionar listeners dos cliques dos botões
			if (!this._salvar.hasEventListener(MouseEvent.CLICK))
			{
				
				this.addChild(linhabaixo);
				this.addChild(linhacima);
				
				for (var k:int = 0; k < _imagem.length; k++)
				{
					ObjetoAprendizagem.areaImagem.addChild(this._imagem[k]);
				}
				for (var i:int = 0; i < _balao.length; i++)
				{
					ObjetoAprendizagem.areaImagem.addChild(this._balao[i]);
				}
				//this.addChild(this._propBalao);
				this.addChild(this._ajusteBalao);
				this.addChild(this._ajusteImagem);
				this.addChild(this._salvar);
				this.addChild(this._cancelar);
				this.addChild(this._addBalao);
				this.addChild(this._camera);
				this.addChild(this._galeria);
				
				this._salvar.addEventListener(MouseEvent.CLICK, cliqueSalvar);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				this._propBalao.addEventListener(MouseEvent.CLICK, cliquePropB);
				this._ajusteBalao.addEventListener(MouseEvent.CLICK, cliqueAjusteB);
				this._ajusteImagem.addEventListener(MouseEvent.CLICK, cliqueAjusteImg);
				this._addBalao.addEventListener(MouseEvent.CLICK, addBalao);
				
				this._galeria.addEventListener(MouseEvent.CLICK, cliqueGaleria);
				this._camera.addEventListener(MouseEvent.CLICK, cliqueCamera);
				
				for (var j:int = 0; j < _balao.length; j++)
				{
					this._balao[j].addEventListener(MouseEvent.CLICK, cliquePropB);
				}
				
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		
		}
		
		private function cliqueCamera(evento:MouseEvent):void
		{
			trace('clique camera', _imagem.length);
			this.camera.addEventListener(MediaEvent.COMPLETE, cameracomplete);
			this.camera.addEventListener(Event.CANCEL, cameracancel);
			this.camera.addEventListener(ErrorEvent.ERROR, cameraerro);
			
			camera.launch("image");
		
		}
		
		private function cliqueGaleria(evento:MouseEvent):void
		{
			trace('clique galeria', _imagem.length);
			this._roll.addEventListener(Event.CANCEL, cameracancel);
			this._roll.addEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.addEventListener(ErrorEvent.ERROR, cameraerro);
			this._roll.browseForImage();
		
		}
		
		private function cameracancel(evento:Event):void
		{
			trace('camera cancel', _imagem.length);
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
		}
		
		private function cameraerro(evento:ErrorEvent):void
		{
			trace('camera erro', _imagem.length);
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._file.addEventListener(Event.SELECT, arquivoSelecionado);
			this._file.browseForOpen('Escolha uma imagem', [new FileFilter('arquivo de imagem', '*.jpg;*.png')]);
		}
		
		private function cameracomplete(evento:MediaEvent):void
		{
			trace('camera completa', _imagem.length);
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._imagem[_imagem.length] = new Imagem(_imagem.length);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			// COPIANDO O ARQUIVO
			
			// primeiro, recuperando a referência do arquivo original a partir do evento recebido
			var arquivoOrigem:File = evento.data.file;
			
			// segundo, criando a referência para o arquivo de destino
			// aqui, coloquei um local de exemplo - é preciso definir no caminho/nome do arquivo de acordo com o projeto
			
			var arquivoDestino:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id + '/imagens/pagina/');
			if (!arquivoDestino.isDirectory)
			{
				arquivoDestino.createDirectory();
				
			}
			// copiando o arquivo de imagem original para o destino
			arquivoOrigem.copyTo(arquivoDestino, true);
			
			// carregando a imagem do loader a partir do arquivo de destino
			this._imagem[_imagem.length - 1].loader.load(new URLRequest(arquivoDestino.url));
		
		}
		
		private function arquivoSelecionado(evento:Event):void
		{
			trace('arquivo selecionado', _imagem.length);
			this._file.removeEventListener(Event.SELECT, arquivoSelecionado);
			
			this._imagem[_imagem.length] = new Imagem(_imagem.length);
			
			// segundo, criando a referência para o arquivo de destino
			// aqui, coloquei um local de exemplo - é preciso definir no caminho/nome do arquivo de acordo com o projeto
			var arquivoDestino:File = Main.projeto.arquivoImagem(_imagem.length);
			
			// copiando o arquivo de imagem original para o destino
			this._file.copyTo(arquivoDestino);
			
			// carregando a imagem do loader a partir do arquivo de destino
			this._imagem[_imagem.length - 1].loader.load(new URLRequest(arquivoDestino.url));
			
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
		}
		
		private function imagemErro(evento:IOErrorEvent):void
		{
			trace('img erro', _imagem.length);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
			// tratar erro
		}
		
		private function imagemCarregada(evento:Event):void
		{
			trace('imagem carregada', _imagem.length);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			if (this._imagem[_imagem.length - 1].loader.content is Bitmap)
			{
				(this._imagem[_imagem.length - 1].loader.content as Bitmap).smoothing = true;
			}
			
			if (this._imagem[_imagem.length - 1].loader.width > this._imagem[_imagem.length - 1].loader.height)
			{
				trace("largura");
				this._imagem[_imagem.length - 1].width = ObjetoAprendizagem.areaImagem.width / ObjetoAprendizagem.areaImagem.scaleX;
				this._imagem[_imagem.length - 1].scaleY = this._imagem[_imagem.length - 1].scaleX;
			}
			else
			{
				trace('altura');
				this._imagem[_imagem.length - 1].height = ObjetoAprendizagem.areaImagem.height / ObjetoAprendizagem.areaImagem.scaleY;
				this._imagem[_imagem.length - 1].scaleX = this._imagem[_imagem.length - 1].scaleY;
			}
			
			ObjetoAprendizagem.areaImagem.addChild(this._imagem[_imagem.length - 1]);
			
			for (var i:int = 0; i < _balao.length; i++)
			{
				ObjetoAprendizagem.areaImagem.addChild(this._balao[i]);
			}
		
		}
		
		private function addBalao(evento:MouseEvent):void
		{
			
			this._balao[_balao.length] = new Balao(_balao.length);
			this._balao[_balao.length - 1].width = 300;
			this._balao[_balao.length - 1].scaleY = this._balao[_balao.length - 1].scaleX;
			this._balao[_balao.length - 1].x = ObjetoAprendizagem.areaImagem.width / 4;
			this._balao[_balao.length - 1].y = ObjetoAprendizagem.areaImagem.height / 4;
			ObjetoAprendizagem.areaImagem.addChild(_balao[_balao.length - 1]);
			this._balao[_balao.length - 1].addEventListener(MouseEvent.CLICK, cliquePropB);
		
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('inicial', null);		
		}
		
		private function cliquePropB(evento:MouseEvent):void
		{
			
			//trace('click propB');
			
			var balaoClicado:Balao = evento.target as Balao;
			
			this._dados.balao = balaoClicado;
			
			this.mudaTela('propriedadesbalao', _dados);
		
		}
		
		private function cliqueAjusteB(evento:MouseEvent):void
		{
			trace('click ajustB');
			this._dados.balao = _balao;
			this._dados.imagem = this._imagem;
			this.mudaTela('editbalao', _dados);
		}
		
		private function cliqueAjusteImg(evento:MouseEvent):void
		{
			trace('click ajusteImg');
			
			this._dados.balao = _balao;
			this._dados.imagem = this._imagem;
			this.mudaTela('editimagem', _dados);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			
			// remover listeners
			this._salvar.removeEventListener(MouseEvent.CLICK, cliqueSalvar);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
			this._propBalao.removeEventListener(MouseEvent.CLICK, cliquePropB);
			this._ajusteBalao.removeEventListener(MouseEvent.CLICK, cliqueAjusteB);
			this._ajusteImagem.removeEventListener(MouseEvent.CLICK, cliqueAjusteImg);
			this._addBalao.removeEventListener(MouseEvent.CLICK, addBalao);
			stage.removeEventListener(Event.RESIZE, desenho);
			for (var i:int = 0; i < _balao.length; i++)
			{
				this._balao[i].removeEventListener(MouseEvent.CLICK, cliquePropB);
			}
		}
		
		override public function recebeDados(dados:Object):void
		{
			
			ObjetoAprendizagem.areaImagem.visible = true;
			if (dados != null)
			{
				if (dados.imagem != null)
				{
					trace('tem Imagem');
					this._imagem = dados.imagem as Vector.<Imagem>;
					
				}
				if (dados.balaoProp != null)
				{
					this._balao[dados.indice].copyProp(dados.balaoProp as Balao);
				}
				if (dados.balao != null)
				{
					trace('tem Balao');
					
					this._balao = dados.balao as Vector.<Balao>;
				}
				if (dados.balaoExclui != null)
				{
					this._exc = dados.balaoExclui as int;
					
					this.removeChild(this._balao[_exc]);
					
					this._balao.splice(this._exc, 1);
					
					trace('excluindo o balão' + this._exc);
					
					for (var xis:int = 0; xis < _balao.length; xis++)
					{
						this._balao[xis].id = xis;
					}
					
				}
				
			}
		
		}
		
		private function removeBotoes():void
		{
			this.removeChild(this._propBalao);
			this.removeChild(this._ajusteBalao);
			this.removeChild(this._ajusteImagem);
			this.removeChild(this._cancelar);
			this.removeChild(this._salvar);
			this.removeChild(this._addBalao);
			this.removeChild(this._galeria);
			this.removeChild(this._camera);
		
			// remove child em todos os outros botoes
		}
		
		private function cliqueSalvar(evento:MouseEvent):void
		{
			//this.removeBotoes();
			ObjetoAprendizagem.areaImagem.visible = false;
			salvarPagina();
			var bmpArray:ByteArray = ObjetoAprendizagem.areaImagem.getPicture('jpg', 100);
			var bmpCache:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id + '/capa.jpg');
			var fstream:FileStream = new FileStream();
			fstream.open(bmpCache, FileMode.WRITE);
			fstream.writeBytes(bmpArray);
			fstream.close();
			
			this.mudaTela('salvar', null);
		
		}
		
		/**
		 * Salva as informações da página atual nos objetos de dados.
		 */
		private function salvarPagina():void
		{
			// criando objeto de informação de página
			var pagina:PaginaDados = new PaginaDados();
			
			// número igual a zero por enquanto - depois será preciso fazer um contador para saber em qual página estamos
			pagina.numero = 0;
			
			// conferindo todos os balões
			for (var i:int = 0; i < this._balao.length; i++)
			{
				// a função "recuperaDados" do balão retorna um objeto "BalaoDados" para incorporar aos dados da página
				// adicionamos um objeto de dados para cada balão
				pagina.baloes.push(this._balao[i].recuperaDados());
			}
			
			// conferindo todas as imagens
			for (i = 0; i < this._imagem.length; i++)
			{
				// o funcionamento é o mesmo dos balões
				pagina.imagens.push(this._imagem[i].recuperaDados());
			}
			
			// gravando a página no projeto
			Main.projeto.guardaPagina(pagina);
		
			// salvar o projeto aqui???
		}
	
	}

}
