-----------------------------Transaciton dates 
SELECT FXDTRANID, FXDTTYP, FXDNRMVPD, FXDBCKVPD, FXDDLDTE, FXDENTDTE, FXDDCM,
         (CASE
               WHEN TRIM(D.FXDBCKVPD) IS NOT NULL AND D.FXDNRMVPD > D.FXDBCKVPD THEN  D.FXDBCKVPD --backdate case 
               WHEN TRIM(D.FXDNRMVPD) IS NULL THEN    D.FXDBCKVPD --backdate case
               ELSE     D.FXDDLDTE  END) TRANSACTIONDATE,
         (CASE
                  WHEN NVL(FXDNRMVPD,     FXDDLDTE) > TO_DATE('23-AUG-2019') THEN TO_DATE('23-AUG-2019')
                  ELSE  NVL(FXDNRMVPD,FXDDLDTE)
         END) DATEALLOTED,
         (CASE
               WHEN TRIM(D.FXDBCKVPD) IS NOT NULL AND D.FXDNRMVPD > D.FXDBCKVPD THEN  D.FXDBCKVPD
               WHEN TRIM(D.FXDNRMVPD) IS NULL THEN    D.FXDBCKVPD
               WHEN TRIM(D.FXDBCKVPD) IS NULL THEN    D.FXDNRMVPD
               ELSE     D.FXDDLDTE
         END) FROMFUNDPRICEDATE, D.*
  FROM FXD D
WHERE fxduhaccn='0003626320' AND fxdfund='ERA'
	--FXDTRANID IN ('0123517482','0123324115','0123238414','0123250826','0222576527','0122576527','0122600132','0123788260')
   AND TRIM(D.FXDCNCVPD) IS NULL
ORDER BY FXDGRPID



SELECT a.frompricedate, a.* From consolidatedtxntbl a WHERE referencenumber LIKE '%0323320250'

SELECT * From divequnitsledgertbl WHERE transactionnumber='0220190090003536'
------------------------------------Unsettled Inflow with otuflos--------------------------
SELECT * From Uhbeneficiariestbl

SELECT * From fxd WHERE fxdfund='G2I' 
--AND NVl(FXDBCKVPD,FXDDLDTE) <='18-APr-2018' AND 
AND fxduhaccn IN ('0003040651','0003555399')
 AND FXDREGSTA='U'
SELECT * From fxd WHERE fxdtranid='0122003406'
SELECT * From  consolidatedtxntbl WHERE fundid='G2I' AND transactiondate='18-apr-2018'
0340122003406

SELECT TRANSACTIONDATE, TRANSACTIONTYPE, FUNDID, COUNT(1)
  FROM CONSOLIDATEDTXNTBL A
 WHERE EXISTS (SELECT COUNT(1)
		  FROM AGEINGTBL X, CONSOLIDATEDTXNTBL Y
		 WHERE LINKTRANSACTIONNUMBER = Y.TRANSACTIONNUMBER
		   AND X.TRANSACTIONNUMBER = A.TRANSACTIONNUMBER
		   AND Y.PROVISIONALFLAG = 'P'
)
   AND TRANSACTIONTYPE IN ('03','05','04')
--   AND FUNDID = 'G2I'
 GROUP BY TRANSACTIONDATE, TRANSACTIONTYPE, FUNDID
 ORDER BY 1;

SELECT * FROM FXB WHERE FXBUHACCN='0003624804' AND fxBfund='AX2' 
SELECT * From FXD WHERE FXDUHACCN='0003624804' AND fxdfund='AX2' AND FXDCNCVPD IS NULL
0340122003406
0340122003460

WITH 
uh_fun_max_unreg AS (
SELECT FXDMCID MCID,fxduhaccn uhaccn,fxdfund FUND,MAX(NVl(FXDBCKVPD,FXDDLDTE)) MAX_unregdate 
  From fxd 
 WHERE FXDREGSTA='U' AND FXDCNCVPD IS NULL
   AND FXDTTYP in ('OB','01','05','07','09','10','11','13','26','31','32','35','38','41')
GROUP BY fxduhaccn,fxdfund,FXDMCID)
SELECT * From FXD ,uh_fun_max_unreg
WHERE NVl(FXDBCKVPD,FXDDLDTE)>= MAX_unregdate--(SELECT MAX_unregdate From uh_fun_max_unreg WHERE uhaccn=FXDUHACCN AND FUND=FXDFUND)
 AND uhaccn=FXDUHACCN 
AND FUND=FXDFUND 
AND MCID=fxdmcid 
--AND FUND = 'G2I' 
AND FXDCNCVPD IS NULL AND FXDDLDTE<'20-AUG-2019'
 AND FXDTTYP NOT in ('OB','01','05','07','09','10','11','13','26','31','32','35','38','41') ORDER BY FXDDLDTE DESC

------------------------------------unsettled inflow with outflows-----------------------------

----------------------------add info master value list --------------------------------

SELECT a.ADDINFOLABEL
, ADDINFODESCRIPTION,RESTRICTIVELIST, ADDINFODATATYPE
--LINKPARAMCODE, LINKTOPARAMS,
From entityaddinfomaptbl a, addinfomastertbl b
WHERE entitytype='U' 
AND a.ADDINFOLABEL=b.ADDINFOLABEL
ORDER BY recordnumber




SELECT a.ADDINFOLABEL
, ADDINFODESCRIPTION,RESTRICTIVELIST, ADDINFODATATYPE,ADDINFOVALIDVALUE, ADDINFOVALIDVALUEDESCRIPTION, DEFAULTLABEL 
--LINKPARAMCODE, LINKTOPARAMS,
From entityaddinfomaptbl a, addinfomastertbl b,addinfovalidvaluestbl c
WHERE entitytype='U' 
AND a.ADDINFOLABEL=b.ADDINFOLABEL
AND a.ADDINFOLABEL=c.ADDINFOLABEL(+)
AND nvl(c.languagecode,'1033')='1033'
ORDER BY recordnumber

----------------------------add info master value list ----------------------------------


----RE: UKTA-12772 - TPR -> Redemptions ->Linked To Unsettled Inflows (Red) to be set No

SELECT TRANSACTIONDATE, transactiontype, FUNDID,COUNT(1)
 From consolidatedtxntbl a WHERE EXISTS (SELECT * From ageingtbl x,
consolidatedtxntbl y WHERE linktransactionnumber =a.transactionnumber  AND x.transactionnumber =y.transactionnumber  AND y.provisionalflag='P')
AND transactiontype IN ('03','05','04')
GROUP BY TRANSACTIONDATE, transactiontype, FUNDID ORDER BY 1
;

SELECT TRANSACTIONDATE, transactiontype, FUNDID,COUNT(1)
 From consolidatedtxntbl a WHERE EXISTS (  SELECT *  FROM AGEINGTBL X, CONSOLIDATEDTXNTBL Y
		 WHERE LINKTRANSACTIONNUMBER = Y.TRANSACTIONNUMBER
		   AND X.TRANSACTIONNUMBER = A.TRANSACTIONNUMBER
		   AND Y.PROVISIONALFLAG = 'P')
AND transactiontype IN ('03','05','04')
GROUP BY TRANSACTIONDATE, transactiontype, FUNDID ORDER BY 1
;

SELECT X.TRANSACTIONNUMBER, X.LINKTRANSACTIONNUMBER, Y.TRANSACTIONNUMBER,
	   PROVISIONALFLAG
  FROM AGEINGTBL X, CONSOLIDATEDTXNTBL Y
 WHERE LINKTRANSACTIONNUMBER = Y.TRANSACTIONNUMBER
 -- AND X.TRANSACTIONNUMBER = A.TRANSACTIONNUMBER
AND x.LINKTRANSACTIONNUMBER<>X.TRANSACTIONNUMBER
   AND Y.PROVISIONALFLAG = 'P'

SELECT fxdregsta, COUNT(1) From fxd a GROUP BY fxdregsta

SELECT transactiontype,provisionalflag,COUNT(1),MIN(TRANSACTIONDATE), MAX(TRANSACTIONDATE) From consolidatedtxntbl WHERE provisionalflag='P'
GROUP BY transactiontype,provisionalflag

SELECT TRANSACTIONDATE, transactiontype, FUNDID,COUNT(1)
 From consolidatedtxntbl a 
WHERE provisionalflag='P'
--AND transactiontype IN ('03','05')
GROUP BY TRANSACTIONDATE, transactiontype, FUNDID

------RE: UKTA-12772 - TPR -> Redemptions ->Linked To Unsettled Inflows (Red) to be set No
--UKTA-12828:UAT-MDR5-RSP BACs error Report - showing Fund Restricted
SELECT fxbfund,FXBPROD, Q02PDDESC,COUNT(1)  COUNT_UH_FND
  From fxb a,(SELECT DISTINCT Q02PRODCDE, Q02PDDESC From OFFXREFQ02 ) b 
 WHERE (FXBTOTSU+FXBTOTUN)>0 
   AND Q02PRODCDE=FXBPROD 
		--a.fxbfund='IAA' AND 
AND NOT EXISTS (SELECT * From fundinvestmentaccounttbl a WHERE ACCOUNTTYPE IN ('IS','AP')
				AND ruleeffectivedate = (SELECT max(ruleeffectivedate) From fundinvestmentaccounttbl b WHERE a.fundid=b.fundid)
				AND fundid =fxbfund )
AND upper(Q02PDDESC) LIKE '%ISA%'
GROUP BY fxbfund,FXBPROD, Q02PRODCDE, Q02PDDESC
ORDER BY 1
--UAT-MDR5-RSP BACs error Report - showing Fund Restricted

----------------------------ISA limits issue 

SELECT * From ACCOUNTTYPEDETAILSTBL
SELECT * From ACCTYPREFTYPESTBL
SELECT * From fxd WHERE fxdgrpid='0023507987'---OI0340123507987
SELECT * FROM consolidatedtxntbl WHERE unitholderid= 'UKTRA9811786'
SELECT * From dmt_paramstbl
fxdtranid='0123507987'
SELECT * From Oneleggedtrfrdetailstbl WHERE referenceno LIKE '%23507987%'
SELECT * From Oneleggedtransfertbl WHERE referenceno LIKE '%23507987%'

SELECT * From Oneleggedtransfertbl WHERE unitholderid= 'UKTRA9811786'
SELECT * From Limitutilizationtbl WHERE unitholderid='UKTRA9824037'
SELECT * From  user_dependencies where referenced_name like '%LIMITUT%' 
SELECT * From VW_LIMITUTILIZATION_CUSTOM WHERE unitholderid='UKTRA9824037'

SELECT * From Limitutilizationtbl@11.HDEV
MINUS
SELECT * From Limitutilizationtbl
---------------------------------Fund UnitholderId balance --------------------------------------------------------------
WITH UH_FUND_BAL AS (
SELECT a.unitholderid,A.FUNDID, B.UNITBALANCE, B.PROVISIONALUNITS, B.BLOCKEDUNITS,
	   SUM(DECODE(SETTLED,
				   'Y',
				   UNITSIN - UNITSOUT,
				   0)) BALLEDGER_SETTLED_BAL,
	   SUM(DECODE(SETTLED,
				   'N',
				   UNITSIN - UNITSOUT,
				   0)) BELLEDGER_UNSETTLED_BAL,
	   SUM(UNITSIN - UNITSOUT) BALLEDGER_BAL
  FROM UHBALLEDGERTBL A, UNITHOLDERFUNDTBL B
 WHERE A.FUNDID = B.FUNDID(+) --outter join only for ruling out migration issues
 AND a.unitholderid=b.unitholderid--outter join only for ruling out migration issues
 GROUP BY a.unitholderid,A.FUNDID, B.UNITBALANCE, B.PROVISIONALUNITS,B.BLOCKEDUNITS)
