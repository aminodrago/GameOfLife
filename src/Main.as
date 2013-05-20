package 
{
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import flash.system.System;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Text;
	import punk.fx.FXMan;
	
	/**
	 * ...
	 * @author azrafe7
	 */
	[SWF(width = "800", height = "500")]
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			FP.console.log("R reset | hold SPACE for slow motion | Conway's Game Of Life | FP " + FP.VERSION + " + punk.fx " + FXMan.VERSION);
			super(800, 500, 30, false);
			
			FP.screen.color = 0x302D26;
			//FP.console.toggleKey = Key.TAB;
			//FP.console.log("TAB - toggle console");
			FP.console.enable();
			
			FP.world = new LivingWorld(159, 91);
		}
		
		override public function update():void
		{
			super.update();
			
			// press ESCAPE to exit debug player
			if (Input.check(Key.ESCAPE)) {
				System.exit(1);
			}

			// R to reset | hold SPACE for slow motion
			if (Input.pressed(Key.R)) {
				LivingWorld(FP.world).seed();
				LivingWorld.COLOR = (0xFF << 24) | Math.random() * 0xFFFFFF;	/*FP.getColorHSV(Math.random(), .75, .9 + Math.random()*.1);*/
			} else if (Input.check(Key.SPACE)) {
				FP.stage.frameRate = 4;
			} else if (FP.stage.frameRate != FP.assignedFrameRate) FP.stage.frameRate = FP.assignedFrameRate;
		}
		
	}
}