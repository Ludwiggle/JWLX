#!/bin/bash

mkdir JWLSout 2>/dev/null
mkdir /dev/shm/JWLSout 2>/dev/null


function finish {
  rm -r JWLSout
  rm -r /dev/shm/JWLSout
}


wolframscript -c '


$kernelPath = "/home/nicola/miniconda3/lib/python3.7/site-packages/JWLS_2_kernel/"

$jupyterPath = RunProcess[{"which","jupyter"}, "StandardOutput"] // StringTrim

(*$kernelPath2 = RunProcess[{"pip","show","jupyter"}] // 
               If[#@"ExitCode" == 1
                  , Return@" > pip did not find jupyter"
                  , #@"StandardOutput" ~StringSplit~ "\n" // StringSplit] & // 
               Select[#, First@# == "Location:" &][[1,2]]<>"/JWLS_2_kernel/" &  //
               If[DirectoryQ@#, #, Return@" > JWLS kernel folder not found"]&
*)


nbAddrF := ReadString["!" <> $jupyterPath <> "-notebook list"] ~
           StringCases ~ Shortest["http://"~~__~~"/"] //
	   If[# == {}
	      , Run[$jupyterPath <>"-notebook &"]; Pause@1; nbAddrF
	      , First@# <> "files/" 
	     ]&

$nbAddr = nbAddrF

(*$Output = {}*)

Off[General::stop] 


(***********************************************************************)
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
  	    
  format = If[ContainsAny[{Head @ result0}, {Graph,Graphics,Image}], "SVG", "String"];

  result  = ExportString[result0, format];

  response = result ~HTTPResponse~
	     <|"StatusCode"  -> 200,
	       "ContentType" -> "image/svg+xml",
	       "Headers"     -> {"Access-Control-Allow-Origin" 
			                     -> <|request@"Headers"|> @ "origin"}
	     |> ~ExportString~ "HTTPResponse";

  (#~WriteString~response; Close@#)& @ #@"SourceSocket"
]&


manipulate1 = $nbAddr <> Export["JWLSout/manipulate.html", #, "Text"]& @
	      TemplateApply[ $kernelPath <> "splate.wl" // Get
                            ,  <|"f" -> ExportString[#1 /. #2[[1]] -> ("+" <> ToString[#2[[1]]] <> "+") 
						      , "Text"],
                                 "v" -> #2[[1]],
                                 "x1" -> #2[[2]],
                                 "x2" -> #2[[3]],
                                 "x3" -> If[Length@#2 == 4, #2[[4]], .1 (#2[[3]]-#2[[2]]) ]
                               |> ] &  
       

SetAttributes[manipulate1, Protected]



manipulate2[f_, {v_, x1_, x2_, x3_:0.1}] := 
    $nbAddr <> Export["JWLSout/manipulate.html", #, "Text"]& @
    TemplateApply[ $kernelPath <> "splate.wl" // Get 
                  , <|"f" -> (f /. v -> ("\"+" <> ToString@v <> "+\"")),
                      "v" -> v,
                      "x1" -> x1,
                      "x2" -> x2,
                      "x3" ->  x3|> ]   


listanimate@list_ := Module[  
    {flns = ("/dev/shm/JWLSout/"<>
              StringPadLeft[ ToString@#, IntegerLength@Length@list, "0"] <>
             ".png" )& /@ Range @ Length @ list},
   
  "rm /dev/shm/JWLSout/*.png" // Run;

  Export[#1,#2,"PNG"]& ~MapThread~ {flns, list};

  Export["/dev/shm/JWLSout/listanimate.html"
	       , TemplateApply[$kernelPath <> "ciccia.wl" // Get
                         , <|"ims" -> ( FileNameTake /@ flns // 
                                        "\"" <> # <> "\""& /@ #& //
                                        StringRiffle[#, ","]& ) ,
                             "total" -> Length@list |>]
         , "Text"] //
  "file://" <> #& // (UsingFrontEnd@SystemOpen@#; Echo@#) &
]



refresh[f_,dt_:1] := $nbAddr <> Export["JWLSout/refresh.html", #, "Text"]& @
                     TemplateApply[$kernelPath <> "refresh.wl" // Get
                                   , <| "f" -> f ~ExportString~ "Text",
                                        "dt" -> (1000 dt) |>] 

SetAttributes[refresh, Protected]


(***********************************************************************)
parseCellF = (
  ToExpression[#, InputForm, Hold] ~DeleteCases~ Null // 
  List @@ HoldForm /@ # & //
  Check[ ReleaseHold @ #,  Last @ $MessageList ]& /@ # & //
  # ~DeleteCases~ Null /. _x?NumericQ -> ScriptForm@x & //
  Column @ Riffle[#, " "]& // 
  ToString[#, CharacterEncoding->"UTF-8"]&
)&

SetAttributes[parseCellF, Protected]


listenerF = ( WriteString[#@"SourceSocket", parseCellF @ #@"Data"];
             Close @ #@"SourceSocket" ) &
	      
SetAttributes[listenerF, Protected]

               
(***********************************************************************)
SocketListen[5858, listenerF]

webSocketF := ($webSocket = SocketListen[5859, webListenerF])
webSocketF
restartWebSocket := ( Close /@ Select[Sockets[] , #[[1]] == $webSocket[[1]]&];
		     webSocketF )

Dialog[]
'

trap finish EXIT




