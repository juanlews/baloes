package telas
{
	import caurina.transitions.Tweener;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaEditImagem extends Tela
	{
		private var _lixeira:BotaoIcone;
		private var _imagem:Imagem;
		private var _editavel:Boolean;
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;		
		private var dados:Object;
		private var btscala:Number;
		private var paginaAtual:int;
		private var imgOrig:Imagem;
		private var _btZoomIn:BotaoIcone;
		private var _btZoomOut:BotaoIcone;
		private var _rodaDireita:BotaoIcone;
		private var _rodaEsquerda:BotaoIcone;
		
		public function TelaEditImagem(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 10;
			dados = new Object();
			imgOrig = new Imagem();
		    this._lixeira = new BotaoIcone(Graficos.ImgLixeira);
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
		    this._btZoomIn = new BotaoIcone(Graficos.ImgZoomIn);
			this._btZoomOut = new BotaoIcone(Graficos.ImgZoomOut);
			this._rodaDireita = new BotaoIcone(Graficos.rotacaoDireita);
			this._rodaEsquerda = new BotaoIcone(Graficos.rotacaoEsquerda);
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			this._btZoomIn.x = stage.stageWidth / 30;
			this._btZoomIn.width = stage.stageWidth / 15;
			this._btZoomIn.scaleY = this._btZoomIn.scaleX;
			this._btZoomIn.y = stage.stageHeight / 2 - (_btZoomIn.height * 1.5);
			
			this._btZoomOut.x = stage.stageWidth / 30;
			this._btZoomOut.width = stage.stageWidth / 15;
			this._btZoomOut.scaleY = this._btZoomOut.scaleX;
			this._btZoomOut.y = stage.stageHeight / 2 ;
						
			this._rodaDireita.width = stage.stageWidth / 15;
			this._rodaDireita.scaleY = this._rodaDireita.scaleX;
			this._rodaDireita.x = stage.stageWidth - stage.stageWidth / 30 - this._rodaDireita.width;
			this._rodaDireita.y = stage.stageHeight / 2 - (_rodaDireita.height * 1.5);
			
			this._rodaEsquerda.width = stage.stageWidth / 15;
			this._rodaEsquerda.scaleY = this._rodaEsquerda.scaleX;
			this._rodaEsquerda.x = stage.stageWidth - stage.stageWidth / 30 - this._rodaEsquerda.width;
			this._rodaEsquerda.y = stage.stageHeight / 2;
			
			this._ok.width = stage.stageWidth / btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 20;
			this._ok.y = stage.stageHeight - this._ok.height - stage.stageHeight / 40;
			
			this._lixeira.width = stage.stageWidth / btscala;
			this._lixeira.scaleY = this._lixeira.scaleX;
			this._lixeira.x = stage.stageWidth / 2 - this._lixeira.width / 2; 
			this._lixeira.y = stage.stageHeight - this._lixeira.height - stage.stageHeight / 40;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - this.stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - stage.stageHeight / 40;
			
			ObjetoAprendizagem.areaImagem.y = linhacima.height;
			
			
			if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
			{
				
				stage.addEventListener(Event.RESIZE, desenho);
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
				stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);				
				stage.addEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);				
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				this._lixeira.addEventListener(MouseEvent.CLICK, excluiImagem);
				this._btZoomOut.addEventListener(MouseEvent.CLICK, zoomOutPorBotao);
				this._btZoomIn.addEventListener(MouseEvent.CLICK, zoomInPorBotao);
				this._rodaDireita.addEventListener(MouseEvent.CLICK,  rodaDireita);
				this._rodaEsquerda.addEventListener(MouseEvent.CLICK, rodaEsquerda);
				/*
				for (var i:int; i < _imagem.length; i++)
				{
					
					
					ObjetoAprendizagem.areaImagem.addChild(_imagem[i]);
				
					this._imagem[i].exclui(true);
					this._imagem[i].addEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
					this._imagem[i].addEventListener(String(i), excluiImagem);
					
					
					
				}
				*/
//				this._imagem.exclui(true);
				this._imagem.addEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
				//this._imagem.addEventListener(String(_imagem.id), excluiImagem);
					
				this.addChild(linhabaixo);
				this.addChild(this._ok);
				this.addChild(this._lixeira);
				this.addChild(this._cancelar);
				this.addChild(this._btZoomIn);
				this.addChild(this._btZoomOut);
				this.addChild(this._rodaDireita);
				this.addChild(this._rodaEsquerda);
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				
				//linhacima.x = 0;
				//Tweener.addTween(linhacima, {x: -linhacima.width, time: 1});
				
			}
		
		}
		
		private function rodaDireita(evento:MouseEvent):void {
		
			_imagem.rotation +=  1;
			
		}
		private function rodaEsquerda(evento:MouseEvent):void {
		
			_imagem.rotation +=  -1;
			
		}
		
		private function zoomOutPorBotao(evento:MouseEvent):void {
			_imagem.scaleX += -0.05;
			_imagem.scaleY = _imagem.scaleX;
		}
		private function zoomInPorBotao(evento:MouseEvent):void {
			_imagem.scaleX += +0.05;
			_imagem.scaleY = _imagem.scaleX;
		}
		private function excluiImagem(evento:MouseEvent):void {
			
			/*
		   // this._imagem[int(evento.type)].removeEventListener(evento.type, excluiImagem);
		
			this._imagem.splice(image, 1);	
			for (var i:int = 0; i < _imagem.length; i++)
					{
						this._imagem[i].redefineId(i, paginaAtual);
					}
			trace(evento.type);*/
			dados.imagemExclui = true;
			dados.numero = _imagem.id;
			
			mudaTela('fotorecuperada', dados); 
		}
		private function cliqueOk(evento:MouseEvent):void
		{
			//dados.imagem = _imagem;
			this.mudaTela('fotorecuperada', null);
		}
		
		override public function botaoBack():void 
		{
			this.cliqueCancelar(null);
		}
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this._imagem.copyAllProp(imgOrig);
			this.mudaTela('fotorecuperada', null);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
			this._rodaDireita.removeEventListener(MouseEvent.CLICK,  rodaDireita);
			this._rodaEsquerda.removeEventListener(MouseEvent.CLICK, rodaEsquerda);
			this._btZoomOut.removeEventListener(MouseEvent.CLICK, zoomOutPorBotao);
			this._btZoomIn.removeEventListener(MouseEvent.CLICK, zoomInPorBotao);
			
			this._imagem.removeEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
			stage.removeEventListener(Event.RESIZE, desenho);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
		
		}
		
		private function dragImagemStart(evento:MouseEvent):void
		{
			this._imagem.startDrag();
			/*var indice:int;
		    		
			for (var i:int = 0; i < _imagem.length; i++)
			{   
				
				if (_imagem[i].loader  == evento.target as Loader)
				{
					
					trace("Imagem clicada é: ", indice = i);
				}
			}
			
			this._imagem[indice].startDrag();
			*/
			 
		 }
		
		private function dragImagemStop(evento:MouseEvent):void
		{
				this._imagem.stopDrag();
				
		
		
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void
		{
			/*var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i].loader == evento.target as Loader)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}*/
			_imagem.scaleX *= evento.scaleX;
			_imagem.scaleY = _imagem.scaleX;
		
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void
		{
			/*
			var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i].loader == evento.target as Loader)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			*/
			_imagem.rotation += evento.rotation;
		}
	
		
		override public function recebeDados(dados:Object):void
		{
			if (dados != null)
			{
				this._imagem = dados.imagem as Imagem;
				this.imgOrig.copyAllProp(_imagem);
				this.paginaAtual = dados.paginaAtual;
			}
			
			else
			{
				
				//trace('imagem nao carregada');
			}
		
		}
	}

}