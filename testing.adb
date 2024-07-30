with AdaToSMV; use AdaToSMV;
with AdaToSMV.SMVWriter; use AdaToSMV.SMVWriter;
with AdaToSMV.AdaReader; use AdaToSMV.AdaReader;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Testing is
   FName : Ada.Strings.Unbounded.Unbounded_String;
   APath : Ada.Strings.Unbounded.Unbounded_String;
   NuSmvPath : Ada.Strings.Unbounded.Unbounded_String;
begin
   Ada.Text_IO.Put("Enter the name of the Ada program: ");
   FName := Ada.Strings.Unbounded.To_Unbounded_String(Ada.Text_IO.Get_Line);

   
   APath := "adaProgs/" & FName & ".adb";
   NuSmvPath := "smv/" & FName & ".smv";
   
   SetConfig(
             AdaPath	=>	APath,
             SMVPath	=>	NuSmvPath
            );

   ParseProgram;
   WriteSMVFile(GetNextMaps);

end Testing;
