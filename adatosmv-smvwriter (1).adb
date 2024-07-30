package body AdaToSMV.SMVWriter is
   
   procedure WriteSMVFile(M: AllNextMaps.Map) is
      F       : File_Type;
      VarName : Unbounded_String;
   begin
      Create (F, Out_File,To_String(Config.SMVFilePath));
      Put_Line (F, "MODULE main");
      -- Write VAR
      Put_Line (F, "VAR");
      
      -- Declare 'line' - Use length of NextTable vector of 'line' for finding LineCount
      Put (F, "  line : {");      
      for n in 1..M(To_Unbounded_String("line")).all.Length loop
         Put (F,n'Image & ",");
      end loop;
      Put (F, " 0};"); 
      Put_Line (F, ""); 
      
      -- Declare each variable as signed word[8]
      for V in M.Iterate loop
         if not (To_String(AllNextMaps.Key(V)) = "line") then
            Put_Line (F, "  " 
                      & To_String(AllNextMaps.Key(V)) 
                      & " : " 
                      & "signed word[8];");
         end if;
      end loop;  
        
       -- Write ASSIGN 
      Put_Line (F, "ASSIGN");
      
      -- Init line
      Put_Line (F, "  init(line) := 0;");
      
      -- Next for 'line' var
      Put_Line (F, "  next(line) :=");
      Put_Line (F, "  case");
      for tuple of M(To_Unbounded_String("line")).all loop
         Put_Line (F,"    line =" 
                   & tuple.Line'Image 
                   & " & " 
                   & To_String(tuple.Cond)
                   & " :" 
                   & To_String(tuple.Expr) 
                   & ";");
      end loop;
      Put_Line (F,"    TRUE : line;");
      Put_Line (F, "  esac;");
      
      -- Next for every var
      for V in M.Iterate loop
         VarName := AllNextMaps.Key(V);
         if not (To_String(VarName) = "line") then
            Put_Line (F, "  next(" 
                      & To_String(VarName)
                      & ") :=");
            Put_Line (F, "  case");
            for tuple of M(V).all loop
               Put_Line (F,"    line =" 
                         & tuple.Line'Image 
                         & " & " 
                   	  & To_String(tuple.Cond)  
                         & " : " 
                         & To_String(tuple.Expr) 
                         & ";");
            end loop;
            Put_Line (F,"    TRUE : "
                      & To_String(VarName)
                      & ";");
            Put_Line (F, "  esac;");
         end if;
      end loop; 
      
      -- Designate area for LTL SPEC
      Put_Line(F, "-- LTLSPEC (V1<V2) -> F G (V2<V1)");      
      Close (F);
   end WriteSMVFile;

end AdaToSMV.SMVWriter;
