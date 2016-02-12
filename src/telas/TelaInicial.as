package telas 
{
	import componentes.BotaoIcone;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.media.CameraRoll;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import recursos.Graficos;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author colaboa
	 */
	public class TelaInicial extends Tela 
	{
		
		// botões
		private var _galeria:BotaoIcone;
		private var _camera:BotaoIcone;
		private var _carregar:BotaoIcone;
		
		// imagem
		private var _imgsHelp:Vector.<Class>;
		private var _imgAtual:int;
		private var _help:Bitmap;
		private var _imagem:Loader;
		
		// galeria
		private var _roll:CameraRoll;
		private var _file:File;
		
		public function TelaInicial(funcMudaTela:Function) 
		{
			super(funcMudaTela);
			
			this._galeria = new BotaoIcone(Graficos.ImgGaleria);
			this.addChild(this._galeria);
			
			this._imgsHelp = new Vector.<Class>();
			this._imgsHelp.push(Graficos.ImgHelp01);
			this._imgsHelp.push(Graficos.ImgHelp02);
			this._imgsHelp.push(Graficos.ImgHelp03);
			this._imgAtual = 0;
			this._help = new this._imgsHelp[this._imgAtual]() as Bitmap;
			this.addChild(this._help);
			
			// criar outros botões
			
			// criando acesso à galeria
			this._roll = new CameraRoll();
			this._file = File.documentsDirectory;
			this._imagem = new Loader();
		}
		
		private function cliqueGaleria(evento:MouseEvent):void {
			this._roll.addEventListener(Event.CANCEL, cameracancel);
			this._roll.addEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.addEventListener(ErrorEvent.ERROR, cameraerro);
			this._roll.browseForImage();
		}
		
		private function cameracancel(evento:Event):void {
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
		}
		
		private function cameraerro(evento:ErrorEvent):void {
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._file.addEventListener(Event.SELECT, arquivoSelecionado);
			this._file.browseForOpen('Escolha uma imagem', [new FileFilter('arquivo de imagem', '*.jpg;*.png')]);
		}
		
		private function cameracomplete(evento:MediaEvent):void {
			this._roll.removeEventListener(Event.CANCEL, cameracancel);
			this._roll.removeEventListener(MediaEvent.SELECT, cameracomplete);
			this._roll.removeEventListener(ErrorEvent.ERROR, cameraerro);
			
			this._imagem.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
            this._imagem.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			this._imagem.loadFilePromise(evento.data);
		}
		
		private function arquivoSelecionado(evento:Event):void {
			this._file.removeEventListener(Event.SELECT, arquivoSelecionado);
			
			this._imagem.contentLoaderInfo.addEventListener(Event.COMPLETE, imagemCarregada);
            this._imagem.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			this._imagem.load(new URLRequest(this._file.url));
		}
		
		private function imagemErro(evento:IOErrorEvent):void {
			this._imagem.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
            this._imagem.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			// tratar erro
		}
		
		private function imagemCarregada(evento:Event):void {
			this._imagem.contentLoaderInfo.removeEventListener(Event.COMPLETE, imagemCarregada);
            this._imagem.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imagemErro);
			
			// mudar tela
			var dados:Object = new Object();
			dados.imagem = this._imagem;
			this.mudaTela('fotorecuperada', dados);
			
		}
		
		override public function desenho(evento:Event = null):void 
		{
			super.desenho(evento);
			
			// POSICIONAR BOTOES
			
			this._galeria.width = stage.stageWidth / 5;
			this._galeria.scaleY = this._galeria.scaleX;
			this._galeria.x = 0;
			this._galeria.y = 0;
			
			this._camera.scaleX = this._camera.scaleY = this._galeria.scaleX;
			// posicionar camera
			
			this._carregar.scaleX = this._carregar.scaleY = this._galeria.scaleX;
			// posicionar carrgar
			
			// pocisionar e dimensionar help aqui
			
			
			// ADICIONAR CLIQUES NOS BOTOES
			if (!this._galeria.hasEventListener(MouseEvent.CLICK)) {
				this._galeria.addEventListener(MouseEvent.CLICK, cliqueGaleria);
				this._camera.addEventListener(MouseEvent.CLICK, cliqueCamera);
				this._carregar.addEventListener(MouseEvent.CLICK, cliqueCarregar);
				
				// TROCA DO HELP
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipeTela);
			}
		}
		
		override public function escondendo(evento:Event):void 
		{
			super.escondendo(evento);
			this._galeria.removeEventListener(MouseEvent.CLICK, cliqueGaleria);
			this._camera.removeEventListener(MouseEvent.CLICK, cliqueCamera);
			this._carregar.removeEventListener(MouseEvent.CLICK, cliqueCarregar);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, swipeTela);
		}
		
		private function cliqueGaleria(evento:MouseEvent):void {
			
		}
		
		private function cliqueCamera(evento:MouseEvent):void {
			
		}
		
		private function cliqueCarregar(evento:MouseEvent):void {
			
		}
		
		private function swipeTela(evento:TransformGestureEvent):void {
			// conferir evento.offsetX para saber se foi swipe direita ou esquerda
			if (evento.offsetX < 0) {
				this._imgAtual++;
				if (this._imgAtual >= this._imgsHelp.length) this._imgAtual = 0;
			} else {
				this._imgAtual--;
				if (this._imgAtual < 0) this._imgAtual = this._imgsHelp.length - 1;
			}
			this.removeChild(this._help);
			this._help.bitmapData.dispose();
			this._help = null;
				
			this._help = new this._imgsHelp[this._imgAtual]() as Bitmap;
			addChild(this._help);
			this.desenho();
		}
		
	}

}