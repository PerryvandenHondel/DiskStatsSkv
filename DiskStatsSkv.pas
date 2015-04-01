{

	DiskStatsSkv

	Export the current diskstats of the computer running the program to a SKV file

	Script ID = 116


	Splunk config:

		Sourcetype: Manual (value=diskstats)
		App Context: Search and Reporting
		Host: Segment in path (value=3, D:\INDEXEDBYSPLUNK\000116\<hostname>\YYYYmMM.skv hostname=3)
		index: Default (main)
		
		
	VER	DESC
	02	Check for drive types, only show local hard disks
	01	Initial setup
	
}


{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}
{$H+}


program DiskstatsSkv;



uses
	Dos,
	SysUtils,
	StrUtils,
	USplunkFile,
	USupportLibrary,
	Windows;
	
	
	
const
	SCRIPT_ID = 116;
	
	

var
	gchrDrive: char;
	LW: byte;
	intDiskFree: Int64;
	intDiskSize: Int64;
	sf: CSplunkFile;


Function IsDriveLocal(strDriveLetter: string): boolean;
//
//	Returns a true/false if the drive is a local hard disk
//	
//	Source: http://wiki.lazarus.freepascal.org/Windows_Programming_Tips
//
var
	r: boolean;		// Return value
begin
	if GetDriveType(PChar(strDriveLetter)) = DRIVE_FIXED then
		r := true
	else
		r := false;
		
	IsDriveLocal := r;
end;
	
	
procedure ProcessDrive2(d: byte);
var
	drive: string;
begin
	//WriteLn(d);
	drive := Chr(d + 64) + ':';
	WriteLn('drive=', drive);
	
	WriteLn(GetDriveType(PChar(drive)));
	WriteLn;
end;

{	
procedure ProcessDrive(chrDrive: char);

begin
	chrDrive:=Upcase(chrDrive);
	LW:=ord(chrDrive)-64;
	WriteLn(LW);
	intDiskFree := DiskFree(LW);
	if intDiskFree < 1 then 
		exit
	else	
	begin
		WriteLn(Chr(LW + 64) + ':');
		if GetDriveType(PChar(chrDrive) + ':')) = 3 then
		begin
			WriteLn('ProcessDrive(): ', chrDrive, ' = FIXED_DRIVE');
			intDiskSize := DiskSize(LW);
			WriteLn(Chr(9), 'SIZE_', chrDrive, '=', intDiskSize, ' FREE_', chrDrive,'=', intDiskFree, 'LOCAL=');
			sf.SetDate();
			sf.SetStatus('INFO');
			sf.AddKey('disk_size_' + chrDrive, intDiskSize);
			sf.AddKey('disk_free_' + chrDrive, intDiskFree);
			sf.WriteLineToFile();
		end;
	end;
end; // of procedure ProcessDrive
}

procedure ProcessDrive02(chrDrive: char);
var
	intDiskFree: Int64;
	intDiskSize: Int64;
	driveLetter: string;
begin
	driveLetter := chrDrive + ':';
	//WriteLn(driveLetter, ' = ', GetDriveType(PChar(driveLetter)));
	if GetDriveType(PChar(driveLetter)) = 3 then
	begin
		intDiskFree := DiskFree(Ord(driveLetter[1]) - 64);
		//Writeln(intDiskFree);
		//WriteLn(driveLetter, 'LOCAL DRIVE');
		if intDiskFree > 0 then 
		begin
			intDiskSize := DiskSize(Ord(driveLetter[1]) - 64);
			sf.SetDate();
			sf.SetStatus('INFO');
			sf.AddKey('disk_size_' + LowerCase(driveLetter[1]), intDiskSize);
			sf.AddKey('disk_free_' + LowerCase(driveLetter[1]), intDiskFree);
			sf.WriteLineToFile();
			WriteLn('Local drive ', driveLetter, ' has capacity for ', intDiskSize, ' bytes and has ', intDiskFree, ' bytes free.');
		end;
	end;
end; // of procedure ProcessDrive



procedure ProgInit();
var
	p: string;
begin
	p := '\\vm70as006.rec.nsint\INDEXEDBYSPLUNK\' + NumberAlign(SCRIPT_ID, 6) + '\' + GetCurrentComputerName() + '\' + FormatDateTime('YYYY', Now()) + 'M' + FormatDateTime('MM', Now()) + '.skv';
	WriteLn('Writing to SKV file: ' + p);
	sf := CSplunkFile.Create(p);
	sf.OpenFileWrite();
	sf.SetScriptId(SCRIPT_ID);
end; // of procedure ProgInit()



procedure ProgRun();
var
	d: byte;
begin
	{WriteLn(DRIVE_FIXED);
	WriteLn(DRIVE_REMOVABLE);
	WriteLn(Ord('C'));
	//ProcessDrive('c');
	//WriteLn(GetDriveType(PChar('c:')));
	// WriteLn(GetDriveType(PChar('v:')));
		
	for d := 3 To 26 do
		ProcessDrive2(d);
	}
	for gchrDrive := 'C' to 'Z' do 
		begin ProcessDrive02(gchrDrive);
	end;
end; // of procedure ProgRun()



procedure ProgDone();
begin
	sf.CloseFile();
end; // of procedure ProgDone()


	
begin
	ProgInit();
	ProgRun();
	ProgDone();
end. // of program Diskstats

