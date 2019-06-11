/**********************************************************

   LAICA/ED4XU editor de textos con lenguaje de macros propio
   
   Autor: Daniel Stuardo
   
   daniel.stuardo@gmail.com
   
   noviembre 2018, 2019.
   
   Editor hecho con Harbour 3.0 y ansi C. Parte del código
   escrito es una adaptación de código C Harbour, o un uso
   completo, y otra parte fue escrito por el autor en años
   anteriores, cuando no conocía Harbour y pensaba que no había
   conocido funciones de proceso de texto más geniales que las
   de Clipper.
   
   Dejo mucho código comentado, por que no lo uso, pero
   podría ser útil para alguien más.
   
   Agradecimientos a todos los mencionados en este programa
   cuyos aportes potenciaron a Xu.
   
   Si va a utilizar parte del código que no es Harobur y que
   es propiedad del autor, hágalo, pero mencione quién lo 
   escribió.
   
***********************************************************/  

#include "fileio.ch"
#include "directry.ch"
#include "inkey.ch"
#include "achoice.ch"
#include "memoedit.ch"
//#include "hbextcdp.ch"


REQUEST HB_LANG_ES
HB_LANGSELECT( "ES" )
REQUEST HB_CODEPAGE_UTF8
hb_cdpSelect( "UTF8" )

FUNCTION MAIN
///param _file

//setmode(25,80)

public _CR:=HB_OSNewline()

numParam:=PCOUNT()

SETCANCEL(.F.)

public MOUSEPRESENT:=.F.
    IF MPRESENT()                                                                                              
       MOUSEPRESENT:=.T.
       set( _SET_EVENTMASK, INKEY_ALL ) 
       mSetCursor( .t. ) 
    ENDIF 



SET SCOREBOARD OFF
SET ESCAPE ON
SET DATE FRENCH
SET CENTURY ON

public NUMPI:=3.14159265358979323846

public hARCHIVO := ""
public PATH_BINARY
public PATH_SOURCE
public PATH_LOG
public PATH_DEBUG
public PATH_HELP
public PATH_TEMP
public SW_CLEAR_LOG
public PATH_XU

public _fileSeparator

// buffer de copia de texto
public BUFFER:={},SW_HAYBUFFER:=.F. //debe copiar en cualquier archivo
public SWMARCA:=.F.
public DEFTOKEN:=","; DEFROUND:=13
public LISTAEXPRESION:={}  // gusrda expresiones exitosas
public LISTABUSQUEDA:={}   // guarda palabras buscadas y reemplazadas

// variables del editor
public cEDITOR:=112  //15
public cTEXTO:=112 
public tTEXTO:=cTEXTO
public cBARRA:=11  // 2=verde 14=amarillo
public cTITULO:=12
public cMENU:=11  // 2
public cSELECT:=71
public cTABULA:=3
public cSECCION:=121
public cKEYWORD:=120
public cCURSORMOD:=12
public cDESTACADO:=56
public cCADENA:=116
//public cEDITINC:=113
public SWCOLORTEXTO:=0
public cEDITCOM:=117
public cEDITDEF:=122
public cHELP:=7
public cDESPLAZAMIENTO:=5
public cMAPACOLORES:=""
public cLENMAPACOLORES:=0
public cPAGINA:=MAXROW()-4  // menos 3 menos el encabezado
///public SWBLOQUE:=0
public SW_CODESP
public TMPDIRECTORY:=""
public BAKDIRECTORY:=""
public EXEDIRECTORY:=""
public SWELIMINATAB:=.F.
public OPERATING_SYSTEM:=""
public EXTENSION:=1
public OSSYSTEM:=OS()
       OSSYSTEM:=upper(alltrim(substr(OSSYSTEM,1,at(" ",OSSYSTEM))))
public SWBINARY:=.F.

public SWCTRLJCTRKV:=.F.
public SWTEXTOMODIFICADO:=.F.

public lDEFINE:={}
public lSECCION:={}
public lKEYWORD:={}

public RBUFFER:={}, SWRECBUFFER:=.T.  // resultados de OPE. recupera BUFFER por defecto.

public BUFFER_CTRLZ:={},LINBUFFCTRLZ:={}   // CTRL-Z deshacer comando anterior en modo lineas marcadas

///public _ARCHIVO
public SLINEA,TLINEA,BASELINE,HELP1,HELP2,SWLENGUAJE
public ESEJECUTABLE,COMPILADOR, EJECUTOR, DESCRIPCION, PARAMETROS, COMENTARIOS,METADATA, cMETADATA
public LISTACOMPILA:={}
public cCOLORES:={}
public COMMANDS,OUTPUTCOMM,COMANDO
public SWNOEXE:=.F.
public SW_PASTE:=.F.
public SWNOTNUL:=.F.
public SWKEEPVACIO:=.F.
public SWNOBUFFER:=.F.
public SWSENSITIVE:=.T.
public SWRADIANES:=.T.
public SWSOURCE:=.T.
public CORDEL  // cordel de archivos en edición
public SWGRMODE:=.T.   // usa gnome-terminal
public STRSP:=""
public cRESULTBUFFER:={}


tmp := CMDSYSTEM('gnome-terminal -- bash -c "exit" </dev/null >/dev/null 2>&1',0)
if tmp!=0
   SWGRMODE:=.F.
end

PATH_XU:=_Carga_Configuracion()


public ACTUALDIR:=_fileSeparator+CURDIR()+_fileSeparator
public HOME:=getenv("HOME")+_fileSeparator

public TEXTOTIPO:="",LENTEXTOTIPO:=0   // muestra el tipo del texto

public HUEVO:=""
public BUFFERKT:=""  // buffer para CTRL-KT y CTRL-KR

CLEAR
SLINEA:=MAXCOL()  //-2
TLINEA:=MAXROW()
BASELINE:=REPLICATE(" ",512)   
/*
HELP1:="  MAIN  "+CHR(240)+"  ^O  Help      ^Q  Quit    ^T  Top      ^J  Jump   ^N  Find   ^Y  Ins Rmks   ESC  Shell Cmds  "+CHR(240)+"   Enjoy  "+CHR(1)
HELP2:="  MENU  "+CHR(240)+"  ^P  Compile   ^W  Write   ^B  Bottom   ^K  Edit   ^L  Calc   ^V  Ins Code   F2   Open File   "+CHR(240)+"   Edit4Xu!"
*/
     HELP1:="  MAIN  "+CHR(240)+"  ^O Help      ^Q Quit    ^J Jump       ^N Find   ^Y Ins Rmks   ^Z Undo     "
     HELP2:="  MENU  "+CHR(240)+"  ^P Compile   ^W Write   ^U Sel File   ^K Edit   ^L Macros     ^V Ins Code "


CARGA_COMPILADORES(PATH_XU,_fileSeparator)  // lineas de compilacion y parametros.
METADATA:={}   // archivo
cMETADATA:={}  // datos de edicion
tTEXTO:=cTEXTO
ESEJECUTABLE:=.F.
COMPILADOR:="" 
EJECUTOR:="" 
DESCRIPCION:=""
COMENTARIOS:=""
COMMANDS:={}
OUTPUTCOMM:={}
COMANDO:=""


if numParam>1
   //_arr_par:=array(numParam-1)
   _arr_par:=array(numParam)

   //_file:=hb_pValue(1)    // el nombre del archivo

   iParam:=1
   //  rellenar array de parametros para distribuir despues de la carga de variables

   WHILE iParam<=numParam
      ///_arr_par[iParam-1]:=hb_pValue(iParam)
      _arr_par[iParam]:=hb_pValue(iParam)
      ++iParam
   END
elseif numParam==1
   _file:=hb_pValue(1)
else
/*   outstd(_CR+"Modo de uso:"+_CR+_CR+"  ./ed4xu archivo.ext [-t dirTemp][-b dirBak][-e dirExe]"+_CR;
          +_CR+"ED4XU aborta."+_CR)
   quit */
   numParam:=1
   _file:=ACTUALDIR+"unnamed"
end
         
//   cargar archivo, set de archivos desde file.xued, o lista de archivos, *.ext, o nombres 
//   ebe aceptar path/*.ext, -d directorio (menos los *.ext~) XXX 
//   pi,p,px,py,lini,lfin,cini
//

if numParam>1
   for i:=1 to len(_arr_par)
      STRING:=_arr_par[i]

      /*** verifica "-t" directorios de archivos temporales ***/
      if STRING=="-t"
         if i==len(_arr_par)
            outstd(_CR+"Parametro '-t' incompleto."+_CR+;
                    "LAICA aborta."+_CR)
            quit
         end
         STRING:=_arr_par[++i]  // directorio
         tmp:=CMDSYSTEM("test -d "+STRING,0)
         if tmp==0
            TMPDIRECTORY:=STRING+_fileSeparator
         else
            tmp:=CMDSYSTEM("mkdir "+STRING+" </dev/null >/dev/null 2>&1",0)
            TMPDIRECTORY:=STRING+_fileSeparator
         end

      elseif STRING=="-noterm"   // para entornos no gráficos. ejecuta en la misma pantalla
         SWGRMODE:=.F.
      
      elseif STRING=="-hex"   // carga binario automaticamente
         SWBINARY:=.T.

/*      elseif STRING=="-eggs"  .or. STRING=="-dalien" // huevito de pascua
         feggs:=PATH_XU+_fileSeparator+"binary"+_fileSeparator+"xuvm"+strzero(ceiling(hb_random(10)),2)+".bin"
        // ? feggs ; inkey(0)
         //feggs:="eggs01.bin"
         if file(feggs)
            fp:=fopen(feggs,0)
            _nl:=fseek(fp,0,2)
            fseek(fp,0,0)
            HUEVO:=""
            c:="    "
            for j:=1 to _nl/4
               fread(fp,@c,4)
               HUEVO+=chr(bin2i(c))
            end
            fclose(fp)
         end*/

      /*** verifica directorio de respaldo ***/
      elseif STRING=="-b"
         if i==len(_arr_par)
            outstd(_CR+"Parametro '-b' incompleto."+_CR+;
                    "LAICA aborta."+_CR)
            quit
         end
         STRING:=_arr_par[++i]  // directorio
         tmp:=CMDSYSTEM("test -d "+STRING,0)
         if tmp==0
            BAKDIRECTORY:=STRING+_fileSeparator
         else
            tmp:=CMDSYSTEM("mkdir "+STRING+" </dev/null >/dev/null 2>&1",0)
            BAKDIRECTORY:=STRING+_fileSeparator
         end
      /*** verifica directorio de ejecutables ***/
/*      elseif STRING=="-e"
         if i==len(_arr_par)
            outstd(_CR+"Parametro '-e' incompleto."+_CR+;
                    "LAICA aborta."+_CR)
            quit
         end
         STRING:=_arr_par[++i]  // directorio
         tmp:=CMDSYSTEM("test -d "+STRING,0)
         if tmp==0
            EXEDIRECTORY:=STRING+_fileSeparator
         else
            tmp:=CMDSYSTEM("mkdir "+STRING+" </dev/null >/dev/null 2>&1",0)
            EXEDIRECTORY:=STRING+_fileSeparator
         end */
            
      /*** analiza "-d" para editar carpetas completas ***/
      elseif STRING=="-d"
         if i==len(_arr_par)
            outstd(_CR+"Parametro '-d' incompleto."+_CR+;
                    "LAICA aborta."+_CR)
            quit
         end
         STRING:=_arr_par[++i]  // directorio
         tmp:=CMDSYSTEM("test -d "+STRING,0)
         if tmp==0   // prepara espacio de trabajo, creando los directorios correspondientes
            // verifica archivos temporales
            tmp:=CMDSYSTEM("test -d "+STRING+_fileSeparator+"tmp/",0)
            if tmp==0
               TMPDIRECTORY:=STRING+_fileSeparator+"tmp/"
            else
               tmp:=CMDSYSTEM("mkdir "+STRING+_fileSeparator+"tmp/"+" </dev/null >/dev/null 2>&1",0)
               TMPDIRECTORY:=STRING+_fileSeparator+"tmp/"
            end
            // verifica directorio de respaldo
            tmp:=CMDSYSTEM("test -d "+STRING+_fileSeparator+"bak/",0)
            if tmp==0
               BAKDIRECTORY:=STRING+_fileSeparator+"bak/"
            else
               tmp:=CMDSYSTEM("mkdir "+STRING+_fileSeparator+"bak/"+" </dev/null >/dev/null 2>&1",0)
               BAKDIRECTORY:=STRING+_fileSeparator+"bak/"
            end
            // verifica directorio de ejecutables
            tmp:=CMDSYSTEM("test -d "+STRING+_fileSeparator+"exe/",0)
            if tmp==0
               EXEDIRECTORY:=STRING+_fileSeparator+"exe/"
            else
               tmp:=CMDSYSTEM("mkdir "+STRING+_fileSeparator+"exe/"+" </dev/null >/dev/null 2>&1",0)
               EXEDIRECTORY:=STRING+_fileSeparator+"exe/"
            end
         else  // directorio fue mal puesto. SALIR.
            outstd(_CR+"El directorio de archivos no pudo ser encontrado."+_CR+;
                    "LAICA aborta."+_CR)
            quit
         end   
         str:=FUNFSHELL("ls -l "+STRING+" | awk '{if(substr($1,1,1)=="+chr(34)+"-"+chr(34)+"&&substr($9,length($9),1)!="+chr(34)+"~"+chr(34)+")print $9}'",3)
         nLen := mlcount(str,256)
         if nLen>0
            for j:=1 to nLen
               aName := alltrim(memoline(str,256,j))
               EXT:=substr(aName,rat(".",aName)+1,len(aName))
               ESEJECUTABLE:=.F.
               COMPILADOR:="" 
               EJECUTOR:="" 
               DESCRIPCION:=""
               for k:=1 to len(LISTACOMPILA)
                  if EXT==LISTACOMPILA[k][1]
                     COMPILADOR:=LISTACOMPILA[k][2]
                     EJECUTOR:=LISTACOMPILA[k][3] 
                     DESCRIPCION:=LISTACOMPILA[k][4]
                     COMENTARIOS:=LISTACOMPILA[k][5]
                     ESEJECUTABLE:=iif(LISTACOMPILA[k][6]=="e",.T.,.F.)
                     exit
                  end
               end
               if SWSOURCE
                  if EXT=="xu"
                     AADD(METADATA,PATH_SOURCE+_fileSeparator+aName)
                  elseif EXT=="def"
                     AADD(METADATA,PATH_INCLUDE+_fileSeparator+aName)
                  else
                     AADD(METADATA,STRING+_fileSeparator+aName)
                  end
               else
                  AADD(METADATA,STRING+_fileSeparator+aName)
               end
               AADD(cMETADATA,{aName,1,1,1,1,1,100,0,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,ESEJECUTABLE,COMENTARIOS,"",;
                               TEXTOTIPO,LENTEXTOTIPO})
            end
         else  // directorio fue mal puesto. SALIR.
            /*outstd(_CR+"No existen archivos en el directorio especificado."+_CR+;
                    "ED4XU aborta."+_CR)
            quit*/
            _file:=ACTUALDIR+STRING+_fileSeparator+"unnamed"
            COMPILADOR:="" 
            EJECUTOR:="" 
            DESCRIPCION:=""
            AADD(METADATA,_file)
            AADD(cMETADATA,{"unnamed",1,1,1,1,1,100,0,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,ESEJECUTABLE,COMENTARIOS,"",;
                   TEXTOTIPO,LENTEXTOTIPO})
         end
      elseif substr(STRING,1,1)=="-"
         outstd(_CR+"Opcion "+STRING+" no reconocida."+_CR;
          +_CR+"LAICA aborta."+_CR)
         quit
      else
      /** **/
         if at(_fileSeparator,STRING)==0
            STRING:=ACTUALDIR+STRING
         end
         EXT:=substr(STRING,rat(".",STRING)+1,len(STRING))
         COMPILADOR:="" 
         EJECUTOR:="" 
         DESCRIPCION:=""
         for j:=1 to len(LISTACOMPILA)
            if EXT==LISTACOMPILA[j][1]
               COMPILADOR:=LISTACOMPILA[j][2]
               EJECUTOR:=LISTACOMPILA[j][3] 
               DESCRIPCION:=LISTACOMPILA[j][4]
               COMENTARIOS:=LISTACOMPILA[j][5]
               ESEJECUTABLE:=iif(LISTACOMPILA[j][6]=="e",.T.,.F.)
               exit
            end
         end
         if SWSOURCE
            if EXT=="xu"
               STRING:=substr(STRING,rat("/",STRING)+1,len(STRING))
               //AADD(METADATA,STRING)
               AADD(METADATA,PATH_SOURCE+_fileSeparator+STRING)
            elseif EXT=="def"
               STRING:=substr(STRING,rat("/",STRING)+1,len(STRING))
               AADD(METADATA,PATH_INCLUDE+_fileSeparator+STRING)
            else
               AADD(METADATA,STRING)
               STRING:=substr(STRING,rat("/",STRING)+1,len(STRING))
            end
         else
            AADD(METADATA,STRING)
            STRING:=substr(STRING,rat("/",STRING)+1,len(STRING))
         end
         AADD(cMETADATA,{STRING,1,1,1,1,1,100,0,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,ESEJECUTABLE,COMENTARIOS,"",;
                         TEXTOTIPO,LENTEXTOTIPO})
      end
   end
   //inkey(0)
   if len(METADATA)==0
       outstd(_CR+"Modo de uso:"+_CR+_CR+"  laica archivo.ext [-t dirTemp][-b dirBak]"+_CR;
          +_CR+"LAICA aborta."+_CR)
       quit
   end
   _file:=METADATA[1]
else
   if at(_fileSeparator,_file)==0
       _file:=ACTUALDIR+_file
   end
   EXT:=substr(_file,rat(".",_file)+1,len(_file))
   COMPILADOR:="" 
   EJECUTOR:="" 
   DESCRIPCION:=""
   for i:=1 to len(LISTACOMPILA)
      if EXT==LISTACOMPILA[i][1]
         COMPILADOR:=LISTACOMPILA[i][2]
         EJECUTOR:=LISTACOMPILA[i][3] 
         DESCRIPCION:=LISTACOMPILA[i][4]
         COMENTARIOS:=LISTACOMPILA[i][5]
         ESEJECUTABLE:=iif(LISTACOMPILA[i][6]=="e",.T.,.F.)
         exit
      end
   end
   if SWSOURCE
      if EXT=="xu"
         STRING:=substr(_file,rat("/",_file)+1,len(_file))
         //AADD(METADATA,STRING)
         AADD(METADATA,PATH_SOURCE+_fileSeparator+STRING)
      elseif EXT=="def"
         STRING:=substr(_file,rat("/",_file)+1,len(_file))
         //AADD(METADATA,STRING)
         AADD(METADATA,PATH_INCLUDE+_fileSeparator+STRING)
      else
         AADD(METADATA,_file)
         STRING:=substr(_file,rat("/",_file)+1,len(_file))
      end
   else
      AADD(METADATA,_file)
      STRING:=substr(_file,rat("/",_file)+1,len(_file))
   end
   AADD(cMETADATA,{STRING,1,1,1,1,1,100,0,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,ESEJECUTABLE,COMENTARIOS,"",;
                   TEXTOTIPO,LENTEXTOTIPO})
   _file:=METADATA[1]
end

BUFFER:={}  // inicializa el buffer de copia.

CORDEL:={}   // tendedero de ropa

SetTypeahead(2048)  // buffer general de teclado

WHILE len(alltrim(_file))>0
   PARAMETROS:=""
   EXT:=substr(_file,rat(".",_file)+1,LEN(_file))
   COMPILADOR:="" 
   EJECUTOR:="" 
   DESCRIPCION:=""
   for j:=1 to len(LISTACOMPILA)
      if EXT==LISTACOMPILA[j][1]
         COMPILADOR:=LISTACOMPILA[j][2]
         EJECUTOR:=LISTACOMPILA[j][3] 
         DESCRIPCION:=LISTACOMPILA[j][4]
         COMENTARIOS:=LISTACOMPILA[j][5]
         ESEJECUTABLE:=iif(LISTACOMPILA[j][6]=="e",.T.,.F.)
         exit
      end
   end
   SWLENGUAJE:=1
   EXTENSION:=1  // asume comillas doble y simple como string. 1=$ de latex
   IF EXT=="xu"
      FILE:=_file  //PATH_SOURCE+_fileSeparator+_file
      STRING:="// Programa XU"+_CR+"//#use "+_CR+_CR+"//#include "+_CR+_CR+"name: <descripcion del programa>"+_CR+_CR+"vars:"+_CR+;
              "   "+_CR+"//functions:"+_CR+_CR+"algorithm:"+_CR+"   "+_CR+"stop"
      SWLENGUAJE:=1
   ELSEIF EXT=="def"
      FILE:=_file    //PATH_INCLUDE+_fileSeparator+_file
      STRING:="// Archivo de definiciones XU"+_CR+"#define " 
      SWLENGUAJE:=1
   ELSEIF EXT=="c"
      FILE:=_file
      STRING:="// Programa C"+_CR+"#include <stdio.h>"+_CR+"//vars:"+_CR+"//functions:"+_CR+"//algorithm:"+_CR+"int main( int argc, char *argv[] )"+_CR+"{"+_CR+_CR+"   return 0;"+_CR+"}"
      SWLENGUAJE:=2
   ELSEIF EXT=="h"
      FILE:=_file
      STRING:="// Archivo header C"+_CR+"#define "
      SWLENGUAJE:=2
   ELSEIF EXT=="prg"
      FILE:=_file
      STRING:="// Archivo Harbour"+_CR+"function main()"+_CR+_CR+"return nil"
      SWLENGUAJE:=2
   ELSEIF EXT=="ch"
      FILE:=_file
      STRING:="// Archivo header Harbour"+_CR+"#define "
      SWLENGUAJE:=2
   ELSEIF EXT=="tex"
      FILE:=_file
      STRING:="% Documento PDFLATEX"+_CR+;
              "%Preambulo del documento"+_CR+"\documentclass[a4paper,12pt]{article}"+_CR+_CR+;
              "\usepackage[utf8]{inputenc}"+_CR+"\usepackage[spanish]{babel}"+_CR+_CR+"%Opciones"+;
              _CR+"\title{** title **}"+_CR+"\author{**your name**}"+_CR+"\date{} %quita la fecha"+_CR+_CR+;
              "%Cuerpo del documento"+_CR+"\begin{document}"+_CR+"\maketitle"+_CR+_CR+"\end{document}"+_CR
      SWLENGUAJE:=3
      EXTENSION:=2
   ELSEIF EXT=="m"
      FILE:=_file
      STRING:="% Funcion MATLAB"+_CR+"function f()"+_CR+_CR+"end"+_CR
      SWLENGUAJE:=4
      EXTENSION:=3
   ELSE   
      FILE:=_file
      STRING:=" "
      SWLENGUAJE:=4
   END
   
  /* if len(HUEVO)>0
      if EXT=="c" .or. EXT=="xu"
         STRING+=_CR+"/ *"+_CR+HUEVO+_CR+"* /"+_CR
      else
         STRING+=_CR+_CR+HUEVO+_CR+_CR
      end
   end */
   // define las palabras reservadas para colorear.
   
   AX:=ALLTRIM(FILE)
   if !FILE(FILE)
      TEXTO:={}
      SIZE:=mlcount(STRING,1200)
      for i:=1 to SIZE
         aadd(TEXTO,rtrim(memoline(STRING,1200,i)))
      end
   else
      if substr(FILE,rat(".",FILE)+1,len(FILE))!="temp"
         if len(BAKDIRECTORY)>0
            tARCHIVO:=BAKDIRECTORY+substr(FILE,rat(_fileSeparator,FILE)+1,len(FILE))+;
                      "_"+strtran(dtoc(date()),"/","")+"_"+strtran(time(),":","")
            if " " $ tARCHIVO
               tmp:=CMDSYSTEM('cp '+FILE+' "'+tARCHIVO+'" </dev/null >/dev/null 2>&1',0)
            else
               tmp:=CMDSYSTEM("cp "+FILE+" "+tARCHIVO+" </dev/null >/dev/null 2>&1",0)
            end
            if !file(tARCHIVO)
               cMessage := hb_utf8tostr("No fue posible crear el archivo de respaldo")
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
               clearscr()
            end
         end
         if len(TMPDIRECTORY)==0
            if " " $ FILE
               tmp:=CMDSYSTEM('cp "'+FILE+'" "'+FILE+CHR(126)+'" </dev/null >/dev/null 2>&1',0)
            else
               tmp:=CMDSYSTEM("cp "+FILE+" "+FILE+CHR(126)+" </dev/null >/dev/null 2>&1",0)
            end
            if !file(FILE+CHR(126))
               cMessage := hb_utf8tostr("No fue posible crear el archivo temporal")+_CR+;
                   FILE+_CR+FILE+CHR(126)
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
               clearscr()
            end
         else
            tARCHIVO:=TMPDIRECTORY+substr(FILE,rat(_fileSeparator,FILE)+1,len(FILE))+CHR(126)
            if " " $ tARCHIVO
               tmp:=CMDSYSTEM('cp '+FILE+' "'+tARCHIVO+'" </dev/null >/dev/null 2>&1',0)
            else
               tmp:=CMDSYSTEM("cp "+FILE+" "+tARCHIVO+" </dev/null >/dev/null 2>&1",0)
            end
            if !file(tARCHIVO)
               cMessage := hb_utf8tostr("No fue posible crear el archivo temporal")+_CR+;
                   FILE+_CR+tARCHIVO
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   
               clearscr()
            end
         end
      end
   //   SIZE:=CUENTALINEAS(FILE)    //SIZE=numero de lineas, num tokens linea, numtokens tottal, total carac.
      TEXTO:={}
      SETCURSOR(0)
      SETCOLOR(N2COLOR(cEDITOR))
      @10,int(SLINEA/2)-7 CLEAR TO 14,int(SLINEA/2)+7
      DISPBOX(10,int(SLINEA/2)-7,14,int(SLINEA/2)+7,2)
      @ 12,int(SLINEA/2)-4 SAY "CARGANDO"
      SIZE:=0
      TEXTO:=XREADLINE(FILE,@SIZE)     ///,SIZE[1],SIZE[4])
      SETCURSOR(1)
   end
   cTEXTO:=tTEXTO
   
   CARGACOLORESTEXTO(PATH_XU,_fileSeparator,EXT)
   
   // busca algún "*". Si existe, lo deja ahí
   SWJET:=.F.
   for j:=1 to len(CORDEL)
      if CORDEL[j][1]=="*"
         CORDEL[j][1]:=FILE
         CORDEL[j][2]:=SIZE
         CORDEL[j][3]:=TEXTO
         CORDEL[j][4]:=""  // parametros
         SWJET:=.T.
         exit
      end
   end
   if !SWJET  // no lo encontró: lo añade.
      AADD(CORDEL,{FILE,SIZE,TEXTO,""})
   end
   
   While .T.
      _file:=EDITFILE(@TEXTO,@SIZE,"s",FILE)
      if len(_file)==0
         exit
      end
     // reemplaza el tamaño de TEXTO 
      for j:=1 to len(CORDEL)
         //if substr(CORDEL[j][1],rat(_fileSeparator,CORDEL[j][1]),len(CORDEL[j][1]))==substr(FILE,;
         //    rat(_fileSeparator,FILE),len(FILE))
        // ? CORDEL[j][1]," ::: ",FILE; inkey(0)
         if CORDEL[j][1]==FILE
            CORDEL[j][2]:=SIZE
            CORDEL[j][4]:=PARAMETROS
            exit
         end
      end
     // verifico que el archivo existe
      SWJET:=.F.
      for j:=1 to len(CORDEL)
       //  if substr(CORDEL[j][1],rat(_fileSeparator,CORDEL[j][1])+1,len(CORDEL[j][1]))==substr(_file,;
       //      rat(_fileSeparator,_file)+1,len(_file))
      // ? CORDEL[j][1]," >>>> ",_file; inkey(0)
         if   CORDEL[j][1]==_file
            FOR i:=1 TO LEN(TEXTO)
               RELEASE TEXTO[i]
            END
            PARAMETROS:=CORDEL[j][4]
            TEXTO:=CORDEL[j][3]
            SIZE :=CORDEL[j][2]
            FILE :=CORDEL[j][1]
            EXT:=substr(_file,rat(".",_file)+1,LEN(_file))
            CARGACOLORESTEXTO(PATH_XU,_fileSeparator,EXT)
            SWJET:=.T.
            exit
         end
      end
      if !SWJET
        // ? "NO EXISTE EN COLA: ",_file; inkey(0)
         exit
      end
   end
   
   FOR j:=1 TO LEN(TEXTO)
      RELEASE TEXTO[j]
   END
   RELEASE TEXTO
   RELEASE SIZE
  // hb_gcAll()
  // inkey(0.2)
   ft_Idle()

END
SETCOLOR(N2COLOR(7))

for i:=1 to LEN(CORDEL)
   RELEASE CORDEL[i][3]
   RELEASE CORDEL[i][2]
   RELEASE CORDEL[i][1]
end
RELEASE CORDEL

for i:=1 to LEN(lDEFINE)
  for j:=1 to len(lDEFINE[i])
     RELEASE lDEFINE[i][j]
  end
  RELEASE lDEFINE[i]
end
RELEASE lDEFINE
for i:=1 to LEN(lSECCION)
  for j:=1 to len(lSECCION[i])
     RELEASE lSECCION[i][j]
  end
  RELEASE lSECCION[i]
end
RELEASE lSECCION
for i:=1 to LEN(lKEYWORD)
  for j:=1 to len(lKEYWORD[i])
     RELEASE lKEYWORD[i][j]
  end
  RELEASE lKEYWORD[i]
end
RELEASE lKEYWORD

if len(LISTACOMPILA)>0
   FOR i:=1 to len(LISTACOMPILA)
      RELEASE LISTACOMPILA[i]
   END
end
RELEASE LISTACOMPILA

for i:=1 to len(cMETADATA)
   RELEASE cMETADATA[i]
   RELEASE METADATA[i]
end
RELEASE cMETADATA, METADATA

tmp:=CMDSYSTEM("rm "+PATH_TEMP+_fileSeparator+"*.temp </dev/null >/dev/null 2>&1 &",0)

   IF LEN(BUFFER)>0
      FOR j:=1 to LEN(BUFFER)
         RELEASE BUFFER[j]
      END
      RELEASE BUFFER
   END 
   
RELEASE ALL

  AEVAL(DIRECTORY(PATH_LOG+_fileSeparator+"*.log"), { |aFile| ;
      FERASE(PATH_LOG+_fileSeparator+aFile[F_NAME]) })

  AEVAL(DIRECTORY(PATH_LOG+_fileSeparator+"*.sh"), { |aFile| ;
      FERASE(PATH_LOG+_fileSeparator+aFile[F_NAME]) })

  AEVAL(DIRECTORY(PATH_LOG+_fileSeparator+"*.tmp"), { |aFile| ;
      FERASE(PATH_LOG+_fileSeparator+aFile[F_NAME]) })
clear
   
RETURN NIL

PROCEDURE CLEARSCR
LOCAL tCOLOR,BASE,i
BASE:=REPLICATE(" ",SLINEA+1)
tCOLOR:=setcolor("N/N")
for i:=0 to MAXROW()
   @ i,0 say BASE
end
//@ 0,0 CLEAR TO TLINEA,MAXCOL()
setcolor(tCOLOR)
setpos(0,0)
RETURN


PROCEDURE VISUALIZA_TEXTO(TEXTO,INI,FIN,TCOL,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi) //,SWCTRLKG)
LOCAL XCOLORES,STRING,pINICOL,I,XLEN,lPOS,rPOS,nLEN
LOCAL nPOS,nSIZE,j,k,pFINCOL,SWBLOQUE,cLEN,cColor
LOCAL STRPROC

//COLORWIN(1,1,TLINEA-3,SLINEA,cEDITOR)

DISPBEGIN()

SETCOLOR (N2COLOR(cEDITOR))
SETCURSOR(0)
pINICOL:=1
   
///SW_EDITCOM:=.F.



cLEN:=INI

FOR I:=1 TO TLINEA-3   // FILAS A MOSTRAR
  XLEN:=LEN(TEXTO[INI]) //?? modificar o eliminar.
/*  IF XLEN>=SLINEA
     XLEN:=SLINEA-1
     STRSP:=" "
  ELSE
     STRSP:=SUBSTR(BASELINE,1,SLINEA-XLEN)
  END*/
  setpos(I,0);dispout(STRSP+" ")    //outstd(STRSP)
  STRING:=SUBSTR(TEXTO[INI],TCOL+1,XLEN-TCOL)

 /* 
  STRING:=SUBSTR(TEXTO[INI],TCOL+1,LEN(TEXTO[INI]))
  STRING:=SUBSTR(STRING,1,SLINEA-1)+STRSP
  */
  //setpos(I,0); outstd(" ")
    
  setpos(I,1); dispout(STRING)  //outstd(STRING)
  
  IF TEXTOTIPO=="BINARY"
     if SWCOLORTEXTO==2  // pinta columna 2
        colorwin(I, iif(22-TCOL<=0,1,22-TCOL), I, 34-TCOL, 7 )
        colorwin(I, iif(35-TCOL<=0,1,35-TCOL), I, 46-TCOL, 15 )
        colorwin(I, iif(47-TCOL<=0,1,47-TCOL), I, 58-TCOL, 7 )
        colorwin(I, iif(59-TCOL<=0,1,59-TCOL), I, 70-TCOL, 15 )
        colorwin(I, iif(71-TCOL<=0,1,71-TCOL), I, 82-TCOL, 7 )
        colorwin(I, iif(86-TCOL<=0,1,86-TCOL), I, 107-TCOL, 14 )
     end
     setpos(I,108); dispout(chr(177)+"|")
  ELSEIF XFIL1EDIT>0 .and. XFIL2EDIT>0
     if INI>=XFIL1EDIT .and. INI<=XFIL2EDIT
        COLORWIN(I, 1, I, LEN(STRING),cSELECT ) 
     end
  ELSEIF XFILi>0
     if INI==XFILi
       // if SWCTRLKG
       //    COLORWIN(I, 1, I, SLINEA,cSELECT ) 
       // else
           COLORWIN(I, 1, I, SLINEA,cSELECT ) 
       // end
     end
  ELSE
  
  IF SWCOLORTEXTO>=1
     IF SWCOLORTEXTO==2  // coloreo palabras y simbolos
        if len(STRING)>0
           PONECOLORALAHUEA(lKEYWORD,lSECCION,lDEFINE,cKEYWORD,cSECCION,cEDITDEF,I,STRING)
        end
   /*     XLEN:=LEN(lKEYWORD)
        for j:=1 to XLEN
           nSIZE:=NUMAT(lKEYWORD[j],STRING)
           nLEN:=LEN(lKEYWORD[j])
           for k:=1 to nSIZE
              nPOS:=ATNUM(lKEYWORD[j],STRING,k)
              lPOS:=substr(STRING,nPOS-1,1)
              rPOS:=substr(STRING,nPOS+nLEN,1)
              if nLEN==1
                 COLORWIN(I, nPOS, I, nPOS,cKEYWORD )
              elseif nPOS>1
                 if !isalpha(lPOS).and.!isdigit(lPOS).and.!isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cKEYWORD )
                 end
              else
                 if !isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cKEYWORD )
                 end
              end
           end
        end
        XLEN:=LEN(lSECCION)
        for j:=1 to XLEN
           nSIZE:=NUMAT(lSECCION[j],STRING)
           nLEN:=LEN(lSECCION[j])
           for k:=1 to nSIZE
              nPOS:=ATNUM(lSECCION[j],STRING,k)
              lPOS:=substr(STRING,nPOS-1,1)
              rPOS:=substr(STRING,nPOS+nLEN,1)
              if nLEN==1
                 COLORWIN(I, nPOS, I, nPOS,cSECCION )
              elseif nPOS>1
                 if !isalpha(lPOS).and.!isdigit(lPOS).and.!isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cSECCION )
                 end
              else
                 if !isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cSECCION )
                 end
              end
           end
        end
        XLEN:=LEN(lDEFINE)
        for j:=1 to XLEN
           nSIZE:=NUMAT(lDEFINE[j],STRING)
           nLEN:=LEN(lDEFINE[j])
           for k:=1 to nSIZE
              nPOS:=ATNUM(lDEFINE[j],STRING,k)
              lPOS:=substr(STRING,nPOS-1,1)
              rPOS:=substr(STRING,nPOS+nLEN,1)
              if nLEN==1
                 COLORWIN(I, nPOS, I, nPOS,cEDITDEF )
              elseif nPOS>1
                 if !isalpha(lPOS).and.!isdigit(lPOS).and.!isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cEDITDEF )
                 end
              else
                 if !isalpha(rPOS).and.!isdigit(rPOS)
                    COLORWIN(I, nPOS, I, nPOS+nLEN-1,cEDITDEF )
                 end
              end
           end
        end*/
     END   // fin coloreado de palabras y simbolos.
     IF SWCOLORTEXTO==1 .or. SWCOLORTEXTO==2
       /* nPOS:=AT(COMENTARIOS,TEXTO[INI])
        if nPOS>0
           // BLOQUE DE COMENTARIOS de linea
           if TCOL<=1
              COLORWIN(I, nPOS, I, SLINEA,cEDITCOM )
           else
              if nPOS>=TCOL
                  COLORWIN(I, nPOS-TCOL, I, SLINEA,cEDITCOM )
              else
                  COLORWIN(I, 1, I, SLINEA,cEDITCOM )
              end
           end
           XLEN:=LEN(substr(TEXTO[INI],1,nPOS) )
        else
           XLEN:=LEN(TEXTO[INI])
        end*/
        XLEN:=LEN(TEXTO[INI])
        SWBLOQUE:=.F.
        acSTR:=""
        
        if EXTENSION==1
           cCOM:=chr(34)   // comilla doble
        elseif EXTENSION==3   // matlab
           cCOM:="'"  // apostrofe
        end
        // la siguiente codificacion es necesaria porque así puedo colorear incluso si el
        // principio o fin de string están fuera de la ventana de edicion
       // if EXTENSION!=2   // no es latex
           for j:=1 to XLEN
              cSTR:=substr(TEXTO[INI],j,1)
              // veo comentarios de linea aquí:
              if cSTR=="/"
                 if SWLENGUAJE<=2 .or. SWLENGUAJE==4 //EXTENSION==1
                    if substr(TEXTO[INI],j+1,1)=="/"
                       if !SWBLOQUE    // no esta dentro de un string: clorea
                          if TCOL<=1
                             COLORWIN(I, j, I, SLINEA,cEDITCOM )
                          else
                             if j>=TCOL
                                 COLORWIN(I, j-TCOL, I, SLINEA,cEDITCOM )
                             else
                                 COLORWIN(I, 1, I, SLINEA,cEDITCOM )
                             end
                          end
                          exit
                       end
                    end
                 end
              elseif cSTR==COMENTARIOS
                 //if EXTENSION!=1
                    if !SWBLOQUE    // no esta dentro de un string: clorea
                          if TCOL<=1
                             COLORWIN(I, j, I, SLINEA,cEDITCOM )
                          else
                             if j>=TCOL
                                 COLORWIN(I, j-TCOL, I, SLINEA,cEDITCOM )
                             else
                                 COLORWIN(I, 1, I, SLINEA,cEDITCOM )
                             end
                          end
                          exit
                    end
                 //end
              end
              //
              if cSTR==cCOM .and. acSTR!="\"
                 if !SWBLOQUE   // inicia secuencia
                    SWBLOQUE:=.T.
                 else
                    SWBLOQUE:=.F.
                    if TCOL<=1
                       COLORWIN(I, j, I, j,cCADENA )
                    else
                       if j>TCOL
                           COLORWIN(I, j-TCOL, I, j-TCOL,cCADENA )
                       end
                    end
                 end
              end
              if SWBLOQUE
                 if TCOL<=1
                    COLORWIN(I, j, I, j,cCADENA )
                 else
                    if j>TCOL
                        COLORWIN(I, j-TCOL, I, j-TCOL,cCADENA )
                    end
                 end
              end
              acSTR:=cSTR
           end
     //  end
        
/*       XCOLORES:={}

       STRPROC:=TEXTO[INI]
       LLENACOLORES(STRPROC,TCOL+1,XCOLORES,COMENTARIOS,EXTENSION)
       cLEN:=LEN(XCOLORES)

       if cLEN>0
          COLORSTRINGS( cLEN,I,TCOL,cCADENA,SLINEA,XCOLORES )
          COLORREMARKS( cLEN,I,TCOL,cEDITCOM,SLINEA,XCOLORES )
       end
       if EXTENSION == 1
          XCOLORES:={}
          SWBLOQUE:=COMENTARIOBLOQUE(TEXTO[INI],XCOLORES,COMENTARIOS)
          nLenCom:=len(COMENTARIOS)-1
          cLEN:=LEN(XCOLORES)
          IF cLEN > 0
             IF cLEN % 2 == 0  // me voy a la segura: hay bloques cerrados en la misma linea
                COLORBLOCKREM( cLEN,I,TCOL,cEDITCOM,nLenCom,SLINEA,XCOLORES )
             END
          END
       end*/
    END
  END
  END
  SETCOLOR (N2COLOR(cEDITOR))
  ++INI
  IF INI>TOPE
     STRSP:=SUBSTR(BASELINE,1,SLINEA)
     FOR J:=I+1 TO TLINEA-3
        setpos(J,0); dispout("~"+STRSP)   //outstd("~"+STRSP)
     END
     EXIT
  END

END

// BLOQUE de comentarios tipo / * * / hasta INI-1
if (SWCOLORTEXTO==1 .or. SWCOLORTEXTO==2) .and. TEXTOTIPO!="BINARY"
if SWLENGUAJE<=2 .or. SWLENGUAJE==4  //EXTENSION==1

  // cINI variable que define desde donde comenzare a colorear la hueá.
   cINI:=1
   if cLEN>(TLINEA)*8
      cINI:=cLEN-(TLINEA)*8
   end
   COMBLOQUEC(TEXTO,cINI,INI,cLEN,TCOL,cEDITCOM)
   
/*
   --INI
   k:=1
   SWBLOQUE:=.F.
   for I:=cINI to INI
      XLEN:=LEN(TEXTO[I])

      for j:=1 to XLEN
         cSTR:=substr(TEXTO[I],j,1)
         if cSTR=="/"
            if substr(TEXTO[I],j+1,1)=="*"   // comentaruo!!
               SWBLOQUE:=.T.
            elseif substr(TEXTO[I],j+1,1)=="/"   // comentario de linea: salta todo
               exit
            end
         elseif cSTR=="*"
            if substr(TEXTO[I],j+1,1)=="/"   // fin de comentaruo!!
               SWBLOQUE:=.F.
               if I>=cLEN
                  if TCOL<=1
                     COLORWIN(k, j, k, j+1,cEDITCOM )
                  else
                     if j>TCOL
                         COLORWIN(k, j-TCOL, k, j-TCOL+1,cEDITCOM )
                     end
                  end
              end
            end
         end
         if I>=cLEN  // está dentro de la ventana de edicion
            if SWBLOQUE
              if TCOL<=1
                 COLORWIN(k, j, k, j,cEDITCOM )
              else
                 if j>TCOL
                     COLORWIN(k, j-TCOL, k, j-TCOL,cEDITCOM )
                 end
              end
           end
         end
      end
      if I>=cLEN
         ++k
      end
   end*/
elseif EXTENSION==2    // latex!! $ como comentario
     // cINI variable que define desde donde comenzare a colorear la hueá.
   cINI:=1
   if cLEN>(TLINEA)*5
      cINI:=cLEN-(TLINEA)*5
   end
   CADBLOQUEC(TEXTO,cINI,INI,cLEN,TCOL,cCADENA)
   
/*   --INI
   k:=1
   SWBLOQUE:=.F.
   for I:=cINI to INI
      XLEN:=LEN(TEXTO[I])

      for j:=1 to XLEN
         cSTR:=substr(TEXTO[I],j,1)
         if cSTR=="$"
            if substr(TEXTO[I],j+1,1)=="$"   // No es valido aqui
               loop
            elseif substr(TEXTO[I],j-1,1)=="\"
               loop
            else
               if SWBLOQUE
                  SWBLOQUE:=.F.
                  if I>=cLEN
                     if TCOL<=1
                        COLORWIN(k, j, k, j+1,cCADENA )
                     else
                        if j>TCOL
                            COLORWIN(k, j-TCOL, k, j-TCOL+1,cCADENA )
                        end
                     end
                  end
               else
                  SWBLOQUE:=.T.
               end
            end
         end
         if I>=cLEN  // está dentro de la ventana de edicion
            if SWBLOQUE
              if TCOL<=1
                 COLORWIN(k, j, k, j,cCADENA )
              else
                 if j>TCOL
                     COLORWIN(k, j-TCOL, k, j-TCOL,cCADENA )
                 end
              end
           end
         end
      end
      if I>=cLEN
         ++k
      end
   end */
end

end
SETCURSOR(1)
DISPEND()


RELEASE XCOLORES,STRING,pINICOL,I,XLEN,nSIZE,j,pFINCOL,SWBLOQUE,cLEN,cColor

RETURN

/* esta es la parte dinámica del despliegue: pinta cuando hay actividad en el editor */
/*procedure SHOWTEXTO(STRING1,cini)
LOCAL XCOLORES,PY,xendlinea,cLEN,nPOS,nSIZE,pINICOL,pFINCOL,cColor,j,I,STRING

xendlinea:=len(STRING1)
if xendlinea >= SLINEA
   xendlinea:=SLINEA-1
end
setcursor(0)
PY:=ROW()

COMENTALINEA:=0
STRING:=SUBSTR(STRING1,cini+1,LEN(STRING1))
STRING:=SUBSTR(STRING,1,SLINEA-1)

setpos(PY,1);outstd(STRING)
if xendlinea-cini<SLINEA   
   SETCOLOR(N2COLOR(cEDITOR))
   outstd(" ")
end 

IF SWCOLORTEXTO>=1
   IF SWCOLORTEXTO==2  
      PONECOLORALAHUEA(lKEYWORD,lSECCION,lDEFINE,cKEYWORD,cSECCION,cEDITDEF,PY,@STRING)
   END
   IF SWCOLORTEXTO==1 .or. SWCOLORTEXTO==2
  
      XCOLORES:={}
      LLENACOLORES(STRING1,cini+1,XCOLORES,COMENTARIOS,EXTENSION)

      cLEN:=LEN(XCOLORES)
*/
/*    nPOS:={}
      nSIZE:=PONECOLORALAHUEA(lKEYWORD,nPOS,@STRING)
      if nSIZE>0
         XCOLORWIN(PY,nPOS,lKEYWORD,cKEYWORD,nSIZE)
         FOR I:=1 TO LEN(nPOS)
            RELEASE nPOS[I]
         END
         RELEASE nPOS
      end

      nPOS:={}
      nSIZE:=PONECOLORALAHUEA(lSECCION,nPOS,@STRING)
      if nSIZE>0
         XCOLORWIN(PY,nPOS,lSECCION,cSECCION,nSIZE)
         FOR I:=1 TO LEN(nPOS)
            RELEASE nPOS[I]
         END
         RELEASE nPOS
      end

      nPOS:={}
      nSIZE:=PONECOLORALAHUEA(lDEFINE,nPOS,@STRING)
      if nSIZE>0
         XCOLORWIN(PY,nPOS,lDEFINE,cEDITDEF,nSIZE)
         FOR I:=1 TO LEN(nPOS)
            RELEASE nPOS[I]
         END
         RELEASE nPOS
      end*/
/*
      if cLEN>0
         COLORSTRINGS( cLEN,PY,cini,cCADENA,SLINEA,XCOLORES )
         COLORREMARKS( cLEN,PY,cini,cEDITCOM,SLINEA,XCOLORES )
      end
   
      if EXTENSION == 1
        XCOLORES:={}
        SWBLOQUE:=COMENTARIOBLOQUE(STRING1,XCOLORES,COMENTARIOS)
        nLenCom:=len(COMENTARIOS)-1
        cLEN:=LEN(XCOLORES)
        IF cLEN > 0
           IF cLEN % 2 == 0  // me voy a la segura: hay bloques cerrados en la misma linea
              COLORBLOCKREM( cLEN,PY,cini,cEDITCOM,nLenCom,SLINEA,XCOLORES )
           END
        END
      end
   END
END
SETCOLOR (N2COLOR(cEDITOR))
setcursor(1)

RELEASE XCOLORES,PY,xendlinea,cLEN,nSIZE,pINICOL,pFINCOL,cColor,j,I

return
*/

procedure BarraTitulo(ARCHIVO)
LOCAL ytemp,xtemp,color,tARCHIVO,CABECERA
ytemp:=ROW()
     xtemp:=COL()
     color:=SETCOLOR (N2COLOR(cMENU))
   @0,0 clear to 0,MAXCOL()
   //tARCHIVO:=".."+substr(ARCHIVO,rat(_fileSeparator,ARCHIVO),len(ARCHIVO))

   //CABECERA:="Edit4XU - ["+tARCHIVO+"] - Compiler: "+DESCRIPCION
   CABECERA:=PADC(hARCHIVO,SLINEA)
   CABECERA:=" Laica v1.0"+substr(CABECERA,9)
   setpos( 0,0 ); outstd( substr(CABECERA,1,SLINEA) )
   setpos( 0, SLINEA-cLENMAPACOLORES ); outstd(cMAPACOLORES)

   @TLINEA-2,0 clear to TLINEA,MAXCOL()

   setpos( TLINEA-1,0 ); outstd( substr(HELP1,1,SLINEA) )
   setpos( TLINEA  ,0 ); outstd( substr(HELP2,1,SLINEA) )
     setcolor(color)
     setpos(ytemp,xtemp)
     
return

procedure encabezado(pi,px,TOPE,SW_MODIFICADO,c,SWMARCABLOQUE,SWDELELIN,SWCOPIA,SWCTRLKCTRLD,SWCTRLKCTRLS,;
                     SWCTRLKCTRLP,SWMARCADESP,SWSOBREESCRIBE,SWCTRLKJ,SWCTRLKG,SWEDITTEXT,XFILi,XCOLi,XFILf,XCOLf)
LOCAL ytemp,xtemp,color,COORDS,pos
ytemp:=ROW()
     xtemp:=COL()
     setcursor(0)
     color:=SETCOLOR (N2COLOR(cMENU))

     if SW_MODIFICADO
        SETCOLOR (N2COLOR(cCURSORMOD))
     end
     DISPBEGIN()
     @TLINEA-2,0 SAY SPACE(SLINEA+1)
     setpos(TLINEA-2,0);dispout( " Auto="+iif(SW_CODESP,"OFF","ON")+" ["+hb_ntos(asc(c))+"] ")
     setpos(TLINEA-2,SLINEA-LENTEXTOTIPO-1); dispout(TEXTOTIPO)
     if SLINEA>100
        setpos(TLINEA-2,16/*SLINEA-18*/); dispout(hb_ntos(pi/TOPE*100)+"%")
     end
     if !SWMARCABLOQUE .and. !SWDELELIN .and. !SWCTRLKCTRLD .and. !SWCTRLKCTRLS .and. !SWCTRLKCTRLP .and. !SWMARCADESP;
         .and. !SWCTRLKJ .and. !SWCTRLKG .and. !SWEDITTEXT
         //COORDS:="[ line: "+ hb_ntos(pi)+" of "+hb_ntos(TOPE)+", col: "+hb_ntos(px)+" ]"
         if TEXTOTIPO!="BINARY"
            COORDS:="[ "+ hb_ntos(pi)+":"+hb_ntos(px)+" / "+hb_ntos(TOPE)+" ]"
            
            if SWSOBREESCRIBE
               COORDS+=" OVERWRIT "
            end
         else
            pos:=(pi-1)*20+(px-1)
            if pos>0
               //COORDS:="[ LIN:"+hb_ntos(pi)+", OFFSET:"+ hb_ntos(pos)+" | "+DECTOHEXA(pos)+"h ]"
               COORDS:="[ OFFSET:"+ hb_ntos(pos)+" | "+DECTOHEXA(pos)+"h ]"
            else
               //COORDS:="[ LIN:"+hb_ntos(pi)+", OFFSET:"+ hb_ntos(pos)+" | 0h ]"
               COORDS:="[ OFFSET:"+ hb_ntos(pos)+" | 0h ]"
            end
         end
     else
     //if XFILi>0 .and. XCOLi>0
        if SWMARCABLOQUE .or. SWCTRLKG
          /* if SWCOPIA
              SETCOLOR (N2COLOR(63))
           else
              SETCOLOR (N2COLOR(cSELECT))
           end*/
           SETCOLOR (N2COLOR(cSELECT))
           COORDS:=" SEL <"+hb_ntos(XFILi)+","+hb_ntos(XCOLi)+">"
   //  end
   //  if XFILf>0 .and. XCOLf>0
           COORDS+=" TO <"+hb_ntos(XFILf)+","+hb_ntos(XCOLf)+"> (^KQ=Cancel) "
        elseif SWCTRLKJ
         //  SETCOLOR (N2COLOR(62))
           SETCOLOR (N2COLOR(cSELECT))
           COORDS:=" <"+hb_ntos(XFILi)+" <=> "+hb_ntos(XFILf)+"> (^KQ=Cancel) "
        
        elseif SWEDITTEXT
           SETCOLOR (N2COLOR(cSELECT))
           //COORDS:=" I AM READY FOR OPE! (^KQ=Cancel) "
           COORDS:="[ "+ hb_ntos(pi)+":"+hb_ntos(px)+" / "+hb_ntos(TOPE)+" ]"
        else  // es SWDELELIN
          /* if SWDELELIN 
              SETCOLOR (N2COLOR(cSELECT))
           elseif SWCTRLKCTRLS
              SETCOLOR (N2COLOR(96))
           elseif SWCTRLKCTRLD
              SETCOLOR (N2COLOR(100))
           elseif SWCTRLKCTRLP
              SETCOLOR (N2COLOR(39))
           elseif SWMARCADESP
              SETCOLOR (N2COLOR(48))
           end*/
           SETCOLOR (N2COLOR(cSELECT))
           COORDS:=" LIN <"+hb_ntos(XFILi)+" TO "+hb_ntos(XFILf)+"> (^KQ=Cancel) "
        end
        if SWSOBREESCRIBE
            COORDS+=" OVERWRIT "
        //else
        //    COORDS+="             "
        end
     end
     setpos( TLINEA-2,int(SLINEA/2)-(int(len(COORDS)/2))); dispout( COORDS )

     setcolor(color)
     setcursor(1)
     setpos(ytemp,xtemp)
     DISPEND()
return

FUNCTION ASIGNALINEA(TEXTO)
LOCAL s,xlen,i
  s:={}
  xlen:=len(TEXTO) //+1
  if xlen>0
     for i:=1 to xlen
        aadd(s,substr(TEXTO,i,1))
     end
  else
     s:={""}
  end
RETURN s

/*FUNCTION LLENATEXTO(pTexto,pLen,pIni)
LOCAL linea:="", i
   for i:=1 to pLen+pIni
      if i>pIni
         linea+=pTexto[i]
      end
   end

RETURN linea*/

FUNCTION EDITFILE(TEXTO,TOPE,TIPO,ARCHIVO)
LOCAL p:=0,s:={},px:=0,xlen:=0,m:=0,c:="",i:=0,j:=0,CX:="",SW:=.F.,SW_COMPILE:=.F.,SW_MODIFICADO:=.F.,SWMATCH:=.F.
LOCAL SW_BUFFER:=.F.
local RET:="",LENMETA:=0,SW_INICIO:=.F.,STRING,pi:=0,py:=0,lini:=0,lfin:=0,cini:=0
LOCAL SW_INSERTA:=.F.,SW_BORRA7:=.F.,SW_BORRA8:=.F.,SWF9:=.F.,SW_CTRLOF:=.F.,SWMOVPAG:=.F.,maxLen:=0,SW_EDIT:=.F.
LOCAL cDESCRIPCOMP:={}
LOCAL cBUSCA:="",cREEMPLAZA:="",POSY:=0,POSX:=0,OCURRENCIA:=0,cDATO:="",nDATO:=0
LOCAL nOCURR:=0,LISTAFOUND:={},ptrLF:=0,totLF:=0,tLEN:=0
LOCAL SWINDENTA:=.F.,Indenta:=0,SWINSCODE:=.F.,xCALLBACK:=0,yCALLBACK:=0,SWREPLACE:=.F.,SWCOPIA:=.F.
LOCAL codeIndent:="",pREP:="",pKEY:="",SWA:=.F.,POS:=0,HFIL:=0,nChoice:=0,xFILE:="",aName:={},aSize:={},aDate:={},aTime:={},aAttr:={}
LOCAL SW_BUSCADIR:=.F.,MSGTOTAL:="",HELPTOTAL:="",tARCHIVO:="",EXT:="",SWEXISTE:=.F. //,nLENOPTION:=0
LOCAL SELECTMATCH:={},nLen:=0,cT:=0,CNTCAR:=0,XFILi:=0,XCOLi:=0,XFILf:=0,XCOLf:=0,SWINICIOLIN:=.F.
LOCAL tpi:=0,ECX:="",SWRAPIDA:=.F.,pELIGE:=0,cMessage:="",aOptions:=""
LOCAL tmpPos:=0,tmp:=0,SWPALABRACOMP:=.F.,SWCOMMAND:=.F.,SWINSENSITIVE:=.F.,MENUMATCH:={}
LOCAL SWHUEA:=.F.,SWCTRLA:=.F.
LOCAL SWEDITACOM:=.F.,SWDELELIN:=.F.,SWREPLACECODIGO:=.F.
LOCAL OPERA:="",SWOPEXISTE:=.F.,SWCTRLKCTRLP:=.F.,SWCTRLKCTRLS:=.F.,SWCTRLKCTRLD:=.F.,SWMARCABLOQUE:=.F.
LOCAL SWGETLINEDESP:=.F.,SWMARCADESP:=.F.,SWSOBREESCRIBE:=.F.,SWCTRLKE:=.F.,SWCTRLKB:=.F.,SWCTRLKJ:=.F.
LOCAL TMPTEXTO,SWCTRLKG:=.F.,        SWLOADRAPIDO:=.F.
LOCAL PASTEFROM:=0, PASTETO:=0, SWCTRLON:=.F.
LOCAL HALFFILE
LOCAL XFIL1EDIT:=0,XFIL2EDIT:=0,SWEDITTEXT:=.F.,SWRANGE:=.F.


PUBLIC INPUTFILE
if AT(_fileSeparator,ARCHIVO)==0
   INPUTFILE:=_fileSeparator+CURDIR()+_fileSeparator  // para que sea leido por INPUTLINE
else
   INPUTFILE:=substr(ARCHIVO,1,RAT(_fileSeparator,ARCHIVO))
end

// obtiene nombre de archivo para encabezado.
   hARCHIVO := hb_utf8tostr(substr(ARCHIVO,rat(_fileSeparator,ARCHIVO)+1,len(ARCHIVO)))
   HALFFILE := int(len(hARCHIVO)/2)
//

// inicializa el buffer de CTRL-Z, porque es temporal.
BUFFER_CTRLZ:={}
LINBUFFCTRLZ:={}

public STRSP
STRSP:=SUBSTR(BASELINE,1,SLINEA)

LENMETA:=LEN(METADATA)
SW_INICIO:=.F.
if LENMETA>0
   for i:=1 to LENMETA
      //STRING:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
      if ARCHIVO == METADATA[i]      //STRING==cMETADATA[i][1]
         ///? STRING,"==",cMETADATA[i][1] ; inkey(0)
         pi:=cMETADATA[i][2]
         p:=cMETADATA[i][3]
         pCURSOR:=p
         px:=cMETADATA[i][4]
         py:=cMETADATA[i][5]
         lini:=cMETADATA[i][6]
         lfin:=TOPE
         cini:=cMETADATA[i][8]
         SW_COMPILE:=cMETADATA[i][9]
         SW_MODIFICADO:=cMETADATA[i][10]
         COMPILADOR:=cMETADATA[i][11]
         EJECUTOR:=cMETADATA[i][12]
         DESCRIPCION:=cMETADATA[i][13]
         ESEJECUTABLE:=cMETADATA[i][14]
         COMENTARIOS:=cMETADATA[i][15]
         PARAMETROS:=cMETADATA[i][16]
         if len(cMETADATA[i][17])>0
            TEXTOTIPO:=cMETADATA[i][17]
            LENTEXTOTIPO:=cMETADATA[i][18]
         end
         SW_INICIO:=.T.
         exit
      end
   end
end
if !SW_INICIO
   c:=0
   pi:=1
   p:=1
   pCURSOR:=p
   px:=1
   py:=1
   lini:=1
   lfin:=TOPE 
   cini:=0
   SW_COMPILE:=.F.
   SW_MODIFICADO:=.F.
end

xlen:=2
SW:=.T.
  
SW_INSERTA:=.F.
SW_BORRA7:=.F.
SW_BORRA8:=.F.
SWF9:=.F.
SWMOVPAG:=.F.


SW_CTRLOF:=.F.  // cambia si se usa ^OF o ^U

cBUSCA:="" //space(40); 
cREEMPLAZA:="" //space(40)

POSY:=0;POSX:=0; OCURRENCIA:=0
nOCURR:=1; LISTAFOUND:={};ptrLF:=0;totLF:=0
SW_CODESP:=.F.  // bandera para codigo especial
SWINDENTA:=.T.;Indenta:=0
SWINSCODE:=.F.; codeIndent:=0

xCALLBACK:=0
yCALLBACK:=0

SWREPLACE:=.F.
SWCOPIA:=.F.

//VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE)

public HELP1,HELP2
  
  if TEXTOTIPO=="BINARY"
     nOFFSET:=86
     p:=87; px:=87
     HELP1:="  MAIN  "+CHR(240)+"  ^O Help   ^W Write   ^Q Quit   ^J Jump   ^N Find   ^U Sel File   ^P View"
     HELP2:="  MENU  "+CHR(240)+"  ALT-L Calculator     ^I Edit (o=overwrite, x=del, i=insert)"
  else
     nOFFSET:=0
     HELP1:="  MAIN  "+CHR(240)+"  ^O Help      ^Q Quit    ^J Jump       ^N Find   ^Y Ins Rmks   ^Z Undo     "
     HELP2:="  MENU  "+CHR(240)+"  ^P Compile   ^W Write   ^U Sel File   ^K Edit   ^L Macros     ^V Ins Code "
  end

BarraTitulo(ARCHIVO)       
SW_EDIT:=.T.
SWHUEA:=.F.
MOUSE:=MSAVESTATE()
  
while SW_EDIT
  if SW_INSERTA
     ++TOPE
     resto:=""
     if p<=len(TEXTO[pi])
        resto:=substr(TEXTO[pi],p,len(TEXTO[pi]))
        TEXTO[pi]:=left(TEXTO[pi],p-1)
        ///asize(t,len(t)-(len(t)-p+1))  // +1 es para que recoja el primer caracter
     end
     aadd(TEXTO,"")
     ++pi
     for i:=TOPE-1 to pi step -1
        TEXTO[i+1]:=TEXTO[i]
     end
     if len(resto)>0
        TEXTO[pi]:=resto
     else
        TEXTO[pi]:=""
     end
     RELEASE resto

     p:=1
     ++py
     px:=1
     
     SETCOLOR (N2COLOR(cEDITOR))
     ++lfin
     if py>TLINEA-3
        ++lini
        --py
     end
     SWGETLINEDESP:=.F.;SWMARCADESP:=.F.
     
  elseif SW_BORRA7
     if pi<TOPE
       TEXTO[pi]:=TEXTO[pi]+TEXTO[pi+1]
       for i:=pi+2 to TOPE
          TEXTO[i-1]:=TEXTO[i]
       end
       adel(TEXTO,len(TEXTO))
       asize(TEXTO,len(TEXTO)-1)
       //--TOPE
       TOPE:=len(TEXTO)
       
       SWGETLINEDESP:=.F.;SWMARCADESP:=.F.
       
     end
  elseif SW_BORRA8 
     if pi>1
       p:=len(TEXTO[pi-1])+1
       px:=p
       --py
       TEXTO[pi-1]:=TEXTO[pi-1]+TEXTO[pi]
       for i:=pi to TOPE-1
          TEXTO[i]:=TEXTO[i+1]
       end
       adel(TEXTO,len(TEXTO))
       asize(TEXTO,len(TEXTO)-1)
       //--TOPE
       TOPE:=len(TEXTO)
       --pi

       SWGETLINEDESP:=.F.;SWMARCADESP:=.F.
       
       
       if py<1
          --lini
          py:=1
       end
       if p>SLINEA  // añadido el 26 de marzo de 2019
          cini:=cini+(p-SLINEA+5)
          px:=px-(p-SLINEA+5)
       end
     end
  elseif SW_BUFFER   // quita la linea del texto
     if pi<TOPE
       for i:=pi to TOPE-1
          TEXTO[i]:=TEXTO[i+1]
       end
       adel(TEXTO,len(TEXTO))
       asize(TEXTO,len(TEXTO)-1)
       TOPE:=len(TEXTO)
       SW_BUFFER:=.F.
       p:=1; px:=1
     elseif pi==TOPE
       SW_BUFFER:=.F.
       if TOPE>1
          adel(TEXTO,len(TEXTO))
          asize(TEXTO,len(TEXTO)-1)
          TOPE:=len(TEXTO)
          --pi
          --py
          p:=1; px:=1
       else // TOPE==1
          //asize(TEXTO[pi],1)
          TEXTO[pi]:=""
          TOPE:=len(TEXTO)
          p:=1; px:=1
       end
     end
     SWGETLINEDESP:=.F.;SWMARCADESP:=.F.
  end
  
  // lo siguiente llevar a C
  RELEASE s
  s:=ASIGNALINEA(TEXTO[pi])
  xlen:=len(s)
  // hasta aqui
  
  SW_INSERTA:=.F.;SW_BORRA7:=.F.;SW_BORRA8:=.F.

  VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)

  setpos(py,px)
  
  xini:=1
  SWPRIMERAVEZ:=.F.

  while .T.
     encabezado(pi,p-nOFFSET,TOPE,SW_MODIFICADO,iif(p<=len(s),s[p],""),SWMARCABLOQUE,SWDELELIN,SWCOPIA,;
                   SWCTRLKCTRLD,SWCTRLKCTRLS,SWCTRLKCTRLP,SWMARCADESP,SWSOBREESCRIBE,SWCTRLKJ,SWCTRLKG,SWEDITTEXT,;
                   XFILi,XCOLi,XFILf,XCOLf)

     if cDESTACADO>0
        
       // COLORWIN(py,1,py,SLINEA,cDESTACADO)
        if SWMARCABLOQUE .or. SWDELELIN 
           if SWCOPIA
              //COLORWIN(py,1,py,xlen-cini,cSELECT) //63)
              COLORWIN(py,1,py,SLINEA,cSELECT) //63)
              if !SWDELELIN
                 COLORWIN(1,XCOLi-cini,TLINEA-3,XCOLi-cini,cSELECT) //63)
                 COLORWIN(1,px,TLINEA-3,px,cSELECT) //63)
                // COLORWIN(1,px,TLINEA-3,px,cSELECT)
              end
           else
              //COLORWIN(py,1,py,xlen-cini,cSELECT) //
              COLORWIN(py,1,py,SLINEA,cSELECT)
              if !SWDELELIN
                 COLORWIN(1,XCOLi-cini,TLINEA-3,XCOLi-cini,cSELECT)
                 COLORWIN(1,px,TLINEA-3,px,cSELECT)
               //  COLORWIN(1,px,TLINEA-3,px,cSELECT)
              end
           end
        else
           if SWCTRLKG
              //COLORWIN(py,1,py,xlen-cini,cSELECT)
              COLORWIN(py,1,py,SLINEA,cSELECT)
              COLORWIN(1,XCOLi-cini,TLINEA-3,XCOLi-cini,cSELECT)
              COLORWIN(1,px,TLINEA-3,px,cSELECT)
           elseif SWCTRLKCTRLS
              //COLORWIN(py,1,py,XCOLi,96) //xlen-cini,96)
              if XCOLi-cini>0 .and. XCOLi-cini<=SLINEA
                 COLORWIN(1,XCOLi-cini,TLINEA-3,XCOLi-cini,cSELECT) //96)
                 
              end
              COLORWIN(py,1,py,SLINEA,cSELECT)
           elseif SWCTRLKCTRLD 
              ///COLORWIN(py,XCOLi,py,XCOLi+XCOLf-2,cSELECT) //xlen-cini,100)
              if XCOLi-cini>0
                 if XCOLf-cini<SLINEA
                    COLORWIN(py,XCOLi-cini,py,XCOLf-cini,cSELECT) //xlen-cini,100)
                 else
                    COLORWIN(py,XCOLi-cini,py,SLINEA,cSELECT) //xlen-cini,100)
                 end
              else
                 if XCOLf-cini>0
                    COLORWIN(py,1,py,XCOLf-cini,cSELECT) //xlen-cini,100)
                 end
              end
              //COLORWIN(py,1,py,SLINEA,cSELECT)
           elseif SWCTRLKCTRLP
              ///COLORWIN(py,1,py,xlen-cini,39)
              if XCOLi-cini>0.and. XCOLi-cini<=SLINEA
                 COLORWIN(1,XCOLi-cini,TLINEA-3,XCOLi-cini,cSELECT) //39)
              end
           elseif SWGETLINEDESP
              //COLORWIN(py,1,py,xlen-cini,cSELECT) //48)
              COLORWIN(py,1,py,SLINEA,cSELECT)
           elseif SWCTRLKJ
              //COLORWIN(py,1,py,xlen-cini,cSELECT) //62)
              COLORWIN(py,1,py,SLINEA,cSELECT)
           else
//              if !SWPRIMERAVEZ
//                 COLORWIN(py,1/*+nOFFSET*/,py,xlen-cini,cDESTACADO)
                 if TEXTOTIPO=="BINARY"
                    //divide el destacado en 3 partes
                    if SWCOLORTEXTO==2
                       COLORWIN(py,1,py,18-cini, 11) //cDESTACADO)
                    else
                       COLORWIN(py,1,py,18-cini, cDESTACADO)
                    end
                    COLORWIN(py,iif(22-cini<=0,1,22-cini),py,(nOFFSET-cini-4),cDESTACADO)
                    COLORWIN(py,nOFFSET-cini,py,(nOFFSET-cini+21),cDESTACADO)
                    
     //               COLORWIN(py,(iif(23-cini<=0,cini-(px-nOFFSET+cini-1)-cini , 23-cini)+(px-nOFFSET+cini-1)*3),py,;
    //                            (iif(24-cini<=0,cini-(px-nOFFSET+cini-1)-cini , 24-cini)+(px-nOFFSET+cini-1)*3),47)
                    COLORWIN(py,23-cini+(px-nOFFSET+cini-1)*3,py,24-cini+(px-nOFFSET+cini-1)*3,47)

               /* xpos:=1
                if px>4+nOFFSET
                   xpos:=0
                end
                COLORWIN(py,18+(px-nOFFSET-xpos)*3,py,19+(px-nOFFSET-xpos)*3,47)*/
                 else  // 
                    COLORWIN(py,1/*+nOFFSET*/,py,xlen-cini,cDESTACADO)
                 end
             // COLORWIN(1,px,TLINEA-3,px,cDESTACADO)
//              end
           end
        end
        
     end
  
     if SWPRIMERAVEZ  // marca de palabra match ^NN
        XLEN:=len(cBUSCA)
        if TEXTOTIPO=="BINARY"
           
           if px+XLEN > nOFFSET+1+20
              c2:=(px+XLEN) - (nOFFSET+20)
              COLORWIN(py, px, py, nOFFSET+20,32) //px+(len(cBUSCA)-c2),32 )
              COLORWIN(py+1, nOFFSET+1, py+1, nOFFSET+c2-1,32 )
              c2:=((23+XLEN*3)+(px-nOFFSET-1)*3-2) - (nOFFSET-4)
              COLORWIN(py,23+(px-nOFFSET-1)*3,py,nOFFSET-4,32)
              COLORWIN(py+1,23,py+1,23+c2-1,32)
           else   
              COLORWIN(py, px, py, px+XLEN-1,32 )
              COLORWIN(py,23+(px-nOFFSET-1)*3,py,(23+len(cBUSCA)*3)+(px-nOFFSET-1)*3-2,32)
           end
        else
           COLORWIN(py, px, py, px+XLEN-1,32 )
          // COLORWIN(py,23+(px-nOFFSET-1)*3,py,(23+len(cBUSCA)*3)+(px-nOFFSET-1)*3-2,32)
        end
        SWPRIMERAVEZ:=.F.
     end
     if p>0 .and. p<=len(s)
        if s[p]=="{" .or. s[p]=="}"
           BUSCAPARLLAVE(p,SLINEA,TEXTO,px,py,(TLINEA-3)-py,cini,pi,iif(s[p]=="{",1,0),s[p])
        elseif s[p]=="(" .or. s[p]==")"
           BUSCAPARLLAVE(p,SLINEA,TEXTO,px,py,(TLINEA-3)-py,cini,pi,iif(s[p]=="(",1,0),s[p])
        elseif s[p]=="[" .or. s[p]=="]"
           BUSCAPARLLAVE(p,SLINEA,TEXTO,px,py,(TLINEA-3)-py,cini,pi,iif(s[p]=="[",1,0),s[p])
//           BUSCAPARSIMBOLO(p,SLINEA,TEXTO[pi],py,px,cini)
        end
     end

/*        if s[p]=="("  // marca siguiente paréntesis cerrado
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p+1 to len(s)
              ++ipar
              if s[xini]=="("
                 ++cpar
              elseif s[xini]==")"
                 if cpar==0
                    if xini<=SLINEA
                       COLORWIN(py,px+ipar,py,px+ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        elseif s[p]=="["  // marca siguiente paréntesis cerrado
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p+1 to len(s)
              ++ipar
              if s[xini]=="["
                 ++cpar
              elseif s[xini]=="]"
                 if cpar==0
                    if xini<=SLINEA
                       COLORWIN(py,px+ipar,py,px+ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        elseif s[p]=="{"  // marca siguiente paréntesis cerrado
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p+1 to len(s)
              ++ipar
              if s[xini]=="{"
                 ++cpar
              elseif s[xini]=="}"
                 if cpar==0
                    if xini<=SLINEA
                       COLORWIN(py,px+ipar,py,px+ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        elseif s[p]==")"  // marca siguiente paréntesis abierto
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p-1 to 1 step -1
              ++ipar
              if s[xini]==")"
                 ++cpar
              elseif s[xini]=="("
                 if cpar==0
                    if xini>=cini
                       COLORWIN(py,px-ipar,py,px-ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        elseif s[p]=="]"  // marca siguiente paréntesis abierto
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p-1 to 1 step -1
              ++ipar
              if s[xini]=="]"
                 ++cpar
              elseif s[xini]=="["
                 if cpar==0
                    if xini>=cini
                       COLORWIN(py,px-ipar,py,px-ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        elseif s[p]=="}"  // marca siguiente paréntesis abierto
           COLORWIN(py,px,py,px,32)
           cpar:=0
           ipar:=0
           for xini:=p-1 to 1 step -1
              ++ipar
              if s[xini]=="}"
                 ++cpar
              elseif s[xini]=="{"
                 if cpar==0
                    if xini>=cini
                       COLORWIN(py,px-ipar,py,px-ipar,32)
                       exit
                    else
                       exit
                    end
                 end
                 --cpar
              end
           end
        end*/

    // 
    // @0,0 say "    XLEN = "+str( xlen)+ " P = " +str(p )+"               "
    // setpos(py,px)
    //
    
     c:=inkey(0,159)
     
     if c==1001 .and. TEXTOTIPO!="BINARY"
        c:=inkey(0,159)
        if c==1002     // izquierdo
           c:=inkey(0,159)
           if c==1003 
              mcCol:=MCOL()
              mcRow:=MROW()
             // @ 0,40 say "IZQ->"+hb_ntos((MROW()))+" - "+hb_ntos((MCOL()))+" P="+hb_ntos(p)+" PI="+hb_ntos(pi)
              
              c:=0
              while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE)  // restauro estado inicial para que no imprima huevadas residuales.
              
              /* revisemos si hizo clic en el menú de abajo. */
              if mcRow>=TLINEA-1 
                 pushkey(24,TLINEA-7); exit
            /*     if mcCol>=11 .and. mcCol<=23  // help
                    hb_keyPut(15);hb_keyPut(79); exit
                 elseif mcCol>=25 .and. mcCol<=35  // sale
                    hb_keyPut(17); exit
                 elseif mcCol>=36 .and. mcCol<=49  // CTRL-JJ
                    hb_keyPut(10); hb_keyPut(74); SWf9:=.T.; loop
                 elseif mcCol>=51 .and. mcCol<=61  // find
                    hb_keyPut(14); hb_keyPut(78); exit
                 elseif mcCol>=62 .and. mcCol<=75  // CTRL-Y
                    hb_keyPut(25); exit
                 elseif mcCol>=77 .and. mcCol<=94   .and. OSSYSTEM=="LINUX" // alt-' shell
                    hb_keyPut(26); exit
                 else
                    pushkey(24,TLINEA-3); exit
                 end*/
             /* elseif mcRow==TLINEA
                 if mcCol>=11 .and. mcCol<=23  // compile
                    hb_keyPut(16); hb_keyPut(80); exit
                 elseif mcCol>=25 .and. mcCol<=35  // write
                    hb_keyPut(23); exit
                 elseif mcCol>=36 .and. mcCol<=49  // CTRL-U
                    hb_keyPut(21); exit
                 elseif mcCol>=51 .and. mcCol<=61  // EDIT
                    hb_keyPut(11); exit 
                 elseif mcCol>=62 .and. mcCol<=75  // CTRL-L
                    hb_keyPut(12); exit
                    
                 elseif mcCol>=77 .and. mcCol<=94  // CTRL-V
                    hb_keyPut(22); exit
                 else
                    pushkey(24,TLINEA-7); exit
                 end*/
              elseif mcRow==TLINEA-2
                 if mcCol<=8
                    hb_keyPut(11);hb_keyPut(78); exit
                 elseif mcCol>=int(SLINEA/2)-9 .and. mcCol<=int(SLINEA/2)+9
                    hb_keyPut(10);hb_keyPut(74); SWf9:=.T.; exit
                 else
                    pushkey(24,TLINEA-7); exit
                 end
              elseif mcRow==0
                 if mcCol<=8   // acerca de...
                    hb_keyPut(15);hb_keyPut(65); exit

                 elseif mcCol>=int(SLINEA/2)-HALFFILE-2 .and. mcCol<=int(SLINEA/2)+HALFFILE+2
                    hb_keyPut(21); exit   // CTRL-U
                 //elseif mcCol>=29 .and. mcCol<=len(".."+substr(ARCHIVO,rat(_fileSeparator,ARCHIVO),len(ARCHIVO)))+1
                 //   hb_keyPut(16);hb_keyPut(83); exit
                 elseif mcCol>=SLINEA-LEN(cMAPACOLORES)
                    hb_keyPut(16);hb_keyPut(77); exit
                 else
                    pushkey(5,TLINEA-7); exit
                 end
              end
              
              if mcCol==0
                 mcCol:=1
              end
              
              if mcRow==py
                 if mcCol>px
                    if mcCol>px+(len(s)-p)
                        px:=px+(len(s)-p)
                        p:=len(s)
                    else
                        p:=p+(mcCol-px)
                        px:=px+(mcCol-px)
                    end
                    if SWMARCABLOQUE .or. SWCTRLKG
                        XFILf:=pi; XCOLf:=p
                    end
                 elseif mcCol<px
                    p:=p-(px-mcCol)
                    px:=px-(px-mcCol)
                    
                    if SWMARCABLOQUE .or. SWCTRLKG
                        XFILf:=pi; XCOLf:=p
                    end
                 end
              elseif mcRow<py
                 if mcRow>0
                    pi:=pi-(py-mcRow)   //(TLINEA-3-mcRow)
                    py:=py-(py-mcRow)
                    RELEASE s
                    s:=ASIGNALINEA(TEXTO[pi])
                    if p>len(s)
                      // p:=len(s)
                      // px:=px-(px-p-cini)
                      p:=1; px:=1; cini:=0
                      hb_keyPut(6)
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi

                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    if mcCol>px
                       if mcCol>px+(len(s)-p)
                           px:=px+(len(s)-p)
                           p:=len(s)
                       else
                           p:=p+(mcCol-px)
                           px:=px+(mcCol-px)
                       end
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi

                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    elseif mcCol<px
                       p:=p-(px-mcCol)
                       px:=px-(px-mcCol)
                    
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    exit
                 end
              elseif mcRow>py
                 if mcRow<TLINEA-2 .and. pi+(mcRow-pi)<=TOPE
                    pi:=pi+(mcRow-py)
                    py:=py+(mcRow-py)
                    RELEASE s
                    s:=ASIGNALINEA(TEXTO[pi])
                    if p>len(s)
                      // p:=len(s)
                      // px:=px-(px-p-cini)
                      p:=1; px:=1; cini:=0
                      hb_keyPut(6)
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                       
                       exit
                    end
                    if mcCol>px
                       if mcCol>px+(len(s)-p)
                           px:=px+(len(s)-p)
                           p:=len(s)
                       else
                           p:=p+(mcCol-px)
                           px:=px+(mcCol-px)
                       end
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                    /*   c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    elseif mcCol<px
                       p:=p-(px-mcCol)
                       px:=px-(px-mcCol)
                    
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    exit
                 end
              end   
              //@ 0,40 say "IZQ->"+hb_ntos((MROW()))+" - "+hb_ntos((MCOL()))+" P="+hb_ntos(p)
              setpos(py,px)
           end
           
        elseif c==1004  // derecho
           c:=inkey(0,159)
           if c==1005 
              mcCol:=MCOL()
              mcRow:=MROW()
             // @ 0,40 say "IZQ->"+hb_ntos((MROW()))+" - "+hb_ntos((MCOL()))+" P="+hb_ntos(p)+" PI="+hb_ntos(pi)
              
              c:=0
              while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE)  // restauro estado inicial para que no imprima huevadas residuales.
              
              if mcCol==0
                 mcCol:=1
              end
              
              if mcRow==py
                 if mcCol>px
                    if mcCol>px+(len(s)-p)
                        px:=px+(len(s)-p)
                        p:=len(s)
                    else
                        p:=p+(mcCol-px)
                        px:=px+(mcCol-px)
                    end
                    if SWMARCABLOQUE .or. SWCTRLKG
                        XFILf:=pi; XCOLf:=p
                    end
                 elseif mcCol<px
                    p:=p-(px-mcCol)
                    px:=px-(px-mcCol)
                    
                    if SWMARCABLOQUE .or. SWCTRLKG
                        XFILf:=pi; XCOLf:=p
                    end
                 end
              elseif mcRow<py
                 if mcRow>0
                    pi:=pi-(py-mcRow)   //(TLINEA-3-mcRow)
                    py:=py-(py-mcRow)
                    RELEASE s
                    s:=ASIGNALINEA(TEXTO[pi])
                    if p>len(s)
                      // p:=len(s)
                      // px:=px-(px-p-cini)
                      p:=1; px:=1; cini:=0
                      hb_keyPut(6)
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    if mcCol>px
                       if mcCol>px+(len(s)-p)
                           px:=px+(len(s)-p)
                           p:=len(s)
                       else
                           p:=p+(mcCol-px)
                           px:=px+(mcCol-px)
                       end
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    elseif mcCol<px
                       p:=p-(px-mcCol)
                       px:=px-(px-mcCol)
                    
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    exit
                 end
              elseif mcRow>py
                 if mcRow<TLINEA-2 .and. pi+(mcRow-pi)<=TOPE
                    pi:=pi+(mcRow-py)
                    py:=py+(mcRow-py)
                    RELEASE s
                    s:=ASIGNALINEA(TEXTO[pi])
                    if p>len(s)
                      // p:=len(s)
                      // px:=px-(px-p-cini)
                      p:=1; px:=1; cini:=0
                      hb_keyPut(6)
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                       
                       exit
                    end
                    if mcCol>px
                       if mcCol>px+(len(s)-p)
                           px:=px+(len(s)-p)
                           p:=len(s)
                       else
                           p:=p+(mcCol-px)
                           px:=px+(mcCol-px)
                       end
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                    /*   c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    elseif mcCol<px
                       p:=p-(px-mcCol)
                       px:=px-(px-mcCol)
                    
                       if SWMARCABLOQUE
                           XFILf:=pi; XCOLf:=p
                       elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
                           XFILf:=pi
                       end
                       setpos(py,px)
                     /*  c:=0
                       while inkey()!=0 ; end
                       MRESTSTATE(MOUSE) */
                       exit
                    end
                    exit
                 end
              end   
              //@ 0,40 say "IZQ->"+hb_ntos((MROW()))+" - "+hb_ntos((MCOL()))+" P="+hb_ntos(p)
              setpos(py,px)
           end
      //  else
      //     @ 0,40 say "CENTRO->"+hb_ntos((MROW()))+" - "+hb_ntos((MCOL()))
        end
        c:=0
        while inkey(,159)!=0 ; end
        MRESTSTATE(MOUSE)
        
     end
     
     if SWCTRLKE .or. SWCTRLKB
        if c!=7 .and. c!=8
           SWCTRLKE:=.F.
           SWCTRLKB:=.F.
        end
     end
     
     if SWCTRLA .and. c!=1
        SWCTRLA:=.F.
     end
     
     if c==24     // flecha abajo, CTRL-X
       SETCOLOR (N2COLOR(cEDITOR))

            
       if pi<TOPE   // noha llegado al final del texto
          setcursor(0)
          xini:=1
          
          ++pi
          tLEN:=len(TEXTO[pi])
          if py<MAXROW()-3
             ++py
             //PXFILf:=py
             if tLEN<p
                p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                hb_keyPut(6)

               pCURSOR:=tLEN
             end
          else
             ++lini; ++lfin
             if tLEN<p
                p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                hb_keyPut(6)

               pCURSOR:=tLEN
             end

          end
          RELEASE s
          
          s:=ASIGNALINEA(TEXTO[pi])
          setcursor(1)
          
          if SWMARCABLOQUE
             XFILf:=pi; XCOLf:=p

          elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP .or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
             XFILf:=pi

          end
        
         /* if SWMARCABLOQUE
             COLORWIN(PXFILi,PXCOLi-cini,PXFILf,PXCOLf-cini,71)
          end*/
          exit
      
      /*    xlen:=len(s)
          setpos(py,1)
          SHOWTEXTO(TEXTO[pi],cini)
          setpos(py,px)
             
          setcursor(1)*/
       end
       
     elseif c==5    // flecha arriba, CTRL-E
       SETCOLOR (N2COLOR(cEDITOR))

            
       if pi>1
          setcursor(0)
          
          --pi
          if py>1
             --py
             tLEN:=len(TEXTO[pi])
             if tLEN<p  
                p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                hb_keyPut(6)
               // exit
               /*if tLEN>0
                   if tLEN<cini
                      p:=1; px:=1; cini:=0
                      hb_keyPut(6)
                      //exit
                   else
                      p:=tLEN; px:=tLEN-cini
                   end
                else
                   p:=1; px:=1
                end*/
          //   elseif tLEN>=p .and. pCURSOR<tLEN
               // p:=1; px:=1; cini:=0
               // pushkey(4,pCURSOR-1)
               // exit
          //   elseif tLEN>=p .and. pCURSOR>tLEN
               // p:=1; px:=1; cini:=0
               // hb_keyPut(6)
               // exit
               pCURSOR:=tLEN
             end
          else
             --lini; --lfin
             tLEN:=len(TEXTO[pi])
             if tLEN<p 
                p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                hb_keyPut(6)
                //exit
          //   elseif tLEN>=p .and. pCURSOR<tLEN
               // p:=1; px:=1; cini:=0
               // pushkey(4,pCURSOR-1)
               // exit
          //   elseif tLEN>=p .and. pCURSOR>tLEN
               // p:=1; px:=1; cini:=0
               // hb_keyPut(6)
               // exit
               pCURSOR:=tLEN
             end
            // ? "SCROOL" Sí, pasa por aquí, es raro, pero lo hace.
            // Scroll(1, 0, TLINEA-3, SLINEA, -1,0)
          end
          RELEASE s
          s:=ASIGNALINEA(TEXTO[pi])
          setcursor(1)
          
          if SWMARCABLOQUE
             XFILf:=pi; XCOLf:=p
          elseif SWDELELIN .or. SWCTRLKCTRLD .or. SWCTRLKCTRLS .or. SWCTRLKCTRLP.or. SWMARCADESP .or. SWCTRLKJ .or. SWCTRLKG
             XFILf:=pi

          end
          
          exit

       end
     
     elseif c==13    // CTRL-M   Return
          if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       SW_INSERTA:=.T.
       SW_COMPILE:=.F.
       SW_MODIFICADO:=.T.
       
       // CTRl-Z
       if p>1
          
          AADD(BUFFER_CTRLZ,TEXTO[pi])
          AADD(LINBUFFCTRLZ,pi)
          AADD(BUFFER_CTRLZ,chr(4))
          AADD(LINBUFFCTRLZ,pi+1)
       else
          AADD(BUFFER_CTRLZ,chr(6))  // tope: indica que no hay linea para rescatar
          AADD(LINBUFFCTRLZ,pi)
          AADD(BUFFER_CTRLZ,chr(4))
          AADD(LINBUFFCTRLZ,pi)
       end
       RELEASE LISTAFOUND
     //  AADD(BUFFER_CTRLZ,TEXTO[pi])
     //     AADD(LINBUFFCTRLZ,pi)
       LISTAFOUND:={}  // resetea búsqueda.
       totLF:=0; ptrLF:=0; SWMATCH:=.F.
       cini:=0
       if SWINDENTA .and. p>1
         /* detecta la indentación anterior */
          Indenta:=0
          for i:=1 to len(s)
             if s[i]!=" "
                exit
             else
                ++Indenta
             end
          end
          
          if Indenta>0
             if p>=Indenta
                pushkey(32,Indenta)
             end
            /// AADD(CTRLZ,{pi,1,Indenta,7})
          end
       end
       if yCALLBACK>0
          ++yCALLBACK
       end

       exit

     elseif c==19    // flecha izquierda, CTRL-S
       setcursor(0)
       SETCOLOR (N2COLOR(cEDITOR))
       
       if p>1+nOFFSET 
          --p; --px
          if px<1
            --cini
            ++px
            
            if SWMARCABLOQUE  .or. SWCTRLKG
               XFILf:=pi; XCOLf:=p
            end
            
            exit
          end
       else  // cambia a la linea anterior
        if pi>1
          SETCOLOR (N2COLOR(cEDITOR))
          
          if len(TEXTO[pi-1])>SLINEA
             pCURSOR:=1
             hb_keyPut(5)
             hb_keyPut(6)
           //  if TEXTOTIPO=="BINARY"
           //     hb_keyPut(19)  // para que no quede en el EOL virtual de la línea
           //  end
             setcursor(1)
             exit
          end

          if py>1
             p:=1+nOFFSET; px:=1+nOFFSET
             pCURSOR:=p
             hb_keyPut(5)
             hb_keyPut(6)
          //   if TEXTOTIPO=="BINARY"
          //      hb_keyPut(19)  // para que no quede en el EOL virtual de la línea
          //   end
          else
             hb_keyPut(5)
             hb_keyPut(6)
          //   if TEXTOTIPO=="BINARY"
          //      hb_keyPut(19)  // para que no quede en el EOL virtual de la línea
          //   end
          end
          setcursor(1)
          
          if SWMARCABLOQUE  .or. SWCTRLKG
             XFILf:=pi; XCOLf:=p
          end
          
          exit
         end
       end
       
       if SWMARCABLOQUE .or. SWCTRLKG
          XFILf:=pi; XCOLf:=p
          exit
       end
      
     //  COLORWIN(py,1,py,xlen-cini,cDESTACADO)
     //  COLORWIN(1,px-cini,TLINEA-3,px-cini,cDESTACADO)
              
       setcursor(1)
       setpos(py,px)
       pCURSOR:=p
       if TEXTOTIPO=="BINARY"
          exit
       end
       
     elseif c==4     // flecha derecha, CTRL-D
       setcursor(0)
       SETCOLOR (N2COLOR(cEDITOR))
       xlen:=len(s) //+1
       /////@0,0 say "    XLEN = "+str( xlen)+ " P = " +str(p )+"               "
       if xlen==1+nOFFSET .and. p==1+nOFFSET .and. s[p]==""
          if pi<TOPE   // noha llegado al final del texto
             ++pi
             if py<TLINEA-3
                ++py
                if p>SLINEA-1
                   cini:=0
                end
             else
                if p>SLINEA-1
                  cini:=0
                end
                ++lini; ++lfin
             end
             px:=1+nOFFSET
             p:=1+nOFFSET
             pCURSOR:=p
          end
          setcursor(1)
          
          if SWMARCABLOQUE .or. SWCTRLKG
             XFILf:=pi; XCOLf:=p
          end
          
          exit
       end
       if p<=xlen
          ++p
          if px==SLINEA-1
             ++cini
             if TEXTOTIPO=="BINARY"
             if p>xlen
                if pi<TOPE
                   ++pi
                   if py<TLINEA-3
                      ++py
                      if p>SLINEA-1
                         cini:=0
                      end
                   else
                      if p>SLINEA-1
                         cini:=0
                      end 
                      ++lini; ++lfin
                   end
                   px:=1+nOFFSET
                   p:=1+nOFFSET
                end
             end
             end
             exit
          else
             ++px
          end
          if TEXTOTIPO=="BINARY"
             if p>xlen
                if pi<TOPE
                   ++pi
                   if py<TLINEA-3
                      ++py
                      if p>SLINEA-1
                         cini:=0
                      end
                   else
                      if p>SLINEA-1
                         cini:=0
                      end 
                      ++lini; ++lfin
                   end
                   px:=1+nOFFSET
                   p:=1+nOFFSET
                end
             end
          end
       else
         if pi<TOPE   // noha llegado al final del texto
            ++pi
            if py<TLINEA-3
               ++py
               if p>SLINEA-1
                  cini:=0
               end
            else
               if p>SLINEA-1
                  cini:=0
               end
               ++lini; ++lfin
            end
            px:=1+nOFFSET
            p:=1+nOFFSET
            pCURSOR:=p
         end
         setcursor(1)
         
         if SWMARCABLOQUE  .or. SWCTRLKG
             XFILf:=pi; XCOLf:=p
             
         end
         
         exit
       end

       if SWMARCABLOQUE  .or. SWCTRLKG
          XFILf:=pi; XCOLf:=p
          //setcursor(1)
          //setpos(py,px)
          exit
       end

     //  COLORWIN(py,1,py,xlen-cini,cDESTACADO)
     //  COLORWIN(1,px-cini,TLINEA-3,px-cini,cDESTACADO)
       
       setcursor(1)
       setpos(py,px)
       pCURSOR:=p
       if TEXTOTIPO=="BINARY"
          exit
       end
     // este código puede ser salvador: si necesito otros escapes especiales,
     // agrego otros codigos luego de este.
     elseif c==256   // codigo de color de palabra encontrada
       if SWHUEA
          if TEXTOTIPO!="BINARY"
             COLORWIN(py, px, py, px+len(cBUSCA)-1,32 )
          end

          SWHUEA:=.F.
          SWPRIMERAVEZ:=.T.
          setpos(py,px)
       end
     
     elseif c==500
       SW_CODESP:=.F.
         
     elseif c==1 .or. (c==1 .and. OSSYSTEM=="LINUX")  // CTRL-A  BOL
      //// ? "PASA... VALOR SWCTRLA=",SWCTRLA; inkey(0)
       if !SWCTRLA
          if p==1+nOFFSET .and. len(s)>0
             SWINICIOLIN:=.F.
             for i:=1+nOFFSET to len(s)
                if s[i]!=" "
                   SWINICIOLIN:=.T.
                   exit
                end
             end
             if SWINICIOLIN  
                if i<p
                   pushkey(19,p-i)  
                elseif i>p
                   pushkey(4,i-p) 
                end
             end
             SWCTRLA:=.F.
          else
             p:=1+nOFFSET; cini:=0; px:=1+nOFFSET
      ///    pCURSOR:=p
             SWCTRLA:=.T.
          end
       else
          if len(s)>0
             SWINICIOLIN:=.F.
             for i:=1+nOFFSET to len(s)
                if s[i]!=" "
                   SWINICIOLIN:=.T.
                   exit
                end
             end
             if SWINICIOLIN  
                if i<p
                   pushkey(19,p-i)  //; SWCTRLA:=.F.
                  // p:=i; px:=i; cini:=0
                elseif i>p
                   pushkey(4,i-p)  //; SWCTRLA:=.F.
              /*  else
                   p:=1; cini:=0; px:=1; SWCTRLA:=.T.*/
                end
             end
             SWCTRLA:=.F.
          end
       end
/*
       if !SWCTRLA
          if len(s)>0
             SWINICIOLIN:=.F.
             for i:=1 to len(s)
                if s[i]!=" "
                   SWINICIOLIN:=.T.
                   exit
                end
             end
             if SWINICIOLIN  
                if i<p
                   pushkey(19,p-i)
                   SWCTRLA:=.T.
                  // p:=i; px:=i; cini:=0
                elseif i>p
                   pushkey(4,i-p)
                   SWCTRLA:=.T.
                else
                   p:=1; px:=1; cini:=0;SWCTRLA:=.F.
                end
             end
           end
           //SWCTRLA:=.T.
        else
           p:=1
           cini:=0
           px:=1
      ///  pCURSOR:=p
           SWCTRLA:=.F.
        end
        */
        VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
        setpos(py,px)

     elseif c==6 .or. (c==2 .and. OSSYSTEM=="LINUX")  //  CTRL-F EOL
        p:=len(s)
        if p<SLINEA-1
           cini:=0
        else
           if TEXTOTIPO=="BINARY"
              cini:=len(s)-SLINEA
           else
              cini:=len(s)-(SLINEA-20)
           end
           @ 1,1 clear to TLINEA-3,SLINEA
        end
        px:=abs(len(s)-cini)
        
        if TEXTOTIPO!="BINARY"
           if len(s)>1  //+nOFFSET
              ++px;++p
           end
        end
       /// pCURSOR:=p
       
        VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
        setpos(py,px)

     elseif c==20 .or. (c==397 .and. OSSYSTEM=="LINUX")   // CTRL-T  va al principio del texto
       lini:=1
       lfin:=TLINEA
       cini:=0
       px:=1+nOFFSET;  py:=1; p:=1+nOFFSET; pi:=1
       VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       exit
     
       
     elseif (c==282 .and. OSSYSTEM=="LINUX")  // SHIFT-CTRL-...
       c:=inkey(0)
       if c==49
          c:=inkey(0)
          if c==59
             c:=inkey(0)
             if c==54   // CTRL...
                c:=inkey(0)
                if c==67    // ubica el cursor en el siguiente string de izquierda a derecha
                   SWBUSCAPAR:=.F.
                   for i:=p+1 to len(s)
                      if s[i]==chr(34) .or. s[i]==chr(39)
                         SWBUSCAPAR:=.T.
                         exit
                      end
                   end
                   if SWBUSCAPAR
                      for j:=p to p+(i-p-1)
                         hb_keyPut(4)
                      end
                   end
                elseif c==68  // ubica el cursor en el final del string de derecha a izquierda.
                   SWBUSCAPAR:=.F.
                   for i:=p-1 to 1 step -1
                      if s[i]==chr(34) .or. s[i]==chr(39)
                         SWBUSCAPAR:=.T.
                         exit                          
                      end
                   end
                   if SWBUSCAPAR
                      for j:=p to p-(p-i-1) step -1
                         hb_keyPut(19)
                      end
                   end
                end
             elseif c==52  // SHIFT-ALT... ubica cursor en simbolo de parentesis.
                c:=inkey(0)
                if c==67  // busca (, [ y {
                   SWBUSCAPAR:=.F.
                   for i:=p+1 to len(s)
                       if s[i]=="(" .or. s[i]=="[" .or. s[i]=="{"
                          SWBUSCAPAR:=.T.
                          exit                          
                       end
                   end
                   if SWBUSCAPAR
                      for j:=p to p+(i-p-1)
                         hb_keyPut(4)
                      end
                   end
                elseif c==68  // busca ), ] y }
                   SWBUSCAPAR:=.F.
                   for i:=p-1 to 1 step -1
                       if s[i]=="(" .or. s[i]=="[" .or. s[i]=="{"
                          SWBUSCAPAR:=.T.
                          exit                          
                       end
                   end
                   if SWBUSCAPAR
                      for j:=p to p-(p-i-1) step -1
                         hb_keyPut(19)
                      end
                   end
                end
             end
          end
       end
       
     
     elseif (c==2.and.OSSYSTEM=="DARWIN") .or. (c==401 .and. OSSYSTEM=="LINUX")   // CTRL-B va al final del texto  
       lfin:=TOPE
       lini:=TOPE
       cini:=0
       px:=1+nOFFSET;  py:=1; p:=1+nOFFSET; pi:=TOPE
       VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       exit
       
     elseif c==3 .or. (c==416 .and. OSSYSTEM=="LINUX")  // CTRL-C avance pagina. Donde está parado, se queda. la pagina se mueve
       if pi<TOPE-cPAGINA
          POSY := pi+cPAGINA
          POSX := 0+nOFFSET+1
          SWMATCH:=.T.
          SWMOVPAG:=.T.
          hb_keyPut(10) // salto de línea

       elseif pi>=TOPE-cPAGINA
          POSY := TOPE
          POSX := 0+nOFFSET+1
          SWMATCH:=.T.
          SWMOVPAG:=.T.
          hb_keyPut(10)   // salto de línea
       end 
        
     elseif c==18 .or. (c==408 .and. OSSYSTEM=="LINUX")   // CTRL-R  retro pagina
       if pi>cPAGINA
          POSY := pi-cPAGINA
          POSX := 0+nOFFSET+1
          SWMATCH:=.T.
          SWMOVPAG:=.T.
          hb_keyPut(10) // salto de línea
       elseif pi<=cPAGINA
          POSY := 1
          POSX := 0+nOFFSET+1
          SWMATCH:=.T.
          SWMOVPAG:=.T.
          hb_keyPut(10)  // salto de línea
       end
       
     elseif (c==289 .and. OSSYSTEM=="DARWIN").or.(c==413 .and. OSSYSTEM=="LINUX") 
        if p<len(s)-cDESPLAZAMIENTO
          pushkey(4,cDESPLAZAMIENTO)
        elseif p>=len(s)-cDESPLAZAMIENTO 
          hb_keyPut(6)   // EOL
        end

     elseif (c==304 .and. OSSYSTEM=="DARWIN").or.(c==411 .and. OSSYSTEM=="LINUX")  
        if p>cDESPLAZAMIENTO
          pushkey(19,cDESPLAZAMIENTO)
        elseif p<=cDESPLAZAMIENTO 
          hb_keyput(1)   // BOL
        end

     elseif c==-4   // F5 compila y ejecuta
///        pushkey(16,2)
        hb_keyput(16)
        hb_keyput(80)

     elseif c==16  // CTRL-P ejecuta el programa
       if TEXTOTIPO=="BINARY"
       MSGCONTROL(" CTRL-P... O=Refresh Scrn   | H=HighLighting    | M=Change Colour Edit",;
                  " EXEC      ",;
                  " & VIEW    ")
       else
       MSGCONTROL(" CTRL-P... P=Compile & Run | L=Compile Lib XU | S=Select Compiler | C=Load Set File",;
                  " EXEC     F5=Compile & Run | O=Refresh Scrn   | H=HighLighting    | M=Change Colour Edit",;
                  " & VIEW    X=Ins Params and/or environment vars ")
       end
       c:=inkey(0)
       c:=asc(upper(chr(c)))
       BarraTitulo(ARCHIVO)
       if TEXTOTIPO=="BINARY"
          if c!=77 .and. c!=79 .and. c!=72 .and. c!=27
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       end
       while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
       /* agregar xCOMPILADOR y xPARAMETROS 
          gcc %name%.c -ldssdff -o %name% 
          seleccionar con achoice*/
       if  c==83 //.or. c==19   // CTRL-PS elige compilador, o modifica la línea (añadirla)
           RELEASE cDESCRIPCOMP
           cDESCRIPCOMP:={}
           maxLen:=0
           for i:=1 to len(LISTACOMPILA)
              AADD(cDESCRIPCOMP,LISTACOMPILA[i][4])
              if len(LISTACOMPILA[i][4])>maxLen
                 maxLen:=len(LISTACOMPILA[i][4])
              end
           end
           maxLen:=int(maxLen/2)
           SETCOLOR(N2COLOR(cBARRA))
           @ TLINEA-(int(TLINEA/2)),int(SLINEA/2)-(maxLen+1) CLEAR TO TLINEA-3,int(SLINEA/2)+(maxLen+1)

           setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-10); outstd(" Select a compiler ")
           MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
           //SETCOLOR(N2COLOR(6))
           setcolor( 'GR+/N,N/GR+,,,W/N' )
           pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,int(SLINEA/2)-maxLen,TLINEA-3,int(SLINEA/2)+maxLen,;
                   cDESCRIPCOMP, .T.)
           
           while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 

           RELEASE cDESCRIPCOMP
           IF pELIGE>0
              COMPILADOR:=LISTACOMPILA[pELIGE][2]
              EJECUTOR:=LISTACOMPILA[pELIGE][3]
              DESCRIPCION:=LISTACOMPILA[pELIGE][4]
              COMENTARIOS:=LISTACOMPILA[pELIGE][5]
              ESEJECUTABLE:=iif(LISTACOMPILA[pELIGE][6]=="e",.T.,.F.)
              SW_COMPILE:=.F.
           END
           VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           BarraTitulo(ARCHIVO)
           SETCOLOR(N2COLOR(cTEXTO))
       
       elseif c==88    //  CTRL-PX  insertar parámetros y variables de entorno.           
           SETCOLOR(N2COLOR(cBARRA))
           @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
           @ TLINEA-13,0 CLEAR TO TLINEA-3,SLINEA

           setpos(TLINEA-13,int(SLINEA/2)-26); outstd(" Enter Params and/or Environment Vars for your prog. ")
           MSGBARRA("^W=SAVE & EXIT | ESC=CANCEL EDIT | ^P=PASTE BUFFER | ^T=DEL WORD | ^Y=DEL LINE | RETURN=NEW LINE",ARCHIVO,0)
           //SETCOLOR(N2COLOR(6))
           setcolor( 'GR+/N,N/GR+,,,W/N' )
           
           readinsert(.T.)
           PARAMETROS:=hb_utf8tostr(MEMOEDIT(PARAMETROS,TLINEA-12,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF",1024))
           readinsert(.F.)
           
           PARAMETROS:=ALLTRIM(PARAMETROS)
           VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           BarraTitulo(ARCHIVO)
           SETCOLOR(N2COLOR(cTEXTO))
           
       elseif c==77   //.or. c==13   // CTRL-PM    cambia el mapa de colores.
           RELEASE cSELCOLOURS
           cSELCOLOURS:={}
           maxLen:=0
           for i:=1 to len(cCOLORES)
              AADD(cSELCOLOURS,padc(cCOLORES[i][1],32))
           end
           maxLen:=16
           XCLEAR:=int(TLINEA/2)
           if LEN(cSELCOLOURS)<XCLEAR
              XCLEAR:=LEN(cSELCOLOURS)
           end
           SETCOLOR(N2COLOR(cBARRA))
           //@ TLINEA-XCLEAR,int(SLINEA/2)-(maxLen+1) CLEAR TO TLINEA-3,int(SLINEA/2)+(maxLen+1)
           @ 1,SLINEA-33 CLEAR TO XCLEAR+1,SLINEA

         //  setpos(TLINEA-XCLEAR,int(SLINEA/2)-11); outstd(" Select a color map ")
           MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
           //SETCOLOR(N2COLOR(6))
           setcolor( 'GR+/N,N/GR+,,,W/N' )
         //  pELIGE:=ACHOICE(TLINEA-XCLEAR+1,int(SLINEA/2)-maxLen,TLINEA-3,int(SLINEA/2)+maxLen,;
         //          cSELCOLOURS, .T.)
           pELIGE:=ACHOICE(1,SLINEA-32,XCLEAR,SLINEA-1,;
                   cSELCOLOURS, .T.)
           while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 
              
           RELEASE cSELCOLOURS
           IF pELIGE>0
              cMAPACOLORES:=cCOLORES[pELIGE][1]
              cLENMAPACOLORES:=LEN(cMAPACOLORES)
              cHELP:=cCOLORES[pELIGE][2]
              cTEXT:=cCOLORES[pELIGE][3]
              cEDITOR:=cTEXT
              cCADENA:=cCOLORES[pELIGE][5]
              cMENU:=cCOLORES[pELIGE][6]
              cBARRA:=cMENU
              cCURSORMOD:=cCOLORES[pELIGE][8]
              cSECCION:=cCOLORES[pELIGE][9]
              cKEYWORD:=cCOLORES[pELIGE][10]
              cEDITDEF:=cCOLORES[pELIGE][11]
              cEDITCOM:=cCOLORES[pELIGE][12]
              cDESTACADO:=cCOLORES[pELIGE][13]
              cSELECT:=cCOLORES[pELIGE][14]
           END
           VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           BarraTitulo(ARCHIVO)
           SETCOLOR(N2COLOR(cTEXTO))
           
       elseif c==67 //.or. c==3   // CTRL-PC   recarga el archivo de configuración
           PATH_XU:=_Carga_Configuracion()
           CARGA_COMPILADORES(PATH_XU,_fileSeparator)
           EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))

           CARGACOLORESTEXTO(PATH_XU,_fileSeparator,EXT)
           tTEXTO:=cTEXTO
           BarraTitulo(ARCHIVO)
           exit
       
       elseif c==79 // .or. c==15    // CTRL-PO  refresca la pantalla

      //  if SLINEA!=MAXCOL() .OR. TLINEA!=MAXROW()
           SLINEA:=MAXCOL() //-2
           TLINEA:=MAXROW()
           if TEXTOTIPO=="BINARY"
              if SLINEA<108
                 SLINEA:=110  // minimo para edicion de binarios
                 setmode(TLINEA,SLINEA)
                 hb_keyPut(16);hb_keyPut(79)
              end
           end

           clear
           setcursor(0)
           
           color:=SETCOLOR (N2COLOR(cEDITOR))

           while py>TLINEA-3
              ++lini; --py
           end
           px:=1+nOFFSET; p:=1+nOFFSET; cini:=0
           encabezado(pi,p-nOFFSET,TOPE,SW_MODIFICADO,iif(p<=len(s),s[p],""),SWMARCABLOQUE,SWDELELIN,SWCOPIA,;
                     SWCTRLKCTRLD,SWCTRLKCTRLS,SWCTRLKCTRLP,SWMARCADESP,SWSOBREESCRIBE,SWCTRLKJ,SWCTRLKG,SWEDITTEXT,;
                     XFILi,XCOLi,XFILf,XCOLf) 

           STRSP:=SUBSTR(BASELINE,1,SLINEA)
           VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
        /*   encabezado(pi,p-nOFFSET,TOPE,SW_MODIFICADO,iif(p<=len(s),s[p],""),SWMARCABLOQUE,SWDELELIN,SWCOPIA,;
                     SWCTRLKCTRLD,SWCTRLKCTRLS,SWCTRLKCTRLP,SWMARCADESP,SWSOBREESCRIBE,SWCTRLKJ,SWCTRLKG,SWEDITTEXT,;
                     XFILi,XCOLi,XFILf,XCOLf)*/
           BarraTitulo(ARCHIVO)

           cPAGINA:=MAXROW()-4   // numero de lineas que salta av y re pag.

           setcolor(color)
           setcursor(1)

           setpos(py,px)
           exit
       // end
       
       elseif c==72  //.or. c==8     // CTRL-PH   habilita, inhabilita coloreado de texto
           
           if SWCOLORTEXTO==2
              SWCOLORTEXTO:=0
           else
              SWCOLORTEXTO:=2
           end
           exit
       ///elseif c==7    // CTRL-PG libre
       
/*       elseif c==88  // .or. c==24    // CTRL-PX inserta parametros
           SETCOLOR(N2COLOR(cBARRA))
           @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
           setpos(TLINEA-2,2);outstd(" PARAMETERS? ")
           MSGINPUT("^KU=PASTE")
              
           PARAMETROS:=INPUTLINE(PARAMETROS,SLINEA-15,TLINEA-2,15,"s")
           
           PARAMETROS:=alltrim(PARAMETROS)

           BarraTitulo(ARCHIVO)
           SETCOLOR(N2COLOR(cTEXTO))
           setpos(py,px)
           setcursor(1)*/

       elseif c==76  //.or. c==12   // CTRL-PL  crea la librería
           EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
           if EXT=="xu"
              if SWSOURCE
                 TMPARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                 TMPARCHIVO:=substr(TMPARCHIVO,1,at(".",TMPARCHIVO)-1)
              else
                 TMPARCHIVO:=ARCHIVO
              end
           else
              MSGBARRA("This program is not valid. I need a XU file here.",ARCHIVO,1)
              BarraTitulo(ARCHIVO)
              SETCOLOR (N2COLOR(cTEXTO))
              setpos(py,px)
              setcursor(1)
              loop
           end
           EJECUTA:=strtran(COMPILADOR,"%name%",TMPARCHIVO)
           FUNEXEXU(EJECUTA,"<none>")

       elseif c==80   // CTRL-PP
          if len(COMPILADOR)==0
             MSGBARRA("This program does not have an assigned compiler. Choose one with ^PS",ARCHIVO,1)
             BarraTitulo(ARCHIVO)
             setpos(py,1)
             SETCOLOR (N2COLOR(cTEXTO))
             setpos(py,px)
             setcursor(1)
             loop
          end
          ////TMPARCHIVO:=substr(ARCHIVO,rat(_fileSeparator,ARCHIVO)+1,len(ARCHIVO))
          if SWSOURCE
             EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
             if EXT=="xu" .or. EXT=="def"
                TMPARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
             else
                TMPARCHIVO:=ARCHIVO
             end
          else
             TMPARCHIVO:=ARCHIVO
          end
          TMPARCHIVO:=substr(TMPARCHIVO,1,at(".",TMPARCHIVO)-1)
          if ESEJECUTABLE  // es un ejecutable "e"
             SWNOEXE:=.F.
          else
             SWNOEXE:=.T.   // es otra un script "ne"
          end
        
          IF SWLENGUAJE==1   // ESTA EN XU!!

             if COMPILADOR=="<none>" .and. EJECUTOR=="<none>"
                MSGBARRA("This file can not be executed",ARCHIVO,1)
                BarraTitulo(ARCHIVO)
                setpos(py,1)
                SETCOLOR (N2COLOR(cTEXTO))
                setpos(py,px)
                setcursor(1)
                loop
             else
                
                EJECUTA:=strtran(EJECUTOR,"%name%",TMPARCHIVO)
                EJECUTA1:=strtran(COMPILADOR,"%name%",TMPARCHIVO)
                // rescatar parámetros y variables de entorno
                cTMP:=RESCATOPARAM(PARAMETROS)
                EJECUTA:=strtran(EJECUTA,"%params%",cTMP[1])

                if SWGRMODE   // puede abrir una terminal
                   FUNEXEXU(EJECUTA1,EJECUTA,cTMP[2])
                else
                   SETCOLOR (N2COLOR(7))
                   clear
                   FUNEXEXU(EJECUTA1,EJECUTA,cTMP[2])
                   while inkey()!=0
                      ;
                   end
                  // tmp:=inkey(0)
                   clearterm()
                   clear
                end
                cTMP:=0
             end

          ELSEIF SWLENGUAJE>=2   // ES C u otra hueá!!

             if COMPILADOR=="<none>" //.and. EJECUTOR=="<none>"
                MSGBARRA("This file can not be executed",ARCHIVO,1)
                BarraTitulo(ARCHIVO)
                setpos(py,1)
                SETCOLOR (N2COLOR(cTEXTO)) 
                setpos(py,px)
                setcursor(1)
                loop
             else
                TMPARCHIVO:=substr(TMPARCHIVO,rat("/",TMPARCHIVO)+1,len(TMPARCHIVO))
                EJECUTA:=strtran(EJECUTOR,"%name%",TMPARCHIVO)
                
                EJECUTA1:=strtran(COMPILADOR,"%name%",TMPARCHIVO)
                
                cTMP:=RESCATOPARAM(PARAMETROS)
                
                if ESEJECUTABLE
                    EJECUTA:=strtran(EJECUTA,"%params%",PARAMETROS)
                else
                    EJECUTA1:=strtran(EJECUTA1,"%params%",PARAMETROS)
                end
              //  ? EJECUTA1,"; ",EJECUTA ; inkey(0)
  
                if SWGRMODE   // puede abrir una terminal
                   FUNEXEOTHERS(EJECUTA1,EJECUTA,cTMP[2])
                else
                   SETCOLOR (N2COLOR(7))
                   clear
                   FUNEXEOTHERS(EJECUTA1,EJECUTA,cTMP[2])
                   while inkey()!=0
                      ;
                   end
                  // tmp:=inkey(0)
                   clearterm()
                   clear
                end
                cTMP:=0  
        /*        
                //SAVE SCREEN
                EJECUTA:=strtran(COMPILADOR,"%name%",TMPARCHIVO)
                ///tmp:=CMDSYSTEM("if [ -x "+TMPARCHIVO+" ]; then rm "+TMPARCHIVO+"; fi",0)
                SETCOLOR (N2COLOR(7))
                clear
                if COMPILADOR!="<none>"
                   //? EJECUTA
                   if EXT=="tex"
                      
                   
                      tmp:=FUNFSHELL(EJECUTA,3)
                      ? tmp   // esto muestra el resultado de la compilación
                      wait "Press any key to continue..."
                      tmp:=.T.
                   else
                      tmp:=FUNFSHELL(EJECUTA,2) 
                   end
                else
                   tmp:=.T.
                end
                if tmp .and. EJECUTOR!="<none>"
                   // copia el archivo ejecutable al directorio exe:
                   if len(EXEDIRECTORY)>0
                      if !SWNOEXE   // puedo usar el directorio exe?
                         if EXT=="tex"
                            //tmp:=CMDSYSTEM("mv "+substr(TMPARCHIVO,rat("/",TMPARCHIVO)+1,len(TMPARCHIVO))+".pdf "+EXEDIRECTORY,0)
                            //TMPARCHIVO:=EXEDIRECTORY+substr(TMPARCHIVO,rat("/",TMPARCHIVO)+1,len(TMPARCHIVO))+".pdf"
                            tmp:=CMDSYSTEM("mv "+TMPARCHIVO+".pdf "+EXEDIRECTORY,0)
                            TMPARCHIVO:=EXEDIRECTORY+substr(TMPARCHIVO,rat("/",TMPARCHIVO)+1,len(TMPARCHIVO))+".pdf"
                         else
                            tmp:=CMDSYSTEM("mv "+TMPARCHIVO+" "+EXEDIRECTORY,0)
                            TMPARCHIVO:=EXEDIRECTORY+substr(TMPARCHIVO,rat("/",TMPARCHIVO)+1,len(TMPARCHIVO))
                         end
                      else
                       ///  ? "cp "+ARCHIVO+" "+EXEDIRECTORY+"."
                         tmp:=CMDSYSTEM("cp "+ARCHIVO+" "+EXEDIRECTORY+".",0)
                         TMPARCHIVO:=EXEDIRECTORY+substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                         TMPARCHIVO:=substr(TMPARCHIVO,1,at(".",TMPARCHIVO)-1)
                       ///  ? TMPARCHIVO ; inkey(0)
                      end
                   end
                   if at(_fileSeparator,TMPARCHIVO)==0
                      if  ESEJECUTABLE  //EXT!="tex"
                         TMPARCHIVO:="./"+TMPARCHIVO
                      end
                   end
                   if EXT=="m"   // matlab: debo quitar el path!
                      TMPARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                      TMPARCHIVO:=substr(TMPARCHIVO,1,at(".",TMPARCHIVO)-1)
                   end
                   EJECUTA:=strtran(EJECUTOR,"%name%",TMPARCHIVO)
                   IF LEN(PARAMETROS)>0
                      EJECUTA += " "+PARAMETROS
                   END
                  // ? EJECUTA
                   tmp:=CMDSYSTEM(EJECUTA,1) 
                end

               // setpos(MAXROW()-2,1)
                //wait "Press any key to continue..."
                tmp:=inkey(0)
                clearterm()
                clear
*/
               // RESTORE SCREEN
             end
  ////        end
          END
       end
       
       BarraTitulo(ARCHIVO)
       SETCOLOR(N2COLOR(cTEXTO))
       VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       setpos(py,px)
       setcursor(1)
       exit
       //setpos(py,px)
       //setcursor(1)
       
     elseif c==17    // CTRL-Q
       STRING:=""
       for i:=1 to len(METADATA)
          tmp:=substr(METADATA[i],rat("/",METADATA[i])+1,len(METADATA[i]))
          if VERIFICAMODIFICADO(tmp,cMETADATA)
             STRING:="*"
             exit
          end
       end
       
     //////  if SW_MODIFICADO
       if STRING=="*" .or. SW_MODIFICADO
          if !SW_CTRLOF
             cMessage := "Tienes archivos que no han sido guardados" + _CR + ;
                            "(Consulta en ^U, los archivos en '(mod)')"+_CR+;
                            "Deseas salir de LAICA de todas maneras?"
             aOptions := { hb_utf8tostr("Sí"),"No" }
             nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
             while inkey(,159)!=0 ; end
             MRESTSTATE(MOUSE)
             if nChoice==1
                   SW_EDIT:=.F.
                   exit
             end
          else   // graba y sale, porque se trata de un cambio ^OF o ^U
            /* tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
             if !tmp
                cMessage := hb_utf8tostr("Archivo no pudo ser guardado")
                aOptions := { hb_utf8tostr("Será...") }
                nChoice := Alert( cMessage, aOptions )
             end*/
             SW_EDIT:=.F.
             exit
          end
       else
          SW_EDIT:=.F.
          exit
       end
       c:=0
       while inkey(,159)!=0 ; end
       MRESTSTATE(MOUSE)

     elseif c==-5   // F6   comando ^NN
        hb_keyPut(14)
        hb_keyPut(78)

     elseif c==-7   // F8   comando ^NO
        hb_keyPut(14)
        hb_keyPut(79)

     elseif c==-6   // F7   comando ^NB
        hb_keyPut(14)
        hb_keyPut(66)

     elseif c==14   // CTRL-N  buscar y reemplazar
//       if TEXTOTIPO=="BINARY"
       MSGCONTROL(" CTRL-N...  N=Search  |  O=Next Match   |  R=Replace Match | V=View Matches List",;
                  " SEARCH               |  B=Before Match |  A=Replace All   | Q=Del Matches List",;
                  " & REPLACE F6=Search  | F8=Next Match   | F7=Before Match")
/*       else
       MSGCONTROL(" CTRL-N...  N=Search  |  O=Next Match   |  R=Replace Match | V=View Matches List",;
                  " SEARCH               |  B=Before Match |  A=Replace All   | Q=Del Matches List",;
                  " & REPLACE F6=Search  | F8=Next Match   | F7=Before Match")
       end*/
       c:=inkey(0)
       c:=asc(upper(chr(c)))
       BarraTitulo(ARCHIVO)

       /*if TEXTOTIPO=="BINARY"
          if c==65 .or. c==82
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       end*/
       //SETCOLOR(N2COLOR(cBARRA))
       //@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
       while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)  
       if c==78  //.or. c==14    // CTRL-NN buscar
          WHILE .T.
              SETCOLOR(N2COLOR(cBARRA))
              //@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
              @ TLINEA-11,0 CLEAR TO TLINEA,MAXCOL()
              setpos(TLINEA-11,2); dispout("SEARCH?")
              if TEXTOTIPO=="BINARY"
                 MSGOPE(" <!,*>TEXT=CASE INSENS/FULL WORD #NUM;=ASCII &TEXT=HEXA")
              else
                 MSGOPE(" <!,*>TEXT=CASE INSENS/FULL WORD #NUM;=ASCII")
              end

              ///OPERA:=INPUTLINE(OPERA,SLINEA-1,TLINEA-2,13,"s")
              readinsert(.T.)
              setcolor( 'GR+/N,N/GR+,,,W/N' )
          
             cBUSCA:=MEMOEDIT(cBUSCA,TLINEA-10,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF")
             cBUSCA:=alltrim(cBUSCA)
             cBUSCA:=strtran(cBUSCA,_CR,"")
             c:=inkey()
             if lastkey()==27
                if LEN(cBUSCA)==0
                   exit
                else
                   cBUSCA:=""
                end
             else  // veo por "*"
//                exit
                if cBUSCA=="*"
                    // busca menú
                    if len(LISTABUSQUEDA)>0
                        SETCOLOR(N2COLOR(cBARRA))
                        @ TLINEA-(4+LEN(LISTABUSQUEDA)),10 CLEAR TO TLINEA-3,SLINEA-10

                        setpos(TLINEA-(4+LEN(LISTABUSQUEDA)),int(SLINEA/2)-11); outstd("List words")

                        MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                        setcolor( 'GR+/N,N/GR+,,,W/N' )
                        pELIGE:=ACHOICE(TLINEA-(3+LEN(LISTABUSQUEDA)),11,TLINEA-3,SLINEA-11,LISTABUSQUEDA, .T.)
                        
                        while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                        if pELIGE>0
                           cBUSCA:=LISTABUSQUEDA[pELIGE]
                        end
                        VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                     else
                        cBUSCA:=""
                     end
                else
                     if len(cBUSCA)>0
                        if ASCAN(LISTABUSQUEDA,cBUSCA)==0
                           AADD(LISTABUSQUEDA,cBUSCA)
                        end
                     end
                     exit
                end
             end
          END
          readinsert(.F.)
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
         // setpos(TLINEA-2,2);outstd(" SEARCH? ")
         // MSGINPUT("^KU=PASTE, <!,*> BEFORE TEXT=CASE INSENS/FULL WORD, #NUM;=ASCII")

         // cBUSCA:=INPUTLINE(cBUSCA,SLINEA-13,TLINEA-2,11,"s")
//? "[",cBUSCA,"]"; inkey(0)
          
          BarraTitulo(ARCHIVO)
          SETCOLOR(N2COLOR(cTEXTO))
          if len(ALLTRIM(cBUSCA))>0   ////lastkey()!=27
             tmpPos:=0
             SWMATCH:=.F.
             RELEASE LISTAFOUND
             LISTAFOUND:={}
             totLF:=0
             ptrLF:=1
             SWINSENSITIVE:=.F.
             SWPALABRACOMP:=.F.
             SWRANGE:=.F.

             if substr(cBUSCA,1,2)=="!*" .or. substr(cBUSCA,1,2)=="*!" // pueden ser las 2, o ninguna
                SWINSENSITIVE:=.T.
                SWPALABRACOMP:=.T.
                cBUSCA:=substr(cBUSCA,3,len(cBUSCA))
             else
                if substr(cBUSCA,1,1)=="!"  // case insensitive.
                   SWINSENSITIVE:=.T.
                   cBUSCA:=substr(cBUSCA,2,len(cBUSCA))
                elseif substr(cBUSCA,1,1)=="*"  // palabra completa
                   SWPALABRACOMP:=.T.
                   cBUSCA:=substr(cBUSCA,2,len(cBUSCA))
                end
                // hexadecimal?
                if TEXTOTIPO=="BINARY"
                   
                   // procesa codigo hexadecimal.
                   // además, cualquier texto es convertido a caracteres ascii, para ser procesado en tercera columna.
                   if substr(cBUSCA,1,1)=="&"   // texto hexadecimal
                      cBUSCA:=UPPER(substr(cBUSCA,2,len(cBUSCA)))
                      for i:=1 to len(cBUSCA)
                         if !(substr(cBUSCA,i,1) $ "0123456789ABCDEF ")
                            cMessage := hb_utf8tostr("OPCODE no válido."+_CR+"Intenta con números hexadecimales reales")
                            aOptions := { hb_utf8tostr("Será...") }
                            nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                            while inkey(,159)!=0 ; end
                            MRESTSTATE(MOUSE)
                            setpos(py,px)
                            exit
                         end
                      end
                      if i<len(cBUSCA)
                         loop
                      end
                      cTMP:=numtoken(cBUSCA," ")
                      //c1:=pi; c2:=p
                      c1:=""
                      for i:=1 to cTMP
                         j:=token(cBUSCA," ",i)   // obtengo primer numero
                         c1+=chr(HEXATODEC(j))
                      end
                      cBUSCA:=c1
                   elseif upper(substr(cBUSCA,1,1))=="R"  // busca un rango de caracteres
                      cBUSCA:=alltrim(substr(cBUSCA,2,len(cBUSCA)))
                      nOCURR1:=numtoken(cBUSCA,",")
                      if nOCURR1==2
                          tmpPos1:=val(alltrim(token(cBUSCA,",",1)))
                          tmpPos2:=val(alltrim(token(cBUSCA,",",2)))
                          cBUSCA:=" " // anula reemplazo. dejo un espacio para que pueda marcar
                          SWRANGE:=.T.
                      else
                          MSGBARRA("MATCH NOT FOUND",ARCHIVO,1)
                          POSY:=0;POSX:=0
                          BarraTitulo(ARCHIVO)
                          loop
                      end
                   end
                end
                // añadir carcateres especiales
                if "#" $ cBUSCA .and. ";" $ cBUSCA  // chr
                   SWINSENSITIVE:=.T.
                   nOCURR1:=NUMAT("#",cBUSCA)
                   nOCURR2:=NUMAT(";",cBUSCA)
                   //? cBUSCA, nOCURR1,nOCURR2
                   if nOCURR1==nOCURR2
                   for i:=1 to nOCURR1
                      tmpPos1:=atnum("#",cBUSCA,1)
                      tmpPos2:=atnum(";",cBUSCA,1)
                     // ? tmpPos2,tmpPos1
                      if tmpPos2>tmpPos1
                         cTMP:=substr(cBUSCA,tmpPos1,tmpPos2-tmpPos1+1)
                    //     ? cTMP
                         cTMP:=charrem("#;",cTMP)
                         if ISTNUMBER(cTMP)==1
                            cBUSCA:=substr(cBUSCA,1,tmpPos1-1) + chr(val(cTMP)) + substr(cBUSCA,tmpPos2+1,len(cBUSCA))
                         end
                      end
                   end
                  // ? cBUSCA; inkey(0)
                   end
                end
             end

                for i:=1 to TOPE  // el if anterior evita el POSY+1 y permite buscar en misma linea
                   if TEXTOTIPO=="BINARY"
                      if i<TOPE
                         if !SWRANGE
                            STRING:=TEXTO[i]+SUBSTR(TEXTO[i+1],nOFFSET+1,len(TEXTO[i+1]))
                         else
                            STRING:=TEXTO[i]
                         end
                      else
                         STRING:=TEXTO[i]
                      end
                   else
                      STRING:=TEXTO[i]  //LLENATEXTO(TEXTO[i],len(TEXTO[i]),0,NIL,NIL,0)
                   end
                /* buscaré todas las ocurrencias y llenaré una pila que será consultada por ^NO y ^NB */
                   if SWRANGE
                      nOCURR:=1
                      j:=1
                      tmpPos:=0
                      while nOCURR>0
                       //  if j==0
                       //     nOCURR:=POSRANGE(chr(tmpPos1),chr(tmpPos2),STRING)
                       //  else
                            nOCURR:=POSRANGE(chr(tmpPos1),chr(tmpPos2),STRING,,tmpPos)
                       //  end
                         if nOCURR>0
                            tmpPos:=nOCURR
                            //if tmpPos<nOFFSET .or. tmpPos>nOFFSET+20
                           //     tmpPos:=0
                            //else
                           //  ? "TMPOS=",tmpPos; inkey(0)
                               AADD(LISTAFOUND,i)   // fila
                               AADD(LISTAFOUND,tmpPos) //iif(tmpPos>SLINEA-2,tmpPos+1,tmpPos))
                               AADD(LISTAFOUND,j)   // ocurrencia. necesario para reemplazar
                               totLF+=3
                               SWMATCH:=.T.  // encontré algo...
                               
                           // end
                         end
                         ++j
                      end
                      nOCURR:=0
                   else
                      if !SWINSENSITIVE
                         nOCURR:=NUMAT(cBUSCA,STRING)
                      else
                         nOCURR:=NUMAT(upper(cBUSCA),upper(STRING))
                      end
                   end
                   if nOCURR>0
/*                      if SWRANGE
                         tmpPos:=nOCURR
                         if tmpPos<nOFFSET .or. tmpPos>nOFFSET+20
                             tmpPos:=0
                         else
                            AADD(LISTAFOUND,i)   // fila
                            AADD(LISTAFOUND,tmpPos) //iif(tmpPos>SLINEA-2,tmpPos+1,tmpPos))
                            AADD(LISTAFOUND,1)   // ocurrencia. necesario para reemplazar
                            totLF+=3
                            SWMATCH:=.T.  // encontré algo...
                         end
                      else */
                      for j:=1 to nOCURR
                         if !SWINSENSITIVE
                            tmpPos:=ATNUM(cBUSCA,STRING,j)
                            if TEXTOTIPO=="BINARY"
                               if tmpPos<nOFFSET .or. tmpPos>nOFFSET+20
                                  tmpPos:=0
                               end
                            end
                         else
                            tmpPos:=ATNUM(upper(cBUSCA),upper(STRING),j)
                            if TEXTOTIPO=="BINARY"
                               if tmpPos<nOFFSET .or. tmpPos>nOFFSET+20
                                  tmpPos:=0
                               end
                            end
                         end
                         if SWPALABRACOMP
                            tmpPos:=BUSCACOMPLETA(tmpPos,STRING,len(cBUSCA))
                            if TEXTOTIPO=="BINARY"
                               if tmpPos<nOFFSET .or. tmpPos>nOFFSET+20
                                  tmpPos:=0
                               end
                            end
                         end
                         if tmpPos>0
                            AADD(LISTAFOUND,i)   // fila
                            AADD(LISTAFOUND,tmpPos) //iif(tmpPos>SLINEA-2,tmpPos+1,tmpPos))
                            AADD(LISTAFOUND,j)   // ocurrencia. necesario para reemplazar
                            totLF+=3
                            SWMATCH:=.T.  // encontré algo...
                         end
                     // end
                      end
                   end
                end
                if SWMATCH
                   MSGBARRA(hb_ntos(int(totLF/3))+" MATCHES FOUND!",ARCHIVO,1)
                   POSY:=LISTAFOUND[1]
                   POSX:=LISTAFOUND[2]
                   nOCURR:=LISTAFOUND[3]
                   cini:=0
                   hb_keyPut(10)
                else
                   MSGBARRA("MATCH NOT FOUND",ARCHIVO,1)
                   POSY:=0;POSX:=0  // se resetea cuando ya no encuentra más
                end
           //  end  // binary
          end
          
       elseif c==66 // .or. c==2  // CTRL-NB  repite busqueda de la ocurrencia anterior
          BarraTitulo(ARCHIVO)
          if totLF>0
             if ptrLF>1
                ptrLF-=3
                POSY:=LISTAFOUND[ptrLF]
                POSX:=LISTAFOUND[ptrLF+1]
                nOCURR:=LISTAFOUND[ptrLF+2]
                cini:=0
                hb_keyPut(10)
             else  // es igual a 1
                ptrLF:=totLF-2
                POSY:=LISTAFOUND[ptrLF]
                POSX:=LISTAFOUND[ptrLF+1]
                nOCURR:=LISTAFOUND[ptrLF+2]
                cini:=0
                hb_keyPut(10)
             end
          end

       elseif c==79 // .or. c==15  // CTRL-NO  repite búsqueda
          BarraTitulo(ARCHIVO)
          if totLF>0
             if ptrLF<totLF-3  // debe ser 3 veces menor
                ptrLF+=3
                POSY:=LISTAFOUND[ptrLF]
                POSX:=LISTAFOUND[ptrLF+1]
                nOCURR:=LISTAFOUND[ptrLF+2]
                cini:=0
                hb_keyPut(10)
             else
                ptrLF:=1
                POSY:=LISTAFOUND[ptrLF]
                POSX:=LISTAFOUND[ptrLF+1]
                nOCURR:=LISTAFOUND[ptrLF+2]
                cini:=0
                hb_keyPut(10)
             end
          end

       elseif c==81 // .or. c==17    // CTRL-NQ  borra el buffer de matches
          RELEASE LISTAFOUND
          LISTAFOUND:={}
          SWMATCH:=.F.
          SWPRIMERAVEZ:=.F.
          ptrLF:=0; totLF:=0
          MSGBARRA("MATCHES BUFFER CLEANED. NOW YOU CAN USE CTRL-J",ARCHIVO,1)
          BarraTitulo(ARCHIVO)
          setpos(py,px)

       elseif c==86  //.or. c==22  // CTRL-NV  visualiza los match
          if totLF>0
             MENUMATCH:={}
             for i:=1 to totLF step 3
                if TEXTOTIPO=="BINARY"
                   //(pi-1)*20+(px-1)
                   aadd(MENUMATCH,substr(TEXTO[LISTAFOUND[i]],1,at("|",TEXTO[LISTAFOUND[i]])-1)+" ( "+;
                                  padl( DECTOHEXA( (LISTAFOUND[i]-1)*20 + (LISTAFOUND[i+1]-nOFFSET-1) ),7)+" ) : "+;
                                  strtran(hb_utf8tostr(substr(TEXTO[LISTAFOUND[i]],nOFFSET,len(TEXTO[LISTAFOUND[i]])))+;
                                  iif(LISTAFOUND[i]+1<=TOPE,ltrim(hb_utf8tostr(substr(TEXTO[LISTAFOUND[i]+1], nOFFSET,;
                                  LEN(TEXTO[LISTAFOUND[i]+1])))),""),cBUSCA,UPPER(cBUSCA)))
                else
                   aadd(MENUMATCH,padl(hb_ntos(LISTAFOUND[i]),5)+", "+;
                                  padl(hb_ntos(LISTAFOUND[i+1]),5) + " : "+;
                                  strtran(TEXTO[LISTAFOUND[i]],cBUSCA,upper(cBUSCA)))
                end
             end
   
             SETCOLOR(N2COLOR(cBARRA))
             if len(MENUMATCH)<int(TLINEA/2)
                XCLEAR:=len(MENUMATCH)+3
             else
                XCLEAR:=int(TLINEA/2)+3
             end
             @ TLINEA-XCLEAR,0 CLEAR TO TLINEA-3,SLINEA
             setpos(TLINEA-XCLEAR, 2) //int(SLINEA/2)-13) 
             if TEXTOTIPO=="BINARY"
                outstd("    DIRECTION       POSITION      STRING MATCH")
             else
                outstd(" ROW    COL   LINE MATCH ")
             end
             MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
             //SETCOLOR(N2COLOR(6))
             setcolor( 'GR+/N,N/GR+,,,W/N' )
             pELIGE:=ACHOICE(TLINEA-XCLEAR+1,1,TLINEA-3,SLINEA-1,MENUMATCH, .T.)
             while inkey(,159)!=0 ; end
             MRESTSTATE(MOUSE) 
             VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             BarraTitulo(ARCHIVO)
             SETCOLOR(N2COLOR(cTEXTO))
             setpos(py,px)
             if pELIGE>0
                ptrLF:=pELIGE+(pELIGE-1)+(pELIGE-1)
                POSY:=LISTAFOUND[ptrLF]
                POSX:=LISTAFOUND[ptrLF+1]
                nOCURR:=LISTAFOUND[ptrLF+2]
                cini:=0
                hb_keyPut(10)
             end
             RELEASE MENUMATCH
          else
             MSGBARRA("MATCH NOT FOUND",ARCHIVO,1)
             SETCOLOR(N2COLOR(cTEXTO))
             setpos(py,px)
          end
  
       elseif c==65 // .or. c==1   // CTRL-NA  reemplaza todas las ocurrencias
         if SWMATCH // .and. !SWRANGE
          if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
          WHILE .T. 
             // setpos(TLINEA-2,2);  outstd("TO REPLACE? ")
             // MSGINPUT("^KU=PASTE, #NUM=ASCII")

             // cREEMPLAZA:=INPUTLINE(cREEMPLAZA,SLINEA-16,TLINEA-2,14,"s")
             SETCOLOR(N2COLOR(cBARRA))
             //@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
             @ TLINEA-11,0 CLEAR TO TLINEA,MAXCOL()
             setpos(TLINEA-11,2); dispout("REPLACE ALL "+cBUSCA+" WITH?")
             MSGOPE(" #NUM;=ASCII ")

             ///OPERA:=INPUTLINE(OPERA,SLINEA-1,TLINEA-2,13,"s")
             readinsert(.T.)
             setcolor( 'GR+/N,N/GR+,,,W/N' )
         
             cREEMPLAZA:=MEMOEDIT(cREEMPLAZA,TLINEA-10,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF")
             cREEMPLAZA:=alltrim(cREEMPLAZA)
             cREEMPLAZA:=strtran(cREEMPLAZA,_CR,"")
             c:=inkey()
             if lastkey()==27
                if LEN(cREEMPLAZA)==0
                   exit
                else
                   cREEMPLAZA:=""
                end
             else
               // exit
                if cREEMPLAZA=="*"
                    // busca menú
                    if len(LISTABUSQUEDA)>0
                        SETCOLOR(N2COLOR(cBARRA))
                        @ TLINEA-(4+LEN(LISTABUSQUEDA)),10 CLEAR TO TLINEA-3,SLINEA-10

                        setpos(TLINEA-(4+LEN(LISTABUSQUEDA)),int(SLINEA/2)-11); outstd("List words")

                        MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                        setcolor( 'GR+/N,N/GR+,,,W/N' )
                        pELIGE:=ACHOICE(TLINEA-(3+LEN(LISTABUSQUEDA)),11,TLINEA-3,SLINEA-11,LISTABUSQUEDA, .T.)
                        
                        while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                        if pELIGE>0
                           cREEMPLAZA:=LISTABUSQUEDA[pELIGE]
                        end
                        VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                     else
                        cREEMPLAZA:=""
                     end
                else
                     if len(cREEMPLAZA)>0
                        if ASCAN(LISTABUSQUEDA,cREEMPLAZA)==0
                           AADD(LISTABUSQUEDA,cREEMPLAZA)
                        end
                     end
                     exit
                end
             end
          END
          readinsert(.F.)
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           
           SETCOLOR(N2COLOR(cTEXTO))
           if lastkey()!=27  //len(alltrim(cREEMPLAZA))>0 //.or. lastkey()==13 se usa #13
             /* if substr(cREEMPLAZA,1,1)=="#"  // chr
                 if ISTNUMBER(substr(cREEMPLAZA,2,len(cREEMPLAZA)))==1
                    cREEMPLAZA:=chr(val(substr(cREEMPLAZA,2,len(cREEMPLAZA))))
                 end
              end*/
              if "#" $ cREEMPLAZA .and. ";" $ cREEMPLAZA  // chr
                   nOCURR1:=NUMAT("#",cREEMPLAZA)
                   nOCURR2:=NUMAT(";",cREEMPLAZA)
                   //? cBUSCA, nOCURR1,nOCURR2
                   if nOCURR1==nOCURR2
                   for i:=1 to nOCURR1
                      tmpPos1:=atnum("#",cREEMPLAZA,1)
                      tmpPos2:=atnum(";",cREEMPLAZA,1)
                     // ? tmpPos2,tmpPos1
                      if tmpPos2>tmpPos1
                         cTMP:=substr(cREEMPLAZA,tmpPos1,tmpPos2-tmpPos1+1)
                    //     ? cTMP
                         cTMP:=charrem("#;",cTMP)
                         if ISTNUMBER(cTMP)==1
                            cREEMPLAZA:=substr(cREEMPLAZA,1,tmpPos1-1) + chr(val(cTMP)) + substr(cREEMPLAZA,tmpPos2+1,len(cREEMPLAZA))
                         end
                      end
                   end
                  // ? cBUSCA; inkey(0)
                   end
                end
              for i:=1 to len(LISTAFOUND) step 3
                 POSY:=LISTAFOUND[i]    // fila
                 if TEXTOTIPO!="BINARY"
                    AADD(BUFFER_CTRLZ,TEXTO[POSY])
                    AADD(LINBUFFCTRLZ,POSY)
                 end
                 TEXTO[POSY]:=STRTRAN(TEXTO[POSY],cBUSCA,"__2FtR3__")
              end
              for i:=1 to len(LISTAFOUND) step 3
                 POSY:=LISTAFOUND[i]    // fila
                 TEXTO[POSY]:=STRTRAN(TEXTO[POSY],"__2FtR3__",cREEMPLAZA)
              end
              RELEASE s
              s:=ASIGNALINEA(TEXTO[POSY])
              SW_COMPILE:=.F.
              SW_MODIFICADO:=.T.
              SWMATCH:=.F. 
              RELEASE LISTAFOUND
              ptrLF:=0; totLF:=0; cini:=0; p:=1+nOFFSET;px:=1+nOFFSET
              VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           end
           BarraTitulo(ARCHIVO)
           exit
         else
           if !SWRANGE
              MSGBARRA("FIRST SEARCH, THEN REPLACE",ARCHIVO,1) 
           else
              MSGBARRA("REPLACE NOT VALID WITH RANGE",ARCHIVO,1) 
           end
           BarraTitulo(ARCHIVO)
         end
         setpos(py,px)
         
       elseif c==82 // .or. c==18 // CTRL-NR buscar y reemplazar
        if SWMATCH ///.and. !SWRANGE
          if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
          WHILE .T.
             //setpos(TLINEA-2,2);  outstd("TO REPLACE? ")
             //MSGINPUT("^KU=PASTE, #NUM=ASCII")

             //cREEMPLAZA:=INPUTLINE(cREEMPLAZA,SLINEA-16,TLINEA-2,14,"s")
             SETCOLOR(N2COLOR(cBARRA))
             //@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
             @ TLINEA-11,0 CLEAR TO TLINEA,MAXCOL()
             setpos(TLINEA-11,2); dispout("REPLACE "+cBUSCA+" WITH?")
             MSGOPE(" #NUM;=ASCII ")

             ///OPERA:=INPUTLINE(OPERA,SLINEA-1,TLINEA-2,13,"s")
             readinsert(.T.)
             setcolor( 'GR+/N,N/GR+,,,W/N' )
          
             cREEMPLAZA:=MEMOEDIT(cREEMPLAZA,TLINEA-10,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF")
             cREEMPLAZA:=alltrim(cREEMPLAZA)
             cREEMPLAZA:=strtran(cREEMPLAZA,_CR,"")
             c:=inkey()
             if lastkey()==27
                if LEN(cREEMPLAZA)==0
                   exit
                else
                   cREEMPLAZA:=""
                end
             else
               // exit
                if cREEMPLAZA=="*"
                    // busca menú
                    if len(LISTABUSQUEDA)>0
                        SETCOLOR(N2COLOR(cBARRA))
                        @ TLINEA-(4+LEN(LISTABUSQUEDA)),10 CLEAR TO TLINEA-3,SLINEA-10

                        setpos(TLINEA-(4+LEN(LISTABUSQUEDA)),int(SLINEA/2)-11); outstd("List words")

                        MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                        setcolor( 'GR+/N,N/GR+,,,W/N' )
                        pELIGE:=ACHOICE(TLINEA-(3+LEN(LISTABUSQUEDA)),11,TLINEA-3,SLINEA-11,LISTABUSQUEDA, .T.)
                        
                        while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                        if pELIGE>0
                           cREEMPLAZA:=LISTABUSQUEDA[pELIGE]
                        end
                        VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                     else
                        cREEMPLAZA:=""
                     end
                else
                     if len(cREEMPLAZA)>0
                        if ASCAN(LISTABUSQUEDA,cREEMPLAZA)==0
                           AADD(LISTABUSQUEDA,cREEMPLAZA)
                        end
                     end
                     exit
                end
             end
          END
          readinsert(.F.)
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)

          SETCOLOR(N2COLOR(cTEXTO))
          
          if lastkey()!=27  //len(alltrim(cREEMPLAZA))>0 ///.or. lastkey()==13 se usa #13
             /*if substr(cREEMPLAZA,1,1)=="#"  // chr
                 if ISTNUMBER(substr(cREEMPLAZA,2,len(cREEMPLAZA)))==1
                    cREEMPLAZA:=chr(val(substr(cREEMPLAZA,2,len(cREEMPLAZA))))
                 end
             end*/
             if "#" $ cREEMPLAZA .and. ";" $ cREEMPLAZA  // chr
                   nOCURR1:=NUMAT("#",cREEMPLAZA)
                   nOCURR2:=NUMAT(";",cREEMPLAZA)
                   //? cBUSCA, nOCURR1,nOCURR2
                   if nOCURR1==nOCURR2
                   for i:=1 to nOCURR1
                      tmpPos1:=atnum("#",cREEMPLAZA,1)
                      tmpPos2:=atnum(";",cREEMPLAZA,1)
                     // ? tmpPos2,tmpPos1
                      if tmpPos2>tmpPos1
                         cTMP:=substr(cREEMPLAZA,tmpPos1,tmpPos2-tmpPos1+1)
                    //     ? cTMP
                         cTMP:=charrem("#;",cTMP)
                         if ISTNUMBER(cTMP)==1
                            cREEMPLAZA:=substr(cREEMPLAZA,1,tmpPos1-1) + chr(val(cTMP)) + substr(cREEMPLAZA,tmpPos2+1,len(cREEMPLAZA))
                         end
                      end
                   end
                  // ? cBUSCA; inkey(0)
                   end
                end 
             // OJO: ya tengo seteado ptrLF
             ////STRING:=LLENATEXTO(TEXTO[POSY],len(TEXTO[POSY]),0,NIL,NIL,0)
             tmpPos:=ATNUM(cBUSCA,TEXTO[POSY],nOCURR)
             
             if TEXTOTIPO!="BINARY"
                // CTRL-Z
                AADD(BUFFER_CTRLZ,TEXTO[POSY])
                AADD(LINBUFFCTRLZ,POSY)
             end
             TEXTO[POSY]:=STRTRAN(TEXTO[POSY],cBUSCA,cREEMPLAZA,nOCURR,1)
             adel(LISTAFOUND,ptrLF)
             adel(LISTAFOUND,ptrLF)
             adel(LISTAFOUND,ptrLF)
             totLF-=3
             asize(LISTAFOUND,totLF)
             SETCOLOR(N2COLOR(cTEXTO))
             RELEASE s
             s:=ASIGNALINEA(TEXTO[POSY])

             xlen:=len(s)+1
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             BarraTitulo(ARCHIVO)

             if ptrLF>=totLF
                ptrLF-=3
                if ptrLF<1
                   hb_keyPut(14)
                   hb_keyPut(3)
                   //setpos(py,1)
                   exit
                end
             end 
             /* busca si fue una ocurrencia entre otras de una misma linea para recalibrar */
             RELEASE LISTAFOUND
             LISTAFOUND:={}
             //tmpPos:=0
             for i:=1 to len(TEXTO)  // el if anterior evita el POSY+1 y permite buscar en misma linea
                ////STRING:=LLENATEXTO(TEXTO[i],len(TEXTO[i]),0,NIL,NIL,0)
                /* buscaré todas las ocurrencias y llenaré una pila que será consultada por ^NO y ^NB */
                if !SWINSENSITIVE
                   nOCURR:=NUMAT(cBUSCA,cBUSCA,TEXTO[i])
                else
                   nOCURR:=NUMAT(upper(cBUSCA),upper(cBUSCA),TEXTO[i])
                end
               // nOCURR:=NUMAT(cBUSCA,TEXTO[i])
                if nOCURR>0
                   for j:=1 to nOCURR
                      if !SWINSENSITIVE
                         tmpPos:=ATNUM(cBUSCA,TEXTO[i],j)
                      else
                         tmpPos:=ATNUM(upper(cBUSCA),upper(TEXTO[i]),j)
                      end
                      if SWPALABRACOMP
                         tmpPos:=BUSCACOMPLETA(tmpPos,TEXTO[i],len(cBUSCA))
                      end
                      //tmpPos:=ATNUM(cBUSCA,TEXTO[i],j)
                      if tmpPos>0
                         AADD(LISTAFOUND,i)   // fila
                         AADD(LISTAFOUND,tmpPos)
                         //AADD(LISTAFOUND,iif(tmpPos>SLINEA,tmpPos+len(cBUSCA),;
                         //         iif(j>1.or.tmpPos+(len(cBUSCA))>SLINEA,tmpPos+1,tmpPos) ) ) // columna
                         AADD(LISTAFOUND,j)   // ocurrencia. necesario para reemplazar
                      end
                   end
                end
             end

             POSY:=LISTAFOUND[ptrLF]
             POSX:=LISTAFOUND[ptrLF+1]
             nOCURR:=LISTAFOUND[ptrLF+2]
             cini:=0
             hb_keyPut(10)
          end
          BarraTitulo(ARCHIVO)
        else
          if !SWRANGE
             MSGBARRA("FIRST SEARCH, THEN REPLACE",ARCHIVO,1)
          else
             MSGBARRA("REPLACE NOT VALID WITH RANGE",ARCHIVO,1) 
          end
          BarraTitulo(ARCHIVO)
        end // SWMATCH de REPLACE
       else
          BarraTitulo(ARCHIVO)
       end
       setpos(py,px)
      
     elseif c==-8   // F9 llama directo a ^JJ
       SWf9:=.T.
       hb_keyPut(10)
       hb_keyPut(74)
 
     elseif c==10    // CTRL-J   // SALTA a linea
       SWRAPIDA:=.F.
       if !SWMATCH .or. SWF9  // usa el comando aunque este ocupado con SWMATCH
          SWF9:=.F.
          /** go function, vars, algorithm **/
          if TEXTOTIPO=="BINARY"
          MSGCONTROL(" CTRL-J...  J=Jump to Pos | F9=Jump to Pos",;
                     " JUMP ",;
                     "")
          else
          MSGCONTROL(" CTRL-J...  J=Jump to Line | V=to 'VARS:' (XU) | A=To 'ALGORITHM:' (XU) | F=To 'FUNCTIONS:' (XU)",;
                     " JUMP      F9=Jump to Line | B=Back (only for ^J+J)",;
                     "")
          end
          c:=inkey(0)
          c:=asc(upper(chr(c)))
          BarraTitulo(ARCHIVO)
          if TEXTOTIPO=="BINARY"
             if c!=74 .and. c!=27
                cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
                loop
             end
          end
          setpos(py,px)
          if !SWCTRLJCTRKV
             while inkey(,159)!=0 ; end  // si coloco esto, no puedo hacer ^J en BUFFER
             MRESTSTATE(MOUSE)
          else
             SWCTRLJCTRKV:=.F.
          end
          if c==74 // .or. c==10
             SETCOLOR(N2COLOR(cBARRA))
             ECX:="      "
             @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
             MSGINPUT("")
             if TEXTOTIPO=="BINARY"
                 setpos(TLINEA-2,2);outstd(" POS. TO JUMP? ")
                 ECX:=""
                 ECX:=ALLTRIM(INPUTLINE(ECX,9,TLINEA-2,17,"s"))
             else
                 setpos(TLINEA-2,2);outstd(" LINE TO JUMP? ")
                 ECX:=val(INPUTLINE(ECX,7,TLINEA-2,17,"N"))
             end

             if TEXTOTIPO=="BINARY"
                ECX:=UPPER(ECX)
//                ? "ECX=",ECX;inkey(0)
                if ISTNUMBER(ECX)==1
                   ECX:=VAL(ECX)
                else
                   for i:=1 to len(ECX)
                      if !(substr(ECX,i,1) $ "0123456789ABCDEF")
                         cMessage := hb_utf8tostr("Posición no válida."+_CR+"Intenta con números hexadecimales reales")
                         aOptions := { hb_utf8tostr("Será...") }
                         nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                         while inkey(,159)!=0 ; end
                         MRESTSTATE(MOUSE)
                         setpos(py,px)
                         exit
                      end
                   end
                   if i<len(ECX)
                      loop
                   end
                   ECX:=HEXATODEC(ECX)
                end
                POSX:= (ECX % 20) + nOFFSET + 1
                ECX := int(ECX/20)+1
                
             end
             BarraTitulo(ARCHIVO)
             SETCOLOR(N2COLOR(cTEXTO))
          else
             cBUSCAR:=""
             
             if c==70 // .or. c==6   // CTRL-JF   vaya a funcion
                cBUSCAR:="functions:"
             elseif c==86 // .or. c==22  // CTRL-JV  vaya a vars:
                cBUSCAR:="vars:"
             elseif c==65 // .or. c==1   // CTRL-JA  vaya a algorithm:
                cBUSCAR:="algorithm:"
             elseif c==66 //.or. c==2   // CTRL-JB  regresa al punto original.
                if yCALLBACK>0
                   ECX:=yCALLBACK
                   POSX:=xCALLBACK
                   yCALLBACK:=0
                   xCALLBACK:=0
                   SWRAPIDA:=.T.
                else
                   ECX:=pi
                end
             end
             if len(cBUSCAR)>0 
                for i:=1 to len(TEXTO)  // el if anterior evita el POSY+1 y permite buscar en misma linea
                   ////STRING:=LLENATEXTO(TEXTO[i],len(TEXTO[i]),0,NIL,NIL,0)
                   /* buscaré todas las ocurrencias y llenaré una pila que será consultada por ^NO y ^NB */
                   nOCURR:=AT(cBUSCAR,TEXTO[i])
                   if nOCURR>0
                      ECX:=i
                      POSX:=0
                      SWRAPIDA:=.T.
                      exit
                   end
                end
                if !SWRAPIDA
                   ECX:=pi
                   yCALLBACK:=0
                   xCALLBACK:=0
                else
                   yCALLBACK:=pi
                   xCALLBACK:=p
                end
             else
                if c!=2
                   ECX:=pi
                end
             end
          
          end
       else
          ECX:=POSY
          cini:=0
       end
       if lastkey()!=27 .or. SWRAPIDA
         if ECX<=TOPE .and. ECX>0
          yCALLBACK:=pi
          xCALLBACK:=p
          if ECX==1
             pi:=1;lini:=1; lfin:=TOPE; px:=1/*+nOFFSET*/; p:=1/*+nOFFSET*/; py:=1
          elseif ECX==TOPE
             pi:=TOPE;lini:=TOPE; lfin:=TOPE; px:=1/*+nOFFSET*/; p:=1/*+nOFFSET*/; py:=1 
          else
             if ECX>=lini .and. ECX<=lini+TLINEA-4  // linea bscada esta en vista
                tpi:=pi
                pi:=pi + (ECX-pi)
                py:=py + (pi-tpi)
                px:=1/*+nOFFSET*/; p:=1/*+nOFFSET*/
                pCURSOR:=p
             else
                for i:=1 to TOPE step TLINEA-4
                   if ECX>=i .and. ECX<=i+TLINEA-4
                      pi:=ECX;lini:=i; lfin:=i+TLINEA-4; px:=1;p:=1 // px:=1+nOFFSET; p:=1+nOFFSET
                      py:=ECX-lini+1
                      pCURSOR:=p
                      exit
                   end
                end
             end
          end

          if (SWMATCH .or. c==66 .or. TEXTOTIPO=="BINARY") // .or. c==2
             if POSX>0
                if p>1
                   pushkey(19,p-1)
                end
                pushkey(4,POSX-1)
                if !SWMOVPAG
                   pushkey(256,1)  // codigo que define el color de seleccion
                   SWHUEA:=.T.
                end
             end
          end
          if SWMOVPAG
             SWMOVPAG:=.F.
             SWMATCH:=.F.
          end
          
          VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          
          BarraTitulo(ARCHIVO)

          setpos(py,1)
          exit
         else
          setpos(py,px)
         end
       else
         setpos(py,px)
       end


     elseif c==12   // CTRL-L calculo de vectores numericos.
       // if len(BUFFER)>0
       if TEXTOTIPO=="BINARY"
          while inkey(,159)!=0 ; end  // por si viene de ALT-L
          
          RBUFFER:=_CALCULADORA(ARCHIVO)  // no hará nada con RBUFFER aquí.

          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          BarraTitulo(ARCHIVO)
          exit
       else
          // limpio la lista de busqueda, por si acaso.
           if len(LISTAFOUND)>0 
                    RELEASE LISTAFOUND
                    LISTAFOUND:={}
                    SWMATCH:=.F.
                    ptrLF:=0; totLF:=0
           end
           @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
           MSGBARRA("SELECT AN OPTION WITH LEFT|RIGHT ARROW, AND PRESS RETURN",ARCHIVO,2)
           nChoice:=1
           setcursor(1)
           setcolor( 'GR+/N,N/GR+,,,W/N' )
           ///set decimals to 6
           nSetDecimal:=set(3,DEFROUND)
           while nChoice>0
              nChoice:=_CTRL_LMENU(TLINEA)
              if nChoice>=1 .and. nChoice<=4
                 mainChoice:=nChoice  // respaldo
                 cLEN:=len(BUFFER)
                 // verificar si es una matriz:
                 if cLEN>0
                    if AT(",",BUFFER[1])>0  // hay lista separada por comas. PUede ser matriz
                       nChoice:=ORIENTACION()
                       if nChoice==0
                          exit
                       end
                       RBUFFER:=ARRAY(LEN(BUFFER))
                       ACOPY(BUFFER,RBUFFER)
                       SWRECBUFFER:=.T.
                       BUFFER:=_CTRL_L_SUMSTDVARMEAN(mainChoice, nChoice, cLEN, BUFFER)
                     //  SW_PASTE:=.T.
                       hb_keyPut(11)
                       hb_keyPut(85)
                       exit
                    else   // es un vector vertical
                       nSol:=_CTRL_L_VSUMMEANSTDVAR(mainChoice,cLEN,BUFFER)
                       TEXTO[pi]:=substr(TEXTO[pi],1,p-1)+hb_ntos((nSol))+substr(TEXTO[pi],p,len(TEXTO[pi]))
                    end
                 end
                 exit
              elseif nChoice==5
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_SQRT(@BUFFER)
               //  SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==6
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_CUAD(@BUFFER)
              //   SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==7
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_LOG10(@BUFFER)
              //   SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==8
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_LN(@BUFFER)
              //   SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==9
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_ABS(@BUFFER)
               //  SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==10   // Operaciones con macrosustitución
                 WHILE .T.
               
                 SETCOLOR(N2COLOR(cBARRA))
                 //@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                 @ TLINEA-11,0 CLEAR TO TLINEA,MAXCOL()
                 setpos(TLINEA-11,2); dispout("OPERATION:   (SEE HELP FOR MORE...)")
                 MSGOPE(" ^L=LOAD ^K=SAVE ^C=COPY *=LIST EXPR. ")

                 ///OPERA:=INPUTLINE(OPERA,SLINEA-1,TLINEA-2,13,"s")
                 readinsert(.T.)
                 setcolor( 'GR+/N,N/GR+,,,W/N' )
                 WHILE .T.
                    OPERA:=MEMOEDIT(OPERA,TLINEA-10,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF")
                    c:=inkey()
                    if lastkey()==27
                       if LEN(ALLTRIM(OPERA))==0
                          exit
                       else
                          OPERA:=""
                       end
                    elseif c==3 //inkey()==3
                       for i:=1 to mlcount(OPERA)
                          AADD(BUFFER,rtrim(memoline(OPERA,1024,i)))
                       end
                       OPERA:=""
                       while inkey()!=0
                           ;
                       end
                       exit
                    elseif c==12
                       OPERA:='load("'+alltrim(OPERA)+'")'
                       while inkey()!=0
                           ;
                       end
                      // ? OPERA; inkey(0)
                       exit
                    elseif c==11
                       OPERA:='save("'+alltrim(OPERA)+'")'
                       while inkey()!=0
                           ;
                       end
                     //  ? OPERA; inkey(0)
                       exit 
                    else
                       exit
                    end
                 END
                 SETCOLOR(N2COLOR(cBARRA))
                 readinsert(.F.)
                 //OPERA:=STRTRAN(OPERA,_CR,"")
                 ///OPERA:=STRTRAN(OPERA,CHR(9),"")
                 //? OPERA; inkey(0)
                 OPERA:=ALLTRIM(OPERA)
                 if OPERA=="*"
                    // busca menú
                    XLEN:=len(LISTAEXPRESION)
                    if XLEN>0
                        MATCH:={}
                        FOR i:=1 to XLEN
                           AADD(MATCH,strtran(LISTAEXPRESION[i],chr(10)," "))
                        END
                        SETCOLOR(N2COLOR(cBARRA))
                        @ TLINEA-(4+iif(XLEN>5,5,XLEN)),10 CLEAR TO TLINEA-3,SLINEA-10

                        setpos(TLINEA-(4+iif(XLEN>5,5,XLEN)),int(SLINEA/2)-11); outstd("List used expresions")

                        MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                        setcolor( 'GR+/N,N/GR+,,,W/N' )

                        pELIGE:=ACHOICE(TLINEA-(3+iif(XLEN>5,5,XLEN)),11,TLINEA-3,SLINEA-11,MATCH, .T.,"CTRLKVUSERFUNCTION")
                        
                        while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                        if pELIGE>0
                           if lastkey()==7 .or. lastkey()==8
                              adel(LISTAEXPRESION,pELIGE)
                              asize(LISTAEXPRESION,len(LISTAEXPRESION)-1)
                           else
                              OPERA:=LISTAEXPRESION[pELIGE]
                           end
                        end
                        VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                     end
                 elseif upper(OPERA)=="HELP"
                     hb_keyPut(15);hb_keyPut(79)
                     exit
                 else
                     exit
                 end
                 END
                 if upper(OPERA)=="HELP"
                     hb_keyPut(15);hb_keyPut(79)
                     exit
                 end
                 if len(OPERA)>0
                    if !SWEDITTEXT   // trabaja con el BUFFER
                       RBUFFER:=ARRAY(LEN(BUFFER))
                       ACOPY(BUFFER,RBUFFER)
                       SWRECBUFFER:=.T.
                       BUFFER:=_CTRL_L_OPE(BUFFER,hb_utf8tostr(STRTRAN(OPERA,_CR,""))) //OPERA)  // LLAMA A LA CALCULADORA
                       if LEN(BUFFER)>0
                          if BUFFER[1]=="<command-success>"
                             _CTRLOK()
                             BUFFER:=ARRAY(LEN(RBUFFER))
                             ACOPY(RBUFFER,BUFFER)
                             RBUFFER:={}
                             
                             SW_HAYBUFFER:=.T.
                             OPERA:=""
                             hb_keyPut(12)
                             hb_keyPut(asc("O"))
                             exit
                          elseif BUFFER[1]=="<error>"
                             _CTRLLERROR()
                             BUFFER:=ARRAY(LEN(RBUFFER))
                             ACOPY(RBUFFER,BUFFER)
                             RBUFFER:={}
                             hb_keyPut(12)
                             hb_keyPut(asc("O"))
                             exit
                          end
                          SW_HAYBUFFER:=.T.
                        //  SW_PASTE:=.T.
                          hb_keyPut(11)
                          hb_keyPut(85)
                          // busca por si no existe, para añadirlo a la lista
                          SWOPEXISTE:=.F.
                          for i:=1 to len(LISTAEXPRESION)
                             if OPERA == LISTAEXPRESION[i]
                                SWOPEXISTE:=.T.
                                exit
                             end
                          end
                          if !SWOPEXISTE
                             AADD(LISTAEXPRESION,OPERA)
                          end
                        /*  if !SWRECBUFFER  // mantiene el resultado en el BUFFER
                             BUFFER:=ARRAY(LEN(RBUFFER))
                             ACOPY(RBUFFER,BUFFER)
                          end*/
                       else
                          _CTRLLVOID()
                          BUFFER:=ARRAY(LEN(RBUFFER))
                          ACOPY(RBUFFER,BUFFER)
                          RBUFFER:={}
                          SW_HAYBUFFER:=.F.
                          hb_keyPut(12)
                          hb_keyPut(asc("O"))
                       end
                    else   // trabaja directamente con el texto. lomo plateado
                  ///     ? "ENTRA AQUI ",XFIL1EDIT,XFIL2EDIT ; inkey(0)
                       cTMP:=_CTRL_L_TEXTOPE(@TEXTO,hb_utf8tostr(STRTRAN(OPERA,_CR,"")),@XFIL1EDIT,@XFIL2EDIT)
                       if !cTMP
                          _CTRLLERROR()
                          if XFIL1EDIT==0 .and. XFIL2EDIT==0
                              SWEDITTEXT:=.F.
                             ///XFIL1EDIT:=0; XFIL2EDIT:=0
                          else
                              hb_keyPut(12)
                              hb_keyPut(asc("O"))
                          end
                       else
                          cMessage := hb_utf8tostr("Comando ejecutado con éxito")
                          aOptions := { chr(1) }
                          nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                          while inkey(,159)!=0 ; end
                          MRESTSTATE(MOUSE)
                          if len(BUFFER)>0
                             SW_HAYBUFFER:=.T.
                          end
                          if SWTEXTOMODIFICADO
                             SW_COMPILE:=.F.
                             SW_MODIFICADO:=.T.
                             SWTEXTOMODIFICADO:=.F.
                          end
                          SWOPEXISTE:=.F.
                          for i:=1 to len(LISTAEXPRESION)
                             if OPERA == LISTAEXPRESION[i]
                                SWOPEXISTE:=.T.
                                exit
                             end
                          end
                          if !SWOPEXISTE
                             AADD(LISTAEXPRESION,OPERA)
                          end
                          hb_keyPut(12)
                          hb_keyPut(asc("O"))
                       end
                    end
                 end
                 exit
              elseif nChoice==11 // def token
                 SETCOLOR(N2COLOR(cBARRA))
                 @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                 setpos(TLINEA-2,2); dispout("NEW TOKEN-SEP? ")
                 DEFTOKEN:=INPUTLINE(DEFTOKEN,SLINEA-1,TLINEA-2,17,"s")
                 exit
              elseif nChoice==12  // def round
                 SETCOLOR(N2COLOR(cBARRA))
                 @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                 setpos(TLINEA-2,2); dispout("NEW ROUND? ")
                 DEFROUND:=hb_ntos(DEFROUND)
                 DEFROUND:=VAL(INPUTLINE(DEFROUND,2,TLINEA-2,13,"s"))
                 if DEFROUND>13 .or. DEFROUND<0
                    DEFROUND:=13
                 end
                 exit
                 
              elseif nChoice==13
                 SW_HAYBUFFER:=.T.
                 SETCOLOR(N2COLOR(cBARRA))
                 @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                 RBUFFER:=ARRAY(LEN(BUFFER))
                 ACOPY(BUFFER,RBUFFER)
                 SWRECBUFFER:=.T.
                 _CTRL_L_LINSPC(@BUFFER,TLINEA)
               //  SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==14
                 SETCOLOR(N2COLOR(cBARRA))
                 SW_HAYBUFFER:=.T.
                 @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                    RBUFFER:=ARRAY(LEN(BUFFER))
                    ACOPY(BUFFER,RBUFFER)
                    SWRECBUFFER:=.T.
                 _CTRL_L_SEQ(@BUFFER,TLINEA)
               //  SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)
                 exit
              elseif nChoice==15
                 SW_HAYBUFFER:=.T.
                 RBUFFER:=ARRAY(LEN(BUFFER))
                    ACOPY(BUFFER,RBUFFER)
                    SWRECBUFFER:=.T.
                 _CTRL_L_INSHEADER(@BUFFER,ARCHIVO)
               //  SW_PASTE:=.T.
                 hb_keyPut(11)
                 hb_keyPut(85)

                 exit
              end
           end
           set(3,nSetDecimal)
           BarraTitulo(ARCHIVO)
           exit
       end
             
     elseif c==-2   // F3  comando ^KK
       hb_keyPut(11)
       hb_keyPut(75)
       
     elseif c==-3   // F4   comando ^KU
       hb_keyPut(11)
       hb_keyPut(85)
     elseif c==-9   // F10  comando ^KP indenta
       hb_keyPut(11)
       hb_keyPut(80)
     
   ///  elseif c==194 .and. OSSYSTEM=="DARWIN"   // ALT-K quita n espacios

    /*  TECLAS ATAJO ALT */

     elseif (c==307 .and. OSSYSTEM=="LINUX")   // ALT - ,  ubica el cursor sobre el siguiente numero
       SWBUSCAPAR:=.F.
       SWSALTANUM:=.F.
       if p>len(s)
          --p; --px
          setpos(py,px)
       end
       if asc(s[p])>=48 .and. asc(s[p])<=57
          SWSALTANUM:=.T.
       end
       for i:=p+1 to len(s)
          if SWSALTANUM
             if (asc(s[i])<48 .or. asc(s[i])>57) .and. s[i]!="."
                SWSALTANUM:=.F.
             end
          else
             if asc(s[i])>=48 .and. asc(s[i])<=57
                SWBUSCAPAR:=.T.
                exit
             end
          end
       end
       if SWBUSCAPAR
          for j:=p to p+(i-p-1)
             hb_keyPut(4)
          end
       end
     elseif (c==295 .and. OSSYSTEM=="LINUX")  // SHIFT-ALT - ; ubica cursor en numero der-->izq
       SWBUSCAPAR:=.F.
       SWSALTANUM:=.F.
       if p>len(s)
          --p; --px
          setpos(py,px)
       end
       if asc(s[p])>=48 .and. asc(s[p])<=57
          SWSALTANUM:=.T.
       end
       for i:=p-1 to 1 step -1
          if SWSALTANUM
             if (asc(s[i])<48 .or. asc(s[i])>57) .and. s[i]!="."
                SWSALTANUM:=.F.
             end
          else
             if asc(s[i])>=48 .and. asc(s[i])<=57
                SWBUSCAPAR:=.T.
                exit
             end
          end
       end
       if SWBUSCAPAR
          for j:=p to p-(p-i-1) step -1
             hb_keyPut(19)
          end
       end

     elseif c>=376 .and. c<=384   // ALT-1 .. ALT-9
             pELIGE:=9-(384-c)
             IF pELIGE<=LEN(METADATA)
                STRING:=METADATA[pELIGE]
              //? "ELIJO = ",STRING; inkey(0)
                EXT:=substr(STRING,rat(".",STRING)+1,len(STRING))
                if EXT=="xu" .or. EXT=="def"
                    ///RET:=substr(STRING,rat("/",STRING)+1,len(STRING))
                    RET:=STRING
                    SWLENGUAJE:=1
                else
                    if EXT=="c" .or. EXT=="cpp" .or. EXT=="h"
                       SWLENGUAJE:=2
                    else
                       SWLENGUAJE:=3
                    end
                    RET:=STRING
                end
                if EXT=="tex"
                   EXTENSION:=2
                elseif EXT=="m"
                   EXTENSION:=3
                else
                   EXTENSION:=1
                end
                   // si el archivo en edicion existe en la lista, no lo incluyo, pero altero su meta
                SWEXISTE:=.F.
               /* EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
                if EXT=="xu" .or. EXT=="def"
                   tARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                else
                   tARCHIVO:=ARCHIVO
                end*/
                for i:=1 to len(METADATA)
                     // ? METADATA[i],"----",ARCHIVO; inkey(0)
                      if METADATA[i]==ARCHIVO    ///tARCHIVO
                         SWEXISTE:=.T.  // no lo cargo
                        //  ? "EXISTE. SALE!  RET=",RET; inkey(0)
                         exit
                      end
                end
                lfin:=TOPE
                if !SWEXISTE   // no existe en la lista: lo añado
                     // ? "AÑADE PARA...",ARCHIVO;inkey(0)
                      AADD(METADATA,ARCHIVO)   ////tARCHIVO)
                      STRING:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                      AADD(cMETADATA,{STRING,pi,p,px,py,lini,lfin,cini,SW_COMPILE,SW_MODIFICADO,COMPILADOR,EJECUTOR,DESCRIPCION,;
                                      ESEJECUTABLE,COMENTARIOS,PARAMETROS,TEXTOTIPO,LENTEXTOTIPO})
                else  // esta en la lista, actualizo su metadata
                      cMETADATA[i][2]:=pi
                      cMETADATA[i][3]:=p
                      cMETADATA[i][4]:=px
                      cMETADATA[i][5]:=py
                      cMETADATA[i][6]:=lini
                      cMETADATA[i][7]:=lfin
                      cMETADATA[i][8]:=cini
                      cMETADATA[i][9]:=SW_COMPILE
                      cMETADATA[i][10]:=SW_MODIFICADO
                      cMETADATA[i][11]:=COMPILADOR
                      cMETADATA[i][12]:=EJECUTOR
                      cMETADATA[i][13]:=DESCRIPCION
                      cMETADATA[i][14]:=ESEJECUTABLE
                      cMETADATA[i][15]:=COMENTARIOS
                      cMETADATA[i][16]:=PARAMETROS
                      cMETADATA[i][17]:=TEXTOTIPO
                      cMETADATA[i][18]:=LENTEXTOTIPO
                end
              //  ? "CTRL-U. CARGO=",RET; inkey(0)
                SW_CTRLOF:=.T.
                hb_keyPut(17)   // sale.
                loop
             END
             pELIGE:=0
   
/*     elseif c==377    //  ALT-2

     elseif c==378    //  ALT - 3

     elseif c==379    //  ALT - 4
  */             
/*     elseif (c==383 .and. OSSYSTEM=="LINUX")  // ALT - 8 ubica cursor en inicio de string. izq-->der
       SWBUSCAPAR:=.F.
       for i:=p+1 to len(s)
          if s[i]==chr(34) .or. s[i]==chr(39)
             SWBUSCAPAR:=.T.
             exit
          end
       end
       if SWBUSCAPAR
          for j:=p to p+(i-p-1)
             hb_keyPut(4)
          end
       end
     elseif (c==382 .and. OSSYSTEM=="LINUX")  // ALT - 7 ubica cursor en inicio de string. der-->izq
       SWBUSCAPAR:=.F.
       for i:=p-1 to 1 step -1
          if s[i]==chr(34) .or. s[i]==chr(39)
             SWBUSCAPAR:=.T.
             exit                          
          end
       end
       if SWBUSCAPAR
          for j:=p to p-(p-i-1) step -1
             hb_keyPut(19)
          end
       end

     elseif c==377   // ALT - 1 igual que SHIFT.-ALT---> busca par+entesis desde la isquierda.
          SWBUSCAPAR:=.F.
          for i:=p+1 to len(s)
              if s[i]=="(" .or. s[i]=="[" .or. s[i]=="{"
                  SWBUSCAPAR:=.T.
                  exit                          
              end
          end
          if SWBUSCAPAR
              for j:=p to p+(i-p-1)
                  hb_keyPut(4)
              end
          end
     
     elseif c==376    //  ALT - 2 busca ), ] y }
          SWBUSCAPAR:=.F.
          for i:=p-1 to 1 step -1
              if s[i]=="(" .or. s[i]=="[" .or. s[i]=="{"
                 SWBUSCAPAR:=.T.
                 exit                          
              end
          end
          if SWBUSCAPAR
              for j:=p to p-(p-i-1) step -1
                 hb_keyPut(19)
              end
          end
*/
     elseif c==386  .and. OSSYSTEM=="LINUX" // ALT - guion   desplaza el texto como SHIFT-CONTROL flecha
        if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
                   if pi<TOPE
                      if SWGETLINEDESP  // desplaza el bloque completo hacia abajo
                         if XFILf<TOPE
                            TEXTO[pi]:=LLENATEXTO(s,len(s),0)  // lleno por precaución
                            for i:=XFILf to XFILi step -1
                                                     // CTRl-Z
                               AADD(BUFFER_CTRLZ,TEXTO[i])
                               AADD(LINBUFFCTRLZ,i)
                               AADD(BUFFER_CTRLZ,TEXTO[i+1])
                               AADD(LINBUFFCTRLZ,i+1)
                               AADD(BUFFER_CTRLZ,chr(8))
                               AADD(LINBUFFCTRLZ,0)
                               
                               cTMP:=TEXTO[i]
                               TEXTO[i]:=TEXTO[i+1]
                               TEXTO[i+1]:=cTMP
                            end
                            XFILf++   // actualizo coordenadas
                            XFILi++
                            hb_keyPut(24)
                         end
                      else
                         TEXTO[pi]:=LLENATEXTO(s,len(s),0)
                           // CTRl-Z
                               AADD(BUFFER_CTRLZ,TEXTO[pi])
                               AADD(LINBUFFCTRLZ,pi)
                               AADD(BUFFER_CTRLZ,TEXTO[pi+1])
                               AADD(LINBUFFCTRLZ,pi+1)
                               AADD(BUFFER_CTRLZ,chr(8))
                               AADD(LINBUFFCTRLZ,0)
                         cTMP:=TEXTO[pi]
                         TEXTO[pi]:=TEXTO[pi+1]
                         TEXTO[pi+1]:=cTMP
                        // colorwin(py-1,1,py-1,len(s),48)
                         hb_keyPut(24)
                      end
                      SW_COMPILE:=.F.
                      SW_MODIFICADO:=.T.
                      SW_HAYBUFFER:=.T.
                      VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                   end
     elseif (c==308   .and. OSSYSTEM=="LINUX") // ALT - punto
        if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
                   if pi>1
                      if SWGETLINEDESP  // desplaza el bloque completo hacia arriba
                         if XFILi>1
                            TEXTO[pi]:=LLENATEXTO(s,len(s),0)  // lleno por precaución
                            for i:=XFILi to XFILf
                                                     // CTRl-Z
                               AADD(BUFFER_CTRLZ,TEXTO[i])
                               AADD(LINBUFFCTRLZ,i)
                               AADD(BUFFER_CTRLZ,TEXTO[i-1])
                               AADD(LINBUFFCTRLZ,i-1)
                               AADD(BUFFER_CTRLZ,chr(8))
                               AADD(LINBUFFCTRLZ,0)
                               
                               cTMP:=TEXTO[i]
                               TEXTO[i]:=TEXTO[i-1]
                               TEXTO[i-1]:=cTMP
                            end

                            XFILf--   // actualizo coordenadas
                            XFILi--
                            hb_keyPut(5)
                         end
                      else
                         TEXTO[pi]:=LLENATEXTO(s,len(s),0)
                           // CTRl-Z
                               AADD(BUFFER_CTRLZ,TEXTO[pi])
                               AADD(LINBUFFCTRLZ,pi)
                               AADD(BUFFER_CTRLZ,TEXTO[pi-1])
                               AADD(LINBUFFCTRLZ,pi-1)
                               AADD(BUFFER_CTRLZ,chr(8))
                               AADD(LINBUFFCTRLZ,0)
                         cTMP:=TEXTO[pi-1]
                         TEXTO[pi-1]:=TEXTO[pi]
                         TEXTO[pi]:=cTMP
                         hb_keyPut(5)
                      end
                      SW_COMPILE:=.F.
                      SW_MODIFICADO:=.T.
                      SW_HAYBUFFER:=.T.
                      VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                   end


     elseif c==270 .and. OSSYSTEM=="LINUX"   // ALT-BACKSPACE // quita una tabulación, o borra hacia atrás
        pushkey(8,cTABULA-(p%cTABULA)-1)
        
     elseif c==284 .and. OSSYSTEM=="LINUX"   // ALT - ENTER 

     elseif c==387 .and. OSSYSTEM=="LINUX"   // SHIFT - ALT - = (igual) 

     elseif c==309 .and. OSSYSTEM=="LINUX"   // SHIFT - ALT - /

     elseif c==27   // escape: Nada por ahora
     elseif c==378 .and. OSSYSTEM=="LINUX"   // ALT - 3   Nada por ahora
     elseif c==379 .and. OSSYSTEM=="LINUX"   // ALT - 4   Nada por ahora.
     
     elseif c==385 .and. OSSYSTEM=="LINUX"   // ALT - 0   Marca línea para trabajo sobre el mismo texto. Peligroso.
        if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
        if !SWEDITTEXT
           SWEDITTEXT:=.T.
           XFIL1EDIT:=pi; XFIL2EDIT:=pi  // inicio
        else
           XFIL2EDIT:=pi  // fin
           if XFIL1EDIT>XFIL2EDIT
              cTMP:=XFIL1EDIT
              XFIL1EDIT:=XFIL2EDIT
              XFIL2EDIT:=cTMP
           end
           exit
        end
        
     elseif c==271 .and. OSSYSTEM=="LINUX"   // SHIFT - TAB CTRL-PH  colorea
        if SWCOLORTEXTO==2
              SWCOLORTEXTO:=0
        else
              SWCOLORTEXTO:=2
        end
        exit
        
     elseif c==279 .and. OSSYSTEM=="LINUX"   // ALT - I CTRL-JJ
        SWf9:=.T.
        hb_keyPut(10)
        hb_keyPut(74)
 

     elseif c==277 .and. OSSYSTEM=="LINUX"   // ALT - Y   Repite el ultimo comando OPE
         nSetDecimal:=set(3,DEFROUND)
         hb_keyPut(15)
         hb_keyPut(80)
         set(3,nSetDecimal)
         
     elseif c==294 .and. OSSYSTEM=="LINUX"   // ALT - L   Llama a OPE
         hb_keyPut(12)
         hb_keyPut(79)  // O

     elseif c==280 .and. OSSYSTEM=="LINUX"   // ALT - O   carga archivo desde editor
         hb_keyPut(15)
         hb_keyPut(76) 
         


     elseif c==300 .and. OSSYSTEM=="LINUX"    // ALT-Z  elimina una línea.
       if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       SW_BUFFER:=.T.
       SW_COMPILE:=.F.
       SW_MODIFICADO:=.T.

       if yCALLBACK>0
          --yCALLBACK
       end
       // CTRl-Z
       AADD(BUFFER_CTRLZ,TEXTO[pi])
       AADD(LINBUFFCTRLZ,pi)
       // CTRl-Z
       AADD(BUFFER_CTRLZ,chr(5))
       AADD(LINBUFFCTRLZ,pi)

       // limpio la lista de busqueda, por si acaso.
       if len(LISTAFOUND)>0 
          RELEASE LISTAFOUND
          LISTAFOUND:={}
          SWMATCH:=.F.
          ptrLF:=0; totLF:=0
         // MSGBARRA("MATCHES BUFFER CLEANED. NOW YOU CAN USE CTRL-J",ARCHIVO,1)
         // BarraTitulo(ARCHIVO)
         // setpos(py,px)
       end
       exit

     elseif c==302   .and. OSSYSTEM=="LINUX" // ALT - C    Copia CTRL-KC
       hb_keyPut(11)
       hb_keyPut(67)

     elseif c==306   .and. OSSYSTEM=="LINUX" // ALT - M    Copia CTRL-KM
       hb_keyPut(11)
       hb_keyPut(77)
        
     elseif c==296   .and. OSSYSTEM=="LINUX" // ALT - '  shell de comandos:    
       hb_keyPut(15)
       hb_keyPut(83)

     elseif c==272  .and. OSSYSTEM=="LINUX" // ALT-Q   Quita las marcar ctrl-kq
       hb_keyPut(11)
       hb_keyPut(81)
       
     elseif c==288   .and. OSSYSTEM=="LINUX" // ALT - D    CTRL-KD
       hb_keyPut(11)
       hb_keyPut(68)

     elseif c==287   .and. OSSYSTEM=="LINUX" // ALT - S    CTRL-KS
       hb_keyPut(11)
       hb_keyPut(83)

    
     elseif c==286   .and. OSSYSTEM=="LINUX"  // ALT - A   ctrl-KA
       hb_keyPut(11)
       hb_keyPut(65)

     elseif c==301   .and. OSSYSTEM=="LINUX"  // ALT - X   ctrl-KX
       hb_keyPut(11)
       hb_keyPut(88)

     elseif c==291   .and. OSSYSTEM=="LINUX"  // ALT - H   ctrl-KH
       hb_keyPut(11)
       hb_keyPut(72)

     elseif c==274   .and. OSSYSTEM=="LINUX"  // ALT - E   ctrl-KE
       hb_keyPut(11)
       hb_keyPut(69)

     elseif c==304   .and. OSSYSTEM=="LINUX"  // ALT - B   ctrl-KB
       hb_keyPut(11)
       hb_keyPut(66)

     elseif c==281   .and. OSSYSTEM=="LINUX"  // ALT - P   ctrl-KP
       hb_keyPut(11)
       hb_keyPut(80)
       
     elseif c==278   .and. OSSYSTEM=="LINUX"  // ALT - U   ctrl-KU
       hb_keyPut(11)
       hb_keyPut(85)

     elseif c==292   .and. OSSYSTEM=="LINUX"  // ALT - J   ctrl-KJ
       hb_keyPut(11)
       hb_keyPut(74)

     elseif c==289   .and. OSSYSTEM=="LINUX"  // ALT - F   ctrl-KF
       hb_keyPut(11)
       hb_keyPut(70)
       
     elseif c==275   .and. OSSYSTEM=="LINUX"  // ALT - R   ctrl-KR
       hb_keyPut(11)
       hb_keyPut(82)

/*     elseif (c==194 .and. OSSYSTEM=="DARWIN")  // ALT-R   OBSOLETO
       c:=inkey(0)
       if c==174   // comenta desde la posición del cursor en adelante
          CLEN:=LEN(COMENTARIOS)
          if CLEN==1
             hb_keyPut(asc(COMENTARIOS))
          else
             hb_keyPut(asc(SUBSTR(COMENTARIOS,1,1)))
             hb_keyPut(asc(SUBSTR(COMENTARIOS,2,1)))
          end
          exit
       end

     elseif (c==277 .and. OSSYSTEM=="LINUX")  // ALT - Y
       CLEN:=LEN(COMENTARIOS)
       if CLEN==1
          hb_keyPut(asc(COMENTARIOS))
       else
          hb_keyPut(asc(SUBSTR(COMENTARIOS,1,1)))
          hb_keyPut(asc(SUBSTR(COMENTARIOS,2,1)))
       end
       exit
*/
     elseif c==276   .and. OSSYSTEM=="LINUX"  // ALT - T   ctrl-KT
       hb_keyPut(11)
       hb_keyPut(84)

     elseif c==293   .and. OSSYSTEM=="LINUX"  // ALT - K   ctrl-KK
       hb_keyPut(11)
       hb_keyPut(75)

     elseif c==290   .and. OSSYSTEM=="LINUX"  // ALT - G   ctrl-KG
       hb_keyPut(11)
       hb_keyPut(71)

     elseif c==303   .and. OSSYSTEM=="LINUX"  // ALT - V   ctrl-KV
       hb_keyPut(11)
       hb_keyPut(86)

     elseif c==273   .and. OSSYSTEM=="LINUX"  // ALT - W   ctrl-KW
       hb_keyPut(11)
       hb_keyPut(87)

     elseif c==226 .and. OSSYSTEM=="DARWIN"   // ALT-D,ALT-E,ALT-H,ALT-S,ALT-T,ALT-V,ALT-X
       c:=inkey(0,159)
       if c==136
          c:=inkey(0,159)
          if c==130   // ALT-D
             hb_keyPut(11)
             hb_keyPut(68)
          elseif c==171  // ALT-S
             hb_keyPut(11)
             hb_keyPut(83)
          elseif c==154   // ALT-V
             hb_keyPut(11)
             hb_keyPut(86)
          elseif c==145    // ALT-X
             hb_keyPut(11)
             hb_keyPut(88)
          end
       elseif c==130   // ALT-E
          c:=inkey(0,159)
          if c==172
             hb_keyPut(11)
             hb_keyPut(69)
          end
       elseif c==128   // ALT-T
          c:=inkey(0,159)
          if c==160
             hb_keyPut(11)
             hb_keyPut(84)
          elseif c==166   // ALT-punto
             if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
             end
             if pi>1
                if SWGETLINEDESP  // desplaza el bloque completo hacia arriba
                   if XFILi>1
                      TEXTO[pi]:=LLENATEXTO(s,len(s),0)  // lleno por precaución
                      for i:=XFILi to XFILf
                         cTMP:=TEXTO[i]
                         TEXTO[i]:=TEXTO[i-1]
                         TEXTO[i-1]:=cTMP
                      end
                      XFILf--   // actualizo coordenadas
                      XFILi--
                      hb_keyPut(5)
                   end
                else
                   TEXTO[pi]:=LLENATEXTO(s,len(s),0)
                   cTMP:=TEXTO[pi-1]
                   TEXTO[pi-1]:=TEXTO[pi]
                   TEXTO[pi]:=cTMP
                   hb_keyPut(5)
                end
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.T.
                SW_HAYBUFFER:=.T.
                VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             end
          elseif c==147   // ALT-guion
             if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
             end
             if pi<TOPE
                if SWGETLINEDESP  // desplaza el bloque completo hacia abajo
                   if XFILf<TOPE
                      TEXTO[pi]:=LLENATEXTO(s,len(s),0)  // lleno por precaución
                      for i:=XFILf to XFILi step -1
                         cTMP:=TEXTO[i]
                         TEXTO[i]:=TEXTO[i+1]
                         TEXTO[i+1]:=cTMP
                      end
                      XFILf++   // actualizo coordenadas
                      XFILi++
                      hb_keyPut(24)
                   end
                else
                   TEXTO[pi]:=LLENATEXTO(s,len(s),0)
                   cTMP:=TEXTO[pi]
                   TEXTO[pi]:=TEXTO[pi+1]
                   TEXTO[pi+1]:=cTMP
                   // colorwin(py-1,1,py-1,len(s),48)
                   hb_keyPut(24)
                end
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.T.
                SW_HAYBUFFER:=.T.
                VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             end
          elseif c==158   // ALT-coma
          
          end
       elseif c==132   // ALT-H
          c:=inkey(0,159)
          if c==162
             hb_keyPut(11)
             hb_keyPut(72)
          end
       end
     
     elseif c==198 .and. OSSYSTEM=="DARWIN"   // ALT-F
       c:=inkey(0,159)
       if c==146
          hb_keyPut(11)
          hb_keyPut(70)
       end
     
     elseif c==239 .and. OSSYSTEM=="DARWIN"   // ALT-G
       c:=inkey(0,159)
       if c==163
          c:=inkey(0,159)
          if c==191
             hb_keyPut(11)
             hb_keyPut(71)
          end
       end
     
     elseif c==207 .and. OSSYSTEM=="DARWIN"   // ALT-P
       c:=inkey(0,159)
       if c==128
          hb_keyPut(11)
          hb_keyPut(80)
       end
     
     elseif c==197 .and. OSSYSTEM=="DARWIN"   // ALT-Q
       c:=inkey(0,159)
       if c==147
          hb_keyPut(11)
          hb_keyPut(81)
       end
     
     elseif c==206 .and. OSSYSTEM=="DARWIN"   // ALT-Z
       if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       c:=inkey(0,159)
       if c==169
          SW_BUFFER:=.T.
          SW_COMPILE:=.F.
          SW_MODIFICADO:=.T.

          if yCALLBACK>0
             --yCALLBACK
          end 
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(5))
                      AADD(LINBUFFCTRLZ,pi)
          exit
       end
     
     elseif c==195 .and. OSSYSTEM=="DARWIN"   // ALT-A, ALT-B, ALT-O, ALT-W
       c:=inkey(0,159)
       if c==165    // ALT-A
          hb_keyPut(11)
          hb_keyPut(65)
       elseif c==159   // ALT-B
          hb_keyPut(11)
          hb_keyPut(66)
       elseif c==184   // ALT-O
          hb_keyPut(15)
          hb_keyPut(76)
       elseif c==166    // ALT-W
          hb_keyPut(11)
          hb_keyPut(87)
       end
     elseif c==194  .and. OSSYSTEM=="DARWIN"   // ALT-C,ALT-J,ALT-K,ALT-M,ALT-R
       c:=inkey(0,159)
       if c==169   // ALT-C
          hb_keyPut(11)
          hb_keyPut(67)
       elseif c==182  // ALT-J
          hb_keyPut(11)
          hb_keyPut(74)
       elseif c==167   // ALT-K
          hb_keyPut(11)
          hb_keyPut(75)
       elseif c==181   // ALT-M
          hb_keyPut(11)
          hb_keyPut(77)
       elseif c==174   // ALT-R
          hb_keyPut(11)
          hb_keyPut(82)
       elseif c==180    // ALT-apostrofe
          hb_keyPut(15)
          hb_keyPut(83)
       end

     elseif c==11   //CTRL-K   // borra una linea, pero la deja en el buffer
       // limpio la lista de busqueda, por si acaso.
       if TEXTOTIPO=="BINARY"
          cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
          loop
       end
       if len(LISTAFOUND)>0 
          RELEASE LISTAFOUND
          LISTAFOUND:={}
          SWMATCH:=.F.
          ptrLF:=0; totLF:=0
       end
       
       SETCOLOR(N2COLOR(cBARRA))
       @ TLINEA-4,0 CLEAR TO TLINEA,MAXCOL()
       
       setpos(TLINEA-4,1);outstd(substr(" CTRL-K... K|F3=Cut line | U|F4=Paste line | G=Del Segment | X=Del Lines  | I=Pos Ini line |  P=Indent line",1,SLINEA-3)+chr(175))
       setpos(TLINEA-3,1);outstd(substr(" EDIT      E=Del to EOL  | C=Copy Sqr Blk  | S=Sangria(+)  | D=Sangria(-) | N=AutoComplete | ^P=Indent Lines",1,SLINEA-3)+chr(175))
       setpos(TLINEA-2,1);outstd(substr("           B=Del to BOL  | M=Cut Sqr Blk   | Q=Cancel Mark | L=Del BUFFER | V=View BUFFER  |  H=Copy Blk & Clear",1,SLINEA-3)+chr(175))
       setpos(TLINEA-1,1);outstd(substr("           W=Move lines  | T=Copy Word     | R=Repl. Word  | F=Conv. Base | J=Swap lines   |  A=Copy Line & Clear",1,SLINEA-3)+chr(175))
       setpos(TLINEA,  1);outstd(substr("           Z=Reload file | 0=Calculator    | 1=Del to EOF  | 2=Del to BOF | 4=Mark lines   |  5=Parentization",1,SLINEA-3)+chr(175))
       
       c:=inkey(0)
       c:=asc(upper(chr(c)))
       VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       BarraTitulo(ARCHIVO)
       SETCOLOR(N2COLOR(cTEXTO))
       setpos(py,px)
       if c==71 //.or. c==7        // CTRL-KG
          if !SWCTRLKG
             SWCTRLKG:=.T.
             XFILi:=pi; XCOLi:=p
          else
             SWCTRLKG:=.F.
             XFILf:=pi; XCOLf:=p
             if XFILi>XFILf  // invierte ini y fin si estan al verre
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
                cTMP:=XCOLi
                XCOLi:=XCOLf
                XCOLf:=cTMP
                SWBORRA7:=.T.
                SWBORRA8:=.F.
             elseif XFILi==XFILf 
                if XCOLi<=XCOLf
                   SWBORRA7:=.F.
                   SWBORRA8:=.T.
                else
                   cTMP:=XCOLi; XCOLi:=XCOLf;XCOLf:=cTMP
                   SWBORRA7:=.T.
                   SWBORRA8:=.F.
                end
             else
                SWBORRA7:=.F.
                SWBORRA8:=.T.
             end
            // _ELIMINA_BUFFER(@BUFFER)
             CNT:=0
             ctBUFF:=len(BUFFER)
             if XFILi==XFILf
                 AADD(BUFFER,substr(TEXTO[XFILi],XCOLi,XCOLf-XCOLi+1)+chr(127))
                //// ctBUFF:=len(BUFFER[1])-1
                 ++ctBUFF
                 CNT:=CNT+len(BUFFER[ctBUFF])
                 ///TEXTO[XFILi]:=substr(TEXTO[XFILi],1,XCOLi-1) + substr(TEXTO[XFILi],XCOLf+1,len(TEXTO[XFILi))
             else
                 AADD(BUFFER,substr(TEXTO[XFILi],XCOLi,len(TEXTO[XFILi]))+chr(3) )
                 ++ctBUFF
                 CNT:=CNT+len(BUFFER[ctBUFF])

                 for i:=XFILi+1 to XFILf-1
                    AADD(BUFFER,substr(TEXTO[i],1,len(TEXTO[i]))+chr(3) )
                    ctBUFF++
                    CNT:=CNT+len(BUFFER[ctBUFF])
                 end
                 if XCOLf < len(TEXTO[XFILf])
                    AADD(BUFFER,substr(TEXTO[XFILf],1,XCOLf)+chr(127) )
                    ctBUFF++
                    CNT:=CNT+len(BUFFER[ctBUFF])
                 else
                    AADD(BUFFER,substr(TEXTO[XFILf],1,XCOLf)+chr(3) )
                    ctBUFF++
                    CNT:=CNT+len(BUFFER[ctBUFF])
                 end
             end
             if SWBORRA7 .and. !SWBORRA8
                pushkey(7,CNT-1) 
             else
                hb_keyPut(4)
                pushkey(8,CNT-1)
             end
             SW_HAYBUFFER:=.T.
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
            // XFIL1EDIT:=0;XFIL2EDIT:=0
            // BUFFER_CTRLZ:={}
            // LINBUFFCTRLZ:={}
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0
             exit
          end
        /*   */
       
       elseif c==48   // CTRL-K0  llama a calculadora
          
          RBUFFER:=_CALCULADORA(ARCHIVO)
          if len(RBUFFER)>0
             AADD(BUFFER,RBUFFER[1])  // añade último resultado al BUFFER
             SW_HAYBUFFER:=.T.
             RBUFFER:={}
          end
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          BarraTitulo(ARCHIVO)
          exit
          
       elseif c==74   //  CTRL-KJ intercambia lineas
          if !SWCTRLKJ
             SWCTRLKJ:=.T.
             XFILi:=pi
          else
             SWCTRLKJ:=.F.
             // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[XFILi])
                      AADD(LINBUFFCTRLZ,XFILi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[XFILf])
                      AADD(LINBUFFCTRLZ,XFILf)
                      AADD(BUFFER_CTRLZ,chr(10))
                      AADD(LINBUFFCTRLZ,XFILf)
             XFILf:=pi
             cTMP:=TEXTO[XFILf]
             TEXTO[XFILf]:=TEXTO[XFILi]
             TEXTO[XFILi]:=cTMP
             XFILi:=0; XFILf:=0
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             setpos(py,px)
             exit
          end

       elseif c==70    // CTRL-KF  convierte base numerica. Con menú.
          TEXTO[pi]:=LLENATEXTO(s,len(s),0)
             c:=""
             //wSTR:=""
             for i:=p to 1 step -1
                c:=substr(TEXTO[pi],i,1)
                if !isalpha(c) .and. !isdigit(c)
                   exit
                end
             end
             for j:=p to len(s)
                c:=substr(TEXTO[pi],j,1)
                if !isalpha(c) .and. !isdigit(c)
                   exit
                end
             end
          if i!=j
             STRING:=upper(substr(TEXTO[pi],i+1,j-(i+1)))
             EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
                 
             if EXT=="xu" .or. EXT=="def"
                cEXT:="xu"
             elseif EXT=="c" .or. EXT=="cpp" .or. c=="h"
                cEXT:="c"
             else
                cEXT:=""
             end
             c:=0
             MSGCONTROL(" CTRL-K+F... NUMBER TO CONVERT = "+STRING,;
                        " BASE        B=Dec to Bin | H=Dec to Hex | O=Dec to Octal",;
                        " CHANGE      1=Bin to Dec | 2=Hex to Dec | 3=Octal to Dec | 4=ASCII char")
             c:=inkey(0)
             c:=asc(upper(chr(c)))
             BarraTitulo(ARCHIVO)
             setpos(py,px)
             // debo ver la extensión del archivo para correcta conversion
             if c==66.or.c==72.or.c==79
                baseSW:=.T.
                for k:=1 to len(STRING)
                   xt:=substr(STRING,k,1)
                   if asc(xt)<48 .or. asc(xt)>57
                      baseSW:=.F.
                      exit
                   end
                end
                if baseSW
                   cPREFIX:=""; cSUFIX:=""
                   if c==66   // to binario
                      if cEXT=="xu"
                         cPREFIX:="0x"
                         cSUFIX:="b"
                      end
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+cPREFIX+DECTOBIN(val(STRING))+cSUFIX+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   elseif c==72   // hexa
                      if cEXT=="xu" .or. cEXT=="c"
                         cPREFIX:="0x"
                      end
                      if cEXT=="xu"
                         cSUFIX:="h"
                      end
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+cPREFIX+DECTOHEXA(val(STRING))+cSUFIX+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   elseif c==79   // octal
                      if cEXT=="xu"
                         cPREFIX:="0x"
                         cSUFIX:="o"
                      end
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+cPREFIX+DECTOOCTAL(val(STRING))+cSUFIX+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   end
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                   if p>len(TEXTO[pi])
                      p:=p-(p-len(TEXTO[pi])-1)
                      px:=px-(px-len(TEXTO[pi])-1)
                      if p<=0
                         p:=1; px:=1
                      end
                   end
                   setpos(py,px)
                   c:=0
                   exit
                end
             elseif c==49.or.c==50.or.c==51
                xt:=substr(STRING,1,2)
                   if xt=="0X"
                      STRING:=substr(STRING,3,len(STRING))
                   end
                   xt:=lower(substr(STRING,len(STRING),1))
                   if xt $ "bho" .and. cEXT=="xu"
                      STRING:=substr(STRING,1,len(STRING)-1)
                end
                if c==49   // bin to dec
                   baseSW:=.T.
                   for k:=1 to len(STRING)
                      xt:=substr(STRING,k,1)
                      if xt!="0" .and. xt!="1"
                         baseSW:=.F.
                         exit
                      end
                   end
                   if baseSW
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+hb_ntos(int(BINTODEC(STRING)))+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   end
                elseif c==50  // hexa to dec
                   baseSW:=.T.
                   for k:=1 to len(STRING)
                      xt:=substr(STRING,k,1)
                      if !(xt $ "0123456789ABCDEF")
                         baseSW:=.F.
                         exit
                      end
                   end
                   if baseSW
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+hb_ntos(int(HEXATODEC(STRING)))+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   end
                elseif c==51  // octal to dec
                   baseSW:=.T.
                   for k:=1 to len(STRING)
                      xt:=substr(STRING,k,1)
                      if !(xt $ "01234567")
                         baseSW:=.F.
                         exit
                      end
                   end
                   if baseSW
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+hb_ntos(int(OCTALTODEC(STRING)))+substr(TEXTO[pi],j,len(TEXTO[pi]))
                   end
                end
                if baseSW
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                   if p>len(TEXTO[pi])
                      p:=p-(p-len(TEXTO[pi])-1)
                      px:=px-(px-len(TEXTO[pi])-1)
                      if p<=0
                         p:=1; px:=1
                      end
                   end
                   setpos(py,px)
                   c:=0
                   exit
                end
             elseif c==52   // ascii char
                if ISTNUMBER(STRING)==1
                   if val(STRING)>=32 .and. val(STRING)<256 .and. val(STRING)!=127
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      SW_COMPILE:=.F.
                      SW_MODIFICADO:=.T.
                      TEXTO[pi]:=substr(TEXTO[pi],1,i)+chr(val(STRING))+substr(TEXTO[pi],j,len(TEXTO[pi]))
                      if len(TEXTO[pi])<p     //hb_utf8tostr(
                         p:=p-(p-len(TEXTO[pi])-1)
                         px:=px-(px-len(TEXTO[pi])-1)
                      end
                      setpos(py,px)
                      c:=0
                      exit
                   else
                      SETCOLOR(N2COLOR(cBARRA))
                      @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
                      setpos(TLINEA-1,int(SLINEA/2)-17);outstd("ASCII CODE INVALID FOR THIS EDITOR")
                      setpos(TLINEA  ,int(SLINEA/2)-15);outstd("(Press any key to continue...)")
                      inkey(0)
                      BarraTitulo(ARCHIVO)
             
                      SETCOLOR(N2COLOR(cTEXTO))
                      setpos(py,px)
                   end
                end
             end
          end
       elseif c==84     // CTRL-KT toma una palabra y la deja en el BUFFER.
          TEXTO[pi]:=LLENATEXTO(s,len(s),0)
             c:=""
             //wSTR:=""
             for i:=p to 1 step -1
                c:=substr(TEXTO[pi],i,1)
                if !isalpha(c) .and. !isdigit(c) .and. c!="_" .and. c!="."
                   exit
                end
             end
             for j:=p to len(s)
                c:=substr(TEXTO[pi],j,1)
                if !isalpha(c) .and. !isdigit(c).and. c!="_" .and. c!="."
                   exit
                end
             end
          if i!=j
             SW_HAYBUFFER:=.T.
            
            /// _ELIMINA_BUFFER(@BUFFER)
             //AADD(BUFFER,substr(TEXTO[pi],i+1,j-(i+1))+chr(127))
             BUFFERKT:=substr(TEXTO[pi],i+1,j-(i+1))
             c:=0
          else
             BUFFERKT:=""
          end
       elseif c==82     // CTRL-KR   reemplaza la palabra donde cursor por el contenido del BUFFER, que es otra palabra.
          
             // busco la palabra que contiene guión bajo
             TEXTO[pi]:=LLENATEXTO(s,len(s),0)
             c:=""
             //wSTR:=""
             for i:=p to 1 step -1
                c:=substr(TEXTO[pi],i,1)
                if !isalpha(c) .and. !isdigit(c) .and. c!="_" .and. c!="."
                   exit
                end
             end
             for j:=p to len(s)
                c:=substr(TEXTO[pi],j,1)
                if !isalpha(c) .and. !isdigit(c).and. c!="_" .and. c!="."
                   exit
                end
             end
             if i!=j
                // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                if len(BUFFERKT)>0
                   TEXTO[pi]:=substr(TEXTO[pi],1,i)+alltrim(BUFFERKT)+substr(TEXTO[pi],j,len(TEXTO[pi]))
                else
                   TEXTO[pi]:=substr(TEXTO[pi],1,i)+substr(TEXTO[pi],j,len(TEXTO[pi]))
                end
              //  s:=ASIGNALINEA(TEXTO[pi])
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.T.
                if p>len(TEXTO[pi])
                   p:=p-(p-len(TEXTO[pi])-1)
                   px:=px-(px-len(TEXTO[pi])-1)
                   if p<=0
                      p:=1; px:=1
                   end
                else
                   pushkey(19,p-i-1)
                end
                //setpos(py,px)
                c:=0
                exit
             end
             
       elseif c==69 //.or. c==5  // CTRL-KE    elimina desdela posicion del cursor hasta el final
          if p<len(s)
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             SW_HAYBUFFER:=.T.
            // SW_PASTE:=.T.
             SWCTRLKE:=.T.
             _CTRL_KE(@BUFFER,@s,p)
          end
          
       elseif c==66  // .or. c==2 // CTRL-KB    elimina desde la posicion del cursor hasta el principio
          if p>1
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             SW_HAYBUFFER:=.T.
            // SW_PASTE:=.T.
             _CTRL_KB(@BUFFER,@s,@p,@px)
             // borra
             SWCTRLKB:=.T.
             pushkey(8,p-1) //-1)

             //cini:=0
             //VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE)
             loop
             //setpos(py,px)
             
             //p:=1; px:=1
          end

       elseif c==80 // CTRL-KP   pone inicio de línea donde está el cursor, y baja una línea
          // busca principio de la líena
          if p>=1 .and. p<=len(s) .and. len(s)>1
             _CTRL_KP(@s,p)

          end
       elseif c==16   // ^K-^P  ( mantiene presionado CTRL y sigue con P
          if !SWCTRLKCTRLP
             SWCTRLKCTRLP:=.T.
             XFILi:=pi; XCOLi:=p
          else
             SWCTRLKCTRLP:=.F.
             XFILf:=pi; XCOLf:=XCOLi
             if XFILi>XFILf  // invierte ini y fin si estan al verre
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
             end
             for i:=XFILi to XFILf
                
                SWINICIOLIN:=.F.
                if XCOLi>=1 /*.and. XCOLi<=len(s)*/ .and. len(TEXTO[i])>1
                   for j:=1 to len(TEXTO[i])
                      s:=ASIGNALINEA(TEXTO[i])
                      if s[j]!=" "
                         SWINICIOLIN:=.T.
                         exit
                      end
                   end
                   if SWINICIOLIN
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[i])
                      AADD(LINBUFFCTRLZ,i)
                      if j<XCOLi
                         TEXTO[i]:=space(XCOLi-j)+TEXTO[i]
                         SW_COMPILE:=.F.
                         SW_MODIFICADO:=.T.
                      elseif j>XCOLi
                         TEXTO[i]:=substr(TEXTO[i],j-XCOLi+1,len(TEXTO[i]))
                         SW_COMPILE:=.F.
                         SW_MODIFICADO:=.T.
                      end
                   end
                end
             end
             s:=ASIGNALINEA(TEXTO[pi])
             setpos(py,px)
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0
             exit
          end
          
       elseif c==73  //.or. c==9   // CTRL-KI   ubica el inicio de la linea
          if len(s)>0
             _CTRL_KI(@s,p)
          end 
          
       elseif c==86 //.or. c==22    // CTRL-KV   // visualiza el contenido del buffer
          _CTRL_KV(@BUFFER,@TEXTO,TLINEA,lini,lfin,cini,TOPE,ARCHIVO,@PASTEFROM,@PASTETO,XFIL1EDIT,XFIL2EDIT,XFILi)
          setpos(py,px)

       elseif c==75 //.or. c==11  // CTRL-KK
        /*  if LEN(BUFFER)>0
             if chr(127) $ BUFFER[1] .or. chr(3) $ BUFFER[1]
                _ELIMINA_BUFFER(@BUFFER) // se prepara para recibir texto
             end
          end */
          SW_BUFFER:=.T.
          SW_HAYBUFFER:=.T.
          SW_COMPILE:=.F.
          SW_MODIFICADO:=.T.
          
          // CTRl-Z
          AADD(BUFFER_CTRLZ,TEXTO[pi])
          AADD(LINBUFFCTRLZ,pi)
          // CTRl-Z
          AADD(BUFFER_CTRLZ,chr(5))
          AADD(LINBUFFCTRLZ,pi)
          
          STRING:=LLENATEXTO(s,len(s),0)  // AQUI ESTA BIEN!!!
          AADD(BUFFER,STRING)
          if yCALLBACK>0
             --yCALLBACK
          end
/*          XFIL1EDIT:=0;XFIL2EDIT:=0
          BUFFER_CTRLZ:={}
          LINBUFFCTRLZ:={} */
          exit
       elseif c==76 //.or. c==12    // CTRL-KL   limpia el buffer
          SW_HAYBUFFER:=.F.
        
          _ELIMINA_BUFFER(@BUFFER)
          
          SETCOLOR(N2COLOR(cBARRA))
          @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
          setpos(TLINEA-1,int(SLINEA/2)-12);outstd("BUFFER HAS BEEN CLEANED")
          setpos(TLINEA  ,int(SLINEA/2)-15);outstd("(Press any key to continue...)")
          inkey(0)
          BarraTitulo(ARCHIVO)
             
          SETCOLOR(N2COLOR(cTEXTO))
          setpos(py,px)
             
       elseif c==78  //.or. c==14  // CTRL-KN   habilita/inhabilita opcion de autocompletar
          if !SW_CODESP
             SW_CODESP:=.T.
             SWINDENTA:=.F.
          else
             SW_CODESP:=.F.
             SWINDENTA:=.T.
          end
          exit

       elseif c==72       // CTRL-KH   igual que CTRL-KX, pero deja el espacio.
          if SWMARCABLOQUE
             SWMARCABLOQUE:=.F.
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             SWCOPIA:=.F.
             SWDELELIN:=.F.
          end
          IF !SWDELELIN
             XFILi:=pi
             SWDELELIN:=.T.
          ELSE
            /* if LEN(BUFFER)>0
                if chr(127) $ BUFFER[1]  .or. chr(3) $ BUFFER[1]
                   _ELIMINA_BUFFER(@BUFFER) // se prepara para recibir texto
                end
             end*/
             SW_HAYBUFFER:=.T.
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             
             SWDELELIN:=.F.
             XFILf:=pi
             if XFILi>XFILf
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
        //     else  // normal: debo mover el cursor hacia arriba:
        //        pushkey(5,XFILf-XFILi)
             end
        //     for i:=XFILi to XFILf
        //        hb_keyPut(11)
        //        hb_keyPut(75)
        //     end
        //     for i:=XFILi to XFILf
        //        hb_keyPut(13)
        //     end
        //     pushkey(5,XFILf-XFILi+1)  // debo volcer arriba
             for i:=XFILi to XFILf
                AADD(BUFFER,TEXTO[i])
                // CTRl-Z
                AADD(BUFFER_CTRLZ,TEXTO[i])
                AADD(LINBUFFCTRLZ,i)
                AADD(BUFFER_CTRLZ,chr(9))
                AADD(LINBUFFCTRLZ,i)
                TEXTO[i]:=""
             end
         //    if SWEDITTEXT
         //       if XFILf<=XFIL2EDIT
         /*          SWEDITTEXT:=.F.
                   XFIL1EDIT:=0; XFIL2EDIT:=0
                   BUFFER_CTRLZ:={}
                   LINBUFFCTRLZ:={} */
         //       end
         //    end
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             exit
          END
       
       elseif c==65   // CTRL-KA  copia una porcion de líneas.
          if SWMARCABLOQUE
             SWMARCABLOQUE:=.F.
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             SWCOPIA:=.F.
             SWDELELIN:=.F.
          end
          IF !SWDELELIN
             XFILi:=pi; XFILf:=pi
             SWDELELIN:=.T.
             SWCOPIA:=.T.
          ELSE
            /* if LEN(BUFFER)>0
                if chr(127) $ BUFFER[1]  .or. chr(3) $ BUFFER[1]
                   _ELIMINA_BUFFER(@BUFFER) // se prepara para recibir texto
                end
             end */
             SW_HAYBUFFER:=.T.
//             SW_COMPILE:=.F.
//             SW_MODIFICADO:=.T.
             SWDELELIN:=.F.
             SWCOPIA:=.F.
             XFILf:=pi
             if XFILi>XFILf
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
             end
             for i:=XFILi to XFILf
                STRING:=TEXTO[i]
                AADD(BUFFER,STRING)
             end
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             exit
          END
       
       elseif c==49   // CTRL-K1   borra desde la linea actual hasta el final.
          if pi<TOPE
             SW_HAYBUFFER:=.T.
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             for i:=pi to TOPE
                AADD(BUFFER,TEXTO[pi])
                // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(5))
                      AADD(LINBUFFCTRLZ,pi)
                ADEL(TEXTO,pi)
            end
            TOPE:=TOPE-(TOPE-pi+1)
            ASIZE(TEXTO,TOPE)
            if pi>TOPE
               if pi>1
                  p:=1; /*lini:=TOPE; */ pi:=pi-1; px:=1; py:=py-1; cini:=0
               else
                  if len(TEXTO)==0
                      AADD(TEXTO,"")
                      p:=1; TOPE:=1; pi:=1; px:=1; py:=1; cini:=0
                  end
               end
            end
        //    if SWEDITTEXT
        /*       SWEDITTEXT:=.F.
               XFIL1EDIT:=0; XFIL2EDIT:=0
               BUFFER_CTRLZ:={}
               LINBUFFCTRLZ:={} */
        //    end
            exit
          end
       
       elseif c==50    // CTRL-K2   borra desde la línea actual hasta el principio.
          if pi>1
             SW_HAYBUFFER:=.T.
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             for i:=1 to pi
                AADD(BUFFER,TEXTO[1])
                                // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[1])
                      AADD(LINBUFFCTRLZ,1)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(5))
                      AADD(LINBUFFCTRLZ,1)
                ADEL(TEXTO,1)
             end
             TOPE:=TOPE-pi
             ASIZE(TEXTO,TOPE)
             if len(TEXTO)==0
                AADD(TEXTO,"")
                p:=1; TOPE:=1; pi:=1; px:=1; py:=1; cini:=0; lini:=1
             else
                p:=1; pi:=1; px:=1; py:=1; cini:=0; lini:=1
             end
        //     if SWEDITTEXT
        /*        SWEDITTEXT:=.F.
                XFIL1EDIT:=0; XFIL2EDIT:=0
                BUFFER_CTRLZ:={}
                LINBUFFCTRLZ:={} */
        //     end
             exit
          end
       elseif c==52    // CTRL-K4   marca lineas para su edicion OPE
          if !SWEDITTEXT
             SWEDITTEXT:=.T.
             XFIL1EDIT:=pi; XFIL2EDIT:=pi  // inicio
          else
             XFIL2EDIT:=pi  // fin
             if XFIL1EDIT>XFIL2EDIT
                cTMP:=XFIL1EDIT
                XFIL1EDIT:=XFIL2EDIT
                XFIL2EDIT:=cTMP
             end
             exit
          end
       elseif c==53   // CTRL-K5 verifica parentizacion
          if XFIL1EDIT==0  // analiza todo
             XFIL1EDIT:=1; XFIL2EDIT:=TOPE
             cTMP:= BUSCAPARENTIZACION(@TEXTO,XFIL1EDIT, XFIL2EDIT,COMENTARIOS,iif(EXTENSION==3,"'",'"'))
             XFIL1EDIT:=0; XFIL2EDIT:=0
          else   // analiza porción
             SWPARE:=.F.
             if XFIL2EDIT==0
                XFIL2EDIT:=TOPE
                SWPARE:=.T.
             end
             cTMP:=BUSCAPARENTIZACION(@TEXTO,XFIL1EDIT, XFIL2EDIT,COMENTARIOS,iif(EXTENSION==3,"'",'"'))
             if SWPARE
                XFIL2EDIT:=0
             end
          end
          //? "LEN = ",len(cTMP); inkey(0)
          if !cTMP[1][1]
             cMessage := hb_utf8tostr("Símbolo '"+cTMP[1][2]+"' "+cTMP[1][5]+" en posición "+hb_ntos(cTMP[1][3])+;
                         ", "+hb_ntos(cTMP[1][4]))
             aOptions := { hb_utf8tostr("Ok") }
             nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
             hb_keyPut(10)
             hb_keyPut(74)
             cTMP[1][3]:=hb_ntos((cTMP[1][3]))
             
             for i:=1 to len(cTMP[1][3])
                c:=asc(substr(cTMP[1][3],i,1))
                if c!=3 .and. c!=127
                   hb_keyPut(c)
                else
                   exit
                end
             end
             hb_keyPut(13)  // el enter
           //  pushkey(4,cTMP[1][4])
            /* for i:=1 to cTMP[1][4]
                hb_keyPut(4)  // la flecha hacia la izquierda
             end*/
             SWCTRLJCTRKV:=.T.
          else
             cMessage := hb_utf8tostr("Todo bien!")
             aOptions := { hb_utf8tostr("Ok") }
             nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
          end

       elseif c==88  //.or. c==24  // CTRL-KX  borra una porcion de lineas de texto
          
          if SWMARCABLOQUE
             SWMARCABLOQUE:=.F.
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             SWCOPIA:=.F.
             SWDELELIN:=.F.
          end
          IF !SWDELELIN
             XFILi:=pi
             SWDELELIN:=.T.
          ELSE
           /*  if LEN(BUFFER)>0
                if chr(127) $ BUFFER[1] .or. chr(3) $ BUFFER[1]
                   _ELIMINA_BUFFER(@BUFFER) // se prepara para recibir texto
                end
             end */
             
             SW_HAYBUFFER:=.T.
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             SWDELELIN:=.F.
             XFILf:=pi
             cTMP:=0
             if XFILi>XFILf
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
         //    else  // normal: debo mover el cursor hacia arriba:
         //       pushkey(5,XFILf-XFILi)
             end
          /*   for i:=XFILi to XFILf
                hb_keyPut(11)
                hb_keyPut(75)
             end
*/             
             
             for i:=XFILi to XFILf
                AADD(BUFFER,TEXTO[XFILi])
                                // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[XFILi])
                      AADD(LINBUFFCTRLZ,XFILi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(5))
                      AADD(LINBUFFCTRLZ,XFILi)
                ADEL(TEXTO,XFILi)
             end
             TOPE:=TOPE-(XFILf-XFILi+1)
             ASIZE(TEXTO,TOPE)
             if TOPE==0   // borró todo
                AADD(TEXTO,"")
                TOPE:=len(TEXTO)
                p:=1; px:=1; py:=1; lini:=1; pi:=1; cini:=0
             else
                if XFILi>1
                   --XFILi
                end
                //? XFILi,TOPE,len(TEXTO),TEXTO[TOPE] ; inkey(0)
                if XFILi>=TOPE
                   if XFILi<=lini
                      p:=1; lini:=XFILi; pi:=XFILi; px:=1; py:=1;  cini:=0
                   else
                      p:=1; lini:=TOPE; pi:=TOPE; px:=1; py:=1; cini:=0
                   end
                else
                   if XFILi<=lini
                      lini:=XFILi
                      p:=1; pi:=lini; px:=1; py:=1; cini:=0
                   else
                      p:=1 ;lini:=XFILi; pi:=XFILi 
                      px:=1  ; py:=1 
                      cini:=0
                   end
                end 
//                if cTMP==0
//                   pushkey(5,XFILf-XFILi-1)
//                end
             end
         //    if SWEDITTEXT
         //       if XFILf<=XFIL2EDIT
        /*           SWEDITTEXT:=.F.
                   XFIL1EDIT:=0; XFIL2EDIT:=0
                   BUFFER_CTRLZ:={}
                   LINBUFFCTRLZ:={} */
         //       end
         //    end
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             exit 
          END

       elseif c==81 //.or. c==17  // CTRL-KQ  Elimina marcas de CRTL-KC, KM y KX
          XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
          SWMARCABLOQUE:=.F.; SWDELELIN:=.F.
          SWCOPIA:=.F.; SWCTRLKG:=.F.
          SWCTRLKCTRLD:=.F.;SWCTRLKCTRLS:=.F.;SWCTRLKCTRLP:=.F.
          SWGETLINEDESP:=.F.;SWMARCADESP:=.F.;SWCTRLKJ:=.F.
          SWEDITTEXT:=.F.;XFIL1EDIT:=0;XFIL2EDIT:=0
          //BUFFER_CTRLZ:={}
          //LINBUFFCTRLZ:={}
          exit

       elseif c==87   // CTRL-KW  marca bloque.
          if !SWMARCADESP
             XFILi:=pi
             SWMARCADESP:=.T.
             SWGETLINEDESP:=.T.
          else
             XFILf:=pi
             SWMARCADESP:=.F.
             // validaciones de posición
             if XFILi>XFILf
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
             end
             
          end
          
       
       elseif c==67 //.or. c==3   // CTRL-KC  copia una porción de texto sin cortarlo: linea o bloque
          if SWDELELIN
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             SWMARCABLOQUE:=.F.; SWDELELIN:=.F.
             SWCOPIA:=.F.
          end
          SWCOPIA:=.T.
          
          hb_keyPut(11)  // ^K
          hb_keyPut(77)  // ^KM
          
       elseif c==77 //.or. c==13  // CTRL-KM  marca inicio y fin, y deja en buffer: linea o bloque
          if len(s)>0
             if !SWMARCABLOQUE
                SWMARCABLOQUE:=.T.
             end
           //  SW_PASTE:=.T. 
             if !SWMARCA
                XFILi:=pi; XCOLi:=p

                if XCOLi>len(s)
                   XCOLi:=len(s)
                end
                SWMARCA:=.T.
             else
                SWMARCABLOQUE:=.F.
                XFILf:=pi; XCOLf:=p
                if XCOLf>len(s)
                   XCOLf:=len(s)
                end
                // VALIDACIONES:
                if XFILi==XFILf
                   SW_INVERT:=.F.
                   if XCOLi>xCOLf
                      cTMP:=XCOLi
                      XCOLi:=XCOLf
                      XCOLf:=cTMP
                      SW_INVERT:=.T.
                   end
                end
                //? XFILi,XFILf ; inkey(0)
                if XFILi>XFILf
                   cTMP:=XFILi
                   XFILi:=XFILf
                   XFILf:=cTMP
                   cTMP:=XCOLi
                   XCOLi:=XCOLf
                   XCOLf:=cTMP
                end
                
                if XCOLi>XCOLf
                   cTMP:=XCOLi
                   XCOLi:=XCOLf
                   XCOLf:=cTMP
                   
                end
                //? XFILi,XFILf ; inkey(0)
                //
                SWMARCA:=.F.
                ///CNTCAR:=0
                if XFILi<XFILf      // es un bloque
                   SW_HAYBUFFER:=.T.
               
               //    _ELIMINA_BUFFER(@BUFFER)
                   for i:=XFILi to XFILf
                      STRING:=""
                      tmp:=TEXTO[i]
                      /*for j:=XCOLi to XCOLf  //tFIN
                         STRING+=substr(tmp,j,1)
                         ++CNTCAR
                      end*/
                      STRING:=substr(tmp,XCOLi,XCOLf-XCOLi+1)
                      STRING+=chr(127)
                      AADD(BUFFER,STRING)
                      // borra el texto:
                      if !SWCOPIA
                         // CTRl-Z
                         AADD(BUFFER_CTRLZ,TEXTO[i])
                         AADD(LINBUFFCTRLZ,i)
                         TEXTO[i]:=substr(TEXTO[i],1,XCOLi-1)+substr(TEXTO[i],XCOLf+1,len(TEXTO[i]))
                      end
                   end 
                   if !SWCOPIA
                      SW_COMPILE:=.F.
                      SW_MODIFICADO:=.T.
                      if p>len(TEXTO[pi])
                         hb_keyPut(6)
                      end
                      // resetea, porque ya está en el buffer
                      XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
                      exit
                   end

                elseif XFILi==XFILf
                   SW_HAYBUFFER:=.T.
                //   _ELIMINA_BUFFER(@BUFFER)
                   // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[XFILi])
                      AADD(LINBUFFCTRLZ,XFILi)
                   STRING:=SUBSTR(TEXTO[XFILi],XCOLi,XCOLf-XCOLi+1)
                   STRING+=chr(127)
                   AADD(BUFFER,STRING)
                   // borra el texto:
                   if !SWCOPIA
                      if !SW_INVERT
                         if p<=len(TEXTO[XFILi])
                            hb_keyPut(4)
                         end
                         pushkey(8,LEN(STRING)-1)
                      else
                         pushkey(7,LEN(STRING)-1)
                      end
                   else
                      SWCOPIA:=.F.
                   end
                end
              //  XFIL1EDIT:=0;XFIL2EDIT:=0
              //  BUFFER_CTRLZ:={}
              //  LINBUFFCTRLZ:={}
                // resetea, porque ya está en el buffer
                XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
                if SWCOPIA
                   SWCOPIA:=.F.
                end
                exit
             end
          else
             MSGBARRA("COPY/CUT IS NOT VALID",ARCHIVO,1)
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
             SWCOPIA:=.F.
          end
          setpos(py,px)
       
       elseif c==68  //.or. c==4 // CTRL-KD  quito el número de caracteres copiado en la primera linea, y bajo
          if !SWCTRLKCTRLD
             if p>len(s)
                aadd(s," ")
             end
             if s[p]==" "
               // ? "ENTRO..."; inkey(0)
                SWINICIOLIN:=.F.
                for j:=p to len(s)
                   if s[j]!=" "
                       SWINICIOLIN:=.T.
                       exit
                   end
                end
                if SWINICIOLIN
                   SWCTRLKCTRLD:=.T.
                   XFILi:=pi; XCOLf:=j-1   //j-p+1 // fija fin
                   XCOLi:=p  // fija inicio
                end
             end
          else
             SWCTRLKCTRLD:=.F.
             XFILf:=pi  //; XCOLf:=XCOLi
             if XFILi>XFILf  // invierte ini y fin si estan al verre
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
             end
             for i:=XFILi to XFILf //step -1
                if XCOLf>=1 .and. XCOLf<len(TEXTO[i])
                   ///TEXTO[i]:=substr(TEXTO[i],XCOLf,len(TEXTO[i]))
                   // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[i])
                      AADD(LINBUFFCTRLZ,i)
                   TEXTO[i]:=substr(TEXTO[i],1,XCOLi-1)+substr(TEXTO[i],XCOLf+1,len(TEXTO[i]))
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                end
             end
             s:=ASIGNALINEA(TEXTO[pi])
             if p>LEN(TEXTO[pi]) .and. LEN(TEXTO[pi])>1
                p:=p-(p-LEN(TEXTO[pi]))
                px:=px-(px-LEN(TEXTO[pi]))-cini
             end
             setpos(py,px)
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0
             exit
          end
               
       elseif c==83  ///.or. c==19   // CTRL-KS  inserta la primer linea y baja una linea

          if !SWCTRLKCTRLS
             SWCTRLKCTRLS:=.T.
             XFILi:=pi ; XCOLi:=p
          else
             SWCTRLKCTRLS:=.F.
             XFILf:=pi; XCOLf:=XCOLi
             if XFILi>XFILf  // invierte ini y fin si estan al verre
                cTMP:=XFILi
                XFILi:=XFILf
                XFILf:=cTMP
             end
             for i:=XFILi to XFILf // step -1
                if XCOLi>=1 .and. len(TEXTO[i])>1
                   // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[i])
                      AADD(LINBUFFCTRLZ,i)
                   TEXTO[i]:=space(XCOLi-1)+TEXTO[i]
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                end
             end
             s:=ASIGNALINEA(TEXTO[pi])
             setpos(py,px)
             XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0
             exit
          end
       
       elseif c==90    // CTRL-KZ carga el archivo temporal
          cMessage := hb_utf8tostr("=== Esta opción cargará el archivo original ==="+_CR+;
                                "¡Está a punto de perder sus cambios!"+_CR+;
                                "¿Está seguro de querer continuar?")
          aOptions := { hb_utf8tostr("Sí"), hb_utf8tostr("No sé...") }
          nChoice := Alert( cMessage, aOptions ) //, N2COLOR(cMENU) )
          while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
          if nChoice==1
             // carga
             tARCHIVO:=TMPDIRECTORY+substr(ARCHIVO,rat(_fileSeparator,ARCHIVO)+1,len(ARCHIVO))+CHR(126)
             if file(tARCHIVO)
                TMPTEXTO:=XREADLINE(tARCHIVO,@TOPE)
                XLEN1:=len(TMPTEXTO)
                ASIZE(TEXTO,XLEN1)
                ACOPY(TMPTEXTO,TEXTO)
                for i:=1 to XLEN1
                   RELEASE TMPTEXTO[i]
                end
                RELEASE TMPTEXTO
                TOPE:=XLEN1
                p:=1; px:=1; py:=1; pi:=1; lini:=1;cini:=0
                VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                setpos(py,px)
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.T.

                SWEDITTEXT:=.F.
                XFIL1EDIT:=0; XFIL2EDIT:=0
                BUFFER_CTRLZ:={}
                LINBUFFCTRLZ:={}

                exit
             else
                cMessage := hb_utf8tostr("No puedo encontrar el archivo original"+_CR+;
                                "Quizás, no pudo ser guardado al momento de iniciar la edición"+_CR+;
                                "(Qué mala cuea, comparito!!)")
                aOptions := { hb_utf8tostr("Será...") }
                nChoice := Alert( cMessage, aOptions )
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE)
             end
          end
          
       elseif c==85  //.or. c==21    // CTRL-KU
          if SW_HAYBUFFER
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
           //  SW_PASTE:=.T.    // ya lo usé. queda disponible
             cLen:=len(BUFFER)
             if cLen>0
               /* if SWEDITTEXT
                   if pi<=XFIL2EDIT
                      SWEDITTEXT:=.F.
                      XFIL1EDIT:=0; XFIL2EDIT:=0
                      BUFFER_CTRLZ:={}
                      LINBUFFCTRLZ:={}
                   end
                end */
                if PASTEFROM==0
                   PASTEFROM:=1
                end
                if PASTETO==0
                   PASTETO:=cLen
                end
                if asc(substr(BUFFER[PASTEFROM],len(BUFFER[PASTEFROM]),1))==127
                   tPI:=pi
                   for j:=PASTEFROM to PASTETO
                      cLen:=len(BUFFER[j])
                      if p>len(s)
                         tLen:=len(s)
                         for i:=tLen to tLen+(p-tLen)-2
                            asize(s,len(s)+1)
                            ains(s,len(s))
                            s[len(s)]:=" "
                         end
                      end
                      asize(s,len(s)+cLen-1)
                      for i:=cLen-1 to 1 step -1
                         ains(s,p)
                         s[p]:=substr(BUFFER[j],i,1)
                      end
                      
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,TEXTO[pi])
                      AADD(LINBUFFCTRLZ,pi)
                      
                      TEXTO[pi]:=LLENATEXTO(s,len(s),0)
                      ++pi
                      if pi>TOPE
                         //asize(TEXTO,++TOPE)
                         aadd(TEXTO,"")
                         ++TOPE
                         RELEASE s
                         s:={" "}
      
                         // CTRl-Z
                         AADD(BUFFER_CTRLZ,chr(6))  // tope: indica que no hay linea para rescatar
                         AADD(LINBUFFCTRLZ,pi-1)
                         AADD(BUFFER_CTRLZ,chr(4))
                         AADD(LINBUFFCTRLZ,pi-1)
                      else
                         RELEASE s
                         // CTRl-Z
                       //  AADD(BUFFER_CTRLZ,TEXTO[pi])
                       //  AADD(LINBUFFCTRLZ,pi)
                         s:=ASIGNALINEA(TEXTO[pi])
 //                        ? len(s); inkey(0)
                         if len(s)==1
                            if empty(s[1])
                               s:={" "}
                            end
                         end
                      end
                   end
                   pi:=tPI
                elseif asc(substr(BUFFER[PASTEFROM],len(BUFFER[PASTEFROM]),1))==3  // pegado especial
                   // determinar el total de caracteres:
                   cnt:=0
                   for i:=PASTEFROM to PASTETO
                      cnt+=len(BUFFER[i])
                   end
                   
                   for i:=PASTEFROM to PASTETO
                      XLEN:=len(BUFFER[i])
                      for j:=1 to XLEN
                         c:=substr(BUFFER[i],j,1)
                         if asc(c)==3
                            hb_keyPut(13)
                         elseif asc(c)!=127
                            hb_keyPut(asc(c))
                         end
                      end
                   end
                   if !SW_CODESP
                      hb_keyPut(500)  // código de cambio de SW_CODESP
                      SW_CODESP:=.T.
                   end
                  // for i:=1 to len(STRING)
                  //    c:=substr(STRING,i,1)
                  //    hb_keyPut(asc(c))
                  // end
                else
                   TOPE:=len(TEXTO)+ (PASTETO-PASTEFROM+1)
                   asize(TEXTO,TOPE)
                   for i:=PASTETO to PASTEFROM step -1
                      ains(TEXTO,pi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(6))  // tope: indica que no hay linea para rescatar
                      AADD(LINBUFFCTRLZ,pi)
                      AADD(BUFFER_CTRLZ,chr(4))
                      AADD(LINBUFFCTRLZ,pi)
                      if chr(3) $ BUFFER[i] .or. chr(127) $ BUFFER[i]
                         TEXTO[pi]:=substr(BUFFER[i],1,len(BUFFER[i])-1)
                      else
                         TEXTO[pi]:=BUFFER[i]
                      end
                   end
                end
                if SWRECBUFFER .and. LEN(RBUFFER)>0
                   _ELIMINA_BUFFER(@BUFFER)
                   BUFFER:=ARRAY(LEN(RBUFFER))
                   ACOPY(RBUFFER,BUFFER)
                   _ELIMINA_BUFFER(@RBUFFER)
                   SWRECBUFFER:=.F.
                end
                PASTEFROM:=0
                PASTETO:=0
                exit
             end
          end
       else   // presiono otra cosa: bajo banderas y dejo valores en cero, si uso ^KC o ^KM
          XFILi:=0; XFILf:=0; XCOLi:=0; XCOLf:=0; SWMARCA:=.F.
          SWCOPIA:=.F.
       end
          
     elseif c==25   //CTRL-Y   // Añade comentarios en multiples lineas
       if len(s)>0
          CLEN:=LEN(COMENTARIOS)
          if CLEN==1
             if s[1]!=COMENTARIOS
                if p>1
                   pushkey(19,p-1)
                end
                hb_keyPut(asc(COMENTARIOS))
                hb_keyPut(24)
                exit
             else
                if p>1
                   pushkey(19,p-1)   // se va al principio. No puedo hacer key(1), porque limpio el head.
                end
                pushkey(7,CLEN) // borra LEN veces 
                hb_keyPut(24)
                exit
             end
          elseif CLEN==2
             if len(s)==1  // se cae al preguntar s[1]+s[2]
                hb_keyPut(asc(SUBSTR(COMENTARIOS,1,1)))
                hb_keyPut(asc(SUBSTR(COMENTARIOS,2,1)))
                hb_keyPut(24)
                exit
             elseif s[1]+s[2]!=COMENTARIOS
                if p>1
                   pushkey(19,p-1)
                end
                hb_keyPut(asc(SUBSTR(COMENTARIOS,1,1)))
                hb_keyPut(asc(SUBSTR(COMENTARIOS,2,1)))
                hb_keyPut(24)
                exit
             else
                if p>1
                   pushkey(19,p-1)   // se va al principio. No puedo hacer key(1), porque limpio el head.
                end
                pushkey(7,CLEN) // borra LEN veces 
                hb_keyPut(24)
                exit
             end
          end
       else
          CLEN:=LEN(COMENTARIOS)
          if CLEN==1
             asize(s,len(s)+1)
             ains(s,1)
             s[1]:=COMENTARIOS
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             hb_keyPut(24)
             exit
          else
             asize(s,len(s)+2)
             ains(s,1);ains(s,1)
             s[1]:=SUBSTR(COMENTARIOS,1,1); s[2]:=SUBSTR(COMENTARIOS,2,1)
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
             hb_keyPut(24)
             exit
          end
       end
  
     elseif c==26   // CTRL-Z para lineas marcadas
//         if SWEDITTEXT
            XLEN:=LEN(BUFFER_CTRLZ)
            if XLEN>0
               // limpio la lista de busqueda, por si acaso.
               if len(LISTAFOUND)>0 
                  RELEASE LISTAFOUND
                  LISTAFOUND:={}
                  SWMATCH:=.F.
                  ptrLF:=0; totLF:=0
               end
          
               if BUFFER_CTRLZ[XLEN]==chr(4)
                  //pi:=LINBUFFCTRLZ[XLEN]
                  adel(TEXTO,LINBUFFCTRLZ[XLEN])
                  ASIZE(TEXTO,--TOPE)
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  if BUFFER_CTRLZ[XLEN]!=chr(6)
                     TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  end
                  pi:=LINBUFFCTRLZ[XLEN]
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
//                  SW_BUFFER:=.T.
               elseif BUFFER_CTRLZ[XLEN]==chr(5)
                  pi:=LINBUFFCTRLZ[XLEN]
                  asize(TEXTO,++TOPE)
                  ains(TEXTO,pi)
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  if BUFFER_CTRLZ[XLEN]==chr(7)
                     ADEL(BUFFER_CTRLZ,XLEN)
                     ADEL(LINBUFFCTRLZ,XLEN)
                     --XLEN
                     ASIZE(BUFFER_CTRLZ,XLEN)
                     ASIZE(LINBUFFCTRLZ,XLEN)

                     TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                     ADEL(BUFFER_CTRLZ,XLEN)
                     ADEL(LINBUFFCTRLZ,XLEN)
                     --XLEN
                     ASIZE(BUFFER_CTRLZ,XLEN)
                     ASIZE(LINBUFFCTRLZ,XLEN)

                     TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  else

                     TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  end
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                  if len(BUFFER_CTRLZ)>1
                     if BUFFER_CTRLZ[XLEN-1]==chr(5)
                        hb_keyPut(26)
                     end
                  end

               elseif BUFFER_CTRLZ[XLEN]==chr(10)
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  pi:=LINBUFFCTRLZ[XLEN]
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0

               elseif BUFFER_CTRLZ[XLEN]==chr(8)
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  pi:=LINBUFFCTRLZ[XLEN]
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                  if len(BUFFER_CTRLZ)>1
                     if BUFFER_CTRLZ[XLEN-1]==chr(8)
                        hb_keyPut(26)
                     end
                  end
               elseif  BUFFER_CTRLZ[XLEN]==chr(9)  // ctrl-kh
                  ADEL(BUFFER_CTRLZ,XLEN)
                  ADEL(LINBUFFCTRLZ,XLEN)
                  --XLEN
                  ASIZE(BUFFER_CTRLZ,XLEN)
                  ASIZE(LINBUFFCTRLZ,XLEN)

                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  pi:=LINBUFFCTRLZ[XLEN]
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
                  if len(BUFFER_CTRLZ)>1
                     if BUFFER_CTRLZ[XLEN-1]==chr(9)
                        hb_keyPut(26)
                     end
                  end
                  
               else
                  TEXTO[LINBUFFCTRLZ[XLEN]]:=BUFFER_CTRLZ[XLEN]
                  pi:=LINBUFFCTRLZ[XLEN]
                  if pi-5>0
                     lini:=pi-5
                     py:=6
                  else
                     lini:=pi; py:=1
                  end
                  p:=1+nOFFSET; px:=1+nOFFSET; cini:=0
               end
               ADEL(BUFFER_CTRLZ,XLEN)
               ADEL(LINBUFFCTRLZ,XLEN)
               --XLEN
               ASIZE(BUFFER_CTRLZ,XLEN)
               ASIZE(LINBUFFCTRLZ,XLEN)
               if len(BUFFER_CTRLZ)>0
                  if LINBUFFCTRLZ[XLEN]==pi .and. len(BUFFER_CTRLZ[XLEN])==len(TEXTO[LINBUFFCTRLZ[XLEN]])-1
                     hb_keyPut(26)
                  end
               end
               exit
            end
         
//         end
     
     elseif c==21   // CTRL-U   Carga un nuevo archivo de la lista de edicion
          LENMETA:=LEN(METADATA)

          IF LENMETA>0
             MENUMATCH:=ARRAY(LENMETA)
             SELECTMATCH:=ARRAY(LENMETA)
          //   nLENOPTION:=0
             EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
                 
           /*  if EXT=="xu" .or. EXT=="def"
                //? METADATA[i],ARCHIVO 
                //inkey(0)
                tARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
             else
                tARCHIVO:=ARCHIVO
             end */
             
             XLEN:=1
             for i:=1 to LENMETA
                 STRING:=substr(METADATA[i],rat("/",METADATA[i])+1,len(METADATA[i]))
                 PATH:=substr(METADATA[i],1,rat("/",METADATA[i])-1)
                 if len(PATH)>SLINEA-(int(SLINEA/2)+10)
                    //PATH:=".."+right(PATH,SLINEA-int(SLINEA/2))
                    PATH:=".."+substr(PATH,rat(_fileSeparator,PATH)-20,len(PATH))
                 end
                 SELECTMATCH[i]:=.T.

                 if METADATA[i]==ARCHIVO   //tARCHIVO
                    SELECTMATCH[i]:=.F. // ya esta en edicion: no es elegible
                    STRING:=hb_ntos((XLEN))+padl(STRING,40)+" (editing) ("+PATH+")"
                 else
                    if VERIFICAMODIFICADO(STRING,cMETADATA)
                       STRING:=hb_ntos((XLEN))+padl(STRING,40)+" (mod)     ("+PATH+")"
                    else
                       STRING:=hb_ntos((XLEN))+padl(STRING,40)+"           ("+PATH+")"
                    end
                 end
                 ++XLEN
              /*   IF len(STRING)>nLENOPTION
                    nLENOPTION:=len(STRING)
                 END*/
                 MENUMATCH[i]:=STRING
             end
             XLEN:=0
             XCLEAR:=LEN(MENUMATCH)
             if XCLEAR>int(TLINEA/2)
                XCLEAR:=int(TLINEA/2)
             end
          //   nLENOPTION:=int(nLENOPTION/2)
             SETCOLOR(N2COLOR(cBARRA))
           //  @ TLINEA-(int(TLINEA/2)),0 CLEAR TO TLINEA-3,SLINEA
             @ 1,2 CLEAR TO XCLEAR+1,SLINEA-2
             
             //setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-8); outstd(" Select a file ")
             MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,2)
             SETCOLOR(N2COLOR(6))
            // pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,int(SLINEA/2)-16,;
            //                 TLINEA-3,int(SLINEA/2)+16,MENUMATCH,SELECTMATCH)
             
             //setcolor( 'GB+/B,GR+/R,,,W/N' )
             setcolor( 'GR+/N,N/GR+,,,W/N' )
             
           //  pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,1,;
           //                  TLINEA-3,SLINEA-1,MENUMATCH,SELECTMATCH,"UDFAchoice")
             pELIGE:=ACHOICE(1,3,XCLEAR,SLINEA-3,MENUMATCH,SELECTMATCH,"UDFAchoice")
                         
             while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 
                  
             SETCOLOR(N2COLOR(cTEXTO))
             VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             BarraTitulo(ARCHIVO)
             
             if pELIGE>0 .and. SWELIMINATAB   // elimina una pestaña
                //AADD(CORDEL,{_file,SIZE,TEXTO})
                //? LEN(CORDEL),pELIGE,METADATA[pELIGE] ; inkey(0)
                for i:=1 to len(CORDEL)
                  // ? CORDEL[i][1],METADATA[pELIGE] ; inkey(0)
                   if CORDEL[i][1]==METADATA[pELIGE]
                      for j:=1 to len(CORDEL[i][3])
                         RELEASE CORDEL[i][3][j]
                      end
                      RELEASE CORDEL[i][3]
                      inkey(0.1)
                      CORDEL[i][3]:=nil
                      CORDEL[i][2]:=0
                      CORDEL[i][1]:="*"
                      // release de metadata
                      adel(METADATA,pELIGE)
                      asize(METADATA,len(METADATA)-1)
                      
                      RELEASE METADATA[pELIGE]  //AADD(METADATA,tARCHIVO)
                      asize(cMETADATA[pELIGE],0)
                      adel(cMETADATA,pELIGE)
                      asize(cMETADATA,len(cMETADATA)-1)
                      
                      ///AADD(cMETADATA,{STRING,pi,p,px,py,lini,lfin,cini,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,0})
                      SWELIMINATAB:=.F.
                      exit
                   end
                end
                if SWELIMINATAB  // se activó, pero no econtró el archivo en el cordel.
                   // release de metadata
                   adel(METADATA,pELIGE)
                   asize(METADATA,len(METADATA)-1)
                      
                   RELEASE METADATA[pELIGE]  //AADD(METADATA,tARCHIVO)
                   asize(cMETADATA[pELIGE],0)
                   adel(cMETADATA,pELIGE)
                   asize(cMETADATA,len(cMETADATA)-1)
                      
                   ///AADD(cMETADATA,{STRING,pi,p,px,py,lini,lfin,cini,.F.,.F.,COMPILADOR,EJECUTOR,DESCRIPCION,0})
                   SWELIMINATAB:=.F.
                   hb_gcAll()  // activa garbage.
                end
               // setpos(py,px)
                hb_keyPut(21)  // vuelve a abrir el menu ^U
                loop
             end
             
             RELEASE MENUMATCH
             STRING:=""
             
             IF pELIGE>0
                STRING:=METADATA[pELIGE]
              //? "ELIJO = ",STRING; inkey(0)
                EXT:=substr(STRING,rat(".",STRING)+1,len(STRING))
                if EXT=="xu" .or. EXT=="def"
                    ///RET:=substr(STRING,rat("/",STRING)+1,len(STRING))
                    RET:=STRING
                    SWLENGUAJE:=1
                else
                    if EXT=="c" .or. EXT=="cpp" .or. EXT=="h" .or. EXT=="prg" .or. EXT=="ch"
                       SWLENGUAJE:=2
                    else
                       SWLENGUAJE:=3
                    end
                    RET:=STRING
                end
                if EXT=="tex"
                   EXTENSION:=2
                elseif EXT=="m"
                   EXTENSION:=3
                else
                   EXTENSION:=1
                end
                   // si el archivo en edicion existe en la lista, no lo incluyo, pero altero su meta
                SWEXISTE:=.F.
               /* EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
                if EXT=="xu" .or. EXT=="def"
                   tARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                else
                   tARCHIVO:=ARCHIVO
                end*/
                for i:=1 to len(METADATA)
                     // ? METADATA[i],"----",ARCHIVO; inkey(0)
                      if METADATA[i]==ARCHIVO    ///tARCHIVO
                         SWEXISTE:=.T.  // no lo cargo
                        //  ? "EXISTE. SALE!  RET=",RET; inkey(0)
                         exit
                      end
                end
                lfin:=TOPE
                if !SWEXISTE   // no existe en la lista: lo añado
                     // ? "AÑADE PARA...",ARCHIVO;inkey(0)
                      AADD(METADATA,ARCHIVO)   ////tARCHIVO)
                      STRING:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                      AADD(cMETADATA,{STRING,pi,p,px,py,lini,lfin,cini,SW_COMPILE,SW_MODIFICADO,COMPILADOR,EJECUTOR,DESCRIPCION,;
                                      ESEJECUTABLE,COMENTARIOS,PARAMETROS,TEXTOTIPO,LENTEXTOTIPO})
                else  // esta en la lista, actualizo su metadata
                      cMETADATA[i][2]:=pi
                      cMETADATA[i][3]:=p
                      cMETADATA[i][4]:=px
                      cMETADATA[i][5]:=py
                      cMETADATA[i][6]:=lini
                      cMETADATA[i][7]:=lfin
                      cMETADATA[i][8]:=cini
                      cMETADATA[i][9]:=SW_COMPILE
                      cMETADATA[i][10]:=SW_MODIFICADO
                      cMETADATA[i][11]:=COMPILADOR
                      cMETADATA[i][12]:=EJECUTOR
                      cMETADATA[i][13]:=DESCRIPCION
                      cMETADATA[i][14]:=ESEJECUTABLE
                      cMETADATA[i][15]:=COMENTARIOS
                      cMETADATA[i][16]:=PARAMETROS
                      cMETADATA[i][17]:=TEXTOTIPO
                      cMETADATA[i][18]:=LENTEXTOTIPO
                end
              //  ? "CTRL-U. CARGO=",RET; inkey(0)
                SW_CTRLOF:=.T.
                hb_keyPut(17)   // sale.
                loop
             END
          END
          setpos(py,px)
          loop

     elseif c==28  // F1 ayuda de XUED directa
       hb_keyPut(15)
       hb_keyPut(79)

     elseif c==-1  // F2 comando ^OF
       hb_keyPut(15)
       hb_keyPut(70)

     elseif c==15    // CTRL-O   HELP
       if TEXTOTIPO=="BINARY"
       MSGCONTROL(" CTRL-O... O=Help Laica | F=Open File | A=Details",;
     hb_utf8tostr(" HELP      X=Help XU    | N=New file  | C=Configuration"),;
                  " & FILE   F2=Open File")
       else
       MSGCONTROL(" CTRL-O... O=Help Laica    |  F=Open File |            | P=Repeat last OPE command",;
     hb_utf8tostr(" HELP      X=Help XU       |  N=New file  | A=Details  | S=Execute Shell Command"),;
                  " & FILE    C=Configuration | F2=Open File |            | L=Search & Load Program from current directory")
       end
       c:=inkey(0)
       c:=asc(upper(chr(c)))
       BarraTitulo(ARCHIVO)
       if TEXTOTIPO=="BINARY"
          if c!=65 .and. c!=79 .and. c!=70 .and. c!=78 .and. c!=88 .and. c!=27
             cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       end
       setpos(py,px)
       while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
       if c==76   // CTRL-OL busca la palabra como si fuese un archivo.
          STRING:=LLENATEXTO(s,len(s),0)
             c:=""
             //wSTR:=""
             for i:=p to 1 step -1
                c:=substr(STRING,i,1)
                if !isalpha(c) .and. !isdigit(c) .and. c!="_" .and. c!="."
                   exit
                end
             end
             for j:=p to len(s)
                c:=substr(STRING,j,1)
                if !isalpha(c) .and. !isdigit(c).and. c!="_" .and. c!="."
                   exit
                end
             end
          if i!=j
             
             RET:=substr(STRING,i+1,j-(i+1))
             if !("." $ RET)
                RET += substr(ARCHIVO,rat(".",ARCHIVO),len(ARCHIVO))
             end
            /// EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
           /// ? RET; inkey(0)
             if FILE(RET)
                SWLOADRAPIDO:=.T.
                hb_keyPut(15)
                hb_keyPut(70)
                //for i:=1 to len(RET)
                //   hb_keyPut(asc(substr(RET,i,1)))
               // end
             else
                SWLOADRAPIDO:=.F.
                RET:=""
                cMessage := hb_utf8tostr("El archivo solicitado no pudo ser encontrado")
                aOptions := { hb_utf8tostr("Será...") }
                nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE)
             end
          end
          loop
       
       elseif c==67   // CTRL-OC  edita laica.compiler.
          
          RET:=PATH_XU+_fileSeparator+"laica.compiler"
          SWLOADRAPIDO:=.T.
          SWCTRLON:=.T.
          hb_keyPut(15)
          hb_keyPut(70)
          loop

       elseif c==65   // CTRL-OA   detalles del acerca de
          cMessage := hb_utf8tostr("                    LAICA  v.1.0                   "+_CR+;
                      "                                                   "+_CR+;
                      "Actual Compiler: "+_CR+DESCRIPCION+_CR+;
                      "                                                   "+_CR+;
                      "System: "+OS()+_CR+;
                      "Shell: "+getenv("SHELL")+_CR+;
                      "   _____________________________________________   "+_CR+;
                      "   Editor de textos para XU & sus primos mayores   "+_CR+;
                      "   destinado a la consola Linux Debian based.      "+_CR+;
                      "       (Compilado en Harbour 3.0 / gcc 7.3.0)      "+_CR+;
                      "                                                   "+_CR+;
                      "                ~ Nov. 2018 - 2019 ~               "+_CR+;
                      "                                                   "+_CR+;
                      "        = Este programa es de uso gratuito =       "+_CR+;
                      "   Se entrega 'As Is', con la única garantía que   "+_CR+;
                      "   no voy a lucrar indebidamente con su uso.       "+_CR+;
                      "                                                   "+_CR+;
                      "   Bugs y aportaciones, comunicarse con el autor   "+_CR+;
                      "   al correo: daniel.stuardo@gmail.com             ")

          aOptions := { hb_utf8tostr("Volver") }
          nChoice := Alert( cMessage, aOptions, N2COLOR(112) )
          c:=0
          while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
          loop
       elseif c==83   // ejecuta un comando del shell CTRL-OS
           SETCOLOR(N2COLOR(cBARRA))
           @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
           @ TLINEA-9,0 CLEAR TO TLINEA-3,SLINEA

           setpos(TLINEA-9,2); outstd("COMMAND? ")
           MSGBARRA("^W=EXEC ESC=CANCEL ^P=PASTE | *=LIST COMM !=LOOK '<str>=EDIT $<str>=INSERT @<str>=REPLACE EDITION",ARCHIVO,0)
           //SETCOLOR(N2COLOR(6))
           setcolor( 'GR+/N,N/GR+,,,W/N' )
           
           readinsert(.T.)
           COMANDO:=hb_utf8tostr(MEMOEDIT(COMANDO,TLINEA-8,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF",1024))
           readinsert(.F.)

          
          
/*          SETCOLOR(N2COLOR(cBARRA))
          @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
          setpos(TLINEA-2,2);outstd(" COMMAND? ")
          MSGINPUT("^KU=PASTE, *=LIST COMMANDS OUTPUT !=LOOK '<str>=EDIT $<str>=INSERT @<str>=REPLACE EDITION")

          COMANDO:=INPUTLINE(COMANDO,SLINEA-12,TLINEA-2,12,"s")
*/
          COMANDO:=alltrim(COMANDO)
          COMANDO:=STRTRAN(COMANDO,_CR," ")
          if "$" $ COMANDO
             COMANDO:=strtran(COMANDO,"$",ARCHIVO)
          end
          
          if COMANDO=="*"
             if len(COMMANDS)>0
                SETCOLOR(N2COLOR(cBARRA))
                @ 10,10 CLEAR TO TLINEA-3,SLINEA-10

                setpos(10,int(SLINEA/2)-10); outstd("List System Command")
   
                MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                //setcolor("B/GR+,I/GR+")
                //SETCOLOR(N2COLOR(6))
                setcolor( 'GR+/N,N/GR+,,,W/N' )
                pELIGE:=ACHOICE(11,11,TLINEA-3,SLINEA-11,COMMANDS, .T.)
                
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE) 
              
                if pELIGE>0
                   COMANDO:=COMMANDS[pELIGE]
                   hb_keyPut(15)
                   hb_keyPut(83)
                end
             end
          elseif COMANDO=="!"
             if len(OUTPUTCOMM)>0
                SHOWOUTPUT()
             end
          else   // ejecuta el comando
             if len(COMANDO)>0
                // verificar si quiere que lo edite o solo lo muestre ('): ej: 'ls -l
                SWEDITACOM:=.F.
                SWINSCODIGO:=.F.
                SWREPLACECODIGO:=.F.
                if substr(COMANDO,1,1)=="'"  // edita la salida en un archivo temporal
                   SWEDITACOM:=.T.
                   COMANDO:=substr(COMANDO,2,LEN(COMANDO))
                elseif substr(COMANDO,1,1)=="^"  // inserta la salida en edicion actual
                   SWINSCODIGO:=.T.
                   COMANDO:=substr(COMANDO,2,LEN(COMANDO))
                elseif substr(COMANDO,1,1)=="@"  // reemplaza la edición actual por la salida.
                   SWREPLACECODIGO:=.T.
                   COMANDO:=substr(COMANDO,2,LEN(COMANDO))
                end 
                SWCOMMAND:=.F.
                for i:=1 to len(COMMANDS)
                   if COMANDO==COMMANDS[i]
                      SWCOMMAND:=.T.
                      exit
                   end
                end
                if !SWCOMMAND
                   AADD(COMMANDS,COMANDO)
                end
                OUTPUTCOMM:=FUNFSHELL(COMANDO,4)
                if OUTPUTCOMM=="<error>"
                   SWEDITACOM:=.F.
                   SWINSCODIGO:=.F.
                   SWREPLACECODIGO:=.F.
                end
                ///OUTPUTCOMM:=hb_utf8tostr(OUTPUTCOMM)
                IF SWEDITACOM
                   
                   //SALE Y EDITA ARCHIVO TEMPORAL
                   //SW_CTRLOF:=.T.
                   RET:=PATH_TEMP+_fileSeparator+"output_"+hb_ntos(int(hb_random(1000000)))+".temp"
                   //tmp:=StrFile(OUTPUTCOMM, RET)
                   //tmp:=MEMOWRIT(RET,hb_strtoutf8(OUTPUTCOMM))
                   xfp:=fcreate(RET,0)
                   if ferror()==0
                      fwrite(xfp,hb_strtoutf8(OUTPUTCOMM))
                      fclose(xfp)
                   else
                      cMessage := hb_utf8tostr("No tiene permiso para crear un archivo en directorio temporal")
                      aOptions := { hb_utf8tostr("Será") }
                      nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                      while inkey(,159)!=0 ; end
                      MRESTSTATE(MOUSE)
                      exit
                   end
                   SWLOADRAPIDO:=.T.
                   SWCTRLON:=.T.
                   hb_keyPut(15)
                   hb_keyPut(70)
                   loop
                   //hb_keyPut(17)  // CTRL-Q sin preguntar por grabar. Solo graba
                   //loop
                ELSEIF SWINSCODIGO
                   
                   // INSERTA LA SALIDA EN EDICION TEMPORAL
                   cLen:=mlcount(OUTPUTCOMM,1200)
                   TOPE:=len(TEXTO)+cLen
                   asize(TEXTO,TOPE)
                   for i:=cLen to 1 step -1
                      ains(TEXTO,pi)
                      // CTRl-Z
                      AADD(BUFFER_CTRLZ,chr(6))  // tope: indica que no hay linea para rescatar
                      AADD(LINBUFFCTRLZ,pi)
                      AADD(BUFFER_CTRLZ,chr(4))
                      AADD(LINBUFFCTRLZ,pi)
                      TEXTO[pi]:=rtrim(memoline(OUTPUTCOMM,1200,i))
                   end
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                ELSEIF SWREPLACECODIGO
                   
                   cMessage := hb_utf8tostr("¿Está seguro de que desea reemplazar el texto completo?"+_CR+;
                                            "(Esta acción no tiene vuelta atrás)")
                   aOptions := { hb_utf8tostr("Sí"), "No" }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)

                   if nChoice==2
                      exit
                   end
                 
                   // elimina CTRL-Z buffer
                   
                   BUFFER_CTRLZ:={};LINBUFFCTRLZ:={}
                   
                      NL:=mlcount(OUTPUTCOMM,2048)  //numtoken(OUTPUTCOMM,HB_OSNEWLINE())
                      NUMCAR:=len(hb_strtoutf8(OUTPUTCOMM))
                      MAXLONG:=3200
                      TMPTEXTO:=GETLINEAS(OUTPUTCOMM,NL,NUMCAR,MAXLONG)
                      XLEN1:=len(TMPTEXTO)
                     /// ? XLEN1, XLEN2 ; inkey(0)
                      ASIZE(TEXTO,XLEN1)
                      ACOPY(TMPTEXTO,TEXTO)
                   TOPE:=XLEN1
                   for i:=1 to TOPE
                      RELEASE TMPTEXTO[i]
                   end
                   RELEASE TMPTEXTO

                   p:=1; px:=1; py:=1; pi:=1; lini:=1;cini:=0
                   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                   setpos(py,px)
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                   exit
                ELSE
                   SHOWOUTPUT()
                END
             end 
          end

          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          BarraTitulo(ARCHIVO)
          SETCOLOR(N2COLOR(cTEXTO))
          setpos(py,px)
          exit
          
       elseif c== 79  //.or. c==15    // CTRL-OO  Ayuda del editor
          HELPTOTAL:=CARGAINTROXU() ///hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"LAICA.help"))
          MSGTOTAL:="AYUDA DE LAICA          ^C=Av Pag.  ^R=Re Pag. "
          hb_keyPut(27)
       elseif c==1
          HELPTOTAL:=hb_utf8tostr(OUTPUTCOMM)
          MSGTOTAL:="Output Shell Command    ^C=Av Pag.  ^R=Re Pag. "
       elseif c==80       // CTRL-OP    repite comando de OPE, si existe.
          if len(OPERA)>0
             RBUFFER:=ARRAY(LEN(BUFFER))
             ACOPY(BUFFER,RBUFFER)
             SWRECBUFFER:=.T.
             nSetDecimal:=set(3,DEFROUND)
             BUFFER:=_CTRL_L_OPE(BUFFER,hb_utf8tostr(STRTRAN(OPERA,_CR,"")))  // LLAMA A LA CALCULADORA
             if LEN(BUFFER)>0
                if BUFFER[1]=="<command-success>"
                             _CTRLOK()
                             BUFFER:=ARRAY(LEN(RBUFFER))
                             ACOPY(RBUFFER,BUFFER)
                             RBUFFER:={}
                             
                             SW_HAYBUFFER:=.T.
                             OPERA:=""
                             hb_keyPut(12)
                             hb_keyPut(asc("O"))
                             exit
                elseif BUFFER[1]=="<error>"
                             _CTRLLERROR()
                             BUFFER:=ARRAY(LEN(RBUFFER))
                             ACOPY(RBUFFER,BUFFER)
                             RBUFFER:={}
                             hb_keyPut(12)
                             hb_keyPut(asc("O"))
                             exit
                end
             //   SW_PASTE:=.T.
                hb_keyPut(11)
                hb_keyPut(85)
                // busca por si no existe, para añadirlo a la lista
                SWOPEXISTE:=.F.
                for i:=1 to len(LISTAEXPRESION)
                   if OPERA == LISTAEXPRESION[i]
                      SWOPEXISTE:=.T.
                      exit
                   end
                end
                if !SWOPEXISTE
                   AADD(LISTAEXPRESION,OPERA)
                end
             else
                _CTRLLVOID()
                BUFFER:=ARRAY(LEN(RBUFFER))
                ACOPY(RBUFFER,BUFFER)
                RBUFFER:={}
             end
             set(3,nSetDecimal)
          end
          exit
                 
       elseif c==88 // .or. c==16   // CTRL-OX  Ayuda rápida del lenguaje
          HELPTOTAL:=CARGAINTROXU()//"" //hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu.help"))
          MSGTOTAL:="AYUDA DE XU(vm)         ^C=Av Pag.  ^R=Re Pag. "
          hb_keyPut(27)

       elseif c==78   // CTRL-ON  crea un archivo.
          SWLOADRAPIDO:=.T.
          RET:=ACTUALDIR+"newfile_"+hb_ntos(int(hb_random(1000000)))
          
          SWCTRLON:=.T.
          hb_keyPut(15)
          hb_keyPut(70)
          loop
       elseif c==70 // .or. c==6    // CTRL-OF   abre un archivo

          SETCOLOR(N2COLOR(cBARRA))
          @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
          setpos(TLINEA-2,2);outstd("FILE TO LOAD? ")
          
          if !SWLOADRAPIDO
             RET:="" 
          
             MSGINPUT("^KU=PASTE, INSERT PATH: ^IH=HOME ^IP=CURRENT ^IR=RELATIVE ^IS=SOURCE XU ^II=INCLUDE XU")
             RET:=INPUTLINE(RET,SLINEA-16,TLINEA-2,16,"s")
          else
             SWLOADRAPIDO:=.F.  // resetea para futuras budquedas
          end
          
          BarraTitulo(ARCHIVO)
          SETCOLOR(N2COLOR(cTEXTO))
          RET:=alltrim(RET)
          if len(RET)>0
             if at("*",RET)==0
                SW_BUSCADIR:=.T.
             else
                SW_BUSCADIR:=.F.
             end
             while at("*",RET)>0
                if LEN(RET)==1
                   RET:=ACTUALDIR+RET
                end
                aCarp := Directory(RET, "D")
                nLen:=len(aCarp)
                if nLen>0
                   /* ordenar el directorio */
                   ASORT( aCarp,,, {| x, y | x[1] < y[1] } )
                   /*  */
                   MENUMATCH:=ARRAY(nLen+1)

                   for i:=1 to nLen
                      if len(aCarp[i][1])>52
                         aCarp[i][1]:=".."+right(aCarp[i][1],50)
                      end
                      MENUMATCH[i]:=padl(hb_utf8tostr(aCarp[i][1]),52)+" "+padl(hb_ntos(aCarp[i][2]/1024),9)+"KB "+;
                           padr(aCarp[i][5],1)+" "+;
                           padr(dtoc(aCarp[i][3]),10)+" "+padl(aCarp[i][4],8)
                   end
                   ains(MENUMATCH,1)
                   MENUMATCH[1]:=padl("..",52)+" Parent directory"

                   SETCOLOR(N2COLOR(cBARRA))
                   @ TLINEA-(int(TLINEA/2)),0 CLEAR TO TLINEA-3,SLINEA

                   setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-8); outstd(" Select a file ")
                   
                   MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                   //SETCOLOR(N2COLOR(6))
                   setpos(TLINEA-2,1)
                   if len(RET)>SLINEA-1
                      outstd(".."+right(RET,SLINEA-5))
                   else
                      outstd(RET)
                   end
                   setcolor( 'GR+/N,N/GR+,,,W/N' )
                   pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,1,TLINEA-3,SLINEA-1,MENUMATCH,.T.)
                   
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE) 
              
                   SETCOLOR(N2COLOR(cTEXTO))
                   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                   BarraTitulo(ARCHIVO)
                   RELEASE MENUMATCH

                   if pELIGE > 0
                      if pELIGE==1  // cambia al directorio anterior
                         RET:=substr(RET,1,rat(_fileSeparator,RET)-1)  // quito "/*"
                         RET:=substr(RET,1,rat(_fileSeparator,RET)-1)+_fileSeparator+"*"
                      elseif aCarp[pELIGE-1][5]=="D"  // entra al directorio
                         RET:=substr(RET,1,rat("*",RET)-1)  // quito "*"
                         RET:=RET+hb_utf8tostr(aCarp[pELIGE-1][1])+_fileSeparator+"*"
                      else
                         EXT:= substr(aCarp[pELIGE-1][1],rat(".",aCarp[pELIGE-1][1])+1,len(aCarp[pELIGE-1][1]))
                         if EXT=="xu" 
                            RET:=/*PATH_SOURCE+_fileSeparator+*/ aCarp[pELIGE-1][1]
                         elseif EXT=="def"
                            RET:=/*PATH_INCLUDE+_fileSeparator+*/ aCarp[pELIGE-1][1]
                         else
                            RET:=substr(RET,1,rat("/",RET))+aCarp[pELIGE-1][1]
                           /* if OPERATING_SYSTEM=="LINUX" 
                               EXT:=FUNFSHELL("file -i "+RET,3)
                            elseif OPERATING_SYSTEM=="DARWIN"
                               EXT:=FUNFSHELL("file -I "+RET,3)
                            end 
                            if "charset=binary" $ EXT
                               cMessage := "No puedo editar archivos binarios" + _CR + ;
                                      "ni archivos ejecutables"
                               aOptions := { "Okay" }
                               nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                               while inkey(,159)!=0 ; end
                               MRESTSTATE(MOUSE)
                               exit
                            end*/
                         end
                         SW_BUSCADIR:=.T.
                         CARGACOLORESTEXTO(PATH_XU,_fileSeparator,EXT)
                      end
                   else
                      exit
                   end
                else
                   //exit
                   cMessage := hb_utf8tostr("El directorio está vacío")
                   aOptions := { "Okay" }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)
                   RET:=substr(RET,1,rat(_fileSeparator,RET)-1)  // quito "/*"
                   RET:=substr(RET,1,rat(_fileSeparator,RET)-1)+_fileSeparator+"*"
                end
             end

             if !SW_BUSCADIR
                RET:=""
                setpos(py,px)
                loop
             end
             if SWSOURCE
                EXT:=substr(RET,rat(".",RET)+1,LEN(RET))
                if EXT=="xu"
                   RET:=PATH_SOURCE+_fileSeparator+RET
                elseif EXT=="def"
                   RET:=PATH_INCLUDE+_fileSeparator+RET
                else
                   ///xFILE:=RET
                   if at(_fileSeparator,RET)==0
                      RET:=ACTUALDIR+RET
                   end
                end
             else
                if at(_fileSeparator,RET)==0
                   RET:=ACTUALDIR+RET
                end
             end

             if !file(RET) .and. !SWCTRLON
                   cMessage := "=== FILE NOT FOUND ===" + _CR + ;
                      RET+_CR+;
                      "Aceptas crear este archivo?"
                   aOptions := { "Acepto", "No, gracias" }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)
                   if nChoice==2 
                      RET:=""
                      setpos(py,px)
                      loop
                   end
             
             end
           //  ? "SELECCIONADO=",RET
           //  ? "ACTUAL=",ARCHIVO
           //  inkey(0)
             // por si vuelve...
           /*  EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
             if EXT=="xu" .or. EXT=="def"
                tARCHIVO:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
             else
                tARCHIVO:=ARCHIVO
             end*/
             
             SWEXISTE:=.F.
             for i:=1 to len(METADATA)  // busco si archivo actualmente editado existe, para no ponerlo en stack, sino, actualizarlo
              
                if METADATA[i]==ARCHIVO      //tARCHIVO
                   SWEXISTE:=.T.
                   exit
                end
             end
             lfin:=TOPE
             if !SWEXISTE
                
                //AADD(METADATA,tARCHIVO)
                AADD(METADATA,ARCHIVO)
                STRING:=substr(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
                AADD(cMETADATA,{STRING,pi,p,px,py,lini,lfin,cini,SW_COMPILE,SW_MODIFICADO,COMPILADOR,EJECUTOR,DESCRIPCION,;
                                ESEJECUTABLE,COMENTARIOS,PARAMETROS,TEXTOTIPO,LENTEXTOTIPO})
             else
                cMETADATA[i][2]:=pi
                cMETADATA[i][3]:=p
                cMETADATA[i][4]:=px
                cMETADATA[i][5]:=py
                cMETADATA[i][6]:=lini
                cMETADATA[i][7]:=lfin
                cMETADATA[i][8]:=cini
                cMETADATA[i][9]:=SW_COMPILE
                cMETADATA[i][10]:=SW_MODIFICADO
                cMETADATA[i][11]:=COMPILADOR
                cMETADATA[i][12]:=EJECUTOR
                cMETADATA[i][13]:=DESCRIPCION
                cMETADATA[i][14]:=ESEJECUTABLE
                cMETADATA[i][15]:=COMENTARIOS
                cMETADATA[i][16]:=PARAMETROS
                cMETADATA[i][17]:=TEXTOTIPO
                cMETADATA[i][18]:=LENTEXTOTIPO
             end
             SW_CTRLOF:=.T.
            /// ? "CARGARE=",RET;inkey(0)
             hb_keyPut(17)   // sale.
             if SWCTRLON
                SWCTRLON:=.F.
                TEXTOTIPO:="UTF8"
             end

             loop
          else
             RET:=""
             setpos(py,px)
             loop
          end
       else
          setpos(py,px)
          loop
       end
       SETCOLOR(N2COLOR(cBARRA))
       @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
       setcursor(0)

       @ 0,0 CLEAR TO TLINEA-3,MAXCOL()
       @ 1, 1 TO TLINEA-3,MAXCOL()-1 DOUBLE
       setpos(0,2); outstd( MSGTOTAL )
       MSGBARRA("Author: Mr. Dalien. See ^OA for conf. details. This program is free",ARCHIVO,2)
       //SETCOLOR(N2COLOR(cHELP))
       setcolor( 'GR+/N,N/GR+,,,W/N' )
       
       if c==88 // .or. c==16  // Ayuda XU: activa el menu.
          CALLMENUXU(@HELPTOTAL,ARCHIVO)
       elseif c==79   // ayuda LAICA
          CALLLAICAMENU(@HELPTOTAL,ARCHIVO)
       else
          // llama a lo que contenga HELPTOTAL
          setcursor(0)
          MEMOEDIT(HELPTOTAL,2,2,TLINEA-4,SLINEA-2, .F.)
          setcursor(1)
       end
       HELPTOTAL:=""
       @ 0,0 CLEAR TO TLINEA,SLINEA
       encabezado(pi,p-nOFFSET,TOPE,SW_MODIFICADO,iif(p<=len(s),s[p],""),SWMARCABLOQUE,SWDELELIN,SWCOPIA,;
                   SWCTRLKCTRLD,SWCTRLKCTRLS,SWCTRLKCTRLP,SWMARCADESP,SWSOBREESCRIBE,SWCTRLKJ,SWCTRLKG,SWEDITTEXT,;
                   XFILi,XCOLi,XFILf,XCOLf)
       VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       BarraTitulo(ARCHIVO)
       SETCOLOR(N2COLOR(cTEXTO))
       setpos(py,px)
       setcursor(1)     

     elseif c==22     // CTRL-V, Insert   inserta codigo. diferenciar controles de otras cosas.
       if TEXTOTIPO=="BINARY"
          cMessage := hb_utf8tostr("Este comando no puede ser usado"+_CR+"en una edición hexadecimal")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
          loop
       end
        MSGCONTROL(" CTRL-V... D=DateTime | E=Name Env Var | V=Value Env Var | Y=Block Remarks /* */ (Only C/C++ & XU)",;
                   " INSERT    C, A, F=Programing Code for C/C++, XU & LaTex | I=Overwrite mode",;
                   " CODE")
        c:=inkey(0)
        c:=asc(upper(chr(c)))
        BarraTitulo(ARCHIVO)
        setpos(py,px)
        while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
        SWA:=.F.
        if c==68  // .or. c==4        // CTRL-VD  inserta fecha y hora
          STRING:=PONEFECHA()
          for i:=1 to len(STRING)
             hb_keyPut(asc(substr(STRING,i,1)))
          end
          STRING:=""
        
        elseif c==73         // CTRL-VI  modo sobreescritura on/off
          SWSOBREESCRIBE:=!SWSOBREESCRIBE
          if SWSOBREESCRIBE
             setcursor(1)
          else
             setcursor(3)
          end
          
        elseif c==89 // .or. c==25    // CTRL-VY
          if EXTENSION==1
             STRING:="/*  */"
             for i:=1 to len(STRING)
                hb_keyPut(asc(substr(STRING,i,1)))
             end
             hb_keyPut(19)
             hb_keyPut(19)
             hb_keyPut(19)
             STRING:=""
          else
             hb_keyPut(25)
          end
        elseif c==69 // .or. c==5     // CTRL-VE  insertar variable de entorno.
          STRING:=_SELECTENVVAR(TLINEA,ARCHIVO,0)
          if len(STRING)>0
             for i:=1 to len(STRING)
                hb_keyPut(asc(substr(STRING,i,1)))
             end
             STRING:=""
          end
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          BarraTitulo(ARCHIVO)
        elseif c==86  .or. c==22     // CTRL-VV  insertar contenido de variable de entorno.
          STRING:=_SELECTENVVAR(TLINEA,ARCHIVO,1)
          if len(STRING)>0
             for i:=1 to len(STRING)
                hb_keyPut(asc(substr(STRING,i,1)))
             end
             STRING:=""
          end
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          BarraTitulo(ARCHIVO)
        elseif c==67 // .or. c==3       // CTRL-VC inserta controles
          MENUCTRL:=INSERTMENU(1)
          SWA:=.T.
        elseif c==65 //.or. c==1   // CTRL-VA inserta asignaciones especiales
          MENUCTRL:=INSERTMENU(2)
          SWA:=.T.
        elseif c==70 //.or. c==6   // CTRL-VF inserta función
          MENUCTRL:=INSERTMENU(4)
          SWA:=.T.
        end
        if SWA
           // limpio la lista de busqueda, por si acaso.
           if len(LISTAFOUND)>0 
              RELEASE LISTAFOUND
              LISTAFOUND:={}
              SWMATCH:=.F.
              ptrLF:=0; totLF:=0
           end
    
           MENUMATCH:=MENUCTRL[1]
           MENU:=MENUCTRL[2]

           SETCOLOR(N2COLOR(cBARRA))
           @ TLINEA-(int(TLINEA/2)),0 CLEAR TO TLINEA-3,SLINEA

           setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-6); outstd(" Ins Code ")
           MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
           //SETCOLOR(N2COLOR(6))
           setcolor( 'GR+/N,N/GR+,,,W/N' )
           pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,1,TLINEA-3,SLINEA-1,MENUMATCH, .T.)
           
           while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 
              
           SETCOLOR(N2COLOR(cBARRA))
           VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
           BarraTitulo(ARCHIVO)
           SETCOLOR(N2COLOR(cTEXTO))
         
           STRING:=""
           IF pELIGE>0
              STRING:=hb_utf8tostr(MENU[pELIGE][1])
              pKEY:=MENU[pELIGE][2]
              pREP:=MENU[pELIGE][3]
           END

           nLen:=LEN(STRING)
           mLen:=mlcount(STRING,216)
           if nLen!=0
              codeIndent:=p-1
              STRING1:=""
              if mLen>1
                 ++TOPE
                 asize(TEXTO,TOPE)
                 ++pi
                 ains(TEXTO,pi)
                 ++py 
                 if yCALLBACK>0
                    ++yCALLBACK
                 end
                 if py>TLINEA-3
                    ++lini; ++lfin
                    --py
                 end
              end
              for j:=1 to nLen
                 CX:=substr(STRING,j,1)
                 if asc(CX)==13
                    loop
                 end
                 if asc(CX)!=10
                    STRING1+=CX
                 else
                    
                    TEXTO[pi]:=SPACE(codeIndent) + STRING1
                    ++TOPE
                    asize(TEXTO,TOPE)
                    ++pi
                    ains(TEXTO,pi)
                    
                    ++py  //;p:=1;px:=1
                    if yCALLBACK>0
                       ++yCALLBACK
                    end
                    if py>TLINEA-3
                       ++lini; ++lfin
                       --py
                      // if yCALLBACK>0
                      //    --yCALLBACK
                      // end
                    end
                    STRING1:=""
                 end
              end
              if len(STRING1)>0
                 if mLen>1
                    TEXTO[pi]:=SPACE(codeIndent) + STRING1
                 else
                    TEXTO[pi]:=substr(TEXTO[pi],1,codeIndent) + STRING1 + ;
                               substr(TEXTO[pi],codeIndent+1,len(TEXTO[pi]))
                 end
                 STRING1:=""
              end
              codeIndent:=0
              SW_COMPILE:=.F.
              SW_MODIFICADO:=.T.

              SETCOLOR(N2COLOR(cTEXTO))
              VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
              BarraTitulo(ARCHIVO)
              if pREP>0
                 pushkey(pKEY,pREP)
                 exit
              elseif pKEY>0
                 hb_keyPut(pKEY)
                 exit
              else
                 exit
              end
           else
              BarraTitulo(ARCHIVO)
              setpos(py,px)
           end
        else
           BarraTitulo(ARCHIVO)
           setpos(py,px)
        end
       
     elseif c==23   //CTRL-W
       /*if TEXTOTIPO=="BINARY"
          cMessage := hb_utf8tostr("No puede guardar este archivo, porque solo es"+_CR+"una representación binaria")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
          loop
       end*/
       tARCHIVO:=ARCHIVO   // guardo temporal para comparar
       //ECX:=ARCHIVO
       
       WHILE .T.
       SETCOLOR(N2COLOR(cBARRA))
       EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
       if SWSOURCE
          if EXT=="xu"
              PATH:=PATH_SOURCE+_fileSeparator
          elseif EXT=="def"
              PATH:=PATH_INCLUDE+_fileSeparator
          else
              PATH:=LEFT(ARCHIVO,rat("/",ARCHIVO))
          end
       else
          PATH:=LEFT(ARCHIVO,rat("/",ARCHIVO))
       end
       RET:=""
       ECX:=SUBSTR(ARCHIVO,rat("/",ARCHIVO)+1,len(ARCHIVO))
       @ TLINEA-3,0 CLEAR TO TLINEA,MAXCOL()
       setpos(TLINEA-3,2);outstd(" PATH="+ iif(len(PATH)>SLINEA-11, ".."+RIGHT(PATH,SLINEA-11), PATH ) )
       setpos(TLINEA-2,2);outstd(" FILE NAME TO WRITE? ")

       MSGINPUT("^KU=PASTE, INSERT PATH: ^IH=HOME ^IP=CURRENT ^IR=RELATIVE ^IS=SOURCE XU ^II=INCLUDE XU")
       ECX:=INPUTLINE(ECX,SLINEA-23,TLINEA-2,23,"s")

       BarraTitulo(ARCHIVO)
       SETCOLOR(N2COLOR(cTEXTO))
       ECX:=alltrim(ECX)

       if LEN(ECX)>0
          
          if at("*",ECX)==0
             SW_BUSCADIR:=.T.
             if len(alltrim(PATH))>0
                ARCHIVO:=PATH+ECX
             else
                ARCHIVO:=ECX
             end
             exit  // sale del bucle principal
          else
             SW_BUSCADIR:=.F.
             cARCHIVO:=SUBSTR(ECX,rat("/",ECX)+1,len(ECX))
             RET:=LEFT(ECX,rat("/",ECX))
             if at("*/",ECX)>0
                 RET:=ACTUALDIR+"*"
             else
                 cMessage := hb_utf8tostr("No puede usar '*' de esta forma. Use '*/archivo' para navegar")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             end
          
             while at("*",RET)>0
                aCarpeta := Directory(RET, "D")
                /* ordenar el directorio */
                ASORT( aCarpeta,,, {| x, y | x[1] < y[1] } )
                /*  */
                // selecciona solo directorios:
                aCarp:={}
                for i:=1 to len(aCarpeta)
                   if aCarpeta[i][5]=="D"
                      aadd(aCarp,{aCarpeta[i][1],aCarpeta[i][2],aCarpeta[i][3],aCarpeta[i][4],;
                                  aCarpeta[i][5]})
                   end
                end
                
                nLen:=len(aCarp)

                MENUMATCH:=ARRAY(0)
                AADD(MENUMATCH,padl("..",52)+" Parent directory")
                for i:=1 to nLen
                   if aCarp[i][5]=="D"
                      AADD(MENUMATCH,padl(hb_utf8tostr(aCarp[i][1]),50)+" "+padl(hb_ntos(aCarp[i][2]/1024),9)+"KB "+;
                           padr(aCarp[i][5],1)+" "+;
                           padr(dtoc(aCarp[i][3]),10)+" "+padl(aCarp[i][4],8) )
                   end
                end

                SETCOLOR(N2COLOR(cBARRA))
                @ TLINEA-(int(TLINEA/2)),0 CLEAR TO TLINEA-3,SLINEA

                setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-11); outstd(" Select a directory ")
                   
                MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN. ESC=SELECT",ARCHIVO,0)
                setpos(TLINEA-2,1)
                if len(RET)>SLINEA-1
                      outstd(".."+right(RET,SLINEA-5))
                else
                      outstd(RET)
                end
                setcolor( 'GR+/N,N/GR+,,,W/N' )
                pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,1,TLINEA-3,SLINEA-1,MENUMATCH,.T.)
                
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE) 
              
                SETCOLOR(N2COLOR(cTEXTO))
                VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                BarraTitulo(ARCHIVO)
                RELEASE MENUMATCH

                if pELIGE==0
                   ECX:=substr(RET,1,rat(_fileSeparator,RET))+cARCHIVO
                  // ? ECX ; inkey(0)
                   SW_BUSCADIR:=.T.
                   exit
                elseif pELIGE==1  // cambia al directorio anterior
                      RET:=substr(RET,1,rat(_fileSeparator,RET)-1)  // quito "/*"
                      RET:=substr(RET,1,rat(_fileSeparator,RET)-1)+_fileSeparator+"*"
                else  // entra al directorio
                      RET:=substr(RET,1,rat("*",RET)-1)  // quito "*"
                      RET:=RET+hb_utf8tostr(aCarp[pELIGE-1][1])+_fileSeparator+"*"
                end
             end
          end
          if SW_BUSCADIR
             if AT(_fileSeparator,ECX)>0   // añade un nuevo path.
                ARCHIVO:=ECX   // guarda en nuevo path
             else
                ARCHIVO:=PATH+ECX  // rearmo el path del archivo
             end
          end
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
       else
          BarraTitulo(ARCHIVO)
          VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
          SW_BUSCADIR:=.F.
          ARCHIVO:=tARCHIVO
          RET:=""
          exit
       end
       END  // bucle principal
       if SW_BUSCADIR
             @ 10,int(SLINEA/2)-7 CLEAR TO 14,int(SLINEA/2)+7
             DISPBOX(10,int(SLINEA/2)-7,14,int(SLINEA/2)+7,2)
             @ 12,int(SLINEA/2)-4 SAY "GUARDANDO"
             
             /*  si el archivo cambia de codificación, no debe notarse en la edición actual
                 Luego, debo respaldar el tipo de codificación para no tener probemas de
                 edicion */
             TMPTEXTOTIPO:=TEXTOTIPO
             
             if !file(ARCHIVO)    // no existe el archivo: lo graba
               // @ 0,0 say "  ARCHIVO NO EXISTE Y SE GUARDA  "+ARCHIVO; inkey(0)
                if TEXTOTIPO=="BINARY"
                   tmp:=SAVEBIN(TEXTO,ARCHIVO,TOPE,nOFFSET+1)
                else
                   tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
                end
             elseif ARCHIVO==tARCHIVO   // es el mismo editado
               // @ 0,0 say "  ARCHIVO EXISTE Y ES EL MISMO  "+ARCHIVO; inkey(0)
                //tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
                if TEXTOTIPO=="BINARY"
                   tmp:=SAVEBIN(TEXTO,ARCHIVO,TOPE,nOFFSET+1)
                else
                   tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
                end
             elseif file(ARCHIVO)   // es distinto al editado y existe
               // @ 0,0 say "  ARCHIVO EXISTE EN LA RUTA ESPECIFICADA  "+ARCHIVO; inkey(0)
                cMessage := "El archivo "+ECX+" existe en la ruta especificada"+_CR+;
                         hb_utf8tostr("Deseas sobreescribirlo?")
                aOptions := { hb_utf8tostr("Sí"),"No" }
                nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE)
                if nChoice==1
                   if TEXTOTIPO=="BINARY"
                      tmp:=SAVEBIN(TEXTO,ARCHIVO,TOPE,nOFFSET+1)
                   else
                      tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
                   end
                   //tmp:=SAVEFILE(TEXTO,ARCHIVO,TOPE)
                else
                   tmp:=.T.   // para que no pase
                   //ARCHIVO:=tARCHIVO
                end
                ARCHIVO:=tARCHIVO
             end
             BarraTitulo(ARCHIVO)
             VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)

             if !tmp
                cMessage := hb_utf8tostr("Archivo no pudo ser guardado")
                // define response option
                aOptions := { hb_utf8tostr("Será...") }

                // show message and let end user select panic level
                nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                while inkey(,159)!=0 ; end
                MRESTSTATE(MOUSE)
             else
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.F.
                cTEXTO:=tTEXTO
                ARCHIVO:=tARCHIVO
                setpos(py,px)
             end
             TEXTOTIPO:=TMPTEXTOTIPO
             LENTEXTOTIPO:=LEN(TEXTOTIPO)
       end
       setpos(py,px)
       
        
     elseif c==7    // SUPR, CTRL-G
          if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Use CTRL-I para sobreescribir datos")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       xlen:=len(s) 
       if xlen>=p
         AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
         AADD(LINBUFFCTRLZ,pi)
         --xlen
         adel(s,p)
         asize(s,xlen)
         TEXTO[pi]:=LLENATEXTO(s,xlen,0)
         /*if !SWCTRLKE
            if xlen-p<20 
                millisec(100)
                while inkey()!=0
                   ;
                end
            end
         end*/
         
         VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
         
         ++xlen
         
         SW_COMPILE:=.F.
         SW_MODIFICADO:=.T.
         setpos(py,px)
         
       else
         SW_BORRA7:=.T.
         SW_COMPILE:=.F.
         SW_MODIFICADO:=.T.
         if yCALLBACK>0
            --yCALLBACK
         end
         if pi<TOPE
            AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
            AADD(LINBUFFCTRLZ,pi)
            AADD(BUFFER_CTRLZ,TEXTO[pi+1])
            AADD(LINBUFFCTRLZ,pi+1)
            AADD(BUFFER_CTRLZ,chr(7))  // debo procesar las dos líeas que faltan
            AADD(LINBUFFCTRLZ,pi+1)
            AADD(BUFFER_CTRLZ,chr(5))
            AADD(LINBUFFCTRLZ,pi+1)
         else
            AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
            AADD(LINBUFFCTRLZ,pi)
         end
         exit
       end
     elseif c==8   // RETROCESO, CTRL-H
          if TEXTOTIPO=="BINARY"
             cMessage := hb_utf8tostr("Use CTRL-I para sobreescribir datos")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
             loop
          end
       if p>1
         
         AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
         AADD(LINBUFFCTRLZ,pi)
         
         xlen:=len(s)         
         --p
         
         --xlen
         adel(s,p)
         asize(s,xlen)
         TEXTO[pi]:=LLENATEXTO(s,xlen,0)
         SETCOLOR(N2COLOR(cTEXTO))
         --px
         if px<1
            if cini>int(SLINEA/2)
               px:=px+int(SLINEA/2)
               cini:=cini-int(SLINEA/2)
            else
               ++px
               --cini
               if cini<0
                  cini:=0
               else
                  if cini>0
                     px:=px+cini
                     cini:=0
                  end
               end
            end
         end

         VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)

         ++xlen
         
         SW_COMPILE:=.F.
         SW_MODIFICADO:=.T.
         
         setpos(py,px) //--px)
         
       else

         SW_BORRA8:=.T.
         SW_COMPILE:=.F.
         SW_MODIFICADO:=.T.
         if yCALLBACK>0
            --yCALLBACK
         end
         if pi>1
            AADD(BUFFER_CTRLZ,TEXTO[pi-1])
            AADD(LINBUFFCTRLZ,pi-1)
            AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
            AADD(LINBUFFCTRLZ,pi)
            AADD(BUFFER_CTRLZ,chr(7))  // debo procesar las dos líeas que faltan
            AADD(LINBUFFCTRLZ,pi)
            AADD(BUFFER_CTRLZ,chr(5))
            AADD(LINBUFFCTRLZ,pi)
         else
            AADD(BUFFER_CTRLZ,LLENATEXTO(s,xlen,0))
            AADD(LINBUFFCTRLZ,pi)
         end

         exit
       end

     elseif c==9   // tabulador (CTRL-I)
       if TEXTOTIPO!="BINARY"
          AADD(BUFFER_CTRLZ,LLENATEXTO(s,len(s),0))
          AADD(LINBUFFCTRLZ,pi)
          pushkey(32,cTABULA-(p%cTABULA))
       else   // sobreescribe archivo binario.
          SETCOLOR(N2COLOR(cBARRA))
          ECX:=""
          @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
          MSGINPUT("")
          setpos(TLINEA-2,2);outstd(" READY! ")
          ECX:=ALLTRIM(INPUTLINE(ECX,SLINEA-10,TLINEA-2,10,"s"))
          if lastkey()!=3 .or. len(ECX)>0
             c1:=substr(ECX,2,len(ECX))
             ECX:=upper(substr(ECX,1,1))
             
             if ECX=="X"  // borra posiciones
                
                if ISTNUMBER(c1)==1
                   c1:=val(c1)

                   pos:=(pi-1)*20+(px-nOFFSET)
                ///   ? "POS=",pos," LONG=",c2; inkey(0)
                   REFORMAT(@TEXTO,nOFFSET+1,1,pos,c1)
                   TOPE:=LEN(TEXTO)
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                 /*  BarraTitulo(ARCHIVO)
                   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                   setpos(px,py)
                   setcursor(1)
                   exit*/
                else
                   cMessage := hb_utf8tostr("Número no válido."+_CR+"Intenta con números reales")
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)
                   setpos(py,px)
                end
             elseif ECX=="I"    // inserta posiciones con caracteres
                c2:=GETSTRCTRLI(c1)
                if len(c2)>0
                   REFORMAT(@TEXTO,nOFFSET+1,2,(pi-1)*20+(px-nOFFSET),c2)
                   TOPE:=LEN(TEXTO)
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                else
                   cMessage := hb_utf8tostr("Caracter no válido."+_CR+;
                             "Si es un solo caracter, usa '#nn;'"+_CR+"También intenta con opcode hexadecimal.")
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)
                   setpos(py,px)
                end
             elseif ECX=="O"    // sobreescribe
                c2:=GETSTRCTRLI(c1)
                if len(c2)>0
                   REFORMAT(@TEXTO,nOFFSET+1,0,(pi-1)*20+(px-nOFFSET),c2)
                   TOPE:=LEN(TEXTO)
                   SW_COMPILE:=.F.
                   SW_MODIFICADO:=.T.
                else
                   cMessage := hb_utf8tostr("Caracter no válido."+_CR+;
                             "Si es un solo caracter, usa '#nn;'"+_CR+"También intenta con opcode hexadecimal.")
                   aOptions := { hb_utf8tostr("Será...") }
                   nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                   while inkey(,159)!=0 ; end
                   MRESTSTATE(MOUSE)
                   setpos(py,px)
                end
               /// p:=c3; pi:=c1
             end // if
             BarraTitulo(ARCHIVO)
             VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
             setpos(px,py)
             setcursor(1)
             exit
          end
       end
       BarraTitulo(ARCHIVO)
       setpos(px,py)
       
     else
        if TEXTOTIPO=="BINARY"
          cMessage := hb_utf8tostr("Use CTRL-I para sobreescribir datos")
                 aOptions := { hb_utf8tostr("Será...") }
                 nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                 while inkey(,159)!=0 ; end
                 MRESTSTATE(MOUSE)
          loop
        end
        //if c>=32
        
          c:=CARACTESPE(c)
          if c==127   // codigo especial era CX
             SW_CODESP:=!SW_CODESP
             SWINDENTA:=!SWINDENTA
             c:=0
          end
          if c==10  // salto de línea
             c=0
          elseif c==13
             c=0
          end
          if c!=0
             if SW
                xlen:=len(s)
                AADD(BUFFER_CTRLZ,LLENATEXTO(s,len(s),0))
                AADD(LINBUFFCTRLZ,pi)
              ///  @0,60 say "XLEN="+hb_ntos(xlen)+" P="+hb_ntos(p)+"   "
                if SWSOBREESCRIBE
                   if p<=xlen
                 //     AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                      s[p]:=chr(c)
                      ++p; ++px
                      
                   else    // es mayor
                 //     AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                      asize(s,xlen+1)
                      ains(s,p)
                      ++xlen; ++px
                      s[p]:=chr(c)
                      ++p
                      
                   end
                else       
                if p<xlen // px<xlen
              ///    AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                  asize(s,xlen+1)
                  ains(s,p)
                  ++xlen; ++px
                  s[p]:=chr(c)
                  
                  ++p
                /*  */  
                  if !SW_CODESP
                    if s[p-1]=='"'
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:='"'
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="("
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:=")"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="{"
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="}"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="["
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="]"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="|"
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="|"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="$" .and. EXTENSION==2
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="$"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    end
                  end
                elseif p==xlen
                  if p==1
                  ///   AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                     if s[p]==""
                        s[p]:=chr(c)
                        ++p;++px
                     else   // existe un caracter
                        asize(s,xlen+1)
                        ains(s,p)
                        s[p]:=chr(c)
                        ++xlen; ++p; ++px
                     end
                  else
                     //if p>1   // >=
                 ///    AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                        asize(s,xlen+1)
                        ains(s,p)
                     //end
                     s[p]:=chr(c)
                     // aguega anticomando:
                     //AADD(CTRLZ,{pi,p,7})
                     ++xlen; ++p; ++px
                  end
                  
                /*  */  
                  if !SW_CODESP
                    if s[p-1]=='"'
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:='"'
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="("
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:=")"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="{"
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="}"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="["
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="]"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="|"
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="|"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    elseif s[p-1]=="$" .and. EXTENSION==2
                      ++xlen;asize(s,xlen);ains(s,p)
                      s[p]:="$"
                      // aguega anticomando:
                    //  AADD(CTRLZ,{pi,p,7})
                    end
                  end
                /*  */
                else    // es mayor que xlen
             ///     AADD(CTRLZ,{lini,cini,pi,p,py,px,TEXTO[pi]})
                  asize(s,xlen+1)  //
                  ains(s,p)
                  s[p]:=chr(c)
                  // aguega anticomando:
                  ++xlen; ++p; ++px
                  
                  if !SW_CODESP
                     if s[p-1]=='"'
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:=chr(c)
                        // aguega anticomando:
                       // AADD(CTRLZ,{pi,p,7})
                     elseif s[p-1]=='('
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:=")"
                        // aguega anticomando:
                       // AADD(CTRLZ,{pi,p,7})
                     elseif s[p-1]=='['
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:="]"
                        // aguega anticomando:
                      //  AADD(CTRLZ,{pi,p,7})
                     elseif s[p-1]=='{'
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:="}"
                        // aguega anticomando:
                      //  AADD(CTRLZ,{pi,p,7})
                     elseif s[p-1]=='|'
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:="|"
                        // aguega anticomando:
                      //  AADD(CTRLZ,{pi,p,7})
                     elseif s[p-1]=='$' .and. EXTENSION==2
                        asize(s,xlen+1);ains(s,p) 
                        s[p]:="$"
                        // aguega anticomando:
                      //  AADD(CTRLZ,{pi,p,7})
                     end
                  end

                end
                end   // SWSOBREESCRIBE
                
                // se asegura de que deba compilar después de una modificacion
                SW_COMPILE:=.F.
                SW_MODIFICADO:=.T.

                if px>SLINEA-1
                   //++cini ; --px
                   cini:=cini+20
                   px:=px-20
                   
                end

                TEXTO[pi]:=LLENATEXTO(s,len(s),0)
               // @ py+1, px say TEXTO[pi] + hb_ntos((len(TEXTO[pi]))) ; inkey(0)
                setcursor(0)
                VISUALIZA_TEXTO(TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                
                setcursor(1)
                setpos(py,px)
                pCURSOR:=p
             end
          end
       /*else
          cMessage := hb_utf8tostr("No se permiten caracteres ASCII menores a 32")
          aOptions := { hb_utf8tostr("Será...") }
          nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
          while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
       end*/
     end
     
  end
end

RETURN RET

FUNCTION BUSCAPARENTIZACION(TEXTO,XFIL1EDIT, XFIL2EDIT,COM,EXT)
LOCAL TARGET,i,j,k,xlen,s,s0:={},x:={},y:={},plen:=0,ret:=.T.
LOCAL msg:="",swcom:=.F.
  
  TARGET:={}
//  ? "LEN=",len(TEXTO)," TOPE=",XFIL2EDIT; inkey(0)
  for i:=XFIL1EDIT to XFIL2EDIT  // líneas

     s:=ASIGNALINEA(TEXTO[i])
     xlen:=len(s)
     for j:=1 to xlen
        if swcom     // si viene de un comentario de bloque, siga saltando hasta */
           while j<xlen
              if s[j]=="*"
                 if s[j+1]=="/"
                    swcom:=.F.
                    exit
                 end
              end
              ++j
           end
           if j>=xlen
              exit
           end
        end
        if s[j]==EXT  // aislo los strings
           k:=j+1
           while k<= xlen
              if s[k]==EXT
                 j:=k+1
                 exit
              end
              ++k
           end
           if k>xlen
              exit
           end
           if j>xlen
              exit
           end
        end
        if EXT=='"'  // si string es comilla, salto los // y /* */
         //  ?"J=",j," len=",xlen
           if s[j]=="/"
             if j<xlen
                if s[j+1]=="/"  // es un comentario de línea
                   exit
                elseif s[j+1]=="*"  // busca fin de comentario
                   k:=j+1
                   while k<xlen  // evito llegar al ultimo caracter para el k+1
                     if s[k]=="*"
                        if s[k+1]=="/"
                           j:=k+1
                           exit
                        end
                     end
                     ++k
                   end
                   if k==xlen
                     swcom:=.T.
                     exit
                   end
                end
             end
           end
        else
           if s[j]==COM  // comentario de un simbolo #, %, etc.
              exit
           end
        end
        if s[j]=="(" .or. s[j]=="[" .or. s[j]=="{"
        //   ? "ENCUENTRA "+s[j]
           aadd(s0,s[j])
           aadd(y,i)
           aadd(x,j)
           plen:=len(s0)
        elseif s[j]==")" .or. s[j]=="]" .or. s[j]=="}"
        //   ? "ENCUENTRA "+s[j]
           if plen==0
              ret:=.F.
              aadd(s0,s[j])
              aadd(y,i)
              aadd(x,j)
              plen:=len(s0)
              msg:=" no ha sido abierto"
              exit
           else
              if s[j]==")"
                 if s0[plen]!="("
                    ret:=.F.
                       s0[plen]:=s[j]
                       y[plen]:=i
                       x[plen]:=j
                       msg:=" no ha sido abierto"
                    exit
                 else
                    --plen
                    asize(s0,plen)
                    asize(y,plen)
                    asize(x,plen)
                 end
              elseif s[j]=="]"
                 if s0[plen]!="["
                    ret:=.F.
                    s0[plen]:=s[j]
                    y[plen]:=i
                    x[plen]:=j
                    msg:=" no ha sido abierto"
                    exit
                 else
                    --plen
                    asize(s0,plen)
                    asize(y,plen)
                    asize(x,plen)
                 end
              elseif s[j]=="}"
                 if s0[plen]!="{"
                    ret:=.F.
/*                    s0[plen]:=s[j]
                    y[plen]:=i
                    x[plen]:=j*/
                    msg:=" no ha sido cerrado"
                    exit
                 else
                    --plen
                    asize(s0,plen)
                    asize(y,plen)
                    asize(x,plen)
                 end
              end
           end
        end
     end
     if !ret
        exit
     end
  end
  if !ret
     aadd(TARGET,{ret,s0[plen],y[plen],x[plen],msg})
  else
     if plen>0
        aadd(TARGET,{.F.,s0[plen],y[plen],x[plen]," no ha sido cerrado"})
     else
        aadd(TARGET,{ret,0,0,0,""})
     end
  end
return TARGET

FUNCTION CARGAINTROXU()
local feggs,fp,_nl,sw:=.F.,c,j, HELPTOTAL

feggs:=PATH_XU+_fileSeparator+"binary"+_fileSeparator+"introxu.bin"
sw:=.T.
if file(feggs)
   fp:=fopen(feggs,0)
   _nl:=fseek(fp,0,2)
   fseek(fp,0,0)
   HELPTOTAL:=""
   c:="    "
   for j:=1 to _nl/4
      fread(fp,@c,4)
      HELPTOTAL+=chr(bin2i(c))
   end
   fclose(fp)
else
   HELPTOTAL:="AYUDA DE XU"+_CR+_CR+_CR+"Elija un topico de ayuda desde el menu de ayuda."
end

RETURN HELPTOTAL

FUNCTION CALLLAICAMENU(HELPTOTAL,ARCHIVO)
local nChoice, POS, HFIL,pELIGE,MATCH, MREAD, hCADI,lCADI,hCADF,XLEN,FILEHELP,TOPICO,MENS

nChoice:=1
while nChoice>0 
   setcursor(0)
   //if sw
   //   hb_keyPut(27)
  // end
   MEMOEDIT(HELPTOTAL,2,2,TLINEA-4,SLINEA-2, .F.)
   setcursor(1)
   POS:=12
   HFIL:=2 //int(SLINEA/2)-33  //28
   setcolor( 'GR+/N,N/GR+,,,W/N' )
   @ TLINEA-2, HFIL    PROMPT "INTRO"
   @ TLINEA-2, HFIL+8  PROMPT "MACROS"  
                
   MENU TO nChoice
   if nChoice==1
      TOPICO:="PRIMEROS PASOS"
      MATCH:={"Introduccion LAICA","Uso del BUFFER","Comandos de movimiento de cursor","Edicion basica",;
              "Menu ^O (ayuda y archivos)","Menu ^P (Compilacion y vista)","Menu ^V (Insercion de codigo)",;
              "Menu ^J (Saltos a lineas)",;
              "Menu ^K (Edicion avanzada)","Menu ^N (Busqueda y reemplazo)","Menu ^L (Procesamiento avanzado de texto)",;
              "Comandos ALT (atajos de comandos CTRL)"}
      FILEHELP:=PATH_HELP+_fileSeparator+"laica.help"
      XLEN:=len(MATCH)

   elseif nChoice==2
      TOPICO:="MACROS - EDICION AVANZADA"
      MATCH:={"Introduccion a las macros LAICA - OPE","Sentencias del encabezado","Registros de memoria","Estructura de Ciclo",;
              "Funciones aritmeticas","Funciones basicas de texto","Modificacion de BUFFER","Tokens","Funciones avanzadas de texto",;
              "Sobrecarga de operadores","Funciones utilitarias",;
              "Funciones de archivo","Operadores de bits","Edicion hexadecimal","Ejemplos"}
      FILEHELP:=PATH_HELP+_fileSeparator+"laica.help"
      XLEN:=len(MATCH)
      
   end
   if nChoice>0
      SETCOLOR(N2COLOR(cBARRA))
      @ TLINEA-XLEN-5,10 CLEAR TO TLINEA-4,SLINEA-10
      MENS:="MENU DEL TOPICO ["+TOPICO+"]"
      setpos(TLINEA-XLEN-5,int(SLINEA/2)-int(len(MENS)/2)); outstd(MENS)

     // MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
     // setcolor( 'GR+/N,N/GR+,,,W/N' )
      setcolor( 'W/N,N/W,,,W/N' )

      pELIGE:=ACHOICE(TLINEA-XLEN-4,11,TLINEA-4,SLINEA-11,MATCH, .T.)

      while inkey(,159)!=0 ; end
      MRESTSTATE(MOUSE) 
      MREAD:=hb_utf8tostr(MEMOREAD(FILEHELP))
      if pELIGE>0
         hCADI:=at("$$BEGIN "+MATCH[pELIGE],MREAD)
         lCADI:=len("$$BEGIN "+MATCH[pELIGE])
         HELPTOTAL:=substr(MREAD,hCADI+lCADI,len(MREAD))
         hCADF:=at("$$END "+MATCH[pELIGE],HELPTOTAL)
         HELPTOTAL:=substr(HELPTOTAL,1,hCADF-1)
         HELPTOTAL:=substr(MREAD,1,at("$$END INTRO",MREAD)-1)+HELPTOTAL
      else
         nChoice:=1 ; hb_keyPut(27)//MREAD
      end
   end
end
//hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"ed4xu.help"))
RETURN

FUNCTION CALLMENUXU(HELPTOTAL,ARCHIVO)
local nChoice, POS, HFIL,pELIGE,MATCH, MREAD, hCADI,lCADI,hCADF,XLEN,FILEHELP,TOPICO,MENS

nChoice:=1
while nChoice>0 
   setcursor(0)
   //if sw
   //   hb_keyPut(27)
  // end
   MEMOEDIT(HELPTOTAL,2,2,TLINEA-4,SLINEA-2, .F.)
   setcursor(1)
   POS:=12
   HFIL:=2 //int(SLINEA/2)-33  //28
   setcolor( 'GR+/N,N/GR+,,,W/N' )
   @ TLINEA-2, HFIL    PROMPT "INTRO"
   @ TLINEA-2, HFIL+8  PROMPT "PREPROC"  //+9 CASTOR
   @ TLINEA-2, HFIL+16 PROMPT "CONTROL"    //+8
   @ TLINEA-2, HFIL+24 PROMPT "STRING"    //+6
   @ TLINEA-2, HFIL+31 PROMPT "MATRIX"    //+6
   @ TLINEA-2, HFIL+38 PROMPT "MATH"    //+6
   @ TLINEA-2, HFIL+43 PROMPT "DATE"  //+6
   @ TLINEA-2, HFIL+48 PROMPT "BASE"   //+8
   @ TLINEA-2, HFIL+53 PROMPT "BITS"     //+7
   @ TLINEA-2, HFIL+58 PROMPT "I/O"  //
   @ TLINEA-2, HFIL+62 PROMPT "STACK"     //
   @ TLINEA-2, HFIL+68 PROMPT "STANDARD"     //
                
   MENU TO nChoice
   if nChoice==1
      TOPICO:="PRIMEROS PASOS"
      MATCH:={"Introduccion","Compilacion y ejecucion","Un programa simple","Estructura de un programa XU",;
              "Detalles de la programacion XU","Tipos de datos en XU",;
              "Asignacion de datos","Operadores matematicos y logicos",;
              "Parametros",;
              "Funciones de usuario","Librerias","Sentencia flag","Precision numerica"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu.help"
      XLEN:=len(MATCH)

   elseif nChoice==2
      TOPICO:="PREPROCESADOR"
      MATCH:={"Asignaciones","Macro #define","Bifurcacion inline","Macro #include","Macro #import"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-preprocesador.help"
      XLEN:=len(MATCH)
      
   elseif nChoice==3
      TOPICO:="ESTRUCTURAS DE CONTROL"
      MATCH:={"Iteracion","Macros de iteracion","Quiebre de iteracion","Bifurcacion IF","Macros de bifurcacion",;
              "Evaluacion por seleccion","Habitaciones","Salto a subrutina","Atrapar errores"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-control.help"
      XLEN:=len(MATCH)

   elseif nChoice==4
      TOPICO:="STRINGS"
      MATCH:={"Asignacion de strings","Despliegue",hb_utf8tostr("Tamaño"),"Concatenacion","Substrings","Replicacion",;
              "Insercion","Reemplazo","Busqueda","Archivos","Tokens","Miscelaneos"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funstring.help"
      XLEN:=len(MATCH)

   elseif nChoice==5
      TOPICO:="MATRICES"
      MATCH:={"Dimensiones y declaraciones","Redimension",hb_utf8tostr("Tamaño de una matriz"),"Sentencia USE","Acceso a una matriz",;
              "Declaracion de rangos","Uso de rangos","Busqueda","Unir matrices","Cortar matrices","Copiar submatrices",;
              "Archivos","Operaciones estadisticas","Despliegue","Generar secuencias","Ordenacion","Maximo y minimo",;
              "Funciones IS...","Funcion JOIN"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funmatrix.help"
      XLEN:=len(MATCH)

   elseif nChoice==6
      TOPICO:="MATEMATICAS"
      MATCH:={"Numeros aleatorios","Enteros y redondeo","Funciones comunes","Funciones miscelaneas","Trigonometria","Conjuntos"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funmath.help"
      XLEN:=len(MATCH)

   elseif nChoice==7
      TOPICO:="FECHAS Y HORAS"
      MATCH:={"Funciones de Hora","Funciones de fecha","Ejemplo"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-fundate.help"
      XLEN:=len(MATCH)

   elseif nChoice==8
      TOPICO:="CAMBIO DE BASE"
      MATCH:={"Bases numericas","Cambio de base"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funbase.help"
      XLEN:=len(MATCH)

   elseif nChoice==9
      TOPICO:="MANEJO DE BITS"
      MATCH:={"Manipulacion de bits","Funciones de bits","Ejemplo: operaciones con bits"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funbits.help"
      XLEN:=len(MATCH)

   elseif nChoice==10
      TOPICO:="ENTRADA Y SALIDA"
      MATCH:={"Funciones de consola","Mensajeria entre programas","Archivos","Ejemplo archivos binarios",;
              "Ejemplo entrada de datos"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funio.help"
      XLEN:=len(MATCH)

   elseif nChoice==11
      TOPICO:="STACKS"
      MATCH:={"Funciones estandar","Push y pop","Recuperacion","Queue y deque","Manipulacion de stacks","Ejemplo de uso"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funstack.help"
      XLEN:=len(MATCH)

   elseif nChoice==12
      TOPICO:="FUNCIONES MISCELANEAS"
      MATCH:={"Sentencias basicas","Funcion de contexto","Funcion FLAG","Castores de conversion","Funciones string estandar",;
              "Funciones XML","Funciones de sistema","Funciones de pantalla"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funmisc.help"
      XLEN:=len(MATCH)

   end
   if nChoice>0
      SETCOLOR(N2COLOR(cBARRA))
      @ TLINEA-XLEN-5,10 CLEAR TO TLINEA-4,SLINEA-10
      MENS:="MENU DEL TOPICO ["+TOPICO+"]"
      setpos(TLINEA-XLEN-5,int(SLINEA/2)-int(len(MENS)/2)); outstd(MENS)

     // MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
     // setcolor( 'GR+/N,N/GR+,,,W/N' )
      setcolor( 'W/N,N/W,,,W/N' )
      
      pELIGE:=ACHOICE(TLINEA-XLEN-4,11,TLINEA-4,SLINEA-11,MATCH, .T.)

      while inkey(,159)!=0 ; end
      MRESTSTATE(MOUSE) 
      MREAD:=hb_utf8tostr(MEMOREAD(FILEHELP))
      if pELIGE>0
         hCADI:=at("$$BEGIN "+MATCH[pELIGE],MREAD)
         lCADI:=len("$$BEGIN "+MATCH[pELIGE])
         HELPTOTAL:=substr(MREAD,hCADI+lCADI,len(MREAD))
         hCADF:=at("$$END "+MATCH[pELIGE],HELPTOTAL)
         HELPTOTAL:=substr(HELPTOTAL,1,hCADF-1)
         HELPTOTAL:=substr(MREAD,1,at("$$END INTRO",MREAD)-1)+HELPTOTAL
      else
         nChoice:=1 ; hb_keyPut(27)//MREAD
      end
   end
/*   
   if nChoice==1
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu.help"))
   elseif nChoice==2
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-preprocesador.help"))
   elseif nChoice==3
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-control.help"))
   elseif nChoice==4
      MATCH:={"Asignacion de strings","Despliegue",hb_utf8tostr("Tamaño"),"Concatenacion","Substrings","Replicacion",;
              "Insercion","Reemplazo","Busqueda","Archivos","Tokens","Miscelaneos"}
      FILEHELP:=PATH_HELP+_fileSeparator+"xu-funstring.help"
      
      SETCOLOR(N2COLOR(cBARRA))
      @ TLINEA-16,10 CLEAR TO TLINEA-3,SLINEA-10
      setpos(TLINEA-16,int(SLINEA/2)-9); outstd(hb_utf8tostr("Menú por tópicos"))

      MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
      setcolor( 'GR+/N,N/GR+,,,W/N' )

      pELIGE:=ACHOICE(TLINEA-15,11,TLINEA-3,SLINEA-11,MATCH, .T.)

      while inkey(,159)!=0 ; end
      MRESTSTATE(MOUSE) 
      MREAD:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funstring.help"))
      if pELIGE>0
         HELPTOTAL:=substr(MREAD,at("$$BEGIN"+MATCH[pELIGE]))
      
                               
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funstring.help"))
   elseif nChoice==5
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funmatrix.help"))
   elseif nChoice==6
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funmath.help"))
   elseif nChoice==7
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-fundate.help"))
   elseif nChoice==8
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funbase.help"))
   elseif nChoice==9
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funbits.help"))
   elseif nChoice==10
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funio.help"))
   elseif nChoice==11
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funstack.help"))
   elseif nChoice==12
                   HELPTOTAL:=hb_utf8tostr(MEMOREAD(PATH_HELP+_fileSeparator+"xu-funmisc.help"))
   end
   */
end
RETURN HELPTOTAL

FUNCTION GETSTRCTRLI(c1)
local c2,i,nOCURR1,nOCURR2,tmpPos1,tmpPos2,cTMP
local sw:=.T.  // espera un caracter hexadecimal

//? c1
for i:=1 to len(c1)
   if !(upper(substr(c1,i,1)) $ "0123456789ABCDEF ")
       sw:=.F.
       exit
   end
end
//? sw 
if !sw //i<len(c1)  // encontró un caracer no hexadecimal: asume caracteres ASCII: separar y convertir a HEXA.
   if "#" $ c1 .and. ";" $ c1  // chr
 //     ? "ENTRA"; inkey(0)
      nOCURR1:=NUMAT("#",c1)
      nOCURR2:=NUMAT(";",c1)
      //? cBUSCA, nOCURR1,nOCURR2
      if nOCURR1==nOCURR2
         for i:=1 to nOCURR1
            tmpPos1:=atnum("#",c1,1)
            tmpPos2:=atnum(";",c1,1)
            // ? tmpPos2,tmpPos1
            if tmpPos2>tmpPos1
               cTMP:=substr(c1,tmpPos1,tmpPos2-tmpPos1+1)
               //     ? cTMP
               cTMP:=charrem("#;",cTMP)
              // ? "TMP=",cTMP
              // ? "LIN=",c1
               if ISTNUMBER(cTMP)==1
                  c1:=substr(c1,1,tmpPos1-1) + chr(val(cTMP)) + substr(c1,tmpPos2+1,len(c1))
               end
              // ? "LIN=",c1; inkey(0)
            end
         end
      else
         c2:=""
      // ? cBUSCA; inkey(0)
      end
   end
   c2:=c1
else
   c2:=""
   cTMP:=numtoken(c1," ")
   for i:=1 to cTMP
      j:=upper(token(c1," ",i))   // obtengo primer numero
      c2+=chr(HEXATODEC(j))
   end
end

RETURN c2


FUNCTION _CALCULADORA(ARCHIVO)
LOCAL XLEN,pELIGE,OPERA:="",BUFFER:={},SWOPEXISTE:=.F.,MATCH
         WHILE .T.
             SETCOLOR(N2COLOR(cBARRA))
             @ TLINEA-11,0 CLEAR TO TLINEA,MAXCOL()
             setpos(TLINEA-11,2); dispout("CALCULATOR:   (SEE HELP FOR MORE...)")
             MSGOPE(" SELECT... *=EXPRESION !=RESULT")

             XLEN:=len(cRESULTBUFFER)
             
             if XLEN>0
                @ (TLINEA-12)-iif(XLEN>5,6,XLEN+1),0 CLEAR TO TLINEA-12,MAXCOL()
                setpos((TLINEA-12)-iif(XLEN>5,6,XLEN+1),2); dispout("RESULTS:")
                for i:=1 to XLEN
                    hb_keyPut(24)
                end
                hb_keyPut(27)
                setcolor( 'W+/N,N/W+,,,W+/N' )
                pELIGE:=ACHOICE((TLINEA-12)-iif(XLEN>5,5,XLEN),1,TLINEA-13,SLINEA-1,cRESULTBUFFER, .T.)
                   while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 
             end
             readinsert(.T.)
             setcolor( 'GR+/N,N/GR+,,,W+/N' )
             WHILE .T.
                    OPERA:=MEMOEDIT(OPERA,TLINEA-10,1,TLINEA-3,SLINEA-1,.T.,"MemoUDF")
                    c:=inkey()
                    if lastkey()==27
                       if LEN(ALLTRIM(OPERA))==0
                          exit
                       else
                          OPERA:=""
                       end
                    else
                       exit
                    end
             END
             SETCOLOR(N2COLOR(cBARRA))
             readinsert(.F.)
             OPERA:=ALLTRIM(OPERA)
             if substr(OPERA,len(OPERA),1)=="*"
                    // busca menú
                XLEN:=len(LISTAEXPRESION)
                if XLEN>0
                   MATCH:={}
                   for i:=1 to XLEN
                      AADD(MATCH,strtran(LISTAEXPRESION[i],chr(10)," ")) //+iif(len(cRESULTBUFFER)>0.and.," ==> "+cRESULTBUFFER[i],""))
                   end
                   SETCOLOR(N2COLOR(cBARRA))
                   @ TLINEA-(4+iif(XLEN>5,6,XLEN)),10 CLEAR TO TLINEA-3,SLINEA-10

                   setpos(TLINEA-(4+iif(XLEN>5,6,XLEN)),int(SLINEA/2)-10); outstd("List of expresions")

                   MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                   setcolor( 'GR+/N,N/GR+,,,W/N' )
                   pELIGE:=ACHOICE(TLINEA-(3+iif(XLEN>5,6,XLEN)),11,TLINEA-3,SLINEA-11,MATCH, .T.,"CTRLKVUSERFUNCTION")
                        
                   while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                   if pELIGE>0
                      if lastkey()==7 .or. lastkey()==8
                         ADEL(LISTAEXPRESION,pELIGE)
                         ASIZE(LISTAEXPRESION,len(LISTAEXPRESION)-1)
                         loop
                      else
                         OPERA:=substr(OPERA,1,len(OPERA)-1)+LISTAEXPRESION[pELIGE]
                      end
                   else
                      loop
                   end
                   ///   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                end
             elseif substr(OPERA,len(OPERA),1)=="!"   // busca un resultado y lo incluye
                XLEN:=len(cRESULTBUFFER)
                if XLEN>0
                   MATCH:={}
                   for i:=1 to XLEN
                      AADD(MATCH,strtran(cRESULTBUFFER[i],chr(10)," "))   ///+" <== ","")+LISTAEXPRESION[i])
                   end
                   SETCOLOR(N2COLOR(cBARRA))
                   @ TLINEA-(4+iif(XLEN>5,6,XLEN)),10 CLEAR TO TLINEA-3,SLINEA-10

                   setpos(TLINEA-(4+iif(XLEN>5,6,XLEN)),int(SLINEA/2)-8); outstd("List of results")

                   MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
                   setcolor( 'GR+/N,N/GR+,,,W/N' )
                   pELIGE:=ACHOICE(TLINEA-(3+iif(XLEN>5,6,XLEN)),11,TLINEA-3,SLINEA-11,MATCH, .T.,"CTRLKVUSERFUNCTION")
                        
                   while inkey(,159)!=0 ; end
                        MRESTSTATE(MOUSE) 

                   if pELIGE>0
                      OPERA:=substr(OPERA,1,len(OPERA)-1)+cRESULTBUFFER[pELIGE]
                   else
                      loop
                   end
                   ///   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XFIL1EDIT,XFIL2EDIT,XFILi)
                end
             elseif upper(OPERA)=="HELP"
                hb_keyPut(15);hb_keyPut(79)
                exit
             end
             if len(OPERA)>0
                // muestra la ventana con el resultado de la operacón, y vuelve al editor.
                BUFFER:=_CTRL_L_OPE(BUFFER,hb_utf8tostr(STRTRAN(OPERA,_CR,"")))
                if LEN(BUFFER)>0
                  // if BUFFER[1]!="<error>"
                      AADD(cRESULTBUFFER,strtran(BUFFER[1],chr(127),""))
                      AADD(LISTAEXPRESION,OPERA)
                     /* SWOPEXISTE:=.F.
                      for i:=1 to len(LISTAEXPRESION)
                         if OPERA == LISTAEXPRESION[i]
                            SWOPEXISTE:=.T.
                            exit
                         end
                      end
                      if !SWOPEXISTE
                         AADD(LISTAEXPRESION,OPERA)
                      end*/
                  // end
                end
             else
                exit
             end
          END
RETURN BUFFER

/*
 * Conversion Funtions
 *
 * Copyright 1999 Luiz Rafael Culik <Culik@sl.conex.net>
 */

FUNCTION DecToBin( nNumber )

   LOCAL cNewString := ""
   LOCAL nTemp

   DO WHILE nNumber > 0
      nTemp := nNumber % 2
      cNewString := SubStr( "01", nTemp + 1, 1 ) + cNewString
      nNumber := Int( ( nNumber - nTemp ) / 2 )
   ENDDO

   RETURN cNewString

FUNCTION DecToOctal( nNumber )

   LOCAL cNewString := ""
   LOCAL nTemp

   DO WHILE nNumber > 0
      nTemp := nNumber % 8
      cNewString := SubStr( "01234567", nTemp + 1, 1 ) + cNewString
      nNumber := Int( ( nNumber - nTemp ) / 8 )
   ENDDO
   if len(cNewString)==0
      cNewString:="0"
   end
   RETURN cNewString

FUNCTION DecToHexa( nNumber )

   LOCAL cNewString := ""
   LOCAL nTemp

   DO WHILE nNumber > 0
      nTemp := nNumber % 16
      cNewString := SubStr( "0123456789ABCDEF", nTemp + 1, 1 ) + cNewString
      nNumber := Int( ( nNumber - nTemp ) / 16 )
   ENDDO
   if len(cNewString)==0
      cNewString:="0"
   end
   RETURN cNewString

FUNCTION BinToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

   FOR nX := 1 TO nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "01" ) - 1 ) * ( 2 ^ ( nLen - nX ) )
   NEXT

   RETURN nNumber

FUNCTION OctalToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

   FOR nX := 1 TO nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "01234567" ) - 1 ) * ( 8 ^ ( nLen - nX ) )
   NEXT

   RETURN nNumber

FUNCTION HexaToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

   FOR nX := 1 TO nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "0123456789ABCDEF" ) - 1 ) * ( 16 ^ ( nLen - nX ) )
   NEXT

   RETURN nNumber
 


PROCEDURE _ELIMINA_BUFFER(BUFFER)
LOCAL j
IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
END
BUFFER:={}  // lo borro.
RETURN

FUNCTION _CTKVLLENABUFF(BUFFER)
LOCAL XNUMLIN:=0,XLEN:=0,i,XNUMCAR:=0,STRING:={}
XNUMLIN:=LEN(BUFFER)
XLEN:=LEN(hb_ntos((XNUMLIN)))

for i:=1 to XNUMLIN
   XNUMCAR+=len(alltrim(BUFFER[i]))
   //STRING+=BUFFER[i]+_CR
   if LEN(BUFFER[i])==0
      AADD(STRING,strzero(i,XLEN)+" : ")
   else
      AADD(STRING,strzero(i,XLEN)+" : "+BUFFER[i])
   end
end

RETURN {STRING,XNUMLIN,XNUMCAR}

PROCEDURE _CTRL_KV(BUFFER,TEXTO,TLINEA,lini,lfin,cini,TOPE,ARCHIVO,PASTEFROM,PASTETO,XF1,XF2,XFILi)
LOCAL STRING,RECEPT,i,XCLEAR,XNUMLIN:=0,XNUMCAR:=0,XLEN,pELIGE:=0,c,FIRST,cTMP,SW:=.F.,MULTIINS:={}
LOCAL STR:="",j
//STRING:=""
STRING:={}

RECEPT:=_CTKVLLENABUFF(@BUFFER)
STRING:=RECEPT[1]
XNUMLIN:=RECEPT[2]
XNUMCAR:=RECEPT[3]
FIRST:=1
if len(STRING)>0
   WHILE .T.
   SETCOLOR(N2COLOR(cBARRA))

   if XNUMLIN<int(TLINEA/2)
      XCLEAR:=LEN(BUFFER)+3
     // @ TLINEA-LEN(BUFFER),0 CLEAR TO TLINEA-3,SLINEA
   else
      XCLEAR:=int(TLINEA/2)+3
   end
   
   @ TLINEA-XCLEAR,0 CLEAR TO TLINEA-3,SLINEA
   setpos(TLINEA-XCLEAR,2); outstd("TOTAL LINE BUFFER="+hb_ntos(XNUMLIN)+" #CARS="+hb_ntos(XNUMCAR))
   MSGBARRA("^V=INS LINES  ^S=SEL LINES  ^J=JUMP TO LINE  BKSP|SUPR=DEL LINES  RETURN=INS 1 LINE",ARCHIVO,2)
   setcolor( 'GR+/N,N/GR+,,,W/N' )
  // MEMOEDIT(STRING,TLINEA-XCLEAR+1,0,TLINEA-3,SLINEA, .T.)
   

   pELIGE:=ACHOICE(TLINEA-XCLEAR+1,1,TLINEA-3,SLINEA-1,STRING,.T.,"CTRLKVUSERFUNCTION",FIRST)
   
   while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 
              
   if pELIGE!=0
      if lastkey()==13
         inkey()
         for i:=1 to len(BUFFER[pELIGE])
            c:=asc(substr(BUFFER[pELIGE],i,1))
            if c!=3 .and. c!=127
               hb_keyPut(c)
            else
               exit
            end
         end
         if c==3 .or. c!=127
            hb_keyPut(13)
         end
         if !SW_CODESP
            hb_keyPut(500)  // código de cambio de SW_CODESP
            SW_CODESP:=.T.
         end
         exit
      elseif lastkey()==10   // ctrl-j
         hb_keyPut(10)
         hb_keyPut(74)
         for i:=1 to len(BUFFER[pELIGE])
            c:=asc(substr(BUFFER[pELIGE],i,1))
            if c!=3 .and. c!=127
               hb_keyPut(c)
            else
               exit
            end
         end
         hb_keyPut(13)  // el enter
         SWCTRLJCTRKV:=.T.
         exit
      elseif lastkey()==19   // ctrl-s
         inkey()
         XLEN:=len(MULTIINS)
         PASTEFROM:=0
         SW:=.T.
         for i:=1 to XLEN
            if MULTIINS[i]==pELIGE
               STRING[pELIGE]:=substr(STRING[pELIGE],4,len(STRING[pELIGE]))
               ADEL(MULTIINS,i)
               ASIZE(MULTIINS,--XLEN)
               SW:=.F.
            end
         end
         if SW
            STRING[pELIGE]:=">>>"+STRING[pELIGE]
            AADD(MULTIINS,pELIGE)
         end
         FIRST:=pELIGE
         loop
      elseif lastkey()==22  // ctrl v
         inkey()
         IF len(MULTIINS)==0
         if !SW
            SW:=.T.
            PASTEFROM:=pELIGE
            STRING[pELIGE]:=">>>"+STRING[pELIGE]
            FIRST:=pELIGE
            loop
         else
            SW:=.F.
            if pELIGE==PASTEFROM
               STRING[pELIGE]:=substr(STRING[pELIGE],4,len(STRING[pELIGE]))
               FIRST:=pELIGE
               loop
            end
            PASTETO:=pELIGE
            if PASTETO<PASTEFROM
               cTMP:=PASTEFROM
               PASTEFROM:=PASTETO
               PASTETO:=cTMP
            end
            hb_keyPut(11)
            hb_keyPut(85)
            exit
         end
         ELSE
            XLEN:=len(MULTIINS)
            for j:=1 to XLEN
               STR:=BUFFER[MULTIINS[j]]
               for i:=1 to len(STR) 
                  c:=asc(substr(STR,i,1))
                  if c!=3 .and. c!=127
                     hb_keyPut(c)
                  else
                     exit
                  end
               end
               if c==3 .or. c!=127
                  hb_keyPut(13)
               else
                  hb_keyPut(32)
               end
            end
            if !SW_CODESP
               hb_keyPut(500)  // código de cambio de SW_CODESP
               SW_CODESP:=.T.
            end
            exit
         END
   /*      
         SETCOLOR(N2COLOR(cBARRA))
         @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
         setpos(TLINEA-2,2); outstd(" PASTE FROM "+hb_ntos(pELIGE))
         setpos(TLINEA-2,21);outstd(" TO? ")
         MSGINPUT("")
         PASTEFROM:=pELIGE
         PASTETO:="     "
         PASTETO:=val(INPUTLINE(PASTETO,5,TLINEA-2,26,"N"))
         if PASTETO>XNUMLIN
            PASTETO:=XNUMLIN
         end
         
         if PASTETO>=PASTEFROM
            if lastkey()!=3
               hb_keyPut(11)
               hb_keyPut(85)
            end
         elseif PASTETO>0
            cTMP:=PASTEFROM
            PASTEFROM:=PASTETO
            PASTETO:=cTMP
            if lastkey()!=3
               hb_keyPut(11)
               hb_keyPut(85)
            end
         end
         exit */
      elseif lastkey()==8
         inkey()
         XLEN:=len(MULTIINS)
         for i:=1 to XLEN
            if MULTIINS[i]==pELIGE
               ADEL(MULTIINS,i)
               ASIZE(MULTIINS,--XLEN)
               exit
            end
         end
         for i:=1 to XLEN
            if MULTIINS[i]>pELIGE
               MULTIINS[i]:=MULTIINS[i]-1
            end
         end
         
         if pELIGE==PASTEFROM
            PASTEFROM:=0
            PASTETO:=0
            SW:=.F.
         elseif pELIGE<PASTEFROM
            --PASTEFROM
         end
         
        // MULTIINS:={}
         if pELIGE>1
            ADEL(BUFFER,--pELIGE)
         else
            ADEL(BUFFER,pELIGE)
         end
         
         --XNUMLIN
         ASIZE(BUFFER,XNUMLIN)
         RECEPT:=_CTKVLLENABUFF(@BUFFER)
         STRING:=RECEPT[1]
         XNUMLIN:=RECEPT[2]
         XNUMCAR:=RECEPT[3]
         FIRST:=pELIGE
         if FIRST>XNUMLIN
            FIRST:=XNUMLIN
         end
         
         if LEN(MULTIINS)>0
         for i:=1 to LEN(BUFFER)
            for j:=1 to LEN(MULTIINS)
               if MULTIINS[j]==i
                  STRING[i]:=">>>"+STRING[i]
                  exit
               end
            end
         end
         end
         
         if PASTEFROM>0
            STRING[PASTEFROM]:=">>>"+STRING[PASTEFROM]
         end
         
         VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XF1,XF2,XFILi)
      //   PASTEFROM:=0
      //   PASTETO:=0 
      elseif lastkey()==7 // ctrl-g ctrl-h
         inkey()
       //  MULTIINS:={}
         XLEN:=len(MULTIINS)
         for i:=1 to XLEN
            if MULTIINS[i]==pELIGE
               ADEL(MULTIINS,i)
               ASIZE(MULTIINS,--XLEN)
               exit
            end
         end
         for i:=1 to XLEN
            if MULTIINS[i]>pELIGE
               MULTIINS[i]:=MULTIINS[i]-1
            end
         end
         
         if pELIGE==PASTEFROM
            PASTEFROM:=0
            PASTETO:=0
            SW:=.F.
         elseif pELIGE<PASTEFROM
            --PASTEFROM
         end
         
         ADEL(BUFFER,pELIGE)
         --XNUMLIN
         ASIZE(BUFFER,XNUMLIN)
         RECEPT:=_CTKVLLENABUFF(@BUFFER)
         STRING:=RECEPT[1]
         XNUMLIN:=RECEPT[2]
         XNUMCAR:=RECEPT[3]
         FIRST:=pELIGE
         if FIRST>XNUMLIN
            FIRST:=XNUMLIN
         end
         
         if LEN(MULTIINS)>0
            for i:=1 to LEN(BUFFER)
               for j:=1 to LEN(MULTIINS)
                  if MULTIINS[j]==i
                     STRING[i]:=">>>"+STRING[i]
                     exit
                  end
               end
            end
         end
         
         if PASTEFROM>0
            STRING[PASTEFROM]:=">>>"+STRING[PASTEFROM]
         end
            
         VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XF1,XF2,XFILi)
        /* SETCOLOR(N2COLOR(cBARRA))
         @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
         setpos(TLINEA-2,2); outstd(" DEL FROM "+hb_ntos(pELIGE))
         setpos(TLINEA-2,19);outstd(" TO? ")
         MSGINPUT("")
         PASTEFROM:=pELIGE
         PASTETO:="     "
         PASTETO:=val(INPUTLINE(PASTETO,5,TLINEA-2,24,"N"))
         if PASTETO>XNUMLIN
            PASTETO:=XNUMLIN
         end
         if PASTETO>=PASTEFROM
            if lastkey()!=3
               pELIGE:=PASTEFROM
               for i:=PASTEFROM to PASTETO
                  ADEL(BUFFER,pELIGE)
               end
               ASIZE(BUFFER,XNUMLIN-(PASTETO-PASTEFROM+1))
            end
         end */
        // PASTEFROM:=0
        // PASTETO:=0 
      end
   else
      exit
   end
   END
   VISUALIZA_TEXTO(@TEXTO,lini,lfin,cini,SLINEA,TOPE,XF1,XF2,XFILi)
   BarraTitulo(ARCHIVO)
   SETCOLOR(N2COLOR(cTEXTO))
   ///setpos(py,px)

else
   SETCOLOR(N2COLOR(cBARRA))
   @ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
   setpos(TLINEA-1,int(SLINEA/2)-8);outstd("BUFFER IS CLEAN")
   setpos(TLINEA  ,int(SLINEA/2)-15);outstd("(Press any key to continue...)")
   inkey(0)
   BarraTitulo(ARCHIVO)
             
   SETCOLOR(N2COLOR(cTEXTO))
end
RETURN

FUNCTION CTRLKVUSERFUNCTION(nMode, nCurElement, nRowPos)
LOCAL nRetVal := AC_CONT // Default, Continue
LOCAL nKey := LASTKEY()

nRetVal := AC_CONT // Continue ACHOICE()
DO CASE
CASE nMode == AC_HITTOP // Attempt to go past Top
   ;
CASE nMode == AC_HITBOTTOM // Attempt to go past Bottom
   ;
CASE nMode == AC_EXCEPT // Key Exception
   DO CASE
      CASE nKey == K_RETURN // If RETURN key, select
        nRetVal := AC_SELECT
      CASE nKey == K_ESC // If ESCAPE key, abort
         nRetVal := AC_ABORT
      case nKey == 22
         nRetVal := AC_SELECT
         hb_keyPut(22)
      case nKey == 7 
         nRetVal := AC_SELECT
         hb_keyPut(7)
      case nKey == 8
         nRetVal := AC_SELECT
         hb_keyPut(8)
      case nKey == 19
         nRetVal := AC_SELECT
         hb_keyPut(19)
      case nKey == 10  // CTRL-J va a la línea
         nRetVal := AC_SELECT
         hb_keyPut(10)
      OTHERWISE
         nRetVal := AC_GOTO // Otherwise, go to item
   ENDCASE
ENDCASE

RETURN nRetVal


PROCEDURE _CTRL_KI(s,p)
LOCAL SWINICIOLIN,i
SWINICIOLIN:=.F.
for i:=1 to len(s)
   if s[i]!=" "
      SWINICIOLIN:=.T.
      exit
   end
end
if SWINICIOLIN
   if i<p
      pushkey(19,p-i)
   else
      pushkey(4,i-p)
   end
end
RETURN

PROCEDURE _CTRL_KP(s,p)
LOCAL SWINICIOLIN,i
SWINICIOLIN:=.F.
for i:=1 to len(s)
   if s[i]!=" "
      SWINICIOLIN:=.T.
      exit
   end
end
if SWINICIOLIN
   if i<p
      // ubica el principio de la linea
      if p>1
         pushkey(19,p-1)
      end
      hb_keyPut(11)
      hb_keyPut(73)   //9
      pushkey(32,p-i)             
      hb_keyPut(24)
   elseif i>p
      pushkey(7,i-p)
      hb_keyPut(24)
   end
end
RETURN

PROCEDURE _CTRL_KB(BUFFER,s,p,px)
LOCAL STRING,j

/*IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
   //// RELEASE BUFFER
END
BUFFER:={} */  // borra el contenido del buffer.
// guarda caracteres en el buffer, y
// borra.
STRING:=""
/*if p>len(s)
   --p;--px
end*/
for j:=1 to p-1
   STRING+=s[j]
end
STRING+=chr(127)  // avisa para que no autocomplete con ^KU
AADD(BUFFER,STRING)

// borra
//pushkey(8,p-1) //-1)

RETURN

PROCEDURE _CTRL_KE(BUFFER,s,p)
LOCAL j,STRING
/*IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
END
BUFFER:={} */   // borra el contenido del buffer.
// guarda caracteres en el buffer, y
// borra.
STRING:=""
for j:=p to len(s)
   STRING+=s[j]
end
STRING+=chr(127)  // avisa para que no autocomplete con ^KU
AADD(BUFFER,STRING)
// borra
pushkey(7,len(s)-p+1)

RETURN


FUNCTION _CTRL_LMENU(TLINEA)
LOCAL POS,HFIL,cCOLOR
POS:=12
HFIL:=2 
@ TLINEA-2, HFIL    PROMPT "1:SUM"
@ TLINEA-2, HFIL+8  PROMPT "2:MEAN"
@ TLINEA-2, HFIL+15 PROMPT "3:STD"
@ TLINEA-2, HFIL+21 PROMPT "4:VAR"
cCOLOR:=SETCOLOR(N2COLOR(cMENU))
@ TLINEA-2, HFIL+27 SAY "|"
SETCOLOR(cCOLOR)
@ TLINEA-2, HFIL+29 PROMPT "5:SQRT"
@ TLINEA-2, HFIL+36 PROMPT "6:SQR"
@ TLINEA-2, HFIL+42 PROMPT "7:LOG"
@ TLINEA-2, HFIL+48 PROMPT "8:LN"
@ TLINEA-2, HFIL+53 PROMPT "9:ABS"
@ TLINEA-2, HFIL+59 PROMPT "O:OPE"
@ TLINEA-2, HFIL+65 PROMPT "T:DEFTOK"
@ TLINEA-2, HFIL+74 PROMPT "R:DEFROUND ("+hb_ntos(DEFROUND)+")"
cCOLOR:=SETCOLOR(N2COLOR(cMENU))
@ TLINEA-2, HFIL+90 SAY "|"
SETCOLOR(cCOLOR)
@ TLINEA-2, HFIL+92 PROMPT "L:LINSPC"  // añadir pad:
@ TLINEA-2, HFIL+101 PROMPT "S:SEQ"
@ TLINEA-2, HFIL+107 PROMPT "H:HEADER"
//  cCOLOR:=SETCOLOR(N2COLOR(cTEXTO))
//  @ TLINEA-2, HFIL+40 SAY "|"
//  SETCOLOR(cCOLOR)
//  @ TLINEA-2, HFIL+53 PROMPT "PADDING"  // pad:L,R,C relleno espacio. lo que está en el buffer. L 10
              
MENU TO nChoice
RETURN nChoice

FUNCTION _SELECTENVVAR(TLINEA,ARCHIVO,TIPO)
LOCAL STRING,MENUMATCH,cBUFF,NL,TMPMENU,I,pELIGE

cBUFF:=FUNFSHELL("env",3)
NL:=STRCUENTALINEAS(cBUFF)
///? NL; inkey(0)
TMPMENU:=GETLINEAS(cBUFF,NL,LEN(cBUFF),2048)
///? LEN(TMPMENU); inkey(0)
MENUMATCH:=ARRAY(NL)
VARENV:=ARRAY(NL)
CONENV:=ARRAY(NL)
FOR I:=1 TO NL
   VARENV[I]:=ALLTRIM(SUBSTR(TMPMENU[I],1,AT("=",TMPMENU[I])-1))
   MENUMATCH[I]:=padl(VARENV[I],32)+"  "
   CONENV[I]:=SUBSTR(TMPMENU[I],AT("=",TMPMENU[I])+1,LEN(TMPMENU[I]))
   MENUMATCH[I]+=CONENV[I]
END

SETCOLOR(N2COLOR(cBARRA))
@ TLINEA-(int(TLINEA/2)),0 CLEAR TO TLINEA-3,SLINEA
setpos(TLINEA-(int(TLINEA/2)),int(SLINEA/2)-15); outstd(" Select an Environment Var ")                   
MSGBARRA("SELECT A POSITION WITH UP|DOWN ARROW, AND PRESS RETURN",ARCHIVO,0)
setcolor( 'GR+/N,N/GR+,,,W/N' )
pELIGE:=ACHOICE(TLINEA-(int(TLINEA/2))+1,1,TLINEA-3,SLINEA-1,MENUMATCH,.T.)

while inkey(,159)!=0 ; end
              MRESTSTATE(MOUSE) 
              
SETCOLOR(N2COLOR(cTEXTO))

if pELIGE>0
   if TIPO==0
      STRING:=VARENV[pELIGE]
   else
      STRING:=CONENV[pELIGE]
   end
else
   STRING:=""
end
RETURN STRING

FUNCTION PONEFECHA()
LOCAL meses:={"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"}
LOCAL dias:={"Domingo", "Lunes","Martes",hb_utf8tostr("Miércoles"),"Jueves","Viernes",hb_utf8tostr("Sábado")}
LOCAL fecha,sFec
//hb_langSelect( "es" )
fecha:=date()
sFec:=dias[DOW(fecha)]+" "+hb_ntos((DAY(fecha)))+" de "+meses[MONTH(fecha)]+" de "+hb_ntos((YEAR(fecha)))+", "+time()
//sFec:=cDow(fecha)+" "+hb_ntos((Day(fecha)))+" de "+cMonth(fecha)+" de "+hb_ntos((YEAR(fecha)))+", "+time()
RETURN sFec

PROCEDURE _CTRL_L_INSHEADER(BUFFER,ARCHIVO)
LOCAL j, fecha,sfec,EXT, COM:="", sCOM:=""
LOCAL meses:={"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"}
IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
END
BUFFER:={}
EXT:=substr(ARCHIVO,rat(".",ARCHIVO)+1,len(ARCHIVO))
if EXT=="c" .or. EXT=="cpp" .or. EXT=="h" .or. EXT=="def" .or. EXT=="xu"
   sCOM:="/**************************************************"
   COM:=" *"
elseif EXT=="m" .or. EXT=="tex"
   sCOM:="%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
   COM:="%"
elseif EXT=="py" .or. EXT=="sh" .or. EXT=="ksh"
   sCOM:="###################################################"
   COM:="#"
end

AADD(BUFFER,sCOM)
AADD(BUFFER,COM+"  Prorama   : ")
AADD(BUFFER,COM+"  Autor     : ")
AADD(BUFFER,COM+"  Sistema   : "+OS())
fecha:=date()
sFec:=meses[MONTH(fecha)]+" "+hb_ntos((DAY(fecha)))+", "+hb_ntos((YEAR(fecha)))
AADD(BUFFER,COM+"  Fecha ini : "+sfec+"; "+TIME())
AADD(BUFFER,COM+hb_utf8tostr("  Descripción:"))
AADD(BUFFER,COM+"   ")
AADD(BUFFER,COM+"   Este programa blah blah blah...")
AADD(BUFFER,COM+"   ")
if len(COM)==2
   AADD(BUFFER," **************************************************/")
else
   AADD(BUFFER,sCOM)
end

RETURN

PROCEDURE _CTRL_L_SEQ(BUFFER,TLINEA)
LOCAL AX,BX,CX,DX,i,j,nPOS,cLEN
CX:=BX:=AX:=SPACE(9)
DX:=""
IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
END
BUFFER:={}
setpos(TLINEA-1,2); dispout("FROM:")
setpos(TLINEA-1,18); dispout("INC:")
setpos(TLINEA-1,33); dispout("#ELEMENTS:")
setpos(TLINEA-1,54); dispout("PAD:")
CX:=val(INPUTLINE(CX,9,TLINEA-1,8,"N"))
if lastkey()==3
   RETURN
end
BX:=val(INPUTLINE(BX,9,TLINEA-1,23,"N"))
if lastkey()==3
   RETURN
end
AX:=val(INPUTLINE(AX,9,TLINEA-1,44,"N"))
if lastkey()==3
   RETURN
end
DX:=INPUTLINE(DX,9,TLINEA-1,59,"s")
if lastkey()==3
   RETURN
end
nPOS:=SEQUENCE( CX, BX, AX )
cLEN:=len(nPOS)
if len(alltrim(DX))==0
   for i:=1 to cLEN
      AADD(BUFFER,hb_ntos((nPOS[i]))+chr(127) )
   end
else
   AX:=substr(DX,1,1)  // tipo pad
   BX:=substr(DX,2,1)  // caracter de relleno
   CX:=val(substr(DX,3,len(DX))) // espacio
   if AX=="L"
      for i:=1 to cLEN
         AADD(BUFFER,padl(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   elseif AX=="R"
      for i:=1 to cLEN
         AADD(BUFFER,padr(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   else
      for i:=1 to cLEN
         AADD(BUFFER,padc(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   end
end
RETURN

PROCEDURE _CTRL_L_LINSPC(BUFFER,TLINEA)
LOCAL AX,BX,CX,DX,i,j,nPOS,cLEN

CX:=BX:=AX:=SPACE(9)
DX:=""
IF LEN(BUFFER)>0
   FOR j:=1 to LEN(BUFFER)
      RELEASE BUFFER[j]
   END
END
BUFFER:={}
setpos(TLINEA-1,2); dispout("FROM:")
setpos(TLINEA-1,18); dispout("TO:")
setpos(TLINEA-1,32); dispout("#ELEMENTS:")
setpos(TLINEA-1,54); dispout("PAD:")
//cCOLOR:=SETCOLOR(N2COLOR(cTEXTO))
CX:=val(INPUTLINE(CX,9,TLINEA-1,8,"N"))
if lastkey()==3
   RETURN
end
BX:=val(INPUTLINE(BX,9,TLINEA-1,22,"N"))
if lastkey()==3
   RETURN
end
AX:=val(INPUTLINE(AX,9,TLINEA-1,43,"N"))
if lastkey()==3
   RETURN
end
DX:=INPUTLINE(DX,9,TLINEA-1,59,"s")
if lastkey()==3
   RETURN
end
nPOS:=SEQSP( CX, BX, AX )
cLEN:=len(nPOS)
if len(alltrim(DX))==0
   for i:=1 to cLEN
      AADD(BUFFER,hb_ntos((nPOS[i]))+chr(127) )
   end
else
   AX:=substr(DX,1,1)  // tipo pad
   BX:=substr(DX,2,1)  // caracter de relleno
   CX:=val(substr(DX,3,len(DX))) // espacio
   if AX=="L"
      for i:=1 to cLEN
         AADD(BUFFER,padl(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   elseif AX=="R"
      for i:=1 to cLEN
         AADD(BUFFER,padr(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   else
      for i:=1 to cLEN
         AADD(BUFFER,padc(hb_ntos((nPOS[i])),CX,BX)+chr(127) )
      end
   end
end
RETURN

FUNCTION _CTRLL_OBTIENELISTA(DX)
LOCAL Q,i,j,c,fun,ctap:=0,num,R,str,long,k,cTMP,sw,tmpi:=0,ctmpi:=0,ctpar:=0,strfun:="",SWFUN:=.F.
Q:={}  // pila de evaluacion
R:={}  // pila de valores

/* saco los comentarios */
cTMP:=""
i:=1
while i<=len(DX)
   c:=substr(DX,i,1)
   
   if c=="/"
      ++i
      c:=substr(DX,i,1)
      if c=="*"
         ++i
         while i<=len(DX)
            c:=substr(DX,i,1)
            if c=="*"
               if (c:=substr(DX,++i,1))=="/"
                  c:=""
                  exit
               end
            end
            ++i
         end
      else
         --i
         c:=substr(DX,i,1)
      end
   elseif c==chr(34)
      cTMP+=c
      ++i
      while i<=len(DX)
         c:=substr(DX,i,1)
         cTMP+=c
         if c==chr(34)
            exit
         end
         ++i
      end
      ++i; loop
   end
   cTMP+=c
   ++i
end

//? cTMP ; inkey(0)
DX:=cTMP
cTMP:=""


/* algunos reemplazos necesarios */
if "NULL" $ DX   // iteración no cancela con líneas nulas
   SWNOTNUL:=.T.
   DX:=strtran(DX,"NULL","")
end
if "KEEP" $ DX    // mantiene el resultado en el buffer, eliminando los datos originales.
   SWRECBUFFER:=.F.
   DX:=strtran(DX,"KEEP","")
end
if "VOID" $ DX
   SWKEEPVACIO:=.T.
   DX:=strtran(DX,"VOID","")
end
if "NOBUFF" $ DX
   SWNOBUFFER:=.T.
   DX:=strtran(DX,"NOBUFF","")
end
if "NOSEN" $ DX
   SWSENSITIVE:=.F.
   DX:=strtran(DX,"NOSEN","")
end
if "DEG" $ DX
   SWRADIANES:=.F.
   DX:=strtran(DX,"DEG","")
end
if "_alpha_" $ DX
   DX:=strtran(DX,"_alpha_",hb_utf8tostr(chr(34)+"abcdefghijklmnñopqrstuvwxyz"+chr(34)))
end
if "_ALPHA_" $ DX
   DX:=strtran(DX,"_ALPHA_",hb_utf8tostr(chr(34)+"ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"+chr(34)))
end
if "_number_" $ DX
   DX:=strtran(DX,"_number_",chr(34)+"0123456789"+chr(34))
end

/* variables globales? */



/*   */
////DX:=strtran(DX,"?(","IF(")
DX:=strtran(DX,"match{","MATCH(#,")
//DX:=strtran(DX,"(--","(")
DX:=strtran(DX,"(-","(0-")  // ajusto negativos
//DX:=strtran(DX,"(++","INC(")
DX:=strtran(DX,"range{","RANGE(#,") 
DX:=strtran(DX,"ins{","INS(#,") 
DX:=strtran(DX,"#{","LIN(")  // linea
DX:=strtran(DX,"trea{","TREA(#,")
DX:=strtran(DX,"treb{","TREB(#,")
DX:=strtran(DX,"tre{","TRE(#,")
//DX:=strtran(DX,"(&","VAL(")
//DX:=strtran(DX,"($","STR(")
//DX:=strtran(DX,"'{","CH(")  // chr
//DX:=strtran(DX,"&{","ASC(")  // asc
DX:=strtran(DX,"{*","CP(#,")
DX:=strtran(DX,"rp{","RP(#,")
DX:=strtran(DX,"{+","PTRP(#,")  // avanza puntero del string
DX:=strtran(DX,"{-","PTRM(#,")  // retorcede puntero extremo de string
DX:=strtran(DX,"mon{","MON(#,")
DX:=strtran(DX,"${","TK(#,")
DX:=strtran(DX,"round{","ROUND(#,")
DX:=strtran(DX,"sub{","SUB(#,")
DX:=strtran(DX,"tra{","TRA(#,")
DX:=strtran(DX,"trb{","TRB(#,")
DX:=strtran(DX,"tr{","TR(#,")
DX:=strtran(DX,"rpc{","RPC(#,")
DX:=strtran(DX,"pc{","PC(#,")
DX:=strtran(DX,"pr{","PR(#,")
DX:=strtran(DX,"pl{","PL(#,")
DX:=strtran(DX,"msk{","MSK(#,")
DX:=strtran(DX,"sat{","SAT(#,")
DX:=strtran(DX,"rat{","RAT(#,")
DX:=strtran(DX,"ata{","ATA(#,")
DX:=strtran(DX,"afa{","AFA(#,")
DX:=strtran(DX,"at{","AT(#,")
DX:=strtran(DX,"af{","AF(#,")
DX:=strtran(DX,"dc{","DC(#,")
DX:=strtran(DX,"one{","ONE(#,")
DX:=strtran(DX,"tpc{","TPC(#,")
DX:=strtran(DX,"tklet{","TKLET(#,")
///? DX; inkey(0)
/**/
i:=1
long:=LEN(DX)
while i <= long
   c:=substr(DX,i,1)
   if c==" "
      ++i
      loop
   end
   if SWFUN
      if c!="("
         _ERROR("CONV: DEBE IR UN PARENTESIS AQUI: "+substr(DX,1,i)+"<<")
         RETURN {}
      end
   end
   if c=="(" 
      if SWFUN
         SWFUN:=.F.
      end
      AADD(Q,c)
      AADD(R,c)
      ++ctap
   elseif  c==")"
      AADD(Q,c)
      AADD(R,c)
      --ctap
      if ctap<0
         _ERROR("CONV: PARENTESIS DESBALANCEADOS")
         RETURN {}
      end
   elseif c==">"
      c+=substr(DX,++i,1)
      if c==">>"   // desplazamiento derecha
         AADD(Q,c)
         AADD(R,c)
      elseif c==">="
         AADD(Q,c)
         AADD(R,c)
      else
         c:=">"
         AADD(Q,c)
         AADD(R,c)
         --i
       //  _ERROR("CONV: SIMBOLO NO RECONOCIDO "+c)
      //   RETURN {}
      end
   elseif c=="!"
      c+=substr(DX,++i,1)
      if c=="!="   // distinto a 
         AADD(Q,"<>")
         AADD(R,"<>")
      else
         --i
      end
   elseif c=="<"
      c+=substr(DX,++i,1)
      if c=="<<"   // desplazamiento izquierda
         AADD(Q,c)
         AADD(R,c)
      elseif c=="<=" .or. c=="<>"
         AADD(Q,c)
         AADD(R,c)
      else
         c:="<"
         AADD(Q,c)
         AADD(R,c)
         --i 
       //  _ERROR("CONV: SIMBOLO NO RECONOCIDO "+c)
       //  RETURN {}
      end
   elseif c==chr(126)   // not
      AADD(Q,c)
      AADD(R,c)
   
   elseif c=="?"   // un IF má seguro y eficiente.  exp? expr-1 [: expr-2] . Salta hasta ":"
      AADD(Q,"JNZ"); AADD(R,"JNZ")
      AADD(Q,"("); AADD(R,"(")
      AADD(Q,")"); AADD(R,")")
      
   elseif c==":"    // else
      AADD(Q,"ELSE"); AADD(R,"ELSE")
      AADD(Q,"("); AADD(R,"(")
      AADD(Q,")"); AADD(R,")")
   
   elseif c==";" .or. c=="."  // endif
      AADD(Q,"ENDIF"); AADD(R,"ENDIF")
      AADD(Q,"("); AADD(R,"(")
      AADD(Q,")"); AADD(R,")")

   elseif c=="#"    // puede ser numero de línea de buffer si es acompañado de un numero #1, #3...
      tmpi:=i-1  // por si es una asignación
      ++i
      num:=""
      while i<=long
         c:=substr(DX,i,1)
         if c==" "
            ++i
            loop
         end
         if isdigit(c)
            num+=c
            ++i
         else
            --i
            exit
         end
      end
      if len(num)==0  // es un parámetro de linea procesada.
         AADD(Q,"N")
         AADD(R,"#")

      elseif c=="("   // es una asignación
         // busco hasta donde asigna:
         ctmpi:=i
         strfun:=""
         i+=2  // para saltarme primer "("
         ctpar:=1
         while i<=long
            c:=substr(DX,i,1)
            strfun+=c
            if c=="("
               ++ctpar
            elseif c==")"
               --ctpar
               if ctpar==0
                  exit
               end
               if ctpar<0
                  _ERROR("CONV: PARENTESIS DESBALANCEADOS: "+substr(DX,1,i)+"<<")
                  RETURN {}
               end
            end
            ++i
         end
         DX:=substr(DX,1,tmpi)+"LET("+num+","+strfun+substr(DX,++i,len(DX))
         long:=LEN(DX)
         i:=tmpi  // restauro indice para que lea "TKLET"
       //  ? "DX?=", DX; inkey(0)
      else
         if ISTNUMBER(num)!=1
            _ERROR("CONV: NUMERO DE LINEA NO VALIDO: "+substr(DX,1,i)+"<<")
            RETURN {}
         else
            AADD(Q,"LIN"); AADD(R,"LIN")
            AADD(Q,"("); AADD(R,"(")
            AADD(Q,"N");  AADD(R,val(num))
            AADD(Q,")"); AADD(R,")")
         end
      end
/*   elseif c=="#"   // puede ser numero de línea si es acompañado de un numero #1, #3...
      ++i
      
      num:=""
      while i<=long
         c:=substr(DX,i,1)
         if isdigit(c)
            num+=c
            ++i
         else
            --i
            exit
         end
      end
      if len(num)==0  // es un parámetro
         AADD(Q,"N")
         AADD(R,"#")
      else
         if ISTNUMBER(num)!=1
            _ERROR("CONV: NUMERO DE LINEA NO VALIDO #<<"+num+">>")
            RETURN {}
         end
         AADD(Q,"LIN"); AADD(R,"LIN")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,"N");  AADD(R,val(num))
         AADD(Q,")"); AADD(R,")")
      end
     
   elseif c=="$"   // puede ser un token del tipo AWK $1, $2,...$n
      ++i
      num:=""
      while i<=long
         c:=substr(DX,i,1)
         if isdigit(c)
            num+=c
            ++i
         else
            --i
            exit
         end
      end
      if ISTNUMBER(num)!=1 .or. len(num)==0
         _ERROR("CONV: NUMERO DE TOKEN NO VALIDO #<<"+num+">>")
         RETURN {}
      end
      AADD(Q,"TK"); AADD(R,"TK")
      AADD(Q,"("); AADD(R,"(")
      AADD(Q,"N");  AADD(R,"#")
      AADD(Q,"N");  AADD(R,val(num))
      AADD(Q,")"); AADD(R,")") */
   elseif c=="$"    // puede ser un token del tipo AWK $1, $2,...$n o un cambio de token $n(valor)
      tmpi:=i-1  // por si es una asignación
      ++i
      num:=""
      while i<=long
         c:=substr(DX,i,1)
         if c==" "
            ++i
            loop
         end
         if isdigit(c)
            num+=c
            ++i
         else
            --i
            exit
         end
      end
      if ISTNUMBER(num)!=1 .or. len(num)==0
         _ERROR("CONV: NUMERO DE TOKEN NO VALIDO: "+substr(DX,1,i)+"<<")
         RETURN {}
      end
      if c=="("   // es una asignación
         // busco hasta donde asigna:
         ctmpi:=i
         strfun:=""
         i+=2  // para saltarme primer "("
         ctpar:=1
         while i<=long
            c:=substr(DX,i,1)
            strfun+=c
            if c=="("
               ++ctpar
            elseif c==")"
               --ctpar
               if ctpar==0
                  exit
               end
               if ctpar<0
                  _ERROR("CONV: PARENTESIS DESBALANCEADOS: "+substr(DX,1,i)+"<<")
                  RETURN {}
               end
            end
            ++i
         end
         DX:=substr(DX,1,tmpi)+"TKLET(#,"+num+","+strfun+substr(DX,++i,len(DX))
         long:=LEN(DX)
         i:=tmpi  // restauro indice para que lea "TKLET"
       //  ? "DX?=", DX; inkey(0)
      else
         AADD(Q,"TK"); AADD(R,"TK")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,"N");  AADD(R,"#")
         AADD(Q,"N");  AADD(R,val(num))
         AADD(Q,")"); AADD(R,")")
      end
   elseif c=="@"    // variable de registro.
      tmpi:=i-1  // por si es una asignación
      ++i
      num:=""
      while i<=long
         c:=substr(DX,i,1)
         if c==" "
            ++i
            loop
         end
         if isdigit(c)
            num+=c
            ++i
         else
            --i
            exit
         end
      end
      if ISTNUMBER(num)!=1 .or. len(num)==0
         _ERROR("CONV: NUMERO DE REGISTRO NO VALIDO #<<"+num+">>")
         RETURN {}
      end
      if c=="("   // es una asignación
         // busco hasta donde asigna:
         ctmpi:=i
         strfun:=""
         i+=2  // para saltarme primer "("
         ctpar:=1
         while i<=long
            c:=substr(DX,i,1)
            strfun+=c
            if c=="("
               ++ctpar
            elseif c==")"
               --ctpar
               if ctpar==0
                  exit
               end
               if ctpar<0
                  _ERROR("CONV: PARENTESIS DESBALANCEADOS")
                  RETURN {}
               end
            end
            ++i
         end
         DX:=substr(DX,1,tmpi)+"MOV("+num+","+strfun+substr(DX,++i,len(DX))
         long:=LEN(DX)
         i:=tmpi  // restauro indice para que lea "MOV"
       //  ? "DX?=", DX; inkey(0)
      else
      AADD(Q,"VAR"); AADD(R,"VAR")
      AADD(Q,"("); AADD(R,"(")
      AADD(Q,"N");  AADD(R,val(num))
      AADD(Q,")"); AADD(R,")")
      end
   elseif c=='"'   // es un string. para rep() y cat()
      AADD(Q,"C")
      //str:='"'
      str:=""
      ++i
      while i<=LEN(DX)
         c:=substr(DX,i,1)
         if c=='"'
            //str+='"'
            exit
         elseif c=="\"
            ++i
            c:=substr(DX,i,1)
            if c=='"'
               str+='"'
            else
               str+="\"
               --i
            end
         else
            str+=c
         end
         ++i
      end
      if i>LEN(DX)
         _ERROR("CONV: CADENA NO HA SIDO CERRADA")
         RETURN {}
      end

      AADD(R,str+chr(0))
   
   elseif c=="0"   // podría se un número en base distinta: deben ser escritos con mayúscula si son hexas.
     num:=c
     AADD(Q,"N")
     c:=substr(DX,++i,1)
     if c=="x"   // es un numero con base!
        num:=""
        while i<=LEN(DX)
           c:=substr(DX,++i,1)
           if isdigit(c) .or. c=="A".or.c=="B".or.c=="C".or.c=="D".or.c=="E".or.c=="F"
              num+=c
           else
              exit
           end
        end
     //   ? "NUM=",num; inkey(0)
        if c=="b"     // es binairo
           for j:=1 to len(num)
              xt:=substr(num,j,1)
              if xt!="0" .and. xt!="1"
                 _ERROR("CONV: NUMERO BINARIO MAL FORMADO: "+num)
                 RETURN {}
              end
           end
           num:=BINTODEC(num)
        elseif c=="o"   // es octal
           for j:=1 to len(num)
              xt:=substr(num,j,1)
              if !(xt $ "01234567")
                 _ERROR("CONV: NUMERO OCTAL MAL FORMADO: "+num)
                 RETURN {}
              end
           end
           num:=OCTALTODEC(num)
        elseif c=="h"    // es hexadecimal
           for j:=1 to len(num)
              xt:=substr(num,j,1)
              if !(xt $ "0123456789ABCDEF")
                 _ERROR("CONV: NUMERO HEXADECIMAL MAL FORMADO: "+num)
                 RETURN {}
              end
           end
           num:=HEXATODEC(num)
        else   // no es ninguna hueá: error!
           _ERROR("CONV: BASE NUMERICA NO RECONOCIDA: "+num)
           RETURN {}
        end 
   //     ? "NUM=",num; inkey(0)
        AADD(R,num)
        
      else  // es un número que comienza con 0...

        while i<=LEN(DX)
           c:=substr(DX,i,1)
           if isdigit(c) .or. c=="."
              num+=c
           elseif upper(c)=="E"
              num+="E"
              ++i
              c:=substr(DX,i,1)
              if c=="+" .or. c=="-"
                 num+=c
              elseif isdigit(c)
                 num+=c
              else
                 _ERROR("CONV: NO ES UN NUMERO NOTACION-CIENTIFICA VALIDO: "+num)
                 RETURN {}
              end
           else
              --i  // ajusto para que sea leido luego
              exit
           end
           ++i
        end
        if ISNOTATION(num)==1
           AADD(R,E2D(num))
        else
           if ISTNUMBER(num)!=1 .or. !isdigit(substr(num,len(num),1))
              _ERROR("CONV: NO ES UN NUMERO VALIDO: "+num)
              RETURN {}  // error
           else
              AADD(R,val(num))
           end
        end
      end
      
   elseif isdigit(c)
      num:=c
      ++i
      AADD(Q,"N")
    //  ? "EXPR=",DX,len(DX)
      while i<=LEN(DX)
         c:=substr(DX,i,1)
         if isdigit(c) .or. c=="."
            num+=c
         elseif upper(c)=="E"
            num+="E"
            ++i
            c:=substr(DX,i,1)
      //      ? "NUM=",num,"  C=",c; inkey(0)
            if c=="+" .or. c=="-"
               num+=c
            elseif isdigit(c)
               num+=c
            else
               _ERROR("CONV: NO ES UN NUMERO NOTACION-CIENTIFICA VALIDO: "+num)
               RETURN {}
            end
         else
            --i  // ajusto para que sea leido luego
            exit
         end
         ++i
      //   ? num; ??"-->",i ; inkey(0)
      end
      //   ? num; inkey(0)
      // evaluar el número
      if ISNOTATION(num)==1
         AADD(R,E2D(num))
      else
         if ISTNUMBER(num)!=1 .or. !isdigit(substr(num,len(num),1))
            _ERROR("CONV: NO ES UN NUMERO VALIDO: "+num)
            RETURN {}  // error
         else
            AADD(R,val(num))
         end
      end

   elseif isalpha(c) .or. c==chr(126)
      fun:=c
      ++i
      c:=substr(DX,i,1)
      while isalpha(c) .and. i<=LEN(DX)
         fun+=c
         ++i
         c:=substr(DX,i,1)
      end
      fun:=upper(fun)
      if fun=="PI"
         AADD(Q,"N")
         AADD(R,NUMPI)
      elseif fun=="I"
         AADD(Q,"I"); AADD(R,"I")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")
      elseif fun=="L"
         AADD(Q,"L"); AADD(R,"L")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")
      elseif fun=="POOL"
         AADD(Q,"POOL"); AADD(R,"POOL")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")
      elseif fun=="NT"   // total de tokens
         AADD(Q,"NT"); AADD(R,"NT")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")
       ///  ? "ENCONTRO NT"; inkey(0)
      elseif fun=="CLEAR"
         AADD(Q,"CLEAR"); AADD(R,"CLEAR")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")
      elseif fun=="NOP"
         AADD(Q,"NOP"); AADD(R,"NOP")
         AADD(Q,"("); AADD(R,"(")
         AADD(Q,")"); AADD(R,")")

      else
         AADD(Q,fun)
         AADD(R,fun)
         SWFUN:=.T.
      end
      if i<=LEN(DX)
         --i
      end
   elseif c=="}" .or. c=="]"
      AADD(Q,")")
      AADD(R,")")
      --ctap
   elseif c=="{"
      AADD(Q,"CAT")
      AADD(R,"CAT")
      DX:=substr(DX,1,i)+"("+substr(DX,i+1,len(DX))
      long:=LEN(DX)
   elseif c=="["
      AADD(Q,"INT")
      AADD(R,"INT")
      DX:=substr(DX,1,i)+"("+substr(DX,i+1,len(DX))
      long:=LEN(DX)
   elseif c=="+" .or. c=="-" .or. c=="*" .or. c=="/" .or. c=="^".or.c=="%".or.c=="\".or.c=="&".or.c=="|".or.c=="!".or.c=="="
      AADD(Q,c)
      AADD(R,c)
   end
   ++i
end

if /*Q[len(Q)]!=")" .and. Q[LEN(Q)]!="N" .or.*/ ctap!=0
   _ERROR("CONV: PARENTESIS DESBALANCEADOS")
   RETURN {}
end
RETURN {Q,R}

FUNCTION _CTRLL_EVALUA(q,r)
LOCAL pila,pila2,p,p2,sw,l,l2,m,m2,swv,j,DICC,cFUN,posPila,x,y

/* codigo de funcion */

cFUN:={"FNA","FNA","FNA","FNA","FNA","FNA",;
       "FNB","FNB","FNB",;
       "FNC","FNC","FNC",;
       "FND","FND","FND","FND","FND","FND","FND",;
       "FNE","FNE","FNE","FNE","FNE","FNE","FNE","FNE","FNE",;
       "FNF","FNF","FNF","FNF","FNF",;
       "FNG","FNG","FNG","FNG","FNG","FNG",;
       "FNH","FNH","FNH","FNH","FNH","FNH","FNH","FNH","FNH",;
       "FNI","FNI","FNI","FNI","FNI","FNI","FNI","FNI",;
       "FNJ","FNJ","FNJ","FNJ","FNJ","FNJ","FNJ","FNJ","FNJ","FNJ",;
       "FNK","FNK","FNK","FNK",;
       "FNL","FNL","FNL","FNL","FNL","FNL","FNL","FNL",;
       "FNM","FNM","FNM","FNM","FNM","FNM","FNM",;
       "FNN","FNN","FNN","FNN","FNN","FNN",;
       "FNO","FNO","FNO","FNO","FNO","FNO","FNO","FNO","FNO","FNO","FNO","FNO",;
       "FNP","FNP","FNP","FNP","FNP","FNP","FNP"}

nFUN:={"FNA","FNB","FNC","FND","FNE","FNF","FNG","FNH","FNI","FNJ","FNK","FNL","FNM","FNN","FNO","FNP"}  // "FNA-FNP"

DICC:={"NT","I","VAR","MOV","~","L",;   // A 1-6
       "JNZ","ELSE","ENDIF",;   // B  7-9
       "POOL","LOOP","ROUND",;           // C  10-12
       "CAT","MATCH","LEN","SUB","AT","RANGE","ATA",;  // D  13-19
       "AF","RAT","PTRP","PTRM","CP","TR","TRA","TRB","AFA",;  // E  20-28
       "TK","TKLET","LET","COPY","GLOSS",;    // F      29-33
       "RP","TRI","LTRI","RTRI","UP","LOW",;    // G  34-39
       "TRE","INS","DC","RPC","ONE","RND","SEED","TREA","TREB",;       // H  40-48
       "VAL","STR","CH","ASC","LIN","PC","PL","PR",;    // I   49-56
       "MSK","MON","SAT","DEFT","IF","IFLE","IFGE","CLEAR","SAVE","LOAD",; // J  57-66
       "NOP","AND","OR","XOR",;    // K   67-70
       "NOT","BIT","ON","OFF","BIN","HEX","DEC","OCT",; // L  71-78
       "LN","LOG","SQRT","ABS","INT","CEIL","EXP",;  // M  79-85
       "FLOOR","SGN","SIN","COS","TAN","INV",;       // N  86-91
       "+","-","*","/","\","^","%","|","&",">>","<<","!",;   // O   92-103
       "<=",">=","<>","=","<",">","TPC"}  // P  104-109
       
/*   */
pila:={}; pila2:={}
p:={}; p2:={}
aadd(pila,"(")
aadd(pila2,"(")
   while len(q)>0
      sw:=.F.
      l:=alltrim(SDC(q))
      l2:=SDC(r)
      
    //  ? "EVAL : L= ",l,"  L2= ",l2 ; inkey(0)
      
      if l=="N" .or. l=="C"
         aadd(p,l)
         aadd(p2,l2)
      else
         if !es_simbolo(l) .and. !es_Lsimbolo(l)
////            ? l ; inkey(0)
            if es_funcion(l)
               aadd(pila,l)     // es funcion
               aadd(pila2,l2)
            else
               _ERROR("SINTAXIS(1): SIMBOLO NO RECONOCIDO ("+l+")") //substr(l,2,len(l))+")")
               RETURN .F.
            end
         else
            if l=="("
               aadd(pila,l)
               aadd(pila2,l2)
            
            elseif l $ "+*-/^%\&|!" .or. l=="<<" .or. l==">>" .or. es_funcion(l) .or. es_Lsimbolo(l)
               while !sw
                  m:=SDP(pila)
                  m2:=SDP(pila2)
                  if m=="("
                    aadd(pila,m)  //mete m en pila
                    aadd(pila,l)  //mete l en pila
                    aadd(pila2,m2)
                    aadd(pila2,l2)
                    sw:=.T.; loop //break  //
                    //exit
                  end
                  if l=="^"
                    if m=="^"
                       aadd(p,m)  //mete m en p
                       aadd(p,l)
                       aadd(p2,m2)
                       aadd(p2,l2)
                    else
                       aadd(pila,m) //mete m en pila
                       aadd(pila,l) //mete l en pila
                       aadd(pila2,m2)
                       aadd(pila2,l2)
                       sw:=.T.
                    end

              
                  elseif l=="*" 
                    if m =="^" .or. m=="*" .or. m=="/" .or. m=="%" .or. m=="\"
                       aadd(p,m)   //mete m en p
                       aadd(p2,m2)
                    else
                       if es_funcion(m)
                          aadd(p,m)
                          aadd(p2,m2)
                     /******/
                       else   // ojo: esto falta
                          aadd(pila,m) //mete l en pila
                          aadd(pila2,m2)
                       end    // hasta aquí: esto estaba en XU.
                     /******/
                       aadd(pila,l) //mete l en pila
                       aadd(pila2,l2)
                       sw:=.T.
                    end

                  elseif l=="/" .or. l=="\" .or. l=="%"
                    if m=="*".or.m=="^".or.m=="/" .or. m=="%" .or. m=="\"
                       aadd(p,m)     //mete l en p
                       aadd(pila,l) //mete m en pila
                       aadd(p2,m2)
                       aadd(pila2,l2)
                       sw:=.T.
                    else
                       if es_funcion(m)
                          aadd(p,m)
                          aadd(p2,m2)
                     /******/
                       else   // ojo: esto falta
                          aadd(pila,m) //mete l en pila
                          aadd(pila2,m2)
                     /******/
                       end
                       aadd(pila,l) //mete l en pila
                       aadd(pila2,l2)
                       sw:=.T.
                    end
                
                  elseif l=="+" .or. l=="-" .or. l==">>" .or. l=="<<" .or. l=="&".or.l=="|".or. l=="!".or. es_Lsimbolo(l)
                     aadd(p,m)       //mete m en p
                     aadd(pila,l)    //mete l en pila
                     aadd(p2,m2)
                     aadd(pila2,l2)
                     sw:=.T.
      
               // -------  Y si es funcion?
                  else
                     if es_funcion(l)
                        aadd(pila,m)
                        aadd(p,l)
                        aadd(pila2,m2)
                        aadd(p2,l2)
                  
                        sw:=.T.
                     end
               // -------------------------
                  end
               end   // while

               if len(pila)==0 
                  aadd(pila,"(")   //mete cen en pila
                  aadd(pila2,"(")
               end
            elseif l==")"          // es un parentesis derecho?
               m:=SDP(pila)        // extrae de pila para m
               m2:=SDP(pila2)
//               ? "M==",m
               while m!="(" 
                  aadd(p,m)        //mete m en p
                  aadd(p2,m2)
                  m:=SDP(pila)     // extrae de pila para m
                  m2:=SDP(pila2)
                  //?? m
                  if esnulo(m) //m==nil
                      _ERROR("SINTAXIS(2): EXPRESION MAL FORMADA")
                      RETURN .F.
                  end
               end
               if len(pila)>0
                  m:=SDP(pila)
                  m2:=SDP(pila2)
//                  ?"M===",m
                  if es_funcion(m)
                     aadd(p,m)
                     aadd(p2,m2)
                  /*******/
                  else
                     aadd(pila,m) //mete l en pila
                     aadd(pila2,m2)
                  /*******/  
                  end
               end
            end

         end
      end
   end
   if len(pila)>0
      m:=SDP(pila)
      m2:=SDP(pila2)
      while m!="(" .and. m!=NIL
         aadd(p,m)
         aadd(p2,m2)
         m:=SDP(pila)
         m2:=SDP(pila2)
      end
     /* if len(pila)>0 .or. m==NIL
         _ERROR("SINTAXIS(3): EXPRESION MAL FORMADA (QUEDAN "+hb_ntos(len(pila))+" RESULTADOS EN PILA).")
         RETURN .F.
      end */
   end
   // revisa sintacticamente todo.
   pila:={}
   posPila:=0
   while !empty(p)
      m:=SDC(p)
      ++posPila
   //   ? "P = ",m; inkey(0)
      if m=="N" .or. m=="C" 
         aadd(pila,m)

      elseif m $ "+*-/^%\&|!".or.m=="<<".or.m==">>"  .or. es_Lsimbolo(m)
         o:=SDP(pila)
         n:=SDP(pila)
         if o==NIL .or. n==NIL // .or. o!="N" .or. n!="N" .and. (n!="X" .and. o!="X")
            _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA/TIPO DE OPERANDO OP: ( "+m+" )")
            RETURN .F.
         else
            aadd(pila,"N")
         end
      elseif es_funcion(m)
         if m=="ROUND"
            m:=SDP(pila)
            n:=SDP(pila)
            if esnulo(n,m) //m==NIL .or. n==NIL ///.or. n!="N" .or. m!="N" .and. (n!="X" .and. m!="X")
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA/TIPO DE ARGUMENTO (ROUND)")
               RETURN .F.
            else
               aadd(pila,"N")
            end
         elseif m=="MON"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            m:=SDP(pila)
            if esnulo(n,o,h,m) //h==NIL .or. n==NIL .or. o==NIL .or. m==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO (MON)")
               RETURN .F.
            end
            aadd(pila,"C")

         elseif m=="TRB"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            y:=SDP(pila)  // ocurrencia
            if esnulo(n,o,h,y) //h==NIL .or. n==NIL .or. o==NIL .or. y==NIL 
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")

         elseif m=="TRA"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            y:=SDP(pila)  // ocurrencia
            x:=SDP(pila)  // reemplazos
            if esnulo(n,o,h,x,y) //h==NIL .or. n==NIL .or. o==NIL .or. y==NIL .or. x==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")
            
         elseif m=="TR".or. m=="TPC"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            if esnulo(n,o,h) //h==NIL .or. n==NIL .or. o==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")

         elseif m=="TREB"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            y:=SDP(pila)  // ocurrencia
            if esnulo(n,o,h,y) //h==NIL .or. n==NIL .or. o==NIL .or. y==NIL 
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")
            
         elseif m=="TREA"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            y:=SDP(pila)  // ocurrencia
            x:=SDP(pila)  // reemplazos
            if esnulo(n,o,h,x,y) //h==NIL .or. n==NIL .or. o==NIL .or. y==NIL .or. x==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")
            
         elseif m=="TRE"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            if esnulo(n,o,h) //h==NIL .or. n==NIL .or. o==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")

         elseif m=="ATA"
            o:=SDP(pila)
            n:=SDP(pila)
            x:=SDP(pila)  // ocurrencia
            if esnulo(n,o,x) //o==NIL .or. n==NIL .or. x==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")  

         elseif m=="AT"
            o:=SDP(pila)
            n:=SDP(pila)
            if esnulo(n,o) //o==NIL .or. n==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")        

         elseif m=="AFA"
            o:=SDP(pila)
            n:=SDP(pila)
            x:=SDP(pila)  // ocurrencia
            if esnulo(n,o,x) //o==NIL .or. n==NIL .or. x==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")
            
         elseif m=="AF"
            o:=SDP(pila)
            n:=SDP(pila)
            if esnulo(n,o) //o==NIL .or. n==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")
         
         elseif m=="SUB".or. m=="INS" .or. m=="RPC".or. m=="IF".or. m=="IFLE".or.;
                m=="IFGE" .or.m=="TKLET"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            if esnulo(n,o,h) //h==NIL .or. n==NIL .or. o==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")
         elseif m=="TK"
            o:=SDP(pila)
            n:=SDP(pila)
            
            if esnulo(n,o) //o==NIL .or. n==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            else
               aadd(pila,"N")
            end
         elseif m=="CAT" .or. m=="CP".or.m=="PTRP".or.m=="PTRM" .or. m=="ONE";
                .or. m=="PL".or.m=="PC".or.m=="PR".or.m=="MSK".or.m=="SAT" .or.m=="DC"
            o:=SDP(pila)
            n:=SDP(pila)
            
            if esnulo(n,o) //o==NIL .or. n==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            else
               aadd(pila,"C")
            end
            
         elseif m=="MATCH" .or. m=="AND" .or. m=="OR".or.m=="XOR".or.m=="RAT".or.;
                m=="BIT".or.m=="ON".or.m=="OFF"
            o:=SDP(pila)
            n:=SDP(pila)
            
            if esnulo(n,o) //o==NIL .or. n==NIL// .or. n!="C" .or. m!="C"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            else
               aadd(pila,"N")
            end
         elseif m=="UP".or.m=="LO".or.m=="TRI".or.m=="LTRI".or.m=="RTRI".or.m=="BIN".or.m=="HEX"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C")
         elseif m=="SAVE"
            m:=SDP(pila)
            if m==NIL
               _ERROR("SINTAXIS: ESPERO UN NOMBRE DE ARCHIVO (SAVE)")
               RETURN .F.
            end
  ///          aadd(pila,"C") // solo para que pase el analisis
         elseif m=="LET" .or. m=="MOV"
            h:=SDP(pila)
            n:=SDP(pila)
            if esnulo(n,h) //h==NIL .or. n==NIL
               _ERROR("SINTAXIS: FALTAN ARGUMENTOS EN "+m)
               RETURN .F.
            end
         
         elseif m=="LOAD" .or. m=="SAVE"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: ESPERO UN NOMBRE DE ARCHIVO ("+m+")")
               RETURN .F.
            end
         elseif m=="DEFT" .or. m=="LOOP".or.m=="SEED".or.m=="RP"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: ESPERO UN ARGUMENTO VALIDO PARA ("+m+")")
               RETURN .F.
            end
         
         elseif m=="POOL" .or. m=="CLEAR" .or. m=="JNZ" .or. m=="ELSE" .or. m=="ENDIF"
            ;
            
         elseif m=="CH" .or. m=="STR".or. m=="GLOSS"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: ESPERO UN ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"C") // solo para que pase el analisis
         elseif m=="LEN".or. m=="ASC" .or.m=="DEC" .or. m=="VAR" .or. m=="NOT"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")
         elseif m=="RANGE"
            h:=SDP(pila)
            n:=SDP(pila)
            o:=SDP(pila)
            if esnulo(n,o,h) //h==NIL .or. n==NIL .or. o==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")
            
         elseif m=="VAL"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
            aadd(pila,"N")
         elseif m=="NOP"
            aadd(pila,"C")

         elseif m=="COPY"
            n:=SDP(pila)
            if n==NIL
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO ("+m+")")
               RETURN .F.
            end
           
            
         elseif m=="I" .or. m=="NT".or.m=="L"
            aadd(pila,"N")
         else
            m:=SDP(pila)
            if m==NIL //.or. m!="N"
               _ERROR("SINTAXIS: EXPRESION MAL FORMADA. FALTA ARGUMENTO O TIPO DISTINTO")
               RETURN .F.
            else
               aadd(pila,"N")
            end
         end
      else  // puede ser variable
         _ERROR("SINTAXIS: SIMBOLO NO RECONOCIDO ("+m+")")
         RETURN .F.
      end
   end

/* Añade codigos de funcion */
   i:=1 
   while i<=len(p2)
    //  ? "p2=",p2[i]
    if valtype(p2[i])=="C"
       _pos:=0
       for j:=1 to len(DICC)
          if p2[i]==DICC[j]
             _pos:=j //ascan(DICC,p2[i])
             exit
          end
       end
      
      if _pos>0
         p2[i]:=_pos   // meto código de funcion
         asize(p2,len(p2)+1)
         ains(p2,i)
         p2[i]:=ASCAN(nFUN,cFUN[_pos])  // intercalo codigo de familia
         ++i
         
      else   // es un string
         asize(p2,len(p2)+1)
         ains(p2,i)
         p2[i]:=20  // codigo de pushdata string
         ++i
      end

    else
         asize(p2,len(p2)+1)
         ains(p2,i)
         p2[i]:=21  // codigo de pushdata numero
         ++i
    end
      ++i
   end 
/*   i:=1 
   while i<=len(p2)
     if valtype(p2[i])=="C"
        _pos:=0
        for j:=1 to len(DICC)
           if p2[i]==DICC[j]
              _pos:=j
              exit
           end
        end
        if _pos>0
           p2[i]:=_pos   // meto código de funcion
           asize(p2,len(p2)+1)

           ains(p2,i)
           p2[i]:=cFUN[_pos]

           ++i
        end
     end
     ++i
   end */
/*?
       for j:=1 to len(p2)
        ?? p2[j],", "
       end
       ?
       inkey(0) */
  /* if len(pila)>1
      _ERROR("SINTAXIS: EXPRESION MAL FORMADA (QUEDAN "+hb_ntos(len(pila))+" RESULTADOS EN PILA).")
      RETURN .F.
   end */
RETURN p2


FUNCTION _EVALUA_EXPR(p,par,ITERACION,SWEDIT)
LOCAL res,pila,m,n,o,h,k,x,y,i,j,id:=0,ids:=0,c1,c2,c3,fp,str,nLength,xvar,NUMTOK:=0,ope:=0,vtip
LOCAL VARTABLE:=ARRAY(10),JMP:={},LENJMP:=0,vn,vo,num,LENP,pilaif,tmpPos,swFound,tmpo,tmpn,sw
   pila:={}
   pilaif:={}
   tmpPos:=0   // guarda la ultima posicion de RANGE, para busquedas iterativas, por linea
   afill(VARTABLE,"")
   NUMTOK:=numtoken(par,DEFTOKEN)
//   if pcount()==4
    //  tBUFFER:=array(len(BUFFER))
    //  ACOPY(BUFFER,tBUFFER)
//      SWEDIT:=.T.
//   end
   LENP:=len(p)
   //while !empty(p)
   for i:=1 to LENP
      if inkey()==27
         exit
      end
      //m:=SDC(p)
      m:=p[i]
      if m==20 //chr(1)   // mete string
         m:=p[++i]
         if m=="#"
            AADD(pila,par+chr(0))
         else
            aadd(pila,m)
         end
      elseif m==21 //chr(2)
         m:=p[++i]
         aadd(pila,m)   // numero
      else   // ejecuta funcion
         SWITCH m

    //  ? "DATA= ",m
/*      if valtype(m)=="C"
         if m=="#"
            AADD(pila,par+chr(0))
      //      ? "PARAM: ",par; inkey(0)
*/
         //elseif m=="FNO"
         CASE 15 // "FNO"
         //elseif m $ "+*-/^%|&\" .or. es_Lsimbolo(m)
            m:=p[++i]
            n:=SDP(pila)
            o:=SDP(pila)
           /* if esnulo(n,o) //n==NIL .or. o==NIL
               _ERROR("EVALUADOR: EXPRESION MAL FORMADA EN OPERACION ARITMETICO-LOGICA")
               RETURN .F.
            end*/
            vn:=valtype(n)
            vo:=valtype(o)
            if vn=="C"
               if right(n,1)!=chr(0)  //!(chr(0) $ n)
                  c1:=alltrim(n)
                  if len(c1)>0
                  if ISTNUMBER(c1)==1
                     n:=val(c1)
                     vn:="N"
                  else
                     if ISNOTATION(c1)==1
                        n:=e2d(c1)
                        vn:="N"
                     end
                  end
                  end
               end
            end
            
            if vo=="C"
               if right(o,1)!=chr(0)  //!(chr(0) $ o)
                  c1:=alltrim(o)
                  if len(c1)>0
                  if ISTNUMBER(c1)==1
                     o:=val(c1)
                     vo:="N"
                  else
                     if ISNOTATION(c1)==1
                        o:=e2d(c1)
                        vo:="N"
                     end
                  end
                  end
               end
            end

//       "+","-","*","/","\","^","%","|","&",;   // O   92-100
//            if !(_funExec[m]:EXEC(@pila,@o,@n,@vo,@vn))
//               return .F.
//            end
         //  ? "M=",m," O=",o," N=",n; inkey(0)
            switch m
               case 92
               if vn=="N"
                  if vo=="N"
                     AADD(pila,o+n)
                  else
                     o:=strtran(o,chr(0),"")
                     AADD(pila, substr(o,n,len(o))+chr(0))
                  end
               elseif vo=="N"
                  n:=strtran(n,chr(0),"")
                  AADD(pila, substr(n,o,len(n))+chr(0))
               else // sea numeros o strings
                  n:=strtran(n,chr(0),"")
                  o:=strtran(o,chr(0),"")
                  AADD(pila,(o+n)+chr(0))  // concatena
               end
               exit
               
               case 93
               if vn=="N" 
                  if vo=="N"
                     AADD(pila,o-n)
                  else
                     o:=strtran(o,chr(0),"")
                     AADD(pila, substr(o,1,len(o)-n)+chr(0))
                  end
               else
                  if vo=="N"
                     n:=strtran(n,chr(0),"")
                     AADD(pila, substr(n,1,len(n)-o))
                  else   // elimina TRE con ""
                     n:=strtran(n,chr(0),"")
                     o:=strtran(o,chr(0),"")
                     //?"N=",n," O=",o
                     tmpo:=""
                     if len(n)>0 .and. len(o)>0
                     if len(o)>=len(n)
                     tmpo:=o; tmpn:=n
                     if !SWSENSITIVE   
                        o:=upper(o);n:=upper(n)
                     end
                     id:=numat(n,o)
                     if id>0
                        j:=1
                        while j<=id
                           ids:=atnum(n,o,j)
                           ids:=BUSCACOMPLETA(ids,o,len(n))
                           if ids>0
                              c1:=substr(tmpo,1,ids-1)
                              c2:=substr(tmpo,ids+len(tmpn),len(tmpo))
                              tmpo:=c1+c2
                              if !SWSENSITIVE
                                 o:=upper(tmpo)
                              else
                                 o:=tmpo
                              end
                              id:=numat(n,o)
                              j:=0
                           end
                           ++j
                        end
                     end
                     end
                     end
                  //   ??" O=",o; inkey(0)
                     aadd(pila,tmpo+chr(0))
                  end
               end
               exit
               
               case 94
               if vn=="N"
                  if vo=="N"
                     AADD(pila,o*n)
                  else
                     o:=strtran(o,chr(0),"")
                     AADD(pila, replicate(o,n)+chr(0))
                  end
               else
                  if vo=="N"
                     n:=strtran(n,chr(0),"")
                     AADD(pila, replicate(n,o)+chr(0))
                  else
                     n:=strtran(n,chr(0),"")
                     o:=strtran(o,chr(0),"")
                    /// ? ">>",CHARMIX(n,o) ; inkey(0)
                     AADD(pila, CHARMIX(o,n)+chr(0))
                  end
               end
               exit
               
               case 95
               if vn=="N" 
                  if vo=="N"
                     if n!=0
                        AADD(pila,o/n)
                     else
                        AADD(pila,"DIV/0")
                     end
                  else
                     o:=strtran(o,chr(0),"")
                     AADD(pila,substr(o,n,len(o))+chr(0))
                  end
               else
                  if vo=="C"
                     n:=strtran(n,chr(0),"")
                     o:=strtran(o,chr(0),"")
                     AADD(pila, CHARONLY(n,o)+chr(0)) // solo deja en "n" los caracteres de "o"
                  else
                     n:=strtran(n,chr(0),"")
                     AADD(pila,substr(n,1,o)+chr(0))
                  end
               end
               exit

               case 99  // or   o esta contenido
               vn:=vo+vn
               if vn=="NN"
                  AADD(pila,XNUMOR(o,n))
               elseif vn=="CC"
                  n:=strtran(n,chr(0),"")
                  o:=strtran(o,chr(0),"")
                  if SWSENSITIVE
                     AADD(pila,iif(o $ n,0,1))
                  else
                     AADD(pila,iif(upper(o) $ upper(n),0,1))
                  end
               else
                  _ERROR("EVALUADOR: TIPOS DISTINTOS EN OPERACION | (OR|CONTENIDO) ")
                  RETURN .F.
               end
               exit

               case 100  // and
               vn:=vn+vo
               if vn=="NN"
                  AADD(pila,XNUMAND(o,n))
               elseif vn=="CC"
                  n:=strtran(n,chr(0),"")
                  o:=strtran(o,chr(0),"")
                  if !SWSENSITIVE
                     n:=upper(n)
                     o:=upper(o)
                  end
                  id:=numat(o,n)
                  ///?"ID=",id
                  if id>0
                     swFound:=.F.
                     ids:=0
                     for j:=1 to id
                        ids:=ATNUM(o,n,j)
                        ids:=BUSCACOMPLETA(ids,n,len(o))
                        if ids>0
                          swFound:=.T.
                          exit
                        end
                     end
                     if swFound
                        AADD(pila,0)
                     else
                        AADD(pila,1)
                     end
                  else
                     AADD(pila,1)
                  end
                 // AADD(pila,CHARAND(o,n)+chr(0))
               else
                  _ERROR("EVALUADOR: TIPOS DISTINTOS EN OPERACION & (AND|SUB EXACTO) ")
                  RETURN .F.
               end
               exit

               case 96
               if vn=="N" 
                  if vo=="N"
                     if n!=0
                        AADD(pila,int(o/n))
                     else
                        AADD(pila,"DIV/0")
                     end
                  else 
                     o:=strtran(o,chr(0),"")
                     AADD(pila, atadjust(o,par,n,1,," ")+chr(0))
                  end
               else
                  AADD(pila,"TYPE-\-ERROR")
               end
               exit
               
               case 97
               if vn=="N"
                  if vo=="N"
                     AADD(pila,o^n)
                  else
                     o:=strtran(o,chr(0),"")
                     AADD(pila, posins(par,o,n)+chr(0))
                  end
               else
                  if vo=="C"   // AF busca exacta
                     n:=strtran(n,chr(0),"")
                     o:=strtran(o,chr(0),"")

                    // tmpo:=o; tmpn:=n
                     if !SWSENSITIVE   
                        o:=upper(o);n:=upper(n)
                     end
                     id:=numat(n,o)
                     if id>0
                        j:=1
                        while j<=id
                           ids:=atnum(n,o,j)
                           ids:=BUSCACOMPLETA(ids,o,len(n))
                           if ids>0
                              AADD(pila, ids )
                              exit
                           end
                           ++j
                        end
                        if j>id
                           aadd(pila,0)
                        end
                     else
                        aadd(pila,0)
                     end
                  else
                     AADD(pila,"TYPE-^-ERROR")
                  end
               end
               exit
               
               case 98
               vtip:=vn+vo 
               if vtip=="NN" //vn=="N" .and. vo=="N"
                  AADD(pila,o%n)
               elseif vtip=="NC"
                  o:=strtran(o,chr(0),"")
                  AADD(pila, POSCARACTER(o,n)+chr(0))
               elseif vtip=="CC"  //vn=="C" .and. vo=="C"
                  n:=strtran(n,chr(0),"")
                  o:=strtran(o,chr(0),"")
                  AADD(pila, iif(LIKE(n,o),0,1))
               else
                  AADD(pila,"TYPE-%-ERROR")
               end
               exit
               
               case 101  //">>"   // desplazamiento según si es numero o caracter
                 vtip:=vo+vn 
                 if vtip=="NN"
                    AADD(pila,HB_BITSHIFT(o,n*(-1)))
                 elseif vtip=="CN"
                    AADD(pila,CHARSHR(o,n))
                 else
                    _ERROR("EVALUADOR: TIPOS DISTINTOS EN OPERACION BINARIA >> ")
                    RETURN .F.
                 end
                 exit

               case 102   //"<<"   // desplazamiento según si es numero o caracter
                 vtip:=vo+vn 
                 if vtip=="NN"
                    AADD(pila,HB_BITSHIFT(o,n))
                 elseif vtip=="CN"
                    AADD(pila,CHARSHL(o,n))
                 else
                    _ERROR("EVALUADOR: TIPOS DISTINTOS EN OPERACION BINARIA << ")
                    RETURN .F.
                 end
                 exit

               case 103 //"!"  // xor
                 vtip:=vo+vn 
                 if vtip=="NN"
                    AADD(pila,XNUMXOR(o,n))
                 elseif vtip=="CC"
                    AADD(pila,CHARXOR(o,n))
                 else
                    _ERROR("EVALUADOR: TIPOS DISTINTOS EN OPERACION BINARIA ! (XOR) ")
                    RETURN .F.
                 end
                 exit

            end
            EXIT
            
         //elseif m=="FNP"
         CASE 16  // "FNP"
         //elseif m $ "+*-/^%|&\" .or. es_Lsimbolo(m)
            m:=p[++i]
            if m == 110  // TPC
               h:=SDP(pila)
               n:=SDP(pila) 
               o:=SDP(pila)
               if valtype(h)!="N"
                  h:=val(h)
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila, POSCHAR(o,n,h)+chr(0))
               loop
            end   
            
            n:=SDP(pila)
            o:=SDP(pila)
           /* if esnulo(n,o) //n==NIL .or. o==NIL
               _ERROR("EVALUADOR: EXPRESION MAL FORMADA EN OPERACION LOGICA")
               RETURN .F.
            end*/
            vn:=valtype(n)
            vo:=valtype(o)
            if vn=="C"
               if right(n,1)!=chr(0)  //!(chr(0) $ n)
                  c1:=alltrim(n)
                  if len(c1)>0
                  if ISTNUMBER(c1)==1
                     n:=val(c1)
                     vn:="N"
                  else
                     if ISNOTATION(c1)==1
                        n:=e2d(c1)
                        vn:="N"
                     end
                  end
                  end
               end
            end
            
            
            if vo=="C"
               if right(o,1)!=chr(0)  //!(chr(0) $ o)
                  c1:=alltrim(o)
                  if len(c1)>0
                  if ISTNUMBER(c1)==1
                     o:=val(c1)
                     vo:="N"
                  else
                     if ISNOTATION(c1)==1
                        o:=e2d(c1)
                        vo:="N"
                     end
                  end
                  end
               end
            end               

            vtip:=vo+vn
//       "<=",">=","<>","=","<",">"}  // P  101-106
//            if !(_funExec[m]:EXEC(@pila,@o,@n,@vtip))
//               return .F.
//            end

            switch m
            case 107
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o==n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))==n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)==n,0,1))
               end
               exit
            case 104
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o<=n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))<=n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)<=n,0,1))
               end
               exit
               
            case 105
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o>=n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))>=n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)>=n,0,1))
               end
               exit
               
            case 108
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o<n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))<n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)<n,0,1))
               end
               exit
               
            case 109
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o>n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))>n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)>n,0,1))
               end
               exit
               
            case 106
               if isany(vtip,"NN","CC") //vtip=="NN" .or. vtip=="CC"
                  AADD(pila,iif(o!=n,0,1))
               elseif vtip=="NC"
                  AADD(pila,iif(hb_ntos((o))!=n,0,1))
               elseif vtip=="CN"
                  AADD(pila,iif(val(o)!=n,0,1))
               end
               exit
            end
            EXIT
            
// "NT","I","VAR","MOV","~","L",;   // A 1-6
         //elseif m=="FNA"
         CASE 1  // "FNA"
            m:=p[++i]
            
            switch m
            case 1 //"NT"
               AADD(pila,NUMTOK)
               exit
            case 2  //"I"
               AADD(pila,ITERACION)
               exit
            case 3  //"VAR"
               o:=SDP(pila)
              /* if esnulo(o) //o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN '@N'")
                  RETURN .F.
               end*/
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if o>=1 .and. o<=20
                  aadd(pila,VARTABLE[o])
               else
                  _ERROR("EVALUADOR: REGISTRO "+HB_NTOS(o)+" NO EXISTE @(<<1..20>>) L:"+hb_ntos(i) )
                  return .F.
               end
               exit
               
            case 4  //"MOV"
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: @N RECIBE UN VALOR NULO")
                  RETURN .F.
               end*/
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if o>=1 .and. o<=20
                  VARTABLE[o]:=n
               else
                  _ERROR("EVALUADOR: REGISTRO "+HB_NTOS(o)+" NO EXISTE MOV(<<1..20>>,...) L:"+hb_ntos(i) )
                  return .F.
               end
               exit

            case 5  //chr(126)  // not
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ~(EXPR) (NOT) ")
                  RETURN .F.
               end*/
               vn:=valtype(n)
               if vn=="N"
                  if n!=0
                     AADD(pila,0)
                  else
                     AADD(pila,1)
                  end
               else
                  _ERROR("EVALUADOR: TIPO NUMERICO ESPERADO EN ~(EXPR) (NOT) ")
                  RETURN .F.
               end
               exit

            case 6  //"L"
               AADD(pila,len(par))
               exit
            end
            EXIT

//       "JNZ","ELSE","ENDIF",;   // B  7-9           
         //elseif m=="FNB"
         CASE 2  // "FNB"
            m:=p[++i]
            switch m
            case 8  //"ELSE"  // JNZ fue verdadero: debe sartar else
               ++i
               while i<=LENP
                  //if valtype(p[i])=="C"
                  if p[i]==2  //"FNB"
                     ++i
                     if p[i]==8  //"ELSE" 
                        if len(pilaif)==0
                            exit
                        end
                        ++i
                     elseif p[i]==9  //"ENDIF"
                        if len(pilaif)>0
                           asize(pilaif,len(pilaif)-1)
                           ++i
                        else
                           exit
                        end
                     elseif p[i]==7  //"JNZ"  // pone en pila
                        aadd(pilaif,1)
                        ++i
                     end
                  else
                     i += 2
                  end
                  //end
                  //++i
               end
               if len(pilaif)>0
                  _ERROR("EVALUADOR ':': EXPRESION << EXPR ? >> MAL FORMADA")
                  RETURN .F.
               end
               exit
               
            case 9  //"ENDIF"
               loop
               
            case 7  //"JNZ"
               n:=SDP(pila)
               if n!=NIL
                  if valtype(n)=="N"
                     n:=hb_ntos((n))
                  else
                     n:=strtran(n,chr(0),"")
                  end
                 // ? "JNZ=",n; inkey(0)
                  IF LEN(n)>0 .and. n!="0"  // busco "ELSE"
                     ++i
                     while i<=LENP
                        //if valtype(p[i])=="C"
                        if p[i]==2 //"FNB"
                           ++i
                           if p[i]==8  //"ELSE" 
                              if len(pilaif)==0
                                 exit
                              end
                              ++i
                           elseif p[i]==9  //"ENDIF"
                              if len(pilaif)>0
                                 asize(pilaif,len(pilaif)-1)
                                 ++i
                              else
                                 exit
                              end
                           elseif p[i]==7  //"JNZ"  // pone en pila
                              aadd(pilaif,1)
                              ++i
                           end
                        else
                           i += 2  // avanzo a sig. codigo de funcion
                        end
                       // end
                       // ++i
                     end
                     if len(pilaif)>0
                        _ERROR("EVALUADOR '?': EXPRESION << EXPR ? >> MAL FORMADA ")
                        RETURN .F.
                     end
                  END
               else
                  _ERROR("EVALUADOR '?': NO EXISTE UNA EXPRESION PARA ? << EXPR ? >>")
                  RETURN .F.
               end
               exit
            end
            EXIT
//        "POOL","LOOP","ROUND",;           // C  10-12
         //elseif m=="FNC"
         CASE 3  // "FNC"
            m:=p[++i]
            switch m
            case 12  //"ROUND"
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ROUND")
                  RETURN .F.
               end */
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,ROUND(n,o))
               exit
               
            case 11  //"LOOP"
               if LENJMP>0
                  n:=SDP(pila)
                 /* if esnulo(n) //n==NIL
                     _ERROR("EVALUADOR: VALOR NULO EN PUNTERO A DIRECCION LOOP")
                     RETURN .F.
                  end */
                  if valtype(n)!="N"
                     n:=strtran(n,chr(0),"")
                     n:=val(n)
                  end
               /// ? "n = ",n ; inkey(0)
                  if n==0
                     --LENJMP
                     ASIZE(JMP,LENJMP)
                  else
                     i:=JMP[LENJMP]
                  end
               else
                  _ERROR("EVALUADOR: LOOP sin POOL") 
                  return .F.
               end
               exit
               
            case 10  //"POOL"
               if i<LENP
                  aadd(JMP,i)
                  LENJMP:=len(JMP)
               end
               exit
            end
            EXIT
            
//       "CAT","MATCH","LEN","SUB","AT","RANGE","ATA",;  // D  13-19
         //elseif m=="FND"
         CASE 4  // "FND"
            m:=p[++i]
            switch m
            case 14  //"MATCH"  // match(#,"hola\;funcion()\;v=a * (b - c)")
               n:=SDP(pila)  // palabras a buscar
               o:=SDP(pila)  // variable: debe ser string
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN MATCH")
                  RETURN .F.
               end*/ 
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               xvar:=0
               // busca tokens:
               if !SWSENSITIVE
                  n:=upper(n); o:=upper(o)
               end
               n:=strtran(n,"\;",chr(1))
               
               id:=numtoken(n,chr(1))
               j:=1
               while j<=id
                  ids:=token(n,chr(1),j)
                     
                  //c3:=atnum(ids,o,1)
                  c3:=atnum(ids,o,1)
                  c3:=BUSCACOMPLETA(c3,o,len(ids))
                  if c3>0
                     ++xvar
                  end
                  ++j
               end
               aadd(pila,xvar-id)
               exit

            case 13  //"CAT"
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN CAT")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if len(n)==0
                  AADD(pila,o+chr(0))
               elseif len(o)==0
                  AADD(pila,n+chr(0))
               else
                  AADD(pila,(n+o)+chr(0))
               end
               exit
            
            case 16  //"SUB"
               h:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,h) //n==NIL.or.o==NIL.or.h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN SUB")
                  RETURN .F.
               end */
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if n==0 .or. m==0
                  AADD(pila,""+chr(0))   // opcion: no pone nada.
               else
                  AADD(pila,substr(o,n,h)+chr(0))
               end
               exit

            case 17   //"AT"
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN AT")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if !SWSENSITIVE
                  o:=upper(o); n:=upper(n)
               end
               AADD(pila, at(o,n) )
               exit

            case 19  //"ATA"
               x:=SDP(pila)  // ocurrencia
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o,x) //n==NIL.or.o==NIL.or.x==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ATA")
                  RETURN .F.
               end */
               if valtype(x)!="N"
                  x:=strtran(x,chr(0),"")
                  x:=val(x)
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if !SWSENSITIVE
                  o:=upper(o); n:=upper(n)
               end
               y:=numat(o,n)
               AADD(pila, atnum(o,n,x) )
               exit
               
            case 15  //"LEN"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LEN")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  AADD(pila,len(hb_ntos(((n)))))
               else
                  n:=strtran(n,chr(0),"")
                  AADD(pila,len(n))
               end
               exit

            case 18  //"RANGE"
               o:=SDP(pila)
               n:=SDP(pila)
               h:=SDP(pila)
              /* if esnulo(n,o,h) //n==NIL.or.o==NIL.or.h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RANGE")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               tmpPos:=POSRANGE(chr(n),chr(o),h,,tmpPos)
              // ? tmpPos
               AADD(pila,tmpPos)
               exit
            end
            EXIT

//       "AF","RAT","PTRP","PTRM","CP","TR","TRA","TRB","AFA",;  // E  20-28
         //elseif m=="FNE"
         CASE 5  // "FNE"
            m:=p[++i]
            switch m
            case 20  //"AF"   // busca full
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN AF")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if !SWSENSITIVE   
                  o:=upper(o);n:=upper(n)
               end
               id:=numat(n,o)
               if id>0
                  j:=1
                  while j<=id
                     ids:=atnum(n,o,j)
                     ids:=BUSCACOMPLETA(ids,o,len(n))
                     if ids>0
                        AADD(pila, ids )
                        exit
                     end
                     ++j
                  end
                  if j>id
                     aadd(pila,0)
                  end
               else
                  aadd(pila,0)
               end
               exit

            case 28  //"AFA"   // busca full
               x:=SDP(pila)  // ocurrencia
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o,x) //n==NIL.or.o==NIL.or.x==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN AFA")
                  RETURN .F.
               end */
               if valtype(x)!="N"
                  x:=strtran(x,chr(0),"")
                  x:=val(x)
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if !SWSENSITIVE   
                  o:=upper(o);n:=upper(n)
               end
               id:=numat(n,o)
               sw:=.F.
               if id>0
                  j:=1
                  while j<=id
                     ids:=atnum(n,o,j)
                     ids:=BUSCACOMPLETA(ids,o,len(n))
                     if ids>0
                        AADD(pila, ids )
                        sw:=.T.
                        exit
                     end
                     ++j
                  end
                  if !sw
                     //if j>id
                     aadd(pila,0)
                     //end
                  end
               else
                  aadd(pila,0)
               end
               exit
            
            case 25  //"TR"
               h:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o,h) //n==NIL.or.o==NIL.or.h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TR")
                  RETURN .F.
               end */
               if valtype(m)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end

               AADD(pila,strtran(o,n,h)+chr(0))
               exit
               
            case 27  //"TRB"
               h:=SDP(pila)  // omite
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o,m,h) //n==NIL.or.o==NIL .or.m==NIL.or.h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TRB")
                  RETURN .F.
               end */
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila,strtran(o,n,m,h)+chr(0))
               exit
               
            case 26  //"TRA"
               x:=SDP(pila)  // omite y reemplaza
               h:=SDP(pila)  // omite
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(n,o,m,h,x) //n==NIL.or.o==NIL .or.m==NIL.or.h==NIL.or.x==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TRA")
                  RETURN .F.
               end */
               if valtype(x)!="N"
                  x:=strtran(x,chr(0),"")
                  x:=val(x)
               end
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila,strtran(o,n,m,h,x)+chr(0))
               exit
            
            case 24  //"CP"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN CP")
                  RETURN .F.
               end */
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               AADD(pila,replicate(n,o)+chr(0))
               exit

            case 21  //"RAT"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RAT")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               
               
               if !SWSENSITIVE
                  o:=upper(o); n:=upper(n)
               end
               AADD(pila, rat(o,n) )
               exit

            case 22  //"PTRP"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN PTRP {+S}")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               
               AADD(pila, substr(n,o,len(n))+chr(0))
               exit

            case 23  //"PTRM"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN PTRM {-S}")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
             //  n:=strtran(n,'"',"")
               
               AADD(pila, substr(n,1,len(n)-o)+chr(0))
               exit 
            end
            EXIT

//       "TK","TKLET","LET","COPY","GLOSS",;    // F      29-33
         //elseif m=="FNF"
         CASE 6  // "FNF"
            m:=p[++i]
            switch m
            case 29  //"TK"
               m:=SDP(pila)
               o:=SDP(pila)
              /* if esnulo(m,o) //m==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TK $N")
                  RETURN .F.
               end */
               if valtype(m)!="N"
                  m:=strtran(m,chr(0),"")
                  m:=val(m)
               end
              /* if valtype(n)=="N"
                  n:=hb_ntos((n))
               end*/
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
              // ? "M=",m; inkey(0)
               if m==0
                  AADD(pila,par+chr(0))
               elseif m<0
                  _ERROR("EVALUADOR: NO ACEPTO UN INDICE DE TOKEN NEGATIVO")
                  return .F.
               else
                 /* if m>NUMTOK
                     AADD(pila,""+chr(0))
                  else*/
                  n:=alltrim(token(o,DEFTOKEN,m))
                  if len(n)>0 
                     if ISTNUMBER(n)==1
                        AADD(pila,val(n))
                     elseif ISNOTATION(n)==1
                        AADD(pila,e2d(n))
                     else
                        AADD(pila,n+chr(0))
                     end
                  else
                     AADD(pila,""+chr(0))
                  end
               end
               exit              

            case 31  //"LET"
               h:=SDP(pila)  // string.
               o:=SDP(pila)  // linea.debe ser un número
              /* if esnulo(h,o) //h==NIL.or.o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LET")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               
            //   ? "LEN(BUFFER)=",len(BUFFER)," o=",o
               if o>0 .and. o<=len(BUFFER)
                  BUFFER[o]:=h
               else
                  _ERROR("EVALUADOR: LINEA REFERENCIADA EN LET NO EXISTE")
                  return .F.
               end
               exit

            case 30  //"TKLET"
               h:=SDP(pila)  // token 2. puede ser un string.
               n:=SDP(pila)  // token 1. debe ser un numero, indice de token
               o:=SDP(pila)  // linea
              /* if esnulo(n,o,h) //n==NIL.or.o==NIL.or.h=NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TKLET")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               o:=strtran(o,chr(0),"")
               if valtype(h)=="N"  // intercambia tokens
                  c1:=alltrim(token(o,DEFTOKEN,n))
                  c2:=alltrim(token(o,DEFTOKEN,h))
                  j:=numtoken(o,DEFTOKEN)
                  str:=""
                  for xvar:=1 to j
                     if xvar==n
                        str+=c2+DEFTOKEN
                     elseif xvar==h
                        str+=c1+DEFTOKEN
                     else
                        str+=alltrim(token(o,DEFTOKEN,xvar))+DEFTOKEN
                     end
                  end
                  AADD(pila,substr(str,1,len(str)-1)+chr(0))
               else    // cambia el token n por el string h
                  j:=numtoken(o,DEFTOKEN)
                  str:=""
                  h:=strtran(h,chr(0),"")
                  //h:=alltrim(h)
                  for xvar:=1 to j
                     if xvar==n
                        str+=h+DEFTOKEN
                     else
                        str+=alltrim(token(o,DEFTOKEN,xvar))+DEFTOKEN
                     end
                  end
                  AADD(pila,substr(str,1,len(str)-1)+chr(0))
               end
               exit
               
            case 32  //"COPY"
               if SWEDIT
                  n:=SDP(pila)
                 /* if esnulo(n) //n==NIL
                     _ERROR("EVALUADOR: VALOR NULO EN COPY")
                     RETURN .F.
                  end */
                  if valtype(n)=="N"
                     n:=hb_ntos((n))
                  else
                     n:=strtran(n,chr(0),"")
                  end
                  
                //  ?"COPY N=",n; inkey(0)
                  if esnulo(n) //n==NIL
                     _ERROR("EVALUADOR: NO ENCUENTRO UN DATO VALIDO PARA COPIAR EN BUFFER <<COPY(null)>>")
                     RETURN .F.
                  elseif len(n)>0 .and. n!="0"
                     AADD(BUFFER,alltrim(n)+chr(0))
                     //SW_HAYBUFFER:=.T.
                  end
               else
                  _ERROR("EVALUADOR: COPY SOLO TRABAJA BAJO CTRL-K4")
                  RETURN .F.
               end
               exit
               
            case 33  //"GLOSS"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN GLOSS")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  IF ABS(n)>INFINITY().or. (ABS(n)>0.and.ABS(n)<0.000000000001)
                     n:=D2E(n,10)
                  else
                     n:=hb_ntos((n))
                  end
               else
                  n:=strtran(n,chr(0),"")
               end
               AADD(pila,GLOSA(n)+chr(0))
               exit
            end
            EXIT
       
//"RP","TRI","LTRI","RTRI","UP","LOW",;    // G  34-39
         //elseif m=="FNG"
         CASE 7
            m:=p[++i]
            switch m
            case 35  //"TRI"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TRI")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=str(n)
               end
               n:=strtran(n,chr(0),"")
               AADD(pila,alltrim(n)+chr(0))
               exit
               
            case 36  //"LTRI"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LTRI")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=str(n)
               end
               n:=strtran(n,chr(0),"")
               AADD(pila,ltrim(n)+chr(0))
               exit
               
            case 37  //"RTRI"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RTRI")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=str(n)
               end
               n:=strtran(n,chr(0),"")
               AADD(pila,rtrim(n)+chr(0))
               exit

            case 38  //"UP"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN UP")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos(((n)))
               else
                  n:=strtran(n,chr(0),"")
               end
               AADD(pila,upper(n)+chr(0))
               exit
               
            case 39  //"LOW"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LOW")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos(((n)))
               else
                  n:=strtran(n,chr(0),"")
               end
               AADD(pila,lower(n)+chr(0))
               exit
            
            case 34  //"RP"
               o:=SDP(pila)
             
             /*  if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RP")
                  RETURN .F.
               end */
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
             //  o:=strtran(o,'"',"")
                  o:=strtran(o,chr(0),"")
               end
               ///AADD(pila,o+chr(0))
               par:=o
               NUMTOK:=numtoken(par,DEFTOKEN)
               exit
            end
            EXIT

//       "TRE","INS","DC","RPC","ONE","RND","SEED","TREA","TREB",;       // H  40-48
         //elseif m=="FNH"
         CASE 8   
            m:=p[++i]
            switch m
            case 40  //"TRE"
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,m) //n==NIL .or. o==NIL.or.m==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TRE")
                  RETURN .F.
               end */
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               id:=numat(n,o)
               if id>0
                  j:=1
                  while j<=id
                     ids:=atnum(n,o,j)
                     ids:=BUSCACOMPLETA(ids,o,len(n))
                     if ids>0
                        c1:=substr(o,1,ids-1)
                        c2:=substr(o,ids+len(n),len(o))
                        o:=c1+m+c2
                        --j
                     end
                     ++j
                  end
               end
               aadd(pila,o+chr(0))
               exit

            case 48  //"TREB"  // desde ocurrencia
               h:=SDP(pila)
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,m,h) //n==NIL .or. o==NIL .or.m==NIL .or. h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TREB")
                  RETURN .F.
               end */
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               id:=numat(n,o)
               if id>0   // encontré ocurrencias 
                  if id>=h   // hay mas de las que debo omitir,
                     j:=1
                     while j<=h-1
                        ids:=atnum(n,o,j)
                        ids:=BUSCACOMPLETA(ids,o,len(n))
                        if ids==0
                           ++h
                        end
                        ++j
                     end
                     j:=h
                     while j<=id
                     ids:=atnum(n,o,j)
                     ids:=BUSCACOMPLETA(ids,o,len(n))
                     if ids>0
                        c1:=left(o,ids-1)   //substr(o,1,ids-1)
                        c2:=substr(o,ids+len(n),len(o))
                        o:=c1+m+c2
                        --j
                     end
                     ++j
                     end
                  end
               end
               aadd(pila,o+chr(0))
               exit
               
            case 47  //"TREA"  // desde ocurrencia, numero de ocurrencias
               x:=SDP(pila)
               h:=SDP(pila)
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,m,h,x) //n==NIL .or. o==NIL .or.m==NIL .or. h==NIL.or.x==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN TREA")
                  RETURN .F.
               end */
               if valtype(x)!="N"
                  x:=strtran(x,chr(0),"")
                  x:=val(x)
               end
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               id:=numat(n,o)
               if id>0   // encontré ocurrencias 
                  if id>=h   // hay mas de las que debo omitir,
                     j:=1
                     while j<=h-1
                        ids:=atnum(n,o,j)
                        ids:=BUSCACOMPLETA(ids,o,len(n))
                        if ids==0
                           ++h
                        end
                        ++j
                     end
                     j:=h
                     if id>x+h
                        id:=x+h
                     end
                     k:=0
                     while j<=id
                        ids:=atnum(n,o,j)
                        ids:=BUSCACOMPLETA(ids,o,len(n))
                        if ids>0
                           c1:=left(o,ids-1)   //substr(o,1,ids-1)
                           c2:=substr(o,ids+len(n),len(o))
                           o:=c1+m+c2
                           --j
                           ++k
                           if k==x
                              exit
                           end
                        end
                        ++j
                     end
                  end
               end
               aadd(pila,o+chr(0))
               exit

            case 41  //"INS"
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,m) //n==NIL .or. o==NIL .or.m==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN INS")
                  RETURN .F.
               end */
               if valtype(m)!="N"
                  m:=strtran(m,chr(0),"")
                  m:=val(m)
               end 
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if m>0
                  xvar:=substr(o,m+1,len(o))
                  
                  AADD(pila,substr(o,1,m)+n+xvar+chr(0))
               else
                  AADD(pila,o+chr(0))
               end
               exit
               
            case 43  //"RPC"
               m:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,m) //n==NIL .or. o==NIL .or.m==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RPC")
                  RETURN .F.
               end */
               if valtype(m)=="N"
                  m:=hb_ntos((m))
               else
                  m:=strtran(m,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila,CHARREPL(n,o,m)+chr(0))
               exit
               
            case 44  //"ONE"
               n:=SDP(pila)  // caracter a reducir
               o:=SDP(pila)  // variable: debe ser string
             /*  if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ONE")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila,CHARONE(n,o)+chr(0))
               exit
               
            case 42  //"DC"
               n:=SDP(pila)  // caracteres a eliminar
               o:=SDP(pila)  // variable: debe ser string
             /*  if esnulo(n,o) //n==NIL .or. o==NIL 
                  _ERROR("EVALUADOR: VALOR NULO EN DC")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               AADD(pila,CHARREM(n,o)+chr(0))
               exit
               
            case 45  //"RND"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN RND")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,HB_RANDOM()*n)
               exit
               
            case 46  //"SEED"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN SEED")
                  RETURN .F.
               end */
               if ITERACION==1
                  if valtype(n)!="N"
                     n:=strtran(n,chr(0),"")
                     n:=val(n)
                  end
                  HB_RANDOMSEED(n)
               end
               exit
            end
            EXIT

//       "VAL","STR","CH","ASC","LIN","PC","PL","PR",;    // I   49-56
         //elseif m=="FNI"
         CASE 9
            m:=p[++i]
            switch m
            case 53  //"LIN"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LIN")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end

                  if n>0 .and. n<=LEN(BUFFER)
                     AADD(pila,strtran(BUFFER[n],chr(127),""))
                  else
                     _ERROR("EVALUADOR: NO EXISTE LA LINEA PEDIDA EN EL TEXTO (LIN)")
                     RETURN .F.
                  end
               exit

            case 51  //"CH"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN CH")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
                //  if n<=0 .or. n>255
                //     AADD(pila,"null")
                //  else
                //     AADD(pila,chr(n)+chr(0))
                //  end
               //else
               end
               AADD(pila,chr(n)+chr(0))
              // end
               exit

            case 49  //"VAL"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN VAL")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  if ISTNUMBER(n)==1
                     AADD(pila,val(n))
                  elseif ISNOTATION(n)==1
                     AADD(pila,e2d(n))
                  else
                     _ERROR("EVALUADOR: CONVERSION NO VALIDA EN VAL <<VAL( STRING-NO-NUMERIC )>>")
                     RETURN .F.
                  end
               else
                  AADD(pila,n)
               end
               exit

            case 50  //"STR"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL 
                  _ERROR("EVALUADOR: VALOR NULO EN STR")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  AADD(pila,hb_ntos((n))+chr(0))
               else
                  n:=strtran(n,chr(0),"")
                  AADD(pila,n+chr(0))
               end
               exit
               
            case 54  //"PC".or.m==55 "PL".or.m==56 "PR"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN PC")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               
               AADD(pila, padc(n,o)+chr(0))
               exit
               
            case 55  //"PL"
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN PL")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               
               AADD(pila, padl(n,o)+chr(0))
               exit
            
            case 56  //"PR"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN PR")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               
               AADD(pila, padr(n,o)+chr(0))
               exit
               
            case 52  //"ASC"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ASC")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               IF LEN(n)>1
                  n:=substr(n,1,1)
               end
               AADD(pila,asc(n))
            end
            EXIT

//       "MSK","MON","SAT","DEFT","IF","IFLE","IFGE","CLEAR","SAVE","LOAD",; // J  57-66
         //elseif m=="FNJ"
         CASE 10
            m:=p[++i]
            switch m
            case 57  //"MSK"
               n:=SDP(pila)  // relleno y mascara
               o:=SDP(pila)  // variable: debe ser numerico
              /* if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN MSK")
                  RETURN .F.
               end */
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
             //  o:=strtran(o,'"',"")
               c1:=substr(n,1,1)    // relleno
               c2:=substr(n,2,len(n)) // mascara
               AADD(pila,XFUNMASK(o,c2,c1)+chr(0))
               exit
               
            case 58  //"MON"
               h:=SDP(pila)  // decimales
               m:=SDP(pila)  // ancho
               n:=SDP(pila)  // relleno y signo moneda
               o:=SDP(pila)  // variable: debe ser numerico
             /*  if esnulo(n,o,m,h) //n==NIL .or. o==NIL .or. m==NIL .or. h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN MON")
                  RETURN .F.
               end */
               if valtype(h)!="N"
                  h:=strtran(h,chr(0),"")
                  h:=val(h)
               end
               if valtype(m)!="N"
                  m:=strtran(m,chr(0),"")
                  m:=val(m)
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               //n:=strtran(n,'"',"")
               c1:=substr(n,1,1)    // relleno
               c2:=substr(n,2,len(n)) // tipo moneda
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               AADD(pila,XFUNMONEY(o,c2,c1,h,m)+chr(0))
               exit
               
            case 59  //"SAT"
               o:=SDP(pila)
               n:=SDP(pila) 
              /* if esnulo(n,o) //n==NIL .or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN SAT")
                  RETURN .F.
               end */
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
                  o:=strtran(o,"\n",HB_OSNEWLINE())                  
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
             //  n:=strtran(n,'"',"")
               AADD(pila, XFUNCCCSATURA(n, DEFTOKEN, o)+chr(0))
               exit

            case 61  //"IF" 
               h:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,h) //n==NIL .or. o==NIL .or. h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN IF")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if len(alltrim(o))==0 .or. val(o)==0
                  AADD(pila,n)
               else
                  AADD(pila,h)
               end
               exit

            case 62  //"IFLE" 
               h:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,h) //n==NIL .or. o==NIL .or. h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN IFLE")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if val(o)<=0 .and. ISTNUMBER(o)==1
                  AADD(pila,n)
               else
                  AADD(pila,h)
               end
               exit
            
            case 63  //"IFGE"
               h:=SDP(pila)
               n:=SDP(pila)
               o:=SDP(pila)
             /*  if esnulo(n,o,h) //n==NIL .or. o==NIL .or. h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN IFGE")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               if valtype(o)=="N"
                  o:=hb_ntos((o))
               else
                  o:=strtran(o,chr(0),"")
               end
               if val(o)>=0 .and. ISTNUMBER(o)==1
                  AADD(pila,n)
               else
                  AADD(pila,h)
               end
               exit
               
            case 60  //"DEFT"
               h:=SDP(pila)  // string.
             /*  if esnulo(h) //h==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN DEFT")
                  RETURN .F.
               end */
               if valtype(h)=="N"
                  h:=hb_ntos((h))
               else
                  h:=strtran(h,chr(0),"")
               end
               DEFTOKEN:=h
               NUMTOK:=numtoken(par,DEFTOKEN) // defino variable global
               exit
            
            case 65  //"SAVE"
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN SAVE")
                  RETURN .F.
               end */
               if valtype(n)!="C"
                  _ERROR("EVALUADOR: ESPERO UN NOMBRE DE ARCHIVO VALIDO (SAVE)")
                  RETURN .F.
               end
               n:=strtran(n,chr(0),"")
               
               fp:=fcreate(n,0)
               if ferror()!=0
                  _ERROR("EVALUADOR: EL NOMBRE DE ARCHIVO NO ES VALIDO (SAVE):"+n)
                  RETURN .F.
               end
               for j:=1 to len(LISTAEXPRESION)
                  //FWRITE(fp, hb_strtoutf8(strtran(LISTAEXPRESION[j],_CR,chr(2)))+_CR)
                  FWRITE(fp, hb_strtoutf8(LISTAEXPRESION[j])+_CR)
                  FWRITE(fp, chr(2))
               end
               fclose(fp)
               pila:={}
               exit

            case 66  //"LOAD"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN LOAD")
                  RETURN .F.
               end */
               if valtype(n)!="C"
                  _ERROR("EVALUADOR: ESPERO UN NOMBRE DE ARCHIVO VALIDO (LOAD)")
                  RETURN .F.
               end
               n:=strtran(n,chr(0),"")
               
               if !file(n)  //ferror()!=0
                  _ERROR("EVALUADOR: EL NOMBRE DE ARCHIVO NO ES VALIDO (LOAD):"+n)
                  RETURN .F.
               end
               ///LISTAEXPRESION:=XREADLINE(n,@nLength)
               fp:=fopen(n,0)
               if ferror()==0
                  c1:=fseek(fp,0,2)
                  fseek(fp,0,0)
                  cTMP:=FREADSTR(fp,c1)
                  while len(cTMP)>0
                     //LISTAEXPRESION[j]:=strtran(LISTAEXPRESION[j],chr(2),_CR)
                     AADD(LISTAEXPRESION,substr(cTMP,1,at(chr(2),cTMP)-1))
                     cTMP:=substr(cTMP,at(chr(2),cTMP)+1,len(cTMP))
                  end
                  fclose(fp)
               else
                  _ERROR("EVALUADOR: NO FUE POSIBLE CARGAR EL ARCHIVO DE MACROS (LOAD):"+n)
                  RETURN .F.
               end
               pila:={}
               exit

            case 64  //"CLEAR"
               LISTAEXPRESION:=array(0)
               pila:={}
               exit

            end
            if m>=64
               exit  // sale del ciclo
            end
            EXIT

//       "NOP","AND","OR","XOR",;    // K   67-70
         //elseif m=="FNK"
         CASE 11
            m:=p[++i]
            switch m
            case 67  //"NOP"
               AADD(pila,"")
               exit
               
            case 68  //"AND"
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN AND")
                  RETURN .F.
               end */
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,iif(o==0 .and. n==0,0,1))
               exit
               
            case 69  //"OR"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN OR")
                  RETURN .F.
               end */
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,iif(o==0 .or. n==0,0,1))
               exit
               
            case 70  //"XOR"
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN XOR")
                  RETURN .F.
               end */
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,iif((o==0.and.n!=0).or.(o!=0.and.n==0),0,1))
               exit
            end
            EXIT

//       "NOT","BIT","ON","OFF","BIN","HEX","DEC","OCT",; // L  71-78

         //elseif m=="FNL"
         CASE 12
            m:=p[++i]
            switch m
            case 72  //"BIT"  // ontiene un bit n
               o:=SDP(pila)
               n:=SDP(pila)
              /* if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN BIT")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               AADD(pila,XGETBIT(n,o,1))
               exit

            case 73  //"ON"   // enciende un bit n
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN ON")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               AADD(pila,XSETBIT(n,o+1))
               exit
               
            case 74  //"OFF"   // apaga un bit n
               o:=SDP(pila)
               n:=SDP(pila)
             /*  if esnulo(n,o) //n==NIL.or. o==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN OFF")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               if valtype(o)!="N"
                  o:=strtran(o,chr(0),"")
                  o:=val(o)
               end
               AADD(pila,XCLEARBIT(n,o+1))
               exit
               
            case 71  //"NOT"   // negacion binaria
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN NOT")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,XNUMNOT(n))
               exit
            
            case 75  //"BIN"   // convierte a binario
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN BIN")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,DECTOBIN(n)+chr(0))
               exit
               
            case 76  //"HEX"   // convierte a hexadecimal
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN HEX")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,DECTOHEXA(n)+chr(0))
               exit
               
            case 78  //"OCT"   // convierte a OCTAL
               n:=SDP(pila)
              /* if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN OCT")
                  RETURN .F.
               end */
               if valtype(n)!="N"
                  n:=strtran(n,chr(0),"")
                  n:=val(n)
               end
               AADD(pila,DECTOOCTAL(n)+chr(0))
               exit

            case 77  //"DEC"
               n:=SDP(pila)
             /*  if esnulo(n) //n==NIL
                  _ERROR("EVALUADOR: VALOR NULO EN DEC")
                  RETURN .F.
               end */
               if valtype(n)=="N"
                  n:=hb_ntos((n))
               else
                  n:=strtran(n,chr(0),"")
               end
               num:=""
               c1:=substr(n,1,2)
               c2:=substr(n,len(n),1)
              // ?"C1=",c1," C2=",c2; inkey(0)
               if c1!="0x" .or. !(c2 $ "bho")
                  _ERROR("EVALUADOR: BASE NUMERICA NO RECONOCIDA: "+n)
                    RETURN .F.
               end
               n:=substr(n,3,len(n))
               IF LEN(n)>1
                  num:=""
                  j:=1
                  while j<=LEN(n)
                    c:=substr(n,j,1)
                    if isdigit(c) .or. isany(c,"A","B","C","D","E","F") //c=="A".or.c=="B".or.c=="C".or.c=="D".or.c=="E".or.c=="F"
                       num+=c
                    else
                       exit
                    end
                    ++j
                  end
                 // ? "NUM=",num; inkey(0)
                  if c=="b"     // es binairo
                    for j:=1 to len(num)
                      xt:=substr(num,j,1)
                      if xt!="0" .and. xt!="1"
                        _ERROR("EVALUADOR: NUMERO BINARIO MAL FORMADO: "+num)
                        RETURN .F.
                      end
                    end
                    num:=BINTODEC(num)
                  elseif c=="o"   // es octal
                    for j:=1 to len(num)
                      xt:=substr(num,j,1)
                      if !(xt $ "01234567")
                        _ERROR("EVALUADOR: NUMERO OCTAL MAL FORMADO: "+num)
                        RETURN .F.
                      end
                    end
                    num:=OCTALTODEC(num)
                  elseif c=="h"    // es hexadecimal
                    
                    for j:=1 to len(num)
                      xt:=substr(num,j,1)
                      if !(xt $ "0123456789ABCDEF")
                         _ERROR("EVALUADOR: NUMERO HEXADECIMAL MAL FORMADO: "+num)
                         RETURN .F.
                      end
                    end
                    num:=HEXATODEC(num)
                  else   // no es ninguna hueá: error!
                    _ERROR("EVALUADOR: BASE NUMERICA NO RECONOCIDA: "+num)
                    RETURN .F.
                  end
               else
                  _ERROR("EVALUADOR: NO HAY NUMERO A CONVERTIR: "+num)
                    RETURN .F.
               end
               AADD(pila,num)
               exit
            end
            EXIT

//       "LN","LOG","SQRT","ABS","INT","CEIL","EXP",;  // M  79-85
         //elseif m=="FNM"
         CASE 13
            m:=p[++i]
            n:=SDP(pila)
           /* if esnulo(n) //n==NIL
               FUN:=IIF(m==79,"LN",iif(m==80,"LOG",iif(m==81,"SQRT",iif(m==82,"ABS",iif(m==83,"INT []",iif(m==84,"CEIL","EXP"))))))
               _ERROR("EVALUADOR: VALOR NULO EN "+FUN)
               RETURN .F.
            end */
            if valtype(n)!="N"
               n:=alltrim(n)
               n:=strtran(n,chr(0),"")
               if ISTNUMBER(n)==1
                  n:=val(n)
               elseif ISNOTATION(n)==1
                  n:=e2d(n)
               else
                  _ERROR("EVALUADOR: OPERANDO NO ES UN NUMERO "+n)
                  RETURN .F.
               end
            end
            switch m
            case 83  //"INT"
               AADD(pila,int(n)); exit
            case 84  //"CEIL"
               AADD(pila,ceiling(n)); exit
            case 81  //"SQRT"
               AADD(pila,sqrt(n)); exit
            case 82  //"ABS"
               AADD(pila,abs(n)); exit
            case 79  //"LN"
               AADD(pila,log(n)); exit
            case 80  //"LOG"
               AADD(pila,log10(n)); exit
            case 85  //"EXP"
               AADD(pila,exp(n)); exit
            end
            EXIT

//       "FLOOR","SGN","SIN","COS","TAN","INV",;       // N  86-91
         //elseif m=="FNN"
         CASE 14
            m:=p[++i]
            n:=SDP(pila)
         /*   if esnulo(n) //n==NIL
               FUN:=IIF(m==86,"FLOOR",iif(m==87,"SGN",iif(m==88,"SIN",iif(m==89,"COS",iif(m==90,"TAN","INV")))))
               _ERROR("EVALUADOR: VALOR NULO EN "+FUN)
               RETURN .F.
            end */
            if valtype(n)!="N"
               n:=alltrim(n)
               n:=strtran(n,chr(0),"")
               if ISTNUMBER(n)==1
                  n:=val(n)
               elseif ISNOTATION(n)==1
                  n:=e2d(n)
               else
                  _ERROR("EVALUADOR: OPERANDO NO ES UN NUMERO "+n)
                  RETURN .F.
               end
            end
            switch m
            case 86  //"FLOOR"
               AADD(pila,floor(n)); exit
            case 87  //"SGN"
               AADD(pila,sign(n)); exit
            case 91  //"INV"
               AADD(pila,1/n); exit
            case 88  //"SIN"
               if SWRADIANES
                   AADD(pila,sin(n))
               else
                   AADD(pila,sin(n*PI()/180))
               end
               exit
            case 89  //"COS"
               if SWRADIANES
                   AADD(pila,cos(n))
               else
                   AADD(pila,cos(n*PI()/180))
               end
               exit
            case 90  //"TAN"
               if SWRADIANES
                   AADD(pila,tan(n))
               else
                   AADD(pila,tan(n*PI()/180))
               end
               exit
            end
            EXIT
         END
      end

     /*    else
            aadd(pila,m)
         end
      elseif valtype(m)=="N"
         aadd(pila,m)
      end*/
  //    ? "PILA=",len(pila)
   end

   XLEN:=len(pila)
   if XLEN>1 
      _ERROR("EVALUADOR: EXPRESION MAL FORMADA (QUEDAN "+hb_ntos(len(pila))+" RESULTADOS EN PILA).")
      RETURN .F.
   end
//RETURN iif(len(pila)==1,pila[1],"")
RETURN iif(XLEN>=1,pila[XLEN],"")

FUNCTION GLOSA(CIFRA)
LOCAL cDec,cNum,xPos,c,c1,c2,cCIF,decimal,num,N,desde,name,cif,l,i
LOCAL AX,BX,CX,DX,EX,FX
AX:={"uno","dos","tres","cuatro","cinco","seis","siete","ocho","nueve"}
BX:={"once","doce","trece","catorce","quince","dieciseis","diecisiete","dieciocho","diecinueve"}
CX:={"","veinti","treinta y ","cuarenta y ","cincuenta y ","sesenta y ","setenta y ","ochenta y ","noventa y "}

DX:={"diez","veinte","treinta","cuarenta","cincuenta","sesenta","setenta","ochenta","noventa"}

FX:={"ciento","docientos","trecientos","cuatrocientos","quinientos","seicientos","setecientos","ochocientos","novecientos"}

EX :={"","mil","millones","mil millones","billones","mil billones","trillones","mil trillones","cuatrillones","mil cuatrillones",;
      "quintillones","mil quintillones","sextillones","mil sextillones","septillones","mil septillones","octillones","mil octillones",;
      "nonillones","mil nonillones","decillon","mil decillones"}

if ISNOTATION(CIFRA)==1
   cNum:=hb_ntos((E2D(CIFRA)))
else
   cNum:=alltrim(CIFRA)
end
if ISTNUMBER(cNum)==1
   cDec:=""
   xPos:=at(".",cNum)
   if xPos>0
      cDec:=substr(substr(cNum,xPos+1,len(cNum)),1,2)
      cNum:=substr(cNum,1,xPos-1)
   end

   decimal:=""
   if val(cDec)>0
      if cDec!="00"
         decimal:=" con "
         num:=val(cDec)
         if num<10
            decimal+=AX[num]
         elseif num<20
            //num:=hb_ntos(num)
            if cDec=="10"
               decimal+="diez"
            else 
               decimal+=BX[val(right(cDec,1))]
            end
         else
            //c:=hb_ntos(num)
            if val(substr(cDec,2,1))==0
               decimal+=DX[val(left(cDec,1))]
            else
               c1:=val(right(cDec,1))
               //if c1>1
                  decimal+=CX[val(left(cDec,1))]+AX[c1]
              // else
              //    N+=CX[val(left(c,1))]+"un "+name
              // end
            end
         end
      end
   end
 //  ? decimal
   l:=len(cNum)
   cif:={}
   while l>0
      if l-2>0
         aadd(cif,val(substr(cNum,l-2,l)))
      else
         aadd(cif,val(substr(cNum,1,l)))
      end
      cNum:=substr(cNum,1,l-3)
      l:=len(cNum)
   //   ? cif[len(cif)]
   end
   desde:=l:=len(cif)
   nCIF:=""

   for i:=l to 1 step -1
      c:=cif[i]
      N:=""
      if c>0
         if desde>0
            name:=EX[desde]+" "
         else
            name:=""
         end
         
         if c<10
            if c==1 
               if desde>=2
                //  c2:=at("(",name)
                //  if c2>0
                //     N+="un "+left(name,c2-1)+" "
                //  else
                   if name!="mil "
                     c2:=at("es",name)
                     if c2>0
                        N+="un "+left(name,c2-1)+" "
                     else
                        N+="un "+name
                     end
                   else
                     N+=name  
                   end
               else
                  N+="uno" //+name
               end
            else
               N+=AX[c]+" "+name
            end
         elseif c<20
            c:=hb_ntos(c)
            if c=="10"
               N+="diez "+name
            else 
               N+=BX[val(right(c,1))]+" "+name
            end
         elseif c<100
            c:=hb_ntos(c)
            if val(substr(c,2,1))==0
               N+=DX[val(left(c,1))]+" "+name
            else
               c1:=val(right(c,1))
               if c1>1
                  N+=CX[val(left(c,1))]+AX[c1]+" "+name
               else
                  if desde>=2
                     N+=CX[val(left(c,1))]+"un "+name
                  else
                     N+=CX[val(left(c,1))]+"uno"
                  end
               end
            end
         else   // mayor que 100
            c:=hb_ntos(c)
            if val(substr(c,2,len(c)))==0
               if left(c,1)=="1"
                  N+="cien "+name
               else
                  N+=FX[val(left(c,1))]+" "+name
               end
            else   
               N+=FX[val(left(c,1))]+" "
               c:=substr(c,2,2)
               c1:=val(c)
          //  ? c1
               if c1<10
                  if c1==1 
                     if desde>=2
                        c2:=at("es",name)
                        if c2>0
                           N+="un "+left(name,c2-1)+" "
                        else
                        
                           N+="un "+name
                        end
                     else
                        N+="uno "//+name
                     end
                  else
                    // ? c1
                     N+=AX[c1]+" "+name
                  end
               elseif c1<20
                  if c=="10"
                     N+="diez "+name
                  else 
                     N+=BX[val(right(c,1))]+" "+name
                  end
               elseif c1<100
                  if val(substr(c,2,1))==0
                     N+=DX[val(left(c,1))]+" "+name
                  else
                     c2:=val(right(c,1))
                     if c2==1
                        if desde>=2
                           N+=CX[val(left(c,1))]+"un "+name
                        else
                           N+=CX[val(left(c,1))]+"uno"
                        end
                     else
                        N+=CX[val(left(c,1))]+AX[c2]+" "+name
                     end
                  end
               end
            end  
         end
      else
         if l==1
            N+="cero"
         end
      end
      if desde>2
         if cif[i-1]>0
            if rat("mil ",N)>0
               N:=substr(N,1,rat("mil ",N)+3)
            end
         end
      end
      nCIF:=nCIF+N
      --desde
   end
   nCIF:=alltrim(nCIF)+decimal

else
   nCIF:= " ** no se puede convertir ["+cNum+"] ** " 
end

RETURN nCIF

PROCEDURE _ERROR(msg)
   SETCOLOR(N2COLOR(cBARRA))
   @ TLINEA-3,0 CLEAR TO TLINEA,SLINEA
   setpos(TLINEA-2,int(SLINEA/2)-int(len(msg)/2)); outstd(msg)
//   inkey(0)
//   BarraTitulo(ARCHIVO)
   SETCOLOR(N2COLOR(cTEXTO))
RETURN

PROCEDURE _CTRLLERROR()
local cMessage, aOptions,nChoice
cMessage := hb_utf8tostr("La operación no es válida"+HB_OSNEWLINE()+"(Mira abajo...)")
aOptions := { "Okay" }
nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
return

PROCEDURE _CTRLLVOID()
local cMessage, aOptions,nChoice
cMessage := hb_utf8tostr("No hay resultados registrados")
aOptions := { "Okay" }
nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
return

PROCEDURE _CTRLOK()
local cMessage, aOptions,nChoice
cMessage := hb_utf8tostr("Supongo que la operación fue realizada"+HB_OSNEWLINE()+"con éxito")
aOptions := { "Okay" }
nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
return

FUNCTION _CTRL_L_TEXTOPE(TEXTO,DX,XFIL1EDIT,XFIL2EDIT)
LOCAL cLEN,I,cDATO,nDATO,Q,RX,R,T,TMPTOKEN //,lBUFF:=0,lenBUF:=0  //,nSetDecimal
local cMessage, aOptions,nChoice,SWERROR:=.F., XLEN
Q:=_CTRLL_OBTIENELISTA(DX)

if len(Q)==0
   RETURN .F.
end
R:={}
T:={}
for i:=1 to len(Q[1])
   AADD(T,Q[1][i])
   AADD(R,Q[2][i])  // esto evaluará si todo sale bien
end

R:=_CTRLL_EVALUA(T,R)
if valtype(R)=="L"
   RETURN .F.
end
XLEN:=len(TEXTO)
lenBUF:=len(BUFFER)
TMPTOKEN:=DEFTOKEN
FOR I:=XFIL1EDIT TO XFIL2EDIT
  if I==0 .or. I>XFIL2EDIT .or. I>XLEN
     /*cMessage := hb_utf8tostr("Lapsus intrauterino digital: Vuelve a marcar el texto, por favor")
     aOptions := { "Okay" }
     nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
     while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE) */
     _ERROR(upper(hb_utf8tostr("Lapsus intrauterino digital: Vuelve a marcar el texto, por favor")))
     XFIL1EDIT:=0; XFIL2EDIT:=0
     SWERROR:=.T.
     exit
  else
     cDATO:=TEXTO[I]
  end

//   ? "ENTRA: ",cDATO; inkey(0)
   RX:=_EVALUA_EXPR(@R,cDATO,I,.T.)
   if valtype(RX)=="L"
      DEFTOKEN:=TMPTOKEN
      RETURN .F.
   end
   if valtype(RX)=="N"
      IF ABS(RX)>INFINITY().or. (ABS(RX)>0.and.ABS(RX)<0.000000000001)
         RX:=D2E(RX,5)
      else
         RX:=hb_ntos((RX))
      end
      if TEXTO[I]!=RX .or. len(TEXTO[I])!=len(RX)
         AADD(BUFFER_CTRLZ,TEXTO[I])
         AADD(LINBUFFCTRLZ,I)
      end
      TEXTO[I]:=RX
      SWTEXTOMODIFICADO:=.T.
   else
      RX:=strtran(RX,chr(0),"")
      if len(RX)>0 .and. !("load" $ DX) .and. !("save" $ DX) .and. !("clear" $ DX)
         if TEXTO[I]!=RX .or. len(TEXTO[I])!=len(RX)
            AADD(BUFFER_CTRLZ,TEXTO[I])
            AADD(LINBUFFCTRLZ,I)
         end
         
         TEXTO[I]:=RX
         SWTEXTOMODIFICADO:=.T.
      else
         if SWKEEPVACIO
            AADD(BUFFER_CTRLZ,TEXTO[I])
            AADD(LINBUFFCTRLZ,I)
            TEXTO[I]:=""
            SWTEXTOMODIFICADO:=.T.
         end
      end
   end
   DEFTOKEN:=TMPTOKEN  // regresa a token inicial
//   ? "SALE: ",TEXTO[I]; inkey(0)
END
SWNOTNUL:=.F.
SWKEEPVACIO:=.F.
SWNOBUFFER:=.F.
SWSENSITIVE:=.T.
DEFTOKEN:=TMPTOKEN
if SWERROR
   RETURN .F.
end
RETURN .T.

FUNCTION _CTRL_L_OPE(BUFFER,DX)
LOCAL cLEN,i,cDATO,nDATO,Q,RX,R,T,TMPTOKEN,tmpBUFF:={}  //,nSetDecimal

Q:=_CTRLL_OBTIENELISTA(DX)

if len(Q)==0
   RETURN {"<error>"}  //Q
end
R:={}
T:={}
for i:=1 to len(Q[1])
  // ? Q[1][i]; ?? Q[2][i]
   AADD(T,Q[1][i])
   AADD(R,Q[2][i])  // esto evaluará si todo sale bien
end
//inkey(0)

R:=_CTRLL_EVALUA(T,R)
//qqout( R); inkey(0)
if valtype(R)=="L"
  // ?" RETORNO DE _CTRLL_EVALUA=",R
   RETURN {"<error>"}  //{}
end
/*for i:=1 to len(R)
   ?? R[i],","
end 
inkey(0)
*/
 
// si no es un valor logico, debe ser el array de expresion
cLEN:=len(BUFFER)
TMPTOKEN:=DEFTOKEN
//if "#" $ DX .or. "{" $ DX .or. "$" $ DX
if cLEN>0 .and. !SWNOBUFFER
      for i:=1 to cLEN
         //cDATO:=alltrim(strtran(BUFFER[i],chr(127),""))
         cDATO:=strtran(BUFFER[i],chr(127),"")

         if len(alltrim(cDATO))==0  // termina cuando encuentra una línea en blanco
            if SWNOTNUL
               ASIZE(BUFFER,i-1)
               exit
            end
         end
         if len(cDATO)>0
            if ISNOTATION(cDATO)==1
               ///cDATO:=str(E2D(cDATO))
               cDATO:=E2D(cDATO)
            else
               if ISTNUMBER(cDATO)==1
                  cDATO:=val(cDATO)
               end
            end
         //else
            
         end
         //AX:=strtran(DX,"#",cDATO)
         RX:=_EVALUA_EXPR(@R,cDATO,i,.F.)
         if valtype(RX)=="L"
            DEFTOKEN:=TMPTOKEN
            RETURN {"<error>"}  //{}
         end
         if valtype(RX)=="N"
            IF ABS(RX)>INFINITY().or. (ABS(RX)>0.and.ABS(RX)<0.000000000001)
               RX:=D2E(RX,5)
            else
               RX:=hb_ntos((RX))
            end
            //BUFFER[i]:=RX+chr(127)
            AADD(tmpBUFF,RX+chr(127))
         else
            RX:=strtran(RX,chr(0),"")
            if len(RX)>0
               if !("load" $ DX) .and. !("save" $ DX) .and. !("clear" $ DX)
                  //BUFFER[i]:=RX+chr(127)      
                  AADD(tmpBUFF,RX+chr(127))
               else
                  return {"<command-success>"}
               end
            else  // si es linea vacía, no 
               if SWKEEPVACIO
               //return {}
                  AADD(tmpBUFF,""+chr(127))
               end
            end
         end
         DEFTOKEN:=TMPTOKEN  // resetea token
      end
        // resetea opcion de linea nula
   /*else
      DEFTOKEN:=TMPTOKEN
      _ERROR("EVALUADOR: NO USE ATAJOS {} SI VA A OPERAR SIN BUFFER")
      RETURN {}
   end*/
else
   //BUFFER:={}
   RX:=_EVALUA_EXPR(@R,"",1,.F.)
   if valtype(RX)=="L"
      DEFTOKEN:=TMPTOKEN
    //  ? "SALIO ",RX; inkey(0) 
      RETURN {"<error>"}  //{}
   end
   if valtype(RX)=="N"
      IF ABS(RX)>INFINITY().or. (ABS(RX)>0.and.ABS(RX)<0.000000000001)
         RX:=D2E(RX,5)
      else
         RX:=hb_ntos((RX))
      end
      AADD(tmpBUFF,RX+chr(127))
   else
      RX:=strtran(RX,chr(0),"")
      if len(RX)>0 
         if !("load" $ DX) .and. !("save" $ DX) .and. !("clear" $ DX)
            //AADD(BUFFER,RX+chr(127))
            
            AADD(tmpBUFF,RX+chr(127))
         else 
            return {"<command-success>"}
         end
      else
         if SWKEEPVACIO
            AADD(tmpBUFF,""+chr(127))
         end
      //   ? "RX es 0" ; inkey(0)
      //    return {}
      end
   end
end
DEFTOKEN:=TMPTOKEN
SWNOBUFFER:=.F.
SWKEEPVACIO:=.F.
SWSENSITIVE:=.T.
SWNOTNUL:=.F.

RETURN tmpBUFF  //BUFFER

function es_funcion(arg)
//local _pos:=0,_ret:=.F.,DICC,i,long
local DICC
/*DICC:={"LN","LOG","SQRT","ABS","INT","CEIL","FLOOR","SGN","ROUND","SIN","COS","TAN","UP","LO","MSK","MON","SAT","SAVE","LOAD",;
       "EXP","INV","RP","CAT","LEN","SUB","AT","AF","RAT","PTRP","PTRM","CP","TR","TK","VAL","CH","LIN","PC","PL","PR","IF",;
       "TRE","INS","DC","RPC","ONE","ASC","TRI","LTRI","RTRI","I","INC","DEC","NTK","IFLE","IFGE","LETK","MATCH","LET","DEFT",;
       "NT","POOL","LOOP","MOV","VAR","CLEAR","VOID","NOP","COPY","AND","OR","XOR","NOT","BIT","ON","OFF","BIN","HEX","~",;
       "JNZ","ELSE","ENDIF","RANGE"}*/
DICC:={"LN","LOG","SQRT","ABS","INT","CEIL","FLOOR","SGN","ROUND","SIN","COS","TAN","UP","LOW","MSK","MON","SAT","SAVE","LOAD",;
       "EXP","INV","RP","CAT","LEN","SUB","AT","AF","RAT","PTRP","PTRM","CP","TR","TK","VAL","CH","LIN","PC","PL","PR","IF",;
       "TRE","INS","DC","RPC","ONE","ASC","TRI","LTRI","RTRI","I","INC","DEC","IFLE","IFGE","TKLET","MATCH","LET","DEFT",;
       "NT","POOL","LOOP","MOV","VAR","NOP","COPY","AND","OR","XOR","NOT","BIT","ON","OFF","BIN","HEX","OCT","~",;
       "JNZ","ELSE","ENDIF","CLEAR","RANGE","STR","GLOSS","RND","L","TRA","TRB","AFA","ATA","TREA","TREB","TPC",;
       "FNA","FNB","FNC","FND","FNE","FNF",;
       "FNH","FNI","FNJ","FNK","FNL","FNM","FNN","FNO","FNP"}
       
/*long:=len(DICC)
for i:=1 to long
   if DICC[i]==arg
       //_pos:=Ascan(DICC, arg)
      _ret:=.T.
      exit
   end
end */
return iif(Ascan(DICC, arg)>0,.T.,.F.)  //_ret

function es_simbolo(c)
local _ret:=.F.

   if c=="+" .or. c=="-" .or. c=="*" .or. c=="/" .or.c=="%".or.;
      c==")" .or. c=="(" .or. c=="^" .or. c=="\" ;
      .or. c==">>" .or.c=="<<".or.c=="&".or.c=="|".or.c=="!"
      
      _ret:=.T.
   end

return _ret

function es_Lsimbolo(c)
local _ret:=.F.

   if c=="<=" .or. c==">=".or.c=="<>".or.c=="=".or.c=="<".or.c==">"
      _ret:=.T.
   end

return _ret


/*function SDP( _lista )
Local _last_valor,_nLongi

_Last_valor:=0
_nLongi := len( _lista )

   // Chequea si existen elementos
   if _nLongi == 0
      return ( nil )
   end

   // obtiene el ultimo valor
   _Last_valor := _lista[ _nLongi ]

   // Remueve el ultimo elemento del stack
   Asize( _lista, _nLongi - 1 )

   // Retorna el elemento extraido
return  _Last_valor */

function SDC( _lista )
local _last_valor,_nLongi
   _Last_valor:=0
   _nLongi := len( _lista )

   // Chequea si existen elementos
   if _nLongi == 0
      return ( nil )
   end

   // obtiene el ultimo valor
   _Last_valor := _lista[ 1 ]

   // Remueve el ultimo elemento del stack
   Adel ( _lista, 1 )
   Asize( _lista, _nLongi - 1 )

   // Retorna el elemento extraido
return  _Last_valor 


PROCEDURE _CTRL_L_ABS(BUFFER)
LOCAL cLEN,i,cDATO,nDATO
cLEN:=len(BUFFER)
for i:=1 to cLEN
   cDATO:=strtran(BUFFER[i],chr(127),"")
   if ISNOTATION(cDATO)==1
      nDATO:=E2D(cDATO)
   else
      nDATO:=val(cDATO)
   end
   BUFFER[i]:=hb_ntos((abs(nDATO)))+chr(127)
end
RETURN

PROCEDURE _CTRL_L_LN(BUFFER)
LOCAL cLEN,i,cDATO,nDATO
cLEN:=len(BUFFER)
for i:=1 to cLEN
   cDATO:=strtran(BUFFER[i],chr(127),"")
   if ISNOTATION(cDATO)==1
      nDATO:=E2D(cDATO)
   else
      nDATO:=val(cDATO)
   end
   BUFFER[i]:=hb_ntos((log(nDATO)))+chr(127)
end
RETURN

PROCEDURE _CTRL_L_LOG10(BUFFER)
LOCAL cLEN,i,cDATO,nDATO
cLEN:=len(BUFFER)
for i:=1 to cLEN
   cDATO:=strtran(BUFFER[i],chr(127),"")
   if ISNOTATION(cDATO)==1
      nDATO:=E2D(cDATO)
   else
      nDATO:=val(cDATO)
   end
   BUFFER[i]:=hb_ntos((log10(nDATO)))+chr(127)
end
RETURN

PROCEDURE _CTRL_L_CUAD(BUFFER)
LOCAL cLEN,i,cDATO,nDATO
cLEN:=len(BUFFER)
for i:=1 to cLEN
   cDATO:=strtran(BUFFER[i],chr(127),"")
   if ISNOTATION(cDATO)==1
      nDATO:=E2D(cDATO)
   else
      nDATO:=val(cDATO)
   end
   BUFFER[i]:=hb_ntos((nDATO^2))+chr(127)
end
RETURN

PROCEDURE _CTRL_L_SQRT(BUFFER)
LOCAL cLEN,i,cDATO,nDATO
cLEN:=len(BUFFER)
for i:=1 to cLEN
   cDATO:=strtran(BUFFER[i],chr(127),"")
   if ISNOTATION(cDATO)==1
      nDATO:=E2D(cDATO)
   else
      nDATO:=val(cDATO)
   end
   BUFFER[i]:=hb_ntos((sqrt(nDATO)))+chr(127)
end
RETURN

FUNCTION _CTRL_L_VSUMMEANSTDVAR(mainChoice,cLEN,BUFFER)
LOCAL nPOS,nSUM:=0,cDATO,nSol,nPROM, i

nPOS:=array(cLEN)
for i:=1 to cLEN
   cDATO:=alltrim(strtran(BUFFER[i],chr(127),""))
   if ISNOTATION(cDATO)==1
      nPOS[i]:=E2D(cDATO)
   else
      nPOS[i]:=val(cDATO)
   end
   nSUM:=nSUM + nPOS[i]
end
nSol:=nSUM
if mainChoice>=2
   nPROM:=nSUM/cLEN
   nSol:=nPROM
end
if mainChoice>=3
   nSUM:=0
   for i:=1 to cLEN
      nSUM:=nSUM + ((nPOS[i]-nPROM)^2)
   end
end
/// ? nSUM; inkey(0)
if mainChoice==3
   nSol:= SQRT(nSUM/cLEN)   ///sqrt( (nSUM/cLEN) - (nPROM^2) )
elseif mainChoice==4
   nSol:= nSUM/cLEN      ////(nSUM/cLEN) - (nPROM^2)
end
RELEASE nPOS

RETURN nSol


FUNCTION _CTRL_L_SUMSTDVARMEAN(mainChoice, nChoice, cLEN, BUFFER)
LOCAL tBUFFER,nOCURR,aSUM,nOCU,cDATO,nPOS,nPROM,nSUM:=0, TOK
LOCAL i,j

if nChoice==1 .or. nChoice==3  // vertical o total
   tBUFFER:=ARRAY(1)
   tBUFFER[1]:=""
   TOK:=DEFTOKEN
   nOCURR:=NUMTOKEN(BUFFER[1],TOK)  // este será el que mande.
   aSUM:=ARRAY(nOCURR)  // array de sumas verticales
   AFILL(aSUM,0)
   nPOS:=array(cLEN,nOCURR)  // matriz de resutados temporales. std y var
   for i:=1 to cLEN
      AFILL(nPOS[i],0)   // relleno con ceros
   end
   for i:=1 to cLEN
      nOCU:=NUMTOKEN(BUFFER[i],TOK)
      if nOCU>nOCURR  // si es mayor, solo calcula hasta donde puede.
         nOCU:=nOCURR  // no importa si es menor o igual
      end
      for j:=1 to nOCU
         cDATO:=alltrim(token(BUFFER[i],TOK,j))
         if ISNOTATION(cDATO)==1
            nPOS[i][j]:=E2D(cDATO)
         else
            nPOS[i][j]:=val(cDATO)
         end
         aSUM[j]+=nPOS[i][j]
      end
   end
                          
   if nChoice==1   // vertical
      if mainChoice==1
         for i:=1 to nOCURR-1
            tBUFFER[1]+=hb_ntos((aSUM[i]))+TOK
         end
         tBUFFER[1]+=hb_ntos((aSUM[nOCURR]))
      elseif mainChoice==2
         for i:=1 to nOCURR-1
            tBUFFER[1]+=hb_ntos((aSUM[i]/cLEN))+TOK
         end
         tBUFFER[1]+=hb_ntos((aSUM[nOCURR]/cLEN))
      elseif mainChoice==3  // std
         for i:=1 to nOCURR  // para cada columna
            nPROM:=aSUM[i]/cLEN
            nSUM:=0
            for j:=1 to cLEN   // recorro sus filas
               nSUM:=nSUM + ((nPOS[j][i]-nPROM)^2)
            end
            tBUFFER[1]+=hb_ntos(( SQRT(nSUM/cLEN) ))
            if i<nOCURR
               tBUFFER[1]+=TOK
            end
         end
      else     // var
         for i:=1 to nOCURR  // para cada columna
            nPROM:=aSUM[i]/cLEN
            nSUM:=0
            for j:=1 to cLEN   // recorro sus filas
               nSUM:=nSUM + ((nPOS[j][i]-nPROM)^2)
            end
            tBUFFER[1]+=hb_ntos(( (nSUM/cLEN) ))
            if i<nOCURR
               tBUFFER[1]+=TOK
            end
         end
      end
   else          // total
      if mainChoice==1
         for i:=1 to nOCURR
            nSUM+=aSUM[i]
         end
         tBUFFER[1]:=hb_ntos((nSUM))
      elseif mainChoice==2
         for i:=1 to nOCURR
            nSUM+=aSUM[i]
         end
         tBUFFER[1]:=hb_ntos((nSUM/(nOCURR*cLEN)))
      elseif mainChoice==3  // std
         for i:=1 to nOCURR
            nSUM+=aSUM[i]
         end
         nPROM:=nSUM/(nOCURR*cLEN)
         nSUM:=0
         for i:=1 to cLEN
            for j:=1 to nOCURR   // recorro sus filas
               nSUM:=nSUM + ((nPOS[i][j]-nPROM)^2)
            end
         end
         tBUFFER[1]:=hb_ntos(( SQRT(nSUM/(cLEN*nOCURR)) ))
      else    // var
         for i:=1 to nOCURR
            nSUM+=aSUM[i]
         end
         nPROM:=nSUM/(nOCURR*cLEN)
         nSUM:=0
         for i:=1 to cLEN
            for j:=1 to nOCURR   // recorro sus filas
               nSUM:=nSUM + ((nPOS[i][j]-nPROM)^2)
            end
         end
         tBUFFER[1]:=hb_ntos(( (nSUM/(cLEN*nOCURR)) ))
      end
   end
                          
 /*  IF LEN(BUFFER)>0
      FOR j:=1 to LEN(BUFFER)
         RELEASE BUFFER[j]
      END
   END
   BUFFER:=ARRAY(1)
   BUFFER[1]:=tBUFFER[1] */
                          
elseif nChoice==2   // horizontal
   tBUFFER:=ARRAY(cLEN)
   for i:=1 to cLEN
      TOK:=DEFTOKEN
      nOCURR:=NUMTOKEN(BUFFER[1],TOK)  // este será el que mande.
      nPOS:=array(nOCURR)
      for j:=1 to nOCURR
         cDATO:=alltrim(token(BUFFER[i],TOK,j))
         if ISNOTATION(cDATO)==1
            nPOS[j]:=E2D(cDATO)
         else
            nPOS[j]:=val(cDATO)
         end
         nSUM+=nPOS[j]
      end
      nPROM:=nSUM/nOCURR
      if mainChoice==1
         tBUFFER[i]:=hb_ntos((nSUM))+chr(127)
      elseif mainChoice==2
         tBUFFER[i]:=hb_ntos((nPROM))+chr(127)
      elseif mainChoice==3  // std
         nSUM:=0
         for j:=1 to nOCURR
            nSUM:=nSUM + ((nPOS[j]-nPROM)^2)
         end
         tBUFFER[i]:=hb_ntos((SQRT(nSUM/nOCURR)))+chr(127)
      else   // var
         nSUM:=0
         for j:=1 to nOCURR
            nSUM:=nSUM + ((nPOS[j]-nPROM)^2)
         end
         tBUFFER[i]:=hb_ntos((nSUM/nOCURR))+chr(127)
      end
      RELEASE nPOS
      nSUM:=0
   end
  /// ACOPY(tBUFFER,BUFFER)
end
RETURN tBUFFER

function ORIENTACION()
local cMessage, aOptions,nChoice
cMessage := hb_utf8tostr("¿Cómo deseas la operación?")
aOptions := { "Vertical","Horizontal","Total" }
nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
return nChoice

function VERIFICAMODIFICADO(STRING,cMETADATA)
local i,j

   for i:=1 to len(cMETADATA)
      if cMETADATA[i][1]==STRING
         return cMETADATA[i][10]
      end
   end

return .F.

function UDFAchoice( nMode, nCurElement, nRowPos )

local nRetVal := AC_CONT                // Default, Continue
local nKey    := lastkey()

local nRow := Row()
local nCol := Col()

HB_SYMBOL_UNUSED( nRowPos )

///@ 0, 20 SAY Str( nRow, 3 ) + " " + Str( nCol, 3 )

do case
   // After all pending keys are processed, display message
case nMode == AC_IDLE
   ///@  0,  0 say padr( ltrim( str( nCurElement ) ), 10 )
   nRetVal := AC_CONT                   // Continue ACHOICE()
case nMode == AC_HITTOP                 // Attempt to go past Top
   ///@  0,  0 say "Hit Top   "
// tone( 100, 3 )
case nMode == AC_HITBOTTOM              // Attempt to go past Bottom
   ///@  0,  0 say "Hit Bottom"
// tone( 100, 3 )
case nMode == AC_EXCEPT                 // Key Exception
   ///@  0,  0 say "Exception "
   do case
   case nKey == K_RETURN                // If RETURN key, select
      nRetVal := AC_SELECT
   case nKey == K_ESC                   // If ESCAPE key, abort
      nRetVal := AC_ABORT
   case nKey == K_DEL
      nRetVal := AC_SELECT
      SWELIMINATAB:=.T.

   otherwise
      nRetVal := AC_GOTO                // Otherwise, go to item
   endcase
endcase
return nRetVal

PROCEDURE SHOWOUTPUT()
   hb_keyPut(15)
   hb_keyPut(1)
RETURN

FUNCTION INSERTMENU(CTRL)

MCONTROL:=ARRAY(2)

MENUMATCH:={}
MENU:={}
if SWLENGUAJE==1
  if CTRL==1  // Estructuras de control  ^VC
    AADD(MENUMATCH,"for to / next         ")
    AADD(MENUMATCH,"for to step / next    ")
    AADD(MENUMATCH,"for downto / next     ")
    AADD(MENUMATCH,"for downto step / next")
    AADD(MENUMATCH,"while / wend          ")
    AADD(MENUMATCH,"do / until            ")
    AADD(MENUMATCH,"if / endif            ")
    AADD(MENUMATCH,"if / else / endif     ")
    AADD(MENUMATCH,"if / elseif... / endif")
    AADD(MENUMATCH,"for each in / next    ")
    AADD(MENUMATCH,"for each inlist / next")
    AADD(MENUMATCH,"try / exception       ")
    AADD(MENUMATCH,"sub / back            ")
     
    AADD(MENU,{"for <- to "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"for <- to  step "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"for <- downto "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"for <- downto  step "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"while "+_CR+"   "+_CR+"wend",5,0})
    AADD(MENU,{"do"+_CR+"   "+_CR+"until ",5,0})
    AADD(MENU,{"if "+_CR+"   "+_CR+"endif",5,0})
    AADD(MENU,{"if "+_CR+"   "+_CR+"else"+_CR+"   "+_CR+"endif",5,3})
    AADD(MENU,{"if "+_CR+"   "+_CR+"elseif "+_CR+"   "+_CR+"else"+_CR+"   "+_CR+"endif",5,5})
    AADD(MENU,{"for each  in "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"for each  inlist "+_CR+"   "+_CR+"next",5,0})
    AADD(MENU,{"try"+_CR+"   "+_CR+"   //raise(n)"+_CR+"exception"+_CR+"   //write whatsup()"+_CR+"   //again"+_CR+"tend",5,5})
    AADD(MENU,{'sub "<label>"'+_CR+"   "+_CR+"back"+_CR+_CR+'//gosub "<label>"',5,3})

  elseif CTRL==2
    AADD(MENUMATCH," Asignación agrupada            {a,b,...} <- {v,w,...}   (a<-v; b<-w; ...)           ")
    AADD(MENUMATCH," Bifurcación en línea           { ? : }   (Usar dentro de otra bifurcación en línea)")
    AADD(MENUMATCH," Asignación democrática         var <- {v,w,...}                                     ")
    AADD(MENUMATCH," Asignación bifurcada           var <- {{ <expr-L> ? !{v,w,...} :  }}                ")
    AADD(MENUMATCH," Asignación selectiva           !{  ?  :  } <- Var/valor                             ")
    AADD(MENUMATCH," Asignación selectiva agrupada  !{  ?  :  } <- {a,b,...}  ")
    AADD(MENUMATCH," Asignación selectiva bifurcada !{  ?  :  } <- {  ?  :  } ")
    AADD(MENUMATCH," Macro matriz de 1 dimensión    var <- _(( dim ) { v,w,... })")
    AADD(MENUMATCH," Macro matriz de 1 dimensiones  var <- _(( dim ) { ...,!{  ? : },... })")
    AADD(MENUMATCH," Macro matriz de 2 dimensiones  var <- _(( dim1,dim2 ) {{,},{,},...}) ")
    AADD(MENUMATCH," Macro matriz de 3 dimensiones  var <- _((dim1,dim2,dim3) {{{,},{,}},{{,},{,}},...}) ")
    
    AADD(MENU,{"{  } <- {  }",0,0})
    AADD(MENU,{"{ ? : }",0,0})
    AADD(MENU,{"  <- {  }",0,0})
    AADD(MENU,{"  <- {{  ? !{  } :  }}",0,0})
    AADD(MENU,{"!{  ?  :  } <- ",0,0})
    AADD(MENU,{"!{  ?  :  } <- {  }",0,0})
    AADD(MENU,{"!{  ?  :  } <- {  ?  :  }",0,0})
    AADD(MENU,{" <- _((  ) {  })",0,0})
    AADD(MENU,{" <- _((  ) { !{  ? : } })",0,0})
    AADD(MENU,{" <- _((,) {{,},{,}})",0,0})
    AADD(MENU,{" <- _((,,) {{{,},{,}},{{,},{,}}})",0,0})

  elseif CTRL==4
    AADD(MENUMATCH,hb_utf8tostr(" function string        : declara una función que devuelve un string"))
    AADD(MENUMATCH,hb_utf8tostr(" function matriz string : declara una función que devuelve una matriz de string"))
    AADD(MENUMATCH,hb_utf8tostr(" function number        : declara una función que devuelve un número"))
    AADD(MENUMATCH,hb_utf8tostr(" function matriz number : declara una función que devuelve una matriz de números"))
    AADD(MENUMATCH,hb_utf8tostr(" function booleana      : declara una función que devuelve un valor booleano"))
    AADD(MENUMATCH,hb_utf8tostr(" function matriz bool   : declara una función que devuelve una matriz de booleanos"))
    AADD(MENUMATCH,hb_utf8tostr(" function stack         : declara una función que devuelve un stack"))
    AADD(MENUMATCH,hb_utf8tostr(" procedure              : declara una función que no devuelve nada"))
    
    AADD(MENU,{"F([param:type[,...]]):string"+_CR+"r:=string"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):^string"+_CR+"r:=^string"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):number"+_CR+"r:=number"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):^number"+_CR+"r:=^number"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):boolean"+_CR+"r:=boolean"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):^boolean"+_CR+"r:=^boolean"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):stack"+_CR+"r:=stack"+_CR+"begin:"+_CR+"   "+_CR+"   return r"+_CR+"end",5,2})
    AADD(MENU,{"F([param:type[,...]]):void"+_CR+"begin:"+_CR+"   "+_CR+"end",5,0})
  end
elseif SWLENGUAJE==2
  if CTRL==1
    AADD(MENUMATCH," for            ")
    AADD(MENUMATCH," while          ")
    AADD(MENUMATCH," do/while       ")
    AADD(MENUMATCH," if             ")
    AADD(MENUMATCH," if/else        ")
    AADD(MENUMATCH," if/else if     ")
    AADD(MENUMATCH," switch/case    ")
    
    AADD(MENU,{"for(  ;  ;  )"+_CR+"{"+_CR+"   "+_CR+"}",5,1})
    AADD(MENU,{"while(  )"+_CR+"{"+_CR+"   "+_CR+"}",5,1})
    AADD(MENU,{"do"+_CR+"{"+_CR+"   "+_CR+"}while(  );",5,1})
    AADD(MENU,{"if(  )"+_CR+"{"+_CR+"   "+_CR+"}",5,1})
    AADD(MENU,{"if(  )"+_CR+"{"+_CR+"   "+_CR+"}else{"+_CR+"   "+_CR+"}",5,3})
    AADD(MENU,{"if(  )"+_CR+"{"+_CR+"   "+_CR+"}else if(  ){"+_CR+"   "+_CR+"}",5,3})
    AADD(MENU,{"switch( )"+_CR+"{"+_CR+"   case  : {"+_CR+"      "+_CR+"   }"+_CR+"   default:{"+_CR+"      "+_CR+"   }"+_CR+"}",5,4})
  elseif CTRL==2
    //
    AADD(MENUMATCH,hb_utf8tostr(" Setea string malloc (no recomendado)  "))
    AADD(MENUMATCH,hb_utf8tostr(" Setea string calloc                   "))
    AADD(MENUMATCH,hb_utf8tostr(" bifurcación inline                    "))
    AADD(MENUMATCH,hb_utf8tostr(" Abrir o crear un archivo              "))
    AADD(MENUMATCH,hb_utf8tostr(" Macro mínimo entre 2 enteros          "))
    AADD(MENUMATCH,hb_utf8tostr(" Macro máximo entre 2 enteros          "))
    AADD(MENUMATCH,hb_utf8tostr(" Macro intercambio entre 2 enteros     "))
    
    AADD(MENU,{"sVAR=(char *)malloc(sizeof(char *));"+_CR+"if( sVAR== NULL ){"+_CR+"   return NULL;"+_CR+"}",5,3})
    AADD(MENU,{"sVAR=(char *)calloc( <N>,sizeof(char *));"+_CR+"if( sVAR== NULL ){"+_CR+"   return NULL;"+_CR+"}",5,3})
    AADD(MENU,{"( ? : )",0,0})
    AADD(MENU,{'//MODO: "r"=lee; "w"=escribe/crea; "a"=añade; "<rwa>b"=archivo binario'+_CR+'FILE *fp;'+_CR+;
               'if ( (fp=fopen("file","MODO"))==NULL){'+_CR+'   printf("No puedo abrir el archivo\n");'+_CR+;
               '   return 1;'+_CR+'} else {'+_CR+'   /* instrucciones */'+_CR+'   fclose(fp);'+_CR+'}',1,1})
    AADD(MENU,{"#define MIN(A,B)  ( (A) < (B) ? (A) : (B) )",0,0})
    AADD(MENU,{"#define MAX(A,B)  ( (A) > (B) ? (A) : (B) )",0,0})
    AADD(MENU,{"#define SWAP(A,B)  ( { A^=B; B^=A; A^=B; } )",0,0})
    
  elseif CTRL==4
    AADD(MENUMATCH,hb_utf8tostr("stdlib.h : atof,atoi,malloc,free,abs...   "))
    AADD(MENUMATCH,hb_utf8tostr("string.h : strcpy,strcat,strtok,strcmp... "))
    AADD(MENUMATCH,hb_utf8tostr("math.h   : sqrt,log,exp,fabs,pow,sin...   "))
    AADD(MENUMATCH,hb_utf8tostr("time.h   : time,asctime,mktime,strftime..."))
    AADD(MENUMATCH,hb_utf8tostr("ctype.h  : isalpha,isdigit,isupper,is...  "))
    AADD(MENUMATCH,hb_utf8tostr("assert.h : assert                         "))
    AADD(MENUMATCH,hb_utf8tostr("stdarg.h : va_list,va_start,va_end,va_arg "))
    AADD(MENUMATCH,hb_utf8tostr("setjmp.h : setjmp,longjmp                 "))
    AADD(MENUMATCH,hb_utf8tostr("signal.h : signal,raise                   "))
    AADD(MENUMATCH,hb_utf8tostr("limits.h : CHAR_BIT,CHAR_MAX,INT_MAX...   "))
    AADD(MENUMATCH,hb_utf8tostr("float.h  : FLT_DIG,DBL_DIG,DBL_MAX...     "))
    
    AADD(MENU,{"#include <stdlib.h>",0,0})
    AADD(MENU,{"#include <string.h>",0,0})
    AADD(MENU,{"#include <math.h>",0,0})
    AADD(MENU,{"#include <time.h>",0,0})
    AADD(MENU,{"#include <ctype.h>",0,0})
    AADD(MENU,{"#include <assert.h>",0,0})
    AADD(MENU,{"#include <stdarg.h>",0,0})
    AADD(MENU,{"#include <setjmp.h>",0,0})
    AADD(MENU,{"#include <signal.h>",0,0})
    AADD(MENU,{"#include <limits.h>",0,0})
    AADD(MENU,{"#include <float.h>",0,0})
  end
elseif SWLENGUAJE==3   // latex
  if CTRL==1   // ^VC
    AADD(MENUMATCH," Agrega preambulo para enumerate ")
    AADD(MENUMATCH," Lista simple (itemize)          ")
    AADD(MENUMATCH," Lista enumerada (enumerate)     ")
    AADD(MENUMATCH," Pasos de algoritmo              ")
    AADD(MENUMATCH," Entorno de descripcion          ")
    AADD(MENUMATCH," Tabla simple                    ")
    AADD(MENUMATCH," Tabla multicolumna (ejemplo)    ")
    AADD(MENUMATCH," Agrega preambulo para graficos  ")
    AADD(MENUMATCH," Inserta grafico                 ")
    AADD(MENUMATCH," Escalar grafico                 ")
    AADD(MENUMATCH," Rotar grafico                   ")
    
    AADD(MENU,{"\usepackage{enumerate}",0,0})
    AADD(MENU,{"\begin{itemize}"+_CR+"  \item ..."+_CR+"\end{itemize}",5,1})
    AADD(MENU,{"\begin{enumerate}"+_CR+"  \item ..."+_CR+"\end{enumerate}",5,1})
    AADD(MENU,{"\begin{enumerate}[\hspace*{0.5cm}\bfseries P{a}so 1]"+_CR+;
               "  \item ..."+_CR+"  \begin{enumerate}[(a)]"+"    \item ..."+_CR+;
               "  \end{enumerate}"+_CR+"\end{enumerate}",5,3})
    AADD(MENU,{"\begin{description}"+_CR+"  \item[*your tip*] ..."+_CR+"\end{description}",5,1})
    AADD(MENU,{"\begin{tabular}{|c|c|c|}"+_CR+"\hline"+_CR+"head1 & head2 & head3 \\"+_CR+;
               "\hline"+_CR+"dato1 & dato2 & dato3 \\"+_CR+"\hline"+_CR+"\end{tabular}",5,4})
    AADD(MENU,{"\begin{tabular}{|l|r|r|}"+_CR+"\hline"+_CR+"        & \multicolumn{2}{c|}{Distancia al Sol} \\"+_CR+;
               "Planeta & \multicolumn{2}{c|}{(millones de km)} \\"+_CR+"\cline{2-3}"+_CR+;
               "        & Máxima & Mínima \\"+_CR+"\hline"+_CR+"Mercurio & 69.4 & 46.8 \\"+_CR+;
               "Venus & 109.0 & 107.6 \\"+_CR+"Tierra & 152.6 & 147.4 \\"+_CR+"\hline"+_CR+"\end{tabular}",0,0})
    AADD(MENU,{"\usepackage{graphicx}",0,0})
    AADD(MENU,{"\includegraphics[width=<N>cm,height=<M>cm] {archivo.jpg}",0,0})
    AADD(MENU,{"\includegraphics[scale=<N0..1>]{archivo.jpg}",0,0})
    AADD(MENU,{"\includegraphics[angle=<A>]{archivo.jpg}",0,0})
    
  elseif CTRL==2   // ^VA
    //
    AADD(MENUMATCH,hb_utf8tostr(" Agregar preámbulo para Maths  "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz con () {pmatrix}       "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz con [] {bmatrix}       "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz con {} {Bmatrix}       "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz con || {vmatrix}       "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz con |||| {Vmatrix}     "))
    AADD(MENUMATCH,hb_utf8tostr(" Matriz en línea {smalltrix}   "))
    AADD(MENUMATCH,hb_utf8tostr(" Determ. en línea {smalltrix}  "))
    
    AADD(MENU,{"\usepackage{amsmath}"+_CR+"\usepackage{amssymb}",0,0})

    AADD(MENU,{"\[\begin{pmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{pmatrix}\]",0,0})
    AADD(MENU,{"\[\begin{bmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{bmatrix}\]",0,0})
    AADD(MENU,{"\[\begin{Bmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{Bmatrix}\]",0,0})
    AADD(MENU,{"\[\begin{vmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{vmatrix}\]",0,0})
    AADD(MENU,{"\[\begin{Vmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{Vmatrix}\]",0,0})
    AADD(MENU,{"$\left(\begin{smallmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{smallmatrix}\right)$",0,0})
    AADD(MENU,{"$\left|\begin{smallmatrix}"+_CR+"A_1 & A_2 & A_3 \\"+_CR+;
               "B_1 & B_2 & B_3 \\"+_CR+;
               "C_1 & C_2 & C_3 \\"+_CR+"\end{smallmatrix}\right|$",0,0})

  elseif CTRL==4   // ^VF
    AADD(MENUMATCH,hb_utf8tostr(" Agregar preámbulo para Maths  "))
    AADD(MENUMATCH,hb_utf8tostr(" Raiz cuadrada                 "))
    AADD(MENUMATCH,hb_utf8tostr(" Raiz enesima                  "))
    AADD(MENUMATCH,hb_utf8tostr(" Fracciones                    "))
    AADD(MENUMATCH,hb_utf8tostr(" Binomios                      "))
    AADD(MENUMATCH,hb_utf8tostr(" Parentesis ajustados          "))
    AADD(MENUMATCH,hb_utf8tostr(" Productoria subíndice abajo   "))
    AADD(MENUMATCH,hb_utf8tostr(" Productoria subíndice lado    "))
    AADD(MENUMATCH,hb_utf8tostr(" Productoria varios subíndices "))
    AADD(MENUMATCH,hb_utf8tostr(" Sumatoria subíndice abajo     "))
    AADD(MENUMATCH,hb_utf8tostr(" Sumatoria subíndice lado      "))
    AADD(MENUMATCH,hb_utf8tostr(" Ecuación                      "))
    AADD(MENUMATCH,hb_utf8tostr(" Lista de ecuaciones (ejemplo) "))
    AADD(MENUMATCH,hb_utf8tostr(" Límite infinito               "))
    AADD(MENUMATCH,hb_utf8tostr(" Integral simple               "))
    AADD(MENUMATCH,hb_utf8tostr(" Derivada parcial              "))
    AADD(MENUMATCH,hb_utf8tostr(" Integral doble                "))
    AADD(MENUMATCH,hb_utf8tostr(" Integral triple               "))
    AADD(MENUMATCH,hb_utf8tostr(" Integral circular             "))
    AADD(MENUMATCH,hb_utf8tostr(" Integral n-dimensional        "))
    
    AADD(MENU,{"\usepackage{amsmath}"+_CR+"\usepackage{amssymb}",0,0})
    AADD(MENU,{"\sqrt{}",0,0})
    AADD(MENU,{"\sqrt[]{}",0,0})
    AADD(MENU,{"\frac{}{}",0,0})
    AADD(MENU,{"\binom{n}{k}",0,0})
    AADD(MENU,{"\left( ... \right)",0,0})
    AADD(MENU,{"\prod\limits_{}^{}",0,0})
    AADD(MENU,{"\prod\nolimits_{}^{}",0,0})
    AADD(MENU,{"\prod_{\substack{i=1\\i\ne k}}^n\left( ... \right)",0,0})
    AADD(MENU,{"\sum\limits_{}^{}",0,0})
    AADD(MENU,{"\sum\nolimits_{}^{}",0,0})
    AADD(MENU,{"\begin{equation}"+_CR+"   "+_CR+"\end{equation}",0,0})
    AADD(MENU,{"\begin{equation}"+_CR+" \left."+_CR+"  \begin{aligned}"+_CR+"    x_0 & = 0 \\"+;
               _CR+"     y_0 & = 0"+_CR+"  \end{aligned}"+_CR+" \right\}"+_CR+"\quad\text{texto expicativo}"+_CR+;
               "\end{equation}",0,0})
    AADD(MENU,{"\lim\limits_{x\to\infty}",0,0})
    AADD(MENU,{"\int_a^b f(x)\,\mathrm{d}x",0,0})
    AADD(MENU,{"\frac{\partial x}{\partial t}",0,0})
    AADD(MENU,{"\iint f(x,y)\,\mathrm{d}x\,\mathrm{d}y",0,0})
    AADD(MENU,{"\iiint f(x,y,z)\,\mathrm{d}x\,\mathrm{d}y\,\mathrm{d}z",0,0})
    AADD(MENU,{"\oint_a^b f(x)\,\mathrm{d}x",0,0})
    AADD(MENU,{"\idotsint_M \mathrm{d}x_1\dots \mathrm{d}x_n",0,0})
    
  end
end

MCONTROL[1]:=ACLONE(MENUMATCH)
MCONTROL[2]:=ACLONE(MENU)

RELEASE MENUMATCH
RELEASE MENU

RETURN MCONTROL

PROCEDURE MSGOPE(TIP)
LOCAL MSG
MSG:=" ^W=FINISH ^Y=DEL LINE ^V=INS ^P=PASTE ESC=CLEAN/CANCEL"
if pCount()>0
   if len(TIP)>0
      MSG+=" | "+TIP
   end
end 
setpos(TLINEA-1,2);outstd(iif(len(MSG)+2>SLINEA,SUBSTR(MSG,1,SLINEA-2),MSG ))
RETURN

PROCEDURE MSGINPUT(TIP)
LOCAL MSG
MSG:="^C=Cancel  ESC=clean  RETURN=End"
/*if pCount()>0
   if len(TIP)>0
      MSG+=" | "+TIP
   end
end */
setpos(TLINEA-1,2);outstd(MSG)
setpos(TLINEA,  2);outstd(iif(len(TIP)+2>SLINEA,SUBSTR(TIP,1,SLINEA-2),TIP ))

RETURN

PROCEDURE MSGCONTROL(MSG,MSG2,MSG3)
SETCOLOR(N2COLOR(cBARRA))
@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
MSG:=iif(len(MSG)>SLINEA, substr(MSG,1,SLINEA-1),MSG)
MSG2:=iif(len(MSG2)>SLINEA, substr(MSG2,1,SLINEA-1),MSG2)
MSG3:=iif(len(MSG3)>SLINEA, substr(MSG3,1,SLINEA-1),MSG3)
setpos(TLINEA-2,1);outstd(MSG)
setpos(TLINEA-1,1);outstd(MSG2)
setpos(TLINEA,  1);outstd(MSG3)
return


PROCEDURE MSGBARRA(MSG,ARCHIVO,SALIDA)
SETCOLOR(N2COLOR(cBARRA))
@ TLINEA-2,0 CLEAR TO TLINEA,MAXCOL()
setpos(TLINEA-1,int(SLINEA/2)-INT(LEN(MSG)/2));outstd(iif(len(MSG)>SLINEA, substr(MSG,1,SLINEA-1),MSG))
if SALIDA<2
   setpos(TLINEA  ,int(SLINEA/2)-15);outstd("(Press any key to continue...)")
else
   setpos(TLINEA  ,int(SLINEA/2)-14);outstd("(Press ESC to continue...)")
end
if SALIDA==1
   inkey(0)
   BarraTitulo(ARCHIVO)
end
RETURN

/*FUNCTION PREPARATEXTOBIN(TEXTO,INI,FIN,nOFFSET) // NOFFSET+1 EN LA LLAMADA
LOCAL STRING:="",I
  FOR I:=INI TO FIN
     STRING+=SUBSTR(TEXTO[I],nOFFSET,LEN(TEXTO[I])
  END
   
RETURN STRING */

FUNCTION SAVEBIN(TEXTO,ARCHIVO,TOPE,nOFFSET)
LOCAL I,J,FP,STRING,LIN

  IF (FP:=FCREATE(ARCHIVO))==F_ERROR
     RETURN .F.
  END
  LIN:=0
  FOR I:=1 TO TOPE
     ///STRING:=hb_strtoutf8(TEXTO[I]+_CR)
     for J:=nOFFSET to LEN(TEXTO[I])
        STRING:=I2BIN(ASC(SUBSTR(TEXTO[I],J,1)))
        FWRITE(FP,STRING,1)
     end
  END
  FCLOSE(FP)

  /*       if OPERATING_SYSTEM=="LINUX" 
            EXT:=FUNFSHELL("file -i "+AX,3)
         elseif OPERATING_SYSTEM=="DARWIN"
            EXT:=FUNFSHELL("file -I "+AX,3)
         end 
         EXT:=STRTRAN(EXT,HB_OSNEWLINE(),"")
         TEXTOTIPO:=UPPER(SUBSTR(EXT,AT("=",EXT)+1,LEN(EXT)))
         LENTEXTOTIPO:=LEN(TEXTOTIPO)
    */     
RETURN .T.

FUNCTION SAVEFILE(TEXTO,ARCHIVO,TOPE)
LOCAL I,FP,STRING,J,LIN,EXT

  IF (FP:=FCREATE(ARCHIVO))==F_ERROR
     RETURN .F.
  END
  LIN:=0
  FOR I:=1 TO TOPE
     STRING:=hb_strtoutf8(TEXTO[I]+_CR)
     FWRITE(FP,STRING,LEN(STRING))
     ++LIN
  END
  FCLOSE(FP)

         if OPERATING_SYSTEM=="LINUX" 
            EXT:=FUNFSHELL("file -i "+ARCHIVO,3)
         elseif OPERATING_SYSTEM=="DARWIN"
            EXT:=FUNFSHELL("file -I "+ARCHIVO,3)
         end 
         EXT:=STRTRAN(EXT,HB_OSNEWLINE(),"")
         TEXTOTIPO:=UPPER(SUBSTR(EXT,AT("=",EXT)+1,LEN(EXT)))
         LENTEXTOTIPO:=LEN(TEXTOTIPO)  

RETURN .T.

PROCEDURE REFORMAT(TEXTO,nOFFSET,CODE,POS,LONG)
LOCAL LIN,TOPE,STRING,I,cBUFF,cBUFHEX,CNT,LN, c
  LIN:=0
  TOPE:=LEN(TEXTO)
  STRING:=""
  FOR I:=1 TO TOPE
     ///STRING:=hb_strtoutf8(TEXTO[I]+_CR)
     for J:=nOFFSET to LEN(TEXTO[I])
        STRING+=SUBSTR(TEXTO[I],J,1)
     end
  END
  IF CODE==1  // Borra. luego, reformatea
     STRING:=substr(STRING,1,POS-1)+substr(STRING,POS+LONG,len(STRING))
     TOPE:=int(len(STRING)/20)+1  // recalcula número de líneas.
     if TOPE<LEN(TEXTO)
        asize(TEXTO,TOPE)
     end
  ELSEIF CODE==0  // sobeescribe
     STRING:=substr(STRING,1,POS-1)+LONG+substr(STRING,POS+len(LONG),len(STRING))
  ELSEIF CODE==2  // inserta posiciones; LONG es, ahora, un string de caracteres
     STRING:=substr(STRING,1,POS-1)+LONG+substr(STRING,POS,len(STRING))
  END
  cBUFF:=""
  cBUFHEX:=""
  CNT:=1
  OFFSET:=0
  OFFSETI:=0
  NUMCAR:=LEN(STRING)
 // ? "NUMCAR:=",NUMCAR; inkey(0)
  I:=1
  LN:=1

  WHILE I<=NUMCAR
     c:=asc(substr(STRING,I,1))
     cBUFF+=chr(c)
     cBUFHEX+=PADR(DECTOHEXA(c),2)+" "//iif(++cSP==4 .and. CNT<21,"  "," ")//" "
     ++CNT
               
     if CNT==21
        TEXTO[LN]:=""
        TEXTO[LN]:=" "+PADL(DECTOHEXA(OFFSETI),7)+" : "+PADL(DECTOHEXA(OFFSET),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF
        OFFSETI:=OFFSET+1
        cBUFF:=""
        cBUFHEX:=""
        CNT:=1
        ++LN
        if LN>TOPE
           ASIZE(TEXTO,++TOPE)
        end
     end

     ++OFFSET
     ++I
  END
  if len(cBUFF)>0
     if len(cBUFHEX)<58  //56
        //cBUFHEX:=cBUFHEX+SPACE(65-LEN(cBUFHEX))
        cBUFHEX:=cBUFHEX+SPACE(60-LEN(cBUFHEX))
     end
        TEXTO[LN]:=""
        TEXTO[LN]:=" "+PADL(DECTOHEXA(OFFSETI),7)+" : "+PADL(DECTOHEXA(OFFSET-1),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF
     cBUFF:=""
  end
  if esnulo(TEXTO[len(TEXTO)]) //TEXTO[len(TEXTO)]==NIL
     --TOPE
//  if TOPE<LEN(TEXTO)
     ASIZE(TEXTO,TOPE)
  end
  STRING:=""
RETURN


FUNCTION FORMATBIN()

RETURN

FUNCTION LEEBINARIO(FP)
LOCAL STRING,cBUFF,NL,I,NUMCAR:=0,EXT,SW,S,LINEA,READFILE,CNT,cBUFHEX,OFFSET,OFFSETI,cSP

                  STRING:={}
                  NUMCAR:=FSEEK(FP,0,2)
                  FSEEK(FP,0,0)
                  I:=1
                  S:=SPACE(1)
                  cBUFF:=""
                  cBUFHEX:=""
                  CNT:=1
                  OFFSET:=0
                  OFFSETI:=0
                  cSP:=0
                  while I<=NUMCAR
                     FREAD(FP,@S,1)
                 //    if BIN2I(S)!=127
                        cBUFF+=CHR(BIN2I(S)) //+" "
                 //    else
                 //       cBUFF+=" "
                 //    end
                   //      cBUFHEX+="0 "+" " //iif(++cSP==4 .and. CNT<21,"  "," ")//" "
                   //  else
                         cBUFHEX+=PADR(DECTOHEXA(BIN2I(S)),2)+" " //iif(++cSP==4 .and. CNT<21,"  "," ")
                   //  end
                     ++CNT
                     
                     if CNT==21
                      //  if OFFSETI==0
                      //     AADD(STRING," "+PADL(0,7)+" : "+PADL(DECTOHEXA(OFFSET),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF)
                      //  else
                           AADD(STRING," "+PADL(DECTOHEXA(OFFSETI),7)+" : "+PADL(DECTOHEXA(OFFSET),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF)
                      //  end
                        OFFSETI:=OFFSET+1
                        cBUFF:=""
                        cBUFHEX:=""
                        CNT:=1
                     end
                     ++OFFSET
                     ++I
                  end
                  if len(cBUFF)>0
                     if len(cBUFHEX)<58  //56
                        cBUFHEX:=cBUFHEX+SPACE(60-LEN(cBUFHEX))
                     end
                  //   if OFFSETI==0
                  //      AADD(STRING," "+PADL(0,7)+" : "+PADL(DECTOHEXA(OFFSET-1),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF)
                  //   else
                        AADD(STRING," "+PADL(DECTOHEXA(OFFSETI),7)+" : "+PADL(DECTOHEXA(OFFSET-1),7)+" |"+chr(178)+" "+cBUFHEX+chr(177)+"|"+chr(178)+" "+cBUFF)
                  //   end
                     cBUFF:=""
                  end

RETURN STRING

FUNCTION XREADLINE(AX,SIZE)
LOCAL STRING,cBUFF,FP,NL,I,J,NUMCAR:=0,EXT,SW,S,LINEA,READFILE,CNT,cBUFHEX,OFFSET,OFFSETI,cSP /*,XNUMCAR*/
               local cMessage, aOptions,nChoice
   AX:=ALLTRIM(AX)

   STRING:={}
   

   FP:=FOPEN(AX,0)
   IF FERROR()==0
      
      // si no concuerda el tamaño del archivo con lo leido, opcion binaria ON.
     // XNUMCAR:=FSEEK(FP,0,2)
     // FSEEK(FP,0,0)
      
      if !SWBINARY
         if OPERATING_SYSTEM=="LINUX" 
            EXT:=FUNFSHELL("file -i "+chr(34)+AX+chr(34),3)
         elseif OPERATING_SYSTEM=="DARWIN"
            EXT:=FUNFSHELL("file -I "+chr(34)+AX+chr(34),3)
         end 
         EXT:=STRTRAN(EXT,HB_OSNEWLINE(),"")
         EXT:=substr(EXT,at("=",EXT)+1,len(EXT))
        // ? "EXT=",EXT; inkey(0)
         
      else
         EXT:="binary"
         SWBINARY:=.F.
      end
       //  ? "EXT=",EXT ; inkey(0)
         if EXT=="utf-8" .or. EXT=="us-ascii"
            READFILE:=CUENTALINEAS(AX)
            NUMCAR:=READFILE[2]
            NL:=READFILE[1]
            MAXLONG:=READFILE[3]
//            ? "NUMCAR=",NUMCAR,"  NL=",NL," MAXLONG=",MAXLONG; inkey(0)
            SW:=.F.
            if NUMCAR>0 /*.and. MAXLONG==0*/ .and. NL==1
               READFILE:=SPCUENTALINEAS(AX)
               NUMCAR:=READFILE[2]
               NL:=READFILE[1]
               MAXLONG:=READFILE[3]
              // ? "NUMCAR=",NUMCAR,"  NL=",NL," MAXLONG=",MAXLONG; inkey(0)
               SW:=.T.
            end
            if NUMCAR>0
               if MAXLONG>0 .and. NL>0
                  cBUFF:=HB_UTF8TOSTR(FREADSTR(FP,NUMCAR))
                  if SW
                     cBUFF:=strtran(cBUFF,chr(13),chr(10))
                     cMessage := hb_utf8tostr("Este archivo tiene caracteres truculentos."+_CR+;
                            "Sin embargo, creo que puedo editarlo."+_CR+;
                            "Si la edición tiene problemas, identifique el o los caracteres"+_CR+;
                            "problemáticos, e intente una edición hexadecimal"+_CR+;
                            "cargando el archivo con opción '-bin' desde la consola")
                     aOptions := { "Okay" }
                     nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                  end
                  NUMCAR:=LEN(cBUFF)
                  STRING:=GETLINEAS(cBUFF,NL,NUMCAR,MAXLONG)
               else 
               ///if STRING[len(STRING)]=="ERROR-DE-FORMATO-NO-RECONOCIDO"

                  cMessage := hb_utf8tostr("Este archivo tiene caracteres no reconocidos:"+_CR+"Se cargará como edición hexadecimal"+_CR+_CR+;
                            "Puedes usar ^NN para buscar caracteres raros, y"+_CR+"usar ^NA o ^NR para reemplazarlos"+_CR+;
                            "(Nota: no se puedes usar ^Z en esta edición)")
                  aOptions := { "Okay" }
                  nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )

                  EXT:="binary"
                  STRING:=LEEBINARIO(FP)
                  NL:=LEN(STRING)
               end
            else
                NL:=1
                AADD(STRING,"")
            end
         elseif "iso-8859" $ EXT .or. "unknown-8bit" $ EXT
            READFILE:=CUENTALINEAS(AX)
            NUMCAR:=READFILE[2]
            NL:=READFILE[1]
            MAXLONG:=READFILE[3]
            SW:=.F.
            if NUMCAR>0 .and. MAXLONG==0 .and. NL==1
               READFILE:=SPCUENTALINEAS(AX)
               NUMCAR:=READFILE[2]
               NL:=READFILE[1]
               MAXLONG:=READFILE[3]
              // ? "NUMCAR=",NUMCAR,"  NL=",NL," MAXLONG=",MAXLONG; inkey(0)
               SW:=.T.
            end
            if NUMCAR>0
               if MAXLONG>0 .and. NL>0
                  cBUFF:=FREADSTR(FP,NUMCAR)
                  if SW
                     cBUFF:=strtran(cBUFF,chr(13),chr(10))
                     cMessage := hb_utf8tostr("Este archivo tiene caracteres truculentos."+_CR+;
                            "Sin embargo, creo que puedo editarlo."+_CR+;
                            "Si la edición tiene problemas, identifique el o los caracteres"+_CR+;
                            "problemáticos, e intente una edición hexadecimal"+_CR+;
                            "cargando el archivo con opción '-bin' desde la consola")
                     aOptions := { "Okay" }
                     nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
                  end
                  NUMCAR:=LEN(cBUFF)
                  STRING:=GETLINEAS(cBUFF,NL,NUMCAR,MAXLONG)
               else 

                  cMessage := hb_utf8tostr("Este archivo tiene un formato no reconocido"+_CR+"Se cargará como BINARIO")
                  aOptions := { "Okay" }
                  nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )

                  EXT:="binary"
                  STRING:=LEEBINARIO(FP)
                  NL:=LEN(STRING)
               end
            else
                NL:=1
                AADD(STRING,"")
            end
         else
            STRING:=LEEBINARIO(FP)
            NL:=LEN(STRING)
         end
         FCLOSE(FP)
         

         TEXTOTIPO:=UPPER(EXT)
         LENTEXTOTIPO:=LEN(TEXTOTIPO)
      /*   IF NUMCAR!=LEN(cBUFF)
            FP:=FOPEN(AX,0)
            cBUFF:=FREADSTR(FP,NUMCAR)
            FCLOSE(FP)
            IF NUMCAR!=LEN(cBUFF)
               cMessage := hb_utf8tostr("No puedo leer este archivo"+_CR+" Me la ganó...")
               aOptions := { hb_utf8tostr("Será...") }
               nChoice := Alert( cMessage, aOptions )
               SIZE:=1
               AADD(STRING,"8=D")
               RETURN STRING
            ELSE
               cMessage := hb_utf8tostr("Archivo no puede ser maquillado"+_CR+;
                                        "Será editado tal como se levantó"+_CR+"(Me la ganó...)")
               aOptions := { hb_utf8tostr("Será...") }
               nChoice := Alert( cMessage, aOptions )
            END
         END */

//         NUMCAR:=LEN(cBUFF)
//         STRING:=GETLINEAS(cBUFF,NL,NUMCAR,MAXLONG)
      /*   STRING:=ARRAY(NL)
         for i:=1 to NL
            STRING[i]:=rtrim(memoline(cBUFF,1200,i))
           // LINEA:=substr(LINEA,1,at(chr(13),LINEA)-2)
           // LINEA:=strtran(LINEA,chr(10),"")
           // LINEA:=strtran(LINEA,chr(13),"")
           // LINEA:=strtran( rtrim(memoline(cBUFF,1200,i)), chr(10),"") // quito los NL de otros sistemas ASCII
           // LINEA:=strtran( rtrim(memoline(cBUFF,1200,i)), chr(13),"")
           // AADD(STRING, LINEA )
         end*/
/*      else
         FCLOSE(FP)
         NL:=1
         AADD(STRING,"")
      end*/
   ELSE
      cMessage := hb_utf8tostr("El archivo está corrupto:"+_CR+AX+_CR+"Revísalo con un editor de verdad")
      aOptions := { hb_utf8tostr("Será...") }
      nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
      while inkey(,159)!=0 ; end
      MRESTSTATE(MOUSE)
      NL:=1
      AADD(STRING,"")
   END
   SIZE:=NL
   
   RELEASE cBUFF,FP,NL,NUMCAR,LINEA
 ///  hb_gcAll()
 ///  inkey(0.2)
RETURN STRING

FUNCTION MemoUDF( nMode, nLine, nCol )
LOCAL nKey := LASTKEY(),i,j,c
LOCAL nRetVal := ME_DEFAULT // Default return action

if nKey == 16   // CTRL-P pega el buffer
    for i:=1 to len(BUFFER)
       for j:=1 to len(BUFFER[i])
          c:=asc(substr(BUFFER[i],j,1))
          if c!=3 .and. c!=127   
             hb_keyPut(c)
          end
       end
       if c==3 .or. c!=127
          hb_keyPut(13)
       end
    end
    nRetVal := ME_IDLE
elseif nKey == 3   // CTRL-C  copia al BUFFER
    hb_keyPut(23)
    hb_keyPut(3)
    nRetVal := ME_IDLE
elseif nKey == 12   // CTRL-L load file
    hb_keyPut(23)
    hb_keyPut(12)
    nRetVal := ME_IDLE
elseif nKey == 11   // CTRL-K load file
    hb_keyPut(23)
    hb_keyPut(11)
    nRetVal := ME_IDLE
end

/*
DO CASE
//CASE nMode == ME_IDLE
//  @ 20, 5 SAY "MemoMode is ME_IDLE "
CASE nMode == ME_UNKEY
//  @ 20, 5 SAY "MemoMode is ME_UNKEY "
  DO CASE
  CASE nKey == K_F2
    nRetVal := ME_WORDRIGHT
  CASE nKey == K_F3
    nRetVal := ME_BOTTOMRIGHT
///    nRetVal := ME_DEFAULT
  ENDCASE

CASE nMode == ME_UNKEYX
  DO CASE
  CASE nKey == 21   // CTRL-U pega el buffer
    for i:=1 to len(BUFFER)
       for j:=1 to len(BUFFER[i])
          c:=asc(substr(BUFFER[i],j,1))
          if c==3 .or. c!=127
             hb_keyPut(13)
          else   
             hb_keyPut(asc(c))
          end
       end
    end
    nMode:=ME_DATA
  ENDCASE
//  @ 20, 5 SAY "MemoMode is ME_UNKEYX"
//OTHERWISE
 // @ 20, 5 SAY "MemoMode is ME_INIT "
ENDCASE
*/
RETURN nRetVal 

  FUNCTION RESCATOPARAM(PARAMETROS)
  LOCAL RETPAR:={},ML:=0,I, STRENV:="",STRPAR:=""
  PARAMETROS:=ALLTRIM(PARAMETROS)
  ML:=GETLINEAS(PARAMETROS,STRCUENTALINEAS(PARAMETROS),LEN(PARAMETROS),1024)
  
  FOR I:=1 TO LEN(ML)
     IF LEN(ALLTRIM(ML[I]))>0
        IF "=" $ ML[I]
           STRENV+="export "+ML[I]+_CR
        ELSE
           STRPAR+=ALLTRIM(ML[I])+" "
        END
     END
  END
  RETPAR:={STRPAR,STRENV}
  return RETPAR

  PROCEDURE FUNEXEXU(AX,TX,ENVVARS)
  local DX,RX,BX,EX,LINEA
    EX:=hb_ntos(int(hb_random(1000000000)))
    // prepara respuesta
    BX:=PATH_LOG+_fileSeparator+"XU_"+EX+".sh"
    DX:=FCREATE (BX)
    FWRITE (DX,"#!/bin/bash"+_CR)
    FWRITE (DX,ENVVARS+_CR)
    FWRITE (DX,AX+_CR)
    FWRITE (DX,"if [ -a "+PATH_TEMP+"/err_xu_compi.tmp ]; then"+_CR)
    FWRITE (DX,"rm "+PATH_TEMP+"/err_xu_compi.tmp"+_CR)
    FWRITE (DX,'echo "Press any key to continue..."'+_CR)
    FWRITE (DX,"read -rsp $'Press any key to continue...\n' -n 1 key"+_CR)
    
    FWRITE (DX,"else"+_CR)
    if TX!="<none>"
       FWRITE (DX,"clear"+_CR)
       FWRITE (DX,TX+_CR)
    end    
    FWRITE (DX,"read -rsp $'Press any key to continue...\n' -n 1 key"+_CR)

    FWRITE (DX,"fi"+_CR)
 //   FWRITE (DX,"rm "+BX+_CR)
    FCLOSE (DX)
    RX:=CMDSYSTEM("chmod 755 "+BX,0)
//
    if SWGRMODE
       LINEA:='gnome-terminal -- bash -c "'+BX+'"'
    else
       LINEA:=BX
    end
    // Ejecuta el Batch
    RX:=CMDSYSTEM(LINEA,0)
    HB_IDLESLEEP( 1 )
    if SW_CLEAR_LOG
       FERASE (BX)
    end
  RETURN

  PROCEDURE FUNEXEOTHERS(AX,TX,ENVVARS)
  local DX,RX,BX,EX,LINEA
    EX:=hb_ntos(int(hb_random(1000000000)))
    // prepara respuesta
    BX:=PATH_LOG+_fileSeparator+"XU_"+EX+".sh"
    DX:=FCREATE (BX)
    FWRITE (DX,"#!/bin/bash"+_CR)
    FWRITE (DX,ENVVARS+_CR)
    FWRITE (DX,AX+_CR)
    FWRITE (DX,'if [ "$?" != "0" ]; then'+_CR)
    FWRITE (DX,'echo "Press any key to continue..."'+_CR)
    FWRITE (DX,"read -rsp $'Press any key to continue...\n' -n 1 key"+_CR)
    FWRITE (DX,"else"+_CR)
    if TX!="<none>"
       
       FWRITE (DX,"clear"+_CR)
       FWRITE (DX,TX+_CR)
    end
    FWRITE (DX,"read -rsp $'Press any key to continue...\n' -n 1 key"+_CR)
    FWRITE (DX,"fi"+_CR)
 //   FWRITE (DX,"rm "+BX+_CR)
    FCLOSE (DX)
    RX:=CMDSYSTEM("chmod 755 "+BX,0)
//
    if SWGRMODE
       LINEA:='gnome-terminal -- bash -c "'+BX+'"'
    else
       LINEA:=BX
    end
    // Ejecuta el Batch
    RX:=CMDSYSTEM(LINEA,0)
    HB_IDLESLEEP( 1 )
    if SW_CLEAR_LOG
       FERASE (BX)
    end
  RETURN



  FUNCTION FUNFSHELL(AX,TIPO)    // 148 X<-FCMD
  LOCAL EAX,BX,DX,EX,RX,CX,TX
 
    EX:=hb_ntos(int(hb_random(1000000000)))
    // prepara respuesta
    BX:=PATH_LOG+_fileSeparator+"XU_"+EX 
    // amra el .BAT
    
    AX:=AX+" > "+BX+".tmp"
    DX:=FCREATE (BX+".sh")
     FWRITE (DX,"#!/bin/bash"+_CR)
     FWRITE (DX,AX+_CR)

     FWRITE (DX,"echo $? > "+PATH_LOG+_fileSeparator+"XUANS_"+EX+".log"+_CR)
    FCLOSE (DX)
    RX:=CMDSYSTEM("chmod 755 "+BX+".sh",0)
//
    // Ejecuta el Batch
    RX:=CMDSYSTEM(BX+".sh",0) // </dev/null >/dev/null 2>&1 &")
  
    TX:=SECONDS()
    while !file(BX+".tmp")
       if SECONDS()-TX >= 4
          cMessage := hb_utf8tostr("Imposible obtener un resultado."+_CR+"Si escribiste un grupo de líneas bash, asegúrate de"+;
                               _CR+"poner ';' al final de cada instrucción, porque elimino los new-line"+_CR+;
                                   "antes de proceder.")
          aOptions := { hb_utf8tostr("Será...") }
          nChoice := Alert( cMessage, aOptions, N2COLOR(cMENU) )
          while inkey(,159)!=0 ; end
          MRESTSTATE(MOUSE)
          RX:="<error>"
          RELEASE EAX,BX,DX,EX,CX
          RETURN RX
       end
    end
    CX:=hb_utf8tostr(MEMOREAD(BX+".tmp"))
    DX:=MEMOREAD(PATH_LOG+_fileSeparator+"XUANS_"+EX+".log")
    if TIPO==2
       RX:=iif(DX!="0",.F.,.T.)
    elseif TIPO==3 .or. TIPO==4
       if DX!="0"
          RX:="<error>"
       else
          RX:=CX   // guardo salida
       end
    end

   /* if SW_CLEAR_LOG
       FERASE (BX+".sh")
       FERASE (BX+".tmp")
       if TIPO!=1
          FERASE (PATH_LOG+_fileSeparator+"XUANS_"+EX+".log")
       end
    end */
    
    RELEASE EAX,BX,DX,EX,CX
  RETURN RX

/*PROCEDURE MILLISEC( nDelay )
   HB_IDLESLEEP( nDelay / 1000 )
   RETURN
  */ 
procedure CARGACOLORESTEXTO(PATH_XU,_fileSeparator,LANGUAJE)
local _w,_p,_e,_linea,_nl,_v,nt,_d,_c,swDefColor:=.F.,i,j,_i

for i:=1 to LEN(lDEFINE)
  for j:=1 to len(lDEFINE[i])
     RELEASE lDEFINE[i][j]
  end
  RELEASE lDEFINE[i]
end

for i:=1 to LEN(lSECCION)
  for j:=1 to len(lSECCION[i])
     RELEASE lSECCION[i][j]
  end
  RELEASE lSECCION[i]
end

for i:=1 to LEN(lKEYWORD)
  for j:=1 to len(lKEYWORD[i])
     RELEASE lKEYWORD[i][j]
  end
  RELEASE lKEYWORD[i]
end

lDEFINE:={}; lSECCION:={}; lKEYWORD:={}

if !FILE(PATH_XU+_fileSeparator+"laica.compiler")
   DEFINEKEYWORDS(LANGUAJE)
else
   _v:=Memoread(PATH_XU+_fileSeparator+"laica.compiler")
   _nl:= MlCount(_v)

   for _i:=1 to _nl
      _linea:=alltrim(hb_utf8tostr(Memoline(_v,1600,_i)))
      if substr(_linea,1,1)!=";"
         if !empty(_linea)
            _w:=lower(alltrim(substr(_linea,1,at("=",_linea)-1)))  // extension
            _p:=alltrim(substr(_linea,at("=",_linea)+1,len(_linea))) // linea
            do case
               case _w=="colours"
                  swDefColor:=.F.
                  //nTok:=AT(LANGUAJE,_p)
                  nTok:=numtoken(_p,",")
                  if nTok>0
                     for j:=1 to nTok
                        if token(_p,",",j)==LANGUAJE
                           swDefColor:=.T.
                           exit
                        end
                     end
                  end
               case _w=="preprocs" .and. swDefColor
                  nTok:=numtoken(_p,",")
                  for j:=1 to nTok
                     AADD(lDEFINE,token(_p,",",j))
                  end
               case _w=="sections" .and. swDefColor
                  nTok:=numtoken(_p,",")
                  for j:=1 to nTok
                     AADD(lSECCION,token(_p,",",j))
                  end
               case _w=="keywords" .and. swDefColor
                  if _p=="\"
                     exit
                  end
                  nTok:=numtoken(_p,",")
                  for j:=1 to nTok
                     AADD(lKEYWORD,token(_p,",",j))
                  end
            end
         end
      end
   next
   if !swDefColor
      DEFINEKEYWORDS(LANGUAJE)
   end
end
RELEASE _w,_p,_e,_linea,_nl,_v,nt,_d,_c,swDefColor:=.F.,i

RETURN

procedure CARGA_COMPILADORES(PATH_XU,_fileSeparator)
local _w,_p,_e,_linea,_nl,_v,nt,_d,_c,i,_m

public cEDITOR
public cTEXTO
public cBARRA
public cTITULO
public cMENU
public cSELECT
public cTABULA
public cDESPLAZAMIENTO
public cPAGINA

if len(LISTACOMPILA)>0
   FOR i:=1 to len(LISTACOMPILA)
      RELEASE LISTACOMPILA[i]
   END
   LISTACOMPILA:={}
end
if len(cCOLORES)>0
   FOR i:=1 to len(cCOLORES)
      RELEASE cCOLORES[i]
   END
   cCOLORES:={}
end

if !FILE(PATH_XU+_fileSeparator+"laica.compiler")
   outstd(_CR,hb_UTF8tostr("Atención: no encuentro el archivo LAICA.COMPILER"),_CR)
   AADD(LISTACOMPILA,{"xu","xuc %name%.xu -x -m -v -sys","xu %name%","XU - Ejecutable","//","e"})
   AADD(LISTACOMPILA,{"xu","xuc %name%.xu -l -sys","",hb_utf8tostr("XU - Librería (.lib)"),"//","e"})
   AADD(LISTACOMPILA,{"xu","xuc %name%.xu -m -v -sys","",hb_utf8tostr("XU - Información de debugueo"),"//","e"})
   AADD(LISTACOMPILA,{"c","gcc %name%.c -o %name%","%name%","GCC - Ejecutable","//","e"})
   
else
   _v:=Memoread(PATH_XU+_fileSeparator+"laica.compiler")
   _nl:= MlCount(_v)
   for _i:=1 to _nl
      _linea:=alltrim(hb_utf8tostr(Memoline(_v,1600,_i)))
      if substr(_linea,1,1)!=";"
         if !empty(_linea)
            _w:=lower(alltrim(substr(_linea,1,at("=",_linea)-1)))  // extension
            _p:=alltrim(substr(_linea,at("=",_linea)+1,len(_linea)))  // linea
            do case
               case _w=="tab"
                  cTABULA:=val(_p)
               case _w=="pag"
                  cPAGINA:=val(_p)
               case _w=="ctrl_lz"
                  cDESPLAZAMIENTO:=val(_p)
               
               case _w=="map"
                  nt:=numtoken(_p,",")
                  cMAPACOLORES:=alltrim(token(_p,",",1))
                  cLENMAPACOLORES:=LEN(cMAPACOLORES)
                  cHELP:=val(alltrim(token(_p,",",2)))
                  cTEXT:=val(alltrim(token(_p,",",3)))
                  cEDITOR:=cTEXT
                  cCADENA:=val(alltrim(token(_p,",",4)))
                  cMENU:=val(alltrim(token(_p,",",5)))
                  cBARRA:=cMENU
                  cCURSORMOD:=val(alltrim(token(_p,",",6)))
                  cSECCION:=val(alltrim(token(_p,",",7)))
                  cKEYWORD:=val(alltrim(token(_p,",",8)))
                  cEDITDEF:=val(alltrim(token(_p,",",9)))
                  cEDITCOM:=val(alltrim(token(_p,",",10)))
                  cDESTACADO:=val(alltrim(token(_p,",",11)))
                  cSELECT:=val(alltrim(token(_p,",",12)))
                  aadd(cCOLORES,{cMAPACOLORES,cHELP,cTEXT,cEDITOR,cCADENA,cMENU,cBARRA,;
                                 cCURSORMOD,cSECCION,cKEYWORD,cEDITDEF,cEDITCOM,cDESTACADO,cSELECT}) 

              /* case _w=="help"
                  cHELP:=val(_p)
               case _w=="text"
                  cTEXTO:=val(_p)
                  cEDITOR:=cTEXTO
               case _w=="menu"
                  cMENU:=val(_p)
                  cBARRA:=cMENU
               case _w=="section"
                  cSECCION:=val(_p)
               case _w=="remarks"
                  cEDITCOM:=val(_p)
               case _w=="preproc"
                  cEDITDEF:=val(_p)
               case _w=="keyword"
                  cKEYWORD:=val(_p)
               case _w=="string"
                  cCADENA:=val(_p)
               case _w=="cursor_mod"
                  cCURSORMOD:=val(_p) */
                  
               case _w=="end_compiler_definition"
                  exit
               otherwise
                  // obtengo compilacion
                  nt:=numtoken(_p,",")
                  _m:=alltrim(token(_p,",",1))
                  _c:=alltrim(token(_p,",",2))
                  _e:=alltrim(token(_p,",",3))
                  _d:=alltrim(token(_p,",",4))
                  _f:=alltrim(token(_p,",",5))
                  AADD(LISTACOMPILA,{_w,_c,_e,_d,_f,_m})
            end
         end
      end
   next
end

RETURN

procedure _Carga_Configuracion()
local _f,_v,_w,_nl,_i,_linea,_p
local PATH_XU,OSHost

public PATH_BINARY
public PATH_SOURCE
public PATH_INCLUDE
public PATH_LOG
public PATH_DEBUG
public PATH_HELP
public PATH_TEMP  // para archivos temporales

public SW_CLEAR_LOG:=.T.
public _fileSeparator

PATH_XU:=CURDIR()
OSHost:=OS()
OSHost:=upper(alltrim(substr(OSHost,1,at(" ",OSHost))))
if OSHost=="LINUX" .or. OSHost=="DARWIN"
  _fileSeparator:="/"
  PATH_XU:="/"+PATH_XU
elseif OSHost=="WINDOWS"
  _fileSeparator:="\"
end
OPERATING_SYSTEM:=OSHost

if !file(PATH_XU+_fileSeparator+"xu")
   PATH_XU:=GETENV("PATH_XU")
   if alltrim(PATH_XU)==""
      outstd(_CR,hb_UTF8tostr("Atención: debe declarar la variable de entorno PATH_XU"))
      outstd(_CR,hb_UTF8tostr("          si quiere ejecutar desde cualquier parte del"))
      outstd(_CR,hb_UTF8tostr("          sistema."))
      outstd(_CR,hb_UTF8tostr("          Si está en Linux u OSX, hágalo así:"),_CR)
      outstd(_CR,hb_UTF8tostr("                export PATH_XU=ruta-de-XU"),_CR)
      outstd(_CR,hb_UTF8tostr("          Si está en Win8=Dows, hágalo así:"),_CR)
      outstd(_CR,hb_UTF8tostr("                set PATH_XU=ruta-de-XU"),_CR)
      outstd(_CR,hb_UTF8tostr("     donde:"),_CR)
      outstd(_CR,hb_UTF8tostr("        ruta-de-XU = la ruta donde está guardada XU."),_CR)
      release all
      quit
   end
end

if !FILE(PATH_XU+_fileSeparator+"xu.config")
   outstd(_CR,hb_UTF8tostr("Atención: no encuentro el archivo XU.CONFIG."),_CR)
   release all
   quit
else
   _v:=Memoread(PATH_XU+_fileSeparator+"xu.config")
   _nl:= MlCount(_v)
   for _i:=1 to _nl
      _linea:=alltrim(Memoline(_v,1600,_i))
      if substr(_linea,1,1)!=";"
         if !empty(_linea)
            _w:=upper(alltrim(substr(_linea,1,at("=",_linea)-1)))
            _p:=alltrim(substr(_linea,at("=",_linea)+1,len(_linea)))

            do case
               case _w=="BINARY"
                  PATH_BINARY:=PATH_XU+_fileSeparator+_p
               case _w=="SOURCE"
                  PATH_SOURCE:=PATH_XU+_fileSeparator+_p
               case _w=="LOG"
                  PATH_LOG:=PATH_XU+_fileSeparator+_p
               case _w=="TEMP"
                  PATH_TEMP:=PATH_XU+_fileSeparator+_p
               case _w=="INCLUDE"
                  PATH_INCLUDE:=PATH_XU+_fileSeparator+_p
               case _w=="DEBUG"
                  PATH_DEBUG:=PATH_XU+_fileSeparator+_p
               case _w=="HELP"
                  PATH_HELP:=PATH_XU+_fileSeparator+_p
               case _w=="CLEAR_LOG"
                  if upper(_p)="YES"
                     SW_CLEAR_LOG:=.T.
                  end
            end
         end
      end
   next
end

return PATH_XU

FUNCTION CARACTESPE(cBUFF)
LOCAL tBUFF,ascVAL,CX,ttBUFF,tttBUFF
tBUFF:=" "
ascVAL:=cBUFF
if ascVAL==194 .or.ascVAL==195.or.ascVAL==207.or.ascVAL==198.or.ascVAL==197;
   .or. ascVAL==234 .or. ascVAL==180
   tBUFF:=chr(inkey())
   CX:=hb_UTF8tostr(chr(cBUFF)+tBUFF)
   CX:=ASC(CX)
elseif ascVAL==226 .or. ascVAL==239
   ttBUFF:=" "
   tBUFF:=chr(inkey())
   ttBUFF:=chr(inkey())
   CX:=hb_UTF8tostr(chr(cBUFF)+tBUFF+ttBUFF)
   CX:=ASC(CX)
elseif ascVAL==206
   ttBUFF:=" "
   tttBUFF:=" "
   tBUFF:=chr(inkey())
   ttBUFF:=chr(inkey())
   tttBUFF:=chr(inkey())
   CX:=hb_UTF8tostr(chr(cBUFF)+tBUFF+ttBUFF+tttBUFF)
   CX:=ASC(CX)
else
   CX:=cBUFF
end
RELEASE tBUFF,ascVAL,ttBUFF,tttBUFF
RETURN CX


FUNCTION INPUTLINE(ENTRADA,TOPE,ROW,COL,TIPO)
LOCAL INICIO,s,p,pt,px,xlen,m,c,i,CX,SW,swPto,nLEN
  
  /* flush */
  
 /* while inkey()!=0
     ;
  end */
  /**/
  
  INICIO:=ROW
  
  s:=array(TOPE)

  c:=0
  p:=1
  pt:=COL
  px:=COL
  xlen:=pt+1
  swPto:=.F.

  setpos(INICIO,pt)
  nLEN:=LEN(ENTRADA)
  if nLEN>0
     for i:=1 to nLEN
        hb_keyPut(asc(substr(ENTRADA,i,1)))
     end
     pushkey(19,nLEN)
  end
  //hb_gcAll()  // aprovecha el inkey para GC
  while .T.
     c=inkey(0)
     if c==13
       exit
     elseif c==3   // CTRL-C chao!
       for i:=1 to TOPE
         s[i]:=""
       end
       exit
     elseif c==27
         for i:=1 to TOPE
           s[i]:=""
         end
       
         setpos(INICIO,pt)
         setcursor(0)
         for i:=1 to xlen-pt-1
           outstd(" ")
         end
         setcursor(1)
         c:=" "
         p:=1
         pt:=COL
         px:=COL
         xlen:=pt+1
         swPto:=.F.
         setpos(INICIO,px)

     elseif c==9  // CTRL-I  inserta algo
       c:=inkey(0)
       c:=asc(upper(chr(c)))
       if c==8 .or. c==72    // CTRL-IH inserta home
          for i:=1 to len(HOME)
             hb_keyPut(asc(substr(HOME,i,1)))
          end
       elseif c==16 .or. c==80  // CTRL-IP  inserta PWD
          for i:=1 to len(ACTUALDIR)
             hb_keyPut(asc(substr(ACTUALDIR,i,1)))
          end
       elseif c==18 .or. c==82  // CTRL-IR relative curr path (donde stá el fichero en edición)
          for i:=1 to len(INPUTFILE)
             hb_keyPut(asc(substr(INPUTFILE,i,1)))
          end
       elseif c==19 .or. c==83  // CTRL-IS añade ruta a directorio SOURCE de XU
          for i:=1 to len(PATH_SOURCE)
             hb_keyPut(asc(substr(PATH_SOURCE,i,1)))
          end
          hb_keyPut(asc(_fileSeparator))
       elseif c==9 .or. c==73  // CTRL-II añade ruta a directorio Include de XU
          for i:=1 to len(PATH_INCLUDE)
             hb_keyPut(asc(substr(PATH_INCLUDE,i,1)))
          end
          hb_keyPut(asc(_fileSeparator))
       elseif c==65    // CTRL-IA   autocompleta path actual
          
       end

     elseif c==-3   // F4   comando ^KU
       hb_keyPut(11)
       hb_keyPut(85)
       
     elseif c==11   // CTRL-KU
       c:=inkey(0)
       c:=asc(upper(chr(c))) 
       if c==85 .or. c==21
          if SW_HAYBUFFER
             SW_COMPILE:=.F.
             SW_MODIFICADO:=.T.
            /// SW_PASTE:=.T.    // ya lo usé. queda disponible
             cLen:=len(BUFFER)
            /* nLen:=cLen
             for i:=1 to cLen
                nLen += len(BUFFER[i])
             end*/
             //hb_keyPut(127)  // levanta bandera de codigo especial
             cT:=0
             for i:=1 to cLen
                STRING:=BUFFER[i]
                for j:=1 to len(STRING)
                   cT:=asc(substr(STRING,j,1))
                   if cT!=127
                      hb_keyPut(cT)
                   end
                end
                if cT!=127
                   hb_keyPut( 13 )
                end
             end
             if cT!=127
                hb_keyPut( 1 )
             end
             //hb_keyPut(127)  // la baja.
          end
       end

     elseif c==1   // CTRL-A  BOL
       if p>1
          setcursor(0)
          pushkey(19,p-1)
          setcursor(1)
       end
           
     elseif c==6   //  CTRL-F EOL
        if p<len(s)
          setcursor(0)
          //if TIPOTEXTO!="BINARY"
             pushkey(4,len(s)-p+1)
          //else
          //   pushkey(4,len(s)-(p+1))
          //end
          setcursor(1)
        end
        
     elseif c==19
       if p>1
          --p; --px
       end
       setpos(INICIO,px)
     elseif c==4
       if px<xlen-1
         ++px; ++p
       end
       setpos(INICIO,px)

     elseif c==7
       if xlen-pt>p
         --xlen
         if s[p]=="."
            swPto:=.F.
         end
         adel(s,p)
         setpos(INICIO,pt)
         for i:=1 to xlen-pt-1
           outstd(s[i])
         end   
         setpos(INICIO,xlen-1);outstd(" ")
         setpos(INICIO,px)
       end
     elseif c==8
       if px>pt
         --p
         if s[p]=="."
            swPto:=.F.
         end
         s[p]:="" 
         --xlen
         adel(s,p)
         //asize(s,len(s)-1)
         setpos(INICIO,pt)
         for i:=1 to xlen-pt-1
           outstd(s[i])
         end   
         setpos(INICIO,xlen-1);outstd(" ")
         setpos(INICIO,--px)
       end

     else
       if xlen<=TOPE+pt
          c:=CARACTESPE(c)
          if c!=0
             SW:=.F.
             if TIPO=="N"
                if chr(c) $ "0123456789.-"
                   SW:=.T.
                end
             elseif TIPO=="s"
                SW:=.T.
             end
             if SW      
                if px<xlen
                  ains(s,p)
                  ++xlen; ++px
                  s[p]:=chr(c)
                  ++p
                else
                  s[p]:=chr(c) ; ++xlen; ++p; ++px
                end
                setpos(INICIO,pt)
                setcursor(0)
                for i:=1 to xlen-pt-1
                  outstd(s[i])
                end
                setcursor(1)
                setpos(INICIO,px)
             end
          end
       end
     end
  end
  m:=""
  if c!=3
     for i:=1 to xlen-pt-1
        m+=s[i]
     end
  end
  /* flush */
  
  while inkey()!=0
     ;
  end
  /**/
  ///? "["+m+"]"; inkey(0)
RELEASE INICIO,s,p,pt,px,xlen,c,i,CX,SW,swPto
RETURN m 

PROCEDURE DEFINEKEYWORDS(LANGUAJE)

IF LANGUAJE=="xu" .or. LANGUAJE=="def"
  lDEFINE:={"#include","#use","#import","#define"}
  lSECCION:={"vars:","functions:","algorithm:","stop"}
  lKEYWORD:={"for each","for","next","while","wend","begin:","endif","elseif",;
             "matrix","math","string","base","bit","date","trig","stack","set",;
             "else","cleartry","try","exception","tend","loop","lend","until","pause",;
             "goodbye","downto","step","inlist","and","or","xor","~","show",;
             "not","^number","number","^string","string","stack","^boolean","function","switch",;
             "boolean","(ref)","(*)","void","gosub","sub","back","room","rend","exitif",;
             "again","return","precision","cls","pause","flag","write","raise","true","false",;
             "break","continue","eval","case","otherwise","evend","end","if","to","in"}
ELSEIF LANGUAJE=="c" .or. LANGUAJE=="h"
  lDEFINE:={"#include","#define","#ifdef","#ifndef","#endif","#elif","#else","#if","#message","#undef"}
  lSECCION:={"main","return"}
  lKEYWORD:={"for","break","continue","while","else if","else","extern","default","case","register","class","new",;
             "char","float","long","double","short","sizeof","static","unsigned","const","signed","void","auto",;
             "volatile","typedef","struct","union","enum","goto","if","NULL",;
             "uint8_t","uint16_t","uint32_t","uint64_t","int"}
ELSEIF LANGUAJE=="prg" .or. LANGUAJE=="ch"
  lDEFINE:={"#define","#include","#ifdef","#ifndef","#undef","#error","#command","#xcommand","#stdout","#endif"}
  lSECCION:={"function","procedure","return"}
  lKEYWORD:={"for","while","case","exit","loop","local","memvar","public","set","@","clear","say","get","valid","read","prompt","box","menu"," to ","quit",;
             "elseif","else","end","if","static","nil",".T.",".F.",".and.",".or.","!"}

ELSEIF LANGUAJE=="py"
  lDEFINE:={"import","from"}
  lSECCION:={"def","lambda","class","return","global","new"}
  lKEYWORD:={"print","for","while","break","continue","yield","assert","except","try","finally","elif","else","raise",;
             "exec","not","and","or","is","if"}
ELSEIF LANGUAJE=="sh" .or. LANGUAJE=="ksh"
  lDEFINE:={"export","declare","typeset"}
  lSECCION:={"function","return","exit"}
  lKEYWORD:={"echo","for","while","select","until","done","elif","else","case","esac","continue","let","local","set","shift","then","fi","do","in","if",;
             "sudo","mkdir","cd","alias","rmdir","rm","unalias","getopts","kill","unset","printf","awk","true","false","bg","fg","umask","cp","cat","grep",;
             "tail","head"}
ELSE
  lDEFINE:={"<none>"}
  lSECCION:={"<none>"}
  lKEYWORD:={"<none>"}
END
RELEASE i
RETURN

/** codigo C **/
#pragma BEGINDUMP
#include "hbapi.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapierr.h"
#include "hbapigt.h"
#include "hbset.h"
#include "hbdate.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <math.h>
#include <inttypes.h>

HB_FUNC( FT_IDLE )
{
   hb_idleState();
}

HB_FUNC( POSCARACTER )
{
   PHB_ITEM pTEXTO = hb_param(1, HB_IT_STRING );
   HB_SIZE nPos = hb_parni ( 2 );
   char * cRet = (char *)calloc(2,1);
   const char * szText = hb_itemGetCPtr( pTEXTO );
   cRet[0] = szText[nPos-1];
   cRet[1] = '\0';
   hb_retc( cRet );
   free(cRet);
}

void do_fun_xgetbit(){
   unsigned x = hb_parni(1);
   int p = hb_parni(2);
   int n = hb_parni(3);
   hb_retni( (x>> (p+1-n)) & ~(~0 << n) );
}
HB_FUNC ( XGETBIT )
{
   do_fun_xgetbit();
}

//isany(vtip,"NN","CC")
HB_FUNC( ISANY )
{
   int iPCount = hb_pcount();

   HB_BOOL bGood = HB_FALSE;
   if( iPCount > 0 )
   {
      PHB_ITEM pVAR = hb_param( 1, HB_IT_STRING );
      const char * cVAR = hb_itemGetCPtr( pVAR );
      int iParam;
      for( iParam = 2; iParam <= iPCount; iParam++ )
      {
         PHB_ITEM pCom = hb_param( iParam, HB_IT_STRING );
         const char * cCom = hb_itemGetCPtr( pCom );
         if( strcmp( cVAR, cCom ) == 0 )
         {
            bGood = HB_TRUE;
            break;
         }
         hb_itemClear( pCom );
      }
      hb_itemClear( pVAR );
   }
   hb_retl( bGood );
}

HB_FUNC( ESNULO )
{
   int iPCount = hb_pcount();

   HB_BOOL bError = HB_FALSE;
   if( iPCount > 0 )
   {
      
      int iParam;
      for( iParam = 1; iParam <= iPCount; iParam++ )
      {
         if( HB_ISNIL( iParam ) )
         {
            bError = HB_TRUE;
            break;
         }
      }
   }
   hb_retl( bError );
}

/* StackPop( <aStack> ) --> <xValue>
   Returns NIL if the stack is empty
 *
 * renamed: SDP
 * Harbour Project source code:
 * Stack structure
 *
 * Copyright 2000 Jose Lalin <dezac@corevia.com>
 * www - http://harbour-project.org
*/
HB_FUNC( SDP )
{
   PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
   HB_ISIZ ulLen = hb_arrayLen( pArray );
   PHB_ITEM pLast = hb_itemNew( NULL );

   if( ulLen )
   {
      hb_arrayLast( pArray, pLast );
      hb_arrayDel( pArray, ulLen );
      --ulLen;
      hb_arraySize( pArray, HB_MAX( ulLen, 0 ) );
   }

   hb_itemReturnRelease( pLast );
}

/**************************************************************************************/ 
/*
 * CT3 Number and bit manipulation functions:
 *       NumAnd(), NumOr(), NumXor(), NUMNOT()
 *       ClearBit(), SetBit()
 *
 * Copyright 2007 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 */

HB_BOOL ct_numParam( int iParam, HB_MAXINT * plNum )
{
   const char * szHex = hb_parc( iParam );

   if( szHex )
   {
      *plNum = 0;
      while( *szHex == ' ' )
         szHex++;
      while( *szHex )
      {
         char c = *szHex++;

         if( c >= '0' && c <= '9' )
            c -= '0';
         else if( c >= 'A' && c <= 'F' )
            c -= 'A' - 10;
         else if( c >= 'a' && c <= 'f' )
            c -= 'a' - 10;
         else
            break;
         *plNum = ( *plNum << 4 ) | c;
         iParam = 0;
      }
      if( ! iParam )
         return HB_TRUE;
   }
   else if( HB_ISNUM( iParam ) )
   {
      *plNum = hb_parnint( iParam );
      return HB_TRUE;
   }

   *plNum = -1;
   return HB_FALSE;
}

HB_FUNC( XNUMAND )
{
   int iPCount = hb_pcount(), i = 1;
   HB_MAXINT lValue = -1, lNext = 0;

   if( iPCount && ct_numParam( 1, &lValue ) )
   {
      while( --iPCount && ct_numParam( ++i, &lNext ) )
         lValue &= lNext;

      if( iPCount )
         lValue = -1;
   }
   hb_retnint( lValue );
}

HB_FUNC( XNUMOR )
{
   int iPCount = hb_pcount(), i = 1;
   HB_MAXINT lValue = -1, lNext = 0;

   if( iPCount && ct_numParam( 1, &lValue ) )
   {
      while( --iPCount && ct_numParam( ++i, &lNext ) )
         lValue |= lNext;

      if( iPCount )
         lValue = -1;
   }
   hb_retnint( lValue );
}

HB_FUNC( XNUMXOR )
{
   int iPCount = hb_pcount(), i = 1;
   HB_MAXINT lValue = -1, lNext = 0;

   if( iPCount && ct_numParam( 1, &lValue ) )
   {
      while( --iPCount && ct_numParam( ++i, &lNext ) )
         lValue ^= lNext;

      if( iPCount )
         lValue = -1;
   }
   hb_retnint( lValue );
}

HB_FUNC( XNUMNOT )
{
   HB_MAXINT lValue;

   if( ct_numParam( 1, &lValue ) )
      lValue = ( ~lValue ) & 0xffffffff;
      //lValue = ( ~lValue ) & 0xffffffff;

   hb_retnint( lValue );
}

HB_FUNC( XCLEARBIT )
{
   int iPCount = hb_pcount(), iBit, i = 1;
   HB_MAXINT lValue;

   if( ct_numParam( 1, &lValue ) )
   {
      while( --iPCount )
      {
         iBit = hb_parni( ++i );
         if( iBit < 1 || iBit > 64 )
            break;
         lValue &= ~( ( ( HB_MAXINT ) 1 ) << ( iBit - 1 ) );
      }

      if( iPCount )
         lValue = -1;
   }

   hb_retnint( lValue );
}
HB_FUNC( XSETBIT )
{
   int iPCount = hb_pcount(), iBit, i = 1;
   HB_MAXINT lValue;

   if( ct_numParam( 1, &lValue ) )
   {
      while( --iPCount )
      {
         iBit = hb_parni( ++i );
         if( iBit < 1 || iBit > 64 )
            break;
         lValue |= ( ( HB_MAXINT ) 1 ) << ( iBit - 1 );
      }

      if( iPCount )
         lValue = -1;
   }

   hb_retnint( lValue );
}


uint16_t ftokens(const char *linea, const char *buscar, uint16_t lb) {
   const char *t,*r; // son solo punteros apuntando a la cadena s.

   uint16_t n=0;

   r = linea;  // rescato primera posición
   t = strstr(r,buscar);
   while (t!=NULL) {
      r = t + lb;
      ++n;
      t = strstr(r,buscar);
   }

   return n;
}

char * fun_alltrim( const char *linea, HB_SIZE sizel) {
   const char *r,*s;
   char *t,*buffer;
   HB_SIZE tsize;

   r = linea;
   if ( *r=='\t' || *r=='\r' || *r=='\n' || *r==' ' ){
      while (( *r=='\t' || *r=='\r' || *r=='\n' || *r==' ') && *r) r++; 
      if (!*r) return NULL;  // no hay texto, solo puras weás! 
   }
   s = linea + (sizel-1);
   if (*s=='\t' || *s=='\r' || *s=='\n' || *s==' ') {
      while (( *s=='\t' || *s=='\r' || *s=='\n' || *s==' ') && s!=linea) s--;     
      if (s==linea) return NULL;  // no hay texto, sólo puras weás!
   }
   tsize = s - r + 1;  // longitud del texto.

   buffer = (char *) calloc((tsize+1),1);//sizeof(char *));
   if (buffer==NULL) return NULL;
   t = buffer;
   strncpy (t,r,tsize);
   t[tsize]='\0';

   return buffer;
}
char *strpad (const char *linea, uint16_t size, uint16_t sizel, uint16_t codeFun){
   char *t,*buffer;
   const char *s, *r;
   uint16_t tsize,l1,l2,ts, lsizel;
   int i,p,q;
   
  // acoto el string a padear, por ambos lados (evito llamar a TRIM).
 // printf("\nLinea  %s\n",linea);

 //   printf("ENTRA AQUI\n");
   r = linea;
   if (*r=='\t' || *r=='\r' || *r=='\n' || *r==' '){
      while ((*r=='\t' || *r=='\r' || *r=='\n' || *r==' ') && *r) r++; 
      if (!*r) return NULL;  // no hay texto, sólo puras weás! 
   }
   s = linea + (sizel-1);
   if (*s=='\t' || *s=='\r' || *s=='\n' || *s==' '){
      while ((*s=='\t' || *s=='\r' || *s=='\n' || *s==' ') && s!=linea) s--;     
      if (s==linea) return NULL;  // no hay texto, sólo puras weás!
   }
   tsize = s - r + 1;  // longitud del texto.
 //  printf("\nS= %s, R=%s, TSIZE=%d CPAD=%d SIZECAMPO=%d\n",s,r,tsize,size,sizel);
   if (tsize>sizel) return NULL;
 //  printf("\nPASO... con %s\n",linea);
   lsizel = sizel - strlen(linea);


   l1 = ( (size - tsize) + lsizel ) / 2;
   l2 = l1;

   if (l1+l2+tsize < size+lsizel) l2++;   // por si el pad es impar
   ts = l1+l2+tsize;
// asigno espacio (size) para nueva cadena:
   buffer = (char *) calloc(ts+1,1); //sizeof(char));
   t = buffer;
   if (t==NULL) return NULL;    // todo termina si no hay memoria.
   
   switch( codeFun ){
      case 0: { // centrado
      	p=0;
        while (l1--){
      	  //strcat(t," ");
      	  t[p++] = ' ';
        }
        //strncat(t,r,tsize);
        q=0;
        while (tsize--){
        	 t[p++] = r[q++];
        } 
        while (l2--){
      	 // strcat(t," ");
      	   t[p++] = ' ';
        }
        t[p] = '\0';
        break;
      }
      case 1: {  // Left
      	p=0;
        //strncat(t,r,tsize);
        q=0;
        while (tsize--){
        	 t[p++] = r[q++];
        }
        i = l1 + l2;
        while (i--){
      	  //strcat(t," ");
      	  t[p++] = ' ';
        }
        t[p] = '\0';
        break;
      }
      case 2: {    // Right
        i = l1 + l2;
        p = 0;
        while (i--){
      	  //strcat(t," ");
      	  t[p++] = ' ';
        }
        //strncat(t,r,tsize);
        q=0;
        while (tsize--){
        	 t[p++] = r[q++];
        }
        t[p] = '\0';
        break;
      }
   }
   char * Retorno = (char *)calloc(p+1,1);
   char * Ret = Retorno;
   strcpy(Ret,t);
   free(buffer);
   return Retorno;   
}

#define MAXBUFFER 4096

char *fsaturate( const char *tokens, const char *tok, const char *linea){
   char *buffer;
   const char *t, *s;
   char **ltoken;     // lista de tokens
   uint16_t lentok = strlen(tok);
   uint16_t i=0,l, sizei;

   if (lentok==0) return NULL;

   // cuántos tokens tengo?
   uint16_t ntok = ftokens(tokens,tok,lentok);
   if (ntok==0) return NULL;   // no hay tokens
   //ltoken = (char**)malloc( sizeof(char *)*(ntok+2) );
   ltoken = (char**)calloc( ntok+1, sizeof(char *) );
   // a ntok se suma 1, pues acá necesito los tokens, no los separadores, como en strtran. 

   if (ltoken==NULL) return NULL;   // no hay memoria

   // obtengo tokens y los guardo en un arreglo para reemplazar después.
   t = tokens;
   char *temp;
   while ((s = strstr(t,tok))!=NULL) {
       l = s - t;
       
       ltoken[i] = (char*)calloc( (l+1), 1);//sizeof(char *) );
       temp = ltoken[i];
       if (temp==NULL) {     // limpiar la memoria que ya fue asignada
           //free(ltoken);
           for (l=0;l<=i;++l) free(ltoken[l]);
           free(ltoken);
           return NULL;     // no hay memoria para el arreglo
       }
       //strncpy(ltoken[i], t, l);
       strncpy(temp, t, l);
       t = ++s;
    //   printf("\nTOken... %s\n",ltoken[i]);
       ++i;
   }

   if (t!=NULL) {           // queda un token más: lo capturo.
       ltoken[i] = (char*)calloc( (strlen(t)+1), 1);// sizeof(char *) );
       temp = ltoken[i];
       if (temp==NULL) {     // limpiar la memoria que ya fue asignada
           ///free(ltoken);
           for (l=0;l<=i;++l) free(ltoken[l]);
           free(ltoken);
           return NULL;     // no hay memoria para el arreglo
       }
       
       //strcpy(ltoken[i], t);
       strcpy(temp, t);
       sizei = i;
   } else sizei = i-1;

   // asigno espacio a la línea objetiva
   ///buf = (char *) malloc (sizeof(char *)*MAXBUFFER); // MAXBUFFER lo asgno por flag "512"
   buffer = (char *) calloc (MAXBUFFER,1);//sizeof(char *));
   char *buf = buffer;
   if (buf==NULL) {         // limpiar la memoria que ya fue asignada
       //free(ltoken);
       for (l=0;l<=i;++l) free(ltoken[l]);
       free(ltoken);
       free(buffer);
       return NULL;         // no hay memoria para el arreglo
   }
   // Reemplazo los tokens en la línea objetiva
   uint16_t ncampo=0;
   uint16_t lc=0;
   const char *c, *cc;

  // strcpy(buf,"");
   t = linea;
   while ((s = strstr(t,"$"))!=NULL) {
       l = s - t;
       strncat(buf,t,l);         // rescato porción de linea sin tocar, antes del token
       c = s+1;                  // desde el supuesto dígito en adelante
       while (isdigit(*c)) c++;  // obtengo el número del campo
       lc = c - s;               // longitud del número
       if (lc>1) {               // es un campo. 1= no es un campo
          char *cindice,*cind;        // para guardar los índices
          cindice = (char *) malloc (1*(lc+1));
          cind = cindice;
          if (cind==NULL) {     // limpiar la memoria que ya fue asignada
              ///free(ltoken);
              for (l=0;l<=i;++l) free(ltoken[l]);
              free(ltoken);
              free(buffer);
              return NULL;         // no hay memoria para el arreglo
          }
          
          strncpy(cind,s+1,lc);   // preparo el indice del arreglo para obtener token
          ncampo = atoi(cind);
          if (ncampo<=sizei) {     // es un campo válido??
             // aniadir aqui el pad, si lo hay
             const char * campo = ltoken[ncampo];
             if(*c==':'){  // aqui hay un pad
                cc = c;
                c++;  // me lo salto
                
                char *cPadding;
                char *cPadToken;        // para guardar los índices
                int w=0;
                
                while(isdigit(*c)) {c++;++w;}
                lc = c - ( cc+w);
                cPadding = (char *) calloc (lc+1,1);//sizeof(char *));
                cPadToken = (char * ) calloc (128,1);
                char * cPad = cPadding;
          	strncpy(cPad,(cc+w),lc);
          	
                int nPad = atoi(cPad);
                int sizeCampo = strlen(campo);
          	//printf("\nCIND=%d CPAD = %d sizeCampo=%d Campo=%s",ncampo,nPad,sizeCampo,campo);
                if(toupper(*c) == 'C'){  //0
                   cPadToken=strpad(campo,nPad,sizeCampo,0);
                }else if(toupper(*c) == 'L'){  //1
                   cPadToken=strpad(campo,nPad,sizeCampo,1);
                }else if(toupper(*c) == 'R'){  //2
                   cPadToken=strpad(campo,nPad,sizeCampo,2);
                }else{   // error
                   return NULL;
                }
               // printf("\nENTRA AQUI con %s\n",cPadToken);
                if (cPadToken!=NULL) 
                   strcat(buf,cPadToken);
                else
                   strcat(buf,"");

                // printf("\nESTA OK\n");
                c++;
                free(cPadding);
                free(cPadToken);
             }else{
                //strcat(buf,campo);
                char * cCampo = fun_alltrim( (const char*)campo, (HB_SIZE)strlen(campo));
                if (cCampo == NULL){
                   char * cCampo = (char * )calloc(1,1);
                   cCampo[0]='\0';
                }
                const char * pCampo = cCampo;
              //  printf("\nENTRA AQUI con %s\n",cCampo);
                strcat(buf, pCampo);
              //  printf("\nESTA OK\n");
                free(cCampo);
             }
          }
          t = c;              // siempre: por si o por no, el campo será eliminado igual
          free(cindice);
       } else {
          strncat(buf,s,1);   // rescato "$" que no es un campo
          t = ++s;            // avanzo un espacio y continúo el proceso
       }
   }
   // rescato lo último que no ha sido rescatado
   strcat (buf,t);
   int nLen = strlen(buf);
//   buf[nLen+1]='\0';

   // libero memoria
   
   for (l=0;l<=i;++l) free(ltoken[l]);
   free(ltoken);
   
   char * Retorno = (char *) calloc (nLen+1,1);//sizeof(char));
   char * Ret = Retorno;
   strcpy(Ret,buf);
   
   // deguerbo resultado
   free(buffer);
   return Retorno;
/*
//   buf[strlen(buf)+1]='\0';

   // libero memoria
   
   for (l=0;l<=i;++l) free(ltoken[l]);
   free(ltoken);
   
   // deguerbo resultado
   return buffer; */
}

HB_FUNC( XFUNCCCSATURA )
{
    PHB_ITEM pA = hb_param( 1, HB_IT_STRING ); // tokens
    PHB_ITEM pB = hb_param( 2, HB_IT_STRING ); // B = separador
    PHB_ITEM pD = hb_param( 3, HB_IT_STRING ); // D = linea a rellenar
    
    char * pBuffer;
    pBuffer = (char *)fsaturate( hb_itemGetCPtr( pA ), hb_itemGetCPtr( pB ), 
                                 hb_itemGetCPtr( pD ));
    const char * Ret = pBuffer;
    hb_retc( Ret );
    free(pBuffer);
}

char * fun_xmask(const char *formato, const char *car, const char *numero) {
   char *buffer, *pBuf;

   int16_t lf = strlen(formato);
   int16_t ln = strlen(numero); 

   pBuf = (char *)calloc(lf+1,1); //sizeof(char)*(lf+1));
   if (pBuf==NULL) return NULL;

   buffer = pBuf;
   int16_t i=lf, k=lf; 

   char c; 
   --lf; --ln; --k;
   while (lf>=0 && ln>=0) {
      c = formato[lf];
      if (c=='#') buffer[k] = numero[ln--]; 
      else buffer[k] = c;
      --k;
      --lf;
   }
   while (lf>=0) {
      c = formato[lf];
      if (*car) {
         if (c=='#') buffer[k] = *car;
         else buffer[k] = c;
      } else {
         buffer[k] = ' ';
      }
      --lf;
      --k;
   }
   buffer[i]='\0';
  
   return pBuf;
}

char *fun_xmoney (double numero, const char *tipo, const char *cblanc, uint16_t decimales, uint16_t pad){
   char *buf,*buffer,*cnum,*Retnum;
   const char * d, * s;
   uint16_t isize=0, ipart=0, iresto=0, tpad=0, swSign=0, swDec=0;

   buffer = (char *)calloc (32,1); //sizeof(char *) * 24);
   if (buffer==NULL) return NULL;

   buf = buffer;
   
   if( numero < 0 ) {
   	   swSign=1;
   	   numero *= -1;
   }

   uint16_t size = sprintf(buf,"%.*lf",decimales, numero);

   if (decimales>0) {
      d = strstr(buf,".");
      if (d!=NULL) {
         isize = d - buf;  // obtengo parte entera.
         d++;   // tendrá el decimal
         swDec=1;
      } else isize = size;
   } else isize = size;

   int limite = swDec?size-(decimales+1):size;
   iresto = limite > 3 ? isize % 3:0;   // cuantos dígitos sobran
   ipart = (uint16_t) isize / 3; // cuántas particiones debo efectuar; ipart-1=núm de sep
   tpad = isize+(ipart-1)+decimales+2+strlen(tipo)+swSign;

 //  printf("\n**** [%s],len=%lu,size=%d, limite=%d, tpad=%d ****\n",buf,strlen(buf),size,limite,tpad);

   uint16_t blancos=0;

   if (pad < tpad) {
       pad = tpad;
   } else {
       blancos = pad - tpad;
      // if (isize%2!=0) ++blancos;
       if (decimales==0) ++blancos; // por el punto decimal
   }

   Retnum = (char *)calloc(pad+1,1); //sizeof(char *)*(pad+1));
   if (Retnum==NULL) return NULL;
   cnum = Retnum;
   
   strcpy(cnum,tipo);
   uint16_t i;

   for (i=0;i<blancos;i++) strncat(cnum,cblanc,strlen(cblanc));

   if( swSign ) strcat(cnum,"-");

   s = buf;

   // agrego el resto, de existir
   if (iresto>0) {
      strncat(cnum,s,iresto);
      strcat(cnum,",");
      s += iresto;  // avanza el puntero
   }
   // agrego la parte entera
   if (limite >= 3){
      for (i=0;i<ipart; i++) {
         strncat(cnum,s,3);
         if (i<ipart-1) strcat(cnum,",");
         s += 3;
      }
   }else{
      strncat(cnum,s,limite);
      s += limite;
   }
   if (decimales>0) {
      strcat(cnum,".");
      strncat(cnum,d,strlen(d));
   }
   cnum[strlen(cnum)]='\0';
   free(buf);

   return Retnum;
}

HB_FUNC( XFUNMONEY )
{
    double pA = hb_parnd( 1 ); // A = DOUBLE
    PHB_ITEM pB = hb_param( 2, HB_IT_STRING ); // B = TIPO MONEDA
    PHB_ITEM pD = hb_param( 3, HB_IT_STRING ); // D = RELLENO
    int pE = hb_parni( 4 ); // E = DECIMALES
    int pF = hb_parni( 5 ); // F = ANCHO PAD
    
    char * pBuffer, * pRet;
    pBuffer = (char *)fun_xmoney(pA, hb_itemGetCPtr( pB ), 
                                 hb_itemGetCPtr( pD ), pE, pF);
    if( pBuffer != NULL ){
       hb_retc( pBuffer );
    }else{
       pRet = (char*)calloc(2,1);
       strcpy(pRet,"0");
       hb_retc( pRet );
       free(pRet);
    }
    free(pBuffer);
}

HB_FUNC( XFUNMASK )
{
    PHB_ITEM pA = hb_param( 1, HB_IT_STRING ); // A = STRING 
    PHB_ITEM pB = hb_param( 2, HB_IT_STRING ); // B = MASCARA
    PHB_ITEM pD = hb_param( 3, HB_IT_STRING ); // D = CARACTER DE RELLENO
    
    char * pBuffer;
    pBuffer = (char *)fun_xmask(hb_itemGetCPtr( pB ), hb_itemGetCPtr( pD ), 
                               hb_itemGetCPtr( pA ) );
    if( pBuffer != NULL ){
       hb_retc( pBuffer );
    }else{
       // si no hay memoria, devuelve el mismo string
       hb_retc( hb_itemGetCPtr( pA ) );
    }
    free(pBuffer);
}

short int fun_istnumber(const char * AX){
  int DX;
  short int SW_M=0,SW_N=0,SW_P=0,retorne=1;

  while( (DX=*AX)!='\0'){
    if(DX=='-'){
       if (SW_N || SW_P || SW_M) {retorne=0;break;}
       SW_M=1;
    }else if (DX=='.'){
       if (!SW_N || SW_P) {retorne=0;break;}
       SW_P=1;
    }else if (isdigit(DX)) {SW_N=1;
    }else {retorne=0;break;}
    ++AX;
  }
  return retorne;
}

HB_FUNC( ISTNUMBER )  // esto debe ir!! llevar otros codigos semejante a "C"
{
  PHB_ITEM pText = hb_param(1,HB_IT_STRING);
  const char *AX = hb_itemGetCPtr( pText );
  
  hb_retnint(fun_istnumber(AX));
}

HB_FUNC ( D2E )
{
  double nDec = hb_parnd(1);
  double nPrecision = hb_parnd(2);
  char *buf;
  double nExp;
  int signo;
  signo=nDec<0?-1:1;
  if (signo<0) nDec *= -1;
  if( nDec == 0) nExp = 0;
  else if (fabs( nDec ) < 1)  nExp = (double)(int)( log10( nDec ) ) - 1;
  else
      nExp = (double)(int)( log10( fabs( nDec ) + 0.00001 ) );   /* 0.00001 == kludge */
             /* for imprecise logs */
  nDec /= pow(10, nExp );  //pow(10, nExp);
  if (hb_numRound( fabs( nDec ), nPrecision ) >= 10){
      nDec /= 10;
      nExp++;
  }
  //buf = (char *) calloc(sizeof(char)*19+1,1);
  buf = (char *) calloc(32,1);
  switch((int)nPrecision){
     case 1:case 2:case 3: 
         sprintf(buf,"%1.3fE%d",nDec*signo,(int)nExp); break;
     case 4: sprintf(buf,"%1.4fE%d",nDec*signo,(int)nExp); break;
     case 5: sprintf(buf,"%1.5fE%d",nDec*signo,(int)nExp); break;
     case 6: sprintf(buf,"%1.6fE%d",nDec*signo,(int)nExp); break;
     case 7: sprintf(buf,"%1.7fE%d",nDec*signo,(int)nExp); break; 
     case 8: sprintf(buf,"%1.8fE%d",nDec*signo,(int)nExp); break;
     case 9: sprintf(buf,"%1.9fE%d",nDec*signo,(int)nExp); break; 
     default: sprintf(buf,"%1.10fE%d",nDec*signo,(int)nExp); 
  }
  hb_retc( buf );
  free(buf);
}

HB_FUNC ( E2D )
{
   const char *linea = hb_parc(1);
   const char *buf;
   char *sMant;
   double nMant;
   int nExp,mant=0,signo;
   buf=linea;
   while(toupper(*buf)!='E') {
      mant++;
      ++buf;
   }
   nExp = atoi(++buf);
   sMant = (char *)calloc(mant+1,1);
   strncpy(sMant,linea,mant);
   sMant[mant]='\0';
   if (sMant[0]=='-') {
      signo=(-1); 
      sMant++;
   } else signo=1;
   nMant = atof(sMant);
 ///  printf("--> %f, %d, %d\n%f\n",nMant,nExp,signo, nMant * pow( (double)10, (double)nExp)*signo);
   hb_retnd ( nMant * pow( (double)10, (double)nExp)*signo );
}

HB_FUNC( ISNOTATION )  // esto debe ir!! llevar otros codigos semejante a "C"
{
  PHB_ITEM pText = hb_param(1,HB_IT_STRING);
 
  const char *AX = hb_itemGetCPtr( pText );
 // int LX = hb_itemGetCLen( pText );
  int DX;
  short int SW_E=0,SW_P=0,SW_S=0,retorne=1;

  DX=*AX;
  if (DX=='-') ++AX; 
  
  while( (DX=*AX)!='\0'){
    if(toupper(DX)=='E' ){
       if (!SW_E) SW_E=1;
       else {retorne=0;break;}
    }else if (DX=='.'){
       if (!SW_P) SW_P=1;
       else {retorne=0;break;}
    }else if (DX=='+' || DX=='-') {
       if (!SW_S) SW_S=1;
       else {retorne=0;break;}
    }else if (!isdigit(DX)) {retorne=0;break;}
    ++AX;
  }
  if (!SW_E || !SW_P) retorne=0;
  
  hb_retnint(retorne);
}

/*
HB_FUNC( BUSCAFULL )
{
   unsigned int pKey  = hb_parni( 1 );
   PHB_ITEM pSTRING = hb_param( 2, HB_IT_STRING );
   unsigned int pLen = hb_parni( 3 );  //len busca
   
   const char * t = hb_itemGetCPtr( pSTRING );


   printf("%c, %c",*(t+pKey-2),*(t+pKey+pLen-1));
   if ( isalpha(*(t+pKey-2)) || isdigit(*(t+pKey-2)) || 
        isalpha(*(t+pKey+pLen-1)) || isdigit(*(t+pKey+pLen-1)) ) 
      hb_retni( 0 );
   else
      hb_retni( pKey );
   hb_itemClear( pSTRING );
}*/


/* busca palabras completas. Solo strings */
// tmppo:=BUSCACOMPLETA(tmpPos,STRING,len(BUSCA))

HB_FUNC( BUSCACOMPLETA )
{
   unsigned int pKey  = hb_parni( 1 );
   PHB_ITEM pSTRING = hb_param( 2, HB_IT_STRING );
   unsigned int pLen = hb_parni( 3 );  //len busca
   
   const char * t = hb_itemGetCPtr( pSTRING );

   if ( isalpha(*(t+pKey-2)) || isdigit(*(t+pKey-2)) || 
        isalpha(*(t+pKey+pLen-1)) || isdigit(*(t+pKey+pLen-1)) ) 
      hb_retni( 0 );
   else
      hb_retni( pKey );
   hb_itemClear( pSTRING );
}

HB_FUNC( LLENATEXTO )
{
   PHB_ITEM pTexto    = hb_param( 1, HB_IT_ARRAY );
   unsigned int pLen  = hb_parni( 2 );
   unsigned int pIni  = hb_parni( 3 );

   unsigned int i=0;
   int pos=0;
   // rellena texto
 
   char * linea = (char*)calloc(pLen+1,1);

   for( i=1;i<=pLen+pIni;i++) {
      PHB_ITEM pString = hb_itemArrayGet( pTexto, i);
      const char * c = hb_itemGetCPtr( pString );
      hb_itemRelease(pString);
      if (i>pIni) {
         linea[pos++] = c[0];
      }
   }
   linea[pos]='\0';
   hb_retc( linea );
   free( linea );
   hb_itemClear( pTexto );
   //hb_xfree(linea);
   ///hb_itemFreeC( linea );
}


HB_FUNC( SEQUENCE )
{
   double pDesde    = hb_parnd( 1 );
   double pInc    = hb_parnd( 2 );
   unsigned pTotal  = hb_parni( 3 );

   long n;
   PHB_ITEM pC = hb_itemArrayNew( pTotal );
   
   hb_arraySetND( pC, 1,     (double) pDesde );
   
   for( n=2; n<=pTotal; n++){
      PHB_ITEM pCC = hb_itemArrayGet( pC, n-1);
      hb_arraySetND( pC, n, hb_itemGetND( pCC ) + pInc );
      hb_itemRelease(pCC);
   }
    
   hb_itemReturnRelease( pC );
}

HB_FUNC( SEQSP )
{
   double pDesde    = hb_parnd( 1 );
   double pHasta    = hb_parnd( 2 );
   unsigned pTotal  = hb_parni( 3 );
   double inc = (pHasta - pDesde) / ( pTotal - 1);
   long n;
   PHB_ITEM pC = hb_itemArrayNew( pTotal );
   
   hb_arraySetND( pC, 1,     (double) pDesde );
   hb_arraySetND( pC, pTotal,(double) pHasta );
   
   for( n=2; n<=pTotal-1; n++){
      PHB_ITEM pCC = hb_itemArrayGet( pC, n-1);
      hb_arraySetND( pC, n, hb_itemGetND( pCC ) + inc );
      hb_itemRelease(pCC);
   }
    
   hb_itemReturnRelease( pC );
}

HB_FUNC( GETLINEAS )
{
   PHB_ITEM pSTRING = hb_param( 1, HB_IT_STRING );
   long nTotal  = hb_parnl( 2 );
   long nTotCar  = hb_parnl( 3 );
   long nMax  = hb_parnl( 4 );

   PHB_ITEM pCWM = hb_itemArrayNew( nTotal ); // CWM
   const char * STRING = hb_itemGetCPtr( pSTRING );
   long i;
   long totalCar = 0;
   int swError=0;
   if (nMax<=0){
      nMax=1024;
   }
   for(i=0;i<nTotal;i++){
      char * cBuff = (char *)calloc(nMax+nMax,1);
      long j=0;
      while( totalCar <= nTotCar ) {
         ///printf("DATO----- [%c] %d \n",*STRING,(int)*STRING);
         if ( *STRING!='\n' /* || *STRING==(char)13 */){
           // printf("Asigna STRING...\n");
            if(j>nMax+nMax){
               
               swError=1;
               j=nMax+nMax-1;
               break;
            }
            cBuff[j++] = *STRING;
           // printf("Asignado!!...\n");
            ++totalCar;
            ++STRING;
         }else{
            ++totalCar;
            ++STRING;  // nos saltamos '\n'
            ///++STRING;
            break;
         }
      }
      if (swError) {
         hb_arraySetC( pCWM, i+1, (const char *) "ERROR-DE-FORMATO-NO-RECONOCIDO" );
         free ( cBuff );
         break;
      }
      if(j>=0){
         cBuff[j]='\0';
         const char * pBuffer = cBuff;
         hb_arraySetC( pCWM, i+1, (const char *) pBuffer );
   //               printf("Libera cBuff...\n");
         free ( cBuff );
         
   //               printf("Liberado!...\n");
      }else{ 
         hb_arraySetC( pCWM, i+1, (const char *) "ERROR-DE-FORMATO-NO-RECONOCIDO" );
         free( cBuff );
         break;
      }
      
   }
   
   hb_itemClear( pSTRING );
   hb_itemReturnRelease( pCWM );
}

HB_FUNC( SPCUENTALINEAS )
{
   const char * pFile = hb_parc( 1 );

   FILE *fp;
   long nLin=0,nTotCar=0,nLong=0,noldLong=0;
   int sw_Enter=0,sw_Car=0;
   char ch;
   
   fp=fopen(pFile,"r");
   if (fp!=NULL){
      nLin = 0;
      while ((ch = fgetc(fp)) != EOF){
        if (ch == (char)13){
           sw_Enter=1;
           sw_Car=0;
           nLin++;
           if (noldLong < nLong) { // longitud máxima de la línea
              noldLong = nLong;
              nLong=0;
           }
        }else{
           sw_Enter=0;
           sw_Car=1;
           nLong++;
        }
        nTotCar++;
      }
      fclose(fp);
      if(sw_Enter==0 && sw_Car==1)
        ++nLin;
   }

   PHB_ITEM pCWM = hb_itemArrayNew( 3 );
   hb_arraySetNL( pCWM, 1, (long) nLin );
   hb_arraySetNL( pCWM, 2, (long) nTotCar );
   hb_arraySetNL( pCWM, 3, (long) noldLong );
   hb_itemReturnRelease( pCWM );
}

HB_FUNC( CUENTALINEAS )
{
   const char * pFile = hb_parc( 1 );

   FILE *fp;
   long nLin=0,nTotCar=0,nLong=0,noldLong=0;
   int sw_Enter=0,sw_Car=0;
   char ch;
   
   fp=fopen(pFile,"r");
   if (fp!=NULL){
      nLin = 0;
      while ((ch = fgetc(fp)) != EOF){
        if (ch == '\n'){
           sw_Enter=1;
           sw_Car=0;
           nLin++;
           if (noldLong < nLong) { // longitud máxima de la línea
              noldLong = nLong;
              nLong=0;
           }
        }else{
           sw_Enter=0;
           sw_Car=1;
           nLong++;
        }
        nTotCar++;
      }
      fclose(fp);
      if(sw_Enter==0 && sw_Car==1)
        ++nLin;
   }

   PHB_ITEM pCWM = hb_itemArrayNew( 3 );
   hb_arraySetNL( pCWM, 1, (long) nLin );
   hb_arraySetNL( pCWM, 2, (long) nTotCar );
   hb_arraySetNL( pCWM, 3, (long) noldLong );
   hb_itemReturnRelease( pCWM );
}

HB_FUNC( STRCUENTALINEAS )
{
   PHB_ITEM pSTRING = hb_param( 1, HB_IT_STRING );
   
   long nLin=0;
   int sw_Enter=0,sw_Car=0;
   
   nLin = 0;
   const char * STRING = hb_itemGetCPtr( pSTRING );
   
   while ( *STRING != '\0' ){
     if (*STRING == '\n'){
        sw_Enter=1;
        sw_Car=0;
        nLin++;
     }else{
        sw_Enter=0;
        sw_Car=1;
     }
     STRING++;
   }
   if(sw_Enter==0 && sw_Car==1)
     ++nLin;

   hb_itemClear( pSTRING );
   hb_retni ( nLin );
}

void hb_colorwin(int iTop, int iLeft, int iBottom, int iRight, int iNewColor){
  
   HB_BOOL fAll = HB_TRUE;
   int iOldColor = 0;
   
   hb_gtBeginWrite();
   while( iTop <= iBottom )
   {
     int iCol = iLeft;
     while( iCol <= iRight )
     {
       int iColor;
       HB_BYTE bAttr;
       HB_USHORT usChar;

       hb_gtGetChar( iTop, iCol, &iColor, &bAttr, &usChar );
       if( fAll || iColor == iOldColor )
         hb_gtPutChar( iTop, iCol, iNewColor, bAttr, usChar );
       ++iCol;
     }
     ++iTop;
   }
   hb_gtEndWrite();
}

//BUSCAPARLLAVE(p,SLINEA,TEXTO,px,py,lini,TLINEA-3,cini,pi,dir)
HB_FUNC( BUSCAPARLLAVE )
{
   int p       = hb_parni( 1 );
   int SLINEA  = hb_parni( 2 );
   PHB_ITEM pTexto = hb_param( 3, HB_IT_ARRAY );
   int px      = hb_parni( 4 );
   int py      = hb_parni( 5 );  
   long TLINEA  = hb_parni( 6 );  // delta desde pi hasta el fin de ventana
   int cini    = hb_parni( 7 );  // p+cini
   long pi      = hb_parni( 8 );  // fila fisica
   int dir      = hb_parni( 9 );  // adelante=1; 0=atras
   const char * simbolo = hb_parc( 10 );  // simbolo llave u otro
   
   int i,ipar=0;
   char npar=0,par=0;
   long lini = py;
   
   hb_colorwin(py,px,py,px,32);  // colorea la primera llave.

   if (*simbolo=='(')     {npar='(';par=')';}
   else if(*simbolo=='[') {npar='[';par=']';}
   else if(*simbolo==')') {npar=')';par='(';}
   else if(*simbolo==']') {npar=']';par='[';}
   else if(*simbolo=='{') {npar='{';par='}';}
   else if(*simbolo=='}') {npar='}';par='{';}
 
   if(dir) {  // adelante
      for (i=pi; i<=TLINEA+pi; i++){
         PHB_ITEM pAA = hb_itemArrayGet( pTexto, i);
         const char * s = hb_itemGetCPtr( pAA );
         //long nLen = hb_itemGetCLen( pAA );
         hb_itemRelease( pAA );
         const char *t = s;
         t=s+(p-1);  // posicion 
         int xini=(p-1);
         
         //for(xini=p; xini<=nLen; xini++){
         while(*t){
            if (*t==npar) ++ipar;
            if (*t==par) --ipar;
            if (ipar==0){
               if(xini<=SLINEA && xini>=cini)
                  hb_colorwin(py,px,py,px,32);
               break;
            }
            ++t;
            ++px;++xini;
         }
         if (ipar==0) break;
         p=1;  // por el -1 de t=s+p-1
         ++py; px=1;
      }
   }else{  // atrás
      //++ipar;
      for (i=pi; i>=pi-(lini+1); i--){
         PHB_ITEM pAA = hb_itemArrayGet( pTexto, i);
         const char * s = hb_itemGetCPtr( pAA );
         long nLen = hb_itemGetCLen( pAA );
         hb_itemRelease( pAA );
         
         const char *t = s;
         if (i<pi){
            p=nLen;
            px=nLen;
         }
         t=s+(p-1);  // posicion 
         int xini;
         
         for(xini=(p-1); xini>=0; xini--){
        // while(t>=s){
            if (*t==npar) ++ipar;
            if (*t==par) --ipar;
            if (ipar==0){
               if(xini<=SLINEA && xini>=cini && py>=1){
                  hb_colorwin(py,px,py,px,32);
                  //printf("PASA... %c = %d, %d %s\n",*t,py,px,s);
                  }
               break;
            }
            t=s+(xini-1);
            --px;
         }
         if (ipar==0) break;
         --py;
      }   
   }      
   hb_itemClear(pTexto);
   
}      

//BUSCAPARSIMBOLO(p,SLINEA,s,py,px,cini)
/*HB_FUNC( BUSCAPARSIMBOLO )
{
   int p       = hb_parni( 1 );
   int SLINEA  = hb_parni( 2 );
   PHB_ITEM pS = hb_param( 3, HB_IT_STRING );
   int py      = hb_parni( 4 );
   int px      = hb_parni( 5 );
   int cini    = hb_parni( 6 );
   const char * s = hb_itemGetCPtr( pS );
   const char *t;
   char npar,par;
   int swDir=1;  //1=hacia derecha-abajo; 0=hacia izquierda-arriba
   int go=1;
   int cpar,ipar,xini;
   long nLen = ( long ) strlen( s );
   
   t=s+p-1;  // ubico en posicion p   
   if (*t=='(')     {npar='(';par=')';}
   else if(*t=='[') {npar='[';par=']';}
   else if(*t==')') {npar=')';par='(';swDir=0;}
   else if(*t==']') {npar=']';par='[';swDir=0;}
 //  else if(*t=='{') {npar='{';par='}';}
 //  else if(*t=='}') {npar='}';par='{';swDir=0;}
   else{
      go=0;
   }
   if (go){
         hb_colorwin(py,px,py,px,32);
         cpar=0;
         ipar=0;
         if (swDir){
            for(xini=p+1; xini<=nLen; xini++){
               ++ipar;
               t=s+xini-1;
               if (*t==(char)34){
                  if ( *(t-1)!='\\'){
                     ++xini;
                     while(xini<=nLen){
                        ++ipar;
                        t=s+xini-1;
                        if (*t==(char)34){
                           if ( *(t-1)!='\\'){
                              break;
                           }
                        }
                        ++xini;
                     }
                     if (xini>nLen) break;
                  }
               }
               
               if (*t==npar){
                  ++cpar;
               }else if (*t==par){
                  if (cpar==0){
                     if (xini<=SLINEA){
                        hb_colorwin(py,px+ipar,py,px+ipar,32);
                        break;
                     }else{
                        break;
                     }
                  }
                  --cpar;
               }
            }
         }else{  // de derecha a izquierda
            for( xini=p-1; xini>=1;xini--){
               ++ipar;
               t=s+xini-1;
               
               if (*t==(char)34){
                  if ( *(t-1)!='\\'){
                     --xini;
                     while(xini>=1){
                        ++ipar;
                        t=s+xini-1;
                        if (*t==(char)34){
                           if ( *(t-1)!='\\'){
                              break;
                           }
                        }
                        --xini;
                     }
                     if (xini<=0) break;
                  }
               }
               
               if (*t==npar)
                  ++cpar;
               else if (*t==par){
                  if (cpar==0){
                     if (xini>=cini){
                        hb_colorwin(py,px-ipar,py,px-ipar,32);
                        break;
                     }else{
                        break;
                     }
                  }
                  --cpar;
               }
            }
         }
   }
   hb_itemClear(pS);
}*/

HB_FUNC( CADBLOQUEC )
{
   PHB_ITEM pTexto   = hb_param( 1, HB_IT_ARRAY );
   unsigned int cINI = hb_parni( 2 );
   unsigned int INI  = hb_parni( 3 );
   unsigned int cLEN = hb_parni( 4 );
   unsigned int tCOL = hb_parni( 5 );
   unsigned int cCADENA = hb_parni( 6 );
   
   unsigned int i,j,k=1, SWBLOQUE=0;
   --INI;
   for(i=cINI; i<=INI; i++){
      PHB_ITEM pString = hb_itemArrayGet( pTexto, i );
      const char * cSTR = hb_itemGetCPtr( pString );
      long nLen = ( long ) strlen( cSTR );
      for(j=1; j<=nLen; j++){
        if( *cSTR == '$'){
           if ( *(cSTR+1) == '$' ){
               continue;
           }else if ( *(cSTR-1) == '\\' ){
            ////elseif substr(TEXTO[I],j-1,1)=="\"
               continue;
           }else{
               if ( SWBLOQUE ){
                  SWBLOQUE=0;
                  if ( i >= cLEN ){
                     if ( tCOL <= 1 ){
                        hb_colorwin(k, j, k, j+1, cCADENA);
                     }else{
                        if ( j > tCOL ){
                           hb_colorwin(k, j-tCOL, k, j-tCOL+1, cCADENA); 
                        }
                     }
                  }
               }else{
                  SWBLOQUE=1;
               }
            }
         }
         if ( i >= cLEN ){  // está dentro de la ventana de edicion
            if ( SWBLOQUE ){
              if ( tCOL <= 1 ){
                 hb_colorwin(k, j, k, j, cCADENA);
              }else{
                  if ( j > tCOL ){
                     hb_colorwin(k, j-tCOL, k, j-tCOL, cCADENA);
                  }
               }
            }
         }
         ++cSTR;
      }
      if ( i >= cLEN ){
         ++k;
      }
      hb_itemRelease(pString);
   }
   hb_itemClear(pTexto);
}

/* marca de bloque */
// MARKBLOQUE(TEXTO,cINI,INI,XFILi,XCOLi,XFILf,XCOLf,TCOL,71)
/*HB_FUNC( MARKBLOQUE )
{
   PHB_ITEM pTexto   = hb_param( 1, HB_IT_ARRAY );
   unsigned int cINI = hb_parni( 2 );
   unsigned int INI  = hb_parni( 3 );
   unsigned int XFILi = hb_parni( 4 );
   unsigned int XCOLi = hb_parni( 5 );
   unsigned int XFILf = hb_parni( 6 );
   unsigned int XCOLf = hb_parni( 7 );
   unsigned int tCOL = hb_parni( 8 );
   unsigned int cEDITCOM = hb_parni( 9 );
   
   unsigned int i,j,k=1, SWBLOQUE=0;
   --INI;
   for(i=cINI; i<=INI; i++){
      PHB_ITEM pString = hb_itemArrayGet( pTexto, i );
      const char * cSTR = hb_itemGetCPtr( pString );
      long nLen = ( long ) strlen( cSTR );
      for(j=1; j<=nLen; j++){
         if( *cSTR == '/'){
            if ( *(cSTR+1) == '*' ){ 
               SWBLOQUE=1;
            }else if ( *(cSTR+1) == '/' ){ 
               break;
            }
         }else if ( *cSTR == '*' ){
            if ( *(cSTR+1) == '/' ){
               SWBLOQUE=0;
               if ( i >= cLEN ){
                  if ( tCOL <= 1 ){
                     hb_colorwin(k, j, k, j+1, cEDITCOM);
                  }else{
                     hb_colorwin(k, j-tCOL, k, j-tCOL+1, cEDITCOM);
                  }
               }
            }
         }
         if ( i >= cLEN ){
            if ( SWBLOQUE ){
               if ( tCOL <= 1 ){
                  hb_colorwin(k, j, k, j, cEDITCOM);
               }else{
                  if ( j > tCOL ){
                     hb_colorwin(k, j-tCOL, k, j-tCOL, cEDITCOM);
                  }
               }
            }
         }
         ++cSTR;
      }
      if ( i >= cLEN ) ++k;
      hb_itemRelease(pString);
   }
   hb_itemClear(pTexto);
}*/

/* comentarios de bloque de C */
HB_FUNC( COMBLOQUEC )
{
   PHB_ITEM pTexto   = hb_param( 1, HB_IT_ARRAY );
   unsigned int cINI = hb_parni( 2 );
   unsigned int INI  = hb_parni( 3 );
   unsigned int cLEN = hb_parni( 4 );
   unsigned int tCOL = hb_parni( 5 );
   unsigned int cEDITCOM = hb_parni( 6 );
   
   unsigned int i,j,k=1, SWBLOQUE=0, SWSTRING=0;
   --INI;
   for(i=cINI; i<=INI; i++){
      PHB_ITEM pString = hb_itemArrayGet( pTexto, i );
      const char * cSTR = hb_itemGetCPtr( pString );
      long nLen = ( long ) strlen( cSTR );
      SWSTRING=0;
      for(j=1; j<=nLen; j++){
         // veo si esta dentro de un string:
         if( *cSTR == '"' && *(cSTR-1) != '\\') {
            if (!SWSTRING) SWSTRING=1;
            else SWSTRING=0;
         } 
         // hasta aquí
         if( *cSTR == '/'){
            if ( *(cSTR+1) == '*' ){
               if (!SWSTRING)
                  SWBLOQUE=1;
            }else if ( *(cSTR+1) == '/' ){
               if (!SWSTRING) 
                  break;
            }
         }else if ( *cSTR == '*' ){
            if (!SWSTRING){
               if ( *(cSTR+1) == '/' ){
                  if (SWBLOQUE){   // hay un bloque abierto
                     SWBLOQUE=0;
                     if ( i >= cLEN ){
                        if ( tCOL <= 1 ){
                           hb_colorwin(k, j, k, j+1, cEDITCOM);
                        }else{
                           hb_colorwin(k, j-tCOL, k, j-tCOL+1, cEDITCOM);
                        }
                     }
                  }else{
                     if ( i >= cLEN ){
                        if ( tCOL <= 1 ){
                           hb_colorwin(k, j, k, j+1, 71);
                        }else{
                           hb_colorwin(k, j-tCOL, k, j-tCOL+1, 71);
                        }
                     }
                     
                  }
               }
            }
         }
         if ( i >= cLEN ){
            if ( SWBLOQUE ){
               if ( tCOL <= 1 ){
                  hb_colorwin(k, j, k, j, cEDITCOM);
               }else{
                  if ( j > tCOL ){
                     hb_colorwin(k, j-tCOL, k, j-tCOL, cEDITCOM);
                  }
               }
            }
         }
         // aprovecho de analizar los {}
        // if (*cSTR == '{' ){ // abre un paréntesis
            
        // }
         
         ++cSTR;
      }
      if ( i >= cLEN ) ++k;
      hb_itemRelease(pString);
   }
   hb_itemClear(pTexto);
}

// COLORBLOCKREM( cLEN,I,TCOL,cEDITCOM,nLenCom,SLINEA,XCOLORES )
/*
HB_FUNC( COLORBLOCKREM )
{
   unsigned int nSize    = hb_parni( 1 );  //
   unsigned int I        = hb_parni( 2 );  //
   unsigned int TCOL     = hb_parni( 3 );  //
   unsigned int cEDITCOM = hb_parni( 4 );  // color cadena
   unsigned int nLenCom  = hb_parni( 5 );  // 
   unsigned int SLINEA   = hb_parni( 6 );  // largo linea
   PHB_ITEM pCOLORES     = hb_param( 7, HB_IT_ARRAY ); //

   unsigned int j;
   for (j=1; j<=nSize; j+=2){
      int XCOLORES = hb_itemGetNInt( hb_itemArrayGet( pCOLORES, j ));
      if ( fabsf((float)XCOLORES) < TCOL )
         XCOLORES=0;
      
      int XCOLORES1 = hb_itemGetNInt( hb_itemArrayGet( pCOLORES, j+1 ));
      if ( fabsf((float)XCOLORES1) < TCOL )
         XCOLORES1=0;
      
      if ( XCOLORES < 0 && XCOLORES1 > 0 )
         hb_colorwin(I, XCOLORES*(-1)-TCOL, I, XCOLORES1-TCOL+nLenCom,cEDITCOM );
      else if ( XCOLORES==0 && XCOLORES1==0 )
         continue;
      else if ( XCOLORES==0 && XCOLORES1 > 0 ) // termina bloque iniciado antes
         hb_colorwin(I, 1, I, XCOLORES1-TCOL+nLenCom,cEDITCOM );
      else if ( XCOLORES<0 && XCOLORES1==0 )  // inicia uno que no alcanza a verse 
         hb_colorwin(I, XCOLORES*(-1)-TCOL, I, SLINEA,cEDITCOM );
   }
}
*/
// COLORREMARKS( cLEN,I,TCOL,cEDITCOM,SLINEA,XCOLORES )
/*
HB_FUNC( COLORREMARKS )
{
   unsigned int nSize    = hb_parni( 1 );  //
   unsigned int I        = hb_parni( 2 );  //
   unsigned int TCOL     = hb_parni( 3 );  //
   unsigned int cEDITCOM = hb_parni( 4 );  // color cadena
   unsigned int SLINEA   = hb_parni( 5 );  // largo linea
   PHB_ITEM pCOLORES     = hb_param( 6, HB_IT_ARRAY ); //

   unsigned int pINICOL=0;
   unsigned int j;
   for (j=1; j<=nSize; j++){
      int XCOLORES = hb_itemGetNInt( hb_itemArrayGet( pCOLORES, j ));
      if (XCOLORES <0 ) {
         pINICOL=( XCOLORES*(-1) );
         if( pINICOL < TCOL )
             hb_colorwin(I, 1, I, SLINEA,cEDITCOM );
         else if( pINICOL>TCOL )
             hb_colorwin(I, pINICOL-TCOL, I, SLINEA,cEDITCOM );
         else
             hb_colorwin(I, 1, I, SLINEA,cEDITCOM );
         break;
      }
   }
}
*/
/*
HB_FUNC( COLORSTRINGS )
{
   unsigned int nSize  = hb_parni( 1 );  //
   unsigned int I      = hb_parni( 2 );  //
   unsigned int TCOL   = hb_parni( 3 );  //
   unsigned int cCADENA= hb_parni( 4 );  // color cadena
   unsigned int SLINEA = hb_parni( 5 );  // largo linea
   PHB_ITEM pCOLORES   = hb_param( 6, HB_IT_ARRAY ); //
   
   int cColor=0;
   int pINICOL=0, pFINCOL=0;
   
   unsigned int j;
   for (j=1; j<=nSize; j++){
      ++cColor;
      int XCOLORES = hb_itemGetNInt( hb_itemArrayGet( pCOLORES, j ));
      if(XCOLORES != 0){
         if (XCOLORES < 0){
            pINICOL=0;
            break;
         }else{
            if ( fmodf((float)cColor,(float)2)!=0 ){
               pINICOL = XCOLORES - TCOL;
            }else{
               if ( pINICOL == 0 ){
                  pINICOL=1;
               }
               pFINCOL=XCOLORES - TCOL;
               hb_colorwin(I, pINICOL, I, pINICOL+pFINCOL-pINICOL,cCADENA );
               pINICOL=0; pFINCOL=0;
            }
         }
      }
   }
   // analizo remanente.
   if ( pINICOL > 0 )  // no alcanza a cerrar, porque queda fuera de la ventana
      hb_colorwin(I, pINICOL, I, SLINEA, cCADENA );
}
*/

/*HB_FUNC( XCOLORWIN )
{
   unsigned int nFIL   = hb_parni( 1 );
   PHB_ITEM pPos       = hb_param( 2, HB_IT_ARRAY ); // 
   PHB_ITEM pWord      = hb_param( 3, HB_IT_ARRAY ); //
   unsigned int nColor = hb_parni( 4 );  //
   unsigned int nSize  = hb_parni( 5 );  //
   
   unsigned int i;
   for (i=1;i<=nSize; i++){
      PHB_ITEM pP = hb_itemArrayGet( pPos, i );
      int nPOS1 = hb_itemGetNInt( hb_itemArrayGet( pP, 1 ));
      int nPOS2 = hb_itemGetNInt( hb_itemArrayGet( pP, 2 ));
      const char * palabra = hb_itemGetCPtr( hb_itemArrayGet( pWord, nPOS1 ) );
      hb_colorwin(nFIL, nPOS2, nFIL, nPOS2+strlen( palabra )-1, nColor);
   }
}*/

/* busca matches para colorear. puede solapar palabras :( */
/* PONECOLORALAHUEA(lKEYWORD,lSECCION,lDEFINE,cKEYWORD,cSECCION,cEDITDEF,FILA,@STRING) */

HB_FUNC( PONECOLORALAHUEA )
{
   PHB_ITEM pListaK  = hb_param( 1, HB_IT_ARRAY ); // lista de comandos
   PHB_ITEM pListaS  = hb_param( 2, HB_IT_ARRAY ); // lista de comandos
   PHB_ITEM pListaD  = hb_param( 3, HB_IT_ARRAY ); // lista de comandos
   unsigned int nColorK = hb_parni( 4 );
   unsigned int nColorS = hb_parni( 5 );
   unsigned int nColorD = hb_parni( 6 );
   unsigned int nFIL = hb_parni( 7 );

   PHB_ITEM tSTRING = hb_param(8, HB_IT_STRING); // string a procesar
   
   unsigned int i;
   const char * pSTRING = hb_itemGetCPtr( tSTRING );

   
   long uiArrayLen = ( long ) hb_arrayLen( pListaK );
   for(i=1; i<=uiArrayLen;i++){  // para cada elemento de la lista
      PHB_ITEM pString = hb_itemArrayGet( pListaK, i );
      const char * pElemento = hb_itemGetCPtr( pString );
      long sLen = hb_itemGetCLen( pString );
      hb_itemRelease(pString);
      
      const char *t,*r;
      int l;
      r = pSTRING;
      t = strstr(r,pElemento);
       
      while(t!=NULL){
        // ( isalpha(*(t+pKey-2)) || isdigit(*(t+pKey-2)) || 
        //isalpha(*(t+pKey+pLen-1)) || isdigit(*(t+pKey+pLen-1)) ) 
        
         if ( ( !isalpha(*(t-1)) && !isdigit(*(t-1)) &&
            !isalpha(*(t+sLen)) && !isdigit(*(t+sLen)) ) ||
            pElemento[0]==']'||pElemento[0]=='['||pElemento[0]==')'||
            pElemento[0]=='('||pElemento[0]=='}'||pElemento[0]=='{'||
            pElemento[0]=='$'||pElemento[0]=='!'||pElemento[0]=='@'||
            pElemento[0]=='?'||pElemento[0]==':'||pElemento[0]=='|'||pElemento[0]=='&') {
            l = ( t - pSTRING ) + 1;
         
            // en vez de llenar un array, colorear de inmediato.
            hb_colorwin(nFIL, l, nFIL, l+sLen-1, nColorK);
         }
         r = t + sLen;
         t = strstr(r,pElemento);
      }
   } 

   uiArrayLen = ( long ) hb_arrayLen( pListaS );
   for(i=1; i<=uiArrayLen;i++){  // para cada elemento de la lista
      PHB_ITEM pString = hb_itemArrayGet( pListaS, i );
      const char * pElemento = hb_itemGetCPtr( pString );
      long sLen = hb_itemGetCLen( pString );
      hb_itemRelease(pString);
      
      const char *t,*r;
      int l;
      r = pSTRING;
      t = strstr(r,pElemento);
       
      while(t!=NULL){
         if ( ( !isalpha(*(t-1)) && !isdigit(*(t-1)) &&
            !isalpha(*(t+sLen)) && !isdigit(*(t+sLen)) ) ||
            pElemento[0]==']'||pElemento[0]=='['||pElemento[0]==')'||
            pElemento[0]=='('||pElemento[0]=='}'||pElemento[0]=='{'||
            pElemento[0]=='$'||pElemento[0]=='!'||pElemento[0]=='@'||
            pElemento[0]=='?'||pElemento[0]==':'||pElemento[0]=='|'||pElemento[0]=='&') {
            l = ( t - pSTRING ) + 1;
         
            // en vez de llenar un array, colorear de inmediato.
            hb_colorwin(nFIL, l, nFIL, l+sLen-1, nColorS);
         }
         r = t + sLen;
         t = strstr(r,pElemento);
      }
      
   } 

   uiArrayLen = ( long ) hb_arrayLen( pListaD );
   for(i=1; i<=uiArrayLen;i++){  // para cada elemento de la lista
      PHB_ITEM pString = hb_itemArrayGet( pListaD, i );
      const char * pElemento = hb_itemGetCPtr( pString );
      long sLen = hb_itemGetCLen( pString );
      hb_itemRelease(pString);
      const char *t,*r;
      int l;
      r = pSTRING;
      t = strstr(r,pElemento);
       
      while(t!=NULL){
         if ( ( !isalpha(*(t-1)) && !isdigit(*(t-1)) &&
            !isalpha(*(t+sLen)) && !isdigit(*(t+sLen)) ) ||
            pElemento[0]==']'||pElemento[0]=='['||pElemento[0]==')'||
            pElemento[0]=='('||pElemento[0]=='}'||pElemento[0]=='{'||
            pElemento[0]=='$'||pElemento[0]=='!'||pElemento[0]=='@'||
            pElemento[0]=='?'||pElemento[0]==':'||pElemento[0]=='|'||pElemento[0]=='&') {
            l = ( t - pSTRING ) + 1;
         
            // en vez de llenar un array, colorear de inmediato.
            hb_colorwin(nFIL, l, nFIL, l+sLen-1, nColorD);
         }
         r = t + sLen;
         t = strstr(r,pElemento);
      }

   }
 //  hb_itemRelease(tSTRING); Esto causa un error en valgrind.
   hb_itemClear(pListaK);
   hb_itemClear(pListaS);
   hb_itemClear(pListaD);
}

HB_FUNC( PUSHKEYARR )
{
   PHB_ITEM pTexto = hb_param( 1, HB_IT_ARRAY );
   long uiArrayLen = ( long ) hb_arrayLen( pTexto );
   long i;
   for (i=1; i<=uiArrayLen; i++)
      hb_inkeyPut((HB_MAXINT)  hb_itemGetNInt( hb_itemArrayGet( pTexto, i )));
   
}

HB_FUNC( PUSHKEY )
{
   unsigned int pKey  = hb_parni( 1 );
   unsigned int pRep  = hb_parni( 2 );
   unsigned int i;
   for (i=0; i<pRep; i++)
      hb_inkeyPut(pKey);
   
}

HB_FUNC( CMDSYSTEM )
{
  PHB_ITEM pText = hb_param(1,HB_IT_STRING);
  unsigned int pLen  = hb_parni( 2 );
  
  const char * string = hb_itemGetCPtr( pText );
  
  int ret,R;
  
  if(pLen==1){
     R=system("clear");
  }
  ret=system(string);
  if(pLen==1){
     R=system("echo \"Presss any key to continue...\"");
  }
  hb_itemClear( pText );
  hb_retni(ret);
}

HB_FUNC( CLEARTERM )
{
   int R;
   R=system("clear");
}

/*
HB_FUNC( COMENTARIOBLOQUE )
{
   PHB_ITEM pTexto    = hb_param( 1, HB_IT_STRING );
  // unsigned int pIni  = hb_parni( 2 );
   PHB_ITEM pColores   = hb_param( 2, HB_IT_ARRAY );  // array de colores. inicial= 0
   ///const char * pCom   = hb_parc( 3 );  // comentario de linea.
   PHB_ITEM tCom = hb_param(3, HB_IT_STRING);
   
      // busca colores
      int nSize=0,swStr=0,swBloque=0,pPos;
      char cAnt=' '; 
      
      const char * pCom = hb_itemGetCPtr( tCom );
      int nLenCom=strlen(pCom);
      long i;
      const char * c = hb_itemGetCPtr( pTexto );
      long uiArrayLen = strlen( c );
      
      for(i=0; i<uiArrayLen; i++){
         
         if ( c[i] == (char)34 ){   // '"'
            if ( cAnt != (char)92 ){  // "\"
               swStr = !swStr;
            }
         }else if ( c[i] == pCom[0] ){  //'/' ){ //(char)47){  // comentario?
               if ( nLenCom > 1 ){
                  if ( c[i+1] == '*' ) {  // comentario de bloque
                     if ( !swStr && !swBloque ){  // está fuera de un string
                        pPos=i+1;
                        hb_arraySize( pColores, ++nSize );
                        hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos*(-1) );
                        swBloque=1;
                        // es comentario de bloque: hay que seguir buscando colores, por si se cierra
                     }
                  }
               }
         }else if ( c[i] == (char)42 ) { 
             if ( c[i+1] == (char)47 ) {   // lo cierra
                if ( !swStr ){  // está fuera de un string
                    pPos=i+1;
                    hb_arraySize( pColores, ++nSize );
                    hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                    swBloque=0;
                    // es comentario de bloque: hay que seguir buscando colores, por si se cierra
                }
             }
         }
         cAnt = c[i];  // respaldo anterior.
      }
 
   hb_itemReturn( pColores );
   hb_retni( swBloque );
}
*/
/*HB_FUNC( LLENACOLORES )
{
   PHB_ITEM pTexto    = hb_param( 1, HB_IT_STRING );
   unsigned int pIni  = hb_parni( 2 );
   PHB_ITEM pColores   = hb_param( 3, HB_IT_ARRAY );  // array de colores. inicial= 0
   PHB_ITEM tCom = hb_param( 4, HB_IT_STRING );
   unsigned int pCode  = hb_parni( 5 );  // 1=analiza colores; 0=no; 2=latex
   
   unsigned int i=0;

   if ( pCode == 1 ){
      // busca colores
      int nSize=0,swStr=0,swChar=0;//,swBloque=0;
      char cAnt=' ';
      
      const char * pCom = hb_itemGetCPtr( tCom );
      int nLenCom=strlen(pCom);
      const char * c = hb_itemGetCPtr( pTexto );
      long uiArrayLen = strlen( c );
      for(i=0; i<uiArrayLen; i++){
         ///const char * c = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i) );
         if ( c[i] == (char)34 ){   // '"' 34
            int pPos=0;
            if ( cAnt != (char)92 && !swChar){  // "\"
               
               if (i<pIni) pPos=0; else pPos=i+1; // analizo si hay 1's y lo hago mod 2.
               hb_arraySize( pColores, ++nSize );
               hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
               swStr = !swStr;
            }
         }else if ( c[i] == (char)39  && !swStr){  // ' comilla simple
            int pPos=0;
            if ( cAnt != (char)92){  // "\"
               
               if (i <pIni) pPos=0; else pPos=i+1; // analizo si hay 1's y lo hago mod 2.
               hb_arraySize( pColores, ++nSize );
               hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
               swChar = !swChar;
            }
         }else if ( c[i] == pCom[0] ){  //'/' ){ //(char)47){  // comentario?
               if ( nLenCom > 1 ){
                 /// const char * cCom = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i+1) );
                  if ( c[i+1] == '/' ) { //(char)47){  // es un comentario de linea!!
                     if ( !swStr && !swChar ){  // está fuera de un string
                        hb_arraySize( pColores, ++nSize );
                        hb_arraySetNI( pColores, nSize, (int) ( (i+1)*(-1) ) );
                        break;  // es comentario de linea: para que seguir buscando colores?
                     }
//                  }else if ( cCom[0] == '*' ) {  // comentario de bloque
//                     if ( !swStr && !swChar ){  // está fuera de un string
//                        hb_arraySize( pColores, ++nSize );
//                        hb_arraySetNI( pColores, nSize, (HB_MAXINT) ( i*1000*(-1) ) );
//                      //  swBloque=1;
//                        // es comentario de bloque: hay que seguir buscando colores, por si se cierra
//                     }
                  }
               }else{
                  if ( !swStr && !swChar){  // está fuera de un string
                     hb_arraySize( pColores, ++nSize );
                     hb_arraySetNI( pColores, nSize, (int) ( (i+1)*(-1) ) );
                     break;  // es comentario de linea: para que seguir buscando colores?
                  }
               }
//         }else if ( c[0] == (char)42 ) { //&& swBloque ) {  // podría cerrar un comentario de bloque
//             const char * cCom = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i+1) );
//             if ( cCom[0] == (char)47 ) {   // lo cierra
//                if ( !swStr && !swChar ){  // está fuera de un string
//                    hb_arraySize( pColores, ++nSize );
//                    hb_arraySetNI( pColores, nSize, (HB_MAXINT) ( (++i)*1000 ) );
//                    swBloque=0;
//                    // es comentario de bloque: hay que seguir buscando colores, por si se cierra
//                }
//             }
         }
         cAnt = c[i];  // respaldo anterior.
      }
   }else if ( pCode == 2 ){  // colores latex
      // busca colores
      int nSize=0; //,swllave=0;
      char cAnt=' ';
      
      const char * pCom = hb_itemGetCPtr( tCom );
      const char * c = hb_itemGetCPtr( pTexto );
      long uiArrayLen = strlen( c );
      for(i=0; i<uiArrayLen; i++){
         if ( c[i] == (char)36 ){   // '$' ...
            if ( i > 0 )
               if ( c[i-1]== (char)92 ) continue;   // puede ser "\$", y eso no es una ecuacion
            
            // buscamos el siguiente "$" para cerrar.
            int swDoble=0;
            if ( c[i+1] == (char)36 ) swDoble=1; // debe buscar "$$"
            
            int pPos=0;
            pPos=i+1;
            hb_arraySize( pColores, ++nSize );
            hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
            if ( swDoble ) ++i;
            ++i;
            int swFound=0;
            while ( i<uiArrayLen ){
              if ( c[i] == (char)36 ) {
                 if ( swDoble ){
                    if ( c[i+1] == 36 ) ++i;
                 }
                 pPos=i+1;
                 hb_arraySize( pColores, ++nSize );
                 hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                 swFound=1;
                 break;
              }
              ++i;
              if ( swFound ) break;
            }
            if (i == uiArrayLen ) {  // llegó al final y no encontró "}"
               pPos=i;
               hb_arraySize( pColores, ++nSize );
               hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
               break;
            }
            
         }else if ( c[i] == (char)123 || c[i] == (char)125 ){  //... y '{' y '}'
            
            if ( i > 0 ){
               if ( c[i-1]== (char)92 ) continue;   // puede ser "\{" o "\}" y no es bloque
              /// else if ( c[i] == (char)123 && c[i+1] == (char)36 ) ++i;  // es "{$", salta segundo
              /// else if ( c[i] == (char)125 && c[i-1] == (char)36 ) ++i;  // es "$}", salta segundo
            } 
            if ( c[i] == (char)123 ) {
             //  if ( !swllave ) {  // es el primero. ver si no está dentro de un "$"
                  int pPos=0;
                  pPos=i+1;
                  hb_arraySize( pColores, ++nSize );
                  hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                  // busca "}" para cerrar:
                  ++i;
                  int swFound=0, sumPar=1;
                  while ( i<uiArrayLen ){
                     if ( c[i] == (char)123 ) ++sumPar;
                     if ( c[i] == (char)125 ){
                        if ( sumPar == 1 ){
                           pPos=i+1;
                           hb_arraySize( pColores, ++nSize );
                           hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                           swFound=1;
                           break;   // ya lo encontró
                        }else --sumPar;
                     }
                     ++i;
                     if ( swFound ) break;
                  }
                  if (i == uiArrayLen ) {  // llegó al final y no encontró "}"
                     pPos=i;
                     hb_arraySize( pColores, ++nSize );
                     hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                     break;
                  }
             //  }
            }else if ( c[i] == (char)125 ) {  // viene de antes. dejo, al menos, esta linea marcada
             //  if ( swllave == 1 ) {
                  int pPos=0;
                  pPos=1;   // marco posicion inicial
                  hb_arraySize( pColores, ++nSize );
                  hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
                  pPos=i+1;
                  hb_arraySize( pColores, ++nSize );
                  hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
             //     --swllave;
             //  } else --swllave;
            }
           
         }else if ( c[i] == pCom[0] ){  //'%' comentario?
            
            if ( i > 0 )
               if ( c[i-1]== (char)92 ) continue;   // puede ser "\%" y no es un comentario
            
            hb_arraySize( pColores, ++nSize );
            hb_arraySetNI( pColores, nSize, (int) ( (i+1)*(-1) ) );
            break;  // es comentario de linea: para que seguir buscando colores?
         }
         cAnt = c[i];  // respaldo anterior.
      }
   }

   hb_itemReturn( pColores );

}*/

HB_FUNC( N2COLOR )
{
   int iColor = hb_parnidef( 1, -1 );

   if( iColor >= 0x00 && iColor <= 0xff )
   {
      char szColorString[ 10 ];
      hb_gtColorsToString( &iColor, 1, szColorString, 10 );
      hb_retc( szColorString );
   }
   else
      hb_retc_null();
}

#pragma ENDDUMP

/*HB_FUNC( STRTONUM )
{
   PHB_ITEM pTexto      = hb_param( 1, HB_IT_ARRAY );
   
   long uiArrayLen = ( long ) hb_arrayLen( pTexto );

   PHB_ITEM pC = hb_itemArrayNew( uiArrayLen );
   unsigned int n;
   for( n=1; n<=uiArrayLen; n++){
        const char *pA = hb_itemGetCPtr( hb_itemArrayGet( pTexto, n) );
        
        hb_arraySetNInt( pC, n, (char)*pA);
   }
   hb_itemReturnRelease( pC );
} */

/*procedure BarraCompila(ARCHIVO)
   SHOWBASE:=substr(BASELINE,1,SLINEA+2)
   color:=setcolor("0/7")
   setcursor(0)
   setpos( 0,0 ); outstd( SHOWBASE )
   ARCHIVO:="..."+substr(ARCHIVO,rat(_fileSeparator,ARCHIVO),len(ARCHIVO))
   setpos( 0,1 ); outstd( " Compilando ["+ARCHIVO+"]..." )
   setcursor(1)
   setcolor(color)
return */

/*HB_FUNC( CARTOSTR )
{
   unsigned int CX    = hb_parni( 1 );
   unsigned int DX    = hb_parni( 2 );
   unsigned int pCX=0;
   
   if( CX == 9 )
      pCX=32;
   else if( CX==194){
      CX=DX;
      if( CX==161 ) pCX=173;   // inicio exclamacion
      else if( CX==191 ) pCX=168; // inicio interrogacion
      else if( CX==172 ) pCX=170; // negacion logica
      else if( CX==183 ) pCX=194; // punto sobre el 3
      else if( CX==186 ) pCX=167; // Nro
      else if( CX==170 ) pCX=166; // nda
      else pCX=0;
   }else if( CX==195 ){ 
      CX=DX;
      if( CX==167 ) pCX=135;   // ç
      else if( CX==135 ) pCX=128; // Ç
      else if( CX==161 ) pCX=160; // á
      else if( CX==169 ) pCX=130;  // é
      else if( CX==173 ) pCX=161; // í
      else if( CX==179 ) pCX=162; // ó
      else if( CX==186 ) pCX=163; // ú
      else if( CX==177 ) pCX=164; // ñ
      else if( CX==145 ) pCX=165; // Ñ
      else if( CX==164 ) pCX=132; // ä
      else if( CX==171 ) pCX=137;  // ë
      else if( CX==175 ) pCX=139;  // ï
      else if( CX==182 ) pCX=148;  // ö
      else if( CX==188 ) pCX=129;  // ü
      else if( CX==162 ) pCX=131;  // â
      else if( CX==170 ) pCX=136;  // ê
      else if( CX==174 ) pCX=140;  // î
      else if( CX==180 ) pCX=147;  // ô
      else if( CX==187 ) pCX=150;  // û
      else if( CX==160 ) pCX=133;  // à
      else if( CX==168 ) pCX=138;  // è
      else if( CX==172 ) pCX=141;  // ì
      else if( CX==178 ) pCX=149;  // ò
      else if( CX==185 ) pCX=151;  // ù
      else if( CX==155 ) pCX=219;  // ladrillo
      else pCX=0;
   }else 
      pCX=CX;
   
   hb_retni(pCX);
}*/

/*HB_FUNC( VIS_TEXTO )
{
// TEXTO,INI,TCOL,SLINEA,TOPE,TLINEA)
   PHB_ITEM pTexto      = hb_param( 1, HB_IT_ARRAY );
   unsigned int pIni    = hb_parni( 2 );
   unsigned int pTcol   = hb_parni( 3 );
   unsigned int pSLINEA = hb_parni( 4 );
   unsigned int pTOPE   = hb_parni( 5 );
   unsigned int pTLINEA = hb_parni( 6 );
            int iColor  = hb_parni( 7 );
   
   unsigned int i,j,pos;
   char *NL,*c;
   NL = (char*)malloc(sizeof(char)+1);
   NL[0]='\n';NL[1]='\0';
   c = (char*)malloc(sizeof(char)+1);
   c[0]=' '; c[1]='\0';
         
   char szColorString[ 10 ];
   hb_gtColorsToString( &iColor, 1, szColorString, 10 );
   hb_gtSetColorStr( szColorString );
      
   for (i=1; i<=pTLINEA-3; i++){
      PHB_ITEM pA = hb_itemArrayGet( pTexto, pIni );
      long uiArrayLen = ( long ) hb_arrayLen( pA );
      c[0]='|';
      hb_gtSetPos( i, 0 );hb_conOutStd( c, 1 );
      if( uiArrayLen > pSLINEA){
         uiArrayLen=pSLINEA;
      }
      pos=0;
      char * linea;
      linea = (char*)malloc(sizeof(char)*uiArrayLen+pTcol);
      for( j=1;j<=uiArrayLen+pTcol;j++) {
         strcpy(c, (char *) hb_itemGetCPtr( hb_itemArrayGet( pA, j) ) );
         if (j>=pTcol) {linea[pos++] = c[0];}
         ///linea[pos++] = c[0];  
      }
      linea[pos]='\0';
      //printf("%s\n",linea);
      hb_gtSetPos( i, 1 );
      //if( pos > 0 ) 
      hb_conOutStd( linea, pos+1 );
      //else          hb_conOutStd( " ", 1 );
      hb_xfree(linea);
      ++pIni;
      if ( pIni > pTOPE)
         break;
   }
   hb_xfree(c);hb_xfree(NL);  
}


uint16_t ftokens(const char *linea, const char *buscar, uint16_t lb) {
   const char *t,*r; // son solo punteros apuntando a la cadena s.

   uint16_t n=0;

   r = linea;  // rescato primera posición
   t = strstr(r,buscar);
   while (t!=NULL) {
      r = t + lb;
      ++n;
      t = strstr(r,buscar);
   }

   return n;
}

*/

/*
HB_FUNC( PONECOLORALAHUEA )
{
   PHB_ITEM pLista  = hb_param( 1, HB_IT_ARRAY ); // lista de comandos
   const char * pSTRING = hb_parc( 2 );  // string a procesar
   unsigned int pIni  = hb_parni( 3 );  // indice de busqueda
   
   long uiArrayLen = ( long ) hb_arrayLen( pLista );
   long nLen = strlen( pSTRING );
   unsigned int i;
   int ret=0;
   
   if (pIni<=uiArrayLen ){
      for (i=pIni;i<=uiArrayLen;i++){
         const char * pElemento = hb_itemGetCPtr( hb_itemArrayGet( pLista, i) );
         long nSubLen = strlen( pElemento );
         if( hb_strAt( pElemento, nSubLen, pSTRING, nLen ) > 0 ){
            ret=i;
            break;
         }
      }
   }
   hb_retni( ret );
}
*/
/*
HB_FUNC( LLENATEXTO )
{
   PHB_ITEM pTexto    = hb_param( 1, HB_IT_ARRAY );
   unsigned int pLen  = hb_parni( 2 );
   unsigned int pIni  = hb_parni( 3 );
   PHB_ITEM pColores   = hb_param( 4, HB_IT_ARRAY );  // array de colores. inicial= 0
   ///const char * pCom   = hb_parc( 5 );  // comentario de linea.
   PHB_ITEM tCom = hb_param( 5, HB_IT_STRING );
   unsigned int pCode  = hb_parni( 6 );  // 1=analiza colores; 0=no
   
   unsigned int i=0;
   int pos=0;
   if ( pCode == 1 ){
      // busca colores
      int nSize=0,swStr=0,swChar=0;//,swBloque=0;
      char cAnt=' ';
      long uiArrayLen = ( long ) hb_arrayLen( pTexto );
      const char * pCom = hb_itemGetCPtr( tCom );
      int nLenCom=strlen(pCom);
      
      for(i=1; i<=uiArrayLen; i++){
         const char * c = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i) );
         if ( c[0] == (char)34 ){   // '"'
            int pPos=0;
            if ( cAnt != (char)92 && !swChar){  // "\"
               ///printf("ENCONTRE en %d, ini=%d c=(%c) cAnt=(%c)\n",i,pIni,c[0],cAnt);
               if (i<pIni) pPos=0; else pPos=i; // analizo si hay 1's y lo hago mod 2.
               hb_arraySize( pColores, ++nSize );
               hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
               swStr = !swStr;
            }
         }else if ( c[0] == (char)39  && !swStr){  // ' comilla simple
            int pPos=0;
            if ( cAnt != (char)92){  // "\"
               ///printf("ENCONTRE en %d, ini=%d c=(%c) cAnt=(%c)\n",i,pIni,c[0],cAnt);
               if (i<pIni) pPos=0; else pPos=i; // analizo si hay 1's y lo hago mod 2.
               hb_arraySize( pColores, ++nSize );
               hb_arraySetNI( pColores, nSize, (HB_MAXINT) pPos );
               swChar = !swChar;
            }
         }else if ( c[0] == pCom[0] ){  //'/' ){ //(char)47){  // comentario?
               if ( nLenCom > 1 ){
                  const char * cCom = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i+1) );
                  if ( cCom[0] == '/' ) { //(char)47){  // es un comentario de linea!!
                     if ( !swStr && !swChar ){  // está fuera de un string
                        hb_arraySize( pColores, ++nSize );
                        hb_arraySetNI( pColores, nSize, (int) ( i*(-1) ) );
                        break;  // es comentario de linea: para que seguir buscando colores?
                     }
//                  }else if ( cCom[0] == '*' ) {  // comentario de bloque
//                     if ( !swStr && !swChar ){  // está fuera de un string
//                        hb_arraySize( pColores, ++nSize );
//                        hb_arraySetNI( pColores, nSize, (HB_MAXINT) ( i*1000*(-1) ) );
//                      //  swBloque=1;
//                        // es comentario de bloque: hay que seguir buscando colores, por si se cierra
//                     }
                  }
               }else{
                  if ( !swStr && !swChar){  // está fuera de un string
                     hb_arraySize( pColores, ++nSize );
                     hb_arraySetNI( pColores, nSize, (int) ( i*(-1) ) );
                     break;  // es comentario de linea: para que seguir buscando colores?
                  }
               }
//         }else if ( c[0] == (char)42 ) { //&& swBloque ) {  // podría cerrar un comentario de bloque
//             const char * cCom = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i+1) );
//             if ( cCom[0] == (char)47 ) {   // lo cierra
//                if ( !swStr && !swChar ){  // está fuera de un string
//                    hb_arraySize( pColores, ++nSize );
//                    hb_arraySetNI( pColores, nSize, (HB_MAXINT) ( (++i)*1000 ) );
//                    swBloque=0;
//                    // es comentario de bloque: hay que seguir buscando colores, por si se cierra
//                }
//             }
         }
         cAnt = c[0];  // respaldo anterior.
      }
   }
   // rellena texto
   
   char * linea;
 
   linea = (char*)calloc(pLen+1,sizeof(char));

   for( i=1;i<=pLen+pIni;i++) {
      const char * c = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i) );
      if (i>pIni) {
         linea[pos++] = c[0];
      }
   }
   linea[pos]='\0';
   
   if ( pCode == 1 ) hb_itemReturn( pColores );
   hb_retc( linea );
   free(linea);
}

*/

/*
char * FUNXSUBSTR(const char *linea, int inicio, int cuenta){
   int l = strlen(linea);
   // ajusto inicio: resto uno
   --inicio;
   if (l<inicio) return NULL;   // OJO con esto: el que reciba, debe poner ""

   char *buffer;
   buffer = (char *)calloc(cuenta+1,1);
   if (buffer == NULL) return NULL;
   strncpy(buffer, linea+inicio, cuenta);
   buffer[cuenta] = '\0';

   return buffer;
}

HB_FUNC( ASIGNALINEA )
{
   PHB_ITEM tSTRING = hb_param(1, HB_IT_STRING);
   ///const char * pSTRING = hb_parc( 1 );
   const char * pSTRING = hb_itemGetCPtr( tSTRING );
   long xlen = strlen( pSTRING );
   unsigned int i;
   int nSize=0;
   PHB_ITEM pCWM = hb_itemArrayNew( 0 );
   if(xlen>0){
      for(i=0; i<xlen;i++){ 
         hb_arraySize( pCWM, ++nSize );
         hb_arraySetC( pCWM, nSize, (char *) FUNXSUBSTR( pSTRING, i+1, 1)  );
      } 
   }else{
      hb_arraySize( pCWM, ++nSize );
      hb_arraySetC( pCWM, nSize, "" );
   }

   hb_itemReturnRelease( pCWM );
}
*/

/*
HB_FUNC( PONECOLORALAHUEA )
{
   PHB_ITEM pLista  = hb_param( 1, HB_IT_ARRAY ); // lista de comandos
   PHB_ITEM pCWM    = hb_param( 2, HB_IT_ARRAY ); // array de posiciones junto con indice de comandos
   HB_ITEM_PTR tSTRING = hb_param(3, HB_IT_STRING); //hb_parc( 3 );  // string a procesar
   
   long uiArrayLen = ( long ) hb_arrayLen( pLista );
   
   unsigned int i;
   int nSize=0;
   const char * pSTRING = hb_itemGetCPtr( tSTRING );

   for(i=1; i<=uiArrayLen;i++){  // para cada elemento de la lista
      const char * pElemento = hb_itemGetCPtr( hb_itemArrayGet( pLista, i) );
      long sLen = strlen( pElemento );
      
      const char *t,*r;
      int l;
      r = pSTRING;
      t = strstr(r,pElemento);
       
      while(t!=NULL){
       if ( ( !isalpha(*(t-1)) && !isdigit(*(t-1)) &&
            !isalpha(*(t+sLen)) && !isdigit(*(t+sLen)) ) ||
            pElemento[0]==']'||pElemento[0]=='['||pElemento[0]==')'||
            pElemento[0]=='('||pElemento[0]=='}'||pElemento[0]=='{'||
            pElemento[0]=='$'||pElemento[0]=='!'||pElemento[0]=='@'||
            pElemento[0]=='?'||pElemento[0]==':'||pElemento[0]=='|'||pElemento[0]=='&') {
         l = ( t - pSTRING ) + 1;
         
         // en vez de llenar un array, colorear de inmediato.
         
         PHB_ITEM pC  = hb_itemArrayNew( 2 );
         ++nSize; 
         hb_arraySetNI( pC, 1, (HB_MAXINT) i );  // elemento 
         hb_arraySetNI( pC, 2, (HB_MAXINT) l );  // posicion
         hb_arrayAdd( pCWM, pC );
       }
         r = t + sLen;
         t = strstr(r,pElemento);
      }
   }

   hb_itemReturn( pCWM );  // array de pociciones
   hb_retni( nSize );   // tamaño del array de posiciones  
}
*/
/*HB_FUNC( LLENATEXTO )
{
   PHB_ITEM pTexto    = hb_param( 1, HB_IT_ARRAY );
   unsigned int pLen  = hb_parni( 2 );
   unsigned int pIni  = hb_parni( 3 );

   unsigned int i=0;
   int pos=0;
   // rellena texto
 
   char * linea = (char*)calloc(pLen+1,sizeof(char));

   for( i=1;i<=pLen+pIni;i++) {
      const char * c = hb_itemGetCPtr( hb_itemArrayGet( pTexto, i) );
      if (i>pIni) {
         linea[pos++] = c[0];
      }
   }
   linea[pos]='\0';
   hb_retc( linea );
   free( linea );
   //hb_xfree(linea);
   ///hb_itemFreeC( linea );
}*/