,Fund_Bal AS (
SELECT FUNDID, SUM(UNITBALANCE) UNITBALANCE, SUM(PROVISIONALUNITS) PROVISIONALUNITS, SUM(BLOCKEDUNITS) BLOCKEDUNITS,
SUM(UNITBALANCE+PROVISIONALUNITS+PROVISIONALUNITS) Total_Units ,SUM(BALLEDGER_SETTLED_BAL) BALLEDGER_SETTLED_BAL,SUM(BALLEDGER_BAL) BALLEDGER_BAL
 From UH_FUND_BAL
GROUP BY FUNDID) 
SELECT * From 
   -- UH_FUND_BAL -- UH fund level balance 
    Fund_Bal -- fund level balance 
WHERE fundid='AHGB' AND BALLEDGER_BAL<>(UNITBALANCE + PROVISIONALUNITS); 
---comment the table based on the data required 
---------------------------------Fund UnitholderId balance --------------------------------------------------------------
SELECT * From sttm_custfatca_details WHERE TAXCERTIFICATEEXPDATE IS NOT NULL  ORDER BY TAXCERTIFICATEEXPDATE desc
SELECT * From Sttm_Custfatca_Details
----------------------------------------FXD FXB Balance check ----------------------------------------------------
WITH FXD_BAL AS (
SELECT FXDMCID,FXDUHACCN,FXDPROD,FXDFUND,FXDPHISEQ,
				SUM(CASE
						WHEN FXDTTYP in ('OB','01','05','07','09','10','11','13','26','31','32','35','38','41')
 						THEN
						 NVL((FXDGR1UTS + FXDGR2UTS) ,0)* 1
						ELSE
						 NVL((FXDGR1UTS + FXDGR2UTS) ,0) * -1
					END) FXD_BALANCE
		   FROM FXD 
WHERE  trim(FXDCNCVPD) IS NULL--AND (A.FXDNRMVPD IS NOT NULL OR A.FXDBCKVPD IS NOT NULL)
			--AND A.FXDREASON = ' ' -- added by AJS
Group By FXDMCID, FXDUHACCN, FXDPROD, FXDFUND,FXDPHISEQ)
,FXB_BAL AS (SELECT FXBMCID,FXBUHACCN,FXBPROD,FXBFUND,FXbPHISEQ,SUM(B.FXBTOTSU + B.FXBTOTUN) FXB_BAL,
				sum(B.FXBTOTSU) FXBTOTSU, sum(B.FXBTOTUN) FXBTOTUN
		   FROM FXB B
		   GROUP BY FXbMCID, FXbUHACCN, FXbPROD, FXbFUND,FXbPHISEQ)
SELECT FXBMCID, FXBUHACCN, FXBPROD, FXBFUND, FXBPHISEQ, FXB_BAL, FXBTOTSU, FXBTOTUN, FXD_BALANCE
From FXB_BAL A,FXD_BAL B
WHERE  B.FXDMCID(+) = A.FXBMCID
   AND B.FXDUHACCN(+) = A.FXBUHACCN
   AND B.FXDFUND(+) = A.FXBFUND
   AND B.FXDPROD (+)= A.FXBPROD
   AND B.FXDPHISEQ (+) = A.FXBPHISEQ
   AND A.FXBFUND = NVL('',FXBFUND)
  --AND fxbuhaccn IN( '0003555603') and    fxbfund IN ('IIG') 
   AND NVL((FXBTOTSU + FXBTOTUN), 0) != NVL(B.FXD_BALANCE, 0)


15131.57 15131.570000000000
SELECT * From FXD WHERE fxduhaccn IN( '0003555603') and    fxdfund IN ('IIG') 
36.82
SELECT * From dm_unitholderreferencetbl WHERE DSTUNITHOLDERID ='0003555603'
SELECT * From FXb  WHERE fxbuhaccn IN( '0003555603') and    fxbfund IN ('IIG') 

SELECT * From DM_UNITHOLDERREFERENCETBL WHERE  GTAPUnitholderid = 'UKTRA9882099' 
SELECT * From unitholderfundtbl WHERE unitholderid='UKTRA9862863'  And Fundid = 'IIG';
SELECT * From consolidatedtxntbl  WHERE referencenumber LIKE '%0123788260%'
------------------------------------------------------------------------------------------------------------------
----ageing---------------------

SELECT COUNT(1) From ageingtbl
SELECT COUNT(1) From ageinghierarchytbl
SELECT * From ageingtbl a WHERE NOT EXISTS (SELECT * From ageinghierarchytbl b WHERE 
a.transactionnumber=b.transactionnumber AND a.linktransactionnumber=b.linktxnnumber)
SELECT * FROM ageinghierarchytbl Where AGENTCODE Is Null Or BRANCHCODE Is Null Or ACCOUNTOFFICER Is Null Or IFA Is Null;



Select * From Fxd Where Fxduhaccn = '0003623426' And Fxdfund = 'DZA';
SELECT * From fxd WHERE Fxduhaccn = '0003623426' And Fxdfund = 'DZA';
Select * From consolidatedtxntbl Where Unitholderid = 'UKTRA9882099' And Fundid = 'GR3';
SELECT * From DM_UNITHOLDERREFERENCETBL WHERE  GTAPUnitholderid = 'UKTRA9882099' 
SELECT * From unitholderfundtbl WHERE unitholderid='UKTRA9862498'  And Fundid = 'GR3';
----------------------------------dupe GTAP-----------------------------------

----ageing--------------------------

----------------------------------dupe GTAP-----------------------------------
--get the UnitholderId list with HASH as concatination of key columns
--TITLE || FIRSTNAME || MIDDLENAME || LASTNAME || IDENTIFICATIONTYPE ||IDENTIFICATIONNUMBER || NVL(DESIGNATION,'#') || ACCOUNTOPERATIONTYPE ||UHACCOUNTTYPE || J1 || J2 
WITH UH_LIST AS
 (SELECT A.UNITHOLDERID,CIFNUMBER, A.REFERENCENUMBER, TITLE, FIRSTNAME, MIDDLENAME,
		 LASTNAME, INVESTORTYPE, IDENTIFICATIONTYPE, IDENTIFICATIONNUMBER,EXTERNALREFERENCEID ,
		 NVL(DESIGNATION,'#') DESIGNATION, ACCOUNTOPERATIONTYPE, UHACCOUNTTYPE, J1, J2,
			TITLE || FIRSTNAME || MIDDLENAME || LASTNAME || IDENTIFICATIONTYPE ||IDENTIFICATIONNUMBER || 
			NVL(DESIGNATION,'#') || ACCOUNTOPERATIONTYPE ||UHACCOUNTTYPE || J1 || J2 HASH
  --     ,COUNT(1)
	FROM UNITHOLDERTBL A, UNITHOLDERTBL_CUSTOM B, UNITHOLDERINFOTBL C,
		--get J1 J2 for applicable UnitholderId 
		 (SELECT *
			 FROM (SELECT UNITHOLDERID, REFERENCENUMBER, BENEFICIARYID,
						   BENEFICIARYTYPE
					  FROM UHBENEFICIARIESTBL) PIVOT(MAX(BENEFICIARYID) FOR BENEFICIARYTYPE IN('J1' AS J1, 'J2' AS J2))) D
   WHERE A.UNITHOLDERID = B.UNITHOLDERID
	 AND B.UNITHOLDERID = C.UNITHOLDERID
	 AND A.UNITHOLDERID = D.UNITHOLDERID(+) --all UnitholderId may not have J1,j2
	),
--get duplicate base the hash
DUP_HASH AS
 (SELECT lower(HASH) HASH, COUNT(1) COUNT FROM UH_LIST GROUP BY lower(HASH) HAVING COUNT(1) > 1)
--use duplicate UnitholderId hash to get the UHIDS which have corresponding hash
SELECT UNITHOLDERID, REFERENCENUMBER,CIFNUMBER,SUBSTR(REFERENCENUMBER,1,10) DST_UH,EXTERNALREFERENCEID DST_CIF,UHACCOUNTTYPE, TITLE, FIRSTNAME, MIDDLENAME, LASTNAME,
	   INVESTORTYPE, IDENTIFICATIONTYPE, IDENTIFICATIONNUMBER, DESIGNATION,
	   ACCOUNTOPERATIONTYPE,  J1, J2, COUNT
  FROM UH_LIST, DUP_HASH
 WHERE lower(UH_LIST.HASH) = lower(DUP_HASH.HASH)
 ORDER BY INVESTORTYPE, DUP_HASH.HASH

----------------------------------dupe gtap-------------------------------------
--------------------Entity ---------------------------
	One FSA shared by as many as 200+ individual enitty/agents and 
SELECT FXQFSA,COUNT(1) From FXQ a  WHERE Decode(nvl(trim(FXQFSA),'#'),'#','N','Y')='Y'
AND EXISTS (SELECT * From dm_entityreferencetbl WHERE entityid=fxqagent AND  dstamcid=fxqmcid)
GROUP BY FXQFSA HAVING COUNT(1)>1;

SELECT FXQFSA,FXQPARENT,a.* From fxq a  WHERE fxqfsa='150427'
AND EXISTS (SELECT * From dm_entityreferencetbl WHERE entityid=fxqagent AND  dstamcid=fxqmcid)

	FCA number provided by no UK domicile / Ireland cases 



WITH FCA_COUNTS AS
 (SELECT FXQCTRY,
		NVL(TRIM(CNTRY.FCISPARAMTEXT),'UNK') COUNTRYOFDOMICILE,
		 DECODE(NVL(TRIM(FXQFSA), '#'), '#', 'FCA_NOT_PROVIDED', 'FCA_PROVIDED') AS "FCA_PROVIDED",
		 COUNT(1) COUNTS
	FROM FXQ A,(SELECT DSTPARAMVALUE,FCISPARAMTEXT FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='COUNTRYCODES') CNTRY
   WHERE EXISTS (SELECT *
			FROM DM_ENTITYREFERENCETBL
		   WHERE ENTITYID = FXQAGENT
			 AND DSTAMCID = FXQMCID)
    AND FXQCTRY  = DSTPARAMVALUE(+)
   GROUP BY FXQCTRY, DECODE(NVL(TRIM(FXQFSA), '#'), '#', 'FCA_NOT_PROVIDED', 'FCA_PROVIDED'),NVL(TRIM(CNTRY.FCISPARAMTEXT),'UNK'))
SELECT * FROM FCA_COUNTS PIVOT(SUM(COUNTS) FOR FCA_PROVIDED IN('FCA_PROVIDED', 'FCA_NOT_PROVIDED') )
ORDER BY COUNTRYOFDOMICILE
--SELECT * FROM FCA_COUNTS 
--row to colum pivot
SELECT * FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='COUNTRYCODES'
select * from olympic_medal_winners
pivot ( 
  count(*) for medal in ( 'Gold' gold, 'Silver' silver, 'Bronze' bronze )
)
order by noc
fetch first 6 rows only;

SELECT FXQFSA,COUNT(1) From FXQ a  WHERE Decode(nvl(trim(FXQFSA),'#'),'#','N','Y')='Y'
AND EXISTS (SELECT * From dm_entityreferencetbl WHERE entityid=fxqagent AND  dstamcid=fxqmcid)
GROUP BY FXQFSA HAVING COUNT(1)>1

SELECT FXQFSA,FXQPARENT,a.* From fxq a  WHERE fxqfsa='150427'
AND EXISTS (SELECT * From dm_entityreferencetbl WHERE entityid=fxqagent AND  dstamcid=fxqmcid)

---------------------------Entity----------------------------------


--------------UnitholderId addinof
SELECT * From paramstbl WHERE UPPER(paramtext) LIKE '%JOIN%' AND paramlanguage='1033'
SELECT * From  cstb_lov_info WHERE function_id='UTDUH' ORDER BY LOV_id
SIGNING_CONDITION
SELECT * From addinfolablestbl WHERE languagecode='1033'
SELECT * From addinfomastertbl WHERE addinfolabel='SIGNING_CONDITION'
SELECT * From entityaddinfomaptbl WHERE entitytype='U' AND addinfolabel='SIGNING_CONDITION'
SELECT * From uhaddinfomastertbl
SELECT * From unitholderaddinfotblb
--------------UnitholderId Addinof 
------------FATCA uS
SELECT DISTINCT  dstcustomerid,gtapcustomerid, DSTAMCCODE From fxp,(SELECT DISTINCT dstcustomerid,gtapcustomerid, DSTAMCCODE  From  dm_unitholderreferencetbl)
 WHERE fxpctry='USA' AND 
	dstcustomerid=FXPEXCLNT AND 
