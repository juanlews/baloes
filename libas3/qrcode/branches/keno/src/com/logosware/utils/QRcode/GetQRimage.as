/**************************************************************************
* LOGOSWARE Class Library.
*
* Copyright 2009 (c) LOGOSWARE (http://www.logosware.com) All rights reserved.
*
*
* This program is free software; you can redistribute it and/or modify it under
* the terms of the GNU General Public License as published by the Free Software
* Foundation; either version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this program; if not, write to the Free Software Foundation, Inc., 59 Temple
* Place, Suite 330, Boston, MA 02111-1307 USA
*
**************************************************************************/ 
package com.logosware.utils.QRcode
{
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.LabelingClass;
	
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.*;
	import flash.utils.ByteArray;

	/**
	 * 主にカメラ画像からQRコードを切り出すためのクラスです.
	 * 画像上にあるVersion 1～10のQRコードを0,1からなる2次元配列に整形して返します
	 * @author Kenichi UENO
	 **/
	public class GetQRimage extends EventDispatcher
	{
		private var _wid:uint = 320;
		private var _hgt:uint = 240;
		private var _minVersion:uint = 1; // サポートする最低バージョン
		private var _maxVersion:uint = 10; // サポートする最高バージョン
		
		private var _imageSource:DisplayObject = new Sprite();
		private var _resultImage:BitmapData = new BitmapData(1, 1);
		private var _resultArray:Array = [];
		private var _results:Array = [
			_resultImage,
			_resultArray
		];
		private const _origin:Point = new Point(0, 0);
		private var detecter:QRCodeDetecter;

		/**
		 * コンストラクタ.
		 * @param tempMC QRコード描画元のSpriteインスタンス
		 **/
		public function GetQRimage(source:DisplayObject)
		{
			_imageSource = source;
			detecter = new QRCodeDetecter(_imageSource);
// debug code
/*
			bmp = new Bitmap();
			source.parent.addChild( bmp );
			bmp.x = source.width;
*/
		}
// debug code
//		private var bmp:Bitmap;

		/**
		 * 読み取りを実行します
		 * @eventType QRreaderEvent.QR_IMAGE_READ_COMPLETE
		 */
		public function process():void {
			var QRCodes:Array = detecter.detect();
			for ( var i:int = 0; i < QRCodes.length; i++ ) {
				var bmpData:BitmapData = QRCodes[i].image;
// debug code
//				bmp.bitmapData = bmpData;
				var colors:Array = QRCodes[i].borderColors;
				// バージョンの取得
				var qrInfo:Object = _getVersion( bmpData, colors[0], colors[1], colors[2] );
				if ( qrInfo.version > 0 ) {
					// グリッドの結果を取得
					_results = _getGrid( bmpData, qrInfo );
					_resultImage = _results[0];
					_resultArray = _results[1];
					
					// グリッド中でもマーカー確認
					var checkBmp:BitmapData = new BitmapData( _resultImage.width, _resultImage.height );
					checkBmp.applyFilter(_resultImage,_resultImage.rect,_origin,new ConvolutionFilter(7, 7, [1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1],33));
					if ( (checkBmp.getPixel(7, 7) == 0) && (checkBmp.getPixel(checkBmp.width - 8, 7) == 0) && (checkBmp.getPixel(7, checkBmp.height - 8) == 0) ) {
						dispatchEvent( new QRreaderEvent( QRreaderEvent.QR_IMAGE_READ_COMPLETE, _resultImage, _resultArray ) );
					} else {
					}
				}
			}
			// process終了
		}
		/**
		 * 近辺の平均の明るさを取得する
		 * @param	x
		 * @param	y
		 * @param	size
		 * @return
		 */
		private function _getAverage( bmpData:BitmapData, x:int, y:int, size:int ):uint {
			x -= 0.5 * size;
			y -= 0.5 * size;
			var ret:int = 0;
			for ( var i:int = 0; i < size; i++ ) {
				for ( var j:int = 0; j < size; j++ ) {
					if ( bmpData.getPixel32(x + i, y + j) != 0xFFFFFFFF ){
						ret++;
					}
				}
			}
			if ( ret < 0.25 * (size * size) ) {
				return 0xFFFFFFFF;
			} else {
				return 0x0;
			}
		}
		/**
		 * QRコードのビット情報を二次元配列化する
		 * @param bmpData 画像
		 * @param qrInfo QRコード情報オブジェクト
		 * @param ビットパターン配列
		 */
		private function _getGrid( bmpData:BitmapData, qrInfo:Object ):Array {
			var __resultBmp:BitmapData = new BitmapData( 8 + qrInfo.version * 4 + 17, 8 + qrInfo.version * 4 + 17 );
			var __resultArray:Array = new Array( qrInfo.version * 4 + 17 );
			var __i:uint;
			var __thisColor:uint;
			var __tlCenter:Object = { x:qrInfo.topLeftRect.topLeft.x + 0.5 * ( qrInfo.topLeftRect.width ), y:qrInfo.topLeftRect.topLeft.y + 0.5 * ( qrInfo.topLeftRect.height ) };
			var __trCenter:Object = { x:qrInfo.topRightRect.topLeft.x + 0.5 * ( qrInfo.topRightRect.width ), y:qrInfo.topRightRect.topLeft.y + 0.5 * ( qrInfo.topRightRect.height ) };
			var __blCenter:Object = { x:qrInfo.bottomLeftRect.topLeft.x + 0.5 * ( qrInfo.bottomLeftRect.width ), y:qrInfo.bottomLeftRect.topLeft.y + 0.5 * ( qrInfo.bottomLeftRect.height ) };
			for( __i = 0; __i < (qrInfo.version*4+17); __i++ ){
				__resultArray[__i] = new Array( qrInfo.version * 4 + 17 );
			}
			__i = 0;
			__thisColor = 0;
			while ( __thisColor != 0xFFFFFF ) {
				__i++;
				__thisColor = bmpData.getPixel( qrInfo.topRightRect.topLeft.x + __i, qrInfo.bottomLeftRect.topLeft.y + __i );
			}
			bmpData.floodFill( qrInfo.topRightRect.topLeft.x + __i, qrInfo.bottomLeftRect.topLeft.y + __i, 0xFFCCFFFF );
			
			var __bottomRightRect:Rectangle = bmpData.getColorBoundsRect( 0xFFFFFFFF, 0xFFCCFFFF );
			bmpData.floodFill( qrInfo.topRightRect.topLeft.x + __i, qrInfo.bottomLeftRect.topLeft.y + __i, 0xFFFFFFFF );
			var __brCenter:Object = { x:__bottomRightRect.topLeft.x + 0.5 * ( __bottomRightRect.width ), y:__bottomRightRect.topLeft.y + 0.5 * ( __bottomRightRect.height ) };
			
			if( qrInfo.version == 1 ){
				__brCenter.x = __blCenter.x + (__trCenter.x - __tlCenter.x) * 11.0 / 14.0;
				__brCenter.y = __trCenter.y + (__blCenter.y - __tlCenter.y) * 11.0 / 14.0;
			}
			
			var __tempNum1:Number = ( qrInfo.version * 4.0 + 17 - 10 ); //QRコード上の、左上マーカー中心から右「下」マーカー中心までのｘ座標の差 (ver5なら27)
			var __tempNum2:Number = ( qrInfo.version * 4.0 + 17 - 7 ); //QRコード上の、左上マーカー中心から右「上」マーカー中心までのｘ座標の差 (ver5なら30)
			
			var __blTop:Object = { x: qrInfo.bottomLeftRect.topLeft.x + qrInfo.bottomLeftRect.width*0.5, y: qrInfo.bottomLeftRect.topLeft.y + qrInfo.bottomLeftRect.height/14.0 };
			var __trLeft:Object = { x: qrInfo.topRightRect.topLeft.x + qrInfo.topRightRect.width / 14.0, y: qrInfo.topRightRect.topLeft.y + qrInfo.topRightRect.height * 0.5 };
			
			var __sum:Number = 0.0;
			var __num:Number = 0.0;
			
			for ( __i = __blTop.y - qrInfo.cellSize; __i <= __blTop.y + qrInfo.cellSize; __i++ ) {
				if ( bmpData.getPixel( __blTop.x, __i ) != 0xFFFFFF ) {
					__sum += __i;
					__num++;
				}
			}
			__blTop.y = 0.5 * (__blTop.y + __sum / __num);
			
			var __a3:Number = ( __tlCenter.y - __trLeft.y) / ( __tlCenter.x - __trLeft.x);
			var __a30:Number = ( __blTop.y - __brCenter.y) / ( __blTop.x - __brCenter.x);
			var __b3:Number = __trLeft.y - __a3 * __trLeft.x;
			var __b30:Number = __brCenter.y - __a30 * __brCenter.x;
			var __startX3:Number = __tlCenter.x + ( __trLeft.x - __tlCenter.x ) * ( -3.0 / __tempNum1 );
			var __startX30:Number = __blTop.x + ( __brCenter.x - __blTop.x ) * ( -3.0 / __tempNum1 );
			var __startY3:Number = __tlCenter.y + ( __trLeft.y - __tlCenter.y ) * ( -3.0 / __tempNum1 );
			var __startY30:Number = __blTop.y + ( __brCenter.y - __blTop.y ) * ( -3.0 / __tempNum1 );
			var __end3:Number = __trLeft.x + ( __trLeft.x - __tlCenter.x ) * ( 6.0 / __tempNum1 );
			var __end30:Number = __brCenter.x + ( __brCenter.x - __blTop.x ) * ( 6.0 / __tempNum1 );
			var __loopConst:uint = (__resultBmp.width - 8 );
			var __loopConst2:uint = __loopConst - 1;
			var __a:Array = new Array( __loopConst );
			var __b:Array = new Array( __loopConst );
			var __startX:Array = new Array( __loopConst );
			var __startY:Array = new Array( __loopConst );
			var __endX:Array = new Array( __loopConst );
			
			for ( __i = 0; __i < __loopConst; __i++ ) {
				__a[__i] =  (( __a30 - __a3 ) / __tempNum1) * ( __i - 3 ) + __a3;
				__startX[__i] = (( __startX30 - __startX3 ) / __tempNum1) * ( __i - 3 ) + __startX3;
				__startY[__i] = (( __startY30 - __startY3 ) / __tempNum1) * ( __i - 3 ) + __startY3;
				__endX[__i] = (( __end30 - __end3 ) / __tempNum1) * ( __i - 3 ) + __end3;
				__b[__i] =  __startY[__i] - __a[__i] * __startX[__i];
			}
			for ( var __y:Number = 0; __y < __loopConst; __y++ ) {
				var __y2:Number = __y - 3;
				for ( var __x:Number = 0; __x < __loopConst; __x++ ) {
					var __x2:Number = __x - 3;
//					if ( (bmpData.getPixel( __startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 ), __a[__y] * (__startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 )) + __b[__y] ) & 0xFF0000) < 0xFF0000) {
					if ( (_getAverage(bmpData, __startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 ), __a[__y] * (__startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 )) + __b[__y],qrInfo.cellSize )) != 0xFFFFFFFF) {
//						bmpData.setPixel32( __startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 ), __a[__y] * (__startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 )) + __b[__y] , 0xFF0000FF);
						__resultBmp.setPixel( 4 + __x, 4 + __y, 0 );
						__resultArray[__y][__x] = 1;
					}
				}
			}
			return [__resultBmp, __resultArray];
		}
		/**
		 * QRコードのバージョンを判別する
		 * @param bmp 画像
		 * @param QRコード情報オブジェクト
		 */
		private function _getVersion( bmp:BitmapData, tlColor:uint, trColor:uint, blColor:uint ):Object {
			var i:uint;
			var thisColor:uint;
			bmp.lock();
			var topLeftRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, tlColor );
			var topRightRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, trColor );
			var bottomLeftRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, blColor );
			var averageModuleSize:int = (1 / 7) * (1 / 6) * (topLeftRect.width + topLeftRect.height + topRightRect.width + topRightRect.height + bottomLeftRect.width + bottomLeftRect.height);
			var startTopLeft:Point = new Point( 26, topLeftRect.topLeft.y + topLeftRect.height );
			var numX:uint = 0;
			var tempX:uint;
			var oldP:uint;
			var whiteNum:uint = 0;
			
			for ( var j:int = -averageModuleSize; j <= 0; j++ ){
				var whiteArray:Array = [];
				var startColor:uint = _getAverage(bmp,startTopLeft.x, startTopLeft.y + j,averageModuleSize);
				var endColor:uint = _getAverage(bmp,startTopLeft.x + bmp.width-52 , startTopLeft.y + j,averageModuleSize);
				if ( ( startColor != 0xFFFFFFFF ) && ( endColor != 0xFFFFFFFF ) ) {
					oldP = startColor;
					for ( i = 1; i < (bmp.width - 52); i++ ) {
//						if( j & 1 )
//						bmp.setPixel32(startTopLeft.x + i, startTopLeft.y + j, _getAverage(bmp,startTopLeft.x + i, startTopLeft.y + j,averageModuleSize));
						var tempColor:uint = _getAverage(bmp,startTopLeft.x + i, startTopLeft.y + j,averageModuleSize);
						if ( tempColor != oldP ) {
							oldP = tempColor;
						}
						if ( tempColor == 0xFFFFFFFF ) {
							whiteNum++;
						} else {
							if ( whiteNum > 0 ) {
								whiteArray.push( [whiteNum] );
								whiteNum = 0;
							}
						}
					}
					var sum:Number = 0;
					// 妥当性のチェック　白いマスが全部同じくらいのサイズだったらOK
					for ( var k:uint = 0; k < whiteArray.length; k++ ) {
						sum += Number( whiteArray[k] );
					}
					var average:Number = sum / whiteArray.length;
					var error:uint = 0;
					for ( k = 0; k < whiteArray.length; k++ ) {
						if ( ! ((whiteArray[k] > (average * 0.5)) && (whiteArray[k] < (average * 1.5)) ) ) {
							error++;
						}
					}
					if ( error == 0 ) {
						//numX = tempX;
						numX = Math.max(numX, whiteArray.length * 0.5 - 1);
					}
				}
				//numX = Math.floor( ( ( numX - 3 ) - 6  ) * 0.25 ) + 1;
			}
			
			startTopLeft = new Point( topLeftRect.topLeft.x + topLeftRect.width, 26 );
			var numY:uint = 0;
			whiteNum = 0;

			for ( j = -averageModuleSize; j <= 0; j++ ){
				whiteArray = [];
				startColor = _getAverage(bmp,startTopLeft.x + j, startTopLeft.y,averageModuleSize);
				endColor = _getAverage(bmp,startTopLeft.x + j , startTopLeft.y + bmp.height-52,averageModuleSize);
				if ( ( startColor != 0xFFFFFFFF ) && ( endColor != 0xFFFFFFFF ) ) {
					oldP = startColor;
					for ( i = 1; i < (bmp.height - 52); i++ ) {
//						if( j & 1 )
//						bmp.setPixel32(startTopLeft.x + j, startTopLeft.y + i, _getAverage(bmp,startTopLeft.x + j, startTopLeft.y + i,averageModuleSize));
						tempColor = _getAverage(bmp,startTopLeft.x + j, startTopLeft.y + i,averageModuleSize);
						if ( tempColor != oldP ) {
							oldP = tempColor;
						}
						if ( tempColor == 0xFFFFFFFF ) {
							whiteNum++;
						} else {
							if ( whiteNum > 0 ) {
								whiteArray.push( [whiteNum] );
								whiteNum = 0;
							}
						}
					}
					sum = 0;
					// 妥当性のチェック　白いマスが全部同じくらいのサイズだったらOK
					for ( k = 0; k < whiteArray.length; k++ ) {
						sum += Number( whiteArray[k] );
					}
					average = sum / whiteArray.length;
					error = 0;
					for ( k = 0; k < whiteArray.length; k++ ) {
						if ( ! ((whiteArray[k] > (average * 0.5)) && (whiteArray[k] < (average * 1.5)) ) ) {
							error++;
						}
					}
					if ( error == 0) {
	//					numY = tempX;
						numY = Math.max( numY, whiteArray.length * 0.5 - 1 );
					}
				}
				//numY = Math.floor( ( ( numY - 3 ) - 6  ) * 0.25 ) + 1;
			}
			if ( (numX == numY) && (numX >= _minVersion) && (numX <= _maxVersion ) ) {
//				trace("numX");
			} else {
				numX = 0;
			}
			bmp.unlock();
			return {cellSize:(topRightRect.x + topRightRect.width - topLeftRect.x) / (numX * 4 + 17), version:numX, topLeftRect: topLeftRect, topRightRect:topRightRect, bottomLeftRect: bottomLeftRect};
		}
	}	
}
import flash.geom.Point;

