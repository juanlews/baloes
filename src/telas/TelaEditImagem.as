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
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaEditImagem extends Tela
	{
		private var _imagem:Vector.<Imagem>;
		
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;		
		private var dados:Object;
		private var btscala:Number;
		
		
		public function TelaEditImagem(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 10;
			dados = new Object();
		   
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
		   
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			
			this._ok.width = stage.stageWidth / btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 20;
			this._ok.y = stage.stageHeight - _ok.height - stage.stageHeight / 40;
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - this.stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - stage.stageHeight / 40;
			
			if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
			{
				ObjetoAprendizagem.areaImagem.y = linhacima.height;
				stage.addEventListener(Event.RESIZE, desenho);
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
				stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);				
				stage.addEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);				
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				
				for (var i:int; i < _imagem.length; i++)
				{
					
					
					ObjetoAprendizagem.areaImagem.addChild(_imagem[i]);
				
					this._imagem[i].exclui(true);
					this._imagem[i].addEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
					this._imagem[i].addEventListener(String(i), excluiImagem);
					
					
					
				}
				
				this.addChild(linhabaixo);
				this.addChild(this._ok);
				this.addChild(this._cancelar);
				
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				linhacima.x = 0;
				Tweener.addTween(linhacima, {x: -linhacima.width, time: 1});
				
			}
		
		}
		private function excluiImagem(evento:Event):void {
		    this._imagem.splice(int(evento.type), 1);	
			for (var i:int = 0; i < _imagem.length; i++)
					{
						this._imagem[i].id = i;
					}
			trace(evento.type);
		}
		private function cliqueOk(evento:MouseEvent):void
		{
			dados.imagem = _imagem;
			this.mudaTela('fotorecuperada', dados);
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			this.mudaTela('fotorecuperada', null);
		
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
			for (var j:int = 0; j < _imagem.length; j++)
			{
				this._imagem[j].removeEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
			stage.removeEventListener(Event.RESIZE, desenho);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
		
		}
		
		private function dragImagemStart(evento:MouseEvent):void
		{
			var indice:int;
		    		
			for (var i:int = 0; i < _imagem.length; i++)
			{   
				
				if (_imagem[i].loader  == evento.target as Loader)
				{
					
					trace("Imagem clicada é: ", indice = i);
				}
			}
			
			this._imagem[indice].startDrag();
			
			 
		 }
		
		private function dragImagemStop(evento:MouseEvent):void
		{
			for (var i:int = 0; i < _imagem.length; i++)
			{
				this._imagem[i].stopDrag();
				
			}
		
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void
		{
			var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i].loader == evento.target as Loader)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			_imagem[indice].scaleX *= evento.scaleX;
			_imagem[indice].scaleY = _imagem[indice].scaleX;
		
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void
		{
			var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i].loader == evento.target as Loader)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			
			_imagem[indice].rotation += evento.rotation;
		}
	
		
		override public function recebeDados(dados:Object):void
		{
			if (dados != null)
			{
				this._imagem = dados.imagem as Vector.<Imagem>;
				
			}
			
			else
			{
				
				trace('imagem nao carregada');
			}
		
		}
	}

}