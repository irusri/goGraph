package
{
	import com.adobe.flex.extras.controls.springgraph.IEdgeRenderer;
	import mx.core.UIComponent;
	import com.adobe.flex.extras.controls.springgraph.Graph;
	import flash.display.Graphics;
	
	public class EdgeRenderer implements IEdgeRenderer
	{
		public function EdgeRenderer()
		{
			
		}
		
		public function draw(g:Graphics, fromView:UIComponent, toView:UIComponent, fromX:int, fromY:int, toX:int, toY:int, graph:Graph):Boolean
		{
			var thickness = 1;
			var color = 0xC0C0C0;
			var alpha = 1.0;
			g.lineStyle(thickness,color,alpha);
			g.beginFill(0);
			g.moveTo(fromX, fromY);
			g.lineTo(toX, toY);
			g.endFill();
			return true;
		}
		
	}
}