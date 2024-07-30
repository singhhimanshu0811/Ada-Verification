package body AdaToSmv.ParseAssignment is 
procedure ParseAssignStmt (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) is
      use type LALCO.Ada_Node_Kind_Type;
      VarName : Unbounded_String;
   begin
      -- Put_Line("Reached ParseAssignStmt");
      -- Increase line number count
      LineCount := LineCount + 1;
      -- Update NextTable for 'line'
      if Branch=True and (LineCount=ElseIfEntry or LineCount=ElseEntry) then
      	 AllMap(To_Unbounded_String("line")).all.Append(
         (Line => LineCount-1,
          Expr => To_Unbounded_String(ExitPt'Image),
          Cond => To_Unbounded_String("TRUE")
         )
         );
      else
        AllMap(To_Unbounded_String("line")).all.Append(
         (Line => LineCount-1,
          Expr => To_Unbounded_String(LineCount'Image),
          Cond => To_Unbounded_String("TRUE")
         )
        );
      end if;
      
      -- Update NextTable for destination variable of the AssignStmt
      VarName := To_Unbounded_String(Text.Image(LAL.F_Dest(LAL.As_Assign_Stmt(Node)).Text));
      if not AllMap.Contains(VarName) then
         -- Put_Line("Reached ParseAssignStmt - If part");
         -- Create table for the variable 
         AllMap.Include(VarName,new NextTable.Vector);
         -- Insert expression for the variable
         AllMap(VarName).all.Append(
                                     (Line => LineCount-1,
                                      Expr => To_Unbounded_String(
                                        Text.Image(LAL.F_Expr(LAL.As_Assign_Stmt(Node)).Text)),
                                        Cond => To_Unbounded_String("TRUE")
                                     )
                                    );
      else
         --Put_Line("Reached ParseAssignStmt - Else part");
         AllMap(VarName).all.Append(
                                     (Line => LineCount-1,
                                      Expr => To_Unbounded_String(
                                        Text.Image(LAL.F_Expr(LAL.As_Assign_Stmt(Node)).Text)),
                                        Cond => To_Unbounded_String("TRUE")
                                     )
                                    );
      end if;
   end ParseAssignStmt;
   
end    AdaToSmv.ParseAssignment;
