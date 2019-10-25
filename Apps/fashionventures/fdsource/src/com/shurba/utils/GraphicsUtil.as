package com.shurba.utils{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	/**
	 * @author alastair
	 */
	public class GraphicsUtil {
		public static const DESATURATE_MATRIX:Array = [0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0,0,0,1,0];
		public static const DIMMER_MATRIX:Array = [0.6,0,0,0,0,0,0.6,0,0,0,0,0,0.6,0,0,0,0,0,1,0];

		public static function createGradientBox(targetWidth : Number, targetHeight : Number, colors : Array):Shape {
			var box:Shape = new Shape();
			fillGradientBox(box, targetWidth, targetHeight, colors);
			return box;
		}

		public static function fillGradientBox(box:Shape, targetWidth : Number, targetHeight : Number, colors : Array):void {
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];
			var focalPtRatio:Number = 0;
			var matrix:Matrix = new Matrix();

			matrix.createGradientBox(targetWidth, targetHeight, Math.PI/2, 0, 0);

			box.graphics.clear();
			box.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, focalPtRatio);
			box.graphics.drawRect(0, 0, targetWidth, targetHeight);

			box.cacheAsBitmap = true;
		}

		public static function addChildAtCenter(host : DisplayObjectContainer, child : DisplayObject, isChildCentered:Boolean = false):void {
			child.x = (host.width - child.width) / 2;
			child.y = (host.height - child.height) / 2;
			
			if (!isChildCentered) {
				child.x -= child.width / 2;
				child.y -= child.height / 2;
			}
			
			child.x = Math.round(child.x);
			child.y = Math.round(child.y);
			
			host.addChild(child);
		}
	}
}