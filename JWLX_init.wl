$kernelPath = "/home/nicola/Gits/JWLX/JWLX_kernel/"

(*$jupyterPath = RunProcess[{"which","jupyter"}, "StandardOutput"] // StringTrim*)
$jupyterPath = "jupyter-lab"

nbAddrF := Echo@ReadString["!jupyter server list"] ~
           StringCases ~ Shortest["http://"~~__~~"/"] //
           If[# == {}
           , Run[$jupyterPath<>" &"]; Pause@1; nbAddrF
           , First@# <> "files/"] &

$nbAddr =  nbAddrF

$SLim = StringLength@StringRiffle@Names@"System`*"

(*Off[General::stop]*)
(*$Output = {}*)


(********************   Socket  *****************************)
webListenerF = Module[{request, result0, result, format, response},
    
  request = #@"Data"~ImportString~"HTTPRequest";
	    
  result = request@"Body"~ToExpression~StandardForm;
  	    
  format = If[ContainsAny[{Head@result0}, {Graph, Graphics, Image}], "SVG", "String"];

  response = ExportString[result, format] ~HTTPResponse~
	     <|"StatusCode"  -> 200,
	       "ContentType" -> "image/svg+xml",
	       "Headers"     -> {"Access-Control-Allow-Origin" -> <|request@"Headers"|> @ "origin"}
	     |> ~ExportString~ "HTTPResponse";

  (#@"SourceSocket"~WriteString~response; Close@#@"SourceSocket") 
]&


parseCellF = (
  ToExpression[#, InputForm, Hold] ~DeleteCases~ Null // 
  List @@ HoldForm /@ # & //
  Map[Check[ReleaseHold@# // Shallow[#, {Infinity, 50}]&, Last@$MessageList]&]//
  # ~DeleteCases~ Null /. _x?NumericQ -> ScriptForm@x & //
  Column @ Riffle[#, " "]& // ToString[#, CharacterEncoding->"UTF-8"]& //
  If[StringLength@#>$SLim, StringTake[#, $SLim]<>"\n..."<>ToString@StringLength@#<>">>", #]& //
  If[#=="Null", "", #]&
)&

SetAttributes[parseCellF, Protected]

listenerF = (#@"SourceSocket" ~WriteString~ parseCellF@#@"Data"; Close @ #@"SourceSocket") &
	      
SetAttributes[listenerF, Protected]

               
(***********************************************************************)
SocketListen[5858, listenerF]

webSocketF := ($webSocket = SocketListen[5859, webListenerF])
webSocketF
restartWebSocket := ( Close /@ Select[Sockets[] , #[[1]] == $webSocket[[1]]&];
		     webSocketF )

Get@"JWLX_utils.wl"

Dialog[]