DSTAMCCODE=FXPMCID  
ORDER BY  dstcustomerid 


WITH 
client_list AS (SELECT * From fxp,(SELECT DISTINCT dstcustomerid,gtapcustomerid, DSTAMCCODE  From  dm_unitholderreferencetbl)
 WHERE fxpctry='USA' AND 
	dstcustomerid=FXPEXCLNT AND 
DSTAMCCODE=FXPMCID  
ORDER BY  fxpexclnt )
,GTAP_FATCA AS (SELECT dstcustomerid,gtapcustomerid, DSTAMCCODE,FATCACLASSIFICATION,FATCACLASSIFICATIONREASON 
				From FATCAMAINTHDRTBL,client_list
				WHERE FATCAENTITYID=gtapcustomerid)
,DST_FATCA AS (SELECT PF.* 
                 FROM FXPF PF,client_list P,
                             (SELECT DISTINCT DSTCUSTOMERID,DSTAMCCODE,GTAPCUSTOMERID FROM DM_UNITHOLDERREFERENCETBL WHERE DEDUPE = 'N')DM,
                             (SELECT DSTPARAMVALUE,FCISPARAMVALUE FROM DMT_PARAMSTBL WHERE FCISPARAMCODE = 'INVESTORTYPE') INVTYP,
                             (SELECT DSTPARAMVALUE, DSTPARAMTEXT,FCISPARAMVALUE, FCISPARAMTEXT FROM DMT_PARAMSTBL WHERE FCISPARAMCODE IN ('FATCACATIND','FATCACATCOR')) FATCACLASSIFICATION
                        WHERE PF.FXPFEXCLNT = 	P.FXPEXCLNT
                          AND PF.FXPFMCID   = 	P.FXPMCID
                          AND PF.FXPFSSCOD	=	P.FXPSSCOD
                          AND PF.FXPFEXCSEQ =   P.FXPEXCSEQ		  
                          AND P.FXPEXCLNT 	= 	DM.DSTCUSTOMERID
                          AND P.FXPMCID   	= 	DM.DSTAMCCODE
                          AND P.FXPTYPE   	= 	INVTYP.DSTPARAMVALUE
                          AND PF.FXPFCAT    =   FATCACLASSIFICATION.DSTPARAMTEXT
                          AND PF.FXPFAGTYP  =   FATCACLASSIFICATION.DSTPARAMVALUE
                          --AND PF.FXPFAGTYP IN ('01','02')
                          AND PF.FXPFCDATE  = (SELECT MAX(FXPFCDATE)
                                               FROM FXPF
                                               WHERE FXPFMCID   = PF.FXPFMCID
                                                 AND FXPFSSCOD  = PF.FXPFSSCOD 
                                                 AND FXPFEXCLNT = PF.FXPFEXCLNT
                                                 AND FXPFEXCSEQ = PF.FXPFEXCSEQ
                                                 AND FXPFCAT    = PF.FXPFCAT
                                                 AND FXPFAGTYP  = PF.FXPFAGTYP
							   )
						AND FATCACLASSIFICATION.FCISPARAMVALUE IS NOT NULL )
SELECT DISTINCT DSTCUSTOMERID, GTAPCUSTOMERID, DSTAMCCODE, FATCACLASSIFICATION, FATCACLASSIFICATIONREASON,FXPFMCID, FXPFEXCLNT, FXPFCAT
From DST_FATCA,GTAP_FATCA
WHERE dstcustomerid=FXPFEXCLNT  AND 
	  DSTAMCCODE=FXPFMCID 
------------FAATCA US
-------country wise client counts-------------------------
WITH 
fxp_ctr AS (SELECT fxpctry,COUNT(DISTINCT  FXPEXCLNT||FXPMCID) DST_CLNT_COUNT From fxp WHERE 
	EXISTS (SELECT * From  dm_unitholderreferencetbl  WHERE FXPEXCLNT=DSTCUSTOMERID AND FXPMCID=DSTAMCCODE)
	GROUP BY fxpctry),
ctry_desc AS (SELECT * From dmt_paramstbl WHERE FCisparamcode LIKE '%COUNTRY%')
,Ctry_wise AS (SELECT * From fxp_ctr,ctry_desc
WHERE fxpctry=DSTPARAMVALUE(+))
SELECT   FCISPARAMVALUE, FCISPARAMTEXT,  sum (DST_CLNT_COUNT) DST_CLNT_COUNT  From  Ctry_wise
GROUP BY FCISPARAMVALUE, FCISPARAMTEXT
ORDER BY 2

--IRAN
SELECT * From fxp WHERE fxpctry='IR'
SELECT * From dm_unitholderreferencetbl WHERE dstcustomerid='34013377'
SELECT * From fxd WHERE  fxduhaccn IN ('0003016071','0003540316')
SELECT * From fxd_hist WHERE  fxduhaccn IN ('0003016071','0003540316')
SELECT * From fxb WHERE fxbuhaccn IN ('0003016071','0003540316')
Select * FROM consolidatedtxntbl WHERE unitholderid IN ('UKTRA9898018','UKTRA9881281')

-----AMC_rebate____________________________
SELECT * From  fx_AgreementData FOR UPDATE;
SELECT * From  fx_AgreementOverviewData FOR UPDATE;
SELECT * From  fx_UnitholderData FOR UPDATE;
SELECT * From Sttm_Customer
SELECT * From sttm_cus
SELECT * From dm_unitholderr


SELECT MAX(LENGTH(HISTORYTEXT)) From FX_AGREEMENTDATA
SELECT * From fx_AgreementData
SELECT * From FX_AGREEMENTOVERVIEWDATA
SELECT * From FX_UNITHOLDERDATA
SELECT * From FX_FUNDDATA
SELECT * From FX_FUNDGROUPDATA


SELECT 'FX_AGREEMENTDATA' tbl, COUNT(1) From fx_AgreementData
UNION ALL 
SELECT 'FX_AGREEMENTOVERVIEWDATA' tbl, COUNT(1) From FX_AGREEMENTOVERVIEWDATA
UNION ALL 
SELECT 'FX_UNITHOLDERDATA' tbl, COUNT(1) From FX_UNITHOLDERDATA
UNION ALL 
SELECT 'FX_FUNDDATA' tbl, COUNT(1) From FX_FUNDDATA
UNION ALL 
SELECT 'FX_FUNDGROUPDATA' tbl, COUNT(1) From FX_FUNDGROUPDATA

SELECT * From  FX_UNITHOLDERDATA

TRUNCATE TABLE FX_AGREEMENTOVERVIEWDATA ;
TRUNCATE TABLE fx_AgreementData;
TRUNCATE TABLE FX_UNITHOLDERDATA ;
SELECT * From FX_FUNDDATA;
SELECT * From FX_FUNDGROUPDATA;

SELECT * From DM_UHMIGRATIONTBL

SELECT * From FX_AGREEMENTDATA
GRANT READ ON fx_AgreementData TO GTA01_SUP_RO;
GRANT READ ON FX_AGREEMENTOVERVIEWDATA TO GTA01_SUP_RO;
GRANT READ ON FX_UNITHOLDERDATA TO GTA01_SUP_RO;
GRANT READ ON FX_FUNDDATA TO GTA01_SUP_RO;
GRANT READ ON FX_FUNDGROUPDATA TO GTA01_SUP_RO;

SELECT * From fx_AgreementData
CREATE OR REPLACE SYNONYM fx_AgreementData FOR GTASTGPA1.fx_AgreementData;
CREATE OR REPLACE SYNONYM FX_AGREEMENTOVERVIEWDATA FOR GTASTGPA1.FX_AGREEMENTOVERVIEWDATA;
CREATE OR REPLACE SYNONYM FX_UNITHOLDERDATA FOR GTASTGPA1.FX_UNITHOLDERDATA;
CREATE OR REPLACE SYNONYM FX_FUNDDATA FOR GTASTGPA1.FX_FUNDDATA;
CREATE OR REPLACE SYNONYM FX_FUNDGROUPDATA FOR GTASTGPA1.FX_FUNDGROUPDATA;


sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control='/gtaplocal/GTAP_MDR_INFILES/Control_Files/FX_AGREEMENTDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/Spool/GBP_FX_AGREEMENTDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/AgreementData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_AGREEMENTDATA.CSV"

--loader with line feed in between
"replace(:HistoryText, chr(13)||chr(10), '..')"
"str ,x'0A'"
"str ',\n'"

-----AMC_rebate____________________________
---------------------Dedupe---------------------------------------------
UPDATE DM_DEDUPLICATECHECKAGENTTBL SET DD_AGENTLIST=REPLACE(DD_AGENTLIST,',',';')
UPDATE DM_DEDUPLICATECHECKCRPTBL SET DD_ClientList=REPLACE(DD_ClientList,',',';')
UPDATE DM_DEDUPLICATECHECKTBL SET DD_ClientList=REPLACE(DD_ClientList,',',';')

---------------------Dedupe---------------------------------------------

--last update in table
select max(ora_rowscn), scn_to_timestamp(max(ora_rowscn)) from GTAUKTR1.INCOMEDISTRIBUTIONSSETUPTBL;
---
---relationship
---relationship--Mon 7/22/2019 12:21 PM  Navin 
WITH 
relationships AS 
	(--SELECT * FROM DMT_PARAMSTBL WHERE FCISPARAMCODE = 'RELATIONSHIP' AND DSTPARAMTEXT NOT IN ('SINGLE', 'PRIMARY', 'JOINT')
        SELECT a.*,PARAMTEXT FCIS_RELATIONSHIP_DESC FROM DMT_PARAMSTBL a,
        (SELECT * From Paramstbl WHERE PARAMCODE='RELATIONSHIP' AND paramlanguage='1033') b
        WHERE FCISPARAMCODE = 'RELATIONSHIP' AND DSTPARAMTEXT NOT IN ('SINGLE', 'PRIMARY', 'JOINT')
         AND PARAMVALUE(+)=FCISPARAMVALUE
	)
,FXX_ROLES AS
    (SELECT *
          FROM FXX A,
                relationships
       WHERE EXISTS (SELECT 1
                      FROM DM_UNITHOLDERREFERENCETBL
                   WHERE DSTUNITHOLDERID = FXXUHACCN AND GTAPUNITHOLDERID IS NOT NULL and FXXMCID = DSTAMCCODE)
          AND (FXXENDDT IS NULL OR
                FXXENDDT > TO_DATE('23-Aug-2019', 'dd-mon-yyyy'))
          AND DSTPARAMTEXT = FXXROLE
          AND FXXROLE NOT IN ('SINGLE', 'PRIMARY', 'JOINT'))
,DST_ROLES AS
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP,FCISPARAMVALUE FCIS_REL,COUNT(DISTINCT FXPEXCLNT) COUNT_DST
          FROM FXP, FXX_ROLES
       WHERE FXPEXCLNT = FXXEXCLNT
       GROUP BY DSTPARAMTEXT,FCISPARAMVALUE,FCIS_RELATIONSHIP_DESC)
,FCIS_ROLES AS
    (SELECT RELATIONSHIP FCIS_REL, COUNT(DISTINCT RPID) COUNT_GTAP_RPID,COUNT(DISTINCT RPLINKID) COUNT_GTAP_UH
          FROM RELATEDPARTYLINKMAPTBL_CUSTOM
       WHERE RELATIONSHIP IS NOT NULL
       GROUP BY RELATIONSHIP)   
,DST_COUNT AS 
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP, relationships.FCISPARAMVALUE FCIS_REL,FCIS_RELATIONSHIP_DESC,COUNT_DST,0 COUNT_GTAP_RPID,0 COUNT_GTAP_UH
      FROM DST_ROLES,relationships
      WHERE DSTPARAMTEXT=DST_RELATIONSHIP(+))
