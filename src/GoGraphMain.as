import com.adobe.flex.extras.controls.springgraph.Graph;
import com.adobe.flex.extras.controls.springgraph.Item;
import com.adobe.serialization.json.JSON;

import mx.collections.ArrayCollection;
import mx.containers.Box;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.graphics.codec.JPEGEncoder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import utils.DataGridUtils;

[Bindable]
public var fontSizeSpringSlider:Number=7;
[Bindable]
private var edgrerender:LabelEdgeRenderer=new LabelEdgeRenderer();


[Bindable]
private var goArraycol:ArrayCollection=new ArrayCollection();

[Bindable]
//	public var tmparr:ArrayCollection=new ArrayCollection();
private var modelConfig:Object;
private var g: Graph = new Graph();
private var prevItem: Item;
private var itemCount: int = 0;

private function newItem(): void {
	var item: Item = new Item(new Number(++itemCount).toString());
	g.add(item);
	if(prevItem != null)
		g.link(item, prevItem);
	prevItem = item;
	s.dataProvider = g;
}	

private function linkItems(fromId: String, toId: String): void {
	var fromItem: Item = g.find(fromId);
	var toItem: Item = g.find(toId);
	g.link(fromItem, toItem);
	s.dataProvider = g;
}		

private function unlinkItems(fromId: String, toId: String): void {
	var fromItem: Item = g.find(fromId);
	var toItem: Item = g.find(toId);
	g.unlink(fromItem, toItem);
	s.dataProvider = g;
}	


private function GODataResult(event:ResultEvent):Boolean {
	
	//if (signalError) { return false; }
	gc.refresh();
	var exprData:Object = JSON.decode(String(event.result));
	
	for (var cname:String in exprData.children) {
		var cid:String = exprData.children[cname].cid;
		var cparent:String = exprData.children[cname].cparent;
		var crelationship:String = exprData.children[cname].crelationship;
		var cnames:String = exprData.children[cname].cname;
		var contology:String = exprData.children[cname].contology;
		var ccount:String = exprData.children[cname].ccount;
		var midcount:String = exprData.midcount;
		
		var citem: GOItem = new GOItem(cid,"child",'Accession :'+ cid+'\n'+'Ontology :'+contology,'Definition :'+cnames,'Relation :'+crelationship,ccount);
		
		var citemp: GOItem = new GOItem(cparent,"midparent",'Accession :'+ cparent+'\n'+'Ontology :'+contology,'Definition :'+cnames,'Relation :'+crelationship,midcount);
		g.add(citemp);
		g.add(citem);
		goArraycol.addItem({cid:cid,cparent:cparent,contology:contology,relate:'Children',desc:cnames});
		//	tmparr.addItem({citemp:citemp.id,citem:citem.id,infos:citem.info});
		g.link(citemp,citem,citemp);
		
	}
	for (var pname:String in exprData.parent) {
		var pid:String = exprData.parent[pname].pid;
		var pchild:String = exprData.parent[pname].pchild;
		var prelationship:String = exprData.parent[pname].prelationship;
		var pnames:String = exprData.parent[pname].pname;
		var pontology:String = exprData.parent[pname].pontology;
		var pcount:String = exprData.parent[pname].pcount;
		//var pitemp: Item = new Item(pid+"->1");
		//var pitem: Item = new Item(pchild+"->2");
		
		
		var pitemp: GOItem = new GOItem(pid,"parent",'Accession :'+ pid+'\n'+'Ontology :'+ pontology,'Definition :'+pnames,'Relation :'+prelationship,pcount);
		var pitem: GOItem = new GOItem(pchild,"midparent",'Accession :'+ pchild+'\n'+'Ontology :'+pontology,'Definition :'+pnames,'Relation :'+prelationship,midcount); 
		
		g.add(pitemp);
		g.add(pitem);
		goArraycol.addItem({cid:pid,cparent:pchild,contology:pontology,relate:'Ancestors',desc:pnames});
		g.link(pitemp,pitem,pitemp);
	}
	
	gc.source=goArraycol;
	s.dataProvider=g;
	return true;
}





private function GOFault(event:FaultEvent):Boolean {
	//Alert.show(event.fault.content.toString());
	//changeStatus("There was an error loading webservice data, please try again.");
	return true;
}
private function init():void{
	input_GO.text = FlexGlobals.topLevelApplication.parameters.id;
	//input_GO.text="GO:0043231"
	if(input_GO.text!=""){
		dataSend();
	}else{
		input_GO.text="GO:0005975  GO:0009311";
		dataSend();
	}
}
private function dataSend():void{
	//	var g: Graph = new Graph();
	//s.dataProvider=[];
	g.empty();
	goArraycol=new ArrayCollection();
	var str:String =input_GO.text;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		//var base:String = modelConfig.settings.url+"?primaryGene="+a[h];//	serve_getTranscriptData.url =modelConfig.settings.url+"?id="+a[h];
		serve_getGOData.url = "http://130.239.131.199/goService/gotmp.php?id=" +a[h];//+ input_GO.text;
		serve_getGOData.send();
		
	}
	
}


