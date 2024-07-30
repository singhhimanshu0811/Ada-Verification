package body AdaToSMV.AdaReader is
     
   MainNode : LAL.Ada_Node;
   
   -- Call back function for call to Traverse 
   -- Finds top-level node of type 'Ada_Stmt_List'
   function FindMainNode (Node : LAL.Ada_Node'Class) return LALCO.Visit_Status;
   
   function GetNextMaps return AllNextMaps.Map is
   begin
      return AllMap;
   end GetNextMaps;
   -- Main procedure for parsing Ada program that returns AllNextMaps
   -- Visible outside the package
   procedure ParseProgram is
      Unit    : LAL.Analysis_Unit; 
   begin
      -- Create Analysis unit that parses Ada program
      Unit := LAL.Create_Context.Get_From_File(To_String(Config.AdaFilePath));
      --  Report parsing errors and break, if any
      if Unit.Has_Diagnostics then
         for D of Unit.Diagnostics loop
            Put_Line (Unit.Format_GNU_Diagnostic (D));
         end loop;
      end if;
      -- Find main node
      Unit.Root.Traverse (FindMainNode'Access);
      AllMap.Include(To_Unbounded_String("line"),new NextTable.Vector);
      -- Parse main node
      ParseMainNode(MainNode, False, 0, 0, 0);
      --Print AllMap -- FOR DEBUGGING
      --PrintAllNextMaps(AllMap);
      --Unit.Print;
      
   end ParseProgram;
   
   -- Callback for Traverse
   function FindMainNode (Node : LAL.Ada_Node'Class) return LALCO.Visit_Status is
      use type LALCO.Ada_Node_Kind_Type;
   begin
      -- If node of type 
      if Node.Kind = LALCO.Ada_Stmt_List then
         MainNode := LAL.Ada_Node(Node);
         return LALCO.Stop;
      end if;
      return LALCO.Into;
   end FindMainNode;
   
   

end AdaToSMV.AdaReader;
