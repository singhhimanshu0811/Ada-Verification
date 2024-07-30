package body AdaToSMV.MainNode is
procedure ParseMainNode (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) is
      use type LALCO.Ada_Node_Kind_Type;
   begin
      -- Put_Line("Reached ParseStmtList");
      --AllMap.Include(To_Unbounded_String("line"),new NextTable.Vector);
      for child of Node.Children loop
      	if child.Kind = LALCO.Ada_Assign_Stmt then
      		ParseAssignStmt(child, Branch, ElseIfEntry, ElseEntry, ExitPt);
      	else
      		ParseIfElse(child, Branch, ElseIfEntry, ElseEntry, ExitPt);
   	end if;
      end loop;
   end ParseMainNode;
   
end AdaToSMV.MainNode;
   
   
   
   
