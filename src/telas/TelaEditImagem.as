package telas
{
	import caurina.transitions.Tweener;
	import componentes.BotaoIcone;
	import componentes.Imagem;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
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
		
		private var _oRotacao:Number;
		private var _oPosicao:Point;
		private var _oZoom:Number;
		private var dados:Object;
		private var btscala:Number;
		
		public function TelaEditImagem(funcMudaTela:Function)
		{
			super(funcMudaTela);
			dados = new Object();
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
			btscala = 10;
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			this.addChild(this._ok);
			this.addChild(this._cancelar);
			
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
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomImagem);
				stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoImagem);
				for (var i:int; i < _imagem.length; i++)
				{   addChild(_imagem[i])
					this._imagem[i].addEventListener(MouseEvent.MOUSE_DOWN, dragImagemStart);
				}
				
				stage.addEventListener(MouseEvent.MOUSE_UP, dragImagemStop);
				
				this.addChild(linhabaixo);
				
				this.addChild(this._ok);
				this.addChild(this._cancelar);
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				stage.addEventListener(Event.RESIZE, desenho);
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				linhacima.x = 0;
				Tweener.addTween(linhacima, {x: -linhacima.width, time: 1});
				
			}
		
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
			for (var j:int = 0; j < _imagem.length; j++) {
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
				if (_imagem[i] == evento.target as Imagem)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			
			this._imagem[indice].startDrag();
		}
		
		private function dragImagemStop(evento:MouseEvent):void	{			
			for (var i:int = 0; i < _imagem.length; i++) {				
				this._imagem[i].stopDrag();
				
			}
			
		}
		
		private function zoomImagem(evento:TransformGestureEvent):void
		{
			var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i] == evento.target as Imagem)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			_imagem[i].scaleX *= evento.scaleX;
			_imagem[i].scaleY = _imagem[i].scaleX;
		
		}
		
		private function rotacaoImagem(evento:TransformGestureEvent):void
		{	var indice:int;
			for (var i:int = 0; i < _imagem.length; i++)
			{
				if (_imagem[i] == evento.target as Imagem)
				{
					trace("o balao clicado é: ", indice = i);
				}
			}
			
			_imagem[i].rotation += evento.rotation;
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