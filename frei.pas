Program Frei;


Uses DOS;
 
var
  DiskSizeMB,DiskSizeKB:Integer;
  DiskFreeMB,DiskFreeKB:Integer;
  GesamtMBf,GesamtKBf:integer;
  GesamtMBs,GesamtKBs:integer;
  Prozent:longint;
  ds,df:real;
  s:String;
  ch:char;
  fi,si,i:Integer;
  F:Real;
 
function SubTreeFiles(Verz : String):LongInt;
var
  sr : SearchRec;
  sum : LongInt;
begin
  sum:=0;
  FindFirst(Verz+'*.*',AnyFile,sr);
  while DosError=0 do begin
    if sr.Attr and Directory=0
      then Inc(Sum)
      else if sr.Name[1]<>'.' then Inc(Sum,SubTreeFiles(Verz+sr.name+'\'));
    FindNext(sr);
  end;
  SubTreeFiles:=Sum;
end;
 
Function VolID(Drive:Char):String;
 
var
  DirInfo: SearchRec;
  ID:String;
 
begin;
  FindFirst(Drive+':\*.*',VolumeID,Dirinfo);
  if DosError=0 then ID:=DirInfo.name
  else ID:='NONAME';
  While Pos('.',ID)<>0 do Delete(ID,Pos('.',ID),1);
  While Length(ID)<11 do ID:=ID+' ';
 
  VolID:=ID;
end;
 
Procedure Free(Drive:Char);
var Size:integer;
    LW:Byte;
 
begin
  Drive:=Upcase(Drive);
  LW:=ord(Drive)-64;
  F:=DiskFree(LW);
  if F<1 then exit;
  ds:=ds+DiskSize(LW);
  df:=df+DiskFree(LW);
  DiskFreeMB:=(DiskFree(LW)  div 1048576);
  DiskFreeKB:=((DiskFree(LW) mod 1048576) div 1024);
  DiskSizeMB:=(DiskSize(LW)  div 1048576);
  DiskSizeKB:=((DiskSize(LW) mod 1048576) div 1024);
  GesamtMBf:=GesamtMBf+DiskFreeMB;
  GesamtKBf:=GesamtKBf+DiskFreeKB;
  GesamtMBs:=GesamtMBs+DiskSizeMB;
  GesamtKBs:=GesamtKBs+DiskSizeKB;
  Prozent:=round((DiskFree(LW)/DiskSize(LW))*100);
  Write(' ',Drive+': ',VolID(Drive),' ',DiskFreeMB:4,' MB ',DiskFreeKB:4,' KB',' (',Prozent:2,'%)',' von ',
  'Insgesamt ',DiskSizeMB:4,' MB ',DiskSizeKB:4,' KB FREI');
  if ParamStr(1)='F' then WriteLn(SubTreeFiles(ch+':\'):6)
  else WriteLn;
end;
 
 
Begin {Hauptprogramm}
  WriteLn('Frei Version 1.7 Copyright 1997 by ...');
  for ch:= 'c' to 'z' do begin Free(ch);end;
  fi:=GesamtKBf div 1024;
  si:=GesamtKBs div 1024;
  GesamtMBf:=GesamtMBf+fi;
  GesamtMBs:=GesamtMBs+si;
  GesamtKBf:=GesamtKBf-(fi*1024);
  GesamtKBs:=GesamtKBs-(si*1024);
  for i:=1 to 71 do Write('-');
  Prozent:=round((df / ds)*100);
  WriteLn;
  WriteLn('Insgesamt:      ',GesamtMBf:4,' MB ',GesamtKBf:4,' KB ','(',Prozent:2,'%)',' von Insgesamt ',
  GesamtMBs:4,' MB ',GesamtKBs:4,' KB FREI ');
End.  {Hauptprogramm}