private function dataSendSubmit():void{
	//	var g: Graph = new Graph();
	//s.dataProvider=[];
	g.empty();
	goArraycol=new ArrayCollection();
	if(goChk.selected==true){
	var str:String =input_GO.text;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);

	for(var h:int=0;h<a.length;h++){
		//var base:String = modelConfig.settings.url+"?primaryGene="+a[h];//	serve_getTranscriptData.url =modelConfig.settings.url+"?id="+a[h];
		serve_getGOData.url = "http://130.239.131.199/goService/gotmp.php?id=" +a[h];//+ input_GO.text;
		serve_getGOData.send();
		
	}
	}

	if(tidChk.selected==true){	
	var strt:String =input_TID.text;
	var patternt:RegExp = /,/gi;
	var at:Array = strt.replace(patternt, " ").split(/\s+/);
	

	for(var k:int=0;k<at.length;k++){
		//var base:String = modelConfig.settings.url+"?primaryGene="+a[h];//	serve_getTranscriptData.url =modelConfig.settings.url+"?id="+a[h];
		serve_submitTranscript.url = "http://130.239.131.199/goService/submitTranscript.php?id=" +at[k];//+ input_GO.text;
		serve_submitTranscript.send();
		
	}
	}


}


/**
 * export grid data as CSV
 */
private function handleExportClick():void
{
	DataGridUtils.loadDataGridInExcel(gotmpdg);
}

	private function handleExportClick2():void
	{
		DataGridUtils.loadDataGridInExcel(tempadg);
	}

protected function refreshbtn_clickHandler(event:MouseEvent):void
{
	g.empty();
	input_GO.text="GO:0043231";
	dataSend();
}

public function gotoNewNode(node:String):void
{
	g.empty();
	input_GO.text=node;
	dataSend();
}

private function helpGo():void {
	
	var URL:String = "http://v22.popgenie.org/goService/help.html" ;
	navigateToURL(new URLRequest(URL), "_blank");
}

/**
 * take snapshot
 */
[Bindable]
private var file:FileReference = new FileReference();
private function takeSnapshot():void {
	var bitmapData:BitmapData = new BitmapData(s.width, s.height);
	bitmapData.draw(s,new Matrix());
	var bitmap : Bitmap = new Bitmap(bitmapData);
	var jpg:JPEGEncoder = new JPEGEncoder(100);
	var ba:ByteArray = jpg.encode(bitmapData);
	file.save(ba,"Chart" + '.png');
}
[Bindable]
private var tempdatagridarr:ArrayCollection= new ArrayCollection();

private function TranscriptDataResult(event:ResultEvent):Boolean {
	tempdatagridarr=new ArrayCollection();
	//if (signalError) { return false; }
	var tmptid:String=new String();
	var exprData:Object = JSON.decode(String(event.result));
	tmptid=exprData.tid;
	TranscriptBox.visible=true;
	if(tmptid!=null){
		var pattern:RegExp = /,/gi;
		//tmptid=tmptid.replace(pattern, "\n");
		var a:Array = tmptid.replace(pattern, " ").split(/\s+/);
		for(var h:int=0;h<a.length;h++){
			//	myAlert.show(alertBox,a[h]+ " transcript values copied to clipboard.", false);
			tempdatagridarr.addItem({tid:a[h]});
		}
		
		//tidtxt.htmlText=tmptid;
	}else{
		//		tidtxt.htmlText="No Value, try another node";	
	}
	
	return true
	
}
[Bindable]
private var tmpidstr:String="select a node";
public function transcriptdataSend(str:String):void{
	//	var g: Graph = new Graph();
	if(showtidChk.selected==true){
		tmpidstr=str;
		serve_getTranscriptData.url = "http://130.239.131.199/goService/goTranscript.php?id="+str;//+ input_GO.text;
		serve_getTranscriptData.send();
	}
}
public var myAlert:AlertTimer = new AlertTimer();
protected function copytoCLipboard():void{
	//	System.setClipboard('Accession : '+tmpidstr +'\n\n Transcript IDs:\n'+tidtxt.text);
	//	myAlert.show(alertBox,tmpidstr+ " transcript values copied to clipboard.", false);
	
}
/**
 * creationCompete HTTP service Result
 */
private function handle_config_files(event:ResultEvent):void {
	modelConfig = (JSON.decode(String(event.result)));
	loadPolFile(modelConfig.settings.policy_file);
}
/**
 * Retrieves the crossdomain file for the web-service policy file.
 */
private function loadPolFile(url:String):void {
	Security.loadPolicyFile(url);
}


public function submitTranscript(strt:String):void{
	serve_submitTranscript.url="http://130.239.131.199/goService/submitTranscript?id="+strt;
	serve_submitTranscript.send();
	
}

private function SubmitTranscriptResult(event:ResultEvent):void{
	var exprData:Object = JSON.decode(String(event.result));
	input_GO.text=exprData.goid;
	dataSend();
}






