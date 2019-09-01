#!/usr/bin/wolframscript

 

nbAddrF := ReadString@"!jupyter notebook list"~
		 StringCases~Shortest["http://"~~__~~"/"] //
		 If[# == {}
			,(Print["\n$:"<>#]; Run@#)& @"jupyter notebook &"; 
			  Pause@1; nbAddrF
			,Print["\n~: "<>First@#]; First@#<>"files/" 
		   ]&

$nbAddr = nbAddrF


show@g_Image := $nbAddr<>Export["out.png",g,"PNG"]
				
show@g_ := $nbAddr<>Export["out.pdf",g,"PDF"]     

info@sym_Symbol := Column@{Information@sym,
	"https://reference.wolfram.com/language/ref/"<>ToString@sym<>".html"}



Protect/@{show,$nbAddr,$nbAddrF}

Off[General::stop] 




 
serverF = Module[

  {pData = ToExpression[#@"Data",InputForm, List]~
           Check~List@Last@$MessageList /. Null->Nothing //
           Column@Riffle[#, " "]&},
           
  #@"SourceSocket"~WriteString~pData;
  #@"SourceSocket" // Close;
]&

               
SocketListen[5858, serverF]

Dialog[]






