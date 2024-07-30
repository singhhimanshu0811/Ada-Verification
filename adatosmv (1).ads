--with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Langkit_Support.Slocs;
with Langkit_Support.Text;
with Libadalang.Analysis;
with Libadalang.Common;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Unbounded.Hash;


package AdaToSMV is

   package LAL renames Libadalang.Analysis;
   package LALCO renames Libadalang.Common;
   package Slocs renames Langkit_Support.Slocs;
   package Text renames Langkit_Support.Text;
   
   type ConfigRecord is record
      AdaFilePath : Unbounded_String;
      SMVFilePath : Unbounded_String;
   end record;
   
   Config : ConfigRecord;
   
   procedure SetConfig(AdaPath,SMVPath:Ada.Strings.Unbounded.Unbounded_String);
   
end AdaToSMV;
