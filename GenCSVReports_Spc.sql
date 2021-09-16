
CREATE OR REPLACE PACKAGE pkgMigGenCSVReports
AS

PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2,
                    p_sep        IN  VARCHAR2
				   );

PROCEDURE generate_rc (p_dir        IN  VARCHAR2,
                       p_file       IN  VARCHAR2,
                       p_refcursor  IN OUT SYS_REFCURSOR,
                       p_sep        IN VARCHAR2
					  );

PROCEDURE output (p_query  IN  VARCHAR2);

PROCEDURE output_rc (p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE set_separator (p_sep  IN  VARCHAR2);

PROCEDURE set_quotes (p_add_quotes  IN  BOOLEAN := TRUE,
                      p_quote_char  IN  VARCHAR2 := '"'
					 );

PROCEDURE GenerateCsvReports_Parallel(ipKeyString 		spresulttbl.keystring%TYPE, 
                                      ipMainKeyString 	spresulttbl.keystring%TYPE
									 );

Procedure SpCSVReportExport_wrap(ipTask             dm_querryreporttbl.Task%TYPE,
                                 ipKeyString    	spresulttbl.keystring%TYPE,
								 ipAppdate      	DATE,
								 ipModuleid     	MODULEPROFILETBL.MODULEID%TYPE,
								 ipparllelflag  	NUMBER DEFAULT 1,
								 ipMainkeystring    spresulttbl.keystring%TYPE DEFAULT NULL
								);			

g_out_type    		VARCHAR2(1) := 'F';
g_col_header_on 	VARCHAR2(1) := 'N';
g_sep         		VARCHAR2(5) := ',';
g_add_quotes  		BOOLEAN     := FALSE;
g_quote_char  		VARCHAR2(1) := '"';

END pkgMigGenCSVReports;
/