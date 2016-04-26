package telas
{
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import recursos.Graficos;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaInicial extends Tela
	{
		private var _id:String = '1460985335175';
		private var paginaAtual:int = 0;
		// botões
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		private var _carregar:BotaoIcone;
		
		// imagem
		private var _imgsHelp:Vector.<Class>;
		private var _imgAtual:int;
		private var _help:Bitmap;
		private var _imagem:Vector.<Imagem>;
		//balao
		private var _balao:Vector.<Balao>;
		// galeria
		private var _roll:CameraRoll;
		private var _file:File;
		
		//camera
		private var camera:CameraUI;
		
		//scale dos botões
		private var btscala:Number;
		
		//abrir file
		private var _btOpen:BotaoIcone;
		
		//
		private var editavel:Boolean = false;
		private var definido:Boolean = false;
		
		public function TelaInicial(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			btscala = 10;
			
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			this._btOpen = new BotaoIcone(Graficos.ImgOpenFile);
			this.addChild(this._galeria);
			this.addChild(this._btOpen);
			this._imgsHelp = new Vector.<Class>();
			this._imgsHelp.push(Graficos.ImgHelp01);
			this._imgsHelp.push(Graficos.ImgHelp02);
			this._imgsHelp.push(Graficos.ImgHelp03);
			this._imgAtual = 0;
			this._help = new this._imgsHelp[this._imgAtual]() as Bitmap;
			this.addChild(this._help);
			
			// criar outros botões
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			addChild(this._camera);
			
			this._carregar = new BotaoIcone(Graficos.ImgCarregar);
			addChild(this._carregar);
			
			// criando acesso à galeria
			this._roll = new CameraRoll();
			this._file = File.documentsDirectory;
			this._imagem = new Vector.<Imagem>;
			this._imagem[0] = new Imagem(0);
			this._balao = new Vector.<Balao>;
			// criando acesso à camera
			camera = new CameraUI();
		
		}
		
		private function cliqueCamera(evento:MouseEvent):void
		{
			this.camera.addEventListener(MediaEvent.COMPLETE, cameracomplete);
			this.camera.addEventListener(Event.CANCEL, cameracancel);
			this.camera.addEventListener(ErrorEvent.ERROR, cameraerro);
			
			camera.launch("image");
		}
		
		private function cliqueGaleria(evento:MouseEvent):void
		{
			
			this._roll.addEventListener(Event.CANCEL, cameracancel);
			this._roll.addEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.addEventListener(ErrorEvent.ERROR, cameraerro);
			this._roll.browseForImage();
		}
		
		private function cameracancel(evento:Event):void
		{
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
		}
		
		private function cameraerro(evento:ErrorEvent):void
		{
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._file.addEventListener(Event.SELECT, arquivoSelecionado);
			this._file.browseForOpen('Escolha uma imagem', [new FileFilter('arquivo de imagem', '*.jpg;*.png')]);
		}
		
		private function cameracomplete(evento:MediaEvent):void
		{
			this._imagem[0] = new Imagem(0);
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._imagem[0].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[0].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			// COPIANDO O ARQUIVO
			
			// primeiro, recuperando a referência do arquivo original a partir do evento recebido
			var arquivoOrigem:File = evento.data.file;
			
			// segundo, criando a referência para o arquivo de destino
			// aqui, coloquei um local de exemplo - é preciso definir no caminho/nome do arquivo de acordo com o projeto
			var arquivoDestino:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id + '/imagens/pagina' + paginaAtual + '/' + (_imagem.length - 1) + '.jpg');
			
			// copiando o arquivo de imagem original para o destino
			arquivoOrigem.copyTo(arquivoDestino);
			
			// carregando a imagem do loader a partir do arquivo de destino
			this._imagem[_imagem.length - 1].loader.load(new URLRequest(arquivoDestino.url));
		
		}
		
		private function arquivoSelecionado(evento:Event):void
		{
			this._file.removeEventListener(Event.SELECT, arquivoSelecionado);
			
			this._imagem[0] = new Imagem(0);
			// segundo, criando a referência para o arquivo de destino
			// aqui, coloquei um local de exemplo - é preciso definir no caminho/nome do arquivo de acordo com o projeto
			var arquivoDestino:File = Main.projeto.arquivoImagem(_imagem.length, paginaAtual);
			
			// copiando o arquivo de imagem original para o destino
			this._file.copyTo(arquivoDestino);
			
			// carregando a imagem do loader a partir do arquivo de destino
			this._imagem[0].loader.load(new URLRequest(arquivoDestino.url));
			
			this._imagem[0].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[0].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
			//this._imagem[0].loader.load(new URLRequest(this._file.url));
		}
		
		private function imagemErro(evento:IOErrorEvent):void
		{
			this._imagem[0].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[0].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
			// tratar erro
		}
		
		private function imagemCarregada(evento:Event):void
		{
			this._imagem[0].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[0].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			this._imagem[0].x = ObjetoAprendizagem.areaImagem.oWidth / 2;
			this._imagem[0].y = ObjetoAprendizagem.areaImagem.oHeight / 2;
			
			if (this._imagem[0].loader.width > this._imagem[0].loader.height)
			{
				trace("largura", this._imagem[0].width = ObjetoAprendizagem.areaImagem.width / ObjetoAprendizagem.areaImagem.scaleX);
				this._imagem[0].scaleY = this._imagem[0].scaleX;
			}
			else
			{
				trace('altura');
				this._imagem[0].height = ObjetoAprendizagem.areaImagem.height;
				this._imagem[0].scaleX = this._imagem[0].scaleY;
			}
			// posicionar e dimensionar botões	
			var dados:Object = new Object();
			dados.indice = 0;
			this._balao[dados.indice] = new Balao(dados.indice);
			this._balao[dados.indice].tipo = this._balao[dados.indice].tipo;
			this._balao[dados.indice].texto = 'oi';
			this._balao[dados.indice].width = 300;
			this._balao[dados.indice].scaleY = this._balao[dados.indice].scaleX;
			this._balao[dados.indice].x = ObjetoAprendizagem.areaImagem.width / 3;
			this._balao[dados.indice].y = ObjetoAprendizagem.areaImagem.height / 3;
			
			// mudar tela
			this.editavel = true;
			dados.imagem = this._imagem;
			dados.balao = this._balao as Vector.<Balao>;
			dados.editavel = this.editavel;
			this.mudaTela('fotorecuperada', dados);
		
		}
		
		override public function recebeDados(dados:Object):void
		{
			paginaAtual = 0;
			editavel = false;
			Main.projeto.clear();
			
			ObjetoAprendizagem.areaImagem.visible = false;
			
			if (dados != null)
			{
				if (dados.id != null)
				{
					_id = dados.id;
					if (dados.tela != null && dados.tela == 'carregar')
					{
						carregaProjeto(_id);
					}
				}
				
				else
				{
					_id = '1460985335175';
				}
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
				
				for (var xis:int = 0; xis < _balao.length; xis++)
				{
					this._balao[xis].id = xis;
				}
				while (_imagem.length > 0)
				{
					_imagem.shift().dispose();
				}
				
				while (_balao.length > 0)
				{
					_balao.shift().dispose();
				}
				
			}
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			// POSICIONAR BOTOES
			
			this._galeria.width = stage.stageWidth / btscala;
			this._galeria.scaleY = this._galeria.scaleX;
			this._galeria.x = this.stage.stageWidth / 20;
			this._galeria.y = this.stage.stageHeight / 40;
			
			this._camera.scaleX = this._camera.scaleY = this._galeria.scaleX;
			
			// posicionar camera
			this._camera.width = stage.stageWidth / btscala;
			this._camera.scaleY = this._galeria.scaleX;
			this._camera.x = stage.stageWidth - _camera.width - this.stage.stageWidth / 20;
			this._camera.y = this.stage.stageHeight / 40;
			
			this._carregar.scaleX = this._carregar.scaleY = this._galeria.scaleX;
			
			//open
			
			this._btOpen.width = stage.stageWidth / btscala;
			this._btOpen.scaleY = this._btOpen.scaleX;
			this._btOpen.x = stage.stageWidth / 2 - this._btOpen.width / 2;
			this._btOpen.y = stage.stageHeight / 40;
			
			// posicionar carregar
			
			this._carregar.width = stage.stageWidth / btscala;
			this._carregar.scaleY = this._galeria.scaleX;
			
			this._carregar.x = stage.stageWidth / 2 - this._carregar.width / 2;
			this._carregar.y = stage.stageHeight - this._carregar.height - this.stage.stageHeight / 40;
			
			// pocisionar e dimensionar help aqui
			
			this._help.width = stage.stageWidth - stage.stageWidth / 10;
			this._help.scaleY = _help.scaleX;
			//this._help.x = stage.stageWidth / 20;
			this._help.y = stage.stageHeight / 2 - this._help.height / 2;
			
			Tweener.addTween(_help, {x: stage.stageWidth / 20, time: 1});
			
			// ADICIONAR CLIQUES NOS BOTOES
			if (!this._galeria.hasEventListener(MouseEvent.CLICK))
			{
				this.addChild(linhabaixo);
				this.addChild(linhacima);
				this.addChild(this._carregar);
				this.addChild(this._galeria);
				this.addChild(this._camera);
				this.addChild(this._btOpen);
				
				this._galeria.addEventListener(MouseEvent.CLICK, cliqueGaleria);
				this._camera.addEventListener(MouseEvent.CLICK, cliqueCamera);
				this._carregar.addEventListener(MouseEvent.CLICK, cliqueCarregar);
				this._btOpen.addEventListener(MouseEvent.CLICK, cliqueAbreProjeto);
				
				// TROCA DO HELP
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipeTela);
				stage.addEventListener(Event.RESIZE, desenho);
				
				ObjetoAprendizagem.areaImagem.visible = false;
			}
			
			if (!definido)
			{
				definido = true;
				var area:Rectangle = new Rectangle(0, (0 + linhacima.height), stage.stageWidth, (stage.stageHeight - linhacima.height - linhabaixo.height));
				ObjetoAprendizagem.areaImagem.fitOnArea(area);
				
				trace('fiton', definido);
			}
		
		}
		
		private function cliqueAbreProjeto(evento:MouseEvent):void
		{
			this.carregaProjeto(_id);
		}
		
		public function carregaProjeto(id:String):void
		{
			
			if (Main.projeto.carregaProjeto(id))
			{
				_id = id;
				
				paginaAtual = 0;
				editavel = false;
				
				ObjetoAprendizagem.areaImagem.removeChildren();
				
				while (_imagem.length > 0)
				{
					_imagem.shift().dispose();
				}
				
				while (_balao.length > 0)
				{
					_balao.shift().dispose();
				}
				
				for (var i:int = 0; i < Main.projeto.paginas[0].imagens.length; i++)
				{
					
					trace('acrescentando imagem', i);
					
					_imagem[i] = new Imagem(i);
					_imagem[i].recebeDados(Main.projeto.paginas[0].imagens[i], paginaAtual);
					ObjetoAprendizagem.areaImagem.addChild(_imagem[i]);
				}
				
				for (i = 0; i < Main.projeto.paginas[0].baloes.length; i++)
				{
					
					trace('acrescentando balao', i);
					
					_balao[i] = new Balao(i);
					_balao[i].recebeDados(Main.projeto.paginas[0].baloes[i]);
					_balao[i].tipo = Main.projeto.paginas[0].baloes[i].tipo;
					
					ObjetoAprendizagem.areaImagem.addChild(_balao[i]);
					
				}
				editavel = Main.projeto.editavel;
				var dados:Object = new Object();
				
				dados.imagem = this._imagem;
				dados.balao = this._balao;
				dados.paginaAtual = 0;
				dados.editavel = editavel;
				mudaTela('fotorecuperada', dados);
				
			}
		
		}
		
		private function cliqueCarregar(evento:MouseEvent):void
		{
			trace('server');
			
			this.mudaTela('lista', null);
		}
		
		override public function escondendo(evento:Event):void
		{
			this.removeChild(_camera);
			this.removeChild(_carregar);
			this.removeChild(_galeria);
			super.escondendo(evento);
			this._galeria.removeEventListener(MouseEvent.CLICK, cliqueGaleria);
			this._camera.removeEventListener(MouseEvent.CLICK, cliqueCamera);
			this._carregar.removeEventListener(MouseEvent.CLICK, cliqueCarregar);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, swipeTela);
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
		
		private function swipeTela(evento:TransformGestureEvent):void
		{
			// conferir evento.offsetX para saber se foi swipe direita ou esquerda
			var animinicial:Number;
			if (evento.offsetX < 0)
			{
				this._imgAtual++;
				if (this._imgAtual >= this._imgsHelp.length) this._imgAtual = 0;
				animinicial = +_help.height;
				
			}
			else
			{
				this._imgAtual--;
				if (this._imgAtual < 0) this._imgAtual = this._imgsHelp.length - 1;
				animinicial = -_help.height;
				
			}
			this.removeChild(this._help);
			this._help.bitmapData.dispose();
			this._help = null;
			this._help = new this._imgsHelp[this._imgAtual]() as Bitmap;
			this._help.x = animinicial;
			addChild(this._help);
			this.desenho();
		}
	
	}

}