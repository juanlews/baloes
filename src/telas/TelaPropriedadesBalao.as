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
		private var _fndprev:BotaoIcone;
		private var _ok:BotaoIcone;
		private var _excBalao:BotaoIcone;
		
		private var _preview:Balao;
		
		private var _balaoP:Balao;
		
		private var _balaoO:Balao;
		
		private var _modelobalao:int;
		
		private var _marcado:Boolean;
		
		private var _btscala:Number;
		
		private var _excluir:BotaoIcone;
		
		public function TelaPropriedadesBalao(funcMudaTela:Function)
		{
			super(funcMudaTela);
			
			
			
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
			this._cor1 = new BotaoRadio(Graficos.ImgBTCor01, '1', true);
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
			this._balaoP = new Balao(0);
			this._balaoP.mouseChildren = true;

			//adicionando os botoes do tipo icone
			this._flipH = new BotaoIcone(Graficos.ImgPBFlipH);
			this._flipV = new BotaoIcone(Graficos.ImgPBFlipV);
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._excluir = new BotaoIcone(Graficos.ImgLixeira);
			
			// adicionando valor a variavel btnscala
			this._btscala = 10;
			
			// removendo linha de cima
			removeChild(linhacima);
		}
		
		private function cliqueCor(evento:Event):void
		{
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor)
			{
			case '1': 
				_balaoP.setCor(255, 104, 108, 1, 0);
				break;
			case '2': 
				_balaoP.setCor(63, 169, 245, 2, 0);
				break;
			case '3': 
				_balaoP.setCor(153, 153, 153, 3, 0);
				break;
			case '4': 
				_balaoP.setCor(204, 204, 204, 4, 0);
				break;
			case '5': 
				_balaoP.setCor(255, 255, 255, 5, 0);
				break;
			}
		}
		
		private function cliqueBTipo(evento:Event):void
		{
			var clicado:BotaoRadio = evento.target as BotaoRadio;
			switch (clicado.valor)
			{
			case '1': 
				this._modelobalao = 0;
				this._balaoP.tipo = this._modelobalao;
				trace('clicoumodelobalao1');
				break;
			case '2': 
				this._modelobalao = 1;
				this._balaoP.tipo = this._modelobalao;
				trace('clicoumodelobalao2');
				break;
			case '3': 
				this._modelobalao = 2;
				this._balaoP.tipo = this._modelobalao;
				trace('clicoumodelobalao3');
				break;
			}
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			// posicionar todo mundo
			
			
			
			// fundo 
			this._fndprev.width = stage.stageWidth;
			this._fndprev.height = stage.stageHeight / 2 ;
			this._fndprev.x = 0;
			this._fndprev.y = stage.stageHeight / 3 + this._fndprev.height/8;
			this.addChild(this._fndprev);
			
			// balao padrao
			this._balaoP.width = this._fndprev.width - 50;
			this._balaoP.scaleY = this._balaoP.scaleX;
			this._balaoP.x = this._fndprev.x + this._balaoP.width/20;
			this._balaoP.y = this._fndprev.y + this._balaoP.height/20;
			this._balaoP.tipo = this._modelobalao;
			this.addChild(this._balaoP);
			
			//botoes do tipo icone 
			//flip Horizontal
			this._flipH.width = stage.stageWidth / this._btscala;
			this._flipH.scaleY = this._flipH.scaleX;
			this._flipH.x = stage.stageWidth - this._flipH.width - stage.stageWidth/20;
			this._flipH.y = stage.stageHeight - this._flipH.height - stage.stageHeight/40;
			this.addChild(this._flipH);
			
			//flip vertical
			this._flipV.width = stage.stageWidth/ this._btscala;
			this._flipV.scaleY = this._flipV.scaleX;
			this._flipV.x = stage.stageWidth / 2 - this._flipV.width / 2;
			this._flipV.y = stage.stageHeight - this._flipV.height - stage.stageHeight/40;
			this.addChild(this._flipV);
			
			// botao ok
			this._ok.width = stage.stageWidth / this._btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth/20;
			this._ok.y = stage.stageHeight - this._ok.width - stage.stageHeight /  40;
			this.addChild(this._ok);
			
			//botão excluir balão
			this._excluir.width = stage.stageWidth / this._btscala;
			this._excluir.scaleY = this._excluir.scaleX;
			this._excluir.x = stage.stageWidth - this._excluir.width -stage.stageWidth/20 ;
			this._excluir.y = this._fndprev.y - this._excluir.height;
			this.addChild(this._excluir);
			//botoes do tipo radio
			//balao
			this._tipo1.x =stage.stageWidth/20;
			this._tipo1.y = stage.stageHeight/40;
			this._tipo1.width = stage.stageWidth / 3.5;
			this._tipo1.scaleY = this._tipo1.scaleX;
			this.addChild(this._tipo1);
			
			this._tipo2.x = this._tipo1.x + this._tipo1.width + this._tipo1.width/20;
			this._tipo2.y= stage.stageHeight/40;
			this._tipo2.width = stage.stageWidth / 3.5;
			this._tipo2.scaleY = this._tipo2.scaleX;
			this.addChild(this._tipo2);
			
			this._tipo3.x = this._tipo2.x + this._tipo2.width + this._tipo1.width/20;
			this._tipo3.y = stage.stageHeight/40;
			this._tipo3.width = stage.stageWidth / 3.5;
			this._tipo3.scaleY = this._tipo3.scaleX;
			this.addChild(this._tipo3);
			
			//cor
			this._cor1.x = stage.stageWidth / 20 ;
			this._cor1.y = stage.stageHeight / 6;
			this._cor1.width = stage.stageWidth / 8
			this._cor1.scaleY = this._cor1.scaleX;
			this.addChild(this._cor1);
			
			this._cor2.x = this._cor1.x + this._cor1.width *1.5;
			this._cor2.y = stage.stageHeight / 6;
			this._cor2.width = stage.stageWidth /8;
			this._cor2.scaleY = this._cor2.scaleX;
			this.addChild(this._cor2);
			
			this._cor3.x = this._cor2.x + this._cor2.width *1.5;
			this._cor3.y = stage.stageHeight /6;
			this._cor3.width = stage.stageWidth / 8
			this._cor3.scaleY = this._cor3.scaleX;
			this.addChild(this._cor3);
			
			this._cor4.x = this._cor3.x + this._cor3.width * 1.5;
			this._cor4.y = stage.stageHeight / 6;
			this._cor4.width = stage.stageWidth / 8
			this._cor4.scaleY = this._cor4.scaleX;
			this.addChild(this._cor4);
			
			this._cor5.x = this._cor4.x + this._cor4.width * 1.5;
			this._cor5.y = stage.stageHeight / 6;
			this._cor5.width = stage.stageWidth / 8
			this._cor5.scaleY = this._cor5.scaleX;
			this.addChild(this._cor5);
			
			// listners
			
			if (!this._ok.hasEventListener(MouseEvent.CLICK))
			{
				
				trace('criando listener');
				
				this._tipo1.addEventListener('marcado', cliqueBTipo);
				
				this._tipo2.addEventListener('marcado', cliqueBTipo);
				
				this._tipo3.addEventListener('marcado', cliqueBTipo);
				
				this._cor1.addEventListener('marcado', cliqueCor);
				
				this._cor2.addEventListener('marcado', cliqueCor);
				
				this._cor3.addEventListener('marcado', cliqueCor);
				
				this._cor4.addEventListener('marcado', cliqueCor);
				
				this._cor5.addEventListener('marcado', cliqueCor);
								
				this._ok.addEventListener(MouseEvent.CLICK, okclick);
				
				this._flipH.addEventListener(MouseEvent.CLICK, fliphclick);
				
				this._flipV.addEventListener(MouseEvent.CLICK, flipvclick);
				
				this._excluir.addEventListener(MouseEvent.CLICK, excluirbalao);
			}
		}
		public function excluirbalao(event:MouseEvent):void {
		
			trace('excluir balao');
			this.mudaTela('fotorecuperada',null);
			
			
		
		}
		public function fliphclick(event:MouseEvent):void
		{
			this._balaoP.flipH();
			
		}
		public function flipvclick(event:MouseEvent):void
		{
			this._balaoP.flipV();
				
		}
		public function okclick(event:MouseEvent):void
		{
			var dados:Object = new Object();
			
			 this._balaoO.copyProp(this._balaoP);
			
			this.mudaTela('fotorecuperada', dados);
			
			trace(this._balaoP);
		}
		
		override public function recebeDados(dados:Object):void
		{
			if ((dados != null) && (dados.balao != null))
			{
				this._balaoO = dados.balao as Balao;
				
				this._balaoP.copyProp(_balaoO);
				
				switch (this._balaoP.botaoCor)
				{
				case 1: 
					this._cor1.marcado = true;
					break;
				case 2: 
					this._cor2.marcado = true;
					break;
				case 3: 
					this._cor3.marcado = true;
					break;
				case 4: 
					this._cor4.marcado = true;
					break;
				case 5: 
					this._cor5.marcado = true;
					break;
				}
				
			}
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			// remover listeners
			
			
			this._ok.removeEventListener(MouseEvent.CLICK, okclick);
			
			this._tipo1.removeEventListener('marcado', cliqueBTipo);
			this._tipo2.removeEventListener('marcado', cliqueBTipo);
			this._tipo3.removeEventListener('marcado', cliqueBTipo);
			
			this._cor1.removeEventListener('marcado', cliqueCor);
			this._cor2.removeEventListener('marcado', cliqueCor);
			this._cor3.removeEventListener('marcado', cliqueCor);
			this._cor4.removeEventListener('marcado', cliqueCor);
			this._cor5.removeEventListener('marcado', cliqueCor);
		
			this._ok.removeEventListener(MouseEvent.CLICK, okclick);
			this._flipH.removeEventListener(MouseEvent.CLICK, fliphclick);
			this._flipV.removeEventListener(MouseEvent.CLICK, flipvclick);
			
			stage.removeEventListener(Event.RESIZE, desenho);
		
		}
	
	}

}