,FCIS_COUNT AS 
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP, relationships.FCISPARAMVALUE FCIS_REL,FCIS_RELATIONSHIP_DESC,0 COUNT_DST,COUNT_GTAP_RPID,COUNT_GTAP_UH
      FROM FCIS_ROLES,relationships
      WHERE FCISPARAMVALUE=FCIS_REL(+)) 
SELECT DST_RELATIONSHIP,
	   FCIS_REL,
	   FCIS_RELATIONSHIP_DESC,
	   SUM(COUNT_DST) COUNT_DST,
	   SUM(COUNT_GTAP_RPID) COUNT_GTAP_RPID,
	   SUM(COUNT_GTAP_UH) COUNT_GTAP_UH
  FROM (SELECT * FROM DST_COUNT 
  		UNION ALL SELECT * FROM FCIS_COUNT)
 GROUP BY DST_RELATIONSHIP, FCIS_REL ,FCIS_RELATIONSHIP_DESC 
 ORDER BY   DST_RELATIONSHIP, FCIS_REL 

 
SELECT RPLINKID, RPID, RPLINKLEVEL, UNITHOLDERID, CIFNUMBER, LINKAGELEVEL, RELATIONSHIP, paramtext RELATIONSHIP_DESC
 From RELATEDPARTYLINKMAPTBL_CUSTOM a,
(SELECT * From Paramstbl WHERE PARAMCODE='RELATIONSHIP' AND paramlanguage='1033'
)
WHERE RELATIONSHIP=PARAMVALUE(+)
 --- with investor type 
 WITH 
relationships AS 
	(SELECT * FROM DMT_PARAMSTBL WHERE FCISPARAMCODE = 'RELATIONSHIP' AND DSTPARAMTEXT NOT IN ('SINGLE', 'PRIMARY', 'JOINT'))
,FXX_ROLES AS
    (SELECT *
          FROM FXX A,
                relationships
       WHERE EXISTS (SELECT 1
                      FROM DM_UNITHOLDERREFERENCETBL
                   WHERE DSTUNITHOLDERID = FXXUHACCN AND GTAPUNITHOLDERID IS NOT NULL and FXXMCID = DSTAMCCODE)
          AND (FXXENDDT IS NULL OR
                FXXENDDT > TO_DATE('14-jun-2019', 'dd-mon-yyyy'))
          AND DSTPARAMTEXT = FXXROLE
          AND FXXROLE NOT IN ('SINGLE', 'PRIMARY', 'JOINT'))
,DST_ROLES AS
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP,FCISPARAMVALUE FCIS_REL,DECODE(NVL(FXPTYPE,'~'),'P','P','C','C','N/A') FXPTYPE,COUNT(DISTINCT FXPEXCLNT)  COUNT_DST
          FROM FXP, FXX_ROLES
       WHERE FXPEXCLNT = FXXEXCLNT
       GROUP BY DSTPARAMTEXT,FCISPARAMVALUE,DECODE(NVL(FXPTYPE,'~'),'P','P','C','C','N/A'))
,FCIS_ROLES AS
    (SELECT RELATIONSHIP FCIS_REL, DECODE(NVL(ENTITYCATEGORYTYPE,'~'),'I','P','C','C','N/A') FXPTYPE,COUNT(DISTINCT RPID) COUNT_GTAP_RPID,COUNT(DISTINCT RPLINKID) COUNT_GTAP_UH
          FROM RELATEDPARTYLINKMAPTBL_CUSTOM,entitybasetbl
       WHERE RELATIONSHIP IS NOT NULL
		 AND ENTITYID=RPID
       GROUP BY RELATIONSHIP,DECODE(NVL(ENTITYCATEGORYTYPE,'~'),'I','P','C','C','N/A'))   
,DST_COUNT AS 
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP, relationships.FCISPARAMVALUE FCIS_REL,NVL(FXPTYPE,'C') FXPTYPE,NVL(COUNT_DST,0) COUNT_DST,0 COUNT_GTAP_RPID,0 COUNT_GTAP_UH
      FROM DST_ROLES,relationships
      WHERE DSTPARAMTEXT=DST_RELATIONSHIP(+))
,FCIS_COUNT AS 
    (SELECT DSTPARAMTEXT DST_RELATIONSHIP, relationships.FCISPARAMVALUE FCIS_REL,NVL(FXPTYPE,'C') FXPTYPE,0 COUNT_DST,NVL(COUNT_GTAP_RPID,0) COUNT_GTAP_RPID,NVL(COUNT_GTAP_UH,0) COUNT_GTAP_UH
      FROM FCIS_ROLES,relationships
      WHERE FCISPARAMVALUE=FCIS_REL(+)) 
SELECT DST_RELATIONSHIP,
	   FCIS_REL,
	   FXPTYPE,
	   SUM(COUNT_DST) COUNT_DST,
	   SUM(COUNT_GTAP_RPID) COUNT_GTAP_RPID,
	   SUM(COUNT_GTAP_UH) COUNT_GTAP_UH
  FROM (SELECT * FROM DST_COUNT 
  		UNION  SELECT * FROM FCIS_COUNT)
 GROUP BY DST_RELATIONSHIP, FCIS_REL  ,FXPTYPE
 ORDER BY   DST_RELATIONSHIP, FCIS_REL ,FXPTYPE

SELECT RELATIONSHIP,COUNT(DISTINCT RPID)  From RELATEDPARTYLINKMAPTBL_CUSTOM WHERE relationship IS NOT NULL GROUP BY RELATIONSHIP

---relationship
---relationship
--Transaction Type and reftype descriptions DST and FCIS
with DMT_PARAMS as
 (SELECT DSTPARAMVALUE DST_DEAL_TYPE,
         FCISPARAMVALUE,
         substr(FCISPARAMVALUE, 1, 2) TRANSACTIONTYPE,
         substr(FCISPARAMVALUE, 4, 2) REFTYPE,
         substr(FCISPARAMVALUE, 7, 2) TRANSACTIONSUBTYPE
    FROM DMT_PARAMSTBL a
   WHERE FCISPARAMCODE = 'REFTYPE'),
DST_txn_type as
 (Select distinct upper(B55TRNTYID) txn_type, upper(B55MCTRNDS) dst_txn_Dsc
    From OFFXREFB55),
SUBTYPE as
 (Select '' TRANSACTIONTYPE,
         '02' reftype,
         PARAMVALUE SUBTYPE,
         PARAMTEXT SUBTYPEDESCRIPTION
    From paramstbl
   where paramcode = 'TXNSUBTYPEPURCHASE'
     and paramlanguage = '1033'
  union
  Select '' TRANSACTIONTYPE,
         'PS' reftype,
         PARAMVALUE SUBTYPE,
         PARAMTEXT SUBTYPEDESCRIPTION
    From paramstbl
   where paramcode = 'TXNSUBTYPESWITCH'
     and paramlanguage = '1033')
Select a.DST_DEAL_TYPE,d.DST_TXN_DSC,a.FCISPARAMVALUE,a.TRANSACTIONTYPE,a.REFTYPE,a.TRANSACTIONSUBTYPE,b.REFTYPEDESCRIPTION,c.SUBTYPEDESCRIPTION
  From DMT_PARAMS a, reftypetbl b, SUBTYPE c, DST_txn_type d
 where a.DST_DEAL_TYPE=TXN_TYPE(+)
   and a.TRANSACTIONTYPE = b.TRANSACTIONTYPE(+)
   and a.REFTYPE = b.REFTYPE(+)
   --and a.TRANSACTIONTYPE = c.TRANSACTIONTYPE(+)
   and a.TRANSACTIONSUBTYPE = c.SUBTYPE(+)
   and a.REFTYPE = C.reftype(+)
 order by DST_DEAL_TYPE
 
 
 
--Transaction Type and reftype descriptions DST and FCIS
--Transaction Type and reftype descriptions DST and FCIS
---stop code list 
select * From  UHSTOPCODERESTRICTIONTBL
select * From  PARAMALLOWOPERATIONSTBL_CUSTOM
select * From  STOPCODERESTRICTIONTBL
select * From  Uhstopcoderestricttbl_Custom
---stop code list 
--agent List dedupe
select * From  DM_DEDUPLICATECHECKTBL order by length(DD_ClientList) desc,DD_ClientList-- Private client
select * From  DM_DEDUPLICATECHECKCRPTBL order by length(DD_ClientList) desc,DD_ClientList-- Corp client
select * From  DM_DEDUPLICATECHECKAGENTTBL  order by length(DD_AGENTLIST) desc,DD_AGENTLIST -- Agent client

select * from  DM_DEDUPLICATECHECKRPTTBL order by length(DD_ClientList) desc,DD_ClientList
select * from  DM_DEDUPLICATECHECKRPTTBL order by length(DD_ClientList) desc,DD_ClientList
select * from  DM_DEDUPLICATECHECKRPTTBL order by length(DD_ClientList) desc,DD_ClientList
select * From  DM_DEDUPLICATECHECKAGENTTBL  order by length(DD_AGENTLIST) desc,DD_AGENTLIST


  SELECT QUERY,
         DECODE (QUERY,'1', 'FXAS',2, 'FXD',3, 'FXK',4, 'FXQANALV10',5, 'FXQPARENT',6, 'FXQPAYC') QUERY_SOURCE,
         COUNT (1)
    FROM DM_ENTITYREFERENCETBL
GROUP BY QUERY order by query
 
select * From  fxq where fxqmcid='000048' and fxqagent in 
('00000326',
'34503859',
'34503608',
'34503777',
'00000001',
'34503819',
'34503730',
'00000261',
'34503636'
)
003121,34505997

select * From DM_DEDUPLICATECHECKAGENTTBL where fxqmcid <>'000034'
select * From DM_DEDUPLICATECHECKAGENTTBL  where instr(DD_AGENTLIST,'34505997')  >0 in ('003121','34505997')
select * From DM_DEDUPLICATECHECKAGENTTBL  where fxqagent  in ('003121','34505997')
 

select * From  DM_DEDUPLICATECHECKAGENTTBL  where fxqagent  in  ('2007679','2006070')
select * From  fxq where fxqagent  in ('003121','34505997')
 
003121,34505997,
003121,34505997,003121
---AGENT GROUP 
WITH agent
        AS (SELECT LOWER (REGEXP_REPLACE (FXQNAM, '[^A-Za-z0-9]'))lower_FXQNAM, SUBSTR (LOWER (REGEXP_REPLACE (FXQNAM, '[^A-Za-z0-9]')), 1, 4) substr_FXQNAM , a.*
              FROM DM_DEDUPLICATECHECKAGENTTBL a),
     ag_grp
        AS (  SELECT ROW_NUMBER () OVER (ORDER BY substr_FXQNAM)
                        GRP,
                     substr_FXQNAM
                FROM agent a
            GROUP BY substr_FXQNAM)
  SELECT b.GRP, a.*
    FROM agent a, ag_grp b
   WHERE a.substr_FXQNAM = b.substr_FXQNAM --and  a.fxqmcid ='000048' 
ORDER BY GRP, LENGTH (a.lower_FXQNAM), a.lower_FXQNAM 

 --client group
 
Howard
Jonathan
create table DM_DEDUPLICATECHECKTBL5jun as select * From  DM_DEDUPLICATECHECKTBL
 select * From  DM_DEDUPLICATECHECKTBL order by length(DD_ClientList) desc,DD_ClientList-- Private client
