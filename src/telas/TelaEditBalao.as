package telas
{
	import caurina.transitions.Tweener;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import com.google.zxing.BarcodeFormat;
	import componentes.Balao;
	import componentes.Imagem;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.Event;
	import componentes.BotaoIcone;
	import recursos.Graficos;
	
	/**
	 * ...
	 * @author colaboa
	 */
	
	public class TelaEditBalao extends Tela
	{
		
		private var _imagem:Vector.<Imagem>;
		private var _ok:BotaoIcone;
		private var _cancelar:BotaoIcone;
		private var _oRotacao:Number;
		private var _oPosicao:Point;
		private var _oZoom:Number;
		
		private var _balao:Balao;
		
		private var dados:Object;
		private var btscala:Number;
		
		private var balaOrig:Balao;
		
		public function TelaEditBalao(funcMudaTela:Function)
		{
			super(funcMudaTela);
			btscala = 10;
			dados = new Object();
			balaOrig = new Balao(1);
			this._ok = new BotaoIcone(Graficos.ImgPBOK);
			this._cancelar = new BotaoIcone(Graficos.ImgCancelar);
		
		}
		
		override public function desenho(evento:Event = null):void
		{
			super.desenho(evento);
			
			this._ok.width = stage.stageWidth / btscala;
			this._ok.scaleY = this._ok.scaleX;
			this._ok.x = stage.stageWidth / 20;
			this._ok.y = stage.stageHeight - this._ok.height - (stage.stageHeight / 40);
			
			//botão cancelar
			this._cancelar.width = stage.stageWidth / btscala;
			this._cancelar.scaleY = this._cancelar.scaleX;
			this._cancelar.x = stage.stageWidth - _cancelar.width - this.stage.stageWidth / 20;
			this._cancelar.y = stage.stageHeight - this._cancelar.height - stage.stageHeight / 40;
			
			if (!this._cancelar.hasEventListener(MouseEvent.CLICK))
			{
				
				this.addChild(linhabaixo);
				this.addChild(linhabaixo);
				ObjetoAprendizagem.areaImagem.y = linhacima.height;
				for (var k:int = 0; k < _imagem.length; k++)
				{
					ObjetoAprendizagem.areaImagem.addChild(this._imagem[k]);
				}
				
				ObjetoAprendizagem.areaImagem.addChild(this._balao);
				this._balao.addEventListener(MouseEvent.MOUSE_DOWN, dragBalaoStart);
				
				this.addChild(this._ok);
				this.addChild(this._cancelar);
				
				trace('usa tween');
				//	linhacima.x = 0;
				//	Tweener.addTween(linhacima, {x: -linhacima.width, time: 1});
				
				this._ok.addEventListener(MouseEvent.CLICK, cliqueOk);
				this._cancelar.addEventListener(MouseEvent.CLICK, cliqueCancelar);
				
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
				stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
				stage.addEventListener(MouseEvent.MOUSE_UP, dragBalaoStop);
				
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				
				stage.addEventListener(Event.RESIZE, desenho);
				
			}
		}
		
		override public function escondendo(evento:Event):void
		{
			super.escondendo(evento);
			this.addChild(linhabaixo);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomBalao);
			stage.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotacaoBalao);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragBalaoStop);
			stage.removeEventListener(Event.RESIZE, desenho);
			
			this._ok.removeEventListener(MouseEvent.CLICK, cliqueOk);
			this._cancelar.removeEventListener(MouseEvent.CLICK, cliqueCancelar);
			
			this._balao.removeEventListener(MouseEvent.MOUSE_DOWN, dragBalaoStart);
			
		}
		
		override public function recebeDados(dados:Object):void
		{
			if (dados != null)
			{
				if (dados.balao != null)
				{
					
					this._balao = dados.balao as Balao;
					this.balaOrig.copyAllProp(_balao);
					
				}
				if (dados.imagem != null)
				{
					this._imagem = dados.imagem as Vector.<Imagem>;
					
				}
			}
		
		}
		
		private function cliqueCancelar(evento:MouseEvent):void
		{
			_balao.copyAllProp(balaOrig);
		
			this.mudaTela('fotorecuperada', null);
		
		}
		
		private function cliqueOk(evento:MouseEvent):void
		{
			dados.imagem = _imagem;			
			this.mudaTela('fotorecuperada', dados);
		
		}
		
		private function dragBalaoStart(evento:MouseEvent):void
		{
			/*var indice:int;
			
			   for (var i:int = 0; i < _balao.length; i++)
			   {
			   if (_balao[i] == evento.target as Balao)
			   {
			   trace("o balao clicado é: ", indice = i);
			   }
			   }*/
			this._balao.startDrag();
		
		}
		
		private function dragBalaoStop(evento:MouseEvent):void
		{
			this._balao.stopDrag();
		/*
		   for (var i:int = 0; i < _balao.length; i++)
		   {
		   this._balao[i].stopDrag();
		
		   }*/
		}
		
		private function zoomBalao(evento:TransformGestureEvent):void
		{
			_balao.scaleX *= evento.scaleX;
			_balao.scaleY = _balao.scaleX;
		/*
		   var indice:int;
		   for (var i:int = 0; i < _balao.length; i++)
		   {
		   if (_balao[i] == evento.target as Balao)
		   {
		   trace("o balao scalonado é: ", indice = i);
		   }
		   }
		   _balao[indice].scaleX *= evento.scaleX;
		   _balao[indice].scaleY = _balao[indice].scaleX;
		 */
		}
		
		private function rotacaoBalao(evento:TransformGestureEvent):void
		{
			var indice:int;
			/*for (var i:int = 0; i < _balao.length; i++)
			{
				if (_balao[i] == evento.target as Balao)
				{
					trace("o balao rotacionado é: ", indice = i);
				}
			}*/
			_balao.rotation += evento.rotation;
		
		}
	
	}

}