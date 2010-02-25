#include <stdio.h>
#include <string.h>
#include <windows.h>

#pragma warning ( disable : 4996 ) // disable deprecation

int main( int argc, char** argv )
{
  printf("VSIxg 1.0 - Insomniac Games (Nocturnal Initiative)\n");

  char module[MAX_PATH];
  ::GetModuleFileName( NULL, module, sizeof( module ) );

  char drive[MAX_PATH];
  char dir[MAX_PATH];
  _splitpath( module, drive, dir, NULL, NULL );

  char profile[8192];
  sprintf( profile, "%s%s%s", drive, dir, "VSIxg.xml" );

  char command[8192];
  sprintf( command, "%s%s%s", drive, dir, "snmake.exe" );
  for ( int i = 1; i < argc; i++ )
  {
    strcat( command, " " );
    strcat( command, argv[ i ] );
  }

  char xg[8192];
  sprintf( xg, "xgConsole.exe /command=\"%s\" /profile=\"%s\"", command, profile );

  STARTUPINFO si;
  memset( &si, 0, sizeof(si) );
  PROCESS_INFORMATION pi;
  memset( &pi, 0, sizeof( pi ) );
  if ( !::CreateProcess( NULL,
                         xg,
                         NULL,
                         NULL,
                         TRUE,
                         0x0,
                         NULL,
                         NULL,
                         &si,
                         &pi ) )
  {
    fprintf( stderr, "Unable to create process: %s\n", command );
    exit(1);
  }

  printf("Running: %s\n", xg);
  ::WaitForSingleObject( pi.hProcess, INFINITE );

  DWORD code = 0x0;
  if ( !::GetExitCodeProcess( pi.hProcess, &code ) )
  {
    fprintf( stderr, "Unable to get process exit code: %s\n", command );
    exit(1);
  }

  ::CloseHandle( pi.hProcess );
  ::CloseHandle( pi.hThread );

  return code;
}