select * From  DM_DEDUPLICATECHECKTBL where fxpmcid <>'000034'
--private group by  
 WITH private
        AS (SELECT LOWER (REGEXP_REPLACE (FXPSURN|| FXPFSTN||FXPMIDN, '[^A-Za-z0-9]'))lower_FXpNAM, SUBSTR (LOWER (REGEXP_REPLACE (FXPSURN|| FXPFSTN||FXPMIDN, '[^A-Za-z0-9]')), 1, 100) substr_FXPNAM , a.*
              FROM DM_DEDUPLICATECHECKTBL a),
     ag_grp
        AS (  SELECT ROW_NUMBER () OVER (ORDER BY fxPmcid,substr_FXPNAM)
                        GRP,
                     substr_FXPNAM
                FROM private a
            GROUP BY fxPmcid,substr_FXPNAM)
  SELECT b.GRP, a.*
    FROM private a, ag_grp b
   WHERE a.substr_FXPNAM = b.substr_FXPNAM --and  a.fxPmcid ='000048' 
ORDER BY a.fxPmcid,GRP, LENGTH (a.lower_FXpNAM), a.lower_FXpNAM 



--Corporate Group
select * From  DM_DEDUPLICATECHECKCRPTBL
 WITH Corporate
        AS (SELECT LOWER (REGEXP_REPLACE (FXPORG, '[^A-Za-z0-9]'))lower_FXpNAM, SUBSTR (LOWER (REGEXP_REPLACE (FXPORG, '[^A-Za-z0-9]')), 1, 100) substr_FXPNAM , a.*
              FROM DM_DEDUPLICATECHECKCRPTBL a),
     ag_grp
        AS (  SELECT ROW_NUMBER () OVER (ORDER BY fxPmcid,substr_FXPNAM)
                        GRP,
                     substr_FXPNAM
                FROM Corporate a
            GROUP BY fxPmcid,substr_FXPNAM)
  SELECT b.GRP, a.*
    FROM Corporate a, ag_grp b
    FROM Corporate a, ag_grp b
   WHERE a.substr_FXPNAM = b.substr_FXPNAM --and  a.fxPmcid ='000048' 
ORDER BY a.fxPmcid,GRP, LENGTH (a.lower_FXpNAM), a.lower_FXpNAM 
 



select * From  BULKENTITYCONTACTINFOTBL
select * From  DM_UNITHOLDERREFERENCETBL

select * From  dm_entityreferencetbl  where gtap_entityid not in (
select entityid  From  BulkEntityImportTbl )

select * From  dm_entityreferencetbl where orgentityid is not null
delete from  BULKENTITYIMPORTERRORLOGTBL
select * From  entitybasetbl 
select * From  BULKENTITYIMPORTERRORLOGTBL order by rowid desc
select * From  DM_CIFTEMPTBL
select * From  STTM_PERSONAL_CUSTOM;
select * From  uhcontactinfotbl 
select * From  sysparamtbl 
select * From user_objects where object_name like '%FUNDPR%CU%'
select * From  FUNDPRICEDETAILTBL_CUSTOM where fundid='KEA'
select * From  fundpricehdrtbl where fundid='KEA'

sselect * From  FATCAMAINTHDRTBL;
select * From  fundprice
select * From  DM_TIMETRACKINGTBL where MIGFILETYPE  = 'ENT'
select * From  DM_TIMETRACKINGTBL where MIGFILETYPE  = 'TOL' and TASK='TOTAL_TRANSFORMATION_EXECUTION_TIME'
select * From  DM_TIMETRACKINGTBL where MIGFILETYPE  = 'TOL' and TASK='TOTAL_PRE_MIGRATION_EXECUTION_TIME'
select * From  DM_TIMETRACKINGTBL where MIGFILETYPE  = 'TOL' and TASK='TOTAL_PRE_MIGRATION_EXECUTION_TIME'
select * From  dm_timetrackingtbl where total_time is null TASK like '%PRE%'
SELECT  DSTPARAMVALUE, FCISPARAMVALUE FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='REFTYPE'
select * From user_objects where object_name like '%DM_TIMETRACKINGTBL%' 
select * From  DM_TIMETRACKINGTBL_16_4_19  where TASK like '%PRE%'
select * From  DM_TIMETRACKINGTBL_DUMMY  where TASK like '%PRE%'
select * From  txnprocessingrulestbl 
('TOL','TOTAL_PRE_MIGRATION_EXECUTION_TIME',
select * From  entitybasetbl where maker_id ='GTAPTEST1' order by rowid desc
select * From  BULKENTITYIMPORTERRORLOGTBL
select * From user_objects where object_name like '%BULK%ENT%C%' 
select * From user_tab_Cols where column_name like '%REGULATOR%' 
select * From  DM_UNITHOLDERREFERENCETBL
select * From  ENTITYBASETBL_CUSTOM
select * From  user_Dependencies where referenced_name='ENTITYBASETBL_CUSTOM'
select * From  BULKENTITYIMPORTTBL_CUSTOM

select fn_unwrap(UTPKS_UTDENTMN_MAIN) From  dual
---Load 
SELECT * FROM 	loadtbl 
SELECT * From CRITERIAFIELDMAPPINGTBL;
SELECT * From CRITERIATBL
PKGLOADCRITERIA
SELECT fnunwrap_code('PKGLOADCRITERIA')  FROM dual;
   PKGCRITERIAGENERATION PKGLOADCRITERIA
---Load
select * From  DM_FUNDANDACCTYPEREFERENCETBL where dstcustomerid like '%3001846%' 

select * From   DM_UNITHOLDERREFERENCETBL where dstunitholderid like '%3001846%'
select * From  fxd where fxduhaccn='0003001846'
select * From  DM_STANDALONECIFTBL where cifnumber='34001083'
select * From  DM_STANDALONECIFTBL where cifnumber='34177616'
select * From  DM_UNITHOLDERREFERENCETBL where dstunitholderid is null 
select * From  fxx where fxxexclnt='34177616'

select * From  uhbankdetailstbl 
select * From  fxx where fxxuhaccn like '%3001846%'
select * From  DM_FUNDANDACCTYPEREFERENCETBL where gtapunitholderid not like 'UK%'
select count(1) From   DM_UNITHOLDERREFERENCETBL where gtapunitholderid not like 'UK%'
select * From  entitybasetbl
select * From  fxpf where trim(FXPFGIINOS)='Y' is not null 
select ORA_HASH() From  fxq where upper(fxqagent) <>lower(fxqagent)
select * From user_objects where object_name like '%RE%P%' 
select ORA_HASH('CBAMEX1231'||'-'||'CBAMEX111231') From  dual 
SELECT SUM(amount_sold) FROM sales
   WHERE ORA_HASH(CONCAT(cust_id, prod_id), 99, 5) = 0;
   select * From  fxy where  FXYEFFDTE='06-APR-2018' and FXYCURRTO='EUR'
   select * From SysParamTbl  
   2619859205
   2854051559
   1860672725--1860672725
   
   select * From  offxrefa12
   
   
   SELECT  DSTPARAMVALUE, FCISPARAMVALUE FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='TRANSACTIONMODE'
   SELECT  * FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='REFTYPE' order by 1,2,3,4
   commit;
       MERGE INTO DMT_PARAMSTBL e
    USING (   SELECT  * FROM DMT_PARAMSTBL WHERE FCISPARAMCODE='REFTYPE' 
) ab
    ON (ab.DSTPARAMVALUE = e.DSTPARAMVALUE and ab.FCISPARAMVALUE = e.FCISPARAMVALUE)
    WHEN MATCHED THEN
    UPDATE SET e.DSTPARAMTEXT = ab.FCISPARAMTEXT,e.FCISPARAMTEXT = ab.DSTPARAMTEXT 
FATCAMAINTHDRTBL
select * From  FXPF
  --updatePassword: Asdf123$
  UPDATE SMTB_USER
  SET USER_PASSWORD='SHA-512!10000!41FF5D9FE9790FD086949178AB645E13CAFB8F18EB1E1188B48684684F3125F0FDCB82E606F178C31B3AA33A234967C207083BFFEE6D711BABC719433778ECBC',
    SALT           ='1BE6AB446B780E1C90639813934D5B3E'
     ,PWD_CHANGED_ON=to_date( '01/01/2017 08-00-00', 'DD/MM/YYYY HH24-MI-SS' ) 
    ,FORCE_PASSWD_CHANGE='1'
  WHERE USER_ID    =  l_user_id;
  COMMIT;
  
--Pass@123
    UPDATE SMTB_USER
  SET USER_PASSWORD='SHA-512!10000!84300F88A25C8FF30B0CA145747B99A5E202F4142197E1E9A4D1962E590AE2C32E5F1212A7DC30696F21C6D2030A5487CEDE036F1A336C2217C221EBE8DABA75'
    ,SALT           ='F52E29B85A91A8402566B97A4DE7CE5A'
     ,PWD_CHANGED_ON=to_date( '01/01/2017 08-00-00', 'DD/MM/YYYY HH24-MI-SS' ) 
    ,FORCE_PASSWD_CHANGE='0'
    ,USER_STATUS='E'
  WHERE USER_ID    =  '45013915A';
  
 ---------------
  
  Select * From FXO 
 Where FXOFUND = 'TH1'
 Order By To_NUMBER(FXOVALNO) desc 
 
select * From  fxo a where fxovalno =
(select max(To_NUMBER(FXOVALNO)) From   fxo b where a.fxofund=b.fxofund)
and (FXOUTCON-FXOUTISS)>0


select * From   fxo where fxofund='TH1' order by To_NUMBER(fxovalno) desc;
select * From  bodoutstandingunitstbl  where fundid ='TH1'
select 47739546.96      +16604845.5 From  dual 

select * From  fundpricehdrtbl where fundid='TH1' order by effectivedate desc

FUNDID  OUTSTANDINGUNITS  FIOUTSTANDINGUNITS
TH1       47739546.96      16604845.5

select sum(fxbtotsu),sum(fxbtotun),sum(fxbtotsu+fxbtotun) From  fxb where fxbfund='TH1'

FXOUTCON
70133971.59

47739546.96

47739546.96  47739546.96
select * From  uhballedgertbl where runningtotal <0
select linktransactionnumber ,sum(unitsalloted)  From  ageingtbl group by linktransactionnumber having sum(unitsalloted) <0
 
select * From  DM_TXNUNITBALRECONTBL WHERE UHFUNDBAL <> UHBALLEDGERBAL--UKTRA9866997  K3A
select * From  CONSOLIDATEDTXNTBL WHERE TRANSACTIONNUMBER='0220190850000189'--K3A  UKTRA9866997

select * From  AGEINGHIERARCHYTBL

SELECT LINKTRANSACTIONNUMBER, TRANSACTIONNUMBER,UNITHOLDERID,FUNDID,SUM (UNITSALLOTED) AS UNITBALANCE
   FROM AGEINGTBL where unitholderid='UKTRA9846631' and fundid='FZI'
 GROUP BY LINKTRANSACTIONNUMBER,UNITHOLDERID,FUNDID HAVING SUM (UNITSALLOTED) < 0 
select LINKTRANSACTIONNUMBER,UNITHOLDERID,FUNDID From  AGEINGTBL  GROUP BY LINKTRANSACTIONNUMBER,UNITHOLDERID,FUNDID HAVING SUM (UNITSALLOTED) < 0
select LINKtxnNUMBER,UNITHOLDERID,FUNDID From  AGEINGHIERARCHYTBL GROUP BY LINKtxnNUMBER,UNITHOLDERID,FUNDID HAVING SUM (UNITSALLOTED) < 0

select * From  AGEINGTBL where LINKTRANSACTIONNUMBER='0220180950141582'

select * From  AGEINGTBL where LINKTRANSACTIONNUMBER='0220181930003453'
select * From  CHECKWRITINGERRORLOGTBL
select * From  uhballedgertbl where unitholderid='UKTRA9846631' and fundid='FZI' order by 8 
select * From  ageingtbl where unitholderid='UKTRA9846631' and fundid='FZI' order by datealloted,rowid
select count( distinct dstcustomerid) From  dm_unitholderreferencetbl

 
select case when upper(trim(FXPNINO)) like 'X%' then 'Temp_Nino_Starts_With_X' else 'Nino' end Nino_Status From fxp
  
select FXPTYPE Client_Type_Code, decode(FXPTYPE,'P','Private','Corporate') Client_Type_Desc, case when trim(FXPNINO) is not null then 'Y' else 'N' end Nino_Y_N,
case when upper(trim(FXPNINO)) like 'X%' then 'Temp_Nino_Starts_With_X' else 'Nino' end Nino_Status,
FXPNINOSUP ,count(distinct FXPEXCLNT) client_count  
From  fxp where FXPEXCLNT in ( select dstcustomerid From  dm_unitholderreferencetbl where dstcustomerid=FXPEXCLNT) 
group by FXPTYPE,case when trim(FXPNINO) is not null then 'Y' else 'N' end,
case when upper(trim(FXPNINO)) like 'X%' then 'Temp_Nino_Starts_With_X' else 'Nino' end ,decode(FXPTYPE,'P','Private','Corporate'),
FXPNINOSUP
--67193
select * From  unitholdertbl 
select * From  consolidatedtxntbl 
select * From  FXPt  where FXPTRTYPE='NATIONAL ID NUMBER'
sselect * From  paramstbl where paramcode like 'IDENTIFICATIONTYPE%' 

select * From  fxp where FXPNINOSUP='Y' and trim(FXPNINO) not like 'X%' and trim(FXPNINO) not like 'Q%' 

0520190500003792
0520190510004048
SELECT * From  user_dependencies where name like '%UTDSTPCO%' referenced_name like '%PARAMALLOWOPERATIONSTBL_CUSTOM%' 
SELECT * From  paramallowoperationstbl_custom


remaining are solved but we have problem with these 6 records
select * from fxd where fxduhaccn = '0005550415' and fxdfund = 'LHO';
select * from fxd where fxduhaccn = '0003532027' and fxdfund = 'NRI';
select * from fxd where fxduhaccn = '0003412908' and fxdfund = 'ERA';
select * from fxd where fxduhaccn = '0003532027' and fxdfund = 'MHI';
select * from fxd where fxduhaccn = '0003476757' and fxdfund = 'RNI';
select * from fxd where fxduhaccn = '0003532027' and fxdfund = 'RNI';

select * from fxd where FXDREGSTA= 'U' AND FXDDLDTE<='5-APR-2018'
 
select * from FXB WHERE fxBuhaccn = '0003532027' and fxBfund = 'NRI';
select * from fxd where fxduhaccn = '0003532027' and fxdfund = 'NRI';
select transactiondate,DATEALLOTED ,a.* from consolidatedtxntbl a where transactiondate <'5-APR-2018'
SELECT transactiondate,DATEALLOTED FROM CONSOLIDATEDTXNTBL a where DATEALLOTED < '5-APR-2018';
select * from fxd where fxdtranid='0121920921' 
select  nvl(fxdnrmvpd,fxdbckvpd),fxdnrmvpd,fxdbckvpd,a.* from fxd a where nvl(fxdnrmvpd,fxdbckvpd) > '28-feb-2019' and rownum<50
select * from consolidatedtxntbl where fundid ='NRI' and unitholderid like '0003532027%';
select * from txnsettlementtbl where transactionnumber='0320172910000003'
select * from allocationtbl where transactionnumber='0320172910000003'
select * from consolidatedtxntbl  where unitsalloted=0
select * from user_tab_cols where

select * from UNITHOLDERFUNDTBL WHERE fundid ='NRI' and unitholderid like '0003532027%';
select * from AGEINGTBL WHERE fundid ='NRI' and unitholderid like '0003532027%';
 
 
 select * from TXNSETTLEMENTTBL

select * from IncomeDistributionsetupTbl
 142715.13
 
 
UPDATE GTAUKTR1.PARAMSTBL SET PARAMVALUE = 'UKTRA0062061', PARAMTEXT = 'FMSIML'
WHERE PARAMCODE = 'BOXFLOATUH';

select * from ENTITYBANKDETAILSTBL_CUSTOM

 select * from EntityContactInfoTbl

select * from ENTITYBANKDETAILSTBL_CUSTOM
select * from user_tab_cols where column_name like '%FATCASTATUS%'


SELECT
    A.UNITHOLDERID,
    A.FUNDID,
    (A.UNITBALANCE + A.PROVISIONALUNITS) SUMOFUHBAL,
    B.AGEINGUNITBAL,
    C.UHBALLEDGERBAL,
    ((A.UNITBALANCE + A.PROVISIONALUNITS) - B.AGEINGUNITBAL) AS DIFFUHBALAGEINGBAL,
    (C.UHBALLEDGERBAL - B.AGEINGUNITBAL) AS DIFFUHBALLEDGERBALAGEINGBAL,
    ((A.UNITBALANCE + A.PROVISIONALUNITS) - C.UHBALLEDGERBAL) AS DIFFUHBALUHBALLEDGERBAL
FROM UNITHOLDERFUNDTBL A,
    (SELECT UNITHOLDERID, FUNDID, SUM(UNITSALLOTED) AS AGEINGUNITBAL  FROM AGEINGTBL GROUP BY UNITHOLDERID, FUNDID) B,
    (SELECT UnitholderID, FundID, SUM(UNITSIN-UNITSOUT) AS UHBALLEDGERBAL FROM UHBalLedgerTbl GROUP BY UnitholderID, FundID) C
WHERE A.UNITHOLDERID = B.UNITHOLDERID
  AND A.FUNDID = B.FUNDID
  AND A.UNITHOLDERID = C.UNITHOLDERID
  AND A.FUNDID = C.FUNDID
  AND B.UNITHOLDERID = C.UNITHOLDERID
  AND B.FUNDID = C.FUNDID
  AND (((A.UNITBALANCE + A.PROVISIONALUNITS) - B.AGEINGUNITBAL) <> 0
      OR (C.UHBALLEDGERBAL - B.AGEINGUNITBAL) <> 0
      OR ((A.UNITBALANCE + A.PROVISIONALUNITS) - C.UHBALLEDGERBAL) <> 0);


select * from fundpricecomponentstbl 
select * from  user_tables where table_name like '%FUN%PR%COM%'
select * from FUNDPRICECOMPONENTTBL
select * from fundpricehdrtbl 
select * from fundpricedetailtbl 
select * from OFFXREFB33
--enquote or quote 
select q'[q'[]'||UPPER(q'[dfa'asd]')||']''',q'[dfa'a'sd]' ,q'[DFA'ASD]' from dual

