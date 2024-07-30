with AdaToSMV.NextMaps; use AdaToSMV.NextMaps;
with AdaToSmv.ParseAssignment; use AdaToSmv.ParseAssignment;
package AdaToSMV.ParseIfCond is
   
   
   procedure ParseElseIf (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural);
   procedure ParseIfElse (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural);
   --procedure ParseElseIf (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural);
   function countLine (Node : LAL.Ada_Node'Class) return Natural;
   
end AdaToSMV.ParseIfCond;
