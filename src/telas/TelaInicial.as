package telas
{
	import colabora.display.EscolhaProjeto;
	import colabora.display.TelaMensagemStage;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
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
		private var _id:String = '1461675961087';
		private var paginaAtual:int = 0;
		// botões
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		//private var _carregar:BotaoIcone;
		
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
		
		// gerenciar arquivos de projeto
		private var _btOpen:BotaoIcone;
		private var _btArquivos:BotaoIcone;
		private var _btReceber:BotaoIcone;
		private var _telaEscolha:EscolhaProjeto;
		private var _navegaProjeto:File;
		private var _telaMensagem:TelaMensagemStage;
		
		//
		private var editavel:Boolean = false;
		private var definido:Boolean = false;
		private var redesenha:Boolean;
		
		private var salvo:Boolean = false;
		private var msg:TelaMensagemStage;
		public function TelaInicial(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			btscala = 10;
			
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			this._btOpen = new BotaoIcone(Graficos.ImgOpenFile);
			this._btArquivos = new BotaoIcone(Graficos.ImgArquivos);
			this._btReceber = new BotaoIcone(Graficos.ImgReceber);
			
			this.addChild(this._galeria);
			this.addChild(this._btOpen);
			this.addChild(this._btArquivos);
			this.addChild(this._btReceber);
			
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
			
			//this._carregar = new BotaoIcone(Graficos.ImgCarregar);
			//addChild(this._carregar);
			
			// criando acesso à galeria
			this._roll = new CameraRoll();
			this._file = File.documentsDirectory;
			this._imagem = new Vector.<Imagem>;
			this._imagem[0] = new Imagem(0);
			this._balao = new Vector.<Balao>;
			// criando acesso à camera
			camera = new CameraUI();
			
			// tela de compartilhamento
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.CLOSE, onCompartilhamentoClose);
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.COMPLETE, onCompartilhamentoComplete);
			
			// tela de escolha de projetos
			this._telaEscolha = new EscolhaProjeto('Escolha o projeto', new BotaoIcone(Graficos.ImgPBOK), new BotaoIcone(Graficos.ImgCancelar), new BotaoIcone(Graficos.ImgOpenFile), new BotaoIcone(Graficos.ImgLixeira), File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/'));
			this._telaEscolha.addEventListener(Event.COMPLETE, onEscolhaOK);
			this._telaEscolha.addEventListener(Event.CANCEL, onEscolhaCancel);
			this._telaEscolha.addEventListener(Event.OPEN, onEscolhaOpen);
			
			// tela de mensagens
			this._telaMensagem = new TelaMensagemStage(720, 1280, new BotaoIcone(Graficos.ImgPBOK), new BotaoIcone(Graficos.ImgCancelar), 0x666666);
			this._telaMensagem.addEventListener(Event.COMPLETE, onMensagemComplete);
			this._telaMensagem.addEventListener(Event.CANCEL, onMensagemCancel);
			
			// navegação para importar projeto
			this._navegaProjeto = File.documentsDirectory;
			this._navegaProjeto.addEventListener(Event.SELECT, onNavegadorPSelect);
			this._navegaProjeto.addEventListener(Event.CANCEL, onNavegadorPFim);
			this._navegaProjeto.addEventListener(IOErrorEvent.IO_ERROR, onNavegadorPFim);
			
			// importação de projetos
			Main.projeto.addEventListener(Event.CANCEL, onImportCancel);
			Main.projeto.addEventListener(Event.COMPLETE, onImportComplete);
		
		}
		
			override public function botaoBack():void
		{
			
			NativeApplication.nativeApplication.exit();
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
			/*this._balao[dados.indice] = new Balao(dados.indice);
			   this._balao[dados.indice].tipo = this._balao[dados.indice].tipo;
			   this._balao[dados.indice].texto = 'oi';
			   this._balao[dados.indice].width = 300;
			   this._balao[dados.indice].scaleY = this._balao[dados.indice].scaleX;
			   this._balao[dados.indice].x = ObjetoAprendizagem.areaImagem.width / 3;
			   this._balao[dados.indice].y = ObjetoAprendizagem.areaImagem.height / 3;
			 */
			// mudar tela
			this.editavel = true;
			dados.imagem = this._imagem;
			dados.editavel = this.editavel;
			//dados.balao = this._balao as Vector.<Balao>;
			dados.qualTela = 'inicial';
			this.mudaTela('fotorecuperada', dados);
		
		}
		
		override public function recebeDados(dados:Object):void
		{
			paginaAtual = 0;
			editavel = false;
			salvo = false;
			Main.projeto.clear();
			
			ObjetoAprendizagem.areaImagem.visible = false;
			
			if (dados != null)
			{
				if (dados.qualTela != null)
				{
					if (dados.qualTela == 'salvar')
					{
						trace(dados.qualTela)
						salvo = true;
						
					}
					if (dados.redesenha != null)
					{
						this.redesenha = dados.redesenha;
					}
					if (dados.id != null)
					{
						_id = dados.id;
						if (dados.tela != null && dados.tela == 'carregar')
						{
							carregaProjeto(_id);
						}
					}
				}
				else
				{
					_id = '1460985335175';
				}
				if (dados.qualTela != null)
				{
					trace('dados recebidos');
				}
				else
				{
					if (dados.imagem != null)
					{
						trace('tem Imagem');
						this._imagem = dados.imagem as Vector.<Imagem>;
						
					}
					if (dados.editavel != null)
					{
						
						editavel = dados.editavel;
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
						trace('dispose lista recebe dados');
						_imagem.shift().dispose();
					}
					
					while (_balao.length > 0)
					{
						_balao.shift().dispose();
					}
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
			
			//this._carregar.scaleX = this._carregar.scaleY = this._galeria.scaleX;
			
			//posicionar carregar
			
			//this._carregar.width = stage.stageWidth / btscala;
			//this._carregar.scaleY = this._carregar.scaleX;
			//this._carregar.x = stage.stageWidth / 2 - this._carregar.width / 2;
			//this._carregar.y = stage.stageHeight / 40;
			
			// abrir projeto
			this._btOpen.width = stage.stageWidth / btscala;
			this._btOpen.scaleY = this._galeria.scaleX;
			
			// this._btOpen.x = stage.stageWidth / 2 - this._btOpen.width / 2;
			// this._btOpen.y = stage.stageHeight - this._btOpen.height - this.stage.stageHeight / 40;
			
			// arquivos
			this._btArquivos.height = this._btOpen.height;
			this._btArquivos.scaleX = this._btArquivos.scaleY;
			
			// receber
			this._btReceber.height = this._btOpen.height;
			this._btReceber.scaleX = this._btReceber.scaleY;
			
			// posicionando botões inferiores
			var intervaloX:Number = (this.stage.stageWidth - this._btOpen.width - this._btArquivos.width - this._btReceber.width) / 4;
			this._btArquivos.x = intervaloX;
			this._btOpen.x = this._btArquivos.x + this._btArquivos.width + intervaloX;
			this._btReceber.x = this._btOpen.x + this._btOpen.width + intervaloX;
			this._btArquivos.y = this._btReceber.y = this._btOpen.y = stage.stageHeight - this._btOpen.height - this.stage.stageHeight / 40;
			
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
				//this.addChild(this._carregar);
				this.addChild(this._galeria);
				this.addChild(this._camera);
				this.addChild(this._btOpen);
				this.addChild(this._btArquivos);
				this.addChild(this._btReceber);
				
				this._galeria.addEventListener(MouseEvent.CLICK, cliqueGaleria);
				this._camera.addEventListener(MouseEvent.CLICK, cliqueCamera);
				//this._carregar.addEventListener(MouseEvent.CLICK, cliqueCarregar);
				this._btOpen.addEventListener(MouseEvent.CLICK, cliqueCarregar);
				this._btArquivos.addEventListener(MouseEvent.CLICK, cliqueArquivos);
				this._btReceber.addEventListener(MouseEvent.CLICK, cliqueReceber);
				
				// TROCA DO HELP
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipeTela);
				stage.addEventListener(Event.RESIZE, desenho);
				
				ObjetoAprendizagem.areaImagem.visible = false;
				
				if (salvo == true)
				{
				msg = new TelaMensagemStage(stage.stageWidth, stage.stageHeight, new BotaoIcone(Graficos.ImgPBOK) as Sprite, new BotaoIcone(Graficos.ImgCancelar) as Sprite, 0XEFEFEF, 0);
				addChild(msg);
				msg.defineMensagem('<b>Projeto gravado</b><br />&nbsp;<br />Seu projeto foi gravado com suecesso.');
				msg.addEventListener(Event.COMPLETE, fechaMsg);
			    }
			}
			
			if (!definido)
			{
				definido = true;
				var area:Rectangle = new Rectangle(0, (0 + linhacima.height), stage.stageWidth, (stage.stageHeight - linhacima.height - linhabaixo.height));
				ObjetoAprendizagem.areaImagem.fitOnArea(area);
				
				trace('fiton', definido);
			}
		
		}
		private function fechaMsg(evento:Event):void {
			msg.removeEventListener(Event.COMPLETE, fechaMsg);
			trace('fecha');
			removeChild(msg);
			salvo = false;
			desenho();
		}
		/*
		   private function cliqueAbreProjeto(evento:MouseEvent):void
		   {
		   this.carregaProjeto(_id);
		   }
		 */
		
		public function carregaProjeto(id:String):void
		{
			trace('carrega P');
			
			if (Main.projeto.carregaProjeto(id))
			{
				trace(_id = id);
				
				paginaAtual = 0;
				editavel = false;
				
				ObjetoAprendizagem.areaImagem.removeChildren();
				
				while (_imagem.length > 0)
				{
					trace('dispose lista carrega projeto');
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
				trace('carregou');
				editavel = Main.projeto.editavel;
				var dados:Object = new Object();
				
				dados.imagem = this._imagem;
				dados.balao = this._balao;
				dados.paginaAtual = 0;
				dados.editavel = this.editavel;
				trace('dados ok');
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
			trace('escondendo');
			
			this.removeChild(_camera);
			//this.removeChild(_carregar);
			this.removeChild(_galeria);
			super.escondendo(evento);
			this._galeria.removeEventListener(MouseEvent.CLICK, cliqueGaleria);
			this._camera.removeEventListener(MouseEvent.CLICK, cliqueCamera);
			//this._carregar.removeEventListener(MouseEvent.CLICK, cliqueCarregar);
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
		
		/**
		 * O botão "arquivos" foi clicado.
		 */
		private function cliqueArquivos(evento:MouseEvent):void
		{
			if (this._telaEscolha.listar('Defina o projeto a exportar ou escolha um arquivo para importar'))
			{
				this.stage.addChild(this._telaEscolha);
				this._telaEscolha.mostrarAbrir();
			}
		}
		
		/**
		 * O botão "receber projeto" foi clicado.
		 */
		private function cliqueReceber(evt:MouseEvent):void
		{
			ObjetoAprendizagem.compartilhamento.iniciaLeitura();
			this.stage.addChild(ObjetoAprendizagem.compartilhamento);
		}
		
		/**
		 * A tela de compartilhamento foi fechada.
		 */
		private function onCompartilhamentoClose(evt:Event):void
		{
			// não fazer nada: a própria tela se remove
		}
		
		/**
		 * Foi recebido um arquivo de projeto.
		 */
		private function onCompartilhamentoComplete(evt:Event):void
		{
			if (!Main.projeto.importar(ObjetoAprendizagem.compartilhamento.download))
			{
				this._telaMensagem.defineMensagem('<b>Erro de importação!</b><br />&nbsp;<br />Não foi possível importar o projeto recebido. Por favor tente novamente.');
				this.stage.removeChild(ObjetoAprendizagem.compartilhamento);
				this.stage.addChild(this._telaMensagem);
			}
		}
		
		/**
		 * Um projeto foi escolhido na tela de listagem.
		 */
		private function onEscolhaOK(evt:Event):void
		{
			var acOK:Boolean = false;
			if (this._telaEscolha.escolhido != null)
			{
				if (this._telaEscolha.escolhido.id != null)
				{
					// recuperando nome de arquivo
					var exportado:String = Main.projeto.exportarID(this._telaEscolha.escolhido.id as String);
					if (exportado != '')
					{
						// ação ok
						acOK = true;
					}
				}
			}
			if (!acOK)
			{
				// avisar sobre problema ao exportar projeto
				this.stage.removeChild(this._telaEscolha);
				this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido. Por favor tente novamente.');
				this.stage.addChild(this._telaMensagem);
			}
			else
			{
				// avisar sobre o projeto exportado
				this.stage.removeChild(this._telaEscolha);
				this._telaMensagem.defineMensagem('<b>Exportação concluída</b><br />&nbsp;<br />O projeto selecionado foi exportado e está gravado com o nome <br />&nbsp;<br /><b>' + exportado + '</b><br />&nbsp;<br />na pasta <br />&nbsp;<br /><b>' + File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados').nativePath + '</b><br />&nbsp;<br />de seu aparelho.');
				this.stage.addChild(this._telaMensagem);
			}
		
		}
		
		/**
		 * O botão cancelar foi escolhido na tela de listagem de projetos.
		 */
		private function onEscolhaCancel(evt:Event):void
		{
			this.stage.removeChild(this._telaEscolha);
		}
		
		/**
		 * O botão abrir foi escolhido na tela de listagem de projetos.
		 */
		private function onEscolhaOpen(evt:Event):void
		{
			this._telaEscolha.mostrarMensagem('Localizando e importanto um arquivo de projeto.');
			this._navegaProjeto.browseForOpen('Projetos de Narrativa Visual', [new FileFilter('arquivos de projeto', '*.zip')]);
		}
		
		/**
		 * Navegação por arquivo terminada sem nenhuma escolha.
		 */
		private function onNavegadorPFim(evt:Event):void
		{
			// refazendo a listagem
			this._telaEscolha.listar();
		}
		
		/**
		 * Recebendo um arquivo de projeto selecionado.
		 */
		private function onNavegadorPSelect(evt:Event):void
		{
			// importando
			if (Main.projeto.importar(this._navegaProjeto))
			{
				// aguardar importação
				this.stage.removeChild(this._telaEscolha);
			}
			else
			{
				// somentar listar novamente
				this._telaEscolha.listar();
			}
		}
		
		/**
		 * Sucesso na importação de um projeto.
		 */
		private function onImportComplete(evt:Event):void
		{
			this._telaMensagem.defineMensagem('<b>Projeto importado!</b><br />&nbsp;<br />O projeto recebido foi importado corretamente. Use o botão "abrir projeto" para conferi-lo.');
			try
			{
				this.stage.removeChild(ObjetoAprendizagem.compartilhamento);
			}
			catch (e:Error)
			{
			}
			this.stage.addChild(this._telaMensagem);
		}
		
		/**
		 * Erro na importação de um projeto.
		 */
		private function onImportCancel(evt:Event):void
		{
			this._telaMensagem.defineMensagem('<b>Erro de importação!</b><br />&nbsp;<br />Não foi possível importar o projeto recebido. Por favor tente novamente.');
			try
			{
				this.stage.removeChild(ObjetoAprendizagem.compartilhamento);
			}
			catch (e:Error)
			{
			}
			this.stage.addChild(this._telaMensagem);
		}
		
		/**
		 * Clique no botão OK da tela de mensagens.
		 */
		private function onMensagemComplete(evt:Event):void
		{
			// removendo tela de mensagem
			this.stage.removeChild(this._telaMensagem);
		}
		
		/**
		 * Clique no botão CANCELAR da tela de mensagens.
		 */
		private function onMensagemCancel(evt:Event):void
		{
			// removendo tela de mensagem
			this.stage.removeChild(this._telaMensagem);
		}
	
	}

}