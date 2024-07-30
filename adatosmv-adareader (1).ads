with AdaToSMV.NextMaps; use AdaToSMV.NextMaps;
with AdaToSMV.ParseAssignment; use AdaToSMV.ParseAssignment;
with AdaToSMV.ParseIfCond; use AdaToSMV.ParseIfCond;
with AdaToSMV.MainNode; use AdaToSMV.MainNode;

package AdaToSMV.AdaReader is

   procedure ParseProgram;
   function GetNextMaps return AllNextMaps.Map;
   

end AdaToSMV.AdaReader;
