(*ResourceFunction["PersistResourceFunction"]/@ {"SVGImport", "ImportCSVToDataset", "ReadPNG", "ImportOnce","MapCases"}*)

show@g_Image := $nbAddr<>Export["JWLXout/out.png",g,"PNG"]     
show@g_ := $nbAddr<>Export["JWLXout/out.pdf",g,"PDF"]     

info@sym_Symbol := Column @ {
   Information[sym,"Usage"],
   "https://reference.wolfram.com/language/ref/"<>ToString@sym<>".html"}


IncrementalFilenames[data_List, ext_String] := 
  "JWLXout/"<>StringPadLeft[ToString@#, 1+Floor@Log[10,Length@data],"0"]<>"."<>ext & /@ Range@Length@data
  
ExportList[data_List, ext_String] := Export[#1,#2]&~MapThread~{IncrementalFilenames[data, ext],data} 

Protect/@{show, $nbAddr, $nbAddrF, info, IncrementalFilenames, ExportList}


(* HTML Export and Dynamics *)

manipulate1 = $nbAddr <> Export["JWLXout/manipulate.html", #, "Text"]& @
	      TemplateApply[$kernelPath<>"splate.wl" // Get
                            , <|"f" -> ExportString[#1 /. #2[[1]] -> ("+"<>ToString[#2[[1]]]<>"+"), "Text"],
                                "v" -> #2[[1]],
                                "x1" -> #2[[2]],
                                "x2" -> #2[[3]],
                                "x3" -> If[Length@#2 == 4, #2[[4]], .1 (#2[[3]]-#2[[2]])]
                              |> ] &  
       
SetAttributes[manipulate1, Protected]


manipulate2[f_, {v_, x1_, x2_, x3_:0.1}] := 
    $nbAddr <> Export["JWLXout/manipulate.html", #, "Text"]& @
    TemplateApply[ $kernelPath <> "splate.wl" // Get 
                  , <|"f" -> (f /. v -> ("\"+" <> ToString@v <> "+\"")),
                      "v" -> v,
                      "x1" -> x1,
                      "x2" -> x2,
                      "x3" ->  x3|> ]   


listanimate@list_ := Module[  
    {flns = ("/dev/shm/JWLXout/"<>
              StringPadLeft[ ToString@#, IntegerLength@Length@list, "0"] <>
             ".png" )& /@ Range @ Length @ list},
   
  Run@"rm /dev/shm/JWLXout/*.png";

  Export[#1, #2, "PNG"]& ~MapThread~ {flns, list};

  Export["/dev/shm/JWLXout/listanimate.html"
	       , TemplateApply[$kernelPath <> "ciccia.wl" // Get
                         , <|"ims" -> ( FileNameTake /@ flns // 
                                        "\"" <> # <> "\""& /@ #& //
                                        StringRiffle[#, ","]& ) ,
                             "total" -> Length@list |>]
         , "Text"] //
  "file://" <> #& // (UsingFrontEnd@SystemOpen@#; Echo@#) &
]



refresh[f_,dt_:1] := $nbAddr <> Export["JWLXout/refresh.html", #, "Text"]& @
                     TemplateApply[$kernelPath <> "refresh.wl" // Get
                                   , <| "f" -> f ~ExportString~ "Text",
                                        "dt" -> (1000 dt) |>] 

SetAttributes[refresh, Protected]