select * From user_objects where object_name like '%STOPCODE%' 
select * From  STOPCODEACTMASTERTBL_CUSTOM
select * From  UHSTOPCODERESTRICTTBL_CUSTOM

select fxjmcid,fxjsscod,fxjexclnt,fxjagent,fxjexcseq,fxjaddrtyp,fxjupdtdt ,count(1) From  fxj group by fxjmcid,fxjsscod,fxjexclnt,fxjexcseq,fxjaddrtyp,fxjagent,fxjupdtdt having count(1)>2

select * From  fxj where fxjexclnt='34203479'
select * From  fxj where fxjexclnt='34203479'
select * From  sys.aud$
select * From  v$sql where sql_text like '%FXJ%'; 
select * From  all_tab_modifications where table_name like '%FXJ%'

/* Formatted on 11/04/2019 18:03:06 (QP5 v5.277) */
SELECT *
  FROM fxa P, fxb q
 WHERE     P.fxauhaccn = q.fxbuhaccn
       AND P.fxamcid = q.fxbmcid
       AND (fxbprod, fxbprody) IN (  SELECT fxbprod, MAX (fxbprody)
                                       FROM fxb x
                                      WHERE q.fxbuhaccn = x.fxbuhaccn
                                   GROUP BY fxbprod)
       AND (q.fxbtotsu > 0 OR q.fxbtotun > 0)
       AND fxbprod IN (SELECT Q02PRODCDE
                         FROM OFFXREFQ02
                        WHERE Q02PRODCDE = '000033')
SELECT * FROM GTAUKTR1.PARAMSTBL WHERE PARAMCODE = 'SWIFTHEADERTAGS' AND
PARAMVALUE LIKE '%UKTR%';

SELECT * FROM OFFXREFQ02 WHERE Q02PRODCDE = '000033';
select * From  FXB

Select DISTINCT FXBFUND  From  FXB WHERE fxbprod IN (SELECT Q02PRODCDE
                                                       FROM OFFXREFQ02
                                                WHERE Q02PRODCDE = '000033') 
AND FXBTOTSU+ FXBTOTUN>0


select * From  


SELECT * FROM FXO o   
                    WHERE o.FXOVALDTE >= '06-APR-2018'
                    and o.FXOVALNO =(SELECT MAX(a.FXOVALNO) 
                                      FROM FXO a
                                      WHERE a.FXOMCID  = o.FXOMCID
                                        AND a.FXOSSCOD = o.FXOSSCOD
                                        AND a.FXOFUND  = o.FXOFUND
                                        AND a.FXOFUNDT = o.FXOFUNDT
                                        AND a.FXOVALDTE = o.FXOVALDTE
                    ) --128103 

order by fxofund,FXOVALNO
select * From  fxn

     
fxnvaldte='06-apr-2018'
select * From  fxo where fxofund='AB2' and fxovaldte='06-apr-2018'

select * From  entitybasetbl where entitytype='M' 
drop sequence DM_CIFNOSEQ_test
select DM_CIFNOSEQ_TEST.nextval From  dual 
 CREATE or replace SEQUENCE DM_CIFNOSEQ_test
           MINVALUE 1
           MAXVALUE 1000000000000000000000000000
           START WITH 978989
           INCREMENT BY -1
           CACHE 20;
           select * From  unitholdertbl 
           
           990020160
           
           
select * From  UHCONTACTINFOTBL_CUSTOM

select * From  UHCONTACTINFOTBL
select 'UKTR' ||'A' ||LPAD(UHINDSEQ.NEXTVAL,7,'0') From  unitholdertbl where rownum <5 
se
    'UKTR' ||'A' ||LPAD(UHINDSEQ.NEXTVAL,7,'0') 
    
    
    select * From 'UKTR' ||'A' ||LPAD(UHINDSEQ.NEXTVAL,7,'0')   AS GTAPUNITHOLDERID,  --GTAPUNITHOLDERID||''||DST.FCISACCTYPEVALUE    AS GTAPUNITHOLDERID, ---commented direct reference and using sequence 
DM_FUNDANDACCTYPEREFERENCETBL DM

DM_UNITHOLDERREFERENCETBL
drop table DM_FUNDANDACCTYPEREFTBL_BKP
create table DM_UNITHOLDERREFERENCETBL_BKP as select * From  DM_UNITHOLDERREFERENCETBL 
create table DM_FUNDANDACCTYPEREFTBL_BKP as select * From  DM_FUNDANDACCTYPEREFerenceTBL
select * From DM_FUNDANDACCTYPEREFERENCETBL

update DM_UNITHOLDERREFERENCETBL set GTAPUNITHOLDERID='UKTR' ||'A' ||LPAD(UHINDSEQ.NEXTVAL+ROWNUM,7,'0')  
select * From DM_UNITHOLDERREFERENCETBL 
select * From DM_FUNDANDACCTYPEREFERENCETBL
select count(1) From  DM_FUNDANDACCTYPEREFERENCETBL 
create table DM_FUNDANDACCTYPEREFTBL_BKP1 as select * From  DM_FUNDANDACCTYPEREFERENCETBL
create table DM_UNITHOLDERREFERENCETBL_BKP1 as select * From  DM_UNITHOLDERREFERENCETBL
select * from fxk where fxkuhaccn='0003625210' 
select * From  simastertbl where unitholderid like '0003625210%'  
select * From  siintermediarytbl where siid='4100000000001101'
select * From  txnintermediarytbl  
SIID='4120192805118000'
136763

----unitholder updates
update DM_UNITHOLDERREFERENCETBL set GTAPUNITHOLDERID='UKTR' ||'A' ||LPAD(UHINDSEQ.NEXTVAL+ROWNUM,7,'0');  
commit;

