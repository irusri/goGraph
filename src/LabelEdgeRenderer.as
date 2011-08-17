package
{
	import com.adobe.flex.extras.controls.springgraph.Graph;
	import com.adobe.flex.extras.controls.springgraph.IEdgeRenderer;
	import com.adobe.flex.extras.controls.springgraph.Item;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;

public class LabelEdgeRenderer implements IEdgeRenderer 
{ 
	private var labels:Array = new Array(); 
	
/*	public function draw(g:Graphics, f:UIComponent, 
						 t:UIComponent, fromX:int, fromY:int, toX:int, toY:int, 
						 graph:Graph):Boolean 
	{ 
		var fromItem: GOItem = (f as IDataRenderer).data as GOItem; 
		var toItem: GOItem = (t as IDataRenderer).data as GOItem; 
		var linkData: Object = graph.getLinkData(fromItem, toItem); 
		var alpha: Number = 1.0; 
		var thickness: int = 1; 
		var color; 
		if((linkData != null) ) { 
			var settings: Object = linkData.id; 
			//alpha = settings.alpha; 
			//thickness = settings.thickness; 
			//color = settings.color; 
		} 
		
		g.lineStyle(thickness,color,alpha); 
		g.beginFill(0); 
		g.moveTo(fromX, fromY); 
		g.lineTo(toX, toY); 
		g.endFill(); 
		
		var label:Label = new Label(); 
		label.text = "an edge label"; 
		
		//codes for checking duplicate labels is 
		//omitted for brevity 
	//	if(!labelExists(label)) { 
	//		f.parent.addChild(label); 
	//	} 
		var p:Point = new Point(f.x, f.y); 
		p = f.parent.globalToLocal(p); 
		label.x = p.x; 
		label..y = p.y; 
		
		return true; 
	} */
	
	
	public function draw(g:Graphics, f:UIComponent, 
						 t:UIComponent, fromX:int, fromY:int, toX:int, toY:int, 
						 graph:Graph):Boolean 
	{ 
		var fromItem: GOItem = (f as IDataRenderer).data as GOItem; 
		var toItem: GOItem = (t as IDataRenderer).data as GOItem; 
		var linkData: Object = 	graph.getLinkData(fromItem, toItem); 
		var alpha: Number = 1.0; 
		var thickness: int = 1; 
		var color:String;  
		if((linkData != null) &&(linkData.hasOwnProperty("info"))) { 
			var settings: Object = linkData.info; 
			//alpha = settings.alpha; 
			//thickness = settings.thickness; 
			//color = settings.color; 
		} 
		var str:String = linkData.rel//+":" +toItem.id; 
		g.lineStyle(thickness,uint(color),alpha); 
		g.beginFill(0); 
		g.moveTo(fromX, fromY); 
		g.lineTo(toX, toY); 
	//	g.drawRoundRect(20,fromY,10,10,toX,toY);
		
		this.drawArrows(g, fromX, fromY, toX, toY,str,t.parent); 
		g.endFill(); 
		
		/*if(Number(t.id)>id) { 
		var labelRel:Label; 
		labelRel = new Label(); 
		labelRel.text = linkData.label; 
		t.parent.addChild(labelRel); 
		} 
		var p:Point = new Point(t.x,t.y); 
		p = t.parent.globalToLocal(p); 
		labelRel.x = p.x; 
		labelRel.y = p.y+177;*/ 
		
		return true; 
	} 
	
	
	
	private function drawArrows(g:Graphics, fromX:int, fromY:int, toX:int, toY:int,labelArrow:String,parentItem:DisplayObjectContainer):void { 
		var arrowLength:uint = 10; 
		
		var dx:Number = toX - fromX; 
		var dy:Number = toY - fromY; 
		
		var mid1:Point = new Point(fromX + dx / 4, fromY + dy / 4); 
		var mid2:Point = new Point(fromX + dx / 2, fromY + dy / 2); 
		var mid3:Point = new Point(fromX + 3* dx / 4, fromY + 3* dy / 4); 
		
		var vector:Point = new Point(dx, dy); 
		
		// define a transformation matrix 
		var m:Matrix = new Matrix(); 
		var rad:Number = 135 * Math.PI / 180; 
		m.rotate(rad);  // angle has to be Rad 
		
		var vectorR:Point = m.transformPoint(vector); 
		vectorR.normalize(arrowLength); 
		
		m = new Matrix(); 
		rad = 225 * Math.PI / 180; 
		m.rotate(rad); 
		
		var vectorL:Point = m.transformPoint(vector); 
		vectorL.normalize(arrowLength); 
		
		//this.drawArrow(g, mid1, vectorL, vectorR); 
		this.drawArrow(g, mid2, vectorL, vectorR,labelArrow,parentItem); 
		//this.drawArrow(g, mid3, vectorL, vectorR); 
	} 
	
	private function drawArrow(g:Graphics, p:Point, vL:Point, vR:Point,labelArrow:String,parentItem:DisplayObjectContainer):void { 
		var rightX:Number = p.x + vR.x; 
		var rightY:Number = p.y + vR.y; 
		
		var leftX:Number = p.x + vL.x; 
		var leftY:Number = p.y + vL.y; 
		
		g.moveTo(p.x, p.y); 
	//	g.lineTo(rightX, rightY); 
		
		g.moveTo(p.x, p.y); 
	//	g.lineTo(leftX, leftY); 
		var labelRel:Label=checkExistLabel(labelArrow,parentItem);; 
		if(labelRel==null){ 
			labelRel = new Label(); 
			labelRel.text = labelArrow.split(':')[0]; 
			labelRel.name=labelArrow; 
			parentItem.addChild(labelRel); 
		} 
		labelRel.x = p.x+5; 
		labelRel.y = p.y; 
	} 
	
	private function checkExistLabel(nameLabel:String,parentItem:DisplayObjectContainer):Label{ 
		var l:Label=parentItem.getChildByName(nameLabel) as Label; 
		return l; 
	} 
	
	
} }