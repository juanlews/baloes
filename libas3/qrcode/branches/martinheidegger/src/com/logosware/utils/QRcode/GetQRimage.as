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
		private var _bmp_data : BitmapData;
		private var _resultImage:BitmapData = new BitmapData(1, 1);
		private var _resultArray:Array = [];
		private var _results:Array = [
			new BitmapData(1,1),
			new Array(1)
		];
		private var test:Number = 1.125;
		private var defD:int = 100; // 枠の角から縦横合計何pxはなれたところまでの範囲で探すか
		private const _origin:Point = new Point(0, 0);

		/**
		 * コンストラクタ.
		 * @param tempMC QRコード描画元のSpriteインスタンス
		 **/
		public function GetQRimage(source:DisplayObject)
		{
			_imageSource = source;
			_wid = _imageSource.width;
			_hgt = _imageSource.height;
			_bmp_data = new BitmapData( _wid , _hgt , true , 0xFFFFFFFF);
		}

		/**
		 * 読み取りを実行します
		 * @eventType QRreaderEvent.QR_IMAGE_READ_COMPLETE
		 */
		public function process():void {
			var rect : Rectangle = new Rectangle(0, 0, _wid, _hgt);
			var rect2 : Rectangle = new Rectangle(_wid*0.5 - _hgt*0.5, 0, _hgt, _hgt);
			var bmp_test:BitmapData = new BitmapData( _hgt, _hgt );
			var bmp_test2:BitmapData;
			var tempRect:Rectangle;
			var topLeftObj:MarkerObject;
			var topRightObj:MarkerObject;
			var bottomLeftObj:MarkerObject;
			var threshold:uint;
			var pickedRects:Array;// ラベリングした矩形を保存
			var pickedColor:Array;// ラベリングした色を保存
			var borders:Array = new Array();// 外側の色と範囲を入れる
			var i:int;
			var j:int;

			// 画像を取得
			_bmp_data.draw(_imageSource);
			// 画像の明るさを（てきとーに）調べ、中間値を取得
			threshold = _getThreshold( _bmp_data );
			
			// 画像のグレースケール化
			_toGray( _bmp_data, bmp_test, rect2, _origin, test );
			// 画像のニ値化
			_binalization(bmp_test, threshold);
			// ここまでで二値化済み
			var LabelingObj:LabelingClass = new LabelingClass(); 
			LabelingObj.Labeling( bmp_test, 10, 0xFF88FFFE, true ); // ラベリング実行
			
			pickedRects = LabelingObj.getRects();
			pickedColor = LabelingObj.getColors();
			
			LabelingObj = null;

			//マーカー候補の矩形を取得
			borders = _searchBorders( bmp_test, pickedRects, pickedColor );
			
			if ( borders.length >= 3 ) { // マーカー候補の矩形の数。画像を4分割したうちの3箇所に存在するときだけnull以外の配列が帰ってくる
				var markers:Array = _checkMarkers( bmp_test, borders );
			}
			// マーカーがちゃんと見つかった
			if ( markers ) {
				topLeftObj = markers[0];
				topRightObj = markers[1];
				bottomLeftObj = markers[2];
				
				var tempPoint1:Point = topRightObj.center.subtract( topLeftObj.center );
				var tempPoint2:Point = bottomLeftObj.center.subtract( topLeftObj.center );
				
				// カメラが垂直に近い
				if ( _checkAngle(tempPoint1, tempPoint2) ) {
					var theta:Number = -Math.atan2( tempPoint1.y, tempPoint1.x ); // 平面状の回転角
					
					// 画像をまっすぐにする
					var matrix2:Matrix = new Matrix();
					var tempD:Number = (topLeftObj.center.x - topLeftObj.topleft.x) / Math.cos( Math.PI * 0.25 - Math.abs(theta) ) / Math.SQRT2; // マーカーの一辺の長さの半分
					
					matrix2.translate( -topLeftObj.center.x, -topLeftObj.center.y );
					matrix2.rotate( theta );
					matrix2.translate( 10 + tempD, 10 + tempD );
					
					var len:Number = ((topRightObj.center.x + topLeftObj.center.x) - 2 * topLeftObj.topleft.x); // QRコードの一辺の長さ
					bmp_test2 = new BitmapData( len + 20, len + 20 );
					bmp_test2.draw( bmp_test, matrix2 );
					
					// バージョンの取得
					var qrInfo:Object = _getVersion( bmp_test2 );
					if ( qrInfo.version > 0 ) {
						// グリッドの結果を取得
						_results = _getGrid( bmp_test2, qrInfo );
						_resultImage = _results[0];
						_resultArray = _results[1];
						
						// グリッド中でもマーカー確認
						var checkBmp:BitmapData = new BitmapData( _resultImage.width, _resultImage.height );
						checkBmp.applyFilter(_resultImage,_resultImage.rect,_origin,new ConvolutionFilter(7, 7, [1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1],33));
						if( (checkBmp.getPixel(7, 7) == 0) && (checkBmp.getPixel(checkBmp.width-8, 7) == 0) && (checkBmp.getPixel(7, checkBmp.height-8) == 0) ){
							dispatchEvent( new QRreaderEvent( QRreaderEvent.QR_IMAGE_READ_COMPLETE, _resultImage, _resultArray ) );
						} else {
							_results = [
								new BitmapData(1,1),
								new Array(1)
							]
						}
					}
				}
			}
			// process終了
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
					if ( (bmpData.getPixel( __startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 ), __a[__y] * (__startX[__y] + ( __endX[__y] - __startX[__y] ) * ( __x / __loopConst2 )) + __b[__y] ) & 0xFF0000) < 0xFF0000) {
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
		private function _getVersion( bmp:BitmapData ):Object {
			var i:uint;
			var thisColor:uint;

			bmp.lock();
			i = 10;
			thisColor = 0xFFFFFF;
			while ( thisColor == 0xFFFFFF ) {
				i++;
				thisColor = bmp.getPixel( i, i );
			}
			var topLeftRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, 0xFF000000 + thisColor );
			i = 10;
			thisColor = 0xFFFFFF;
			while ( thisColor == 0xFFFFFF ) {
				i++;
				thisColor = bmp.getPixel( bmp.width - i, i );
			}
			var topRightRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, 0xFF000000 + thisColor );
			i = 10;
			thisColor = 0xFFFFFF;
			while ( thisColor == 0xFFFFFF ) {
				i++;
				thisColor = bmp.getPixel( i, bmp.height - i );
			}
			var bottomLeftRect:Rectangle = bmp.getColorBoundsRect( 0xFFFFFFFF, 0xFF000000 + thisColor );
			var startTopLeft:Point = new Point( 13, topLeftRect.topLeft.y + topLeftRect.height );
			var numX:uint = 0;
			var tempX:uint;
			var oldP:uint;
			var whiteNum:uint = 0;
			for ( var j:int = -5; j <= 0; j++ ) {
				tempX = 0;
				var whiteArray:Array = [];
				var tempArray:ByteArray = bmp.getPixels( new Rectangle( startTopLeft.x, startTopLeft.y + j, bmp.width - 26, 1 ) );
				var startColor:uint = tempArray[1];
				var endColor:uint = tempArray[4*(bmp.width-26-1)+1];
				if ( ( startColor != 0xFF ) && ( endColor != 0xFF ) ) {
					oldP = startColor;
					for ( i = 1; i < (bmp.width - 24); i++ ) {
						var tempColor:uint = tempArray[4*i+1];
						if ( tempColor != oldP ) {
							tempX ++;
							oldP = tempColor;
						}
						if ( tempColor == 0xFF ) {
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
					if ( (numX < tempX) && (error == 0) ) {
						numX = tempX;
					}
				}
			}
			numX = Math.floor( ( ( numX - 3 ) - 6  ) * 0.25 ) + 1;
			
			startTopLeft = new Point( topLeftRect.topLeft.x + topLeftRect.width, 13 );
			var numY:uint = 0;
			whiteNum = 0;
			for ( j = -5; j <= 0; j++ ) {
				tempX = 0;
				whiteArray = [];
				tempArray = bmp.getPixels( new Rectangle( startTopLeft.x + j, startTopLeft.y, 1, bmp.height - 26 ) );
				startColor = tempArray[1];
				endColor = tempArray[4*(bmp.height-26-1)+1];
				if ( ( startColor != 0xFF ) && ( endColor != 0xFF ) ) {
					oldP = startColor;
					for ( i = 1; i < (bmp.height - 24); i++ ) {
						tempColor = tempArray[4*i+1];
						if ( tempColor != oldP ) {
							tempX ++;
							oldP = tempColor;
						}
						if ( tempColor == 0xFF ) {
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
					if ( (numY < tempX) && (error == 0) ) {
						numY = tempX;
					}
				}
			}
			numY = Math.floor( ( ( numY - 3 ) - 6  ) * 0.25 ) + 1;

			if ( (numX == numY) && (numX >= _minVersion) && (numX <= _maxVersion ) ) {
//				trace("numX");
			} else {
				numX = 0;
			}
			bmp.unlock();
			return {cellSize:(topRightRect.x + topRightRect.width - topLeftRect.x) / (numX * 4 + 17), version:numX, topLeftRect: topLeftRect, topRightRect:topRightRect, bottomLeftRect: bottomLeftRect};
		}
		/**
		 * 画像中央付近の明るさを使って白と黒の閾値を計算する
		 * @param bmp 画像
		 * @param 閾値
		 */
		private function _getThreshold( bmp:BitmapData ):uint {
			var rect:Rectangle = new Rectangle( bmp.width * 0.5, 0, 1, bmp.height );
			var bmp_check:BitmapData = new BitmapData( 1, bmp.height );
			bmp_check.copyPixels(bmp, rect, new Point(0, 0));
			bmp_check.lock();
			var tempArray:ByteArray = bmp_check.getPixels( bmp_check.rect );
			var sum:Number = 0.0;
			for ( var i:uint = 0; i < bmp.height; i++ ) {
				sum += tempArray[4*i+3]; // 緑成分で判定
			}
			sum /= bmp.height;
			
			return uint(0xFF000000 + 0x00010101 * Math.round(sum));
		}
		/**
		 * 画像をグレースケール化する
		 * @param bmp_src 元の画像
		 * @param bmp_dst 結果格納先の画像
		 * @param rect 適用範囲指定
		 * @param point 適用原点指定
		 * @param constnum 明るさ補正
		 **/
		private function _toGray( bmp_src:BitmapData, bmp_dst:BitmapData, rect:Rectangle, point:Point, constnum:Number = 2.5 ):void {
			var conGray:Array = [constnum*0.3, constnum*0.59, constnum*0.11];
			var cmfGray:ColorMatrixFilter = new ColorMatrixFilter(
				[conGray[0], conGray[1], conGray[2], 0, 0,
				conGray[0], conGray[1], conGray[2], 0, 0,
				conGray[0], conGray[1],conGray[2], 0, 0,
				0, 0, 0, 0, 255] 
			);
			bmp_dst.applyFilter( bmp_src, rect, point, cmfGray );
		}
		/**
		 * 画像を２値化する
		 * @param bmp 2値化する画像
		 * @param threshold 閾値
		 **/
		private function _binalization( bmp:BitmapData, threshold:uint = 0xFFFFFFFF ):void {
			bmp.threshold(bmp, bmp.rect, new Point(0, 0), "<", threshold, 0xFF000000, 0xFFFFFFFF );
			bmp.threshold(bmp, bmp.rect, new Point(0, 0), ">=", threshold, 0xFFFFFFFF, 0xFFFFFFFF );
		}
		/**
		 * 境界上の点をピックアップする
		 * @param bmp 元画像
		 * @param rect 対象画像位置
		 * @param color 対象色
		 * @param devide 分割個数
		 * @param 点情報
		 **/
		private function _getBorderPoints(bmp:BitmapData, rect:Rectangle, color:uint, divide:uint):Array {
			var tempX:uint;
			var tempY:uint;
			var tempBmpX:BitmapData = new BitmapData( rect.width, 1);
			var tempBmpY:BitmapData = new BitmapData( 1, rect.height );
			var tempRect2:Rectangle;
			var tempPoint:Point;
			var loopCount:uint = divide;
			var borderPoints:Array = new Array();
			for (var j:uint = 0; j <= loopCount; j++ ) {
				tempX = ( (rect.width-1) * j ) / loopCount + rect.topLeft.x;
				tempY = ( (rect.height-1) * j ) / loopCount + rect.topLeft.y;
				tempBmpX.copyPixels( bmp, new Rectangle(rect.topLeft.x, tempY, rect.width, 1), new Point(0,0) );
				tempBmpY.copyPixels( bmp, new Rectangle(tempX, rect.topLeft.y, 1, rect.height), new Point(0,0) );
				// 横線スキャン
				tempRect2 = tempBmpY.getColorBoundsRect( 0xFFFFFFFF, color );
				tempPoint = new Point(
					tempX + tempRect2.topLeft.x,
					rect.topLeft.y + tempRect2.topLeft.y
				);
				borderPoints.push( tempPoint );
				tempPoint = new Point(
					tempX + tempRect2.topLeft.x + tempRect2.width,
					rect.topLeft.y + tempRect2.topLeft.y + tempRect2.height );
				borderPoints.push( tempPoint );
				// 縦線スキャン
				tempRect2 = tempBmpX.getColorBoundsRect( 0xFFFFFFFF, color );
				tempPoint = new Point(
					rect.topLeft.x + tempRect2.topLeft.x,
					tempY + tempRect2.topLeft.y
				);
				borderPoints.push( tempPoint );
				tempPoint = new Point(
					rect.topLeft.x + tempRect2.topLeft.x + tempRect2.width,
					tempY + tempRect2.topLeft.y + tempRect2.height
				);
				borderPoints.push( tempPoint );
			}
			return borderPoints;
		}
		/**
		 * マーカーの候補をピックアップする
		 * @param	bmp ラベリング済みの画像
		 * @param	rectArray 矩形情報
		 * @param	colorArray 矩形の色情報
		 * @return 候補の配列
		 */
		private function _searchBorders(bmp:BitmapData, rectArray:Array, colorArray:Array):Array {
			var retArray:Array = [];
			for ( var i:int = 0; i < rectArray.length; i++ ) {
				var count:int = 0;
				var target:Number = 0;
				var tempRect:Rectangle = rectArray[i];// 外側
				if( colorArray[i] != bmp.getPixel( rectArray[i].topLeft.x + rectArray[i].width*0.5, rectArray[i].topLeft.y + rectArray[i].height*0.5) ){
//						var tempStr:String = "";
					var oldFlg:uint = 0;
					var tempFlg:uint = 0;
					var index:int = -1;
					var countArray:Array = [0.0, 0.0, 0.0, 0.0, 0.0];
					var j:int;
					var constNum:Number;

					// 横方向
					constNum = rectArray[i].topLeft.y + rectArray[i].height*0.5;
					for ( j = 0; j < rectArray[i].width; j++ ){
						tempFlg = (bmp.getPixel( rectArray[i].topLeft.x + j, constNum ) == 0xFFFFFF)?0:1;
						if( (index == -1) && (tempFlg == 0) ){
							//go next
						} else {
							if( tempFlg != oldFlg ){
								index++;
								oldFlg = tempFlg;
								if( index >= 5 ){
									break;
								}
							} 
							countArray[index]++;
						}
					}
//						for ( j = 0; j < rectArray[i].width; j++ ){ // この路線もアリかも
//							tempStr += (bmp.getPixel( rectArray[i].topLeft.x + j, rectArray[i].topLeft.y + rectArray[i].height*0.5 ) == 0xFFFFFF)?"1":"0";
//						}
//						var array:Array = tempStr.match("0*(1+)(0+)(1+)(0+)(1+)0*");

					target = 0.25 * (countArray[0] + countArray[1] + countArray[3] + countArray[4]);
					if ( ( countArray[2] > (target*2.5) ) && ( countArray[2] < (target*3.5) ) ) {
						// 縦方向
						countArray = [0.0, 0.0, 0.0, 0.0, 0.0];
						oldFlg = tempFlg = 0;
						index = -1;

						constNum = rectArray[i].topLeft.x + rectArray[i].width*0.5;
						for ( j = 0; j < rectArray[i].width; j++ ){
							tempFlg = (bmp.getPixel( constNum, rectArray[i].topLeft.y + j ) == 0xFFFFFF)?0:1;
							if( (index == -1) && (tempFlg == 0) ){
								//go next
							} else {
								if( tempFlg != oldFlg ){
									index++;
									oldFlg = tempFlg;
									if( index >= 5 ){
										break;
									}
								} 
								countArray[index]++;
							}
						}
						target = 0.25 * (countArray[0] + countArray[1] + countArray[3] + countArray[4]);
						if ( ( countArray[2] > (target*2.5) ) && ( countArray[2] < (target*3.5) ) ) {
							retArray.push( {borderColor:colorArray[i], borderRect:rectArray[i]} );
						}
					}

				}
			}
			return retArray;
		}
		/**
		 * マーカーを４隅のうち３隅にあるか確認する。ついでに右下以外の３隅にあるように回転しておく
		 * @param	bmp 解析元の画像
		 * @param	borders マーカー候補の情報
		 * @return	マーカー情報の配列
		 */
		private function _checkMarkers( bmp:BitmapData, borders:Array ):Array {
			var retArray:Array = [new MarkerObject(defD), new MarkerObject(defD), new MarkerObject(defD)];
			var flg:int = 0;
			var checkField:Array = [0, 0, 0, 0];
			for( var j:int = 0; j < borders.length; j++ ){ // 
				var i:int = 0;
				if( (borders[j].borderRect.topLeft.x + borders[j].borderRect.width ) < (_wid * 0.5) ){
					i += 2;
				} 
				if( (borders[j].borderRect.topLeft.y + borders[j].borderRect.height ) < (_hgt * 0.5) ){
					i += 1;
				}
				checkField[i] = 1;
			}
			if( (checkField[0] +checkField[1] +checkField[2] +checkField[3]) == 3 ){
				var tempMatrix:Matrix = new Matrix();
				tempMatrix.translate( -_wid*0.5, -_hgt*0.5 );
				switch( 0 ){
					case checkField[0]:
						break;
					case checkField[1]:
							tempMatrix.rotate( Math.PI*0.5 );
						break;
					case checkField[2]:
							tempMatrix.rotate( - Math.PI*0.5 );
						break;
					case checkField[3]:
							tempMatrix.rotate(  Math.PI );
						break;
				}
				tempMatrix.translate( _wid*0.5, _hgt*0.5 );
				var tempBmp:BitmapData = new BitmapData(_wid,_hgt);
				tempBmp.draw( bmp, tempMatrix );
				bmp.copyPixels(tempBmp, tempBmp.rect, new Point(0,0) );
				// ここまででマーカーっぽい部分が右下以外の3箇所にあるようになっていると期待する
				
				borders[0].borderRect = bmp.getColorBoundsRect(0xFFFFFFFF, borders[0].borderColor);
				borders[1].borderRect = bmp.getColorBoundsRect(0xFFFFFFFF, borders[1].borderColor);
				borders[2].borderRect = bmp.getColorBoundsRect(0xFFFFFFFF, borders[2].borderColor);
			}  
			for ( i = 0; i < borders.length; i++ ) {
				var tempRect:Rectangle = borders[i].borderRect; // 外枠
				if ( (tempRect.topLeft.x + tempRect.topLeft.y) < retArray[0].d ) { // 左上から近いところにあるか
					retArray[0].topleft = new Point( tempRect.topLeft.x, tempRect.topLeft.y );
					retArray[0].d = tempRect.topLeft.x + tempRect.topLeft.y;
					retArray[0].center = new Point( tempRect.topLeft.x + 0.5 * tempRect.width, tempRect.topLeft.y + 0.5 * tempRect.height);
					flg = (flg & 6) + 1;
				} else	if ( (_hgt - tempRect.width - tempRect.topLeft.x + tempRect.topLeft.y) < retArray[1].d ) { // 右上から近いところにあるか
					retArray[1].topleft = new Point( tempRect.topLeft.x, tempRect.topLeft.y );
					retArray[1].d = tempRect.topLeft.x + tempRect.width + tempRect.topLeft.y;
					retArray[1].center = new Point( tempRect.topLeft.x + 0.5 * tempRect.width, tempRect.topLeft.y + 0.5 * tempRect.height);
					flg = (flg & 5) + 2;
				} else if ( (tempRect.topLeft.x + _hgt - tempRect.height - tempRect.topLeft.y) < retArray[2].d ) {// 左下から近いところにあるか
					retArray[2].topleft = new Point( tempRect.topLeft.x, tempRect.topLeft.y );
					retArray[2].d = tempRect.topLeft.x + tempRect.topLeft.y + tempRect.width + tempRect.height;
					retArray[2].center = new Point( tempRect.topLeft.x + 0.5 * tempRect.width, tempRect.topLeft.y + 0.5 * tempRect.height);
					flg = (flg & 3) + 4;
				}
			}
			return (flg == 7)?retArray:null;
		}
		/**
		 * マーカーが直角に配置されて、カメラが垂直に向いているかどうかのチェック
		 * @param	p1 左上->右上のベクトル
		 * @param	p2 左上->左下のベクトル
		 * @return 垂直に近ければtrue
		 */
		private function _checkAngle(p1:Point, p2:Point):Boolean {
			// tempNumはベクトルの計算式 |A| |B| cos = A・B のcos 部分
			var tempNum:Number = 0.0;
			tempNum = (p1.x * p2.x + p1.y * p2.y) / ( p1.length * p2.length);
			var tempNum2:Number = p1.length / p2.length;
			
			return ((Math.abs(tempNum) <= 0.125) && (tempNum2 < 1.02) && (tempNum2 > 0.98) );
		}
	}	
}
import flash.geom.Point;

/**
 * マーカー候補の情報をもつ内部クラス
 */
class MarkerObject {
	/**
	 * 領域の左上
	 */
	public var topleft:Point;
	/**
	 * 画像の端からの距離
	 */
	public var d:Number;
	/**
	 * 領域の中央
	 */
	public var center:Point;
	/**
	 * コンストラクタ
	 * @param	defaultD dに代入する値
	 */
	public function MarkerObject(defaultD:Number):void {
		d = defaultD;
	}
	public function toString():String {
		return "[Object MarkerObject, topLeft:"+ topleft+ ", d:"+ d+ ", center:"+ center+ "]";
	}
}