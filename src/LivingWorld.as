package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import punk.fx.effects.BloomFX;
	import punk.fx.effects.BlurFX;
	import punk.fx.effects.ColorTransformFX;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXImage;
	import punk.fx.graphics.FXLayer;

	
	/**
	 * A Game Of Life implementation.
	 * 
	 * @author azrafe7
	 */
	public class LivingWorld extends World 
	{
		public static const START_X:int = 2;
		public static const START_Y:int = 22;
		
		public static const TICK:Number = .03;	// in seconds
		public static const CHANCE_OF_BIRTH:Number = .75;
		
		public static const GRID_W:int = 100;
		public static const GRID_H:int = 70;
		
		public static const SCALE:Number = 5;
		public static var COLOR:uint = 0xFFE09040;
		
		protected var gridW:int;
		protected var gridH:int;
		
		protected var grid:Vector.<Cell>;
		protected var nCells:int;
		
		protected var canRender:Boolean = false;
		
		protected var image:FXImage;
		protected var fxLayer:FXLayer;
		
		protected var alphaFX:ColorTransformFX = new ColorTransformFX(1, 1, 1, .82);
		protected var blurFX:BlurFX = new BlurFX(2);
		protected var glowFX:GlowFX = new GlowFX(3, 0xFF, 6, 1, true);
		
		public function LivingWorld(gridW:int = GRID_W, gridH:int = GRID_H) 
		{
			this.gridW = gridW;
			this.gridH = gridH;
			
			nCells = gridW * gridH;
			
			grid = new Vector.<Cell>(nCells, true);
			image = FXImage.createRect(gridW, gridH);
			image.scale = SCALE;
			//image.autoUpdate = false;
			image.effects.add(new GlowFX(2, 0x0, 2, 1, false, false));
			image.effects.add(new BloomFX(2, 200));
			
			//addGraphic(image, 0, START_X, START_Y);
			
			fxLayer = new FXLayer;
			fxLayer.autoClearSource = false;
			fxLayer.entities.add(new Entity(START_X, START_Y, image));
			addGraphic(fxLayer);
			
			fxLayer.onPreRender = function (layer:*):void 
			{
				//glowFX.applyTo(fxLayer.getSource());
				alphaFX.applyTo(fxLayer.getSource());
				blurFX.applyTo(fxLayer.getSource());
			}
			
			seed();
			
			FP.alarm(TICK, onTick, 1);
		}
		
		override public function update():void 
		{
			super.update();
			//onTick();
		}
		
		public function onTick(useRules:Boolean=true):void 
		{
			//trace("tick");
			
			var n:int = nCells;
			
			while (n--) 
			{	
				grid[n].neighbors = countNeighborsOf(n);
				//grid[n].wasAlive = grid[n].alive;
			}
				
			n = nCells;
			
			image.getSource().lock();
			image.getSource().fillRect(image.getSource().rect, 0);
			
			while (n--) 
			{
				if (useRules) applyRulesTo(n);
				
				var cell:Cell = grid[n];
				var x:int = n % gridW;
				var y:int = int(n / gridW);
				
				if (cell.alive) image.getSource().setPixel32(x, y, COLOR);
			}
			
			image.getSource().unlock();
		}
		
		
		public function seed():void 
		{
			var n:int = nCells;
			while (n--) {
				grid[n] = new Cell(Math.random() < CHANCE_OF_BIRTH);
			}
		
			onTick(false);
		}
		
		
		public function applyRulesTo(cellIdx:int):void 
		{
			var cell:Cell = grid[cellIdx];

			if (cell.alive) {
				cell.alive = cell.neighbors == 2 || cell.neighbors == 3;
			} else {
				cell.alive = cell.neighbors == 3;
			}
		}
		
		public function countNeighborsOf(cellIdx:int):int
		{
			var n:int = 0;
			
			for (var j:int = -1; j <= 1; j++) {
				for (var k:int = -1; k <= 1; k++) {
					// only if not self
					if (!(j == 0 && k == 0)) {
						// wrap around
						var x:int = cellIdx % gridW;
						var y:int = int(cellIdx / gridW);
						x = (x + j + gridW) % gridW;
						y = (y + k + gridH) % gridH;
						var idx:int = y * gridW + x;
						
						n += (grid[idx] && grid[idx].alive) ? 1 : 0;
					}
				}
			}
			
			return n;
		}
	}	
}

class Cell {
	public var alive:Boolean;
	public var wasAlive:Boolean;
	public var neighbors:int;
	
	public function Cell(alive:Boolean) 
	{
		this.alive = alive;
	}
}
