package org.flixel;

import nme.display.BitmapData;
import nme.display.BitmapInt32;
import org.flixel.system.BGSprite;
import org.flixel.system.layer.Atlas;
import org.flixel.system.layer.DrawStackItem;
import org.flixel.system.layer.TileSheetData;

/**
 * This is the basic game "state" object - e.g. in a simple game
 * you might have a menu state and a play state.
 * It is for all intents and purpose a fancy FlxGroup.
 * And really, it's not even that fancy.
 */
class FlxSubState extends FlxState
{
	public var _parentState:FlxState;
	
	public var closeCallback:Void->Void;
	
	#if !flash
	private var _bgSprite:BGSprite;
	#end
	
	private var _initialized:Bool = false;
	
	public var initialized(get_initialized, null):Bool;
	
	private function get_initialized():Bool { return _initialized; }
	/**
	 * Internal method. Don't use it!!!
	 */
	public function initialize():Void { _initialized = true; }
	
	#if flash
	public function new(bgColor:UInt = 0x00000000, useMouse:Bool = false) 
	#elseif neko
	public function new(bgColor:BitmapInt32 = null, useMouse:Bool = false) 
	#else
	public function new(bgColor:Int = 0x00000000, useMouse:Bool = false) 
	#end
	{
		#if neko
		if (bgColor == null) bgColor = FlxG.TRANSPARENT;
		#end
		super(bgColor, useMouse);
		closeCallback = null;
		
		#if !flash
		_bgSprite = new BGSprite();
		this.bgColor = bgColor;
		#end
	}
	
	#if flash
	override private function get_bgColor():UInt 
	#else
	override private function get_bgColor():BitmapInt32 
	#end
	{
		return _bgColor;
	}
	
	#if flash
	override private function set_bgColor(value:UInt):UInt 
	#else
	override private function set_bgColor(value:BitmapInt32):BitmapInt32 
	#end
	{
		if (_bgSprite != null)
		{
			_bgColor = value;
			#if !flash
			_bgSprite.pixels.setPixel32(0, 0, _bgColor);
			#end
		}
		
		return value;
	}
	
	override public function draw():Void
	{
		//Draw background
		#if flash
		if(cameras == null) { cameras = FlxG.cameras; }
		var i:Int = 0;
		var l:Int = cameras.length;
		while (i < l)
		{
			var camera:FlxCamera = cameras[i++];
			
			camera.fill(this.bgColor);
		}
		#else
		_bgSprite.draw();
		#end

		//Now draw all children
		super.draw();
	}
	
	public function close(destroy:Bool = true):Void
	{
		if (_parentState != null) 
		{ 
			_parentState.subStateCloseHandler(destroy); 
		}
		else 
		{ 
			/* Missing parent from this state! Do something!!" */ 
			#if !FLX_NO_DEBUG
			throw "This subState haven't any parent state";
			#end
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		_initialized = false;
		_parentState = null;
		closeCallback = null;
	}

}