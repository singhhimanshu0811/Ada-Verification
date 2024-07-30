 package body  AdaToSMV.ParseIfCond is 
 
 
   --Counts assignment and conditional statement children and grandchildren and ... of a node
   function countLine (Node : LAL.Ada_Node'Class) return Natural is
   use type LALCO.Ada_Node_Kind_Type;
   	lines : Natural;
   begin
      lines := 0; 
      for child of Node.Children loop
      	if child.Kind = LALCO.Ada_Assign_Stmt then
      		lines := lines + 1;
      	elsif child.Kind = LALCO.Ada_If_Stmt then
      		lines := lines + 1;
      		for child2 of child.Children loop
      			if child2.Kind = LALCO.Ada_Stmt_List then
      				lines := lines + countLine(child2);
      			end if;
      		end loop;
   	elsif child.Kind = LALCO.Ada_Elsif_Stmt_Part then
   		lines := lines + 1;
      		for child2 of child.Children loop
      			if child2.Kind = LALCO.Ada_Stmt_List then
      				lines := lines + countLine(child2);
      			end if;
      		end loop;
   	end if;
      end loop;
      return lines;
   end countLine;
   
   procedure ParseMainNode (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) is
      use type LALCO.Ada_Node_Kind_Type;
   begin
      -- Put_Line("Reached ParseStmtList");
      --AllMap.Include(To_Unbounded_String("line"),new NextTable.Vector);
      for child of Node.Children loop
      	if child.Kind = LALCO.Ada_Assign_Stmt then
      		ParseAssignStmt(child, Branch, ElseIfEntry, ElseEntry, ExitPt);
      	--elsif child.Kind = LALCO.Ada_If_Stmt then
      	elsif child.Kind = LALCO.Ada_If_Stmt then
      		ParseIfElse(child, Branch, ElseIfEntry, ElseEntry, ExitPt);
      	else
      		ParseElseIf(child, Branch, ElseIfEntry, ElseEntry, ExitPt);
   	end if;
      end loop;
   end ParseMainNode;
   
 procedure ParseIfElse (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) is
      use type LALCO.Ada_Node_Kind_Type;
      CurrLine : Natural;
      IfExpr : Unbounded_String;
      ElseIfExists : Boolean := True;
      ElseIfExpr : Unbounded_String; 
      NewExitPt : Natural;
      NewElseIfEntry : Natural;
      NewElseEntry : Natural;
      TempCnt : Natural;
      child1 : LAL.Ada_Node'Class := Node;
   begin
      -- Increase line number count
      --Put_Line("if block");
      CurrLine := LineCount;
      LineCount := LineCount + 1;
      
     
      --Get the condition
      IfExpr := To_Unbounded_String(Text.Image(LAL.F_Cond_Expr(LAL.As_If_Stmt(Node)).Text));
      
      --node is IfStmt, it has four children - f_cond_expr, f_then_stmts, f_alternatives, f_else_stmts
      TempCnt := 0;
      for child of Node.Children loop
      	TempCnt := TempCnt + 1;
      	if TempCnt = 2 then--count number of statements in the if block
      		NewElseIfEntry := CurrLine + countLine(child) + 1;
      		NewElseEntry := NewElseIfEntry;
      		NewExitPt := NewElseIfEntry;
      	end if;
      	if TempCnt = 3 then--count number of statements in the elif block
      		NewElseEntry := NewElseEntry + countLine(child);
      		if NewElseEntry = NewElseIfEntry then
      			ElseIfExists := False;
      			ElseIfExpr := To_Unbounded_String("FALSE");
      		else
      			ElseIfExpr := To_Unbounded_String(Text.Image(LAL.F_Cond_Expr(LAL.As_Elsif_Stmt_Part(LAL.First_Child(child))).Text));
      		end if;
      		NewExitPt := NewElseEntry;
      	end if;
      	if TempCnt = 4 then--count number of statements in the else block
      		NewExitPt := NewExitPt + countLine(child) ;
      	end if;
      end loop;
      
    
      if Branch=True and (NewExitPt=ElseEntry or NewExitPt=ElseIfEntry) then
      	NewExitPt := ExitPt;
      end if;
      
      Put_Line(NewElseIfEntry'Image);
      Put_Line(NewElseEntry'Image);
      Put_Line(NewExitPt'Image);

      TempCnt := 0;
      for child of Node.Children loop
      	--LAL.Print(child);
      	TempCnt := TempCnt + 1;
      	if TempCnt = 2 then
      		AllMap(To_Unbounded_String("line")).all.Append(
         	(Line => LineCount-1,
          	Expr => To_Unbounded_String(LineCount'Image),
          	Cond => IfExpr
         	)
        	);
        	if ElseIfExists=True then
        		AllMap(To_Unbounded_String("line")).all.Append(
         		(Line => LineCount-1,
          		Expr => To_Unbounded_String(NewElseIfEntry'Image),
          		Cond => "not " & IfExpr
         		)
        		);
        	else
        		AllMap(To_Unbounded_String("line")).all.Append(
         		(Line => LineCount-1,
          		Expr => To_Unbounded_String(NewElseEntry'Image),
          		Cond => "not " & IfExpr
         		)
        		);
        	end if;
      		ParseMainNode(child, True, NewElseIfEntry, NewElseEntry, NewExitPt);
      	end if;
      	if TempCnt = 3 and ElseIfExists=True then
        		--for child1 of child.Children loop
        			--LAL.Print(child1);
      				ParseMainNode(child, True, NewElseIfEntry, NewElseEntry, NewExitPt);
      			--end loop;
      	end if;
      	if TempCnt = 4 then
      		ParseMainNode(child, True, NewElseIfEntry, ElseEntry, NewExitPt);
      	end if;
      end loop;

   end ParseIfElse;
   
   
    procedure ParseElseIf (Node : LAL.Ada_Node'Class; Branch : Boolean; ElseIfEntry : Natural; ElseEntry : Natural; ExitPt : Natural) is
      use type LALCO.Ada_Node_Kind_Type;
      CurrLine : Natural;
      ElseIfExpr : Unbounded_String; 
      NewElseIfEntry : Natural;
      TempCnt : Natural;
   begin
      -- Increase line number count
      --Put_Line("if block");
      CurrLine := LineCount;
      LineCount := LineCount + 1;
      
      LAL.Print(Node);
      --Get the condition
      ElseIfExpr := To_Unbounded_String(Text.Image(LAL.F_Cond_Expr(LAL.As_Elsif_Stmt_Part(Node)).Text));
      
      --node is IfStmt, it has four children - f_cond_expr, f_then_stmts, f_alternatives, f_else_stmts
      TempCnt := 0;
      for child of Node.Children loop
      	TempCnt := TempCnt + 1;
      	if TempCnt = 2 then--count number of statements in the elseif block
      		NewElseIfEntry := CurrLine + countLine(child) + 1;
      	end if;
      end loop;
      
      TempCnt := 0;
      for child of Node.Children loop
      	--LAL.Print(child);
      	TempCnt := TempCnt + 1;
      	if TempCnt = 2 then
      		AllMap(To_Unbounded_String("line")).all.Append(
         	(Line => LineCount-1,
          	Expr => To_Unbounded_String(LineCount'Image),
          	Cond => ElseIfExpr
         	)
        	);
        	AllMap(To_Unbounded_String("line")).all.Append(
         	(Line => LineCount-1,
          	Expr => To_Unbounded_String(NewElseIfEntry'Image),
          	Cond => "not" & ElseIfExpr
         	)
        	);
      		ParseMainNode(child, True, NewElseIfEntry, ElseEntry, ExitPt);
      	end if;
      end loop;

   end ParseElseIf;
   
   
  end     AdaToSMV.ParseIfCond;