MERGE INTO DM_FUNDANDACCTYPEREFERENCETBL D
   USING (SELECT * FROM DM_UNITHOLDERREFERENCETBL) S
   on  (D.DSTUNITHOLDERID||D.gtapacctype = S.DSTUNITHOLDERID||s.gtapacctype)
   WHEN MATCHED THEN UPDATE SET D.GTAPUNITHOLDERID = S.GTAPUNITHOLDERID;
commit;

select * From  FXE where trim(FXEAMOUNT) is null 
     
     DELETE WHERE (S.salary > 8000)
   WHEN NOT MATCHED THEN INSERT (D.employee_id, D.bonus)
     VALUES (S.employee_id, S.salary*.01)
     WHERE (S.salary <= 8000);
     
select * From  DM_ENTITYREFERENCETBL
    
select * From  entitybasetbl 
select * From  DM_ENTITYREFERENCETBL_bkp where gtap_entityid='AT00000115E'  
C:\Leelar\Sculpting\GIT\MIG_SCRIPTS\Scripts\
server  D:\FCIS_J2EE\Migration\CONSOLIDATED_MDR1\Scripts
select * From  entityaddinfotbl
--@"&&VAR\BackEnd\Transformation\Execution\Transformation_Unitholder_Reference_Exe.sql" &&GVAR
--@"&&VAR\BackEnd\Transformation\Execution\Transformation_Entities_Reference_Exe.sql" &&GVAR
--@"&&VAR\BackEnd\Transformation\Execution\Transformation_Entities_Exe.sql" &&GVAR
--@'&&VAR\BackEnd\Migration\Execution\Migration_Exe_Entities.Sql'  &&GVAR

--@"&&VAR\BackEnd\Transformation_Mig_Scripts\UH\DM_UNITHOLDERREFERENCETBL.sql"

select * From BULKENTITYIMPORTTBL_CUSTOM where REGULATEDPARTY='Y' and LASTREVIEWEDDATE is not null
commit; 
update BULKENTITYIMPORTTBL_CUSTOM set REGULATEDPARTY='Y' where REGULATEDREFERENCEID is not null 
Update DM_ENTITYREFERENCETBL set GTAP_ENTITYID=decode(GTAP_ENTITYTYPE,'I','IFGB'||LPAD(ROWNUM,0),'A','ATGB'||LPAD(ROWNUM,0),GTAP_ENTITYID);
select LPAD("r",8,0) ,"r" From   
(select LPAD(rownum,8,0),rownum +1 as "r" From  DM_ENTITYREFERENCETBL)a 
 select * From  DM_ENTITYREFERENCETBL
 
 update BULKENTITYIMPORTTBL_CUSTOM set LASTREVIEWEDDATE='28-oct-2019'
MERGE INTO DM_ENTITYREFERENCETBL D
   USING (SELECT LPAD(rownum+4645,8,0) as "rowno",x.* FROM DM_ENTITYREFERENCETBL x) S
   on  (D.entityid = s.entityid and D.dstamcid=s.dstamcid and D.GTAP_ENTITYTYPE=s.GTAP_ENTITYTYPE )
   WHEN MATCHED THEN UPDATE 
   SET d.GTAP_ENTITYID=decode(d.GTAP_ENTITYTYPE,'I','IFGB'||"rowno",'A','ATGB'||"rowno",d.GTAP_ENTITYID);
commit;

    MERGE INTO DM_ENTITYREFERENCETBL D
      USING (SELECT LPAD(rownum+4645,8,0) as "rowno",x.* FROM DM_ENTITYREFERENCETBL x) S
        on  (D.entityid = s.entityid and D.dstamcid=s.dstamcid and D.GTAP_ENTITYTYPE=s.GTAP_ENTITYTYPE )
      WHEN MATCHED THEN 
      UPDATE
      SET d.GTAP_ENTITYID=decode(d.GTAP_ENTITYTYPE,'I','IFGB'||s."rowno",'A','ATGB'||s."rowno",d.GTAP_ENTITYID);
      
  select * From  DM_ENTITYREFERENCETBL;
    select * From  DM_UNITHOLDERREFERENCETBL ;
    select * From  DM_FUNDANDACCTYPEREFERENCETBL ;
select  
ORA_HASH('0005550862'||'-'||6)    --SEQUENCENUMBER      --Closed-- leela sequence has to unique for record and same acrross all bulk tables
,dbms_utility.get_hash_value('0005550862'||'-'||6,0,99999999) 
From  dual 

select ORA_HASH(systimestamp) From  dual 



create table DM_ENTITYREFERENCETBL_bkp as select * From  DM_ENTITYREFERENCETBL
select * From  DM_ENTITYREFERENCETBL
DROP TABLE DM_DEDUPEENTITYREFERENCETBL;
CREATE TABLE DM_DEDUPEENTITYREFERENCETBL
(
  DST_ENTITYID            VARCHAR2(12),
  DSTAMCID                VARCHAR2(6),
  DSTAGENTTYPE            VARCHAR2(3),
  DST_PARENTENTITYID      VARCHAR2(12),
  DEDUPE                  VARCHAR2(12) Default 'N'
); 
select * From  DM_ENTITYREFERENCETBL
update DM_DEDUPEENTITYREFERENCETBL set orgentityid=entityid,dedupe='Y' where entityid in(
'002527',
'001379',
'002776',
'002999',
'003372',
'2000578',
'2000709',
'2000792',
'2001032',
'2005324',
'34503819',
'34503730')
select * From  DM_DEDUPEENTITYREFERENCETBL
select * From  DM_ENTITYREFERENCETBL where dedupe<>'Y'
update DM_ENTITYREFERENCETBL set orgentityid=entityid,dedupe='Y' where entityid in(
'002527',
'001379',
'002776',
'002999',
'003372',
'2000578',
'2000709',
'2000792',
'2001032',
'2005324',
'34503819',
'34503730')
commit;
select * From  DM_ENTITYREFERENCETBL
update DM_ENTITYREFERENCETBL set orgentityid=''
update DM_ENTITYREFERENCETBL set orgentityid=entityid,dedupe='N' where entityid in('34503819')
and amcid='000048'
select * From  DM_ENTITYREFERENCETBL where entityid in('2000578') and dstamcid='000034'
2000578  ATGB00014777  A  000034  IFA  2000578  N

update DM_ENTITYREFERENCETBL set orgentityid='2000578' where entityid in('2000578') and dstamcid='000034';
update DM_ENTITYREFERENCETBL set orgentityid='2000578',dedupe='Y' ,gtap_entityid='ATGB00014777'
where entityid in('2000709','2000792','2001032','2005324')    and dstamcid='000034'

select * From  DM_ENTITYREFERENCETBL where entityid in('002527') and dstamcid='000034'
002527  IFGB00010354  I  000034  IFA    N

update DM_ENTITYREFERENCETBL set orgentityid='002527' where entityid in('002527') and dstamcid='000034';
update DM_ENTITYREFERENCETBL set orgentityid='002527',dedupe='Y' ,gtap_entityid='IFGB00010354'
where entityid in('003372','002776')  and dstamcid='000034'

commit;
002776
003372
select * From  DM_ENTITYREFERENCETBL where orgentityid is not null

select * From DM_ENTITYREFERENCETBL where  entityid in('003372','002776')      
select entityid,dstamcid,GTAP_ENTITYTYPE From  DM_ENTITYREFERENCETBL x group by entityid,dstamcid,GTAP_ENTITYTYPE having count(1)>1


select * From  DM_UNITHOLDERREFERENCETBL where DSTCUSTOMERID in('34531417') and dstamccode='000034'
990927870

update DM_UNITHOLDERREFERENCETBL set PARENTCIF='34531417' where DSTCUSTOMERID in('34531417') and dstamccode='000034';
update DM_UNITHOLDERREFERENCETBL set PARENTCIF='34531417' ,dedupe='Y' ,GTAPCUSTOMERID='990927870'
where DSTCUSTOMERID in('34506126')  and dstamccode='000034'


select * From  DM_UNITHOLDERREFERENCETBL where PARENTCIF is not null

create table DM_UNITHOLDERREFTBL_bkp as select * From  DM_UNITHOLDERREFERENCETBL

select * From  DM_UNITHOLDERREFERENCETBL where DSTCUSTOMERID in('34601067') and dstamccode='000034'
990927870

update DM_UNITHOLDERREFERENCETBL set PARENTCIF='34601067' where DSTCUSTOMERID in('34601067') and dstamccode='000034';
update DM_UNITHOLDERREFERENCETBL set PARENTCIF='34601067' ,dedupe='Y' ,GTAPCUSTOMERID='990927870'
where DSTCUSTOMERID in('34602411','34602412','34601536','34103913','34004383')  and dstamccode='000034'


SELECT CUSTOMER_NO FROM STTM_CUSTFATCA_DETAILS group by customer_no having count (CUSTOMER_NO)>1
select * From  STTM_CUSTFATCA_DETAILS 
WHERE CUSTOMER_NO = '970948034';

select * From  STTM_CUSTOMER_CUSTOM


select * From  dm_bankdetailstbl 

select * From  consolidatedtxntbl where

MAKER_ID='MIGRATION'

select fn_unwrap('spCmnGenTxnNum') From  dual 

DST

SELECT FXPWRSK ,decode(FXPWRSK,'H','High','L','Low','M','Medium','N','Not Rated',FXPWRSK) AS Risk_DESC,COUNT(fxpwexclnt) DST_CLIENT_COUNT   From fxpw 
WHERE fxpwexclnt IN  (SELECT DISTINCT dstcustomerid From dm_unitholderreferencetbl)
AND  (TRIM(FXPWENDDTE)>= '06-APR-2018' OR FXPWENDDTE IS NULL )
GROUP BY FXPWRSK  

/* Formatted on 6/7/2019 4:19:02 PM (QP5 v5.277) */
with transactions as 
select *
from (select name, task, code_subject, 
row_number() over (partition by name order by task_code) rn
from t)
where rn = 1;

with transactions as(
  SELECT transactiondate,
         transactiontype,
         reftype,
         transactionsubtype,
         COUNT (transactionnumber) count_txn
    FROM consolidatedtxntbl
  -- WHERE reftype IN ('IO','IV','69','99','BT','LD','IR','CL','BT','II','IR','PR','PR','II','IO','OT','PS')
GROUP BY transactiondate, transactiontype, transactionsubtype,reftype)
,rnk as (
select transactiontype, reftype,transactionsubtype,  transactiondate ,count_txn, row_number() OVER (PARTITION BY transactiontype, reftype   ORDER BY count_txn DESC) rn
  from transactions
 )
select * From  rnk where rn<=1 order by
transactiontype, reftype, transactionsubtype, transactiondate,rn
  max(comm) keep (dense_rank last order by hiredate) max_last_comm,
----------------------------https://jira.HDEV/browse/UKTAMIG-267----------------------------
Select * From unitholdertbl 

Select * From fxpf where FXPFETYPE = 'PASSPORT' FXPFTIN is not blank

Select * From  fxpt where FXPTRTYPE in ('NATIONAL ID NUMBER','OTHER','TAX ID NUMBER') and trim(FXPTTAXID) is not null  
and exists (Select * From DM_UNITHOLDERREFERENCETBL where dstcustomerid =fxptexclnt)

Select * From FXPF FXPFETYPE 
Select DSTCUSTOMERID, u.*
  From DM_UNITHOLDERREFERENCETBL dm
  Join UNITHOLDERTBL u
    On dm.GTAPUNITHOLDERID = u.UNITHOLDERID
-- Where DSTCUSTOMERID = '34346888'
 Where DSTCUSTOMERID in ('34644854', '34643051', '34346888', '34642637')

 "PASSPORT" AND FXPFTIN is not blank
SELECT DSTPARAMTEXT, FCISPARAMVALUE FROM DMT_PARAMSTBL WHERE FCISPARAMCODE = 'UHCATEGORY'
Select INVESTORTYPE,UHCATEGORY,count(1) From unitholdertbl group by UHCATEGORY,INVESTORTYPE order by 1
UKTA 8505
Select * From unitholdertbl

