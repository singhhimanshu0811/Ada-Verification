with AdaToSMV.NextMaps; use AdaToSMV.NextMaps;
package AdaToSmv.ParseAssignment is 
   procedure ParseAssignStmt (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) ;
end AdaToSmv.ParseAssignment;
