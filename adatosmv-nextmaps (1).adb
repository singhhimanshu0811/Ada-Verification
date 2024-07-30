package body AdaToSMV.NextMaps is

   procedure PrintAllNextMaps (M : AllNextMaps.Map) is
   begin
      for V in M.Iterate loop
         Put_Line(To_String(AllNextMaps.Key(V)));
         for tuple of M(V).all loop
            Put_Line("~~"& tuple.Line'Image & " and " & To_String(tuple.Cond) & "->" & To_String(tuple.Expr));
         end loop;
      end loop;   
   end PrintAllNextMaps;

end AdaToSMV.NextMaps;
