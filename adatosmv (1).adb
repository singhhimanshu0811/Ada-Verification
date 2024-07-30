package body AdaToSMV is
   
   procedure SetConfig(AdaPath,SMVPath:Ada.Strings.Unbounded.Unbounded_String) is
   begin
      Config.AdaFilePath := AdaPath;
      Config.SMVFilePath := SMVPath;
   end SetConfig;

end AdaToSMV;
