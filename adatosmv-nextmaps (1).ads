package AdaToSMV.NextMaps is
   
   LineCount : Natural :=0;   
   -- Record to store a tuple (line_number,expression) Eg: (1,"A+A")
   type NextTuple is record
      Line   : Natural;
      Expr   : Unbounded_String;
      Cond   : Unbounded_String;--
   end record;

   -- Table of LineExprTuple records
   package NextTable is new
     Ada.Containers.Indefinite_Vectors
        (Index_Type   => Natural,
         Element_Type => NextTuple);

   type NextTableAccess is access all NextTable.Vector;
   
    
   

   package AllNextMaps is new
    Ada.Containers.Indefinite_Hashed_Maps
       (Key_Type        => Unbounded_String,
        Element_Type    => NextTableAccess,
        Hash            => Ada.Strings.Unbounded.Hash,
        Equivalent_Keys => "=");
        
    AllMap : AllNextMaps.Map;
   procedure PrintAllNextMaps (M : AllNextMaps.Map);

end AdaToSMV.NextMaps;
