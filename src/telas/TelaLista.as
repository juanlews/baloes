package telas
{
	import colabora.display.EscolhaProjeto;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import componentes.BotaoIcone;
	import componentes.BotaoLista;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.adobe.crypto.MD5;
	import flash.text.TextFormat;
	import mx.utils.StringUtil;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaLista extends Tela
	{
		
		private var _listaProj:EscolhaProjeto;
		
		private const IMAGENSPORPAGINA:int = 5;
		private const link:String = 'http://192.168.10.159/';
		private var _lista:Vector.<BotaoLista>;
		private var _pagina:int = 0;
		private var _nomes:Vector.<String>;
		
		private var _total:int = 100;
		private var atual:int = 0;
		private var _voltar:BotaoIcone;
		private var _proximo:BotaoIcone;
		private var _anterior:BotaoIcone;
		private var _btOk:BotaoIcone;
		private var _btCancelar:BotaoIcone;
		private var _btAbrir:BotaoIcone;
		
		//Conexão com server
		private var _request:URLRequest;
		private var _urlLoader:URLLoader;
		private var envio:URLVariables;
		private var btscala:Number;
		
		public function TelaLista(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 10;
            /* _voltar = new BotaoIcone(Graficos.ImgCancelar);
		//_proximo = new BotaoIcone(Graficos.ImgSetad);
		//	_anterior = new BotaoIcone(Graficos.ImgSetae); */
			_btOk = new BotaoIcone(Graficos.ImgPBOK);
			_btCancelar = new BotaoIcone(Graficos.ImgCancelar);
			_btAbrir = new BotaoIcone(Graficos.ImgOpenFile);
			
			/*
			this._lista = new Vector.<BotaoLista>();
			for (var ilista:int = 0; ilista < IMAGENSPORPAGINA; ilista++)
			{
				this._lista.push(new BotaoLista('', Graficos.ImgBarra, new TextFormat('Pfennig', 60, 0, false, false, false, null, null, 'center'), new Rectangle(105, 105, 1120, 140)));
			}
			
			this._nomes = new Vector.<String>();
			
			/* / --------------------------------------
			envio = new URLVariables();
			_urlLoader = new URLLoader();
			_request = new URLRequest(link + "baloes/listar.php");
			
			_request.method = 'POST';
			_urlLoader.addEventListener(Event.COMPLETE, recebeu);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroIO);
			envio['valida'] = MD5.hash('asdfg');
			_request.data = envio;
			_urlLoader.load(_request);
			
			addChild(_voltar);
			addChild(_proximo);
			addChild(_anterior);
			*/
			
			_listaProj = new EscolhaProjeto('Escolha um projeto',_btOk ,_btCancelar , _btAbrir, new BotaoIcone(Graficos.ImgLixeira), File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/'));
		
			this._listaProj.addEventListener(Event.COMPLETE, onEscolhaOK);
			this._listaProj.addEventListener(Event.CANCEL, onEscolhaCancel);
			// this._listaProj.addEventListener(Event.OPEN, onEscolhaOpen);
			
			
		}
		//
		private function onEscolhaCancel(evt:Event):void
		{
			this.stage.removeChild(this._listaProj);
			// voltar pra outra tela
			this.mudaTela('inicial', null);
		}

		//
		private function onEscolhaOK(evt:Event):void
		{   trace('escolhidoOk ');
			var dados:Object = new Object;
			trace('escolhido é', this._listaProj.escolhido.id);
			trace ('projeto selecionado', JSON.stringify(this._listaProj.escolhido));
			
			dados.id = String(this._listaProj.escolhido.id);
			dados.tela = 'carregar'; 
			dados.qualTela = 'lista';
			this.stage.removeChild(_listaProj);
					
			mudaTela('fotorecuperada', dados);
			// carregar projeto this._listaProj.escolhido.id
			// abrir tela de visualização
			
			/*var acOK:Boolean = false;
			switch (this._acAtual) {
				case 'abrir projeto':
					if (this._listaProj.escolhido != null) {
						if (this._listaProj.escolhido.id != null) {
							// salvar projeto atual
							Main.projeto.salvar();
							// carregar o projeto selecionado
							if (Main.projeto.carregaProjeto(this._listaProj.escolhido.id)) Main.projeto.tempoAtual = 0;
							this.desenhaTrilhas();
							// ação ok
							acOK = true;
						}
					}
					if (!acOK) {
						// avisar sobre problema ao abrir projeto
						this.stage.removeChild(this._listaProj);
						//this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível abrir o projeto escolhido. Por favor tente novamente.');
						//this.stage.addChild(this._telaMensagem);
					} else {
						// mostrar projeto aberto
						this.stage.removeChild(this._listaProj);
						//this.addChild(this._telaPrincipal);
					}
					break;
				case 'exportar projeto':
					if (this._listaProj.escolhido != null) {
						if (this._listaProj.escolhido.id != null) {
							// recuperando nome de arquivo
							var exportado:String = Main.projeto.exportarID(this._listaProj.escolhido.id as String);
							if (exportado != '') {
								// ação ok
								acOK = true;
							}
						}
					}
					if (!acOK) {
						// avisar sobre problema ao exportar projeto
						this.stage.removeChild(this._listaProj);
						//this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido. Por favor tente novamente.');
						//this.stage.addChild(this._telaMensagem);
					} else {
						// avisar sobre o projeto exportado
						this.stage.removeChild(this._listaProj);
						//this._telaMensagem.defineMensagem('<b>Exportação concluída</b><br />&nbsp;<br />O projeto selecionado foi exportado e está gravado com o nome <br />&nbsp;<br /><b>' + exportado + '</b><br />&nbsp;<br />na pasta <br />&nbsp;<br /><b>' + File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados').nativePath + '</b><br />&nbsp;<br />de seu aparelho.');
						//this.stage.addChild(this._telaMensagem);
					}
					break;
				default:
					this.stage.removeChild(this._listaProj);
					//this.addChild(this._telaPrincipal);
					break;
			}*/
			
		}
		//
			
		//
		private function erroIO(evento:IOErrorEvent):void
		{
			
			trace(evento.text);
		}
		/*	private function recebeu(evento:Event):void
		{
			
			while (this._nomes.length > 0) this._nomes.shift();
			
			_urlLoader.removeEventListener(Event.COMPLETE, recebeu);
			
			var variaveis:URLVariables = new URLVariables(_urlLoader.data);
			
			if (variaveis['erro'] == null)
			{
				trace('resposta do servidor mal formatada');
			}
			else
			{
				if (variaveis['erro'] == '-1')
				{
					trace('erro de validação no servidor');
				}
				else if (variaveis['erro'] == '1')
				{
					trace('pasta não encontrada no servidor');
				}
				else
				{
					var arquivos:Array = String(variaveis['lista']).split(';');
					trace('arquivos encontrados:');
					trace('carregando: ' + link + 'baloes/gravados', arquivos);
					_total = arquivos.length;
					_pagina = 0;
					for (var i:int = 0; i < arquivos.length; i++)
					{
						this._nomes.push(String(arquivos[i]).split('.jpg').join(''));
					}
					
				}
				
			}
		}
		*/
	    /*	private function mostraPagina(num:int):void
		{
			trace('Pagina');
			if ((num >= 0) && ((num * IMAGENSPORPAGINA) < this._nomes.length))
			{
				this._pagina = num;
				for (var inome:int = 0; inome < IMAGENSPORPAGINA; inome++)
				{
					if (((num * IMAGENSPORPAGINA) + inome) < this._nomes.length)
					{
						this._lista[inome].addEventListener(MouseEvent.CLICK, cliqueLista);
						this._lista[inome].texto = this._nomes[(num * IMAGENSPORPAGINA) + inome];
						this._lista[inome].visible = true;
						this._lista[inome].width = stage.stageWidth;
						this._lista[inome].scaleY = this._lista[inome].scaleX;
						this._lista[inome].addEventListener(MouseEvent.CLICK, cliqueLista);
						this._lista[inome].y = _lista[inome].height * inome;
						
						this.addChild(this._lista[inome]);
						
						addChild(linhacima);
						addChild(linhabaixo);
						addChild(_voltar);
						addChild(_proximo);
						addChild(_anterior);
					}
					else
					{
						_lista[inome].visible = false;
					}
				}
			}
			trace('Fim da Pagina');
		
		}*/
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
						
			this.stage.addChild(_listaProj);
			_listaProj.listar();
			/*
			
			envio = new URLVariables();
			_urlLoader = new URLLoader();
			_request = new URLRequest(link + "baloes/listar.php");
			
			_request.method = 'POST';
			_urlLoader.addEventListener(Event.COMPLETE, recebeu);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroIO);
			envio['valida'] = MD5.hash('asdfg');
			_request.data = envio;
			_urlLoader.load(_request);
			
			this.mostraPagina(_pagina);
			
			//desenha botoes
			
			_voltar.width = stage.stageWidth / btscala;
			_voltar.scaleY = _voltar.scaleX;
			_voltar.x = stage.stageWidth / 2 - _voltar.width / 2;
			_voltar.y = stage.stageHeight - _voltar.height - stage.stageHeight / 40;
			
			_anterior.width = stage.stageWidth / btscala;
			_anterior.scaleY = _anterior.scaleX;
			_anterior.x = stage.stageWidth / 20;
			_anterior.y = stage.stageHeight - _voltar.height - stage.stageHeight / 40;
			
			_proximo.width = stage.stageWidth / btscala;
			_proximo.scaleY = _proximo.scaleX;
			_proximo.x = stage.stageWidth - _proximo.width - stage.stageHeight / 20;
			_proximo.y = stage.stageHeight - _proximo.height - stage.stageHeight / 40;
			
			if (!this._anterior.hasEventListener(MouseEvent.CLICK))
			{
				
				_voltar.addEventListener(MouseEvent.CLICK, cliquevoltar);
				_proximo.addEventListener(MouseEvent.CLICK, cliqueproximo);
				_anterior.addEventListener(MouseEvent.CLICK, cliqueanterior);
				
				trace('adicionou');
				
			}*/
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			
		/*	for (var i:int = 0; i < this._lista.length; i++)
			{
				if (this._lista[i].hasEventListener(MouseEvent.CLICK))
				{
					this._lista[i].removeEventListener(MouseEvent.CLICK, cliqueLista);
				}
			}
		*/
		}
		
		/*private function cliqueLista(evento:MouseEvent):void
		{
			
			var clicado:BotaoLista = evento.target as BotaoLista;
			var dados:Object = new Object;
			trace(clicado.texto);
			dados.link = clicado.texto + '.jpg';
			this.mudaTela('visualizar', dados);
		
		}
		//* /
		private function cliquevoltar(evento:MouseEvent):void
		{
			
			this.mudaTela('inicial', null);
		
		}
	    //* /
		private function cliqueproximo(evento:MouseEvent):void
		{
			
			this.mostraPagina(_pagina + 1);
			desenho();
			trace('proximo');
		}
		
		private function cliqueanterior(evento:MouseEvent):void
		{
			
			this.mostraPagina(_pagina - 1);
			desenho();
			trace('anterior')
		}//*/
	
	}
}