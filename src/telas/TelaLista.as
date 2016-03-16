package telas
{
	import componentes.BotaoIcone;
	import componentes.BotaoLista;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
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
		
		//Conexão com server
		private var _request:URLRequest;
		private var _urlLoader:URLLoader;
		private var envio:URLVariables;
		private var btscala:Number;
		
		public function TelaLista(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 8;
			_voltar = new BotaoIcone(Graficos.ImgCancelar);
			_proximo = new BotaoIcone(Graficos.ImgSetad);
			_anterior = new BotaoIcone(Graficos.ImgSetae);
			
			this._lista = new Vector.<BotaoLista>();
			for (var ilista:int = 0; ilista < IMAGENSPORPAGINA; ilista++)
			{
				this._lista.push(new BotaoLista('', Graficos.ImgBarra, new TextFormat('Pfennig', 60, 0, false, false, false, null, null, 'center'), new Rectangle(105, 105, 1120, 140)));
			}
			
			this._nomes = new Vector.<String>();
			
			addChild(_voltar);
			addChild(_proximo);
			addChild(_anterior);
			
			envio = new URLVariables();
			_urlLoader = new URLLoader();
			_request = new URLRequest(link + "baloes/listar.php");
			
			_request.method = 'POST';
			_urlLoader.addEventListener(Event.COMPLETE, recebeu);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erroIO);
			envio['valida'] = MD5.hash('asdfg');
			_request.data = envio;
			_urlLoader.load(_request);
		
		}
		
		private function erroIO(evento:IOErrorEvent):void
		{
			
			trace(evento.text);
		}
		
		private function recebeu(evento:Event):void
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
		
		private function mostraPagina(num:int):void
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
						_lista[inome].texto = this._nomes[(num * IMAGENSPORPAGINA) + inome];
						_lista[inome].visible = true;
						
						this._lista[inome].width = stage.stageWidth;
						this._lista[inome].scaleY = this._lista[inome].scaleX;
						this._lista[inome].addEventListener(MouseEvent.CLICK, cliqueLista);
						this._lista[inome].y = _lista[inome].height * inome;
						this.addChild(this._lista[inome]);
					}
					else
					{
						_lista[inome].visible = false;
					}
				}
			}
			trace('Fim da Pagina');
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			//desenha botoes
			
			_voltar.width = stage.stageWidth / btscala;
			_voltar.scaleY = _voltar.scaleX;
			_voltar.x = stage.stageWidth / 2 - _voltar.width / 2;
			_voltar.y = stage.stageHeight - _voltar.height - stage.stageHeight / 40;
			
			_anterior.width = stage.stageWidth / btscala;
			_anterior.scaleY = _anterior.scaleX;
			_anterior.x = stage.stageWidth / 20;
			_anterior.y = stage.stageHeight - _voltar.height - stage.stageHeight / 40 ;
			
			_proximo.width = stage.stageWidth / btscala;
			_proximo.scaleX = -_proximo.scaleX;
			_proximo.scaleY = _proximo.scaleX;
			_proximo.x = stage.stageWidth - stage.stageHeight / 40;
			_proximo.y = stage.stageHeight - _proximo.height - stage.stageHeight / 40;
			
			this.mostraPagina(_pagina);
			
			if (!this._anterior.hasEventListener(MouseEvent.CLICK))
			{
				
				_voltar.addEventListener(MouseEvent.CLICK, cliquevoltar);
				_proximo.addEventListener(MouseEvent.CLICK, cliqueproximo);
				_anterior.addEventListener(MouseEvent.CLICK, cliqueanterior);
				
				trace('adicionou');
				
			}
			
			var cont:int = 0;
		/*for (var i:int = atual; i < atual + 5; i++)
		   {
		
		   trace(i);
		   if (i >= _lista.length)
		   {
		   this._proximo.removeEventListener(MouseEvent.CLICK, cliqueproximo);
		   }
		   if (i <= 0)
		   {
		   this._anterior.removeEventListener(MouseEvent.CLICK, cliqueanterior);
		   }
		
		   if (!(i >= _lista.length || i < 0))
		   {
		   this._lista[i].addEventListener(MouseEvent.CLICK, cliqueLista);
		   this._lista[i].y = _lista[i].height * cont;
		   this.addChild(this._lista[i]);
		   cont++;
		   }
		
		   }*/
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			for (var i:int = 0; i < this._lista.length; i++)
			{
				if (this._lista[i].hasEventListener(MouseEvent.CLICK))
				{
					this._lista[i].removeEventListener(MouseEvent.CLICK, cliqueLista);
				}
			}
		
		}
		
		private function cliqueLista(evento:MouseEvent):void
		{
			
			var clicado:BotaoLista = evento.target as BotaoLista;
			var dados:Object = new Object;
			trace(clicado.texto);
			dados.link = clicado.texto + '.jpg';
			this.mudaTela('visualizar', dados);
		
		}
		
		private function cliquevoltar(evento:MouseEvent):void
		{
			
			this.mudaTela('inicial', null);
		
		}
		
		private function cliqueproximo(evento:MouseEvent):void
		{
			/*if (!this._anterior.hasEventListener(MouseEvent.CLICK))
			   {
			   this._anterior.addEventListener(MouseEvent.CLICK, cliqueanterior)
			   }
			   for (var i:int = atual; i < atual + 5; i++)
			   {
			   if (i >= _lista.length - 1 || i < 0)
			   {
			   trace(i);
			   }
			   else
			   {
			   if (this._lista[i].hasEventListener(MouseEvent.CLICK))
			   {
			   this._lista[i].removeEventListener(MouseEvent.CLICK, cliqueLista);
			   }
			   this.removeChild(this._lista[i]);
			   }
			   }*/
			//_pagina = _pagina + 1;
			this.mostraPagina(_pagina + 1);
			desenho();
			trace('proximo');
		}
		
		private function cliqueanterior(evento:MouseEvent):void
		{
			/*
			   if (!this._proximo.hasEventListener(MouseEvent.CLICK))
			   {
			   this._proximo.addEventListener(MouseEvent.CLICK, cliqueproximo)
			   }
			   for (var i:int = atual; i < atual + 5; i++)
			   {
			   if (i > _lista.length - 1 || i < 0)
			   {
			   trace(i);
			   }
			   else
			   {
			   if (this._lista[i].hasEventListener(MouseEvent.CLICK))
			   {
			   this._lista[i].removeEventListener(MouseEvent.CLICK, cliqueLista);
			   }
			   this.removeChild(this._lista[i]);
			   }
			   }*/
			this.mostraPagina(_pagina - 1);
			desenho();
			trace('anterior')
		}
	
	}
}