----------------------------https://jira.HDEV/browse/UKTAMIG-267----------------------------
---------------Inflow 04 intermediary -----------------------
Select * From consolidatedtxntbl a where a.provisionalflag='C'
Select * From 
Select * From txnintermediarytbl where transactionnumber ='0420182560001688'
Select * From fxd where fxdgrpid='0022539259'
FXDTRANID = '0222539259'


select * from uhballedgertbl
where unitholderid = 'UKTRA9876381'
and transactionnumber = 0420182560001688
--and fundid = 'GQY'
/

select * from txnintermediarytbl
where transactionnumber = 0420182560001688
/
ela ... Transactionnumber 0420182560001688 only has default intermediaries, however the corresponding transaction on FXD (FXTRANID = 0222539259) has agent 2019405


---------------Inflow 04 intermediary -----------------------
-------------------[JIRA] (UKTAMIG-120) Setting up Cheque Redemption Mandates for Third Party Payees
select FXFMCID, FXFUHACCN, COUNT(*) from fxf
Where FXFMANSRC = '902'         
AND   FXFMANMTH = '000002'  
AND TRIM(FXFCHQN) IS NOT NULL
GROUP BY FXFMCID, FXFUHACCN
HAVING COUNT(*)>1; 
3:00:36 PM: Jomson KALAPARAMBIL/HSDI/HDEV: FXFCHQN 
3:01:59 PM: Jomson KALAPARAMBIL/HSDI/HDEV:
 SELECT * FROM fxf
Where FXFMANSRC = '902'         
AND   FXFMANMTH = '000002'  
AND FXFUHACCN = '0003145419'
AND TRIM(FXFCHQN) IS NOT NULL; 



Password@234$

SELECT * FROM fxf
WHERE FXFMANSRC = '902'         
AND   FXFMANMTH = '000002'  
AND FXFUHACCN = '0003544160'
AND TRIM(FXFCHQN) IS NOT NULL; 

Select * From managerboxupdatetbl_custom where fundid='A2A'
Select * From managerboxupdatetbl_custom where MANAGERBOXDATE='14-jun-2019'


SELECT * FROM fxf
WHERE FXFMANSRC = '902'         
AND   FXFMANMTH = '000002'  
AND FXFUHACCN = '0003145419'
AND TRIM(FXFCHQN) IS NOT NULL; 

3:19:49 PM: Jomson KALAPARAMBIL/HSDI/HDEV: sorry..but for the above case which one to consider.. 
3:20:38 PM: Jomson KALAPARAMBIL/HSDI/HDEV: put a rownum and enddate and deal with it? 


select FXFMCID, FXFUHACCN, COUNT(*) from fxf
Where FXFMANSRC = '902'
AND FXFMANMTH = '000002'
AND TRIM(FXFCHQN) IS NOT NULL
GROUP BY FXFMCID, FXFUHACCN having  COUNT(1)>1

SELECT * FROM fxf WHERE FXFMANSRC = '902' AND FXFMANMTH = '000002' AND FXFUHACCN = '0003593440'; 
-------------------[JIRA] (UKTAMIG-120) Setting up Cheque Redemption Mandates for Third Party Payees

----------------------------------Debug TEst

DECLARE

BEGIN
    
	global.pr_init('000','45013915A'); 
	pkgglobal.pr_init('FMGUKTR','45013915A'); 
	Debug.Pr_Debug('UT' ,'*********************Debug Test Start*****************');
	

	DBMS_OUTPUT.PUT_LINE('*********************Debug Test End*******************');
END;

SELECT * From dba_directories

SELECT * From cstb_debug_users WHERE user_id='45013915A'


DECLARE
  fileHandler UTL_FILE.FILE_TYPE;
BEGIN
  fileHandler := UTL_FILE.FOPEN('GTAP_EXTERNAL_DIR', 'test_file.txt', 'W');
  UTL_FILE.PUTF(fileHandler, 'Writing TO a file\n');
  UTL_FILE.FCLOSE(fileHandler);
       dbms_output.put_line('Successfully created file '||SQLERRM);     

EXCEPTION
  WHEN utl_file.invalid_path THEN
     raise_application_error(-20000, 'ERROR: Invalid PATH FOR file.');
     dbms_output.put_line('failed in 2');
WHEN OTHERS THEN
     dbms_output.put_line('failed in 3'||SQLERRM);     
END;

-----------------------------------Debug Test


SELECT DISTINCT OBJECT_TYPE From user_objects WHERE object_name LIKE ''
---------------------------
: Invalid Agent Bank Details
 select  distinct entityid,substr(entityid,5,20) pattern_Entityid,BANKCODE,BRANCHCODE,ACCOUNTTYPE,ACCOUNTNUMBER,ACCOUNTNAME from entitybankdetailstbl where length ( ACCOUNTNUMBER) <8 
 and ACCOUNTNUMBER not in ('9999999','999999' )
 and ENTITYTYPE='I'
 
 -------------------------------------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------------------------------------
 select RPLINKID,RPID,RPLINKLEVEL,UNITHOLDERID,MAKER_ID,RELATIONSHIP,RECEIVEREPORTS, Decode(nvl(CPID,'#'),'#','Non-MIG','MIG') MIG 
    --RECEIVEREPORTS,decode(maker_id,'MIGRATION','MIGRATION','BAU-Updated') USER_USED,count(1) 
    from RELATEDPARTYLINKMAPTBL_CUSTOM ,
     (select distinct CPID from DM_CONNECTEDPARTIESTBL  )
    --(select * from DM_CONNECTEDPARTIESTBL  where rpid =cpid) 
--    where  exists (select * from DM_CONNECTEDPARTIESTBL  where rpid =cpid)
    --and 
    where RECEIVEREPORTS  is not null
    and rpid =cpid (+)
 --   group by RECEIVEREPORTS,decode(maker_id,'MIGRATION','MIGRATION','BAU-Updated');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RTBF GDPR

select distinct FXPXMCID,FXPXSSCOD,FXPXEXCLNT,FXPXEXCSEQ,FXPXSTRDTE,FXPXENDDT,FXPXEMID 

 ,GTAPCUSTOMERID,GTAPUNITHOLDERID
 ,Decode( NVL(FXPXEMID,'N'),'Exemption','E','H') RBTF_Exemption

from dm_unitholderreferencetbl, FXPX 

where dstcustomerid (+) = FXPXEXCLNT and fxpxmcid=dstamccode(+)

order by Decode( NVL(FXPXEMID,'N'),'Exemption','E','H'),FXPXMCID,FXPXEXCLNT 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------HSSIS-19374 salutation issue-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH uh_sal_title AS
		 (SELECT a.unitholderid
				,--COUNT (1)
				 salutation
				,title
				,firstname
				,lastname
				,REGEXP_REPLACE (TRIM (salutation), '(^[[:space:]]+)|([[:space:]]+$)', NULL) salu_comp
				,REGEXP_REPLACE (TRIM (title), '(^[[:space:]]+)|([[:space:]]+$)', NULL) title_comp
				,REGEXP_REPLACE (TRIM (LOWER (REPLACE (title, '.', '')) || lastname), '(^[[:space:]]+)|([[:space:]]+$)', NULL) title_lastnam_comp
			FROM unitholdertbl_custom a, unitholdertbl b
		   WHERE a.unitholderid = b.unitholderid
			 AND TRIM (salutation) IS NOT NULL
			 AND title IS NOT NULL)
SELECT unitholderid
	  ,--COUNT (1)
	   salutation
	  ,title
	  ,firstname
	  ,lastname
	  ,--, LOWER(replace(SALU_COMP,' ','') ),LOWER(REPLACE(TITLE_COMP,'.','')),
	   CASE
		   WHEN LENGTH (salu_comp) = LENGTH (title_comp)
			AND LOWER (REPLACE (salu_comp, ' ', '')) = LOWER (REPLACE (title_comp, '.', '')) THEN
			   'TITLE_MATCH_SALUTATION'
		   WHEN INSTR (LOWER (REPLACE (salu_comp, ' ', '')), LOWER (REPLACE (title_lastnam_comp, ' ', ''))) > 0 THEN
			   'TITLE_LASTNAME_IN_SALUTATION'
		   WHEN INSTR (LOWER (REPLACE (salu_comp, ' ', '')), LOWER (REPLACE (title_comp, '.', ''))) > 0 THEN
			   'TITLE_IN_SALUTATION'
		   ELSE
			   'TITLE_DIFF_SLUTATION'
	   END
		   data_type
  FROM uh_sal_title
--where unitholderid ='UKTRA9868362'

SELECT *
  FROM (
		   SELECT DISTINCT uh.unitholderid
		   ,addresstype
						  ,uh.addressline4
						  ,uh.country
						   ,cntry.dstparamtext sourceadd45
			 FROM uhcontactinfotbl uh
				 ,(
					  SELECT dstparamvalue
							,dstparamtext
							,fcisparamvalue
							,fcisparamtext
						FROM dmt_paramstbl
					   WHERE fcisparamcode = 'COUNTRYCODES'
				  ) cntry
			WHERE uh.country = cntry.fcisparamvalue
	   )
 WHERE INSTR (addressline4, sourceadd45) > 0;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT a.fxnmcid,
       a.fxnfundt,b.fxbfundt,
       a.fxnfund,
       a.fxnprcamt/100 latest_price,
       SUM(b.fxbtotsu) total_settled_units,
       SUM(b.fxbtotsu * a.fxnprcamt/100) AS total_settled_aum,
       SUM(fxbtotun) total_unsettled_units,
       SUM(b.fxbtotun * a.fxnprcamt/100) AS total_unsettled_aum
FROM --- latest price FXN
(SELECT * FROM FXN p where p.FXNVALNO in (select max(to_number(x.FXNVALNO ))from fxn x where x.fxnfund=p.fxnfund )
  and FXNPRCTYP in ('11','03')) a,
     fxb b
WHERE a.fxnmcid = b.fxbmcid AND
  NVL(TRIM(a.fxnfundt),NVL(TRIM(b.fxbfundt),'#')) = NVL(TRIM(b.fxbfundt),NVL(TRIM(a.fxnfundt),'#')) AND
  a.fxnfund = b.fxbfund
  AND FXNFUND='APQ' 
GROUP BY
 a.fxnmcid,
 a.fxnfundt,b.fxbfundt,
 a.fxnfund,
        a.fxnprcamt
 order by  a.fxnfundt,a.fxnfund; 

select distinct fundid ,fundbasecurrency from funddemographicstbl 

select * from SYSPARAMTBL

with fund_aum as 
(
select fundid,DECLAREDNAV,OUTSTANDINGUNITS,ccy,OUTSTANDINGUNITS*DECLAREDNAV fund_aum from fundpricehdrtbl a, 
(select distinct fundid fnd,fundbasecurrency ccy from funddemographicstbl)   
where fundid =fnd 
and effectivedate = (select max(effectivedate) from fundpricehdrtbl b where a.fundid =b.fundid)
and fundid not like 'RE%' 
order by 2 desc)
--select * from fund_aum
select ccy,sum(fund_aum) aum from fund_aum
group by ccy
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------NOminee Accounts------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT distinct fxamcid
	  ,fxauhaccn
	  ,FXANOMIND
	  ,FXACORPTUH 
	  ,gtapcustomerid
	  ,gtapunitholderid
	  ,gtapacctype
	  ,designation
	  ,FXPTYPE
	  ,FXPORG
,FXPSTAT
,FXPTITLE
,FXPSURN
,FXPSUFFIX
,FXPFSTN
,FXPMIDN
,FXPOTHN

  FROM fxa, dm_unitholderreferencetbl,FXP 
 WHERE fxamcid = dstamccode
   AND fxauhaccn = dstunitholderid
   and fxpmcid = dstamccode
   and FXPEXCLNT =dstcustomerid
   AND NVL (TRIM (FXANOMIND), 'N') <> 'N'
   --and FXACORPTUH='Y'
   order by FXACORPTUH,fxamcid,fxauhaccn
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------NOminee Accounts------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   