with AdaToSmv.ParseAssignment; use AdaToSmv.ParseAssignment;
with AdaToSMV.ParseIfCond; use AdaToSMV.ParseIfCond;
package AdaToSMV.MainNode is
  procedure ParseMainNode (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural);
end AdaToSMV.MainNode;
