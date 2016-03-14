package telas
{
	
	import com.adobe.images.BitString;
	import componentes.Balao;
	import componentes.BotaoIcone;
	import componentes.BotaoRadio;
	import flash.automation.MouseAutomationAction;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaPropriedadesBalao extends Tela
	{
		
		private var _texto:TextField;
		
		// tipos de balão
		private var _tipo1:BotaoRadio;
		private var _tipo2:BotaoRadio;
		private var _tipo3:BotaoRadio;
		
		private var _cor1:BotaoRadio;
		private var _cor2:BotaoRadio;
		private var _cor3:BotaoRadio;
		private var _cor4:BotaoRadio;
		private var _cor5:BotaoRadio;
		
		private var _flipH:BotaoIcone;
		private var _flipV:BotaoIcone;
		private var _ok:BotaoIcone;
		
		private var _preview:Balao;
		private var _checktrue:BotaoIcone;
		private var _checkfalse:BotaoIcone;
		
		private var _marcado:Boolean;
		
		private var _fndprev:BotaoIcone;
		
		private var _balaoP:Balao;
		
		private var _modelobalao:int;
		
		public function TelaPropriedadesBalao(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			// adicionar caixa de texto para input
			
			// adicionando grupo de radio do tipo de balão
			this._tipo1 = new BotaoRadio(Graficos.ImgBTBalao01, '1', true);
			this._tipo2 = new BotaoRadio(Graficos.ImgBTBalao02, '2');
			this._tipo3 = new BotaoRadio(Graficos.ImgBTBalao03, '3');
			
			var grupoTipoBalao:Vector.<BotaoRadio> = new Vector.<BotaoRadio>();
			grupoTipoBalao.push(this._tipo1);
			grupoTipoBalao.push(this._tipo2);
			grupoTipoBalao.push(this._tipo3);
			
			this._tipo1.grupo = this._tipo2.grupo = this._tipo3.grupo = grupoTipoBalao;
			
			// adicionando grupo de radio de cores
			
			this._cor1 = new BotaoRadio(Graficos.ImgBTCor01, '1');
			this._cor2 = new BotaoRadio(Graficos.ImgBTCor02, '2');
			this._cor3 = new BotaoRadio(Graficos.ImgBTCor03, '3');
			this._cor4 = new BotaoRadio(Graficos.ImgBTCor04, '4');
			this._cor5 = new BotaoRadio(Graficos.ImgBTCor05, '5');
			
			var grupoCores:Vector.<BotaoRadio> = new Vector.<BotaoRadio>();
			grupoCores.push(this._cor1);
			grupoCores.push(this._cor2);
			grupoCores.push(this._cor3);
			grupoCores.push(this._cor4);
			grupoCores.push(this._cor5);
			
			this._cor1.grupo = this._cor2.grupo = this._cor3.grupo = this._cor4.grupo = this._cor5.grupo = grupoCores;
			
			this._fndprev = new BotaoIcone(Graficos.ImgHelp);
			//adicionando os baloes
			this._balaoP = new Balao();
			this._balaoP.mouseChildren = true;

			//adicionando os botoes do tipo icone
			this._flipH = new BotaoIcone(Graficos.ImgPBFlipH);
			this._flipV = new BotaoIcone(Graficos.ImgPBFlipV);
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._checkfalse = new BotaoIcone(Graficos.ImgCheck);
			this._checktrue = new BotaoIcone(Graficos.ImgCheckT);
		
		}
		
		private function cliqueCor(evento:Event):void
		{
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor)
			{
			case '1': 
				_balaoP.setCor(255, 0, 0, 0);
				break;
			case '2': 
				_balaoP.setCor(63, 169, 245, 0);
				break;
			case '3': 
				_balaoP.setCor(153, 153, 153, 0);
				break;
			case '4': 
				_balaoP.setCor(204, 204, 204, 0);
				break;
			case '5': 
				_balaoP.setCor(255, 255, 255, 0);
				break;
			}
		}
		
		private function cliqueBTipo(evento:Event):void
		{
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor)
			{
			case '1': 
				break;
			case '2': 
				break;
			case '3': 
				break;
			}
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			// posicionar todo mundo
			// fundo 
			this._fndprev.width = stage.stageWidth;
			this._fndprev.height = stage.stageHeight / 2 - 30;
			this._fndprev.x = 2;
			this._fndprev.y = stage.stageHeight / 3 + 90;
			this.addChild(this._fndprev);
			
			// balao padrao
			this._balaoP.width = this._fndprev.width - 50;
			this._balaoP.scaleY = this._balaoP.scaleX;
			this._balaoP.x = this._fndprev.x + 20;
			this._balaoP.y = this._fndprev.y;
			this._balaoP.tipo = this._modelobalao;
			this.addChild(this._balaoP);
			
			//botoes do tipo icone 
			//flip Horizontal
			this._flipH.width = 60;
			this._flipH.scaleY = this._flipH.scaleX;
			this._flipH.x = 0;
			this._flipH.y = stage.stageHeight - this._flipH.height;
			this.addChild(this._flipH);
			
			//flip vertical
			this._flipV.width = 60;
			this._flipV.scaleY = this._flipV.scaleX;
			this._flipV.x = stage.stageWidth / 2 - this._flipV.width / 2;
			this._flipV.y = stage.stageHeight - this._flipV.height;
			this.addChild(this._flipV);
			
			// botao ok
			this._ok.width = 60;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth - this._ok.width;
			this._ok.y = stage.stageHeight - this._ok.height;
			this.addChild(this._ok);
			
			// check	
			this._checkfalse.width = 60;
			this._checkfalse.scaleY = this._checkfalse.scaleX;
			this._checkfalse.x = stage.stageWidth - this._checkfalse.width;
			this._checkfalse.y = stage.stageHeight / 3 + 40;
			this.addChild(this._checkfalse);
			
			this._checktrue.width = 60;
			this._checktrue.scaleY = this._checktrue.scaleX;
			this._checktrue.x = stage.stageWidth - this._checktrue.width;
			this._checktrue.y = stage.stageHeight / 3 + 40;
			//this.addChild(this._checktrue);
			
			//botoes do tipo radio
			//balao
			this._tipo1.x = 0;
			this._tipo1.y = 50;
			this._tipo1.width = stage.stageWidth / 3;
			this._tipo1.scaleY = this._tipo1.scaleX;
			this.addChild(this._tipo1);
			
			this._tipo2.x = this._tipo1.x + this._tipo1.width;
			this._tipo2.y = 50;
			this._tipo2.width = stage.stageWidth / 3;
			this._tipo2.scaleY = this._tipo2.scaleX;
			this.addChild(this._tipo2);
			
			this._tipo3.x = this._tipo2.x + this._tipo2.width;
			this._tipo3.y = 50;
			this._tipo3.width = stage.stageWidth / 3;
			this._tipo3.scaleY = this._tipo3.scaleX;
			this.addChild(this._tipo3);
			
			//cor
			this._cor1.x = 0;
			this._cor1.y = stage.stageHeight / 4;
			this._cor1.width = stage.stageWidth / 5
			this._cor1.scaleY = this._cor1.scaleX;
			this.addChild(this._cor1);
			
			this._cor2.x = this._cor1.x + this._cor1.width;
			this._cor2.y = stage.stageHeight / 4;
			this._cor2.width = stage.stageWidth / 5
			this._cor2.scaleY = this._cor2.scaleX;
			this.addChild(this._cor2);
			
			this._cor3.x = this._cor2.x + this._cor2.width;
			this._cor3.y = stage.stageHeight / 4;
			this._cor3.width = stage.stageWidth / 5
			this._cor3.scaleY = this._cor3.scaleX;
			this.addChild(this._cor3);
			
			this._cor4.x = this._cor3.x + this._cor3.width;
			this._cor4.y = stage.stageHeight / 4;
			this._cor4.width = stage.stageWidth / 5
			this._cor4.scaleY = this._cor4.scaleX;
			this.addChild(this._cor4);
			
			this._cor5.x = this._cor4.x + this._cor4.width;
			this._cor5.y = stage.stageHeight / 4;
			this._cor5.width = stage.stageWidth / 5
			this._cor5.scaleY = this._cor5.scaleX;
			this.addChild(this._cor5);
			
			// listners
			
			this._checkfalse.addEventListener(MouseEvent.CLICK, marca);
			
			this._checktrue.addEventListener(MouseEvent.CLICK, desmarca);
			
			this._ok.addEventListener(MouseEvent.CLICK, okclick);
			
			this._flipH.addEventListener(MouseEvent.CLICK, fliphclick);
			
			this._flipV.addEventListener(MouseEvent.CLICK, flipvclick);
			
			this._tipo1.addEventListener('marcado', cliqueBTipo1);
			
			this._tipo2.addEventListener('marcado', cliqueBTipo2);
			
			this._tipo3.addEventListener('marcado', cliqueBTipo3);
			
			this._cor1.addEventListener('marcado', cliqueCor);
			
			this._cor2.addEventListener('marcado', cliqueCor);
			
			this._cor3.addEventListener('marcado', cliqueCor);
			
			this._cor4.addEventListener('marcado', cliqueCor);
			
			this._cor5.addEventListener('marcado', cliqueCor);
		
		}
		
		public function cliqueBTipo1(evento:Event):void
		{
			
			this._modelobalao = 0;
			this._balaoP.width = this._fndprev.width - 50;
			this._balaoP.scaleY = this._balaoP.scaleX;
			this._balaoP.x = this._fndprev.x + 20;
			this._balaoP.y = this._fndprev.y;
			this._balaoP.tipo = this._modelobalao;
			this.addChild(this._balaoP);
			trace('clicoumodelobalao1');
		}
		
		public function cliqueBTipo2(evento:Event):void
		{
			
			this._modelobalao = 1;
			this._balaoP.width = this._fndprev.width - 50;
			this._balaoP.scaleY = this._balaoP.scaleX;
			this._balaoP.x = this._fndprev.x + 20;
			this._balaoP.y = this._fndprev.y;
			this._balaoP.tipo = this._modelobalao;
			this.addChild(this._balaoP);
			trace('clicoumodelobalao2');
		}
		
		public function cliqueBTipo3(evento:Event):void
		{
			this._modelobalao = 2;
			this._balaoP.width = this._fndprev.width - 50;
			this._balaoP.scaleY = this._balaoP.scaleX;
			this._balaoP.x = this._fndprev.x + 20;
			this._balaoP.y = this._fndprev.y;
			this._balaoP.tipo = this._modelobalao;
			this.addChild(this._balaoP);
			trace('clicoumodelobalao3');
		}
		
		public function marca(evento:MouseEvent):void
		{
			
			removeChild(this._checkfalse);
			addChild(this._checktrue);
		}
		
		public function desmarca(evento:MouseEvent):void
		{
			
			removeChild(this._checktrue);
			addChild(this._checkfalse);
		}
		
		public function fliphclick(event:MouseEvent):void
		{
			trace('clicoufliph');
		}
		
		public function flipvclick(event:MouseEvent):void
		{
			trace('clicouflipv');
		}
		
		public function okclick(event:MouseEvent):void
		{
			
			var dados:Object = new Object();
			
			dados.balaoProp = this._balaoP;
			this.mudaTela('fotorecuperada', dados);
		}
		
		override public function recebeDados(dados:Object):void
		{
			if ((dados != null) && (dados.balao != null))
			{
				this._balaoP.copyProp(dados.balao as Balao);
			}
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			// remover listeners
			this._checkfalse.removeEventListener(MouseEvent.CLICK, desmarca);
			this._checktrue.removeEventListener(MouseEvent.CLICK, marca);
			this._flipH.removeEventListener(MouseEvent.CLICK, fliphclick);
			this._flipV.removeEventListener(MouseEvent.CLICK, flipvclick);
			this._ok.removeEventListener(MouseEvent.CLICK, okclick);
			
			this._tipo1.removeEventListener('marcado', cliqueBTipo);
			this._tipo2.removeEventListener('marcado', cliqueBTipo);
			this._tipo3.removeEventListener('marcado', cliqueBTipo);
			
			this._cor1.removeEventListener('marcado', cliqueCor);
			this._cor2.removeEventListener('marcado', cliqueCor);
			this._cor3.removeEventListener('marcado', cliqueCor);
			this._cor4.removeEventListener('marcado', cliqueCor);
			this._cor5.removeEventListener('marcado', cliqueCor);
			
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
	
	}

}