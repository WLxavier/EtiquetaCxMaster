SELECT 
	NUMOS,
	TIPOOS,
	TIPOOS_DESCRICAO,
	NUMTRANSWMS,
	NUMPED,
	NUMLOTE,
	CODENDERECO,
	TOT_ETIQUETA,
	TOTAL_ETIQUETA_IMPRESSAO,
	NUMVOLCLI,
	CAIXA,
	CODBARRA,
	OSINICIO,
	OSFINAL,
	GRUPO,
	TOT_VOLFLOWRACK,
	DEPOSITO,
	RUA,
	PREDIO,
	NIVEL,
	APTO,
	NUMBOX,
	BOX_DESCRICAO,
	NUMVIAS,
	QTPECAS,
	PESOPECA,
	PESOEMBALAGEM,
	TIPOESTOQUE,
	PESOVARIAVEL,
	DTINICIOOS,
	CODCLI,
	CLIENTE,
	MUNICIPIO_COMERCIAL,
	CODPROD,
	CODFAB,
	PRODUTO,
	CODAUXILIAR2,
	CODPRACA,
	CONDICAOVENDA,
	RCA,
	VL_UNIT,
	VL_TOTAL,
	VL_ATEND,
	FRETEDESPACHO,
	SEQROTA,
	PRACA,
	CODROTA,
	ROTA,
	LETRAS,
	ESTACAO,
	NUMAPANHAS,
	CLI_FANTASIA,
	FUNCGER_NOME,
	UNIDADE,
	UNIDADEMASTER,
	EMBALAGEM,
	EMBALAGEMMASTER,
	MARCA,
	DESTINO,
	NUMCAR,
	CASE 
		WHEN CAST(:QT AS NUMERIC) IS NOT NULL THEN CAST(:QT AS NUMERIC)
		WHEN QT IS NOT NULL THEN QT 
   		ELSE QT 
	END AS QT,
	PESO,
	VOLUME,
	QTUNITCX,
	NUMPALETE,
	NUMSEQENTREGA,
	TOTVOL,
	NUMORDEMCARGA,
	LETRASNUMORDEMCARGA,
	NUMSEQMONTAGEM,
	TIPOPROD,
	PRAZO1,
	PRAZO2,
	PRAZO3,
	PRAZO4,
	PRAZO5,
	PRAZO6,
	PRAZO7,
	PRAZO8,
	PRAZO9,
	PRAZO10,
	PRAZO11,
	PRAZO12,
	CAIXAVOLUMEID,
	TOTALVOLUMEID,
	VOLUMEID,
	TRANSPORTADORA,
	LETRAS_CODCLI,
	NUMTRANSVENDA,
	NUMNOTA,
	TOTVOLPRODPEDIDO,
	NUMVOLPRODPEDIDO,
	TOTVOLPRODINTERVALOOS,
	CODGRUPO,
	DTVALIDADE
	FROM
