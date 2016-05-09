
package telas
{
	import caurina.transitions.Tweener;
	import colabora.display.TelaMensagemStage;
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
	import informacoes.BalaoDados;
	import informacoes.PaginaDados;
	import informacoes.ProjetoDados;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaFotoRecuperada extends Tela
	{
		
		// botoes
		//private var _propBalao:BotaoIcone;
		private var _ajusteBalao:BotaoIcone;
		private var _ajusteImagem:BotaoIcone;
		private var _salvar:BotaoIcone;
		private var _cancelar:BotaoIcone;
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		private var _addBalao:BotaoIcone;
		private var _addPagina:BotaoIcone;
		private var _proxPagina:BotaoIcone;
		private var _antPagina:BotaoIcone;
		
		
		
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
		
		private var paginaAtual:int = 0;
		
		//
		private var editavel:Boolean = false;
		
		private var _btExcluiPagina:BotaoIcone;
		
		private var _btBiblioteca:BotaoIcone;			// botão para abrir a biblioteca de molduras
		private var _btCompartilhar:BotaoIcone;			// botão para compartilhar o projeto atual
		private var _btExportarImg:BotaoIcone;			// botão para exportar projeto como imagens
		private var _telaBiblioteca:TelaBiblioteca;		// tela da biblioteca de molduras
		private var _telaMensagem:TelaMensagemStage;	// tela de mensagens
		private var _ultimaAc:String = '';				// última ação (para controle da tela de mensagens)
		
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
			//this._propBalao = new BotaoIcone(Graficos.ImgPropBalao);
			this._ajusteBalao = new BotaoIcone(Graficos.ImgAjusteBalao);
			this._ajusteImagem = new BotaoIcone(Graficos.ImgAjusteImagem);
			this._salvar = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			this._camera = new BotaoIcone(Graficos.ImgCamera);
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			this._addPagina = new BotaoIcone(Graficos.ImgNovaPagina);
			this._proxPagina = new BotaoIcone(Graficos.ImgSetaDir);
			this._antPagina = new BotaoIcone(Graficos.ImgSetaEsq)
			this._btExcluiPagina = new BotaoIcone(Graficos.excImagem);
			
			this._btBiblioteca = new BotaoIcone(Graficos.ImgBiblioteca);
			this._btCompartilhar = new BotaoIcone(Graficos.ImgCompartilhar);
			this._btExportarImg = new BotaoIcone(Graficos.ImgExportarImagem);
			
			this._imagem = new Vector.<Imagem>;
			_dados = new Object();
			
			this._roll = new CameraRoll();
			this._file = File.documentsDirectory;
			
			this.camera = new CameraUI();
			
			// biblioteca de imagens
			this._telaBiblioteca = new TelaBiblioteca();
			this._telaBiblioteca.addEventListener(Event.CANCEL, onBibliotecaCancel);
			this._telaBiblioteca.addEventListener(Event.SELECT, onBibliotecaSelect);
			
			// tela de mensagens
			this._telaMensagem = new TelaMensagemStage(720, 1280, new BotaoIcone(Graficos.ImgPBOK), new BotaoIcone(Graficos.ImgCancelar), 0x666666);
			this._telaMensagem.addEventListener(Event.COMPLETE, onMensagemComplete);
			this._telaMensagem.addEventListener(Event.CANCEL, onMensagemCancel);
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			addChild(_btExcluiPagina);
			
			if ((evento != null) && (evento.type == Event.RESIZE))
			{
				// centralizar imagem	
			}
			
			this._proxPagina.width = stage.stageWidth / btscala;
			this._proxPagina.scaleY = this._proxPagina.scaleX;
			this._proxPagina.x = stage.stageWidth - this._proxPagina.width - stage.stageWidth / 20;
			this._proxPagina.y = stage.stageHeight / 2;
			
			this._antPagina.width = stage.stageWidth / btscala;
			this._antPagina.scaleY = this._antPagina.scaleX;
			this._antPagina.x = 0 + stage.stageWidth / 20;
			this._antPagina.y = stage.stageHeight / 2;
			
			if (editavel == true)
			{
				this._btExcluiPagina.width = stage.stageWidth / 20;
				this._btExcluiPagina.scaleY = this._btExcluiPagina.scaleX
				this._btExcluiPagina.x = ObjetoAprendizagem.areaImagem.x - this._btExcluiPagina.width;
				this._btExcluiPagina.y = ObjetoAprendizagem.areaImagem.y;
				
				this._galeria.x = stage.stageWidth / 20;
				this._galeria.y = stage.stageHeight / 40;
				this._galeria.width = stage.stageWidth / btscala;
				var numeroG:Number = this._galeria.scaleY = this._galeria.scaleX;
				
				//botão ajuste do balão
				this._ajusteBalao.width = stage.stageWidth / btscala;
				var numeroAjB:Number = this._ajusteBalao.scaleY = this._ajusteBalao.scaleX;
				this._ajusteBalao.x = (this._galeria.width + this._galeria.x) + stage.stageWidth / 20;
				this._ajusteBalao.y = stage.stageHeight / 40;
				
				//botão ajuste imagem
				this._ajusteImagem.x = (this._ajusteBalao.width + this._ajusteBalao.x) + stage.stageWidth / 20;
				this._ajusteImagem.y = stage.stageHeight / 40;
				this._ajusteImagem.width = stage.stageWidth / btscala;
				var numeroAjI:Number = this._ajusteImagem.scaleY = this._ajusteImagem.scaleX;
				
				//botão add Balao
				this._addBalao..x = (this._ajusteImagem.width + this._ajusteImagem.x) + stage.stageWidth / 20;
				this._addBalao.y = stage.stageHeight / 40;
				this._addBalao.width = stage.stageWidth / btscala;
				var numeroAddB:Number = this._addBalao.scaleY = this._addBalao.scaleX;
				
				//botão add Pagina
				this._addPagina.x = (this._addBalao.width + this._addBalao.x) + stage.stageWidth / 20;
				this._addPagina.y = stage.stageHeight / 40;
				this._addPagina.width = stage.stageWidth / btscala;
				var numeroAddP:Number = this._addPagina.scaleY = this._addPagina.scaleX;
				
				// botão camera
				this._camera.width = stage.stageWidth / btscala;
				var numeroCam:Number = this._camera.scaleY = this._camera.scaleX;
				this._camera.x = stage.stageWidth - _camera.width - stage.stageWidth / 20;
				this._camera.y = stage.stageHeight / 40;
				
				//botão salvar			
				this._salvar.width = stage.stageWidth / btscala;
				var numeroSalv:Number = this._salvar.scaleY = this._salvar.scaleX;
				this._salvar.x = stage.stageWidth / 20;
				this._salvar.y = stage.stageHeight - this._salvar.height - (stage.stageHeight / 40);
				//
				//botão cancelar
				this._cancelar.width = stage.stageWidth / btscala;
				var numeroCanc:Number = this._cancelar.scaleY = this._cancelar.scaleX;
				this._cancelar.x = stage.stageWidth - _cancelar.width - stage.stageWidth / 20;
				this._cancelar.y = stage.stageHeight - this._cancelar.height - (stage.stageHeight / 40);
				
				
				// biblioteca
				this._btBiblioteca.height = this._cancelar.height;
				this._btBiblioteca.scaleX = this._btBiblioteca.scaleY;
				this._btBiblioteca.x = (this.stage.stageWidth / 2) - this._btBiblioteca.width - 10;
				this._btBiblioteca.y = this._cancelar.y;
				
				// compartilhar projeto
				this._btCompartilhar.height = this._cancelar.height;
				this._btCompartilhar.scaleX = this._btCompartilhar.scaleY;
				this._btCompartilhar.x = (this.stage.stageWidth / 2) + 10;
				this._btCompartilhar.y = this._cancelar.y;
				
				// exportar imagens
				this._btExportarImg.height = this._cancelar.height;
				this._btExportarImg.scaleX = this._btCompartilhar.scaleY;
				this._btExportarImg.x = this._btCompartilhar.x + this._btCompartilhar.width + 10;
				this._btExportarImg.y = this._cancelar.y;
				
				//imagem recuperada
				
				//Proxima Pagina
				
				//tween nos botoes
				
				_galeria.scaleX = _galeria.scaleY = 0;
				_ajusteBalao.scaleX = _ajusteBalao.scaleY = 0;
				_ajusteImagem.scaleX = _ajusteImagem.scaleY = 0;
				_addBalao.scaleX = _addBalao.scaleY = 0;
				_addPagina.scaleX = _addPagina.scaleX = 0;
				_camera.scaleX = _camera.scaleY = 0;
				
				Tweener.addTween(_galeria, {scaleX: numeroG, scaleY: numeroG, time: 0.8});
				Tweener.addTween(_ajusteBalao, {scaleX: numeroAjB, scaleY: numeroAjB, time: 0.8});
				Tweener.addTween(_ajusteImagem, {scaleX: numeroAjI, scaleY: numeroAjI, time: 0.8});
				Tweener.addTween(_addBalao, {scaleX: numeroAddB, scaleY: numeroAddB, time: 0.8});
				Tweener.addTween(_addPagina, {scaleX: numeroAddP, scaleY: numeroAddP, time: 0.8});
				Tweener.addTween(_camera, {scaleX: numeroCam, scaleY: numeroCam, time: 0.8});
				
				// adicionar listeners dos cliques dos botões
				if (!this._salvar.hasEventListener(MouseEvent.CLICK))
				{
					
					this.addChild(linhabaixo);
					this.addChild(linhacima);
					
					for (var k:int = 0; k < _imagem.length; k++)
					{
						ObjetoAprendizagem.areaImagem.addChild(this._imagem[k]);
						this._imagem[k].addEventListener(MouseEvent.CLICK, cliqueArrastaImg);
						this._imagem[k].alpha = 1;
						this._imagem[k].mouseEnabled = true;
						
					}
					for (var i:int = 0; i < _balao.length; i++)
					{
						ObjetoAprendizagem.areaImagem.addChild(this._balao[i]);
						this._balao[i].addEventListener(MouseEvent.CLICK, cliqueArrasta);
						this._balao[i].mouseEnabled = true;
						this._balao[i].alpha = 1;
						this._balao[i].smooth();
					}
					
					this.addChild(this._ajusteBalao);
					this.addChild(this._ajusteImagem);
					this.addChild(this._salvar);
					this.addChild(this._cancelar);
					this.addChild(this._addBalao);
					this.addChild(this._addPagina);
					this.addChild(this._proxPagina);
					this.addChild(this._antPagina);
					this.addChild(this._btExcluiPagina);
					this.addChild(this._camera);
					this.addChild(this._galeria);
					this.addChild(this._btBiblioteca);
					this.addChild(this._btCompartilhar);
					this.addChild(this._btExportarImg);
					
					this._salvar.addEventListener(MouseEvent.CLICK, cliqueSalvar);
					this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
					//	this._propBalao.addEventListener(MouseEvent.CLICK, cliquePropB);
					this._ajusteBalao.addEventListener(MouseEvent.CLICK, cliqueAjusteB);
					this._ajusteImagem.addEventListener(MouseEvent.CLICK, cliqueAjusteImg);
					this._addBalao.addEventListener(MouseEvent.CLICK, addBalao);
					this._addPagina.addEventListener(MouseEvent.CLICK, addPagina);
					this._proxPagina.addEventListener(MouseEvent.CLICK, proximaPagina);
					this._antPagina.addEventListener(MouseEvent.CLICK, paginaAnterior);
					this._galeria.addEventListener(MouseEvent.CLICK, cliqueGaleria);
					this._camera.addEventListener(MouseEvent.CLICK, cliqueCamera);
					this._btExcluiPagina.addEventListener(MouseEvent.CLICK, excluiPagina);
					
					this._btBiblioteca.addEventListener(MouseEvent.CLICK, adicionaBiblioteca);
					this._btCompartilhar.addEventListener(MouseEvent.CLICK, compartilhaProjeto);
					this._btExportarImg.addEventListener(MouseEvent.CLICK, exportaImagem);
					
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					
					stage.addEventListener(Event.RESIZE, desenho);
					
				}
			}
			else
			{
				//botão cancelar
				removeChild(_btExcluiPagina);
				this._cancelar.width = stage.stageWidth / btscala;
				this._cancelar.scaleY = this._cancelar.scaleX;
				this._cancelar.x = stage.stageWidth / 2 - _cancelar.width / 2;
				this._cancelar.y = stage.stageHeight - this._cancelar.height - (stage.stageHeight / 40);
				
				if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
				{
					
					this.addChild(linhabaixo);
					this.addChild(linhacima);
					
					for (k = 0; k < _imagem.length; k++)
					{
						ObjetoAprendizagem.areaImagem.addChild(this._imagem[k]);
						
					}
					for (i = 0; i < _balao.length; i++)
					{
						ObjetoAprendizagem.areaImagem.addChild(this._balao[i]);
						this._balao[i].smooth();
					}
					
					this.addChild(this._cancelar);
					this.addChild(this._proxPagina);
					this.addChild(this._antPagina);
					
					this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
					
					this._proxPagina.addEventListener(MouseEvent.CLICK, proximaPagina);
					this._antPagina.addEventListener(MouseEvent.CLICK, paginaAnterior);
					
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					
					stage.addEventListener(Event.RESIZE, desenho);
					
				}
				
			}
		
		}
		
		public function carregaProjeto(id:String):void
		{
			trace('carrega P');
			
			if (Main.projeto.carregaProjeto(id))
			{
				trace(id);
				
				paginaAtual = 0;
				editavel = false;
				
				ObjetoAprendizagem.areaImagem.removeChildren();
				if (_imagem != null)
				{
					
					while (_imagem.length > 0)
					{
						trace('dispose lista carrega projeto');
						_imagem.shift().dispose();
					}
				}
				if (_balao != null)
				{
					while (_balao.length > 0)
					{
						_balao.shift().dispose();
					}
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
				// dados.redesenha = this.redesenha;
				
				trace('dados ok');
					//escondendo(null);
					//	mudaTela('fotorecuperada', dados);
				
			}
		
		}
		
		private function excluiPagina(evento:MouseEvent):void
		{
			
			// 1. verificar se tem mais de uma página - se tiver, limpar a página atual, apagar a pasta "pagina0" e criar pasta "pagina0" novamente
			// 2. se tiver mais de 1 página, conferir se a atual é a última => se for a última, mudar para a penúltima
			// 3. apagar pasta de arquivos da última página "pagina#"
			// 4. apagar dados da última página
			// Main.projeto.paginas[Main.projeto.paginas.length - 1].dispose();
			// Main.projeto.paginas.splice(Main.projeto.paginas.length - 1, 1);
			
			// se só existir uma página
			
			if (paginaAtual == 0)
			{
				while (_imagem.length > 0)
				{
					trace('dispose exclui pagina');
					_imagem.shift().dispose();
					
				}
				
				while (_balao.length > 0)
				{
					_balao.shift().dispose();
				}
				
				Main.projeto.excluiPastaPagina(0);
				
			}
			
			else
			{
				if (paginaAtual == Main.projeto.paginas.length - 1)
				{
					paginaAnterior(evento);
				}
				Main.projeto.salvarDados();
				Main.projeto.excluiPastaPagina(Main.projeto.paginas.length - 1);
				Main.projeto.paginas.splice(Main.projeto.paginas.length - 1, 1);
				salvarPagina(paginaAtual);
				Main.projeto.salvarDados();
			}
		
		}
		
		/**
		 * Abre a seleção de uma moldura da biblioteca.
		 */
		private function adicionaBiblioteca(evt:MouseEvent):void
		{
			this.stage.addChild(this._telaBiblioteca);
		}
		
		/**
		 * Compartilha o projeto atual.
		 */
		private function compartilhaProjeto(evt:MouseEvent):void
		{
			if (Main.projeto.titulo == '') {
				this._ultimaAc = 'aviso falta titulo';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Seu projeto ainda não tem um título e não pode ser compartilhado. Salve o projeto primeiro e tente novamente.');
				this.stage.addChild(this._telaMensagem);
			} else {
				this._ultimaAc = 'compartilhar projeto';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Você tem certeza de que quer compartilhar o projeto atual com o título <b>' + Main.projeto.titulo + '</b>?', true);
				this.stage.addChild(this._telaMensagem);
			}
		}
		
		/**
		 * Exporta a página atual como uma imagem.
		 */
		private function exportaImagem(evt:MouseEvent):void
		{
			if (Main.projeto.titulo == '') {
				this._ultimaAc = 'aviso falta titulo';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Seu projeto ainda não tem um título. Não é possível exportar a página como uma imagem. Salve o projeto e tente novamente.');
				this.stage.addChild(this._telaMensagem);
			} else {
				this._ultimaAc = 'salvar imagem';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Você tem certeza de que quer salvar a página atual como uma imagem?', true);
				this.stage.addChild(this._telaMensagem);
			}
		}
		
		private function proximaPagina(evento:MouseEvent):void
		{
			salvarPagina(paginaAtual);
			if (Main.projeto.paginas.length > paginaAtual + 1)
			{
				paginaAtual++;
				while (_imagem.length > 0)
				{
					trace('dispose proxima pagina');
					_imagem.shift().dispose();
				}
				
				while (_balao.length > 0)
				{
					_balao.shift().dispose();
				}
				
				for (var i:int = 0; i < Main.projeto.paginas[paginaAtual].imagens.length; i++)
				{
					_imagem[i] = new Imagem(i);
					_imagem[i].recebeDados(Main.projeto.paginas[paginaAtual].imagens[i], paginaAtual);
					// trace('carregando', Main.projeto.pasta.resolvePath('imagens/pagina' + paginaAtual + '/' + i + '.jpg').url);
					ObjetoAprendizagem.areaImagem.addChild(_imagem[i]);
				}
				
				for (i = 0; i < Main.projeto.paginas[paginaAtual].baloes.length; i++)
				{
					_balao[i] = new Balao(i);
					_balao[i].recebeDados(Main.projeto.paginas[paginaAtual].baloes[i]);
					_balao[i].tipo = Main.projeto.paginas[paginaAtual].baloes[i].tipo;
					
					ObjetoAprendizagem.areaImagem.addChild(_balao[i]);
					
				}
			}
		
		}
		
		//
		private function paginaAnterior(evento:MouseEvent):void
		{
			salvarPagina(paginaAtual);
			if (paginaAtual - 1 >= 0)
			{
				paginaAtual--;
				while (_imagem.length > 0)
				{
					trace('dispose anterior pagina');
					_imagem.shift().dispose();
				}
				
				while (_balao.length > 0)
				{
					_balao.shift().dispose();
				}
				
				for (var i:int = 0; i < Main.projeto.paginas[paginaAtual].imagens.length; i++)
				{
					_imagem[i] = new Imagem(i);
					_imagem[i].recebeDados(Main.projeto.paginas[paginaAtual].imagens[i], paginaAtual);
					//trace('carregando', Main.projeto.pasta.resolvePath('imagens/pagina' + paginaAtual + '/' + i + '.jpg').url);
					ObjetoAprendizagem.areaImagem.addChild(_imagem[i]);
				}
				
				for (i = 0; i < Main.projeto.paginas[paginaAtual].baloes.length; i++)
				{
					_balao[i] = new Balao(i);
					_balao[i].recebeDados(Main.projeto.paginas[paginaAtual].baloes[i]);
					_balao[i].tipo = Main.projeto.paginas[paginaAtual].baloes[i].tipo;
					
					ObjetoAprendizagem.areaImagem.addChild(_balao[i]);
					
				}
			}
		}
		
		//
		
		private function addPagina(evento:MouseEvent):void
		{
			if (Main.projeto.paginas.length == 0)
			{
				var criaPagina:int = Main.projeto.paginas.length;
				Main.projeto.paginas[criaPagina] = new PaginaDados();
			}
			this.salvarPagina(paginaAtual);
			Main.projeto.salvarDados();
			
			while (_imagem.length > 0)
			{
				trace('dispose add pagina');
				_imagem.shift().dispose();
			}
			
			while (_balao.length > 0)
			{
				_balao.shift().dispose();
			}
			
			criaPagina = Main.projeto.paginas.length;
			Main.projeto.paginas[criaPagina] = new PaginaDados();
			paginaAtual = Main.projeto.paginas[criaPagina].numero = criaPagina;
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
			
			var arquivoDestino:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + Main.projeto.id + '/imagens/pagina' + paginaAtual + '/');
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
			
			this._file.removeEventListener(Event.SELECT, arquivoSelecionado);
			
			this._imagem[_imagem.length] = new Imagem(_imagem.length);
			// segundo, criando a referência para o arquivo de destino
			// aqui, coloquei um local de exemplo - é preciso definir no caminho/nome do arquivo de acordo com o projeto
			var arquivoDestino:File = Main.projeto.arquivoImagem(_imagem.length, paginaAtual);
			
			// copiando o arquivo de imagem original para o destino
			this._file.copyTo(arquivoDestino, true);
			
			// carregando a imagem do loader a partir do arquivo de destino
			
			this._imagem[_imagem.length - 1].loader.load(new URLRequest(arquivoDestino.url));
			
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
		}
		
		private function imagemErro(evento:IOErrorEvent):void
		{
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
		
			// tratar erro
		}
		
		private function imagemCarregada(evento:Event):void
		{
			
			trace ('imagem carregada');
			
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
			this._imagem[_imagem.length - 1].loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			this._imagem[_imagem.length - 1].x = ObjetoAprendizagem.areaImagem.oWidth / 2;
			this._imagem[_imagem.length - 1].y = ObjetoAprendizagem.areaImagem.oHeight / 2;
			this._imagem[_imagem.length - 1].addEventListener(MouseEvent.CLICK, cliqueArrastaImg);
			
			if (this._imagem[_imagem.length - 1].loader.content is Bitmap)
			{
				(this._imagem[_imagem.length - 1].loader.content as Bitmap).smoothing = true;
			}
			
			if (this._imagem[_imagem.length - 1].loader.width > this._imagem[_imagem.length - 1].loader.height)
			{
				this._imagem[_imagem.length - 1].width = ObjetoAprendizagem.areaImagem.width / ObjetoAprendizagem.areaImagem.scaleX;
				this._imagem[_imagem.length - 1].scaleY = this._imagem[_imagem.length - 1].scaleX;
			}
			else
			{
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
			this._balao[_balao.length - 1].addEventListener(MouseEvent.CLICK, cliqueArrasta);
		
		}
		
		private function cliqueArrastaImg(evento:MouseEvent):void
		{
			var imagem:Imagem = evento.target as Imagem;
			
			trace ('imagem', imagem, evento.target);
			
			var dados:Object = new Object();
			
			for (var k:int = 0; k < _balao.length; k++)
			{
				_balao[k].removeEventListener(MouseEvent.CLICK, cliqueArrasta);
				_balao[k].mouseEnabled = false;
				_balao[k].alpha = 0.5;
				
				trace('aplicando alpha em', _balao[k].id);
			 }
			
			for (k = 0; k < _imagem.length; k++)
			{
				_imagem[k].removeEventListener(MouseEvent.CLICK, cliqueArrastaImg);
				_imagem[k].alpha = 0.5;
				mouseEnabled = false;
			}
			if (imagem != null)
			{
				
				trace ('tô aqui');
				
				imagem.alpha = 1;
				imagem.mouseEnabled = true;
				trace('arrasta img:', imagem, imagem.id);
				dados.balao = _balao;
				dados.imagem = imagem;
				dados.paginaAtual = paginaAtual;
				// imagem.removeEventListener(MouseEvent.CLICK, cliqueArrastaImg);
				mudaTela('editimagem', dados);
			}
		
		}
		
		private function cliqueArrasta(evento:MouseEvent):void
		{
			var balao:Balao = evento.target as Balao;
			var dados:Object = new Object();
			
			for (var i:int = 0; i < _balao.length; i++)
			{
				_balao[i].removeEventListener(MouseEvent.CLICK, cliqueArrasta);
				_balao[i].mouseEnabled = false;
				_balao[i].alpha = 0.5;
				
				trace('aplicando alpha em', _balao[i].id);
			}
			for (i = 0; i < _imagem.length; i++)
			{
				_imagem[i].removeEventListener(MouseEvent.CLICK, cliqueArrastaImg);
				_imagem[i].alpha = 0.5;
				mouseEnabled = false;
			}
			if (balao != null)
			{
				balao.alpha = 1;
				balao.mouseEnabled = true;
				
				trace('arrasta', balao.id);
				dados.balao = balao;
				dados.imagem = _imagem
				dados.paginaAtual = paginaAtual;
				balao.removeEventListener(MouseEvent.CLICK, cliqueArrasta);
				mudaTela('editbalao', dados);
			}
		
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			
			editavel = false;
			var dados:Object = new Object;
			dados.editavel = editavel;
			dados.qualTela = null;
			
			this.mudaTela('inicial', dados);
		
		}
		
		private function cliquePropB(evento:MouseEvent):void
		{
			var balaoClicado:Balao = evento.target as Balao;
			
			this._dados.balao = balaoClicado;
			
		//	this.mudaTela('propriedadesbalao', _dados);
		
		}
		
		private function cliqueAjusteB(evento:MouseEvent):void
		{
			this._dados.balao = _balao;
			this._dados.imagem = this._imagem;
			//this.mudaTela('editbalao', _dados);
		}
		
		private function cliqueAjusteImg(evento:MouseEvent):void
		{
			
			this._dados.balao = _balao;
			this._dados.imagem = this._imagem;
			this._dados.paginaAtual = this.paginaAtual;
			//this.mudaTela('editimagem', _dados);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			
			// remover listeners
			
			this._salvar.removeEventListener(MouseEvent.CLICK, cliqueSalvar);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
			//this._propBalao.removeEventListener(MouseEvent.CLICK, cliquePropB);
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
			trace('telafotorecu recebeDados');
			
			if (!ObjetoAprendizagem.areaImagem.visible)
			{
				addChild(ObjetoAprendizagem.areaImagem);
				ObjetoAprendizagem.areaImagem.visible = true;
			}
			
			if (dados != null)
			{
				
				if (dados.id != null)
				{
					carregaProjeto(dados.id)
				}
				if (dados.imagem != null)
				{
					this._imagem = dados.imagem as Vector.<Imagem>;
				}
				if (dados.balaoProp != null)
				{
					this._balao[dados.indice].copyProp(dados.balaoProp as Balao);
				}
				if (dados.balao != null)
				{
					this._balao = dados.balao as Vector.<Balao>;
				}
				if (dados.paginaAtual != null)
				{
					this.paginaAtual = dados.paginaAtual;
				}
				if (dados.editavel != null)
				{
					this.editavel = dados.editavel;
				}
				if(dados.imagemExclui != null){
					
					this._imagem[int(dados.numero)].visible = false;					
					this._imagem[int(dados.numero)].paginaAtual = paginaAtual;
					this._imagem[int(dados.numero)].dispose();					
					this._imagem.splice(int(dados.numero), 1);	
					
					for (var i:int = 0; i < _imagem.length; i++)
					{
						this._imagem[i].redefineId(i, paginaAtual);
					}
				}
				if (dados.balaoExclui != null)
				{
					this._exc = dados.balaoExclui as int;
					
					ObjetoAprendizagem.areaImagem.removeChild(this._balao[_exc]);
					
					this._balao.splice(this._exc, 1);
					
					for (var xis:int = 0; xis < _balao.length; xis++)
					{
						this._balao[xis].id = xis;
					}
					
				}
				
			}
			
			trace('em recebe dados', this.stage);
		
		}
		
		private function removeBotoes():void
		{
			//	this.removeChild(this._propBalao);
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
			salvarPagina(paginaAtual);
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
		private function salvarPagina(Npagina:int):void
		{
			// criando objeto de informação de página
			var pagina:PaginaDados = new PaginaDados();
			
			// número igual a zero por enquanto - depois será preciso fazer um contador para saber em qual página estamos
			pagina.numero = Npagina;
			
			// conferindo todos os balões
			for (var i:int = 0; i < this._balao.length; i++)
			{
				// a função "recuperaDados" do balão retorna um objeto "BalaoDados" para incorporar aos dados da página
				// adicionamos um objeto de dados para cada balão
				
				var dados:BalaoDados = this._balao[i].recuperaDados();
				
				pagina.baloes.push(dados);
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
		
		/**
		 * Inclusão a partir da biblioteca cancelada.
		 */
		private function onBibliotecaCancel(evt:Event):void
		{
			// nada a fazer: a própria tela da biblioteca se remove
		}
		
		/**
		 * Inclusão a partir da biblioteca confirmada.
		 */
		private function onBibliotecaSelect(evt:Event):void
		{
			// localizando imagem selecionada na biblioteca
			var img:File = File.applicationDirectory.resolvePath('biblioteca/' + this._telaBiblioteca.selecionado.arquivo);
			if (img.exists) {
				// adicionando a imagem
				this._imagem[_imagem.length] = new Imagem(_imagem.length);
				// copiando o arquivo da biblioteca para o destino
				var arquivoDestino:File = Main.projeto.arquivoImagem(_imagem.length, paginaAtual);
				img.copyTo(arquivoDestino, true);
				// carregando a imagem do loader a partir do arquivo de destino
				this._imagem[_imagem.length - 1].loader.load(new URLRequest(arquivoDestino.url));
				this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
				this._imagem[_imagem.length - 1].loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			}
		}
		
		/**
		 * Clique no botão OK da tela de mensagens.
		 */
		private function onMensagemComplete(evt:Event):void
		{
			// removendo tela de mensagem
			this.stage.removeChild(this._telaMensagem);
			// verificando a ação
			var acOK:Boolean = false;
			switch (this._ultimaAc) {
				case 'salvar imagem':
					var stream:FileStream = new FileStream();
					var regExp:RegExp=/[:|\/|.|&|$|#|*|+|=|<|>|\\|@|%]/g;
					var nomeImagem:String = Main.projeto.titulo.replace(regExp, '');;
					if (nomeImagem == '') nomeImagem = Main.projeto.id;
					nomeImagem = nomeImagem + ' - pg' + (this.paginaAtual + 1) + '.png'
					stream.open(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/imagens/' + nomeImagem), FileMode.WRITE);
					stream.writeBytes(ObjetoAprendizagem.areaImagem.getPicture('png'));
					stream.close();
					this._telaMensagem.defineMensagem('<b>Imagem gravada</b><br />&nbsp;<br />A imagem da página atual foi gravada na pasta <b>' + File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/imagens/').nativePath + '</b> de seu dispositivo com o nome <b>' + nomeImagem + '</b>.');
					this._ultimaAc = 'imagem exportada';
					this.stage.addChild(this._telaMensagem);
					break;
				case 'compartilhar projeto':
					var exportado:String = Main.projeto.exportar();
					if (exportado != '') {
						// ação ok
						acOK = true;
					}
					if (!acOK) {
						// avisar sobre problema ao exportar projeto
						this._ultimaAc = 'erro compartilhando projeto';
						this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido para compartilhamento. Por favor tente novamente.');
						this.stage.addChild(this._telaMensagem);
					} else {
						// iniciar compartilhamento
						if (ObjetoAprendizagem.compartilhamento.iniciaURL(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados/' + exportado))) {
							this.stage.addChild(ObjetoAprendizagem.compartilhamento);
						} else {
							// avisar sobre erro de compartilhamento
							this._ultimaAc = 'erro compartilhando projeto';
							this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido para compartilhamento. Por favor tente novamente.');
							this.stage.addChild(this._telaMensagem);
						}
					}
					break;
			}
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
