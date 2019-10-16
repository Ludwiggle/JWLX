#!/bin/bash


mkdir JWLSout 2>/dev/null
mkdir /dev/shm/JWLSout 2>/dev/null


function finish {
  rm -r JWLSout
  rm -r /dev/shm/JWLSout
}

wolframscript -c '

$Output = {}

nbAddrF := ReadString@"!jupyter notebook list"~
	   StringCases~Shortest["http://"~~__~~"/"] //
	   If[# == {}
	      , Run@"jupyter notebook &"; Pause@1; nbAddrF
	      , First@#<>"files/" 
	    ]&

$nbAddr = nbAddrF

(***********************************************************************)

show@g_Image := "JWLSout/out.png" // (
		"ln -s "<>Export["/dev/shm/"<>#, g, "PNG"]<>" "<># // Run;
		$nbAddr<># ) & 
                 
show@g_Image := $nbAddr<>Export["JWLSout/out.png",g,"PNG"]     

				
show@g_ := $nbAddr<>Export["JWLSout/out.pdf",g,"PDF"]     


info@sym_Symbol := Column @ {
   Information[sym,"Usage"],
   "https://reference.wolfram.com/language/ref/"<>ToString@sym<>".html"}


Protect/@{show, $nbAddr, $nbAddrF, info}


(***********************************************************************)

webListenerF = Module[{request,result0,result,format,response},
    
  request = #@"Data"~
            ImportString~"HTTPRequest";
	    
  result0 = request@"Body"~
	    ToExpression~StandardForm;
	    
  format = If[ContainsAny[{Head @ result0}, {Graph,Graphics}], "SVG", "String"];

  result  = ExportString[result0, format];

  response = result~HTTPResponse~
	     <|"StatusCode"  -> 200,
	       "ContentType" -> "image/svg+xml",
	       "Headers"     -> {"Access-Control-Allow-Origin" 
			          -> <|request@"Headers"|> @ "origin"}
	     |>~ExportString~"HTTPResponse";

  (#~WriteString~response; Close@#)& @ #@"SourceSocket"
]&


manipulate = $nbAddr <> Export["JWLSout/manipulate.html", #, "Text"]& @
	     TemplateApply[ Get@"/home/nicola/Gits/JWLS_2/JWLS_2_kernel/splate.wl", 
		<|"f" -> (#1 /. #2[[1]] -> ("\"+" <> ToString[#2[[1]]] <> "+\"")),
		  "v" -> #2[[1]],
		  "x1" -> #2[[2]],
		  "x2" -> #2[[3]],
		  "x3" -> If[Length@#2 == 4, #2[[4]], .1 (#2[[3]]-#2[[2]]) ]
		|> ] &  
       
SetAttributes[manipulate, {HoldAll, Protected}]


listanimate@list_ := Module[
  
  {flns = ("/dev/shm/JWLSout/"<>
           StringPadLeft[ToString@#, Ceiling@Log[10, Length@list],"0"]<>
           ".png")& /@ Range@Length@list,
   
   tpl = Get@"/home/nicola/Gits/JWLS_2/JWLS_2_kernel/ciccia.wl"},
  
  Run["rm /dev/shm/JWLSout/*.png; rm JWLSout/*.png"];
  Export[#1,#2,"PNG"]& ~MapThread~ {flns,list};
  Run["ln -s "<>#<>" JWLSout/"<>FileNameTake@#] & /@ flns;
  Export["JWLSout/listanimate.html",
         TemplateApply[tpl, <|"ims" -> (FileNameTake/@flns // 
                                        "\""<>#<>"\""& /@ #& //
                                        StringRiffle[#,","]&) 
                            |>],
         "Text"] // $nbAddr<># & ]

(***********************************************************************)

parseCellF = (
  ToExpression[#, InputForm, Hold] ~DeleteCases~ Null // 
  List @@ HoldForm /@ # & //
  Check[ ReleaseHold @ #,  Last @ $MessageList]& /@ # & //
  # ~DeleteCases~ Null /. x_?NumericQ -> ScriptForm@x & //
  Column @ Riffle[#, " "]& 
)&


SetAttributes[parseCellF, Protected]

	   
listenerF = (WriteString[#@"SourceSocket", parseCellF @ #@"Data"]; 
	     Close @ #@"SourceSocket" 
	    ) &
	      
SetAttributes[listenerF, Protected]


Off[General::stop] 
               
(***********************************************************************)

SocketListen[5859, webListenerF]
SocketListen[5858, listenerF]

Dialog[]
'

trap finish EXIT