(SELECT DISTINCT                                                                                                             
  M.NUMOS,                                                                                                                  
  M.TIPOOS,                                                                                                                 
  T.DESCRICAO AS TIPOOS_DESCRICAO,                                                                                          
  M.NUMTRANSWMS,                                                                                                            
  M.NUMPED,                                                                                                                 
VI.NUMLOTE,
  E.CODENDERECO,                                                                                                            
  TRUNC(SUM(M.QT)/P.QTUNITCX) TOT_ETIQUETA,                                                                                 
  1 TOTAL_ETIQUETA_IMPRESSAO,                                                                                               
  (SELECT SUM(CEIL(X.QT/Z.QTUNITCX)) FROM PCMOVENDPEND X, PCPRODUT Z, PCENDERECO Y                                          
    WHERE X.NUMPED=M.NUMPED                                                                                                 
      AND X.NUMOS = M.NUMOS                                                                                                 
      AND X.NUMTRANSWMS = M.NUMTRANSWMS                                                                                     

      AND X.CODPROD=Z.CODPROD                                                                                               
      AND X.TIPOOS=20                                                                                                       
      AND Y.CODENDERECO=X.CODENDERECO                                                                                       
      AND X.DTESTORNO IS NULL) NUMVOLCLI,                                                                                   
  1 CAIXA,                                                                                                                  
  TO_CHAR(NVL(M.NUMOS,0),'FM0000000000') || TO_CHAR(1, 'FM0000') CODBARRA,                                              
  (SELECT MIN(NUMOS) FROM PCMOVENDPEND WHERE (  PCMOVENDPEND.NUMOS in (:NUMOS)) ) OSINICIO, 
  (SELECT MAX(NUMOS) FROM PCMOVENDPEND WHERE (  PCMOVENDPEND.NUMOS in (:NUMOS)) ) OSFINAL,  
  TO_CHAR(E.CODENDERECO,'0000000000')||                                                                                   
  TO_CHAR(M.CODPROD,'0000000000')||                                                                                       
  TO_CHAR(C.CODCLI,'0000000000')||                                                                                        
  TO_CHAR(M.NUMTRANSWMS,'0000000000') GRUPO,                                                                              
  CASE WHEN (SELECT COUNT(MAX(V.NUMVOL)) FROM PCVOLUMEOS V , PCMOVENDPEND M1                                                
              WHERE M1.TIPOOS  IN (22)                                                                                      
               AND V.NUMOS = M1.NUMOS                                                                                       
               AND M1.NUMPED = M.NUMPED                                                                                     
               AND M1.NUMTRANSWMS = M.NUMTRANSWMS                                                                           
               AND M1.NUMOS = M.NUMOS                                                                                       
                GROUP BY V.NUMOS) > 0                                                                                       
       THEN 'EXISTE(M) '|| (SELECT TO_CHAR(MAX(V.NUMVOL)) FROM PCVOLUMEOS V, PCMOVENDPEND M1                              
                             WHERE V.NUMOS = M1.NUMOS                                                                       
                              AND M1.TIPOOS IN(22)                                                                          
                              AND M1.NUMPED = M.NUMPED                                                                      
                              AND M1.NUMOS = M.NUMOS                                                                        
                              AND M1.NUMTRANSWMS = M.NUMTRANSWMS                                                            
                         GROUP BY V.NUMOS)||' VOLUME(S) FLOW-RACK'                                                        
       ELSE NULL END AS TOT_VOLFLOWRACK,                                                                                    
  E.DEPOSITO,                                                                                                               
  E.RUA,                                                                                                                    
  E.PREDIO,                                                                                                                 
  E.NIVEL,                                                                                                                  
  E.APTO,                                                                                                                   
  NVL(MAX(M.NUMBOX), MAX(M.CODBOX)) AS NUMBOX,                                                                              
  B.DESCRICAO BOX_DESCRICAO,                                                                                                
  NVL(M.NUMVIAS,0) NUMVIAS,                                                                                                 
  (CASE WHEN P.TIPOESTOQUE = 'FR' AND P.PESOVARIAVEL ='S'                                                               
        THEN NVL(M.QTPECAS,(CEIL(SUM(M.QT)/DECODE(P.PESOPECA,0,1,NULL,1,P.PESOPECA)))) ELSE 0 END) AS QTPECAS,              
  P.PESOPECA,                                                                                                               
  P.PESOEMBALAGEM,                                                                                                          
  DECODE(P.TIPOESTOQUE,'PA','PADRÃO', 'FR', 'FRIOS') AS TIPOESTOQUE,                                                
  DECODE(P.PESOVARIAVEL,'S','SIM','N','NÃO') AS PESOVARIAVEL,                                                       
  TRUNC(M.DTINICIOOS) DTINICIOOS,                                                                                           
  C.CODCLI,                                                                                                                 
  C.CLIENTE,                                                                                                                
  C.MUNICENT AS MUNICIPIO_COMERCIAL,                                                                                        
  P.CODPROD,                                                                                                                
  P.CODFAB,                                                                                                                 
  P.DESCRICAO PRODUTO,                                                                                                      
  P.CODAUXILIAR2,                                                                                                           
  PC.CODPRACA,                                                                                                              
  (PC.CONDVENDA) AS CONDICAOVENDA,                                                                                          
  (SELECT U.CODUSUR||'-'||U.NOME FROM PCUSUARI U WHERE U.CODUSUR = PC.CODUSUR) RCA,                                       
  (SELECT AVG(NVL(I.PVENDA,0)) FROM PCPEDI I WHERE I.NUMPED = PC.NUMPED AND M.CODPROD = I.CODPROD) VL_UNIT,                 
  (SUM(M.QT) * (SELECT MIN(I.PVENDA) FROM PCPEDI I                                                                          
                 WHERE I.NUMPED = PC.NUMPED                                                                                 
                  AND M.CODPROD = I.CODPROD)) VL_TOTAL,                                                                     
  (SELECT SUM(I.PVENDA * M1.QT) FROM PCPEDI I, PCMOVENDPEND M1                                                              
    WHERE I.NUMPED = PC.NUMPED                                                                                              
     AND I.NUMPED = M1.NUMPED                                                                                               
     AND I.CODPROD = M1.CODPROD                                                                                             
     AND M1.DTESTORNO IS NULL  )VL_ATEND,                                                                                   
  DECODE (PC.FRETEDESPACHO ,'C','CIF','F','FOB','G','GRATUITO') FRETEDESPACHO,                                  
  (SELECT SEQROTA FROM PCPRACA WHERE CODPRACA =PC.CODPRACA) SEQROTA,                                                        
  (SELECT PRACA FROM PCPRACA WHERE CODPRACA =PC.CODPRACA) PRACA,                                                            
  (SELECT ROTA FROM PCPRACA WHERE CODPRACA =PC.CODPRACA) CODROTA,                                                           
  (SELECT R.DESCRICAO FROM PCROTAEXP R, PCPRACA P                                                                           
    WHERE P.ROTA=R.CODROTA                                                                                                  
     AND P.CODPRACA =PC.CODPRACA) ROTA,                                                                                     
  LETRAS(NVL(PC.NUMSEQROTA,0)) LETRAS,                                                                                      
  E.ESTACAO,                                                                                                                
  (SELECT COUNT(DISTINCT MM.CODENDERECO) FROM PCMOVENDPEND MM                                                               
     WHERE MM.POSICAO = 'P'                                                                                               
       AND MM.TIPOOS = 20                                                                                                   
       AND MM.CODOPER = 'S'                                                                                               
       AND MM.DTESTORNO IS NULL                                                                                             
       AND (  MM.NUMOS in (:NUMOS)) ) NUMAPANHAS,                                           
  C.FANTASIA CLI_FANTASIA,                                                                                                  
  (SELECT (MATRICULA || ' - ' || NOME) FROM PCEMPR WHERE MATRICULA = M.CODFUNCGER) FUNCGER_NOME,                          
  P.UNIDADE,                                                                                                                
  P.UNIDADEMASTER,                                                                                                          
  P.EMBALAGEM,                                                                                                              
  P.EMBALAGEMMASTER,                                                                                                        
  MA.MARCA,                                                                                                                 
  (SELECT X.DESTINO FROM PCCARREG X WHERE X.NUMCAR = M.NUMCAR) DESTINO,                                                     
  M.NUMCAR,                                                                                                                 
  SUM(M.QT) QT,                                                                                                             
  SUM(M.QT) * P.PESOBRUTO PESO,                                                                                             
  SUM(M.QT) * P.VOLUME VOLUME,                                                                                              
  P.QTUNITCX,                                                                                                               
  MIN(M.NUMPALETE) NUMPALETE,                                                                                               
  M.NUMSEQENTREGA,                                                                                                          
  DECODE(NVL((SELECT SUM(M1.NUMVOL) FROM PCMOVENDPEND M1                                                                    
               WHERE M1.NUMOS =  M.NUMOS                                                                                    
                GROUP BY M1.NUMOS),0),0,TRUNC(SUM(M.QT)/P.QTUNITCX),                                                        
             (SELECT SUM(M1.NUMVOL) FROM PCMOVENDPEND M1                                                                    
               WHERE M1.NUMOS =  M.NUMOS                                                                                    
                GROUP BY M1.NUMOS)) AS TOTVOL,                                                                              
  PC.NUMORDEMCARGA,                                                                                                         
  LETRAS(PC.NUMORDEMCARGA) AS LETRASNUMORDEMCARGA,                                                                          
  PC.NUMSEQMONTAGEM,                                                                                                        
  (SELECT DECODE(PCPRODFILIAL.TIPOPROD,1,'GRANDEZA',2,'MIUDEZA',3,'LEVEZA',4,'PERIGOSO',5,'EMBALADO')             
    FROM PCPRODFILIAL                                                                                                       
     WHERE PCPRODFILIAL.CODPROD = M.CODPROD                                                                                 
      AND PCPRODFILIAL.CODFILIAL = M.CODFILIAL) TIPOPROD,                                                                   
  PC.PRAZO1,                                                                                                                
  PC.PRAZO2,                                                                                                                
  PC.PRAZO3,                                                                                                                
  PC.PRAZO4,                                                                                                                
  PC.PRAZO5,                                                                                                                
  PC.PRAZO6,                                                                                                                
  PC.PRAZO7,                                                                                                                
  PC.PRAZO8,                                                                                                                
  PC.PRAZO9,                                                                                                                
  PC.PRAZO10,                                                                                                               
  PC.PRAZO11,                                                                                                               
  PC.PRAZO12,                                                                                                               
                                                                                                                            
   CASE WHEN (SELECT NVL(VALOR,'O')                                                                                       
                FROM PCPARAMETROWMS                                                                                         
                WHERE CODFILIAL = M.CODFILIAL                                                                               
                  AND NOME = 'TIPOVOLUMEPEDIDOVENDA') = 'I' THEN                                                        
          MAX(TO_CHAR(NVL(M.NUMOS,0),'FM0000000000') || TO_CHAR(NVL(G.NUMVOL,1),'FM0000'))                              
       ELSE '0' END CAIXAVOLUMEID,                                                                                        
                                                                                                                            
  CASE WHEN (SELECT NVL(VALOR,'O')                                                                                        
               FROM PCPARAMETROWMS                                                                                          
              WHERE CODFILIAL = M.CODFILIAL                                                                                 
                AND NOME = 'TIPOVOLUMEPEDIDOVENDA') = 'I' THEN                                                          
            (SELECT TO_CHAR(NVL(MAX(NUMVOL),1),'FM0000')                                                                  
               FROM PCVOLUMEOS                                                                                              
              WHERE EXISTS (SELECT 1                                                                                        
                              FROM PCMOVENDPEND MOV                                                                         
                             WHERE MOV.NUMOS = PCVOLUMEOS.NUMOS                                                             
                               AND MOV.DTESTORNO IS NULL                                                                    
                               AND MOV.CODOPER = 'S'                                                                      
                               AND MOV.NUMPED = M.NUMPED) )                                                                 
       ELSE '0' END TOTALVOLUMEID,                                                                                        
                                                                                                                            
  CASE WHEN (SELECT NVL(VALOR,'O')                                                                                        
               FROM PCPARAMETROWMS                                                                                          
              WHERE CODFILIAL = M.CODFILIAL                                                                                 
                AND NOME = 'TIPOVOLUMEPEDIDOVENDA') = 'I' THEN                                                          
            TO_CHAR(NVL(G.NUMVOL,1),'FM0000')                                                                             
       ELSE '0' END VOLUMEID,                                                                                             
                                                                                                                            
  CASE WHEN (SELECT NVL(PCPEDC.CODFORNECFRETE,PCPEDC.CODFORNECREDESPACHO) FROM PCPEDC                                       
              WHERE PCPEDC.NUMPED = M.NUMPED) IS NOT NULL                                                                   
       THEN (SELECT NVL(PCPEDC.CODFORNECFRETE, PCPEDC.CODFORNECREDESPACHO)||' - '||PCFORNEC.FORNECEDOR                    
               FROM PCPEDC, PCFORNEC                                                                                        
              WHERE NVL(PCPEDC.CODFORNECFRETE, PCPEDC.CODFORNECREDESPACHO) = PCFORNEC.CODFORNEC                             
                AND PCPEDC.NUMPED = M.NUMPED)                                                                               
       ELSE NULL END AS TRANSPORTADORA,                                                                                     
  LETRAS(NVL(C.CODCLI,0))LETRAS_CODCLI,                                                                                     
    /* Campos que foram inseridos para não dar erro no group by */                                                          
    M.NUMTRANSVENDA,                                                                                                        
    W.NUMNOTA                                                                                                               
  ,nvl((SELECT COUNT(V.NUMVOL)                                                                                              
         FROM PCVOLUMEOS V , PCMOVENDPEND M1                                                                                
        WHERE M1.TIPOOS  IN (20)                                                                                            
          AND V.NUMOS        = M1.NUMOS                                                                                     
          AND M1.NUMPED      = M.NUMPED                                                                                     
          AND M1.NUMTRANSWMS = M.NUMTRANSWMS                                                                                
          AND M1.NUMOS       = M.NUMOS                                                                                      
          and M1.CODPROD     = M.CODPROD                                                                                    
        GROUP BY M1.CODPROD),0) totvolprodpedido                                                                            
  ,max(m.numvol) numvolprodpedido                                                                                           
  ,nvl((SELECT COUNT(V.NUMVOL)                                                                                              
           FROM PCVOLUMEOS V , PCMOVENDPEND M1                                                                              
          WHERE M1.TIPOOS  IN (20)                                                                                          
            AND V.NUMOS        = M1.NUMOS                                                                                   
            AND M1.NUMPED      = M.NUMPED                                                                                   
            AND M1.NUMTRANSWMS = M.NUMTRANSWMS                                                                              
            AND M1.NUMOS       = M.NUMOS                                                                                    
          GROUP BY M1.numos),0) totvolprodintervaloos,                                                                      
        GR.CODGRUPO                                                                                                         
      ,(case when (pf.ESTOQUEPORDTVALIDADEPK='S') then                                                                    
        (select min(ei2.dtval) from pcestenderecoi ei2 where ei2.codprod=m.codprod and ei2.codendereco=e.codendereco)       
       else null end) DTVALIDADE                                                                                            
  FROM PCMOVENDPEND M,PCENDERECO E,PCCLIENT C,PCPEDC PC,PCPRODUT P,PCMARCA MA,PCPRODFILIAL PF, PCTIPOOS T,                  
       PCBOXWMS B, PCPRACA PR, PCROTAEXP PRE, PCWMS W,                                                                      
   (SELECT GR.CODIGOEST, GR.CODGRUPO, G.CODFILIAL FROM PCWMSGRUPOESTI GR, PCWMSGRUPOEST G WHERE G.CODIGO = GR.CODGRUPO) GR  
     , PCVOLUMEOS G                                                                                                         
     , PCVOLUMEOSI VI
 WHERE M.CODENDERECO    = E.CODENDERECO(+)                                                                                  
   AND M.NUMPED         = PC.NUMPED(+)                                                                                      
   AND PC.CODCLI       = C.CODCLI(+)                                                                                        
   AND P.CODMARCA       = MA.CODMARCA(+)                                                                                    
   AND M.CODPROD        = P.CODPROD                                                                                         
   AND M.CODFILIAL      = PF.CODFILIAL                                                                                      
   AND E.CODFILIAL      = GR.CODFILIAL(+)                                                                                   
   AND M.CODPROD        = PF.CODPROD                                                                                        
   AND M.TIPOOS         = T.CODIGO                                                                                          
   AND M.CODBOX         = B.CODBOX(+)                                                                                       
   AND M.CODFILIAL      = B.CODFILIAL(+)                                                                                    
   AND M.DTESTORNO      IS NULL                                                                                            
   AND M.TIPOOS         = 20                                                                                                
   AND M.CODOPER        = 'S'                                                                                             
   AND E.ESTACAO     = GR.CODIGOEST(+)                                                                                      
   AND NVL(M.NUMPED,0)  <> 0                                                                                                
   AND (  M.NUMOS in (:NUMOS)) 
   AND PF.CODFILIAL     = '1'                                                                                   
   AND M.NUMOS          = G.NUMOS                                                                                           
   AND M.CODENDERECO    = G.CODENDERECO                                                                                     
   AND G.NUMOS          = VI.NUMOS                                                                                          
   AND G.NUMVOL         = VI.NUMVOL                                                                                         
   AND M.CODPROD        = VI.CODPROD
   AND PC.CODPRACA = PR.CODPRACA(+)                                                                                         
   AND PR.ROTA = PRE.CODROTA(+)                                                                                             
   AND M.NUMPED       = W.NUMPED(+)                                                                                         
   AND M.NUMCAR       = W.NUMCAR(+)                                                                                         
   AND M.NUMTRANSWMS  = W.NUMTRANSWMS(+)                                                                                    
   AND M.CODPROD      = W.CODPROD(+)                                                                                        
   AND M.CODPRODACAB = W.CODPRODACAB(+)                                                                                     
GROUP BY                                                                                                                    
      M.NUMOS,M.TIPOOS,T.DESCRICAO,M.NUMPED,                                                                                
      VI.NUMLOTE,
      E.CODENDERECO,M.CODPROD,C.CODCLI,                                                                                     
      M.NUMTRANSWMS,E.DEPOSITO,E.RUA,E.PREDIO,E.NIVEL,E.APTO, B.DESCRICAO, P.QTUNITCX,                                      
      M.NUMVIAS,P.TIPOESTOQUE,P.PESOVARIAVEL,M.QTPECAS,P.PESOPECA,P.PESOEMBALAGEM,                                          
      M.DTINICIOOS, C.CLIENTE,C.MUNICENT,P.CODPROD,P.CODFAB,P.DESCRICAO,P.CODAUXILIAR2,                                     
      PC.CODPRACA,PC.CONDVENDA,PC.CODUSUR,PC.NUMPED,PC.FRETEDESPACHO,PC.NUMSEQROTA,                                         
      E.ESTACAO,C.FANTASIA,M.CODFUNCGER,P.UNIDADE,P.UNIDADEMASTER,P.EMBALAGEM,                                              
      P.EMBALAGEMMASTER,MA.MARCA,M.NUMCAR,P.PESOBRUTO,P.VOLUME,M.NUMSEQENTREGA,                                             
      PC.NUMORDEMCARGA,PC.NUMSEQMONTAGEM,M.CODFILIAL,PC.PRAZO1,PC.PRAZO2,PC.PRAZO3,                                         
      PC.PRAZO4,PC.PRAZO5,PC.PRAZO6,PC.PRAZO7,PC.PRAZO8,PC.PRAZO9,PC.PRAZO10,                                               
      PC.PRAZO11,PC.PRAZO12, G.NUMVOL,PF.TIPOPROD,PF.TIPOPROD, M.NUMTRANSVENDA, W.NUMNOTA, GR.CODGRUPO, GR.CODFILIAL, 
      pf.ESTOQUEPORDTVALIDADEPK,
 M.NUMCAR,E.DEPOSITO,E.RUA,E.PREDIO,E.NIVEL,E.APTO,   M.NUMOS    
, E.DEPOSITO 
, E.RUA      
, E.PREDIO   
, E.NIVEL    
, E.APTO      
 ORDER BY  NUMCAR, DEPOSITO, RUA, PREDIO, NIVEL, APTO,    NUMOS    
,  DEPOSITO 
,  RUA      
,  PREDIO   
,  NIVEL    
,  APTO     ,  NUMPED) TAB
 WHERE 1 = 1
 AND VOLUMEID = TO_CHAR(NVL(CAST(:VOLUMEID AS NUMERIC),1),'FM0000')
