#include "fileio.ch"
#include "directry.ch"
//#include "simpleio.ch"

#define XCODE_CC    "000185"  // codigo familias CC

#define DIR_OFFSET  "000000"
#define STPOP       "000180"
#define RECURSIVE   "000256" //"100223"
#define ERECURSIVE  "000257" 
#define XUCODESTATIC "000063"  // declaracion de arrays estaticos hasta 2D. Mejorar
#define STRDIFF     "000020"
//
#define POP         "000231" 
#define XTOSTACK    "000205"
#define XTOVARIANT  "000206"
//
#define ELOOP       "000272" //"000186"
#define LOOP        "000273" //"000213"

#define CONS_ON     "000067"
#define FUNFIX      "000075"
#define XVTMATFILE  "000078"  // operaciones de grabacion y carga de matrices
#define CASTEO      "000157"

#define GET_ARRAY   "000081"
#define PUT_ARRAY   "000080"
#define GET_MATRIX  "000142"
#define PUT_MATRIX  "000141"
#define SET_ARRAY   "000056"
#define META_SMINMAX "000072"
#define CONFIG_ARRAY "000074"
#define RESHAPE      "000103"
#define XCODE_CCC   "000045"

#define TRSTK_CODE  "000119"
#define MATRANGE    "000122"
#define LETSTRSTK   "000016"
#define LETSTKSTK   "000055"
#define LETESPSTK   "000112"

#define GET         "000151"
#define PUT         "000152"
#define USE         "000228"
#define FPOP        "000184"
//#define      "000118"
#define XCODE2_NC   "000021"
#define ENTROPY     "000236"
#define TSTK_CODE   "000146"
#define MULTMATRIX  "000145"
#define TFSTK_CODE  "000147"
#define SORT        "000200"
///#define XXXXX     "000143"

#define GOOD_BYE    "000011"
#define STATUS      "000093"
#define OK          "000162"
#define FLUSH       "000181"
#define FIX         "000150"
#define PAUSE       "000026"
//#define FMISCD_CODE "000153"

#define OUT         "000049"
//#define OUT_OFF     "000020"

#define RKEY        "000029"
//#define     "000126"
#define SWAP        "000066"
#define LREPLICA    "000105"
#define ATTRIB      "000121"
#define FACTORIAL   "000015"
#define FUNINC      "000096"
#define FUNDEC      "000097"

#define AFINDSTK    "000123"

#define WITH        "000031"
#define WHATS_UP    "000161"
#define PAD         "000154"
#define TRY         "000159"
#define ETRY        "000158"
#define ISNEAR        "000071"
#define NEGATIVE    "000028"
#define POSITIVE    "000022"
#define ISALL       "000032"
#define IIF         "000035"
//#define  "000194"
#define ISLEAP     "000196"
//#define FMISCA_CODE "000125"

#define SIZEMAT     "000124"

#define EXCEPTIONS  "000263" //"000009"
#define TRYAGAIN    "000274" //
#define RAISE       "000219"

#define IS_EQ       "="  //"000246"
#define IS_LT       "<"  //"000245"
#define IS_GT       ">"  //"000244"
#define IS_LE       "<="  //"000243"
#define IS_GE       ">="  //"000242"
#define IS_NOT_EQ   "<>"  //"000241"
#define ARROBA      "@"  //"000240"
#define NOT         "000019"
#define IS_RANGE    "000030"

#define INC         "000098"
#define DEC         "000099"
#define INCDEC      "000218"
#define NOTVAR      "000195"
#define SECTOR      "000271" //"000217"    // ACCESS_IF
#define ESECTOR     "000270" //"000216"    // END_AREA
#define SETBIT      "000129"    //
#define GETBIT      "000130"
#define GETRANGE    "000168"
#define PUTRANGE    "000167"
//#define     "000131"
#define PROCESS     "000156"
#define SERVER      "000169"
#define RESPONSE    "000170"

#define STRREPC     "000079"

#define UNPARSER    "000039"
#define TDATE2CODE  "000190"
#define IS_RUNNING  "000187"
//#define             "000203"
#define ADDMATSTR  "000202"
#define PARSATT     "000212"
#define IS_ALIVE    "000188"

#define PARSER      "000054"
#define MATHLCM     "000210"
#define MATHGCD     "000209"
#define SUMA        "+"   //"000253"
#define RESTA       "-"   //"000252"
#define MULTI       "*"   //"000251"
#define DIV         "/"   //"000250"
#define IDIV        "\"   //"000249"
#define MODULO      "%"   //"000247"
#define POTENCIA    "^"   //"000248"

#define XMETA       "000133"
#define BIT_CODE    "000211"
#define TSTATS_CODE "000127"
#define NOTBIT      "000136"
#define ISANY       "000027"

#define MEMSTRWRITE "000082"
#define TDATECODE   "000221"
#define TIME        "000226"
#define DATE        "000224"
#define ISTIME      "000166"
//#define             "000183"
#define MNSEC       "000100"

#define DATEDIFF    "000207"
#define DATEADD     "000199"

//#define XHTRGCODE    "000192"
//#define XTMATHCODE   "000193"
//#define XMATHCODE    "000189"

#define SUBRUTINE   "000266"
#define GOSUB       "000198"
#define BACK        "000197"

#define TRGCODE     "000033"
#define HTRGCODE    "000038"
#define TMATHCODE   "000113"
#define GETGBIT     "000114"
#define MATHCODE    "000115"
#define SETGBIT     "000116"
#define MINMAXCODE  "000053"

#define STRLOAD     "000018"  
#define MASK        "000178"
//#define          "000182"
#define SHELL       "000149"
#define SHELLX      "000148"
////#define  "000076"
#define SHOWER      "000084"
#define XJOIN       "000140"
#define CONTEXT     "000085"

#define XCODE_CN    "000044"    // codigo optimizacion BASE
#define MONEY       "000172"

#define SATURA      "000171"
#define CGET        "000003"
#define SGET        "000001"
#define SPUT        "000002"
#define XTOBOOL     "000004"
#define ELSIF       "000220" // 
#define EIF         "000225" //
#define EXITIF      "000264" //
#define UNTIL       "000265" //"000004"
#define EWHILE      "000233" //"000005"
#define WHILE       "000230" //

#define POSCHAR     "000006"
#define BREAK       "000268" //"000219"
#define CONTINUE    "000269" //"000220"
#define EFWHILE     "000233" //
#define FWHILE      "000230" //
#define UNIQUE      "000007"
#define SETCODE     "000008"
#define ELSE        "000223" 
#define REPEAT      "000239"  // ponerlo en 258 chocaba con proceso que dejaba NOP a REPEAT. 
#define JT          "000010"
#define IF          "000267" //"000230"
#define JNT         "000013"
//#define JZ          "000036"
///#define XXX         "000014"
//#define XXXXXX         "000144"
#define NOP         "000040"
#define JMP         "000023"
#define JUDF        "000042"

#define WRITE       "000232"
#define TO          "000237"
#define LET         "000017"
#define DIRMEM      "000255"
#define RET         "000058"
#define ADDSTR      "000043"  // no se puede optimizar porque es usado en seccion de operandos :(
#define INTERNO     "000222"
#define ROUND       "000005"

#define STRCPY      "000092"
#define STRINS      "000086"
#define STRCHG      "000087"
#define STRCCAR     "000135"
#define STRCUT      "000111"
#define STRREP      "000083"
#define STRAT       "000061"
#define STRFIND     "000094"
#define STRTOK      "000102"
#define MMINMAX     "000101"
#define STRLIN      "000138"
#define TOKENSTRMAT "000137"

#define STRLZ       "000088"
#define GET_PAGE    "000090"
#define PUT_PAGE    "000091"
#define GET_BLOCK   "000108"
#define PUT_BLOCK   "000109"
#define SEQSP       "000095"
#define SEQUENCE    "000070"
//#define           "000175"
#define BLKCOPY     "000073"
#define XCODE_NC    "000069"
//#define           "000063"

#define XMATALTER   "000062"  // para cut y cat de matrices
#define YMATALTER   "000077"  // para ins  de matrices

#define AND         "000235"
#define OR          "000238"
#define XOR         "000128"
#define LOPERA_CODE "000060"

#define XTOSTR      "000041"
#define XTONUM      "000046"
#define ESELECT     "000277" //    // POP A FSEL
#define SELECT      "000050"     // PUSH A FSEL: FLAG DE SELECT:expresion
#define CASE        "000275"     // EVALUA CONTRA FSEL -- T O F
#define OTHERS      "000276" //"000047"     // Por DEFAULT

#define BRKGZ       "000186"  // saltos sin comparación explícita. Más rápido
#define BRKLZ       "000187"
#define BRKZ        "000036"
#define BRKNZ       "000076"
#define BRKLEZ      "000188"
#define BRKGEZ      "000189"

#define ISNAN       "000134"     
#define ISINF       "000139"

#define SUBSADDSTR       "000064"
#define SUBSSUBSTR       "000065" 
                           
#define PUSH        "000229" 
#define IFB         "100021"     // temporales
#define IFN         "100026"     //
#define IFC         "100027"     //

//#define          "000072"

#define DATASEG     "000254"

#define POPD        "000106"
#define PUSHD       "000104"
////#define JRT         "000034"
#define PUSHL       "000051"
#define POPL        "000052"
#define RPUSH       "000179"

#define POPS        "000110"
#define POPSR       "000107"
#define RETV        "000057"

#define CREATE      "000037"
#define OPEN        "000177"
#define CLOSE       "000176"
#define SEEK        "000089"
#define EOF         "000173"
#define WSTR        "000059"
#define WBIN        "000163"
#define RBIN        "000164"
#define WLINE       "000165"
#define RSTR        "000024"
#define RLINE       "000174"
#define LINECOUNT   "000201"
#define FILEEXIST   "000117"

// codigos que seran reemplazados por los codigos originales y sera aniadido un codigo OP_CODE 227
#define CODOPEMAT   "000227"   // Codigo operacion con matrices
#define CODSUBMAT   "000160"   // codigo operacion de movimiento de caracteres AC+-n|AN
#define LETADDSTK   "100001"
#define LETSUBSTK   "100002"
#define LETPMULSTK  "100003"   // multiplicacion punto a punto A * B
#define LETMMULSTK  "000222"   // multiplicacion matricial ^mul A B
#define LETDIVSTK   "100005"
#define LETIDIVSTK  "100006"
#define LETPOWSTK   "100007"
#define LETMODSTK   "100008"
// operaciones de matriz con escalar
#define LETEADDSTK  "100009"
#define LETESUBSTK  "100010"  // el orden es importante: k - A = matriz con la resta de k-A(i)
#define LETEMULSTK  "100011"  // A - k = matriz con la resta A(i)-k
#define LETEDIVSTK  "100012"  // lo mismo para las demás operaciones.
#define LETEIDIVSTK "100013"
#define LETEPOWSTK  "100014"
#define LETEMODSTK  "100015"
// operaciones logicas con matrices
#define CMPIGUSTK   "100016"
#define CMPLTSTK    "100017"
#define CMPLETSTK   "100018"
#define CMPGTSTK    "100019"
#define CMPGETSTK   "100020"
#define CMPNEQSTK   "100021"

/* operatoria AC+-n|AN, n|AN+-AC, AC*n|AN, n|AN*AC */
#define SUBSSTKADDSTR "200023"
#define SUBSSTKSUBSTR "200024"


function main()
parameters a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z

_offset:=0

Public PATH_ROOT
public PATH_BINARY
public PATH_SOURCE
public PATH_INCLUDE
public PATH_DEBUG
public PATH_TEMP
public PATH_LIB
public _fileSeparator:="/"

public _METADATA:={}
public _GET_FIX:=4
public FFFF := 0
public NULL:=""
public _DIR:=6
//public _tiempo_total_ejecucion
//Set decimals to _GET_FIX
//PUBLIC _sw_debug:=.F.
PUBLIC _sw_pre1:=.F.
PUBLIC _sw_pre2:=.F.
PUBLIC _sw_pre3:=.F.
PUBLIC _sw_exec:=.F.
PUBLIC _sw_lib:=.F.
PUBLIC _sw_retorno:=.F.
PUBLIC _sw_anulawarningretorno:=.F.
PUBLIC _sw_mensajes:=.F.
PUBLIC _file
//PUBLIC _Retorno_main
PUBLIC _SW
public _CR:=HB_OSNewline()

PUBLIC _SW_BITS:=.F.
PUBLIC _SW_DATES:=.F.
PUBLIC _SW_STRINGS:=.F.
PUBLIC _SW_MATHS:=.F.
PUBLIC _SW_TRIGS:=.F.
PUBLIC _SW_BASES:=.F.
PUBLIC _SW_SETS:=.F.
PUBLIC _SW_MATRIXS:=.F.
PUBLIC _SW_STACKS:=.F.
PUBLIC _SW_MISC:=.T.


set date italian
set century on
SETCANCEL(.T.)

set fixed off
set decimals to 16

//_tiempo_total_ejecucion:=time()

_Carga_Configuracion()    // Carga paths de compilacion

// Chequea parametros y los asigna a un array (esto queda para la ejecucion)
_argc:={"a","b","c","d","e","f","g","h","i",;
        "j","k","l","m","n","o","p","q","r",;
        "s","t","u","v","w","x","y","z"}

_argn:=0
_parametro:=NULL
/*********************************************
     argumentos
 *********************************************/
while _argn<26 .and. &(_argc[++_argn])!=nil

  _parametro:=&(_argc[_argn])

  if _parametro=="-h"
      _modo_de_uso()
      quit
  elseif _parametro=="-x"   // genera archivo ejecutable .X
      _sw_exec:=.T. 
  elseif _parametro=="-v"   // genera archivo de variables .var
      _sw_pre1:=.T.
  elseif _parametro=="-m"   // genera archivo de mapa de memoria .map
      _sw_pre2:=.T.
  elseif _parametro=="-p"   // genera preproceso
      _sw_pre3:=.T.
  elseif _parametro=="-l"   // genera libreria
      _sw_lib:=.T.
  elseif _parametro=="-sys" // devuelve un codigo
      _sw_retorno:=.T.
  elseif _parametro=="-wret"   // anula error de retorno dentro de estructura
      _sw_anulawarningretorno:=.T.
  elseif _parametro=="-verb"    // verbose: muestra mensajes de análisis.
      _sw_mensajes:=.T.
  end
end
--_argn // ajuste total de parametros

// chequea si se ingreso el nombre de archivo como minimo.
if _argn==0
    _modo_de_uso()
    outstd(_CR+"****** No has indicado un archivo para ejecutar *******"+_CR)
    quit
end

// chequea si el primer arg es un archivo
_archivo:=&(_argc[1])

if !FILE(PATH_SOURCE + _fileSeparator + _archivo)
    _modo_de_uso()
    outstd(_CR+"****** No existe el archivo indicado ******",_CR)
    quit
end

/* PARA ENGANCHE CON EDITOR */
if _sw_retorno
   color:=setcolor("7")
   setcursor(0)
   setpos( 0,0 ); outstd( REPLICATE(" ",MAXCOL()) )
   ARCHIVO:="..."+substr(_archivo,rat(_fileSeparator,_archivo),len(_archivo))
   setcolor("7/0")
   setpos( 0,1 ); outstd( " Compilando ["+upper(_archivo)+"]..." +_CR+_CR)
   setcursor(1)
   setcolor(color)
end
/*  HASTA AQUI */
//-----------------------------------------------------------------
PUBLIC _ARCHIVO_DEBUG:=_archivo
PUBLIC _lineexe,_hash,_NHASH:=0, _Cod, _Thash
PUBLIC _TFFFF:=65536        // direccion para compilacion de constantes
//PUBLIC _Archivo_Paso        // para analisis de detecta_for y saca_comentarios
PUBLIC _IniVar:=1
PUBLIC _TOP_PRG:=255
PUBLIC _UDFINI:=0, _UDFFIN:=0
PUBLIC _METHOINI:=0, _METHOFIN:=0
PUBLIC _MAININI:=0, _MAINFIN:=0

PUBLIC _METODO,_LEVEL:=22,_OUTPUT:=1,_RETURN:=9
PUBLIC DICC,_TOP:=1
PUBLIC _aMetod:={}
PUBLIC _TIPO_DE_METODO:="NORMAL"
PUBLIC _Stack_nvar:={}   // VARIABLES FANTASMAS PARA FOR EACH
_xUdf:=NULL

// carga Diccionario de instrucciones
DICC:={}
if _sw_mensajes
   _header()
   outstd(_CR+hb_UTF8tostr("Configurando Sesión..."))
end
DICC := _CargaDiccionario()
if _sw_mensajes
   outstd("[Ok]")
end

//_Archivo_Paso:={}
_lineexe:={}            // programa cargado con col para num lin fisica
_hash:={}               // variables de ejecucion
                        // (contexto,label,tipo,dato)
_Thash:={}              // Tabla temporal para constantes. seran trasladadas
                        // al final de _Hash para ordenar laejecucion con hilos.
_Cod:={}                // codigo ejecutable

PUBLIC _arch:=substr(_archivo,1,rat(".",_archivo)-1)
if _sw_mensajes
   outstd(_CR+ "Iniciando Preprocesador:")
end
_TIMESEC:=seconds()
PUBLIC tempFile:="XU_"+alltrim(str(int(hb_random()*1000000000)))+".temp"
_Carga_archivo(PATH_SOURCE+_fileSeparator+_archivo, ;
                         PATH_TEMP+_fileSeparator+tempFile)

_lineexe:=_PASO_2(PATH_TEMP+_fileSeparator+tempFile)
 
if _sw_mensajes
   outstd( "[Ok]")

   outstd(_CR+_CR +hb_UTF8tostr("Desmontando código fuente: "+_CR))
end
_Obtener_Metodo()         //obtengo nombre de metodo y modo de ejecucion

if _sw_mensajes
   outstd(_CR+ "--->Localizando objetos simples (funciones)...")
end

_Define_Hash("OBJECTS:")    // Carga los objetos globales y determina
                            // existencia de UDF's. 

if _UDFINI>0                // encontro UDF's
  _EncuentraMetodo()        // encuentra un metodo y crea sus variables locales
end

// reemplazo todas las variables globales, en principal y en todos los metodos
_laMeto:=len(_aMetod)
for i:=1 to _laMeto
   _METHOINI:=_aMetod[i][1]
   _METHOFIN:=_aMetod[i][2]

   _Reemplazo_Hash("ALGORITHM:")  // reeemplazo vars por hash
                                       // en metodo global
next

if _sw_mensajes
   outstd("[Ok]")
   outstd( _CR+hb_UTF8tostr("--->Localizando objetos complejos (Cálculos y hueás raras)..."))
end
_Reempl_Ampersand()   // por los ampersand
//_Reempl_Code()      // reemplazo menmonicos por codigo
//_QuitoEspacios()

_THASH_to_HASH()    // fusiona THash con Hash y reemplaza en el codigo
                    // las direcciones equivalentes.
                    // con esto ordeno la tabla hash y puedo tratar hilos

// anadir codigo de UDFS al final del codigo principal (despues de STOP)
_inix:=0
_finx:=0
for _j:=2 to len(_aMetod)

  if _aMetod[_j][1]>0
  
     aadd(_lineexe,{"000000",_aMetod[_j][4]})

     _inix:=len(_lineexe)+1
   //--------------------------------------------------------
     // obtengo variables del metodo que sean parametros
     _par:=0
     _t_par:=0
     vars:={}
     for _k:=1 to _NHASH
        if _hash[_k][1]==_aMetod[_j][3]
           if _hash[_k][2]!="*"  // isdigit(_hash[_k][2])      // siempre estaran en orden
              aadd(vars,{"$"+strzero(_hash[_k][6],_DIR), _hash[_k][4], _hash[_k][2]})
              // _hash...[2] tiene STRUCT="11" si es referencia...
              ++_par
           end
        end
     next
     // tiene parametros?
     // despues de que termine con los parametros, debo agregar un Op-code que
     // obligue a descargar los valores a los parametros

     _sw_par_exist:=.F.

     _Cnt_pops:=0
     while _par>0
        if len(vars[_par][3])==2              // arg. es una referencia.
           aadd(_lineexe,{POPSR+vars[_par][1],0})
           ++_t_par
        else
           _sw_par_exist:=.T.
           aadd(_lineexe,{POPS+vars[_par][1],0})  // argumento es por valor
           ++_Cnt_pops
        end
        --_par
     end
     if _sw_par_exist             // existe parametro y es normal (POPS)?
        for _k:=1 to _Cnt_pops
           aadd(_lineexe,{STPOP,0})  // agrego STPOP!!
        next
     end
     
   //--------------------------------------------------------
     if (_Cnt_pops+_t_par) > 0     // debo indicar esto para reconocimiento en ejecucion
        // agregar el total a VARS si no existe, para que sea direccionable
        _LHash:=len(_hash)
        _sw_match_par:=.F.
        for _i:=1 to _LHash
           if _hash[_i][5]=="*"     // es una constante??
              if _hash[_i][4]=="N"
                 if _t_par==val(_hash[_i][3])
                    _sw_match_par:=.T.
                    aadd(_lineexe,{RPUSH+"$"+strzero(_hash[_i][6],_DIR),0})
                    exit                                                    //   15/11/2010: solo hace falta un RPUSH?????
                 end
              end
           end
        next
        if !_sw_match_par
           // agrego la nueva constante
           _nueva_direccion:=_hash[len(_hash)][6]+1
           aadd(_hash,{"local","*",alltrim(str(_t_par)),"N","*",;
                       _nueva_direccion,"local"})
           ++_NHASH
           aadd(_lineexe,{RPUSH+"$"+strzero(_nueva_direccion,_DIR),0})
        end
     end   // si es 0 no hay referencias, y no cuelgo el stack para referencias
          // intermedias!!!
   //--------------------------------------------------------

     for _i:=_aMetod[_j][1] to _aMetod[_j][2]
       aadd(_lineexe,{_lineexe[_i][1],_lineexe[_i][2]})
     next
     _finx:=len(_lineexe)

     aadd(_lineexe,{"111111",_aMetod[_j][4]})

     _aMetod[_j][1]:=_inix
     _aMetod[_j][2]:=_finx
  end
next

if _sw_mensajes
   outstd("[Ok]")
   if _sw_exec .or. _sw_pre1 .or. _sw_pre2 .or. _sw_pre3 .or. _sw_lib
      outstd( _CR+_CR+"Generando archivos:"+_CR)
   end
end


if _sw_pre1
  _GenPRE1(PATH_DEBUG+_fileSeparator+_arch+".var")
end // _sw_pre1


// reemplazar direcciones en programa final
PUBLIC _dirMet:={}   // dejo direcciones que posteriormente seran reemplazadas
_cod:=_Convertir_a_Code() //(_sw_debug)    // cuerpo principal

for _k:=1 to len(_dirMet)
  for _y:=1 to len(_aMetod)
     if _aMetod[_y][4]==_dirmet[_k][2]
        _cod[_dirmet[_k][1]][2]:=strzero(_aMetod[_y][1],_DIR)
        exit
     end
  next 
next

// Verificar si hay llamadas redundantes ciclicamente

_VerificaRedundancia(_dirMet)

// reemplazar codigo de UDF por NOP
for _k:=1 to len(_aMetod)
  for _y:=1 to len(_cod)
     if _cod[_y][2]==_aMetod[_k][4]
        // es un codigo de UDF????

        if _cod[_y-1][2]!="000104"  // marca para UDF
           _Tempv:=_cod[_y+1][2]
           if _Tempv!=JMP.and._Tempv!=JT.and._Tempv!=JNT  // podrÃ­an ser los otros J...
              _cod[_y][2]:=NOP
           end
        end
     end
  next
next

// respaldo _COD antes de que entre a ser normalizado. AsÃ­ chequeo consistencias y
// almaceno cÃ³digo ejecutable y la concha de la lora!!!
//Public _XTCod:=ACLONE(_Cod)

if _sw_pre2
  _GenPRE2(PATH_DEBUG+_fileSeparator+_arch+".map", _cod)
end   

_cnt_byte:=0
if _sw_exec
//  _cnt_byte:=_GenEXEC(PATH_BINARY+_fileSeparator+_arch+"x",_cod)
  _cnt_byte:=_GenEXEC(PATH_BINARY+_fileSeparator+_arch,_cod)

end    // _sw_exec

if _sw_lib
   _GenLIB(PATH_LIB+_fileSeparator+_arch+".lib",PATH_TEMP+_fileSeparator+tempFile)
end

if _sw_pre3
   FILECOPY(PATH_TEMP+_fileSeparator+tempFile, PATH_DEBUG+_fileSeparator+_arch+".xpre")
end

if ferase(PATH_TEMP+_fileSeparator+tempFile)!=0
   setcolor("0/6")
   outstd(_CR+ hb_utf8tostr("Guarning: No fue posible eliminar el archivo temporal"+_CR))
   setcolor("")
end

SW_MSGEDITOR:=iif(_cnt_byte>0,.T.,.F.)
if _sw_mensajes
   
   outstd(_CR+"Tiempo de proceso: ",alltrim(str(seconds()-_TIMESEC)), " seg."+_CR)
   if _cnt_byte>0 
      outstd( "Binario "+_arch+" creado satisfactoriamente, ")
      outstd( alltrim(str(_cnt_Byte/1024)) + " Kb"+_CR)
      
   elseif _sw_pre1 .or. _sw_pre2 .or. _sw_pre3
      outstd(_CR+_CR+ "*** Solo se han generado archivos para debugeo."+_CR)
   elseif _sw_lib
      outstd( _CR+hb_utf8tostr("Librería "+_arch+".lib creada satisfactoriamente."+_CR))
   end
   if !_sw_exec
      outstd( _CR+hb_UTF8tostr("Análisis de "+_arch+" terminado satisfactoriamente,"+_CR))
   
      outstd( hb_UTF8tostr(" **** No se ha generado código ejecutable ****" +_CR))
   end
else
   if SW_MSGEDITOR
      if _sw_retorno
         outstd( "Binario "+upper(_arch)+" creado satisfactoriamente, ")
         outstd( alltrim(str(_cnt_Byte/1024)) + " Kb"+_CR)
         outstd(_CR+"Tiempo de proceso: ",alltrim(str(seconds()-_TIMESEC)), " seg."+_CR+_CR)

      end
   elseif _sw_lib
      if _sw_retorno
         outstd( _CR+hb_utf8tostr("Librería "+_arch+".lib creada satisfactoriamente."+_CR))
         outstd(_CR+"Tiempo de proceso: ",alltrim(str(seconds()-_TIMESEC)), " seg."+_CR+_CR)
      end
   elseif _sw_pre1 .or. _sw_pre2 .or. _sw_pre3
      if _sw_retorno
         outstd(_CR+_CR+ "*** Solo se han generado archivos para debugeo."+_CR)
         outstd(_CR+"Tiempo de proceso: ",alltrim(str(seconds()-_TIMESEC)), " seg."+_CR+_CR)
      end
   end
end

/*******************************************/

/********************************************/
return nil

procedure _THASH_to_HASH()
local i, j, lenTHASH, lenHASH, dirTemp, lenLE, dirNueva

lenTHASH:=len(_Thash)
lenHASH:=len(_hash)
lenLE:=len(_lineexe)

for i:=1 to lenTHASH

  // obtengo direcion temporal de Thash
  dirTemp:=strzero(_Thash[i][6],_DIR)

  // redefino direccion
  _Thash[i][6]:=_hash[lenHASH][6]+1

  /*** CREO ESPACIO EN HASH.
       RAZON: Si no declaro variables, tendré problemas
       en la MV y no voy a cambiar el código de carga.
       ***/
  aadd (_hash,{NULL,NULL,NULL,NULL,NULL,0,NULL})
  ++lenHASH

  // copio resto de datos
  _hash[lenHASH][1] := _Thash[i][1]
  _hash[lenHASH][2] := _Thash[i][2]
  _hash[lenHASH][3] := _Thash[i][3]
  _hash[lenHASH][4] := _Thash[i][4]
  _hash[lenHASH][5] := _Thash[i][5]
  _hash[lenHASH][6] := _Thash[i][6]
  _hash[lenHASH][7] := _Thash[i][7]

  dirNueva:=strzero(_hash[lenHASH][6],_DIR)

  // actualizo direccion temporal por nueva direccion
  for j:=1 to lenLE
     _lineexe[j][1]:=strtran(_lineexe[j][1], dirTemp, dirNueva)
  next


next

// actualizo tamano de Hash
_NHASH:=lenHASH

return nil

procedure _VerificaRedundancia(dirs)
// la primera posicion de _aMetod guarda el cuerpo main
// dirs guarda origen y destino de llamadas

local _pila:=stacknew()
local _k,_l,_so,_sd

// llenar la pila con ORIGEN y DESTINO
for _k:=1 to len(dirs)
   for _l:=2 to len(_aMetod)

      if dirs[_k][1]>=_aMetod[_l][1] .and. dirs[_k][1]<=_aMetod[_l][2]
         stackpush(_pila,_aMetod[_l][4])
         stackpush(_pila,dirs[_k][2])
      end
   next
next
// deteccion de llamada ciclica.

// chequeo de flag recursividad:
if len(_pila)>=2
   if _pila[1]==_pila[2]
      if _LEVEL!=23      // no esta seteado como recursivo, mandar un warning
         outstd(_CR)
         setcolor("0/6")
         outstd("*** Guarning ***"+_CR)
         outstd(hb_UTF8tostr("Se detectó una posible llamada recursiva sin configurar MEMORY.")+_CR)
         outstd("Se ha configurado internamente."+_CR)
         setcolor("")
         _LEVEL:=23
      end
   end
end


while len(_pila)>2  
   DESTINO:=stackpop(_pila)
   ORIGEN:=stackpop(_pila)

   for _l:= len(_pila) to 1 step -2
      if _pila[_l]==ORIGEN
         if _pila[_l-1]==DESTINO
            // error: busco los nombres de los UDF ciclicos
            
            for _m:=2 to len(_aMetod)
               if _aMetod[_m][4]==ORIGEN
                  _so:=_aMetod[_m][3]
               end
               if _aMetod[_m][4]==DESTINO
                  _sd:=_aMetod[_m][3]
               end
            next
            if upper(alltrim(_so))!=upper(alltrim(_sd))
               _Error ("Error: Las funciones ["+_so+"] y ["+_sd+"] causan un problema de referencia cíclica",0)
            end
         end
      end
   next
end

return


function _GenEXEC(_arch,_cod)
local _h,_cnt_Byte:=0,_i,_Offset,_j,_c,_cad,_direcc,_ModDir,_DivDir
local _quinto,_mem, _sw_offset

  /************************************************
   construo el programa ejecutable
   OJO: podria ser la llamada a la ejecucion
  
   ************************************************/
   if _sw_mensajes
      outstd( _CR+"Generando "+ _arch+"...")
   end
  _h:=fcreate(_arch)

  _cnt_Byte:=0
  // guardo direccion inicial de memoria
  
  // guardo encabezado: identifica que se trata de un programa XU
  fwrite(_h,i2bin(asc("F")),1) ;++_cnt_Byte   // Fernandita
  fwrite(_h,i2bin(asc("B")),1) ;++_cnt_Byte   // Benjamin
  fwrite(_h,i2bin(asc("I")),1) ;++_cnt_Byte   // Mamita Irma

  _mem:=2    // es normal

  fwrite(_h,i2bin(_mem),1)  ;++_cnt_Byte // nivel
  fwrite(_h,i2bin(_LEVEL),1)  ;++_cnt_Byte // nivel
  fwrite(_h,i2bin(_OUTPUT),1) ;++_cnt_Byte // nivel
  fwrite(_h,i2bin(_RETURN),1) ;++_cnt_Byte // nivel
  for _i:=1 to len(_METODO)
     _cad:=substr(_METODO,_i,1)
     fwrite(_h,i2bin(asc(_cad)),1) ;++_cnt_Byte
  next

  fwrite(_h,i2bin(255),1) ;++_cnt_Byte  // separador


  // guarda total de objetos vars y constantes detectados

  // definir un codigo que indique si hay mas de 255 objetos o menos.
  // guardar antes del valor indicado.
  if _NHASH>=255
      fwrite(_h,i2bin(2),1) ;++_cnt_Byte   // codigo
      _direcc:=_NHASH
      while _direcc>=255   // hay que guardar offset
         _ModDir:=_direcc%255   //
         fwrite (_h,I2Bin(_ModDir),1) ;++_cnt_Byte
         _direcc:=int(_direcc/255)
      end
      fwrite (_h,I2Bin(_direcc),1) ;++_cnt_Byte   // p.p. calculo
  else     // hay menos de 255 objetos de memoria
      fwrite(_h,i2bin(3),1) ;++_cnt_Byte
      fwrite(_h,i2bin(_NHASH),1) ;++_cnt_Byte
  end

  fwrite(_h,i2bin(255),1) ;++_cnt_Byte  // separador

  // guardo segmento de datos: identificar vars de const
  for _i:=_IniVar to _NHASH //_FinVar

    _code_tip:= iif(_hash[_i][4]=="N",15,;
                  iif(_hash[_i][4]=="F",26,;
                    iif(_hash[_i][4]=="C",16,;
                     iif(_hash[_i][4]=="T",17,;   /* obsoleto */
                      iif(_hash[_i][4]=="L",18,;
                       iif(_hash[_i][4]=="AN",21,;
                        iif(_hash[_i][4]=="AC",22,;
                         iif(_hash[_i][4]=="AL",23,24 ) )))))) )

    if _hash[_i][5]=="*"   // es constante
       fwrite(_h,i2bin(4),1)  ;++_cnt_Byte    // code_const
       fwrite(_h,i2bin(_code_tip),1)  ;++_cnt_Byte
       _ncad:=len(_hash[_i][3])
       _cad:=_hash[_i][3]
/*       if _code_tip==16
          if "cHar012ComilLas" $ _cad
             _cad:=strtran(_cad,"cHar012ComilLas",'"')
          end
       end */

       for _j:=1 to _ncad           // guardo el contenido
          c:=asc(substr(_cad,_j,1))
          // variable
          fwrite (_h,I2Bin(c),1) ;++_cnt_Byte
       next
    else                    // es variable
       fwrite(_h,i2bin(3),1)  ;++_cnt_Byte    // code_vars
       // verificar si es parametro
       if es_entero(_hash[_i][2])
          // verificar si es doble por referencia: eliminar ultimo digito
          if len(_hash[_i][2])==2
             _hash[_i][2]:=substr(_hash[_i][2],1,1)
          end
          //
          fwrite (_h,I2Bin(1),1) ;++_cnt_Byte
          fwrite (_h,I2Bin(val(_hash[_i][2])),1) ;++_cnt_Byte
          ////? "PARAM, POS PAR=",_hash[_i][2]
       else
          fwrite (_h,I2Bin(0),1) ;++_cnt_Byte
       end
       fwrite(_h,i2bin(_code_tip),1)  ;++_cnt_Byte   // guardo el tipo

       //poner direccion de pertenencia:
       //
       // _hash[_i][7] = nombre de udf
       // _aMetod[_k][1]= desde
       // _aMetod[_k][2]= hasta
       // _aMetod[_k][3]= nombre de udf
       // hay que guardar con calculo de offset
       //
       for _j:=1 to len(_aMetod)
         if _aMetod[_j][3]==_hash[_i][7]
            
            _direcc:=_aMetod[_j][1]     // direccion de inicio de UDF

            fwrite(_h,i2bin(5),1) ;++_cnt_Byte   //codigo de lim. de direccion
            while _direcc>=255   // hay que guardar offset: las direcciones estan sobre 255
               _ModDir:=_direcc%255   //
               fwrite (_h,I2Bin(_ModDir),1) ;++_cnt_Byte
               _direcc:=int(_direcc/255)
            end
            fwrite (_h,I2Bin(_direcc),1) ;++_cnt_Byte   // p.p. calculo

            fwrite(_h,i2bin(5),1) ;++_cnt_Byte

            _direcc:=_aMetod[_j][2]     // direccion FINAL de UDF
            while _direcc>=255   // hay que guardar offset
               _ModDir:=_direcc%255   //
               fwrite (_h,I2Bin(_ModDir),1) ;++_cnt_Byte
               _direcc:=int(_direcc/255)
            end
            fwrite (_h,I2Bin(_direcc),1) ;++_cnt_Byte   // p.p. calculo

            fwrite(_h,i2bin(5),1) ;++_cnt_Byte
         end
       next

       // hasta aqui agregado. chequear con el ejecutor si cargo bien las
       // direcciones. Si cargo bien, podremos hablar de hilos o lo que
       // quiera por la puta madre y la concha de la lora!!!!!

    end

    fwrite(_h,i2bin(255),1) ;++_cnt_Byte
  next
  
  fwrite(_h,i2bin(255),1) ;++_cnt_Byte


  // guardo segmento de programa
  for _i:=_TOP_PRG to len(_cod)          // anbtes iniciaba en "1"
  //   _OffSet:=.F.

     if _cod[_i][2]=="FFF"
         ?" ALERTA: se paso un FFF!"
         inkey(0)
     end

//
     if _cod[_i][2]=="$"
        _cod[_i][2]:="000254"   // instruccion
     elseif _cod[_i][2]=="+"
        _cod[_i][2]:="000253"
     elseif _cod[_i][2]=="-"
        _cod[_i][2]:="000252"
     elseif _cod[_i][2]=="*"
        _cod[_i][2]:="000251"
     elseif _cod[_i][2]=="/"
        _cod[_i][2]:="000250"
     elseif _cod[_i][2]=="\"
        _cod[_i][2]:="000249"
     elseif _cod[_i][2]=="^"
        _cod[_i][2]:="000248"
     elseif _cod[_i][2]=="%"
        _cod[_i][2]:="000247"
     elseif _cod[_i][2]=="="
        _cod[_i][2]:="000246"
     elseif _cod[_i][2]=="<"
        _cod[_i][2]:="000245"
     elseif _cod[_i][2]==">"
        _cod[_i][2]:="000244"
     elseif _cod[_i][2]=="<="
        _cod[_i][2]:="000243"
     elseif _cod[_i][2]==">="
        _cod[_i][2]:="000242"
     elseif _cod[_i][2]=="<>"
        _cod[_i][2]:="000241"
     elseif _cod[_i][2]=="@"    
        _cod[_i][2]:="000240"
     elseif _cod[_i][2]=="!"
        _cod[_i][2]:="000012"
     end
//
     _offset:=val(_cod[_i][2])

     if _offset>FFFF
         _offset:=_offset-FFFF
         _cod[_i][2]:=padl(_offset,6,"0")
     end

     _sw_offset:=.F.

     //la siguiente puede ser una direccion de salto de programa o de memoria
     // se debe indicar que se trata de una direccion binaria para efectuar
     // la recuperacion de la memoria original. Esto es solo para el proceso
     // de carga, no ejecucion.
     _direcc:=val(_cod[_i][2])
     if _direcc>=255
        _sw_offset:=.T.
        fwrite (_h,I2Bin(0),1) ;++_cnt_Byte  // codigo offset inicio
        while _direcc>=255                   // hay que guardar offset
            _ModDir:=_direcc%255   //
            fwrite (_h,I2Bin(_ModDir),1) ;++_cnt_Byte
            _direcc:=int(_direcc/255)
        end
        fwrite (_h,I2Bin(_direcc),1) ;++_cnt_Byte   // p.p. calculo

        fwrite (_h,I2Bin(0),1) ;++_cnt_Byte  // codigo offset fin
     end

     _cod[_i][2]:=val(_cod[_i][2])

     if !_sw_offset
         fwrite (_h,I2Bin(_cod[_i][2]),1) ;++_cnt_Byte
     end
     
  next
  fclose(_h)
  if _sw_mensajes
     ?? "[Ok]"
  end

return _cnt_Byte

procedure _GenPRE2(_arch,_cod)
local _file,_i
local j,_offset,_sw_offset,_cuenta,_anterior,f1,f2

  _file:=_arch

  if _sw_mensajes
     outstd( _CR+"Generando "+ _file+"...")
  end
  debug_on (_file)
  ? "Tamano Programa (lineas)= ";??len(_cod)
  ? "---LF---:--DIR--:-DATOS/SERVICIOS-"

  // carga segmento de programa
  for _i:=_TOP_PRG to len(_cod)                  // antes parte de "1"
    //--------------------------------
     ?"[";??padl(_cod[_i][3],5,"0");??"] : "
     
     _sw_offset:=.F.
     _cuenta:=0
     _anterior:=NULL
    

     if es_entero(_cod[_i][2])
        _offset:=val(_cod[_i][2])

        if _i>_TOP_PRG            // esto hace qye el programa final se achique.
          if _cod[_i-1][2]=="$"
              _offset:=_offset-FFFF
              _cod[_i][2]:=padl(_offset,6,"0")
              if _offset<255
                 ?? padl(_cod[_i][1],5,"0");??" : ";??padl(_cod[_i][2],6,"0")
              end
              _sw_offset:=.T.
          end
        end  

        if _offset>=255
           ?? padl(_cod[_i][1],5,"0");??" : ";??padl(DIR_OFFSET,6,"0")
           
           ??" (SEGMENT) (DIR=";??padl(_cod[_i][2],6,"0");??")"
          
           while _offset>=255
              ++_cuenta
              f1:=int(_offset%255)
              f2:=int(_offset/255)
              ?"[";??padl(_cod[_i][3],5,"0");??"] : "
              ?? "----- : ";?? padl(f1,6,"0")
              if _cuenta%2==0
                ??" (DIR = FFF x DIR + ";?? padl(_anterior,6,"0");??")"
              end
              _anterior:=f1
              _offset:=f2
           end
           ?"[";??padl(_cod[_i][3],5,"0");??"] : "
           ?? "----- : ";?? padl(f2,6,"0")
           ?? " (DIR = FFF x ";?? padl(f2,6,"0");??" + ";??padl(f1,6,"0");??")"
           ?"[";??padl(_cod[_i][3],5,"0");??"] : "
           //?? "----- : ";?? padl(239,6,"0")
           ?? "----- : ";?? padl(0,6,"0")
           _sw_offset:=.T.
        end
     end
    
   //---------------------------------

     if _cod[_i][2]=="000000"      // no permite
         _sw_offset:=.T.
         ?? padl(_cod[_i][1],5,"0");??" : ";??_cod[_i][2]; ??" (NOP)"
     end

     if !_sw_offset
        ?? padl(_cod[_i][1],5,"0")
        ?? " : "
        if _i>_TOP_PRG      // antes "1" 
           if _cod[_i-1][2]!="$".and. _cod[_i][2]!="$"   // _i-1
             
             if _cod[_i][2]=="+"
                ?? "000253 (ADD)"
             elseif _cod[_i][2]=="-"
                ?? "000252 (SUB)"
             elseif _cod[_i][2]=="*"
                ?? "000251 (MUL)"
             elseif _cod[_i][2]=="/"
                ?? "000250 (DIV)"
             elseif _cod[_i][2]=="\"
                ?? "000249 (IDIV)"
             elseif _cod[_i][2]=="^"
                ?? "000248 (POW)"
             elseif _cod[_i][2]=="%"
                ?? "000247 (MOD)"
             elseif _cod[_i][2]=="="
                ?? "000246 (IS_EQ)"
             elseif _cod[_i][2]=="<"
                ?? "000245 (IS_LT)"
             elseif _cod[_i][2]==">"
                ?? "000244 (IS_GT)"
             elseif _cod[_i][2]=="<="
                ?? "000243 (IS_LE)"
             elseif _cod[_i][2]==">="
                ?? "000242 (IS_GE)"
             elseif _cod[_i][2]=="<>"
                ?? "000241 (IS_NE)"
             elseif _cod[_i][2]=="@"
                ?? "000240 (IS_IN)"
             elseif _cod[_i][2]=="!"
                ?? "000012 (FACTORIAL)"
             else
                ?? _cod[_i][2]

                if _i==len(_cod) 
                   //??" (END)"
                   ??" (";??upper(DICC[val(_cod[_i][2])][1]);??")"
                else
                   if val(_cod[_i][2])<255
                       if _cod[_i-1][2]!="$" .and. ;
                           _cod[_i+1][2]!=JMP .and.;
                           _cod[_i+1][2]!=JNT .and.;
                           _cod[_i+1][2]!=JT .and.;
                           _cod[_i-1][2]!=NOP .or.;
                           _cod[_i][2]==PUSHD
                            ??" (";??upper(DICC[val(_cod[_i][2])][1]);??")"
                       end
  //                           _cod[_i+1][2]!=JZ .and.;
  //                         _cod[_i+1][2]!=JRT .and.;

                   end

                end
             end
           else
             if _cod[_i][2]=="$"
               ?? "000254 (PUSHS-DATA ADDRESS)" // (#";??_cod[_i+1][2];??"->.STACK)"   //
             else
               ?? _cod[_i][2]    //;??" (DATA)"
             end
           end
        else
           if _cod[_i][2]=="$"
              ?? "000254 (PUSHS-DATA ADDRESS)" // (#";??_cod[_i+1][2];??"->.STACK)"   //
           else
             // ? "LINEA: ";?? _i; inkey(0)
              ?? _cod[_i][2];??" (";??upper(DICC[val(_cod[_i][2])][1]);??")"
           end
        end
     end

  next

  debug_off()
  
  if _sw_mensajes
     outstd( "[Ok]")
  end

return

procedure _GenPRE1(_arch)
local _file,_i

  _file:=_arch
  if _sw_mensajes
     outstd(_CR+ "Generando "+_file+"...")
  end
  debug_on(_file)

  ? "Variables y constantes encontradas..."

  for _i:=_IniVar to _NHASH //_FinVar
    ? "$"+strzero(_i,_DIR);??":$";??strzero(_hash[_i][6],_DIR);??" ";??_hash[_i][1];??",";??_hash[_i][2];??",";??_hash[_i][3];??",";??_hash[_i][4];??",";??_hash[_i][5];??" , Tipo: ";??_hash[_i][7]
  next 

  debug_off()

  if _sw_mensajes
     outstd( "[Ok]")
  end

return

procedure DEBUG_ON(archivo_log)

set printer to &archivo_log   //debug.log
set printer on
set console off

return

procedure DEBUG_OFF()

set printer off
set console on

return

Procedure _Error(bajada,linea)
local fp

  debug_off()
  outstd(_CR+replicate("*",len(bajada)+2))
  setcolor("15/4")
  outstd(_CR+ hb_UTF8tostr(upper(strtran(bajada,"Error","lapsus",1))))
  setcolor("")
  outstd(_CR+replicate("*",len(bajada)+2)  )
  outstd(_CR+ "Programa  = "+upper(_ARCHIVO_DEBUG) )
  outstd(_CR+ "Fecha del 8=D~ : "+dtoc(date())+", "+time() )

  _fuente:=PATH_SOURCE+_fileSeparator+substr(_ARCHIVO_DEBUG,1,at(".",_ARCHIVO_DEBUG))+"xu"
  
  _vnum:= linea //val(_numbusca) 
  if valtype(_vnum)!="N"
     _vnum:=val(_vnum)
     linea:=_vnum
  end
  if linea!=0  
     outstd(_CR+_CR+"Lugar del lapsus en [",_fuente,"]:" )
     if file(_fuente)
         // cargo programa fuente, si existe
         if file(_fuente) 
            _v:=Memoread(_fuente)
            outstd(_CR+"          :")
            for _j:=_vnum-3 to _vnum+3
               _linea:=rtrim(Memoline(_v,1600,_j))
               if AT("//",_linea)>0 
                  _linea:=substr(_linea,1,at("//",_linea)-1)
               end
               if AT("/*",_linea)>0 
                  _linea:=substr(_linea,1,at("/*",_linea)-1)
               end
               if _j==_vnum
                  setcolor("15/2")
                  outstd(_CR+hb_UTF8tostr(strzero(linea,5)+" >>>"+_linea+"  <<<"))
                  setcolor("")
               else
                  outstd(_CR+hb_UTF8tostr("         "+_linea ))
               end
            end
            outstd(_CR+"          :")
            //break
         end
     end 
  end
  
  AEVAL(DIRECTORY(PATH_TEMP+_fileSeparator+"*.temp"), { |aFile| ;
      FERASE(PATH_TEMP+_fileSeparator+aFile[F_NAME]) })
      //outstd(PATH_TEMP+_fileSeparator+aFile[F_NAME]+_CR) })

  RELEASE ALL
  
  fp:=fcreate(PATH_TEMP+_fileSeparator+"err_xu_compi.tmp")
  fclose(fp)
//  outstd( "Presione una tecla para continuar...")
  
//  inkey(0)
  QUIT

return

function _Convertir_a_Code() //(_sw_debug)
local i,j,k,m,_nl,_v,_l,_tl, _k,paso,_flag,_nType,_iType,_fl,_nTypel
local q:={}, pila:={}, p:={}
local q1:={},q2:={},p1:={}          // para codigo UDF incrustado
local arr:={}
local stk_module:={}
local code, dir, vdir, _t, old_code
local e_dir,f_dir,sw_else_if
local t_line:=0   // guarda la dir inicial para expres. de ciclos
local t_orden:=0
local stk:={},stk_len:=0,s1,s2,_vLET:=NULL,_vCODE:=NULL,_vIN:=NULL,_vINSTR:=NULL
local _flg024:=.F.    // flag para funcion 024  is_in
local _flg_ret:=.F.,_retorno:=NULL,_last_type:=NULL

local _sel_nivel:=0, stk_sel:={},stk_selthank:={},stk_selcase:={}
local _sw_case:=.F.,_sw_inicio_case:=.F.

local stk_use:=stacknew()
local _sw_read , ndx_debug:=0
local _sw_udf:=.F.,_ptr_udf:=0,_sw_emethod:=.F.,_varmet,_Metodo_leado:=NULL
local stk_try:={},stk_exception:={}
//local SW_THREAD
//local SW_CONSOLE:=.T., SW_OUT:=.F.
local SW_RECURSIVE:=.F.

local AXBUCLE:=stacknew(),AXEXITBUCLE:=stacknew(),AXCASE:=stacknew()
local AXIF:=stacknew(),BXIF:=stacknew()
local _DIRIF:=stacknew(),_DIRWHILE:=stacknew(),_DIRCASE:=stacknew(),_DIRDO:=stacknew(),DIRLOOP:=stacknew()
local _DIRSECTOR:=stacknew(),_DIRLOOP:=stacknew(),_DIRTRY:=stacknew()
local _sw_others:=.F.,SW_IFEXPANSION:=.F.
local AXIDSUB:=stacknew(); AXDIRSUB:=stacknew()


   // obtengo flag de retorno: obsoleto
   _retorno:=iif(_RETURN==9,"_",;
               iif(_RETURN==10,"N",;
                  iif(_RETURN==11,"C",;
                     iif(_RETURN==12,"L","A"))))

   dir:=_TOP_PRG            // deja los primeros libres por choque de
                               // codigo de instrucciones
   // llena lineas en blanco
   for i:=1 to 254
      aadd(arr,{NULL,NULL,NULL})
   next

   _nl:=len(_lineexe)   // el total, incluso con codigo de USE
   
/*   for hk:=1 to _nl
      ?_lineexe[hk][2],":",_lineexe[hk][1]
   end
*/     
   _ptr_udf:=1

   old_code:=NULL
   SW_THREAD:=.F.

   for i:=_aMetod[_ptr_udf][1] to _nl
      
      _v:=alltrim(_lineexe[i][1])  // linea de codigo 

      _l:=_lineexe[i][2]           // numero de linea para debug
      // procesa linea: convierte expresion a notacion polaca

      code:=substr(_v,1,_DIR)   // ex-3 codigo operacion queda excluido
      if !isdigit(substr(code,1,1)).or. ;
         !isdigit(substr(code,2,1)).or. ;
         !isdigit(substr(code,3,1)).or. ;
         !isdigit(substr(code,4,1)).or. ;
         !isdigit(substr(code,5,1)).or. ;
         !isdigit(substr(code,6,1))

         _Error ("Error: Instrucción no válida (o esto no va aquí) ["+code+"]",_l)
      end

      if code!=_v     // no es una instruccion simple: debe ser procesada
         _v:=substr(_v,_DIR+1,len(_v))  // 4,...resto de la cadena
         q:={}; pila:={}; p:={}

         q:=_LlenaPila(_v,_l,code)   // separa direcciones y las deja en "Q"

         // ciclo para evaluar por partes
         aadd(pila,"(")              // pila de simbolos temporal
         
     /*    if _l==471    //code=RET  //DATEDIFF//SELECT.or.code==IF.or.code==FWHILE // solo para debugeo
         ? "COla: ",code
         for _chucha:=1 to len(q)
            ?? q[_chucha],":"
         end
         end */
         _EvPolaca(@q,@pila,@p,_l,code)    // expresion queda en "P"
      /*   if _l==471   //code=RET   //DATEDIFF//SELECT.or.code==IF.or.code==FWHILE // solo para debugeo
         ? "COla: ",code
         for _chucha:=1 to len(p)
            ?? p[_chucha],":"
         end
         end  */
         _sw_read:=.F.
         if code==SWAP .or. code==TO
            _sw_read:=.T.
         end
      elseif code=="000000"        // inicio de UDF
         code:=NOP
         // capturar nuevos limites de esta udf.
         ++_ptr_udf
         _aMetod[_ptr_udf][1]:=len(arr)+2   // ajuste por el NOP
         _Metodo_leado:=_aMetod[_ptr_udf][3]
         // almacenar las variables del metodo huesped
         // sirve para agregar los PUSHL y POPL
         _varmet:={}
         for _meca:=1 to _NHASH
            if _Metodo_leado==_hash[_meca][1]
               if _hash[_meca][5]!="*"
                  aadd(_varmet,{_hash[_meca][6],_hash[_meca][4]})
               end
            end
         next
         _Metodo_leado:=_aMetod[_ptr_udf][4]   // rescato el numero

         // obtengo el retorno de esta funcion
         _retorno:=_aMetod[_ptr_udf][5]

      elseif code=="111111"        // fin de udf
         code:=RETV
         _sw_udf:=.T.
      elseif code=="000025"
         _sw_emethod:=.T.
         _aMetod[1][1]:=255
         _aMetod[1][2]:=len(arr)
      end

      aadd ( p,code)  // meto codigo en pila de evaluacion

      // traspaso y evaluacion semantica
      _SW_SELPILA:=.F.

      _len_p:=len(p)  // para EVAL y lista
      _v:=SDC(p)

      t_line:=dir     // direccion de inicio de expresion

      _flag:=NULL

      _iType:=NULL
      _nType:=NULL
      _flg024:=.F.
      stk_len:=0    // longitud de stk

      while _v!=nil
         // separo flag de direccion de la direccion
         _flag:=_SacaChar(@_v,1)
         if _flag=="$"      // es var: obtengo su tipo

            aadd(arr,{dir,"$",_l})
            _flag:=NULL
            ++dir

            //Verifico que sea una variable y no una constante para READ
            if _sw_read
               if _hash[val(_v)-FFFF][5] =="*"
                  _Error ("Error: Funcionará mejor si se emplea una variable",_l)
               end
            end

            aadd(stk,_hash[val(_v)-FFFF][4])

            stk_len:=len(stk)
            _last_type:=stk[stk_len]   // guardo el ultimo tipo, para RET

            if stk_len>1
               if stk[stk_len]!=stk[stk_len-1]
                   _flg024:=.T.
               end
            end

         else
            _v:=_flag+_v

            if _v $ ">=<" .or. _v=="<=".or. _v==">=".or. _v=="<>".or._v=="@" //;
                  //  _v=="&" .or. _v=="|".or. _v=="@"
               s1:=SDP(stk)
               s2:=SDP(stk)

               stk_len:=len(stk)

               if s1==NIL .or. s2==NIL
                  _Error ("Error: Expresión lógica mal construida",_l)
               end
               if s1==s2  // sea cual sea el tipo
                  if _v $ ">=<" .or. _v=="<=".or. _v==">=".or. _v=="<>"
                     if s1=="N" .or. s1=="C" .or. s1=="AN"
                        aadd(stk,"L")
                       // AÑADIDO 10-06-2018 POR SIACA
                        if s1=="AN"
                           if _v=="="     ; _v:=CMPIGUSTK
                           elseif _v=="<" ; _v:=CMPLTSTK
                           elseif _v==">" ; _v:=CMPGTSTK
                           elseif _v=="<="; _v:=CMPLETSTK
                           elseif _v==">="; _v:=CMPGETSTK
                           elseif _v=="<>"; _v:=CMPNEQSTK
                           end
                        end
                       //
                     elseif _v=="=" 
                        //if s1=="AN" .or. s1=="AC"  // MOD. 10-06-2018
                        if s1=="AC"
                           aadd(stk,"L")
                           _v:=CMPIGUSTK
                        end
                     else     
                        _Error ("Error: Expresión lógica incorrecta",_l)
                     end
                  elseif _v=="@"
                     if s1!="C" .or. s2!="C"
                        _Error ("Error: Tipos distintos en expresión lógica",_l)
                     end
                     aadd(stk,"L")
                  end
               else
                  _Error ("Error: Tipos distintos en expresión lógica:"+s1+_v+s2,_l)
               end
               stk_len:=len(stk)

            elseif _v $ "+/-*^\%"
               s1:=SDP(stk)
               s2:=SDP(stk)

               stk_len:=len(stk)

               if s1==NIL .or. s2==NIL
                  _Error ("Error: Expresión matemática mal construida",_l)
               end
               if s1==s2  // sea cual sea el tipo
                  if _v $ "/-\^*%"
                     if s1=="N"  //s1!="N" .or. s2!="N"
                        aadd(stk,"N")
                     // agregar resta estre matriz y matriz
                     elseif s1=="AN" //.or. s1=="A" // computo de matrices
                    // ? "(oper equals) LIN: ";??_l;??"  COD: ";?? _v;??" ...";??"S1=";??s1;??", ";??"S2=";??s2
                        aadd(stk,"AN")   // luego reemplazo codigos temporales
                        if _v=="-"
                           _v:=LETSUBSTK
                        elseif _v=="*"
                           _v:=LETPMULSTK
                        elseif _v=="/"
                           _v:=LETDIVSTK
                        elseif _v=="\"
                           _v:=LETIDIVSTK
                        elseif _v=="^"
                           _v:=LETPOWSTK
                        elseif _v=="%"
                           _v:=LETMODSTK
                        end
                     elseif _v=="/" .and. s1=="C"  // asumo tokenización
                        aadd(stk,"AC")
                        _v:=TOKENSTRMAT   
                     else
                        _Error ("Error(2): Tipos distintos en expresión matemática",_l)
                     end
                  elseif _v=="+"
                     if s1=="N"
                        aadd(stk,"N")
                     elseif s1=="C"
                        aadd(stk,"C")
                        _v:=ADDSTR      // instruccion directa
               /* ANIADIDO EL 8/8/2016       */   
                     elseif s1=="AN"    // sumo una matriz??
                        aadd(stk,"AN")
                        _v:=LETADDSTK  // cod 256
                     elseif s1=="AC"
                        aadd(stk,"AC")
                        _v:=ADDMATSTR
                     else
                        _Error ("Error(1): Tipos distintos en expresión matemática",_l)
                     end
                  else
                     _Error ("Error(3): No reconozco este símbolo que está en el lugar de un operador",_l)
                  end
               else  // son distintos: puede ser matriz con escalar y viceversa
                  // CHEQUEAR ESTO CON MAYOR DETENCION
                     if ((s1=="N".and.s2=="AC").or.(s1=="AC".and.s2=="N").or.;
                             (s1=="AN".and.s2=="AC").or.(s1=="AC".and.s2=="AN"))
                        if _v=="+"
                           aadd(stk,"AC")
                           _v:=SUBSSTKADDSTR
                        ELSEIF _v=="-"
                           aadd(stk,"AC")
                           _v:=SUBSSTKSUBSTR
                        ELSEIF _v=="*"
                           aadd(stk,"AC")
                           _v:=LREPLICA       // instruccion directa
                        end
                     //if ("N" $ s1 .and. "A" $ S2).or.("A" $ s1 .and. "N"$s2)  // agregado 18-8-2016: si s2="A", es una funcion mat
                     elseif (s1=="N" .and. s2=="AN") .or. (s1=="AN" .and. s2=="N") .or. ;
                        (s1=="AN" .and. s2=="A") .or. (s1=="A" .and. s2=="AN") .or. ;
                        (s1=="A" .and. s2=="N") .or. (s1=="N" .and. s2=="A") 
                        
                    //    ? "LIN: ";??_l;??"  COD: ";?? _v;??" ...";??"S1=";??s1;??", ";??"S2=";??s2

                        aadd(stk,"AN")
                        if _v=="-"
                           _v:=LETESUBSTK
                        elseif _v=="*"
                           _v:=LETPMULSTK
                        elseif _v=="/"
                           _v:=LETEDIVSTK
                        elseif _v=="\"
                           _v:=LETEIDIVSTK
                        elseif _v=="^"
                           _v:=LETEPOWSTK
                        elseif _v=="%"
                           _v:=LETEMODSTK
                        elseif _v=="+"
                           _v:=LETEADDSTK
                        end
                        
                     elseif ((s1=="N".and.s2=="C").or.(s1=="C".and.s2=="N"))
                        if _v=="*"
                           aadd(stk,"C")
                           _v:=LREPLICA       // instruccion directa
                        elseif _v=="+"
                           aadd(stk,"C")
                           _v:=SUBSADDSTR
                        ELSEIF _v=="-"
                           aadd(stk,"C")
                           _v:=SUBSSUBSTR
                        end
                        
                     elseif (s1=="C".and.s2=="AC").or.(s1=="AC".and.s2=="C")
                        if _v=="+"
                           aadd(stk,"AC")
                           _v:=ADDMATSTR   // concatenacion de mats y strings
                        else
                           _Error ("Error(5): Esta operación no está permitida",_l)  
                        end
                     else
                        _Error ("Error(4): Tipos distintos en expresión matemática",_l)       
                     end
/*                  if _v=="*"
                     if !((s1=="N".and.s2=="C").or.(s1=="C".and.s2=="N"))
                        _Error ("Error: Tipos distintos en expresion matematica",_l)
                     end
                     aadd(stk,"C")
                     if s1=="N"
                        _v:=RREPLICA       // instruccion directa
                     else
                        _v:=LREPLICA       // instruccion directa
                     end 
                  else
                     _Error ("Error: Tipos distintos en expresion matematica",_l)
                  end */
               end
               stk_len:=len(stk)

            else
               // es una instruccion: obtengo el seteo de argumentos
               _vINSTR:=DICC[val(_v)][1]
               _vCODE:=DICC[val(_v)][2]
      
               _iType:=alltrim(DICC[val(_v)][3])
               if _iType=="_"
                  if stk_len>0
                     _Error ("Error: Espero otros argumentos para "+upper(_vINSTR)+", digamos, los argumentos correctos",_l)
                  end
               end

               // verifico si es un RET. Ojo: en MAIN, RET es opcional

               if _vCODE==RET
                  _last_type:=SDP(STK)      // OJO
                  if _last_type!=_retorno   // concuerdan???
                     _Error ("Error: El valor devuelto por la función debe coincidir con su declaración",_l)
                  end
                  AADD(stk,_last_type)     // OJO
               end

               _nType:=_SacaChar(@_iType,1)
               
               if substr(_vINSTR,1,1)=="."
                  if substr(DICC[val(_v)][3],1,1)=="A"
                     _nType:=_nType+_SacaChar(@_iType,1)
                  end
               end   

               _fl:=iif(_vCODE==WRITE.or._vCODE==TO,;
                          stk_len,len(_iType))

               _tl:=0
               _nTypel:=NULL
               // extraigo los argumentos desde pila segun lo req. por funcion
               for _tl:=1 to _fl
                  s1:=SDP(stk)
                  if s1==NIL
                     _Error ("Error: Faltan argumentos para la función/instrucción "+upper(_vINSTR)+":"+_nTypel,_l)
                  end
                  _nTypel:=s1+_nTypel
               next
               
               if _vCODE==MMINMAX
                  /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0)*/
                  /*_vCODE=000101:N##   NANAN   A 
                    _vCODE=000101:N##   NANAN   A          
                    _vCODE=000101:N##   NNAN   A 
                    _vCODE=000101:N##   NANN   A
                  */
                  if _nTypel=="NANAN" .or._nTypel=="NNAN".or._nTypel=="NANN"
                     _nType:="AN"
                  else
                     _Error("Error: Argumentos distintos a los esperados, aweonao!",_l)
                  end
               
               elseif _vCODE==MULTMATRIX
                  if _nTypel=="ANAN"
                     _nType:="AN"
                  else
                     _Error("Error: Argumentos distintos en multiplicación matricial, merme!",_l)
                  end
               
               elseif _vCODE==STRLIN
                  if _nTypel=="CN" .or. _nTypel=="CAN"
                     _nType:="C"
                  elseif _nTypel=="ACN" .or. _nTypel=="ACAN"
                      _nType:="AC"
                  else
                      _Error("STRLIN: Argumentos incorrectos... Me quiero cortar las bolas!",_l)
                  end
                     
               elseif _vCODE==STRTOK 
               /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="CN"
                     _nType:="C"
                  elseif _nTypel=="ACN" .or. _nTypel=="ACAN"
                      _nType:="AC"
                  else
                      _Error("STRTOK: Argumentos incorrectos... Me quiero cortar las bolas!",_l)
                  end
               
               elseif _vCODE==STRAT
                  if _nTypel=="CC"
                     _nType:="N"
                  elseif _nTypel=="ACAC".or._nTypel=="CAC".or._nTypel=="ACC"
                     _nType:="AN"
                  else
                     _Error("Error: Argumentos incorrectos... Me quiero cortar las pelotas!",_l)
                  end

               elseif _vCODE==STRCCAR
                  if _nTypel=="CCC"
                     _nType:="C"
                  elseif _nTypel=="ACCC".or._nTypel=="ACACC" .or._nTypel=="ACACAC".or._nTypel=="ACCAC"
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos incorrectos... Me quiero cortar las bolas!",_l)
                  end
               
               elseif _vCODE==STRINS
                  if _nTypel=="CNC"
                     _nType:="C"
                  elseif _nTypel=="ACNC".or._nTypel=="ACANC" .or._nTypel=="ACANAC".or._nTypel=="ACNAC"
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos incorrectos... Me quiero cortar las pelotas!",_l)
                  end
                  
               elseif _vCODE==STRCHG 
               /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="CCC".or._nTypel=="CACC".or._nTypel=="CACAC"
                     _nType:="C"
                  elseif substr(_nTypel,1,1)=="A".and.!("L" $ _nTypel).and.!("N" $ _nTypel)
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos mal colocados, como el 8=D en el globo ocular",_l)
                  end

               elseif _vCODE==MATHLCM .or. _vCODE==MATHGCD
                  if _nTypel=="NN"
                     _nType:="N"
                  elseif _nTypel=="ANN" .or. _nTypel=="ANAN".or._nTypel=="NAN"
                     _nType:="AN"
                  else
                     _Error("Error: espero números o matrices de números, no esto",_l)
                  end
                        
               elseif _vCODE==FUNINC.or._vCODE==FUNDEC
                  if _nTypel=="N"
                     _nType:="N"
                  elseif _nTypel=="AN"
                     _nType:="AN"
                  else
                     _Error("Error: Argumento de esta operación debe ser number o matriz de number",_l)
                  end
               
               elseif _vCODE==INC.or._vCODE==DEC   
                  if _nTypel!="N" .and._nTypel!="AN"
                     _Error("Error: Argumento de la operación debe ser number o matriz de number",_l)
                  end
                   
               elseif _vCODE==NOTVAR
                  if _nTypel!="L" .and._nTypel!="AL"
                     _Error("Error: Argumento de la operación negación debe ser booleano, GIL!",_l)
                  end
                  
               elseif _vCODE==NOT  // negacion con devolucion
                  if _nTypel=="L"
                     _nType:="L"
                  elseif _nTypel=="AL"
                     _ntype:="AL"
                  else
                     _Error("Error: Argumento de la función negación debe ser booleano, gil!",_l)
                  end
               
               elseif _vCODE==STRREPC
                  if _nTypel=="CCN"
                     _nType:="C"
                  elseif _nTypel=="ACCN".or._nTypel=="ACACN".or._nTypel=="ACACAN".or._nTypel=="ACCAN"
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos mal colocados en STRREPC",_l)
                  end
               
               elseif _vCODE==STRCUT.or._vCODE==STRCPY
                  if _nTypel=="CNN" 
                     _nType:="C"
                  elseif _nTypel=="CANN".or._nTypel=="CANAN".or._nTypel=="CNAN"
                     _nType:="AC"
                  elseif _nTypel=="ACNN".or._nTypel=="ACANN".or._nTypel=="ACANAN".or._nTypel=="ACNAN"
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos mal colocados en STRCUT|STRCPY",_l)
                  end
               
               elseif _vCODE==STRFIND
                  if _nTypel=="CCN"
                     _nType:="N"
                  elseif _nTypel=="ACCN".or._nTypel=="ACACN".or._nTypel=="CACN".or.;
                         _nTypel=="ACCAN".or._nTypel=="ACACAN".or._nTypel=="CACAN"
                     _nType:="AN"
                  else
                     _Error("Error: Argumentos incorrectos (STRFIND)... Me quiero cortar las bolas!",_l)
                  end
                  
               elseif _vCODE==STRREP
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="CCCNN".or._nTypel=="CACCNN".or._nTypel=="CACACNN".or._nTypel=="CCACNN"
                     _nType:="C"
                  elseif substr(_nTypel,1,1)=="A".and.substr(_nTypel,len(_nTypel)-1,2)=="NN".and.;
                         !("L" $ _nTypel).and.!("N" $ substr(_nTypel,1,len(_nTypel)-2))
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos incorrectos (STRREP)... Me quiero cortar las bolas!",_l)
                  end
                  
               elseif _vCODE==ISNAN .or. _vCODE==ISINF
                 if _nTypel!="AN" .AND. _nTypel!="N"
                    _Error("Error: Se requiere un numero o una matriz de numeros en ISNAN/ISINF",_l)
                 else
                    _nType:="L"
                 end
               elseif _vCODE==STRLZ
                 if _nTypel!="AC".AND._nTypel!="C"
                    _Error("Error: Se requiere un string o una matriz de strings en STRLZ",_l)
                 elseif _nTypel=="C"
                    _nType:="L"
                 elseif _nTypel=="AC"
                    _nType:="AL" 
                 end

               elseif _vCODE==PAD
                  /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0)*/
                  if _nTypel=="CN" .or. _nTypel=="NN"
                     _nType:="C"
                  elseif _nTypel=="ACN" .or. _nTypel=="ACAN" //.or._nTypel=="ANN" .or. _nTypel=="ANAN"
                     _nType:="AC"
                  else
                     _Error("PADx: Argumentos erróneos (si es matriz, debe ser string)",_l)
                  end   
           
               elseif _vCODE==STRLOAD
                 /* if _nTypel!="ACANAN".and._nTypel!="ACANN".and._nTypel!="ACNAN".and.;
                     _nTypel!="CNN".and._nTypel!="ACNN"
                     _Error("Error: Tus argumentos me los meto por el orto!",_l)
                  end*/
                  if _nTypel!="C".and. _nTypel!="AC"
                     _Error("STRLOAD: Tus argumentos me los meto por el orto!",_l)
                  end
                  _nType:="C"
                      
               elseif _vCODE==XCODE_CC 
                  if _nTypel=="NC" 
                     _nType:="C"
                  elseif _nTypel=="NAC"
                     _nType:="AC"
                  else
                     _Error("Error: Argumentos fuera de toda lógica!",_l)
                  end 
               
               elseif _vCODE==PARSATT
                  if _nTypel=="CCAC"
                     _nType:="C"
                  elseif _nTypel=="ACCAC".or._nTypel=="CACAC".or._nTypel=="ACACAC"
                     _nType:="AC"
                  else
                     _Error("PARSATT: Argumentos no válidos, es decir, no válidos",_l)
                  end
               
               elseif _vCODE==PARSER .OR. _vCODE==UNPARSER
                  if _nTypel=="ACC" .or. _nTypel=="ACAC".or._nTypel=="CAC"
                     _nType:="AC"
                  elseif _nTypel=="CC"
                     _nType:="C"
                  else
                     _Error("xPARSER: Argumentos chantas. Si yo fuera Homero Simpson, esta weá pasa piola",_l)
                  end
               
               elseif _vCODE==SEEK
                  if _nTypel=="FNN"
                     _nType:="N"
                  else
                     _Error("FSEEK: Argumentos erróneos",_l)
                  end
                 
               elseif _vCODE==XCODE_CCC  // CRYPT
                /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="NACC" .or. _nTypel=="NACAC"
                     _nType:="AC"
                  elseif _nTypel=="NCC"
                     _nType:="C"
                  else
                     _Error("Error: Argumentos fuera de toda lógica!",_l)
                  end
                  
               elseif _vCODE==SEQSP .or. _vCODE==SEQUENCE
                  _nType:="AN"

               elseif _vCODE==WRITE 
               //  ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
               //   inkey(0)
                  if empty(alltrim(_nTypel))
                     _Error ("WRITE: Debe tener argumentos, o sea, algo que escribir poh amermelao!",_l)
                  end
               /*   if _nTypel=="L"
                     _Error ("Error: No puede imprimir un valor de verdad. Use 'CERTAIN'",_l)
                  end */
                  if len(_nTypel)>1 .and. _ntypel!="AN".and._ntypel!="AC".and._nTypel!="AV".and._nTypel!="AL"
                     _Error ("WRITE: Argumentos deben estar separados por coma ','",_l)
                  end
                  
               elseif _vCODE==RECURSIVE  // soporte recursividad
                  SW_RECURSIVE:=.T.
                  _v:=NOP
               elseif _vCODE==ERECURSIVE
                  SW_RECURSIVE:=.F.
                  _v:=NOP
               elseif _vCODE==USE
                  if _nTypel!="A"
                      _Error ("USE: necesita un stack para activar",_l)
                  end
                  // guardo el tipo en stack USE
                  stackpop(stk_use)   // saco anterior

                  stackpush(stk_use,substr(_ntypel,2,1))

               elseif _vCODE==XJOIN
        //          ? _ntypel," - ",_ktypel   // ACC C
                  if _ntypel!="AC"
                      _Error ("Error: El Stack debe ser de tipo string en JOIN",_l)
  /*                  elseif substr(_ntypel,3,1)!="C"
                      _Error ("Error: El separador debe ser de tipo STRING",_l) 
*/
                  end
                  
               elseif _vCODE==TSTATS_CODE
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if substr(_nTypel,2,2)!="AN" 
                      _Error ("FUN STATS: Se requiere un array numérico, gil de la mente!",_l)
                  end
                  _nType:="AN"  // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                  _ntypel:=substr(_ntypel,2,1)
                                     
               elseif _vCODE==AFINDSTK
               //A#C#
               /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) ; QUIT*/
                   if _nTypel!="CCC"  /// POR AHORA SOLO STRING.and._nTypel!="CCAC"
                      if substr(_nTypel,1,1)!="A" 
                         _Error ("Error: Se requiere un array o un string como primer argumento, wea",_l)
                      elseif substr(_nTypel,4,1)=="A"
                         if substr(_nTypel,2,1)!=substr(_nTypel,5,1)
                            _Error ("[\ ]: Tipos distintos a los esperados",_l)
                         end
                      else
                         if substr(_nTypel,2,1)!=substr(_nTypel,4,1)
                            _Error ("[\ ]: Tipos distintos a los esperados",_l)
                         end
                      end
                   end
                   _nType:="AN"  // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                   _ntypel:=substr(_ntypel,2,1)
               
               elseif _vCODE==RESHAPE
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel!="ANNNNN" .AND._nTypel!="ACNNNN".AND._nTypel!="ALNNNN"
                     _Error ("RESHAPE: Tipos de argumento radicalmente distintos a los esperados",_l)
                  end
                  
               elseif _vCODE==MATRANGE
               /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel!="NNA" .AND. _nTypel!="NAN"  //.and._nTypel!="NNA"
                     _Error("[* ]: Espero un number que señale fila/col, y una matriz",_l)
                  end
                  _nType:="AN"
               
               elseif _vCODE==YMATALTER
                  if _nTypel!="NACACN".and._nTypel!="NANANN".and._nTypel!="NALALN"
                     _Error("Error: Argumentos erróneos para insertar matrices",_l)
                  end
                  
               elseif _vCODE==XMATALTER
                  /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                   if substr(_nTypel,1,2)!="NN" 
                      _Error ("Error(1): Se requieren índices de función numéricos, wea",_l)
                   elseif substr(_nTypel,3,1)!="A" .or. substr(_nTypel,5,1)!="A" 
                      _Error ("Error(2): Se requieren matrices para procesar cortes o añadiduras",_l)
                   elseif substr(_nTypel,3,2)!=substr(_nTypel,5,2) .and. substr(_nTypel,5,2)!="AN" 
                      _Error ("Atención: Tipo distinto al esperado en la segunda matriz (si tu intención es hacer un corte)",_l)
                   end
                   _nType:=substr(_nTypel,3,2)  // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                   _ntypel:=substr(_ntype,2,1)  // el subtipo devuelto
           
               elseif _vCODE==SHOWER
                 /*  ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                   if len(_ntypel)==2
                      _Error ("SHOW: no puedes showear una matriz estática: castoreala o asígnala! "+_CR+;
                              "También es posible que te hayas metido el índice de columnas en la raja...",_l)
                   end   
                   if substr(_nTypel,3,1)!="N" 
                      _Error ("SHOW: Se requiere índice numérico de columnas, sacowea",_l)
                   end
               elseif _vCODE==SORT
                  /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                   if substr(_nTypel,3,1)!="N" 
                      _Error ("SORT: Se requiere índice numérico de ordenamiento, pelotudo",_l)
                   end
                   if substr(_ntypel,1,1)!="A"
                      _Error ("SORT: Se requiere un array",_l)
                   end
                   _nType:=_iType  //"A"
               
               elseif _vCODE==STRDIFF
                 /*  ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                   if _nTypel!="CCN"
                      _Error("STRDIFF: espero strings y un número, no esta hueá que pusiste",_l)
                   else
                      _nType:="AN"
                   end
                
               elseif _vCODE==XUCODESTATIC
                  /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                   if _nTypel!="CCNNNN" .and. _nTypel!="CNNNNN" .and. _nTypel!="CLNNNN"
                   ///if substr(_nTypel,1,2)!="CC" .or. substr(_nTypel,3,4)!="NNNN"
                      _Error ("^[ ]: Argumentos mal encajados",_l)
                   else
                      _nType:="A"+substr(_nTypel,2,1)
                   end
                   // devuelve el tipo? no puedo: debo analizar los tipos en ejecucion :(

               elseif _vCODE == XVTMATFILE
                  /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0)*/
                   if substr(_nTypel,1,1)!="A" 
                      _Error ("Error: Se requiere un array, sacowea",_l)
                   elseif substr(_ntypel,3,1)!="C"
                      _Error ("Error: Espero un string con el nombre del archivo, jeropa",_l)
                   end

               elseif _vCODE==TRGCODE .or. _vCODE==TMATHCODE .or._vCODE==MATHCODE .or. _vCODE==HTRGCODE
                /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="NN"
                     _nType:="N"
                  elseif _nTypel=="NAN"
                     _nType:="AN"
                  else
                     _Error("FUN MATHS/TRIG: Argumentos manfinfleros",_l)
                  end
                  
               elseif _vCODE==DATEDIFF
               /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0) */
                  if _nTypel=="CC"
                     _nType:="N"
                  elseif _nTypel=="ACC" .or. _nTypel=="ACAC"
                     _nType:="AN"
                  else
                     _Error ("DAYSDIFF: Argumentos erróneos",_l)
                  end
                  
               elseif _vCODE==DATEADD
                  if _nTypel=="CN"
                     _nType:="C"
                  elseif _nTypel=="ACN" .or. _nTypel=="ACAN"
                     _nType:="AC"
                  else
                     _Error ("DATEADD: Argumentos erróneos en",_l)
                  end
                  
               elseif _vCODE==LINECOUNT
                  if _nTypel=="C"
                     _nType:="AN"
                  else
                     _Error("FLC: Se requiere un nombre de archivo válido",_l)
                  end

               elseif _vCODE==XTOSTR
                  if _nTypel!="N" .and. _nTypel!="AN".and._nTypel!="L".and._nTypel!="AL".and._nTypel!="V";
                      .and. _nTypel!="AV".and._nTypel!="A"
                     _Error ("($ ): Espero números, variants o booleanos (escalares o arrays)",_l)
                  end
                  if _nTypel=="N".or._nTypel=="L".or._nTypel=="V"
                     _nType:="C"
                  else
                     _nType:="AC"
                  end

               elseif _vCODE==XTONUM
                /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel," ",_ntype
                  inkey(0)*/
                  if _nTypel!="C" .and. _nTypel!="AC".and._nTypel!="L".and._nTypel!="AL".and._nTypel!="V";
                      .and. _nTypel!="AV".and._nTypel!="A"
                     _Error ("(# ): Espero strings, variants o booleans (escalares o arrays)",_l)
                  end
                  if _nTypel=="C".or._nTypel=="L".or._nTypel=="V"
                     _nType:="N"
                  else
                     _nType:="AN"
                  end

               elseif _vCODE==XCODE_CN
                  if _nTypel!="NN" .and. _nTypel!="NAN"
                     _Error ("Error: Se requiere un number o un array de number, gil de probeta",_l)
                  end
                  if _nTypel=="NN"
                     _nType:="C"
                  else
                     _nType:="AC"
                  end
                  
               elseif _vCODE==ISNEAR
                  if _nTypel!="NN" .and. _nTypel!="ANN".and._nTypel!="ANAN"
                     _Error ("ISNEAR: Se requiere dos number o dos array de number",_l)
                  end
                  _nType:="L" 
               
               elseif _vCODE==FUNFIX
                 // ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  /*if  _vLET==NULL   se cae cuando esta dentro de una funcion
                     _Error ("FIX: debe ser asignado",_l)
                  end*/
                  if _nTypel=="ANN" 
                     _nType:="AN"
                  elseif _nTypel=="NN"
                     _nType:="N"
                  else
                     _Error ("FIX: argumentos como el pico",_l)
                  end
               elseif _vCODE==FACTORIAL .or. _vCODE==NOTBIT
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0) */
                  if _nTypel!="N" .and. _nTypel!="AN"
                     _Error ("Error: Se requiere un number o un array de number, chamberlein",_l)
                  end
                  _nType:=_nTypel   

               elseif _vCODE==UNIQUE
                  if substr(_nTypel,1,1)!="A".or.len(_nTypel)!=2
                     _Error("UNIQUE: trabaja con matrices, gil de cuna",_l)
                  end
                  _nType:=_nTypel
                  
               elseif _vCODE==SETCODE
                  if _nTypel!="NACAC" .and._nTypel!="NANAN"
                     _Error("Error: Operación de conjuntos requiere matrices number o string",_l)
                  end
                  _nType:=substr(_nTypel,2,2)
               
               elseif _vCODE==ROUND
                  if _nTypel=="NN"
                     _nType:="N"
                  elseif _nTypel=="ANN"
                     _nType:="AN"
                  else
                     _Error ("ROUND: Se requiere un number o un array de number",_l)
                  end
               
               elseif _vCODE==POSCHAR
                  if _ntypel!="CNC" .and. _ntypel!="CNN"
                     _Error("Error: Argumentos incorrectos en '[. ]/POSCHAR'",_l)
                  end
               
               elseif _vCODE==XTOSTACK
                  if substr(_nTypel,1,1)!="A"
                     _nType:="A"+substr(_nTypel,2,1)
                  else
                     _nType:=_nTypel   
                  end

               elseif _vCODE==XTOVARIANT
                  _v:=NOP
                  
               elseif _vCODE==XTOBOOL
                  /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0) */
                  if _nTypel!="N".and._nTypel!="C".and._nTypel!="AN".and._nTypel!="AC".and._nTypel!="V";
                      .and. _nTypel!="AV".and._nTypel!="A"
                     _Error ("Error: Espero números, variants o strings, o un array de estos (%..)/xTObool",_l)
                  elseif _nTypel=="N".or._nTypel=="C".or._nTypel=="V"
                    _nType:="L"
                  else
                    _nType:="AL"
                  end
                  
               elseif _vCODE==ISALL .or. _vCODE==ISANY
                /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0) */
                  if _nTypel!="NN" .and. _nTypel!="ANN" .and. _nTypel!="CC".and._nTypel!="ACC".and. _nTypel!="LL".and._nTypel!="ALL"
                     _Error ("Error: Se requiere un number o un array de number ISANY/ISALL",_l)
                  end
                  _nType:="L"
                   

               elseif _vCODE==NEGATIVE.or._vCODE==POSITIVE
                  if _nTypel!="N" .and. _nTypel!="AN"
                     _Error ("Error: Se requiere un number o un array de number ISPOS/ISNEG",_l)
                  end
                  _nType:="L"
               
               
               elseif _vCODE==TDATECODE
                  if _nTypel=="NC"
                     _nType:="C"
                  elseif _nTypel=="NAC"
                     _nType:="AC"
                  else
                     _Error ("Error: Se requiere un string o un array de string",_l)
                  end

               elseif _vCODE==SATURA
                  if _nTypel=="CCC"
                     _nType:="C"
                  elseif _nTypel=="CANC"
                     _nType:="C"
                  elseif _nTypel=="ACCC"
                     _nType:="AC"
                  elseif _nTypel=="ACANC"
                     _nType:="AC"
                  else
                     _Error ("Error: Argumentos como el pico en 'SATURA'",_l)
                  end

               elseif _vCODE==PROCESS
                  if _nTypel!="NLN".AND._nTypel!="NACN".AND._nTypel!="NNC" 
                     _Error ("Error: Argumentos erroneos en PROCESS",_l)
                  end 
               elseif _vCODE==SERVER
                  if _nTypel!="N"
                     _Error ("Error: Argumentos erroneos en SERVER",_l)
                  end
                  _nType:="AC"
               elseif _vCODE==RESPONSE
                  if _nTypel!="AC"
                     _Error ("Error: Argumentos erroneos en RESPONSE",_l)
                  end
               
               elseif _vCODE==CASTEO
                  if _nTypel=="NAN"
                     _nType:="AN"
                  else
                     _Error ("Error: Argumentos erroneos en operadores de CAST (solo sirve para arrays)",_l)
                  end 
                  
               elseif _vCODE==MONEY
                  if _nTypel=="NCNN"
                     _nType:="C"
                  elseif _nTypel=="ANCNN"
                     _nType:="AC"
                  else
                     _Error ("Error: Argumentos mal educados en MONEY",_l)
                  end               
               elseif _vCODE==MASK
                  if _nTypel=="CC"
                     _nType:="C"
                  elseif _nTypel=="ACC"
                     _nType:="AC"
                  else
                     _Error ("Error: Argumentos HORROROSAMENTE dados en MASK",_l)
                  end               
              /***    if _nTypel=="NC"
                     _nType:="C"
                  elseif _nTypel=="ANC"
                     _nType:="AC"
                  else
                     _Error ("Error: Argumentos mal ubicados en MASK",_l)
                  end  ***/
               
               elseif _vCODE==TDATE2CODE .or. _vCODE==XCODE2_NC .or. _vCODE==XCODE_NC
                 /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0)*/
                  if _nTypel=="NC"
                     _nType:="N"
                  elseif _nTypel=="NAC"
                     _nType:="AN"
                  else
                     _Error ("Error: Se requiere un string o un array de string, amermelao",_l)
                  end

               elseif _vCODE==BIT_CODE
                 /*?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0)*/
                  if _nTypel=="NNN"
                     _nType:="N"
                  elseif _nTypel=="NANN" .or. _nTypel=="NANAN"
                     _nType:="AN"
                  else
                     _Error ("Error: Tus argumentos valen callampa",_l)
                  end

               elseif _vCODE==ISLEAP
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0) */
                  if _nTypel=="N"
                     _nType:="L"
                  elseif _nTypel=="AN"
                     _nType:="AL"
                  else
                     _Error ("Error: Se requiere un number o un array de number en ISLEAP, amermelao",_l)
                  end
                  
               elseif _vCODE==ISTIME
                  if _nTypel!="C" .and. _nTypel!="AC"
                     _Error ("Error: Se requiere un string o un array de string en ISTIME, wea",_l)
                  elseif _nTypel=="C"
                     _nType:="L"
                  elseif _nTypel=="AC"
                     _nType:="AL"
                  end
                                 
               elseif _vCODE==MNSEC
                 /* ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0) */
                  if _nTypel=="C"
                     _nType:="N"
                  elseif _nTypel=="AC"
                     _nType:="AN"
                  else
                     _Error ("Error: Se requiere un string o un array de string, sacowea",_l)
                  end
                  
               elseif _vCODE==BLKCOPY
                 /** ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                  inkey(0)*/
                   if substr(_nTypel,1,1)!="A" 
                      _Error ("Error: Se requiere un array, wea",_l)
                   elseif substr(_ntypel,3,2)!="AN"
                      _Error ("Error: Tipos distintos en índices de selección de bloque",_l)
                   end
                   _nType:=substr(_ntypel,1,2)  //"AN" o "AC" o "AL" // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                   _ntypel:=substr(_ntypel,2,1)
               
               elseif _vCODE == PUTRANGE
                 // ?"PUTRANGE=", _nTypel, "_ntype=",_nType ; inkey(0)
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array",_l)
                  elseif substr(_nTypel,5,1)=="A"
                     if substr(_nTypel,2,1)!=substr(_nTypel,6,1)
                        _Error ("Error: Tipo asignado no coincide con tipo de array",_l)
                     end
                  elseif substr(_nTypel,2,1)!=substr(_nTypel,5,1)
                     _Error ("Error: Tipo asignado no coincide con tipo de array",_l)                     
                  elseif substr(_nTypel,4,1)!="N"
                     _Error ("Error: Se requiere un vector de posición numérico",_l)
                  end
               
               elseif _vCODE == GETRANGE
                 // ?"GETRANGE=", _nTypel, "_ntype=",_nType ; inkey(0)
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array",_l)
                  elseif substr(_nTypel,3,2)!="AN"
                     _Error ("Error: Se requiere un array numérico de posiciones",_l)  
                  end
                  _nType:=substr(_ntypel,1,2) //"AN"  // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                  _ntypel:=substr(_ntypel,2,1)
                  
               elseif _vCODE == GET_ARRAY
                  // filtro por si es string y no array
                  //?"GET_ARRAY=", _nTypel, "_ntype=",_nType 
                  if _nTypel=="CN"   // es string!
                     _nType:="C"
                     _v:=CGET
                  elseif _nTypel=="NN"
                     _nType:="N"
                     _v:=GETBIT
                  else
                     if substr(_nTypel,1,1)!="A"
                        _Error ("Error(1): Se requiere un array en [ARR ...]",_l)
                     elseif substr(_nTypel,3,1)!="N"
                        _Error ("Error(1): Se requiere un índice numérico",_l)
                     end
                     _ntypel:=substr(_ntypel,2,1)
                  end

               elseif _vCODE == PUT_ARRAY
                  //?"PUT_ARRAY=", _nTypel, "_ntype=",_nType 
                  if _nTypel=="CNC" .or._nTypel=="CNN"
                     _v:=POSCHAR
                  elseif _nTypel=="NNN"
                     _v:=SETBIT
                  else
                     if substr(_nTypel,1,1)!="A"
                        _Error ("Error: Se requiere un array en [ARR ...]",_l)
                     elseif substr(_nTypel,2,1)!=substr(_nTypel,4,1)
                        _Error ("Error: Tipo asignado no coincide con tipo de array",_l)
                     elseif substr(_nTypel,3,1)!="N"
                        _Error ("Error: Se requiere un índice numérico",_l)
                     end
                  end

               elseif _vCODE== PUT_MATRIX
                 // ? _nTypel 
                  if _nTypel=="CNNC"
                     _v:=SPUT
                  elseif _nTypel=="NNNN"
                     _v:=SETGBIT
                  else   
                     if substr(_nTypel,1,1)!="A"
                        _Error ("Error: Se requiere un array en [.ARR ...]",_l)
                     elseif substr(_nTypel,2,1)!=substr(_nTypel,5,1)
                        _Error ("Error: Tipo asignado no coincide con tipo de array",_l)
                     elseif substr(_nTypel,3,2)!="NN"
                        _Error ("Error: Se requieren índices numéricos",_l)
                     end
                  end

               elseif _vCODE== PUT_PAGE
                 // ? _nTypel 
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array en [:ARR ...]",_l)
                  elseif substr(_nTypel,2,1)!=substr(_nTypel,6,1)
                     _Error ("Error: Tipo asignado no coincide con tipo de array",_l)
                  elseif substr(_nTypel,3,3)!="NNN"
                     _Error ("Error: Se requieren índices numéricos",_l)
                  end

               elseif _vCODE== PUT_BLOCK
                 // ? _nTypel 
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array en [_ARR ...]",_l)
                  elseif substr(_nTypel,2,1)!=substr(_nTypel,7,1)
                     _Error ("Error: Tipo asignado no coincide con tipo de array",_l)
                  elseif substr(_nTypel,3,4)!="NNNN"
                     _Error ("Error: Se requieren índices numéricos",_l)
                  end
               
               elseif _vCODE == SIZEMAT
                //  ?"^SIZE=", _nTypel, " ITYPE= ",_itype, " NTYPE=",_ntype ; inkey(0)
                  if substr(_nTypel,1,1)!="A" 
                     _Error ("Error: Se requiere una matriz o vector",_l)
                /*  elseif substr(_nTypel,3,1)!="N"
                     _Error ("Error: Se requieren índices numéricos",_l) */
                  end
                  _nType:="AN"  // ojo! con esto aparebtemente se arregla la asignacion de SIZE
                  _ntypel:=substr(_ntypel,2,1)
               
               elseif _vCODE == GET_MATRIX
                  //? _nTypel
                  if _nTypel=="CNN"
                     _nType:="C"
                     _v:=SGET
                  elseif _nTypel=="NNN"
                     _nType:="N"
                     _v:=GETGBIT
                  else
                     if substr(_nTypel,1,1)!="A"
                        _Error ("Error: Se requiere un array en [.ARR ...]",_l)
                     elseif substr(_nTypel,3,2)!="NN"
                        _Error ("Error: Se requieren índices numéricos",_l)
                     end
                     _ntypel:=substr(_ntypel,2,1)
                  end

               elseif _vCODE == GET_PAGE
                  //? _nTypel
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array en [:ARR ...]",_l)
                  elseif substr(_nTypel,3,3)!="NNN"
                     _Error ("Error: Se requieren índices numéricos",_l)
                  end
                  _ntypel:=substr(_ntypel,2,1)

               elseif _vCODE == GET_BLOCK
                  //? _nTypel
                  if substr(_nTypel,1,1)!="A"
                     _Error ("Error: Se requiere un array en [_ARR ...]",_l)
                  elseif substr(_nTypel,3,4)!="NNNN"
                     _Error ("Error: Se requieren índices numéricos",_l)
                  end
                  _ntypel:=substr(_ntypel,2,1)

               elseif _vCODE == GET
                  if _ntypel==NULL
                     if len(stk_use)==0
                        _Error ("Error: No has activado un array para MAT.GET",_l)
                     end
                     _ntype:=stk_use[len(stk_use)]  
                  end

                  _ktypel:=_ntypel
                  if "A" $ _ntypel
                      _ktypel:=substr(_ntypel,2,1)
                  end

                  if atail(stk_use)!=_ktypel
                     _Error ("Error: El tipo en MAT.GET debe coincidir con el tipo del array",_l)
                  end
               
               elseif _vCODE == PUT
                  if _ntypel==NULL
                     if len(stk_use)==0
                        _Error ("Error: No has activado un Stack para MAT.PUT",_l)
                     end
                     _ntype:=stk_use[len(stk_use)]   
                  end

                  _ktypel:=_ntypel
                  if "A" $ _ntypel
                      _ktypel:=substr(_ntypel,2,1)
                  end

                  //? atail(stk_use)
                  //? _ktypel
                  //inkey(0)
                  if atail(stk_use)!=_ktypel .and. atail(stk_use)!="V"
                     _Error ("Error: El tipo en MAT.PUT debe coincidir con el tipo del Stack",_l)
                  end
   
               elseif _vCODE==PUSH 
                 // ?"_vCODE=";?? _vCODE;??":";?? _iType," ",_nTypel
                 // inkey(0)
                  if len(stk_use)==0
                     _Error ("Error: No has activado un Stack para usar PUSH",_l)
                  end
                  
                  /***HOY****/
                  if atail(stk_use)=="V"
                     _nTypel:="V"
                  else
                  /**********/
                     _ktypel:=_ntypel
                     if "A" $ _ntypel
                        _ktypel:=substr(_ntypel,2,1)
                     end
                     if atail(stk_use)!=_ktypel 
                         _Error ("Error: El tipo en PUSH debe coincidir con el tipo del Stack",_l)
                     end 
                  //   ? atail(stk_use),_ktypel ; inkey(0)
                     _iType:=_nTypel
                  end


               elseif _vCODE==FPOP      // la funcion debe devolver algo
                 //  ? "_vCODE=", _vCODE,":", _iType," ",_nTypel
                  
              //    if _ntypel==NULL
                     if len(stk_use)==0
                        _Error ("Error: No has activado un Stack para usar POP",_l)
                     end
                     _ntype:=stk_use[len(stk_use)]  
                     _kTypel:="V"
              //    end
                 //  _nType:="V"
                 /* _ktypel:=_ntypel
                  if "A" $ _ntypel
                      _ktypel:=substr(_ntypel,2,1)
                  end
                 
                  if atail(stk_use)!=_ktypel
                     _Error ("Error: El tipo en POP debe coincidir con el tipo del Stack",_l)
                  end */

               elseif _vCODE==POP 
                 // ? "_vCODE=", _vCODE,":", _iType," ",_nTypel
                 // inkey(0)
                  if len(stk_use)==0
                     _Error ("Error: No has activado un Stack para usar POP",_l)
                  end
                 // _nType:="V" 
                 /* _ktypel:=_ntypel
                  if "A" $ _ntypel
                      _ktypel:=substr(_ntypel,2,1)
                  end
                  if atail(stk_use)!=_ktypel
                      _Error ("Error: El tipo en POP debe coincidir con el tipo del Stack",_l)
                  end */
                  
               elseif _vCODE==CONFIG_ARRAY 
                 //? "CONFIG_ARRAY",_nTypel // "AX"
                 if len(_nTypel)<2
                    _Error ("Error: CONFIG_ARRAY requiere de un stack (use DIM para evitar CONFIG_ARRAY)",_l)
                 end 


               elseif _vCODE==IIF    // iif
                  if _nTypel=="LCC"
                      _v:=IFC
                  elseif _nTypel=="LNN"
                      _v:=IFN
                  elseif _nTypel=="LLL"
                      _v:=IFB
                  else  
                      _Error ("Error: Combinación desconocida de argumentos en {<EXP> ?..:..} | IIF",_l)
                  end
                  
               elseif _vCODE==SWAP    // generico
                  if _nTypel!="CC" .and. _nTypel!="NN" .and. _nTypel!="ACAC" .and. _nTypel!="ANAN"
                     _Error ("Error: Argumentos no válidos en '<->' | SWAP",_l)
                  end
                  
               elseif _vCODE==LET   // debo chequear por _vLET
                  if _nTypel=="C"     //"C" $ _nTypel
                      if _vLET=="AC"
                         _v:=LETSTRSTK
                      end
                  elseif _ntypel=="N"
                      if _vLET=="AN"
                         _v:=LETESPSTK
                      end
                  elseif _ntypel=="L"
                      if _vLET=="AL"
                         _v:=LETESPSTK
                      end
                  elseif "A" $ _nTypel
                      if "A" $ _vLET
                         _v:=LETSTKSTK  
                      end
                  else
                     // ? "_NTYPEL=",_ntypel," VLET=",_vLET ; inkey(0)
                      if _nTypel!=_vLET
                         _Error ("Error(1): Tipos distintos en operación de asignación",_l)
                      end
                  end
               end
               //----------------------

               if _iType!=_nTypel
                  // codigo para IIF
                  if _iType=="L##"
                     if _nTypel!="LNN".and.;
                        _nTypel!="LCC".and.;
                        _nTypel!="LLL"
                        _Error ("Error: Espero otros argumentos para la función "+upper(_vINSTR),_l)
                     end
                  elseif _iType!="#"
                     
                    /// ? _vCODE;??":";?? _iType," ",_nTypel // para sin(arra) entrega _ntypel==NAN
                    // SE Añade _iType!="V" porque no aceptaba un unico argumento de 
                    // funcion de usuario de tipo variant. Veamos si no afecta otras cosas.
                    
                     if !("A" $ _iType) .and. _iType!="N#" .and. _iType!="C#NNNN" ;// para tstk_code
                        .and. _iType!="V"
                        _Error ("Error(1): Espero otros argumentos para la función "+upper(_vINSTR),_l)
                     end
                  end
               end

            /* OJO: 8-dic-2016, si lo quito between pasa sin problemas.  
               if _flg024   // 024 y 030 es error, para 018 (write) no lo es
                  if _vCODE==IS_RANGE
                   ? "_vCODE=",_vCODE," BETW=",_nTypel," iType=",_iType," stklen=",len(stk)
                  //   _Error ("Error(3): Argumentos distintos para la función "+upper(_vINSTR),_l)
                  end
               end
*/
               _flg024:=.T.   // seteo flag para 024
               //? _vCODE;??":";?? _nType," ",_nTypel // para sin(arra) entrega _ntypel==NAN
/*               if _ntype=="N" .and._nTypel=="NAN"
                   aadd(stk,"AN")
               end */
               if _ntype=="#"    
                   // sera un IIF ?     ???????
                   if _vCODE==IIF   // debo dejar el tipo de uno de sus argumentos
                      aadd(stk,iif(_v==IFB,"L",   ;
                                  iif(_v==IFN,"N","C")))
                      //______________________
                      _v:=IIF
                   else

                      //if len(_nTypel)>1                // OJO
                     //    _nTypel:=substr(_nTypel,1,1)  // OJO
                     // end                              // OJO

                      aadd(stk,_nTypel)   // salio del anonimato
                   end

               elseif _nType!="_"     ///

                   //if len(_nType)>1                   // OJO
                   //   _nType:=substr(_nType,1,1)     // OJO
                   //end                                 // OJO
                  //  ? "ENTRA A STK=",_nType; inkey(0)
                   aadd(stk,_nType)

               end

               stk_len:=len(stk)

               if _vCODE==IS_RANGE
               /*  8-dic-2016: si lo queto pasa sin problemas 
                   ? "_vCODE=",_vCODE," BETW=",_nTypel," iType=",_iType," stklen=",len(stk)
                //  if stk_len>1
                     for _x:=1 to stk_len
                        ? stk[_x]
                     next*/
                /*     _Error ("Error: Tienes argumentos de sobra en la expresión",_l)
                  end*/
               elseif _vCODE==WHILE    
                  if stk_len>1
                     _Error ("Error: Te faltó un operador en la expresión, o te sobró uno",_l)
                  end
               end

            end
            //
         end
         if _v!=TO
           /* if _v==SWAPC .or. _v==SWAPN   // al pasar a "C++" esto no va!!
               _v:=SWAP
            end */


            if _v==AND.or._v==OR.or._v==XOR
               aadd(arr,{dir,LOPERA_CODE,_l})
               ++dir

            elseif substr(_v,1,1)=="2"   // es un codigo de computo matricial str+-n en matriz
               aadd(arr,{dir,CODSUBMAT,_l})
               ++dir
               if _v==SUBSSTKADDSTR
                  _v:="+"
               elseif _v==SUBSSTKSUBSTR
                  _v:="-"
               end
            elseif substr(_v,1,1)=="1"   // es un codigo de computo matricial
               aadd(arr,{dir,CODOPEMAT,_l})
               ++dir
               // cambio codigos matriciales por normales para que pasen el analisis
               if _v==LETADDSTK .or. _v==LETEADDSTK
                  _v:="+"
               elseif _v==LETSUBSTK .or. _v==LETESUBSTK
                  _v:="-"
               elseif _v==LETPMULSTK .or. _v==LETEMULSTK
                  _v:="*"
               elseif _v==LETDIVSTK .or. _v==LETEDIVSTK
                  _v:="/"
               elseif _v==LETIDIVSTK .or. _v==LETEIDIVSTK
                  _v:="\"
               elseif _v==LETPOWSTK .or. _v==LETEPOWSTK
                  _v:="^"
               elseif _v==LETMODSTK .or. _v==LETEMODSTK
                  _v:="%"
               elseif _v==CMPIGUSTK
                  _v:="="
               elseif _v==CMPLTSTK
                  _v:="<"
               elseif _v==CMPGTSTK
                  _v:=">"
               elseif _v==CMPLETSTK
                  _v:="<="
               elseif _v==CMPGETSTK
                  _v:=">="
               elseif _v==CMPNEQSTK
                  _v:="<>"
               end
            end


            if _v!=REPEAT .and. _v!=UNTIL
               aadd(arr,{dir,(_v),_l})
               ++dir
            end      // para no tener que eliminar una posicion,mejor no lo ingreso

            // si es una UDF, agregar a continuacion codigo de llamado
            if val(_v)>255           // es una puta maraca chupa-bytes UDF
               for _ndxudf:=1 to len(_aMetod)
                  if _v==_aMetod[_ndxudf][4]

                     // Verificar si es thread y si tiene retorno. Si es asi,
                     // pitear altiro, porque un hilo debe ser VOID carajo!!!
                     SW_CALL:="N"
                     if SW_THREAD
                        if _aMetod[_ndxudf][5]!="_"
                           _Error ("Error: Un hilo no debe retornar nada (debe ser VOID), UDF:"+upper(_aMetod[_ndxudf][3]),_l)
                        end
                        // bandera de llamada hilo o normal
                        SW_CALL:="T"
                     end

                     // revisar si esta fuera del cuerpo principal:
                     // si es asi, agregar PUSHL y POPL para cada variable
                     // local que esta UDF tenga (por si hay recursividad)
                     // NO: la idea es poner pushl y popl cuando HAY
                     // recursividad.
                     if _sw_emethod           // desde dentro de una funcion
                        //if !SW_THREAD        // no es thread
                        if SW_RECURSIVE       // hay recursividad??
                        
                          // agrego PUSHL a cada var local
                          for _tl:=1 to len(_varmet)
                             aadd(arr,{dir,"$",_l})    // push data-address
                             ++dir
                             aadd(arr,{dir,strzero(_varmet[_tl][1],_DIR),_l}) // dir de variable
                             ++dir
                             aadd(arr,{dir,PUSHL,_l})  // a pila de locales!!
                             ++dir
                          next
                        end
                     end

                     if !SW_THREAD 
                        aadd(arr,{dir,PUSHD,_l})
                        ++dir
                     end

                     aadd(arr,{dir,"UUUUU",_l})   // direccion de UDF

                     aadd (_dirmet,{dir,_v,SW_CALL})

                     ++dir

                     aadd(arr,{dir,JUDF,_l})    // jmp para UDF
                     ++dir

                     if _sw_emethod           // desde dentro de una funcion
                        if SW_RECURSIVE
                          // agrego POPL acada var local
                          for _tl:=len(_varmet) to 1 step -1
                             aadd(arr,{dir,"$",_l})    // push data-address
                             ++dir
                             aadd(arr,{dir,strzero(_varmet[_tl][1],_DIR),_l}) // dir de variable
                             ++dir
                             aadd(arr,{dir,POPL,_l})  // desde pila de locales!!
                             ++dir
                          next
                        end
                     end
                     SW_THREAD:=.F.
                     exit
                  end

               next

            end
         end

         _v:=SDC(p)


      end


      * CODE
     /*** nuevo ***/ 

      
      if _vCODE!=LET
        /*** solo acepto un IF/ELSE/ENDIF en este caso, por expanmsion ***/
         if code!=IF .and. code!=ELSE .and. code!=EIF
            _vLET:=NULL  // esto erta lo original, antes de la expansion
            SW_IFEXPANSION:=.F.
         else
            SW_IFEXPANSION:=.T.  // nuevo, por expansion
         end
      else

         if len(stk)>1 .and. !SW_IFEXPANSION
            _Error ("Error: Te faltó un operador en la expresión",_l)
         end
         _vIN := SDP(stk)

         if _vLET!=_vIN
            //? "VLET=",_vLET," VIN=",_vIN
            if !(_vLET=="AC".and._vIN=="C") .and. !(_vLET=="AL".and._vIN=="L") ;
               .and. !(_vLET=="AN".and._vIN=="N") .or. ;/* _vLET!="AV".and._vLET=="V" ;*/
               (_vIN=="V" .or. _vIN=="AV")
               _Error ("Error: Tipos distintos no coinciden o no son válidos: "+_vLET+"<>"+_vIN,_l)
            end
           /// _Error ("Error: Tipos distintos en operación de asignación: "+_vLET+"<>"+_vIN,_l)
         end
      end
      if _vCODE==TO  // para el TO para MOV
         _vLET:=SDP(stk)  //Esperado para TO
      end

      asize(stk,0)

    // analizo, segun codigo, los saltos de linea para if, do,while,else_if, etc.
    
      if code == TRY           // atrapa errores en tiempo de ejecucion
         arr[--dir][2]:="DIR_TRY"
         aadd(stk_try,dir)    // guardo dir de exception
         ++dir
         aadd(arr,{dir,TRY,_l})
         ++dir
         stackpush(_DIRTRY,_l)

      
      elseif code == EXCEPTIONS    // analisis de bloque de excepciones
         arr[dir-1][2]:="DIR_EXCEPTION"
         aadd(stk_exception,dir-1)    // guardo dir de exception
         aadd(arr,{dir,JMP,_l})      // salta si no hay exceptions
         ++dir                   // esta es la direccion de TRY
         // extraigo direccion fisica de TRY
         if len(stk_try)==0
      //   if len(stk_try)!=len(stk_exception)
            _Error ("Error: EXCEPTION sin TRY",_l)
         end
         _tl:=stk_try[len(stk_try)]  // ultima direccion conocida
         arr[_tl][2]:=strzero(dir,_DIR)  // engancho direccion si hay exception

      elseif code == TRYAGAIN      // salta a direcion de TRY
         if len(stk_try)>0 //-len(stk_exception)==0   // estoy dentro de TRY
            //if len(stk_try)>0 
               dir:=len(arr)
               _tl:=stk_try[len(stk_try)]
               arr[dir][2]:=strzero(_tl,_DIR)  // engancho direccion si hay exception
                               // uno _tl+2 porque no necesito volver a poner la direccion en
                               // el stack de TRY, esto era un bug que terminaria en error de overflow
                               // si el try se repitiera indefinidamente.
                               // Pero con _tl+2 me dio un error: no permite levantar otra vez.
               ++dir
               aadd(arr,{dir,JMP,_l}) // salte 
               ++dir
            //else
            //   _Error ("Error: No has abierto una Estructura TRY y estás usando ENDT",_l)
            //end
         else
            _Error ("Error: Estructura TRY incorrecta (es posible que falte EXCEPTION)",_l)
         end
      elseif code == ETRY         // cierra bloque de excepciones
         //if len(stk_try)-len(stk_exception)==0
            if len(stk_try)>0 
               SDP(stk_try)
               if len(stk_exception)==0
                  _Error ("Error: Estructura TRY incorrecta (es posible que falte EXCEPTION)",_l)
               end
               _tl:=SDP(stk_exception)
               arr[_tl][2]:=strzero(dir-1,_DIR)  // engancho direccion si hay exception
            else
               _Error ("Error: No has abierto una Estructura TRY y estás usando TEND",_l)
            end
        // else
        //    _Error ("Error: Estructura TRY incorrecta (es posible que falte WRONG)",_l)
        // end
         stackpop(_DIRTRY)
         
      elseif code == SECTOR       // puerta de entrada a porcion de codigo
         dir:=len(arr)
         arr[dir][2]:="FALSOZONE"   // direccion de salto directo.
         // guardo direccion de modulo en stack
         aadd(stk_module,dir)
         ++dir
         aadd(arr,{dir,JNT,_l}) // salte si no es verdad
         ++dir
         stackpush(_DIRSECTOR,_l)

      elseif code == ESECTOR    // limite de porcion de codigo
         // no conviene usar dir porque ira un NOP. apuntar a dir+1
         dir-=2     // elimino ESECTOR
         asize(arr,dir)
         ++dir

         if len(stk_module)==0
            _Error ("Error: Instrucción SEND mal empleada, que mal!",_l)
         else
            _tl:=SDP(stk_module)   // saco la ultima anidaciopn de SECTOR
            arr[_tl][2]:=strzero(dir,_DIR)
         end
         stackpop(_DIRSECTOR)

      elseif code==IF
         stackpush(BXIF,(-1))     // inicio de If y final de reemplazo de dirs
         --dir
         arr[dir][2]:="FALSEIF"   // dir si es falso
         stackpush(AXIF,dir)   // guardo direccion para reemplazar
         ++dir
         aadd(arr,{dir,JNT,_l})
         ++dir
         stackpush(AXIF,"I")     // inicio de lectura de datos if
         stackpush(_DIRIF,_l)

      elseif code==ELSIF
         if len(AXIF)==0
            _Error ("Error: ELSEIF fuera del IF",_l)
         end
         if AXIF[len(AXIF)]=="-2"
            _Error ("Error: No pueden haber dos ELSE en un IF, amermelao!",_l)
         end
         // saltar al final si IF/ELSIF fue verdadero: debo incrustar dos posiciones
         // antes de la expresion de ELSIF para poner DIR y JMP a final.
         aadd(arr,{dir,"*",_l})
         ++dir
         aadd(arr,{dir,"*",_l})
         // muevo la expresion elsif dos posiciones hacia adelante :
         dir:=len(arr)
         for _tl:=dir to t_line+2 step -1  
            arr[_tl][2]:=arr[_tl-2][2]
         next
         // chequear por si hubo UDF's en la linea de ELSIF
         t_orden:=len(_dirmet)
         for _tl:=1 to t_orden
            if arr[_dirmet[_tl][1]][2]!="UUUUU"
               // se corrio dos direcciones
               _dirmet[_tl][1]:=_dirmet[_tl][1]+2
            end
         next
         // Incrusta salto al final del IF/ELSIF si es verdadero
         arr[t_line][2]:="SALTAFINAL"
         stackpush(BXIF,t_line)   // guarda direccion para reemplazar dir final
         arr[t_line+1][2]:=JMP    // JMP: jump!
         t_line += 2              // ajusto nuevo t_line

         // reemplazar direccion de salto de IF/ELSIF si es FALSO
         if (benja:=stackpop(AXIF))!="I"
            if benja!="EI"
               _Error ("Error: Instrucción IF omitida... revisate el ojete, puede estar ahí",_l)
            end
         end
         _tl:=stackpop(AXIF)  // direccion de salto si IF es jarzo
         arr[_tl][2]:=strzero(t_line,_DIR)   // push!

         // guardo posicion de direccion de salto si ELSIF es falso.
         dir:=len(arr)
         arr[dir][2]:="FALSEIF"     // esto pisa "ELSIF"
         stackpush(AXIF,dir)       // guardo direccion para reemplazar
         ++dir
         aadd(arr,{dir,JNT,_l})
         ++dir
         stackpush(AXIF,"EI")       // inicio de lectura de datos while


      elseif code==ELSE
         if len(AXIF)==0
            _Error ("Error: ELSE fuera del IF: si sobra, métetelo en el ojete",_l)
         end
         if AXIF[len(AXIF)]=="-2"
            _Error ("Error: No pueden haber dos ELSE en un IF: el que sobra métetelo en el orto",_l)
         end
         // agregar JMP a final si IF/ELSIF fue verdadero
         --dir
         arr[dir][2]:="SALTAFINAL"
         stackpush(BXIF,dir)   // guarda direccion para reemplazar dir final
         ++dir
         aadd(arr,{dir,JMP,_l})
         ++dir

         // reemplazar direccion de salto de IF/ELSIF si es FALSO
         if (benja:=stackpop(AXIF))!="I"
            if benja!="EI"
               _Error ("Error: Instrucción IF omitida",_l)
            end
         end
         _tl:=stackpop(AXIF)  // direccion desalto si IF es farzo
         arr[_tl][2]:=strzero(dir,_DIR)   // push!
         stackpush(AXIF,"-2")   // fue un else.

      elseif code==EIF
         dir-=2
         ASIZE(arr,dir)      // ajusto tamano para quitar EEVALUATE
         ++dir             // desde aqui en adelante, continue programa

         //  quedo una direccion de falso de elsif (es decir, el hueveta no
         // puso else)?
         if len(AXIF)>0
            _tl:=stackpop(AXIF)
            if _tl!="-2"     // el anterior no es un else
               if _tl=="EI" .or. _tl=="I"
                  _tl:=stackpop(AXIF)  // direccion desalto si IF es farzo
                  arr[_tl][2]:=strzero(dir,_DIR)   // push!
               else               // puede ser otra cosa, lo retorno
                  stackpush(AXIF,_tl)
               end
            end
         end

         // reemplazo esta direccion en todas las que estan dentro de if
         DirExit:=stackpop(BXIF)
         if valtype(DirExit)!="N"
            _Error ("Error: Te ha sobrado un ENDIF (sugerencia: métetelo en el ojete)",_l)
         end
         while DirExit>0
            arr[DirExit][2]:=strzero(dir,_DIR)
            DirExit:=stackpop(BXIF)
         end
         stackpop(_DIRIF)

      elseif code == SELECT        // evaluate
         if _sw_inicio_case
            _Error ("Error: SELECT debe estar dentro de un CASE",_l)
         end

         stackpush(AXBUCLE,t_line)  // donde comienza la expresion
         stackpush(AXBUCLE,"E")

         _sw_case:=.T.       // para identificar el primer case de un evaluate
         _sw_inicio_case:=.T. // para que no haya un evaluate despues de otro inmediatamente

         _sw_others:=.T.     // espera un OTHERS

         dir-=2 //3
         arr[dir][2]:=SELECT    // vuela IS_EQ por EVALUATE!!!
         ASIZE(arr,dir)      // ajusto tamano para quitar EVALUATE
         ++dir
         stackpush(_DIRCASE,_l)
         
      elseif code==CASE
         if _sw_inicio_case  // vacio
            _sw_inicio_case:=.F.
         else        // debiera existir al menosun CASE registrado previamente
            if len(AXCASE)==0
               _Error ("Error: Instrucción CASE sin SELECT",_l)
            end
         end
         // valida que esta dentro de la estructura EVALUATE
         if len(AXBUCLE)==0
            _Error ("Error: Declaraste una weá dentro de otra weá y la weá está mal! (creo que es CASE)",_l)
         end
         if AXBUCLE[len(AXBUCLE)]!="E"
            _Error ("Error: No aisles un CASE dentro de otra instrucción",_l)
         end

         if !_sw_case      // existe un case anterior: poner direccion t_line
            if stackpop(AXCASE)!="OC"
               _Error ("Error: Estructura SELECT/CASE mal construida",_l)
            end
            _tl:=stackpop(AXCASE)    // saco direccion JNT anterior
            arr[_tl][2]:=strzero(t_line,_DIR)
         else
            _sw_case:=.F.  // no existe direccion anterior
         end
         --dir
         arr[dir][2]:="OTROCASE"    // si es falso, va a otra dir
         stackpush(AXCASE,dir) // para reemplazar
         ++dir
         aadd(arr,{dir,JNT,_l})
         ++dir
         stackpush(AXCASE,"OC")

      elseif code==OTHERS
         _sw_others:=.F.       // esta listo
         // el ultimo case debe apuntar al fin y saltarse others.
         --dir
         arr[dir][2]:="FINEVALUATE"              // donde debe salir

         stackpush(AXEXITBUCLE,dir)            // almaceno direccion
         stackpush(AXEXITBUCLE,"BREAK")        // codigo break
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,JMP,_l})                // salto
         ++dir

         // ahora, si el case anterior es falso, salta aqui.

         if stackpop(AXCASE)!="OC"
            _Error ("Error: Instrucción OTHERWISE sin CASE previo",_l)
         end
         _tl:=stackpop(AXCASE)    // saco direccion JNT anterior
         arr[_tl][2]:=strzero(dir,_DIR)

      elseif code==ESELECT
         BX:=stackpop(AXBUCLE)
         if BX!="E"     // ocurrio un problema con la extructura
            _Error ("Error: Instrucción SELECT omitida? (te lo metiste en el orto?)",_l)
         end
         RetornoBucle:=stackpop(AXBUCLE)     // obtiene direccion de ret.
         DirContinue:=RetornoBucle           // mismo lugar
         dir-=2
         ASIZE(arr,dir)      // ajusto tamano para quitar EEVALUATE
         ++dir             // desde aqui en adelante, continue programa

         //  existe others?
         if _sw_others             // no existe others: lo espera aun
            _sw_others:=.F.
            // llena la direccion de ultimo Case
            if stackpop(AXCASE)!="OC"
               _Error ("Error: Instrucción OTHERWISE sin CASE previo",_l)
            end
            _tl:=stackpop(AXCASE)    // saco direccion JNT anterior
            arr[_tl][2]:=strzero(dir,_DIR)
         end

         // Verificar existencia de BREAK y continue
         wBUCLE:=len(AXEXITBUCLE)
         if wBUCLE>0
            if RetornoBucle==AXEXITBUCLE[wBUCLE]
               BuclePadre := stackpop(AXEXITBUCLE)
               TipoExit   := stackpop(AXEXITBUCLE)
               DirExit    := stackpop(AXEXITBUCLE)
               while BuclePadre==RetornoBucle
                  // Tipo de la salida culeada???
                  if TipoExit=="BREAK"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  elseif TipoExit=="CONTINUE" // es CONINTUENJEUNEYLACONCHALALORA
                     arr[DirExit][2]:=strzero(DirContinue,_DIR)
                  else
                     _Error ("Error: No se permite otra salida de SELECT que no sea BREAK",_l)
                  end
                  if len(AXEXITBUCLE)==0
                     exit
                  end
                  if RetornoBucle==AXEXITBUCLE[len(AXEXITBUCLE)]
                     BuclePadre:=stackpop(AXEXITBUCLE)
                     TipoExit   := stackpop(AXEXITBUCLE)
                     DirExit:=stackpop(AXEXITBUCLE)
                  else
                     exit
                  end
               end
            end
         end
         stackpop(_DIRCASE)

      elseif code==SUBRUTINE   //  266
       //  ? "DIR = ",dir-1
       //  ? "_L = ",_l
         dir-=3
       //  ? "DIR-3=",dir,"=",arr[dir][2]
         arr[dir][2]:=NOP // reemplazo "$" por NOP
         ++dir     // obtengo ID de SUB
       //  ? "DIR-2=",dir,"=",arr[dir][2]
         stackpush(AXIDSUB,{arr[dir][2],0}) 
         arr[dir][2]:="JMPSUB"   // direccion de salto a BACK+1
         stackpush(AXDIRSUB,dir)  // guardola direccion de salto para back
         ++dir
       //  ? "DIR-2=",dir,"=",arr[dir][2]
         arr[dir][2]:=JMP
         ++dir      // listo para siguiente instruccion
         AXIDSUB[len(AXIDSUB)][2]:=dir   // direccion de salto para GOSUB.
      /// inkey(0)
       
      elseif code==BACK    // 197  retorno de SUB
      // en VM, BACK recupera la direccion de retorno desde el stack GOSUB, y asigna a CP.
      // luego, aquí se obtiene la direccion donde saltara SUB cuando pase por primera vez.
         if len(AXIDSUB)>0 .and. len(AXDIRSUB)>0
            BX:=stackpop(AXDIRSUB)
      //      ? "DIR---", arr[BX][2]
            arr[BX][2]:=strzero(dir,_DIR)  // reemplazo "JMPSUB" por nueva direccion
         else
            _Error ("Error: BACK no tiene GOSUB, aweonao",_l)
         end
      
      elseif code==GOSUB    // 198   llamada a SUB
         dir-=3  // me ubico sobre "$"
         arr[dir][2]:=NOP   // reemplazo por NOP. no puedo acortar el arreglo.
         // obtengo label de salto:
         ++dir
         BX:=arr[dir][2]
         // planto el GOSUB:
         arr[dir][2]:=GOSUB
         ++dir
         if len(AXIDSUB)>0
            _SUBSW:=.F.
            for xupalorico:=1 to len(AXIDSUB)
               if AXIDSUB[xupalorico][1]==BX
                  arr[dir][2]:=strzero(AXIDSUB[xupalorico][2],_DIR)
                  _SUBSW:=.T.
                  exit
               end
            end
            if !_SUBSW
               _Error ("Error: GOSUB llama a una subrutina no encontrada, merme",_l)
            end
         else
            _Error ("Error: GOSUB llama a una subrutina no encontrada",_l)
         end
         // dejo listo para el ataque:
         ++dir   
         
      elseif code==FWHILE          // while alternativo
         // guardo la expresion en una pila
         dir-=2
         EX:=dir      // excluyo op_code de while
         stackpush(AXBUCLE,"IW")      // inicio de expresion while
         for xupalorico:=EX to t_line step -1    // no borrar esta huea!
             stackpush(AXBUCLE,arr[xupalorico][2])
         next
         ++dir
         arr[dir][2]:="FALSEWHILE"   // dir si es falso
         stackpush(AXBUCLE,dir)  //len(arr))    // guardo direccion para reemplazar
         ++dir
         aadd(arr,{dir,JNT,_l})
         ++dir
         stackpush(AXBUCLE,strzero(dir,_DIR))   // direccion para iteracion
         stackpush(AXBUCLE,"W")     // inicio de lectura de datos while
         stackpush(_DIRWHILE,_l)

      elseif code==EXITIF
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BREAKIF esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BREAKIF no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BREAKIF esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,JT,_l})                 // salto
         ++dir

      elseif code==BREAK                       // sale sin preguntar niunahuea
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BREAK está como chupete en el culo",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BREAK no está bien puesto aquí (póntelo en el recto)",_l)
         end


         --dir
   
         arr[dir][2]:="CODEBREAK"              // donde debe salir

         stackpush(AXEXITBUCLE,dir)            // almaceno direccion
         stackpush(AXEXITBUCLE,"BREAK")        // codigo break
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,JMP,_l})                // salto
         ++dir


      elseif code==BRKZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKZ,_l})                 // salto si es cero
         ++dir

      elseif code==BRKNZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKNZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKNZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKNZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKNZ,_l})                 // salto si no es cero
         ++dir

      elseif code==BRKGZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKGZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKGZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKGZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKGZ,_l})                 // salto si es mayor que cero
         ++dir

      elseif code==BRKGEZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKGEZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKGEZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKGEZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKGEZ,_l})                 // salto si es mayor o igual que cero
         ++dir

      elseif code==BRKLZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKLZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKLZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKLZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKLZ,_l})                 // salto si es menor que cero
         ++dir

      elseif code==BRKLEZ
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: BRKLEZ esta fuera de contexto",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: BRKLEZ no esta bien puesto aquí (póntelo en el orto)",_l)
         else
            if t_orden!="W" .and. t_orden!="E" .and. t_orden!="R" .and. t_orden!="L" 
               _Error ("Error: BRKLEZ esta fuera de contexto",_l)
            end
         end

         --dir
   
         arr[dir][2]:="CODEEXITIF"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)         // almaceno direccion
         stackpush(AXEXITBUCLE,"EXITIF")    // codigo exitif
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,BRKLEZ,_l})             // salto si es menor o igual que cero
         ++dir



      elseif code==CONTINUE                    // continua hueveando
         // verifico que este dentro de While o Evaluate:
         if len(AXBUCLE)==0
            _Error ("Error: CONTINUE está como chupete en el culo",_l)
         end
         t_orden:=AXBUCLE[len(AXBUCLE)]
         if valtype(t_orden)!="C"
            _Error ("Error: CONTINUE no está bien puesto aquí (póntelo en la raja)",_l)
         end

         --dir
   
         arr[dir][2]:="CODECONTINUE"           // donde debe salir

         stackpush(AXEXITBUCLE,dir)            // almaceno direccion
         stackpush(AXEXITBUCLE,"CONTINUE")     // codigo continue
         stackpush(AXEXITBUCLE,AXBUCLE[len(AXBUCLE)-1]) // direccion de bucle padre
         ++dir                                 // apunto a siguiente dir vacia
         aadd(arr,{dir,JMP,_l})                // salto
         ++dir


      elseif code==EFWHILE         // fin de while alternativo
         BX:=stackpop(AXBUCLE)
         if BX!="W"     // ocurrio un problema con la extructura
            _Error ("Error: Se te perdió el WHILE? (Revísate el chiquitín: puede estar ahí)",_l)
         end
         RetornoBucle:=stackpop(AXBUCLE)     // obtiene direccion de ret.
         DirSiFalso:=stackpop(AXBUCLE)     // direccion para falso, (N)
         // obtiene expresion original
         DirExpresion:=stackpop(AXBUCLE)
         dir:=len(arr)
         arr[dir][2]:=DirExpresion
         DirContinue:=dir         // direccion para "continue"
         DirExpresion:=stackpop(AXBUCLE)
         while DirExpresion!="IW"
            ++dir
            aadd(arr,{dir,DirExpresion,_l})
            DirExpresion:=stackpop(AXBUCLE)
         end
         ++dir
   //      ? "RETORNO BUCLE=",RetornoBucle," T_LINE=",t_line, " DIR FIS=",_l
         aadd(arr,{dir,RetornoBucle,_l})
         ++dir
         aadd(arr,{dir,JT,_l})    // vuelve al bucle
         // guardar direccion final para opcion Falso:
         ++dir
         arr[DirSiFalso][2]:=strzero(dir,_DIR)

         // Verificar existencia de Exit_If y exit y continue
         wBUCLE:=len(AXEXITBUCLE)
         if wBUCLE>0
            if RetornoBucle==AXEXITBUCLE[wBUCLE]
               BuclePadre := stackpop(AXEXITBUCLE)
               TipoExit   := stackpop(AXEXITBUCLE)
               DirExit    := stackpop(AXEXITBUCLE)
               while BuclePadre==RetornoBucle
                  // Tipo de la salida culeada???
                  if TipoExit=="EXITIF"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  elseif TipoExit=="BREAK"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  else            // es CONINTUENJEUNEYLACONCHALALORA
                     arr[DirExit][2]:=strzero(DirContinue,_DIR)
                  end
                  if len(AXEXITBUCLE)==0
                     exit
                  end
                  if RetornoBucle==AXEXITBUCLE[len(AXEXITBUCLE)]
                     BuclePadre:=stackpop(AXEXITBUCLE)
                     TipoExit   := stackpop(AXEXITBUCLE)
                     DirExit:=stackpop(AXEXITBUCLE)
                  else
                     exit
                  end
               end
            end
         end
         stackpop(_DIRWHILE)
         
      elseif code==LOOP            // Loop infinito
         // guardo la expresion en una pila

         --dir
         stackpush(AXBUCLE,strzero(dir,_DIR))   // direccion de bucle
         stackpush(AXBUCLE,"L")     // inicio de lectura de datos loop
         ASIZE(arr,dir-1)    //ajusto arr
         stackpush(_DIRLOOP,_l)

      elseif code==ELOOP           // fin de loop
         BX:=stackpop(AXBUCLE)
         if BX!="L"     // ocurrio un problema con la extructura
            _Error ("Error: Se te perdió el LOOP? (Revísate el escroto: ahí está!)",_l)
         end
         RetornoBucle:=stackpop(AXBUCLE) // obtiene direccion de ret.
         
         DirContinue:=RetornoBucle       // direccion para "continue"

         --dir
         arr[dir][2]:=RetornoBucle   // reemplazo ELOOP por direcciÃ³n retorno
         ++dir

         aadd(arr,{dir,JMP,_l})    // vuelve al bucle
         ++dir

         // Verificar existencia de Exit_If y break y continue
         wBUCLE:=len(AXEXITBUCLE)
         if wBUCLE>0
            if RetornoBucle==AXEXITBUCLE[wBUCLE]
               BuclePadre := stackpop(AXEXITBUCLE)
               TipoExit   := stackpop(AXEXITBUCLE)
               DirExit    := stackpop(AXEXITBUCLE)
               while BuclePadre==RetornoBucle
                  // Tipo de la salida culeada???
                  if TipoExit=="EXITIF"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  elseif TipoExit=="BREAK"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  else            // es CONINTUENJEUNEYLACONCHALALORA
                     arr[DirExit][2]:=DirContinue
                  end
                  if len(AXEXITBUCLE)==0
                     exit
                  end
                  if RetornoBucle==AXEXITBUCLE[len(AXEXITBUCLE)]
                     BuclePadre:=stackpop(AXEXITBUCLE)
                     TipoExit   := stackpop(AXEXITBUCLE)
                     DirExit:=stackpop(AXEXITBUCLE)
                  else
                     exit
                  end
               end
            end
         end
         stackpop(_DIRLOOP)

      elseif code==REPEAT               // Repite hasta que se cumpla
         // guardo la expresion en una pila
         stackpush(AXBUCLE,strzero(dir,_DIR))   // direccion de bucle
         stackpush(AXBUCLE,"R")     // inicio de lectura de datos repeat
         stackpush(_DIRDO,_l)

      elseif code==UNTIL            // cumplame, por favor!!!
         BX:=stackpop(AXBUCLE)
         if BX!="R"     // ocurrio un problema con la extructura
            _Error ("Error: Se te perdió el DO? (REvísate el orto: ahí debe estar!)",_l)
         end
         RetornoBucle:=stackpop(AXBUCLE) // obtiene direccion de ret.
         
         DirContinue:=t_line             // direccion para "continue"

         aadd(arr,{dir,RetornoBucle,_l})
         ++dir
         aadd(arr,{dir,JNT,_l})    // vuelve al bucle
         // guardar direccion final para opcion Falso:
         ++dir
         
         // Verificar existencia de Exit_If y break y continue
         wBUCLE:=len(AXEXITBUCLE)
         if wBUCLE>0
            if valtype(AXEXITBUCLE[wBUCLE])!="C"
               _Error ("Error: Se propagó un error desde la concha de la lora (quizás un SELECT abierto). Búscalo jetón!",_l)
            end
            if RetornoBucle==AXEXITBUCLE[wBUCLE]
               BuclePadre := stackpop(AXEXITBUCLE)
               TipoExit   := stackpop(AXEXITBUCLE)
               DirExit    := stackpop(AXEXITBUCLE)
               while BuclePadre==RetornoBucle
                  // Tipo de la salida culeada???
                  if TipoExit=="EXITIF"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  elseif TipoExit=="BREAK"
                     arr[DirExit][2]:=strzero(dir,_DIR)
                  else            // es CONINTUENJEUNEYLACONCHALALORA
                     arr[DirExit][2]:=strzero(DirContinue,_DIR)
                  end
                  if len(AXEXITBUCLE)==0
                     exit
                  end
                  if RetornoBucle==AXEXITBUCLE[len(AXEXITBUCLE)]
                     BuclePadre:=stackpop(AXEXITBUCLE)
                     TipoExit   := stackpop(AXEXITBUCLE)
                     DirExit:=stackpop(AXEXITBUCLE)
                  else
                     exit
                  end
               end
            end
         end
         stackpop(_DIRDO)

      end

      if _sw_udf
         _aMetod[_ptr_udf][2]:=len(arr)-1   //por el NOP
         _sw_udf:=.F.
      end

   next
   if len(AXDIRSUB)>0
      _Error("Error: No has cerrado un GOSUB",stackpop(AXDIRSUB))
   end
   if len(_DIRTRY)>0
      _Error ("Error: No has cerrado un TRY",stackpop(_DIRTRY))
   end
   if len(_DIRLOOP)>0
      _Error ("Error: No has cerrado un LOOP",stackpop(_DIRLOOP))
   end
   if len(AXBUCLE)>0
      _Error ("Error: BREAKIF, BREAK o CONTINUE fuera de contexto, o no cerraste una estructura, don wea",;
           iif(len(_DIRDO)>0,stackpop(_DIRDO),iif(len(_DIRCASE)>0,stackpop(_DIRCASE),iif(len(_DIRWHILE)>0,;
                    stackpop(_DIRWHILE),1))))
   end
   if len(BXIF)>0 .or. len(AXIF)>0
      _Error ("Error: Parece que no cerraste bien un IF o aplicaste mal un ELSEIF, wea",stackpop(_DIRIF))
   end
   if len(stk_module)>0
      _ERROR ("Error: Es posible que no hayas cerrado un sector del AREA51",stackpop(_DIRSECTOR))
   end
   
   // cambiar EWHILE por JMP
   _tl:=len(arr)
   for i:=_TOP_PRG to _tl            // antes empezaba desde "1"
      if arr[i][2]==EWHILE
         arr[i][2]:=JMP
      elseif arr[i][2]==TO .or. arr[i][2]==ELSE .or. ;
             arr[i][2]==EIF .or. ;     
             arr[i][2]==REPEAT   
         arr[i][2]:=NOP
      end

   next
/*   ?
   for i:=1 to len(arr)
     ? arr[i][1],":",arr[i][2],":",arr[i][3]
   next
  */  
   
return arr

Procedure _EvPolaca(cola, pila, p, linErr,cod)  // cola=q, pila=pila
local sw,l,m,_i

   while len(cola)>0

      sw:=.F.
      l:=alltrim(SDC(cola))

      if substr(l,1,1)=="$"
         aadd(p,l)
      else
         if !es_simbolo(l) .and. !es_Lsimbolo(l) .and. ;
            l!="<=" .and. l!=">=" .and. l!="<>" .and. ;
            l!=AND.and.l!=OR.and.l!=XOR
            if es_funcion(l)
               aadd(pila,l)     // es funcion
            else
               _Error ("Error(1): Símbolo no definido ["+l+"]",linErr)
            end
         else
            if l=="("
               aadd(pila,l)
            elseif l $ "+*-/^\%" .or. es_Lsimbolo(l) .or.  ;
               l=="<>" .or. l=="<=" .or. l==">=" .or.;
               l==AND .or. l==OR .or. l==XOR .or. es_funcion(l) 
               while !sw
                  m:=SDP(pila)
                  if m=="("
                     aadd(pila,m)  //mete m en pila
                     aadd(pila,l)  //mete l en pila
                     sw:=.T.; loop //break  //
                    //exit
                  end
                  if l==OR .or. l==AND .or. l==XOR   // conectivo logico
                     __swlogic:=.F.
                     while es_Lsimbolo(m) .or. m=="<>" .or. m=="<=" .or. m==">=";
                        .or. m==OR.or.m==AND.or.l==XOR .or. es_simbolo(m) .and. m!="("
                        if l==OR .and. (m==AND .or. m==XOR)
                           aadd(p,m)
                           aadd(pila,l)
                           __swlogic:=.T.
                           exit
                        elseif l==AND .and. m==OR
                           aadd(pila,m)
                           aadd(pila,l)
                           __swlogic:=.T.
                           exit
                        elseif l==OR.and.m==OR
                           aadd(pila,m)
                           aadd(pila,l)
                           __swlogic:=.T.
                           exit                           
                        else
                           aadd (p,m)
                           m:=SDP(pila)
                        end
                     end
                     if !__swlogic
                        aadd(pila,m)  // pongo el utimo simbolo leido porque no es lsim ni operador
                        aadd (pila,l)
                     end
                     sw:=.T.; loop //break //
                    //exit
                  elseif l=="=" .or. l=="<=" .or. l==">=".or.;
                     l=="<>" .or. l=="<" .or. l==">".or.l=="@"
                        //op. logicos
                     if es_simbolo(m)
                        aadd(p,m)
                        aadd(pila,l)
                     else
                        aadd(pila,m)
                        aadd(pila,l)
                     end
                     sw:=.T.; loop //break //
                     //exit
                  end
                  if l=="^"
                     if m=="^"
                        aadd(p,m)  //mete m en p
                        aadd(p,l)
                     else
                        aadd(pila,m) //mete m en pila
                        aadd(pila,l) //mete l en pila
                        sw:=.T.
                     end
               
                  elseif l=="*" 
                     if es_Lsimbolo(m) .or. m=="<>" .or. m=="<=" .or. m==">="
                        aadd(pila,m)   
                        aadd(pila,l)
                        sw:=.t.
                     elseif m =="^" .or. m=="*" .or. m=="/" .or. m=="\" .or. m=="%" // puede hacer la comparaciÃ³n individual
                        aadd(p,m)   //mete m en p
                     else
                        if es_funcion(m).and. m!=AND.and.m!=OR.and.m!=XOR
                           aadd(p,m)
                        else
                           aadd(pila,m) //mete m en pila
                        end
                        aadd(pila,l) //mete l en pila
                        sw:=.T.
                     end
               
                  elseif l=="/" .or. l=="\" .or. l=="%"
                     if es_Lsimbolo(m).or. m=="<>" .or. m=="<=" .or. m==">="
                        aadd(pila,m)   
                        aadd(pila,l)
                        sw:=.t.
                     elseif m=="*".or.m=="^".or.m=="/" .or. m=="\".or. m=="%" 
                        aadd(p,m)     //mete l en p
                        aadd(pila,l) //mete m en pila
                        sw:=.T.
                     else
                        if es_funcion(m).and. m!=AND.and.m!=OR.and.m!=XOR
                           aadd(p,m)
                        else
                           aadd(pila,m) //mete m en pila
                        end
                        aadd(pila,l) //mete l en pila
                        sw:=.T.
                     end
                
                  elseif l=="+" .or. l=="-"
                     if es_Lsimbolo(m) .or. m=="<>" .or. m=="<=" .or. m==">=";
                        .or. m==OR .or. m==AND .or. m==XOR
                        aadd(pila,m)   
                        aadd(pila,l)
                     else  
                        aadd(p,m)       //mete m en p
                        aadd(pila,l)    //mete l en pila
                     end
                     sw:=.T.
           
               // -------  Y si es funcion?
                  elseif es_funcion(l)
                     aadd(pila,m)
                     aadd(p,l)
                     sw:=.T.
               // -------------------------
                  end
               end   // while

               if len(pila)==0 
                  aadd(pila,"(")   //mete cen en pila
               end
            elseif l==")"          // es un parentesis derecho?
               m:=SDP(pila)        // extrae de pila para m
               while m!="(" 
                  aadd(p,m)        //mete m en p
                  m:=SDP(pila)     // extrae de pila para m
                  if m==nil
                     _Error ("Error: Expresión matemática mutante",linErr)
                  end
               end
               if len(pila)>0
                  m:=SDP(pila)
                  if es_funcion(m)
                     aadd(p,m)
                  else
                     aadd(pila,m)   // regresa a pila
                  end
               end
            end
         end
      end
   end
   if len(pila)>0
      m:=SDP(pila)
      while m!="("
         aadd(p,m)
         m:=SDP(pila)
      end
   end

return

function _LlenaPila(expr,numlin,code)
local arr:={},c,cc,w, sw,i
local cta_par:=0

   sw:=.F.
   i:=1
   // un caracter es digito, "$", "()" u operador: nada mas
   //? "LlenaPila="+expr
/*   if code==SELECT.or.code==IF.or.code==FWHILE  // debugueo
      ? "EXPR:",expr
   end */
   while !empty(expr)
      c:=_SacaChar(@expr,1)

      if c=="("
         ++cta_par
      elseif c==")"
         --cta_par
      end
      
      if c=="?"   // se lo salta
         loop
      end

      if c=="$"    // es variable. Extraigo siguientes 3 caracteres
         aadd (arr,c+_SacaChar(@expr,_DIR))   // guardo con simbolo

      elseif es_simbolo(c)
         aadd (arr,c)

      elseif es_Lsimbolo(c)
            cc := _SacaChar(@expr,1)
            if es_Lsimbolo(cc)   // es un operador logico compuesto
               // analizar combinaciones validas
               if c=="<"
                   if cc==">" .or. cc=="="
                      aadd (arr,c+cc)
                   else
                      _Error ("Error(1): Símbolo no reconocido puesto como operador lógico ["+c+cc+"]",numlin)
                   end
               elseif c==">"
                   if cc=="="
                      aadd (arr,c+cc)
                   else
                      _Error ("Error(2): Símbolo no reconocido puesto como operador lógico ["+c+cc+"]",numlin)
                   end
               else
                   _Error ("Error(3): Símbolo no reconocido puesto como operador lógico ["+c+cc+"]",numlin)
               end
            else
               expr:=cc+expr   // devuelvo caracter extraido
               aadd (arr,c)    // agregado 
            end

      elseif isdigit(c) 
         aadd (arr,c+_SacaChar(@expr,_DIR-1))    // por que 2?

      else
         if c!=" " .and. c!="," 
            _Error ("Error: Error de sintaxis (quizás no declaraste una variable): "+c+"-"+expr,numlin)
         end
      end
   end


   // evalua si hay parentesis de mas o de menos
   if cta_par!=0
      _Error ("Error: Paréntesis desbalanceados. P.e., si querías: '()*()' y escribiste: '( *()'...",numlin)
   end
   


   aadd (arr,")")

return arr

function es_Lsimbolo(c)
local _ret:=.F.

   if c=="=" .or. c=="<" .or. c==">".or.c=="@" 
      _ret:=.T.
   end

return _ret

function es_simbolo(c)
local _ret:=.F.

   if c=="+" .or. c=="-" .or. c=="*" .or. c=="/" .or.c=="\".or.c=="%".or.;
      c==")" .or. c=="(" .or. c=="^"
      _ret:=.T.
   end

return _ret

function es_funcion(arg)
local _i,_pos:=0,_ret:=.F.

_pos:=Ascan(DICC, {|Aval| upper(aVal[2])==upper(arg)})
if _pos>0
    _ret:=.T.
end
return _ret

function _SacaChar(expr,cant)
local w
   w:=substr(expr,1,cant)
   expr:=substr(expr,cant+1,len(expr))
return w

function _PREPROCESO(_l)
local f1:=.t.,f2:=.t.,f3:=.t.,f4:=.t.,f5:=.t.,f6:=.t.,f7:=.t.,f8:=.t.,f9:=.t.,f10:=.t.
local f11:=.t.,f12:=.t.,f13:=.t.,f14:=.t.,f15:=.t.,f16:=.t.,f17:=.t.,f18:=.t.
// preprocesos...

if _SW_TRIGS
   while "trg." $ _l
     if f11; f11:=.f.
        if "trg.d2r" $_l
        _l:=strtran(_l,"trg.d2r", "trg_code 4 ")   // d2r = code 4
        loop
        end
     elseif f12; f12:=.f.
        if "trg.r2d" $_l
        _l:=strtran(_l,"trg.r2d", "trg_code 5")   // r2d = code 5
        loop
        end
     elseif f1; f1:=.f.
        if "trg.asin" $ _l
           _l:=strtran(_l,"trg.asin", "htrg_code 1 ")
           loop
        end
     elseif f2; f2:=.f.
        if "trg.acos" $ _l
           _l:=strtran(_l,"trg.acos", "htrg_code 2 ")
           loop
        end
     elseif f3; f3:=.f.
        if "trg.atan" $ _l
           _l:=strtran(_l,"trg.atan", "htrg_code 3")
           loop
        end
     elseif f4; f4:=.f.
        if "trg.sinh" $ _l
           _l:=strtran(_l,"trg.sinh", "htrg_code 4")
           loop
        end
     elseif f5; f5:=.f.
        if "trg.cosh" $_l
        _l:=strtran(_l,"trg.cosh", "htrg_code 5")
        loop
        end
     elseif f6; f6:=.f.
        if "trg.tanh" $_l
        _l:=strtran(_l,"trg.tanh", "htrg_code 6")
        loop
        end
     elseif f10; f10:=.f.
        if "trg.cot" $_l
        _l:=strtran(_l,"trg.cot", "trg_code 6")   // cot = code 6
        loop
        end
     elseif f7; f7:=.f.
        if "trg.sin" $_l
        _l:=strtran(_l,"trg.sin", "trg_code 1 ")   // sin = code 1
        loop
        end
     elseif f8; f8:=.f.
        if "trg.cos" $_l
           _l:=strtran(_l,"trg.cos", "trg_code 2 ")  // cos = code 2
        loop
        end
     elseif f9 ; f9:=.f.
        if "trg.tan" $_l
        _l:=strtran(_l,"trg.tan", "trg_code 3 ")  // tan = code 3
        loop
        end
     else
        exit
     end
   end
end
f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.;f10:=.t.
f11:=.t.;f12:=.t.;f13:=.t.;f14:=.t.;f15:=.t.;f16:=.t.;f17:=.t.;f18:=.t.;f19:=.t.

if _SW_MATHS
   while "mth." $ _l
     if f1; f1:=.f.
        if "mth.int" $ _l
        _l:=strtran(_l,"mth.int",  "math_code 1 ")
        loop
        end
     elseif f13; f13:=.f.
        if "mth.rand" $ _l
        _l:=strtran(_l,"mth.rand",     "tmath_code 1 ")
        loop
        end
     elseif f19; f19:=.f.
        if "mth.seed" $ _l
        _l:=strtran(_l,"mth.seed",     "tmath_code 1 ")
        loop
        end
     elseif f2; f2:=.f.
        if "mth.abs" $ _l
        _l:=strtran(_l,"mth.abs",  "math_code 6 ")
        loop
        end
     elseif f4; f4:=.f.
        if "mth.sqrt" $ _l
        _l:=strtran(_l,"mth.sqrt", "math_code 2 ")
        loop
        end
     elseif f6; f6:=.f.
        if "mth.log" $ _l
        _l:=strtran(_l,"mth.log",  "math_code 4 ")
        loop
        end
     elseif f8; f8:=.f.
        if "mth.ln" $ _l
        _l:=strtran(_l,"mth.ln",   "math_code 5 ")
        loop
        end
     elseif f5 ; f5:=.f.
        if "mth.exp" $ _l
        _l:=strtran(_l,"mth.exp",  "math_code 3 ")
        loop
        end
     elseif f3 ; f3:=.f.
        if "mth.sgn" $ _l
        _l:=strtran(_l,"mth.sgn",  "math_code 7 ")
        loop
        end
     elseif f17; f17:=.f.
        if "mth.ceil" $ _l
        _l:=strtran(_l,"mth.ceil",    "tmath_code 2 ")
        loop
        end
     elseif f18; f18:=.f.
        if "mth.floor" $ _l
        _l:=strtran(_l,"mth.floor",   "tmath_code 3 ")
        loop
        end
     elseif f7; f7:=.f.
        if "mth.round" $ _l
        _l:=strtran(_l,"mth.round", "round")
        loop
        end
     elseif f9; f9:=.f.
        if "mth.min" $ _l
        _l:=strtran(_l,"mth.min",  "minmax_code 1 ")
        loop
        end
     elseif f10; f10:=.f.
        if "mth.max" $ _l
        _l:=strtran(_l,"mth.max",  "minmax_code 2 ")
        loop
        end
     elseif f11; f11:=.f.
        if "mth.gcd" $ _l
        _l:=strtran(_l,"mth.gcd",  "xummcd ")  // máximo comun divisor
        loop
        end
     elseif f12; f12:=.f.
        if "mth.lcm" $ _l
        _l:=strtran(_l,"mth.lcm",  "xummcm ")  // mínimo común multiplo
        loop
        end
     elseif f14; f14:=.f.
        if "mth.cels" $ _l
        _l:=strtran(_l,"mth.cels", "tmath_code 4 ")
        loop
        end
     elseif f15; f15:=.f.
        if "mth.fahr" $ _l
        _l:=strtran(_l,"mth.fahr",  "tmath_code 5 ")
        loop
        end
     elseif f16; f16:=.f.
        if "mth.setdelta" $ _l
        _l:=strtran(_l,"mth.setdelta",   "tmath_code 6 ")
        loop
        end
     else
        exit
     end
   end
end

f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.

if _SW_BITS     // argumentos de bits y meta codigos
  while .T.
     if f1; f1:=.f.
        if"(BIT" $ _l
        _l:=strtran(_l,"(BIT",  "bit_code( 1 ") // devulve 1 o 0
        loop
        end
     elseif f2; f2:=.f.
        if "(XOR" $ _l
        _l:=strtran(_l,"(XOR",  "bit_code( 2 ") 
        loop
        end
     elseif f3; f3:=.f.
        if "(OR" $ _l
        _l:=strtran(_l,"(OR",   "bit_code( 8 ") 
        loop
        end
     elseif f4; f4:=.f.
        if "(AND" $ _l
        _l:=strtran(_l,"(AND",  "bit_code( 3 ") 
        loop
        end
     elseif f5; f5:=.f.
        if "(<<" $ _l
        _l:=strtran(_l,"(<<",  "bit_code( 4 ") 
        loop
        end
     elseif f6; f6:=.f.
        if "(>>" $ _l
        _l:=strtran(_l,"(>>",  "bit_code( 5 ") 
        loop
        end
     elseif f7  ; f7:=.f.
        if "(OFF" $ _l
        _l:=strtran(_l,"(OFF",  "bit_code( 6 ")
        loop
        end
     elseif f8 ; f8:=.f.
        if "(ON" $ _l
        _l:=strtran(_l,"(ON",   "bit_code( 7 ")
        loop
        end
     elseif f9; f9:=.f.
        if "(NOT" $ _l
        _l:=strtran(_l,"(NOT",    "bitnot( ")
        loop
        end
     else
        exit
     end
  end
end
        // preproceso funciones de Fecha
f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.;f10:=.t.
f11:=.t.;f12:=.t.

if _SW_DATES
   while "date." $ _l
     if f1 ; f1:=.f.
        if "date.bquarter" $ _l
        _l:=strtran(_l,"date.bquarter",   "tdate_code 2 ") //s
        loop
        end
     elseif f2; f2:=.f.
        if "date.equarter" $ _l
        _l:=strtran(_l,"date.equarter",   "tdate_code 3 ") //s
        loop
        end
     elseif f3; f3:=.f.
        if "date.sdweek" $ _l
        _l:=strtran(_l,"date.sdweek",   "tdate_code 4 ") //S
        loop
        end
     elseif f4; f4:=.f.
        if "date.smonth" $ _l
        _l:=strtran(_l,"date.smonth",   "tdate_code 5 ") //s
        loop
        end
     elseif f5 ; f5:=.f.
        if "date.quarter" $ _l
        _l:=strtran(_l,"date.quarter",    "tdate2_code 1 ")//n
        loop
        end
     elseif f6; f6:=.f.
        if "date.day" $ _l
        _l:=strtran(_l,"date.day",      "tdate2_code 2 ") //n
        loop
        end
     elseif f7; f7:=.f.
        if "date.month" $ _l
        _l:=strtran(_l,"date.month",    "tdate2_code 3 ") //n
        loop
        end
     elseif f8; f8:=.f. 
        if "date.year" $ _l
        _l:=strtran(_l,"date.year",     "tdate2_code 4 ")//n
        loop
        end
     elseif f9 ; f9:=.f.
        if "date.ndweek" $ _l
        _l:=strtran(_l,"date.ndweek",    "tdate2_code 5 ")//n
        loop
        end
     elseif f10; f10:=.f.
        if "date.week" $ _l
        _l:=strtran(_l,"date.week",     "tdate2_code 7 ")  //n
        loop
        end
     elseif f11 ; f11:=.f.
        if "date.dyear" $ _l
        _l:=strtran(_l,"date.dyear",     "tdate2_code 6 ") //n
        loop
        end
     elseif f12; f12:=.f. 
        if "date.dmonth" $ _l
        _l:=strtran(_l,"date.dmonth",   "tdate2_code 8 ") //n
        loop
        end
     else
        exit
     end
  end
end

f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.

if _SW_BASES
  while .t.
     if f1;f1:=.f.
        if "(BDx" $ _l
        _l:=strtran(_l,"(BDx",    "xcode2_nc( 2 ")   // binario a decimal
        loop
        end
     elseif f2;f2:=.f.
        if "(HDx" $ _l
        _l:=strtran(_l,"(HDx",    "xcode2_nc( 3 ")   // hexa a decimal
        loop
        end
     elseif f3;f3:=.f. 
        if "(ODx" $ _l
        _l:=strtran(_l,"(ODx",    "xcode2_nc( 4 ")  // octal a decimal
        loop
        end
     elseif f4;f4:=.f.
        if "(Hx" $ _l
        _l:=strtran(_l,"(Hx",    "xcode_cn( 2 ")
        loop
        end
     elseif f5;f5:=.f.
        if "(Ox" $ _l
        _l:=strtran(_l,"(Ox",   "xcode_cn( 3 ")
        loop
        end
     elseif f6;f6:=.f.
        if "(Bx" $ _l
        _l:=strtran(_l,"(Bx",     "xcode_cn( 5 ")
        loop
        end
     else
        exit
     end
  end
end

      // pilas, colas
f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.

if _SW_STACKS
   while "stk." $ _l
     if f1; f1:=.f.
        if "stk.ins" $ _l
        _l:=strtran(_l,"stk.ins", "tfstk_code 5 1 ")  // inserta un elemento. solo en vectores
        loop
        end
     elseif f2 ; f2:=.f.
        if "stk.del" $ _l
        _l:=strtran(_l,"stk.del", "tfstk_code 6 1 ")  // borra un elemento. solo en vectores
                                           // 1=codigo fantasma para que pueda ser procesado
        loop
        end
     elseif f3; f3:=.f.
        if "stk.top" $ _l
        _l:=strtran(_l,"stk.top",   "(trstk_code 1)") // devuelve el elemento tope del stack, sea queue o deque
        loop
        end
     elseif f4; f4:=.f. 
        if "stk.min" $ _l
        _l:=strtran(_l,"stk.min",  "meta_sminmax 2 ")  // minimo lista
        loop
        end
     elseif f5; f5:=.f. 
        if "stk.max" $ _l
        _l:=strtran(_l,"stk.max",  "meta_sminmax 1 ") // maximo lista
        loop
        end
     else
        exit
     end
  end
end
           
f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.

if _SW_SETS
  while "set" $ _l
     if f1;f1:=.f.
        if "setunion" $ _l
        _l:=strtran(_l,"setunion",  "setcode 1 ")  // union
        loop
        end 
     elseif f2;f2:=.f.
        if "setinter" $ _l
        _l:=strtran(_l,"setinter",  "setcode 2 ")  // interseccion
        loop
        end
     elseif f3;f3:=.f.
        if "setdiff" $ _l
        _l:=strtran(_l,"setdiff",  "setcode 3 ")  // diferencia
        loop
        end
     elseif f4;f4:=.f. 
        if "setsdiff" $ _l
        _l:=strtran(_l,"setsdiff",  "setcode 4 ") // diferencia simetrica
        loop
        end
     else
        exit
     end
  end
end               
     // codigo de familia XCODE_NC
f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.;f10:=.t.///;f11:=.t.

if _SW_STRINGS
  while "str" $ _l 
     if f1;f1:=.f.
        if "strlen" $ _l
        _l:=strtran(_l,"strlen",       "xcode_nc 1 ")   // len
        loop
        end
     elseif f2;f2:=.f.
        if "strtrim" $ _l
        _l:=strtran(_l,"strtrim",      "xcode_cc 6 ")
        loop
        end
     elseif f3 ;f3:=.f. 
        if "strupper" $ _l
        _l:=strtran(_l,"strupper",        "xcode_cc 1 ")  // upper case
        loop
        end
     elseif f4 ;f4:=.f. 
        if "strlower" $ _l
        _l:=strtran(_l,"strlower",        "xcode_cc 2 ") // lower case
        loop
        end
     elseif f5 ;f5:=.f.
        if "strwcount" $ _l
        _l:=strtran(_l,"strwcount",        "xcode_nc 2 ")  // cuenta palabras
        loop
        end
     elseif f6;f6:=.f.
        if "strntok" $ _l
        _l:=strtran(_l,"strntok",      "xcode_nc 3 ")
        loop
        end
     elseif f7 ;f7:=.f.
        if "strlcount" $ _l
        _l:=strtran(_l,"strlcount",      "xcode2_nc 1 ")  // cuenta lineas de un string
        loop
        end
     elseif f8 ;f8:=.f.
        if "strcount" $ _l
        _l:=strtran(_l,"strcount",        "xcode2_nc 5 ")   // cuenta caracteres (strcc v) --> (cc v (flag "LU U L N simbolos"))
        loop
        end

     elseif f9;f9:=.f.
        if "strerac" $ _l
        _l:=strtran(_l,"strerac",      "xcode_cc 3 ")  // elimina caracteres
        loop
        end
     elseif f10 ;f10:=.f. 
        if "strrev" $ _l
        _l:=strtran(_l,"strrev",       "xcode_cc 6 ")  // reversa
        loop
        end
     else
        exit
     end
   end
end

f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.;f10:=.t.;f11:=.t.;f12:=.t.;f13:=.t.
f14:=.t.
 
if _SW_MATRIXS
  while "mat." $ _l
     if f1; f1:=.f.
        if "mat.load" $ _l   
        _l:=strtran(_l,"mat.load",     "xvtmatfile 2 ")
        loop
        end
     elseif f2; f2:=.f.
        if "mat.save" $ _l   
        _l:=strtran(_l,"mat.save",     "xvtmatfile 1 ")
        loop
        end
     elseif f3; f3:=.f.  
        if "mat.mean" $ _l
        _l:=strtran(_l,"mat.mean",     "tstats_code 1 ")// media
        loop
        end
     elseif f4 ; f4:=.f.
        if "mat.sum" $ _l
        _l:=strtran(_l,"mat.sum",      "tstats_code 2 ") // sumatoria
        loop
        end
     elseif f5; f5:=.f. 
        if "mat.row" $ _l
        _l:=strtran(_l,"mat.row",   "tfstk_code 1 ") // col
        loop
        end
     elseif f6 ; f6:=.f. 
        if "mat.col" $ _l
        _l:=strtran(_l,"mat.col",   "tfstk_code 2 ")// row
        loop
        end
     elseif f7; f7:=.f.
        if "mat.pg" $ _l
        _l:=strtran(_l,"mat.pg",  "tfstk_code 3 ")  // page
        loop
        end
     elseif f8 ; f8:=.f. 
        if "mat.bk" $ _l
        _l:=strtran(_l,"mat.bk", "tfstk_code 4 ") // block
        loop
        end
     elseif f9; f9:=.f.
        if "mat.get" $ _l
        _l:=strtran(_l,"mat.get",   ".getdata" )   //"get ")
        loop
        end
     elseif f10 ; f10:=.f.
        if "mat.put" $ _l
        _l:=strtran(_l,"mat.put",   ".putdata ")  //"put <dato>")
        loop
        end
     elseif f11 ; f11:=.f.
        if "mat.append" $ _l
        _l:=strtran(_l,"mat.append",   "xvtmatfile 3 ")  //Append file
        loop
        end
     elseif f12 ; f12:=.f.
        if "mat.min" $ _l
        _l:=strtran(_l,"mat.min",   "minmaxmat_code 1 ")  //min
        loop
        end
     elseif f13 ; f13:=.f.
        if "mat.max" $ _l
        _l:=strtran(_l,"mat.max",   "minmaxmat_code 2 ")  //max
        loop
        end
     elseif f14 ; f14:=.f.
        if "mat.equal" $ _l
        _l:=strtran(_l,"mat.equal",   "minmaxmat_code 3 ")  //equal
        loop
        end
     else
         exit
     end
  end
end

f1:=.t.;f2:=.t.;f3:=.t.;f4:=.t.;f5:=.t.;f6:=.t.;f7:=.t.;f8:=.t.;f9:=.t.;f10:=.t.
f11:=.t.;f12:=.t.;f13:=.t.;f14:=.t.;f15:=.t.;f16:=.t.;f17:=.t.;f18:=.t.;f19:=.t.;f20:=.t.
f21:=.t.

if _SW_MISC  // estas son estándar: siempre van
  while .T.
     if f1 ; f1:=.f.
        if "date2ansi" $ _l
           _l:=strtran(_l,"date2ansi",       "tdate_code 1 ") 
           loop
        end
     elseif f2; f2:=.f.
        if "ansi2date" $ _l
           _l:=strtran(_l,"ansi2date",     "xcode_cc 4 ")
           loop
        end
     elseif f3; f3:=.f.
        if "($" $ _l
           _l:=strtran(_l,"($",     "xtostr( ")  // convierte numero a string
           loop
        end
     elseif f4 ; f4:=.f.
        if "(#" $ _l
           _l:=strtran(_l,"(#",     "xtonum( ") // convierte string a numero
           loop
        end
     elseif f5; f5:=.f.
        if "(%" $ _l
           _l:=strtran(_l,"(%",     "xtobool( ")   // convierte cualquier cosa a bool según CONTEXT_TRUE
           loop
        end
     elseif f15; f15:=.f.
        if "(^" $ _l
           _l:=strtran(_l,"(^",     "xtostack( ")   // convierte cualquier cosa a stack
           loop
        end
     elseif f16; f16:=.f.
        if "(?" $ _l
           _l:=strtran(_l,"(?",     "xtovariant( ")   // convierte cualquier cosa a variante
           loop
        end
        
     elseif f6;f6:=.f.
        if "asc" $ _l
           _l:=strtran(_l,"asc",           "xcode_nc 4 ")  // ASC "A" --> 65
           loop
        end
       // preproceso "#"
     elseif f7;f7:=.f.
        if "chr" $ _l
           _l:=strtran(_l,"chr",           "xcode_cn 1 ")  // CHR(65) --> "A"
           loop
        end
     elseif f8; f8:=.f.
        if "rawinput" $ _l
           _l:=strtran(_l,"rawinput",    "xcode_ccc 3 ")  // read input
           loop
        end
     elseif f9; f9:=.f.
        if "crypt" $ _l
           _l:=strtran(_l,"crypt",             "xcode_ccc 1 ")
           loop
        end
     elseif f10; f10:=.f.
        if "elaptime" $ _l
           _l:=strtran(_l,"elaptime",          "xcode_ccc 2 ")
           loop
        end
     elseif f11; f11:=.f.
        if "sec2time" $_l
           _l:=strtran(_l,"sec2time",    "xcode_cn 4 ")  // convierte 7200 segundos en "02:00:00" minutos
           loop
        end
     elseif f12; f12:=.f. 
        if "queue" $ _l
           _l:=strtran(_l,"queue",  "tstk_code 6 1") // modalidad cola
           loop
        end
     elseif f13 ;f13:=.f. 
        if "deque" $ _l
           _l:=strtran(_l,"deque",  "tstk_code 7 1") //modalidad pila
           loop
        end 
     elseif f14; f14:=.f. 
        if "drop" $ _l
           _l:=strtran(_l,"drop",  "tstk_code 5 1")   // vacia la lista
           loop
        end
     elseif f17; f17:=.f. 
        if "wpop" $ _l
           _l:=strtran(_l,"wpop",  "cwm2let ")   // recupera un dato desde el stack de trabajo
           loop
        end
     elseif f18; f18:=.f.
        if "(int" $ _l
        _l:=strtran(_l,"(int", "(tcast_code 0 ")  // caseta a int
        loop
        end
     elseif f19 ; f19:=.f.
        if "(long" $ _l
        _l:=strtran(_l,"(long", "(tcast_code 1 ")  // castea a long
        loop
        end
     elseif f20; f20:=.f.
        if "(double" $ _l
        _l:=strtran(_l,"(double",   "(tcast_code 2 ") // castea a double
        loop
        end
     elseif f21 ;f21:=.f.
        if "e2d" $ _l
        _l:=strtran(_l,"e2d",        "xcode2_nc 6 ")   // devuelve numero normal de notacion científica
        loop
        end
     else
        exit
     end
     // existe use, push y pop, use que son universales.
  end
end
return _l

procedure _Reempl_Ampersand()
local i,j,k, _nl,l,_laMeto, _MAK, _MBK, _lnexe

_nl := len(_lineexe)
_laMeto:=len(_aMetod)

for k:=1 to _laMeto
  _MAK:=_aMetod[k][1]
  _MBK:=_aMetod[k][2]
  if _MAK>0
     for i:=_MAK to _MBK
        _lineexe[i][1]:=strtran(_lineexe[i][1],"@@@","")
     next
  end
next

return

function _BuscaInstr(v)
local _n:=0,i,l

    //?" BUSCA = ",v
    l:=len(DICC) //239      //len(DICC)
    i:=1
    while i<=l
      // ? "INSTRUCCION = ",DICC[i][1]
       if DICC[i][1]==v
          _n:=i
          exit
       end
       i++
    end

return _n

function _BuscaVar(_n,_metlocal)
local _ret:=0,i

 if _NHASH>0
   for i:=_IniVar to _NHASH
      if _hash[i][1]==_metlocal
         if _hash[i][3]==_n
            _ret:=_hash[i][6]        //i
            exit
         end
      end
   next
 end

return _ret

function _BuscaStr(_n)
local _ret:=0,i

 if _NHASH> 0  //_IniStr
   for i:=1 to _NHASH
      if _hash[i][3]==_n
         _ret:=_hash[i][6]        //i
         exit
      end
   next
 end

return _ret

function _TBuscaStr(_ML,_n)
local _ret:=0,i,l

 l:=len(_Thash)
 _ML:=lower(_ML)
 if l>0  //_IniStr
   if _ML!="*"
      for i:=1 to l
         if lower(_Thash[i][1])==_ML
            if _Thash[i][3]==_n
               _ret:=_Thash[i][6]        //i
               exit
            end
         end
      next
   else
      if valtype(_n)=="N"
         for i:=1 to l
            if _Thash[i][4]=="N"
               if val(_Thash[i][3])==_n
                  _ret:=_Thash[i][6]        //i
                  exit
               end
            end
         next
      else
         for i:=1 to l
            if _Thash[i][3]==_n
               _ret:=_Thash[i][6]        //i
               exit
            end
         next
      end
   end
 end

return _ret

/*
function _Reempl_controles_de_string(cad)

  cad:=strtran(cad, "\n",HB_OSNewLine())     //chr(13)+chr(10))
  cad:=strtran(cad, "\t","        ")
// revisar estos caracteres segun el SO:
  cad:=strtran(cad, "\b",chr(8)) //+chr(8)+chr(8)+chr(8)+chr(8)+chr(8)+chr(8)+chr(8)+chr(8))
//  cad:=strtran(cad, "\d",chr(8))  // retrocede un caracter
  cad:=strtran(cad, "\a",chr(7))  // bip

return cad*/

function XBUSCACONST(linea,METLOC,_EDIR)
LOCAL vLinea:="",vLen,i,c,l
LOCAL pString,pNumber,pSimbolo,pInstr,tInstr
LOCAL nHash,swExiste///,anteriorLeido

if "@@@" $ linea
   return linea
end

vLen:=len(linea)
i:=1

//anteriorLeido:=0  // 0=inicia, 1=numero, 2=string, 3=instruccion, 4=signo +-, 5=operador logico
                  // me dirá algo sobre el signo "-" que encuentre (si es binario o unario)
//? "<--",linea
while i<=vLen
  pString:=NULL  // cadena encontrada
  pNumber:=NULL
  pSimbolo:=NULL
  nHash:=NULL
  pInstr:=NULL
  tInstr:=NULL
  c:=substr(linea,i,1)
//  ?"CARACTER=",c
//  inkey(0)
  if c=="$"   // ya fue analizado: es un simbolo reconocido
        pSimbolo+=c
        c:=substr(linea,++i,1)
        while isdigit(c) .and. i<=vLen
           pSimbolo+=c
           c:=substr(linea,++i,1)
        end
        --i
        vlinea+=" "+pSimbolo+" "
  elseif c=='"'  // es un string:
        pString+=c
        c:=NULL
        while ++i<=vLen .and. c!='"'
           c:=substr(linea,i,1)
           if c=="\"
              c:=substr(linea,++i,1)
              if c=="n"
                 pString+=hb_osnewline()
              elseif c=="t"
                 pString+="        "
              elseif c=='"'
                 pString+="\'"  //c
                 c:=""
              else
                 pString+="\"+c
              end
           else
             // if c!='"'
                 pString+=c
             // end
           end
        end
      //  ? "VLINEA = ",vlinea
      //  ? "STRING = ",pString
        if c!='"'   // aunque no es necesario porque ya se vio en carga, igual va.
           return "ERR-1"+pString  // CADENA SIN CERRAR
        else  // veo si existe en tabla de variables
           //nHash:=_TBuscaStr(METLOC, pString)
           nHash:=_TBuscaStr("*", pString)
           if nHash>0
              vlinea+=" $"+strzero(nHash,_DIR)+" "
           else     // no existe: push!!
              aadd (_Thash,{METLOC,"*",pString,"C","*",++_EDIR,"*"})
              vlinea+=" $"+strzero(_EDIR,_DIR)+" "
              _NHASH:=len(_hash)
           end
        end
        --i
  elseif isdigit(c)  // numero, normal
        pNumber+=c
        c:=substr(linea,++i,1)
        while isdigit(c).or.c==".".and. i<=vLen
           pNumber+=c
           c:=substr(linea,++i,1)
        end
        
        --i   // ajusto por caracter distinto de digito para que sea leido otra vez
        if ISTNUMBER(pNumber)==0
           return "ERR-2"+pNumber    // no es un numero valido
        end
        ///nHash:=_TBuscaStr(METLOC,val(pNumber))
        nHash:=_TBuscaStr("*",val(pNumber))
        if nHash>0
           vlinea+=" $"+strzero(nHash,_DIR)+" "
        else
           aadd (_Thash,{METLOC,"*",pNumber,"N","*",++_EDIR,"*"})
           vlinea+=" $"+strzero(_EDIR,_DIR)+" "
           _NHASH:=len(_hash)
        end
  elseif c == "+"
        c:=substr(linea,++i,1)
        if c=="+"  // es un "FINC"
           vlinea+=" @@@"+DICC[96][2]+" "
        else
           vlinea+="+"
           --i
        end
  elseif c == "-"
        c:=substr(linea,++i,1)
        if c=="-"  // es un "FDEC"
           vlinea+=" @@@"+DICC[97][2]+" "
        else
           vlinea+="-"
           --i
        end
  elseif c == "!" .or. c == "~"   // factorial y negacion
        nHash := _BuscaInstr(c)     // es instruccion?
        if nHash>0     // es una instruccion: guarda y sigue
           vlinea+=" @@@"+DICC[nHash][2]+" "
        end
  elseif c == "." .or. isalpha(c) .or. c=="_"  // OJO: PUEDE TRATARSE DE UNA FUNCION DE USUARIO
        pInstr+=c
        c:=substr(linea,++i,1)
        while isalpha(c).or.c=="_".or.isdigit(c).and. i<=vLen
           pInstr+=c
           c:=substr(linea,++i,1)
        end
        --i
        if pInstr=="pop"  // es ".funpop"
           vlinea+=" @@@"+DICC[184][2]+" "
        else
        ///  ? "INSTR:",pInstr
           nHash := _BuscaInstr(pInstr)     // es instruccion?
           if nHash>0     // es una instruccion: guarda y sigue
              //strtran(_lnexe,DICC[j][1],DICC[j][2])
              //vlinea+=" "+pInstr+" "
              vlinea+=" @@@"+DICC[nHash][2]+" "
           else        // es variable?
              swExiste:=.F.
              for l:=1 to _NHASH
                 if _hash[l][1]==METLOC
                    if pInstr==_hash[l][3]
                       vlinea+=" $"+strzero(_hash[l][6],_DIR)+" "
                       swExiste:=.T.
                       exit
                    end
                 end
              end
              if !swExiste  // busco en variables globales.
                 swExiste:=.F.
                 for l:=1 to _NHASH
                    if _hash[l][1]==_METODO
                      //? _hash[l][3],",",_hash[l][1]
                       if pInstr==_hash[l][3]
                          vlinea+=" $"+strzero(_hash[l][6],_DIR)+" "
                          swExiste:=.T.
                          exit
                       end
                    end
                 end
                 if !swExiste
                    return "ERR-3"+pInstr
                 end
              end
           end
        end
  elseif c== "("  // puede ser un negativo-menos unario.
        vlinea+=c
        c:=substr(linea,++i,1)
        if c=="-"  // es un menos unario
           //nHash:=_TBuscaStr(METLOC,0)
           nHash:=_TBuscaStr("*",0)
           if nHash>0
              vlinea+=" $"+strzero(nHash,_DIR)+" "
           else
              aadd (_Thash,{METLOC,"*","0","N","*",++_EDIR,"*"})
              vlinea+=" $"+strzero(_EDIR,_DIR)+" "
              _NHASH:=len(_hash)
           end
           vlinea+=c  // agrega "0-lo que sea"
        else
           --i
        end
  else            // GUARDA EN vlinea
        vlinea+=c
  end
  ++i
//  inkey(0)
//  if lastkey()==27
//    quit
//  end
end
//? "-->",vlinea

return vlinea

procedure _Reemplazo_Hash(_Metodo_local)
local _nl,_TOP,_v,j,err,code
local_EDIR:=0

    _TOP:= _METHOINI
    _nl := _METHOFIN

    _EDIR:=_TFFFF+len(_Thash)

    if _Metodo_local=="ALGORITHM:"
       _Metodo_local:=_METODO
      // ? "_TOP = ",_TOP,"... _NL = ",_nl
    end

    for j:=_TOP to _nl
 //      ? ">>>> LINEA = ", _lineexe[j][2]
       _v:=XBUSCACONST(_lineexe[j][1],_Metodo_local,@_EDIR)
       err:=substr(_v,1,4)
       if err=="ERR-"
          code:=substr(_v,6,len(_v))
          _v:=substr(_v,5,1)
          
          if _v=="1"
             _Error ("Error: Se detectó una cadena sin cerrar: "+code,_lineexe[j][2])
          elseif _v=="2"
             _Error ("Error: Se detectó un número mutante: "+code,_lineexe[j][2])
          elseif _v=="3"
             _Error ("Error: Palabra no reconocida: "+code,_lineexe[j][2])
          end
       end
       _lineexe[j][1]:=_v
    next

return 

procedure _VerificaNombre(c,_linea,metodo_local)
local k,c1

  for k:=1 to len(c)
    if k==1
      if !isalpha(substr(c,k,1))
        _Error ("Error: Un nombre de variable debe empezar con una letra: "+c,;
                _linea)  
      end
    else
      c1:=substr(c,k,1)
      if !isalpha(c1) .and. !isdigit(c1) .and. c1!="_"
        _Error ("Error: Para un nombre de variable, se acepta a-A..z-Z, 0-9 y '_': "+c,;
                _linea)
      end
    end
  next

  if _BuscaVar(c,metodo_local)>0  // la variable existe
    _Error ("Error: La variable ya fue declarada previamente",_linea)
  end

return

function _ExtraeChar(cad,pos)
return substr(cad,pos,1)

procedure _strcat(destino, origen)
  destino:=destino+origen
return

function es_entero(_n)
local _ret:=.T.,_l,_i:=0
_l:=len(_n)
for _i:=1 to _l
   if !isdigit(substr(_n,_i,1))
      _ret:=.F.
   end
next 
return _ret

procedure _Obtener_Metodo()
local _nl, i,_m,_s,_size,tipo_aplicacion
local _sw_metodo:=.F., _sw_data:=.F.  

   _nl:=len(_lineexe)

   _size:=32768    // seteo de offset de mem para compilaciopn por defecto.
   FFFF:=_size
   _sw_data:=.T.

   _RETURN:=9    // seteo dependencia por defecto "yes", 8= No
   _METODO:="Xu program ********"

   for i:=1 to _nl
      _s:=alltrim(_lineexe[i][1])
      _m:=upper(alltrim(substr(_s,1,at(":",_s)-1)))
      if _m=="NAME"
         _METODO:=lower(alltrim(substr(_s,at(":",_s)+1,len(_s))))
         _sw_metodo:=.T.
      end
      if _m=="MEMORY"
         tipo_aplicacion:=upper(alltrim(substr(_s,at(":",_s)+1,len(_s))))
         _LEVEL:=22
         if tipo_aplicacion=="RECURSIVE"
            _LEVEL:=23
         end
      end

      if _m=="DEPENDENCIA"
         _RETURN:=lower(alltrim(substr(_s,at(":",_s)+1,len(_s))))
         if _RETURN!="si".and._RETURN!="no"
            _Error ("Error: Dependencia no es válida para este programa",i)
         end
         _RETURN:=iif(_RETURN=="si",9,8)
      end
      _OUTPUT:=1  // por defecto: emulate
      if _m=="OUTPUT"
         _OUTPUT:=lower(alltrim(substr(_s,at(":",_s)+1,len(_s))))
         if _OUTPUT!="emulate" .and. _OUTPUT!="terminal"
            _Error ("Error: Define una salida EMULATE o TERMINAL para este programa",i)
         end
         _OUTPUT:=iif(_OUTPUT=="emulate",1,2)
      end
   next
   if !_sw_data
      FFFF:=32768 
   end
return

procedure _EncuentraMetodo()
local _i,_j,_udf,_v,_arg,_argret
// local _sw_thread:=.F.,_finUdf:=NULL

  _i:=_UDFINI
  while _i<=_UDFFIN

    _v:=_lineexe[_i][1]

    _udf:=at("=",_v)  // udf normal.  Y para un thread?
    _funcion:=at("function",_v) 

    if _udf>0 .and. _funcion>0
       _eq:=_udf
       _MetodoLocal:=alltrim(substr(_v,1,_eq-1))    // obtengo nombre de metodo
       _TipoMet:=alltrim(substr(_v,at(":",_v)+1,len(_v)))   // tipo devuelto

       _arg := _Tipo_Arg(_TipoMet,0,_i)
       _argret := _arg
       // obtengo variables y de paso el tipo de argumentos
       for _j:=_i+1 to _UDFFIN
          if upper(alltrim(_lineexe[_j][1]))=="BEGIN:"
             _CargaVarsPublicas(_i+1,_j-1,_MetodoLocal,"NORMAL")
             exit
          end
          
       next
       
       if _j > _UDFFIN
          _Error ("Error: Detecto que la función '"+upper(_MetodoLocal)+"' no tiene BEGIN",_lineexe[_i][2])
       end
       // busco argumentos para este metodo

       _cta_arg:=0
       for k:=1 to _NHASH
         if _hash[k][1]==_MetodoLocal
            // ?  _MetodoLocal
            if _hash[k][2]!="*"
               _cta_arg++
               _xtmp:=val(_hash[k][2])
               if _xtmp==_cta_arg 
                  if "A" $ _hash[k][4]
                     _arg:=_arg+substr(_hash[k][4],1,1)
                  else
                     _arg:=_arg+_hash[k][4]
                  end
               elseif _xtmp==(_cta_arg*11)    // por referencias
                  if "A" $ _hash[k][4]
                     _arg:=_arg+substr(_hash[k][4],1,1)
                  else
                     _arg:=_arg+_hash[k][4]
                  end
               else    // debe ser un error!!!
                  _Error ("Error: Parámetros dispuestos en desorden en función ["+_MetodoLocal+"]",0) 
               end
            end
         end
       next
       _METHOINI:=_j+1
       _sw_returnValue:=0
       _factorRetorno:=0

       for _k:=_j+1 to _UDFFIN
          _instBuscada:=upper(alltrim(_lineexe[_k][1]))
          _instEstruc:=upper(alltrim(substr(_lineexe[_k][1],1,at(" ",_lineexe[_k][1]))))
          if _instBuscada=="END"  //EUDF
             _METHOFIN:=_k-1
             exit
          end
          if _instEstruc=="IF" .or. _instEstruc=="WHILE" .or. _instEstruc=="FOR".or._instEstruc=="EVAL"
             _factorRetorno:=1
          end   
          if _instBuscada=="ENDIF" .or. _instBuscada=="WEND" .or. _instBuscada=="NEXT".or._instBuscada=="EVEND"
             _factorRetorno:=0
          end   
          if _instEstruc=="RETURN"  // tiene retorno
             _sw_returnValue:=1+_factorRetorno
          end
       next
       if (_sw_returnValue>0 .and. upper(_TipoMet)=="VOID")
          _Error ("Error: la función '"+upper(_MetodoLocal)+"' devuelve algo y no debería hacerlo",_lineexe[_k][2])
       elseif (_sw_returnValue==0 .and. upper(_TipoMet)!="VOID")
          _Error ("Error: la función '"+upper(_MetodoLocal)+"' no retorna un valor y debería hacerlo",_lineexe[_k][2])
       elseif _sw_returnValue>1
          if !_sw_anulawarningretorno
             
             setcolor("0/6")
             outstd(_CR+ "*** Guarning ***"+_CR)
             outstd( hb_utf8tostr("La función '"+upper(_MetodoLocal)+"' retorna un valor dentro de una estructura de control,"+_CR+;
                  "siendo posible (no necesario) que finalice sin retornar nada: eso me haría cagar feo!"+_CR+;
                  "(Usa '-wret' para anular esta validación)") +_CR)
             setcolor("")
          end
       end
       if _k > _UDFFIN
          _Error ("Error: Detecto que la función '"+upper(_MetodoLocal)+"' no tiene END",_lineexe[_k][1])
       end

       // instalo nuevo metodo en DICC
       _ldic:=strzero(len(DICC)+1,_DIR)

       aadd(DICC,{"."+_Metodolocal,_ldic,_arg})
       aadd(_aMetod,{_METHOINI,_METHOFIN,_Metodolocal,_ldic,_argret})
          
       // reemplazo los nuevos hash dentro del metodo local
      // ? "ENCUENTRAMETODO()==>_Reemplazo_Hash (",_MetodoLocal,")"
       _Reemplazo_Hash(_MetodoLocal)
    end
    ++_i

  end

return 


procedure _Define_Hash(_SECTION)
local i, f,g,_nl, _linea
local _sw_section, _upsec, _tiene_stop:=.F.

    _nl:=len(_lineexe)

    _upsec:=upper(_SECTION)
    
    for i:=1 to _nl
       _instruct:=upper(alltrim(_lineexe[i][1]))
       if _instruct==_upsec
          exit
       end
       if _instruct=="FUNCTIONS:" .or._instruct=="VARS:"
          --i
          exit
       end
       if _instruct=="ALGORITHM:"
          _EDIR:=len(_hash)+1
          aadd(_hash,{_METODO,"*","gen","*",NULL,_EDIR+FFFF,"NORMAL"})
          f:=i
       end
       if _instruct=="STOP"
          _tiene_stop:=.T.
       end
    next

    if i >= _nl  // por el for trucho: a lo mejr no es necesario
//       _Error ("Error: No encuentro el bloque de objetos (OBJECTS:) [1]",_nl)
       if !_tiene_stop
          _Error ("Error: El programa debe terminar con STOP (sorry por mi asperger)",_nl-3)
       end
       _METHOINI:=f+1
       _METHOFIN:=_nl
       _NHASH:=1
       aadd(_aMetod,{_METHOINI,_METHOFIN,_METODO,"0",_RETURN})
       return
    end

    // siguiente debe ser "VARS:" o "FUNCTIONS:"
    ++i
    if upper(_lineexe[i][1])=="VARS:"  .or. upper(_lineexe[i][1])=="FUNCTIONS:" // declara las publicas
       // hasta donde declara publicas?
       if _instruct=="FUNCTIONS:"
          _sw_section:="UDF"
          f:=i
       else   
          for f:=i+1 to _nl
             _linea:=upper(alltrim(_lineexe[f][1]))
             if _linea=="ALGORITHM:"
                _sw_section:="MET"
                exit
             elseif _linea=="FUNCTIONS:"
                _sw_section:="UDF"
                exit
             end
          next
          if f >= _nl  // por el for trucho
             _Error ("Error: No encuentro declaración ALGORITHM...",_nl)
          end
       
          // cargo variables publicas primero
          _CargaVarsPublicas(i+1,f-1,_METODO,"NORMAL") // siempre seran normales
       end  // if _instruct

      
       if _sw_section=="UDF"  
          existeVars:=.F.
          // busco hasta APPLICATION:
          for g:=f+1 to _nl
             if upper(alltrim(_lineexe[g][1]))=="ALGORITHM:"
                exit
             elseif upper(alltrim(_lineexe[g][1]))=="VARS:"
               /***** BUSCO SI VARS: SE DECLARÓ DESPUES DE UNA UDF ******/
               for h:=g+1 to _nl
                  _linea:=upper(alltrim(_lineexe[h][1]))
                   if _linea=="ALGORITHM:"
                      exit
                   end
                next
                if h >= _nl  // por el for trucho
                   _Error ("Error: No encuentro declaración ALGORITHM...",_nl)
                end
       
                // cargo variables publicas primero
                _CargaVarsPublicas(g+1,h-1,_METODO,"NORMAL") // siempre seran normales
                existeVars:=.T.
                exit

             end
          next

          if g >= _nl  // por el for trucho
             _Error ("Error: No encuentro cuerpo principal ALGORITHM (es obligatorio, wea, entiende!)",_nl)
          end
          // Guardo fronteras de UDF's para proceso posterior
          _UDFINI:=f+1
          _UDFFIN:=g-1

          if !existeVars
             _METHOINI:=g+1
             _METHOFIN:=_nl
          else
             _METHOINI:=h+1
             _METHOFIN:=_nl
          end

          _MAININI:=_METHOINI
          _MAINFIN:=_METHOFIN

       else
          _METHOINI:=f+1
          _METHOFIN:=_nl
         
       end
       aadd(_aMetod,{_METHOINI,_METHOFIN,_METODO,"0",_RETURN})
    end

return

procedure _CargaVarsPublicas(_desde,_hasta,_metodo_local,_Tipo_Metodo)
local _l,_v,t,_lin,_d,_arg,_kk,_vkk,_vkkarg
local _STRUCT
local _TipoVar,_ArgumVar
local _CDIR:=0, _EDIR
local _swref      // indica si argumento es pasado por referencia...

    _EDIR:=len(_hash)+1

    // reservo este espacio para calculos contingentes en T-Real
    if _metodo_local=="ALGORITHM:"
       aadd(_hash,{_METODO,"*","gen","*",NULL,_EDIR+FFFF,_metodo_local})
       _EDIR:=2
    end

    // carga variables en el rango descubierdo _ini,_fin
    while _desde<= _hasta
        _lin:=alltrim(_lineexe[_desde][1])
        if substr(_lin,1,1)=="{"       // es una agrupacion de variables

           if !("}" $ _lin)            // el grupo es de + de una linea
              _desde++

              t:=_lin   

              while _desde<=_hasta
                 _lin:=alltrim(_lineexe[_desde][1])
                 t:=t+" "+_lin

                 if "}" $ _lin
                    exit
                 end
                 _desde++
              end
              _lin:=t
           end

           _l:= at("=",lower(_lin))
          
           _v:=alltrim(substr(_lin,at("{",_lin)+1,at("}",_lin)-at("{",_lin)-1))
        else
           _l:= at("=",lower(_lin))
           _v:= alltrim(substr(_lin,1,_l-1))
        end

        _STRUCT:="*"

        _d:= alltrim(substr(_lin,_l+1,len(_lin)))  // tipo

        if "$" $ _d
           if ":" $ _d
              _STRUCT:=alltrim(substr(_d,2,at(":",_d)-2))   // el numero del argumento

              if !es_entero(_STRUCT)
                 _Error("Error: Índice de parámetro debe ser un número entero $1, $2, etc",;
                     _lineexe[_desde][2])
              end
                          
              if len(_STRUCT)>1
                 _Error("Error: Sólo se aceptan 9 parámetros por función... Sorry, soy limitado",;
                     _lineexe[_desde][2])
              end

              _arg:=alltrim(substr(_d,at(":",_d)+1,len(_d)))

              //------------NUEVO: determinacion de BYREF--- 11-01-2010
              if "(ref)" $ _arg    // existe indicacion de referencia???
                 _arg:=alltrim(strtran(_arg,"(ref)",NULL))
                 _STRUCT:=_STRUCT+_STRUCT    // 11= arg. referencia.
              elseif "(*)" $ _arg    // existe indicacion de referencia???
                 _arg:=alltrim(strtran(_arg,"(*)",NULL))
                 _STRUCT:=_STRUCT+_STRUCT    // 11= arg. referencia.
              end

              //--------------------------------------------
              // busco si ya fue utilizado
              // veo el tipo de _arg

              _vkkarg := _Tipo_Arg(_arg,1,_desde)

              for _kk:=1 to len(_hash)
                 if _hash[_kk][1]==_metodo_local
                    _vkk:=_hash[_kk][2]
                    if _vkk==_STRUCT
                       if _vkkarg!=_hash[_kk][4]
                          _Error("Error: Argumento duplicado con tipo distinto (el que sobra, ya saí)",;
                                _lineexe[_desde][2])
                       end   
                    end
                 end
              next

           else
              _Error("Error: Se ha declarado un argumento de manera incorrecta, oh!",;
                           _lineexe[_desde][2])
           end
        else
           _arg:=_d
        end

        _arg := _Tipo_Arg(_arg,0,_desde)

        _kk:=1
        _qq:=numtoken(_v,",")
        while _kk<=_qq  //!empty(_v)
           _c:=alltrim(token(_v,",",_kk++))     
           _VerificaNombre(_c,_lineexe[_desde][2],_metodo_local)

           _TipoVar:=_arg
           _ArgumVar:=NULL

           _CDIR:=_EDIR+FFFF

           aadd(_hash,{_metodo_local,_STRUCT,_c,_TipoVar,_ArgumVar,_CDIR,_metodo_local})

           ++_EDIR
        end
        _v:=NULL
        _NHASH := len(_hash)
        _desde++
    end                     // end del while

    if _NHASH==0     // no hay variables?
        aadd(_hash,{_metodo_local,"*","NULO","C",NULL,_EDIR+FFFF,_metodo_local})
        _NHASH:=1
    end
//---------------------------------------------------------------------
    // Veo si hay variables fantasmas de for_each:
    while len(_Stack_nvar)>0    // si las hay!!!
       _Nombre_var:=stackpop(_Stack_nvar)   
       // agrego la nueva constante
       _nueva_direccion:=_hash[len(_hash)][6]+1
       aadd(_hash,{_METODO,"*",_Nombre_var,"N",NULL,_nueva_direccion,_METODO})
       ++_NHASH
    end
 
return

function _Tipo_Arg(_arg,_type,_i)
local _ret
   _arg:=lower(_arg)

   if _arg=="number" .or. _arg=="num."
      _ret:="N"
   elseif _arg=="file" 
      _ret:="F"
   elseif _arg=="string"  .or. _arg=="str."
      _ret:="C"
   elseif _arg=="boolean" .or. _arg=="bool." .or. _arg=="logic" .or. _arg=="switch"
      _ret:="L"
   elseif _arg=="array of number" .or. _arg=="^number" .or._arg=="^num."   // es un stack de numeros
      _ret:="AN"
   elseif _arg=="array of string" .or. _arg=="^string" .or._arg=="^str."   // es un stack de strings
      _ret:="AC"
   elseif _arg=="array of boolean" .or. _arg=="^boolean" .or. _arg=="^bool." .or. _arg=="^switch" // es un stack de bools
      _ret:="AL"
   elseif _arg=="array of file" .or._arg=="^file" // es un stack de files
      _ret:="AF"
   elseif _arg=="void"        // vacio
      _ret:="_"
   elseif _arg=="variant"    // tipo nuevo: para stacks solamente (usar con POP)
      _ret:="V"
   elseif _arg=="stack" .or. _arg=="^variant"     // stack sin tipo
      _ret:="AV"   
   else
      _Error("Error(1): No reconozco el tipo de la declaración",;
               _lineexe[_i][2])
   end

return _ret

function _CargaDiccionario()
local _ret,_i
//vacíos
_ret:=array(278,3)
for _i:=1 to 278
   _ret[_i][2]:=strzero(_i,6)
end
// funciones binarias
_ret[1][1]:="sget"             ;_ret[1][3]:="CCNN"
_ret[2][1]:="sput"             ;_ret[2][3]:="_CNNC"
_ret[3][1]:="cget"             ;_ret[3][3]:="CCN"
_ret[4][1]:="xtobool"          ;_ret[4][3]:="L#"
_ret[5][1]:="round"            ;_ret[5][3]:="##N"
_ret[6][1]:="poschar"          ;_ret[6][3]:="_CN#"
_ret[7][1]:="unique"           ;_ret[7][3]:="AA"
_ret[8][1]:="setcode"          ;_ret[8][3]:="ANAA"
_ret[9][1]:="cls"              ;_ret[9][3]:="_"
_ret[10][1]:="jt"              ;_ret[10][3]:="_L"
_ret[11][1]:="goodbye"         ;_ret[11][3]:="_"
_ret[12][1]:="XXXXXX"          ;_ret[12][3]:="_"   // NO TOCAR. RESERVADO PARA FACTORIAL
_ret[13][1]:="jnt"             ;_ret[13][3]:="_L"
_ret[14][1]:="lastkey"         ;_ret[14][3]:="N"   // lee del buffer de teclado ultima tecla 
_ret[15][1]:="!"               ;_ret[15][3]:="##"  // simbolo FACTORIAL empleado en interpretacion
_ret[16][1]:="letstrstk"       ;_ret[16][3]:="AC"
_ret[17][1]:="mov"             ;_ret[17][3]:="##"
_ret[18][1]:="strload"         ;_ret[18][3]:="C#"
_ret[19][1]:=CHR(126)          ;_ret[19][3]:="##"
_ret[20][1]:="strdiff"         ;_ret[20][3]:="ACCN"  // distancia de Levensthein
_ret[21][1]:="xcode2_nc"       ;_ret[21][3]:="#N#"
_ret[22][1]:="ispos"           ;_ret[22][3]:="##"
_ret[23][1]:="jmp"             ;_ret[23][3]:="_N"
_ret[24][1]:="freads"          ;_ret[24][3]:="CFN"
_ret[25][1]:="stop"            ;_ret[25][3]:="_"
_ret[26][1]:="pause"           ;_ret[26][3]:="_"
_ret[27][1]:="isany"           ;_ret[27][3]:="L##"
_ret[28][1]:="isneg"           ;_ret[28][3]:="##"
_ret[29][1]:="readkey"         ;_ret[29][3]:="_N"
_ret[30][1]:="between"         ;_ret[30][3]:="LNNN"
_ret[31][1]:="flag"            ;_ret[31][3]:="_#"
_ret[32][1]:="isall"           ;_ret[32][3]:="L##"
_ret[33][1]:="htrg_code"       ;_ret[33][3]:="#N#"
_ret[34][1]:="system"          ;_ret[34][3]:="C"   // devuelve el nombre del sistema operativo
_ret[35][1]:="iif"             ;_ret[35][3]:="#L##"
_ret[36][1]:="brkz"            ;_ret[36][3]:="_N"   // JZ salte si es zero
_ret[37][1]:="fcreate"         ;_ret[37][3]:="_CN"
_ret[38][1]:="trg_code"        ;_ret[38][3]:="#N#"
_ret[39][1]:="unparser"        ;_ret[39][3]:="###"
_ret[40][1]:="nop"             ;_ret[40][3]:="_"
_ret[41][1]:="xtostr"          ;_ret[41][3]:="##"
_ret[42][1]:="judf"            ;_ret[42][3]:="_N"  // salto a funcion
_ret[43][1]:="addstr"          ;_ret[43][3]:="CCC"
_ret[44][1]:="xcode_cn"        ;_ret[44][3]:="#N#"
_ret[45][1]:="xcode_ccc"       ;_ret[45][3]:="#N##"
_ret[46][1]:="xtonum"          ;_ret[46][3]:="##"
_ret[47][1]:="cwm2let"         ;_ret[47][3]:="_#"
_ret[48][1]:="api"             ;_ret[48][3]:="_C"
_ret[49][1]:="out"             ;_ret[49][3]:="_C"
_ret[50][1]:="eval"            ;_ret[50][3]:="_L"
_ret[51][1]:="pushl"           ;_ret[51][3]:="_#"
_ret[52][1]:="popl"            ;_ret[52][3]:="_#"
_ret[53][1]:="minmax_code"     ;_ret[53][3]:="NNNN"
_ret[54][1]:="parser"          ;_ret[54][3]:="###"
_ret[55][1]:="letstkstk"       ;_ret[55][3]:="AA"
_ret[56][1]:="set_array"       ;_ret[56][3]:="_NNNN"
_ret[57][1]:="retv"            ;_ret[57][3]:="_"
_ret[58][1]:="return"          ;_ret[58][3]:="_#"
_ret[59][1]:="fwrites"         ;_ret[59][3]:="_FC"
_ret[60][1]:="lopera_code"     ;_ret[60][3]:="_"
_ret[61][1]:="strat"           ;_ret[61][3]:="###"
_ret[62][1]:="xmatalter"       ;_ret[62][3]:="ANNAA"
_ret[63][1]:="xustticdm"       ;_ret[63][3]:="AC#NNNN"
_ret[64][1]:="subaddstr"       ;_ret[64][3]:="CCC"
_ret[65][1]:="subsubstr"       ;_ret[65][3]:="CCC"
_ret[66][1]:="swap"            ;_ret[66][3]:="_##"
_ret[67][1]:="screen"          ;_ret[67][3]:="_N"
_ret[68][1]:="video"           ;_ret[68][3]:="_NN"
_ret[69][1]:="xcode_nc"        ;_ret[69][3]:="#N#"
_ret[70][1]:="seq"             ;_ret[70][3]:="ANNN"
_ret[71][1]:="isnear"          ;_ret[71][3]:="L##"
_ret[72][1]:="meta_sminmax"    ;_ret[72][3]:="NNA"
_ret[73][1]:="blkcopy"         ;_ret[73][3]:="AAA"
_ret[74][1]:="config_array"    ;_ret[74][3]:="_A"
_ret[75][1]:="fix"             ;_ret[75][3]:="##N"  // precision. xprec(V dec)
_ret[76][1]:="brknz"           ;_ret[76][3]:="_N"   // jnz salte si no es cero 
_ret[77][1]:="ymatalter"       ;_ret[77][3]:="ANAAN"
_ret[78][1]:="xvtmatfile"      ;_ret[78][3]:="_AC"
_ret[79][1]:="strrepc"         ;_ret[79][3]:="####"
_ret[80][1]:="vput"            ;_ret[80][3]:="_AN#"
_ret[81][1]:="vget"            ;_ret[81][3]:="#AN"
_ret[82][1]:="strsave"         ;_ret[82][3]:="_CC"
_ret[83][1]:="strrep"          ;_ret[83][3]:="######"
_ret[84][1]:="show"            ;_ret[84][3]:="_AN"
_ret[85][1]:="context"         ;_ret[85][3]:="_C"
_ret[86][1]:="strins"          ;_ret[86][3]:="####"
_ret[87][1]:="strchg"          ;_ret[87][3]:="####"
_ret[88][1]:="strlz"           ;_ret[88][3]:="##"
_ret[89][1]:="fseek"           ;_ret[89][3]:="NFNN"
_ret[90][1]:="pget"            ;_ret[90][3]:="#ANNN"
_ret[91][1]:="pput"            ;_ret[91][3]:="_ANNN#"
_ret[92][1]:="strcpy"          ;_ret[92][3]:="####"
_ret[93][1]:="status"          ;_ret[93][3]:="_L"
_ret[94][1]:="strfind"         ;_ret[94][3]:="###N"
_ret[95][1]:="seqsp"           ;_ret[95][3]:="ANNN"
_ret[96][1]:="finc"            ;_ret[96][3]:="##"  // .inc
_ret[97][1]:="fdec"            ;_ret[97][3]:="##"  // .dec
_ret[98][1]:="inc"             ;_ret[98][3]:="_#"
_ret[99][1]:="dec"             ;_ret[99][3]:="_#"
_ret[100][1]:="seconds"        ;_ret[100][3]:="##"
_ret[101][1]:="minmaxmat_code" ;_ret[101][3]:="AN##"  // min y max de matrices-->matriz
_ret[102][1]:="strtok"         ;_ret[102][3]:="###"
_ret[103][1]:="reshape"        ;_ret[103][3]:="_ANNNN"
_ret[104][1]:="pushd"          ;_ret[104][3]:="_"
_ret[105][1]:=".lrepl"         ;_ret[105][3]:="CCN"
_ret[106][1]:="popd"           ;_ret[106][3]:="_"
_ret[107][1]:="popsr"          ;_ret[107][3]:="_#"
_ret[108][1]:="bget"           ;_ret[108][3]:="#ANNNN"
_ret[109][1]:="bput"           ;_ret[109][3]:="_ANNNN#"
_ret[110][1]:="pops"           ;_ret[110][3]:="_#"
_ret[111][1]:="strcut"         ;_ret[111][3]:="####"
_ret[112][1]:="letespstk"      ;_ret[112][3]:="AN"
_ret[113][1]:="tmath_code"     ;_ret[113][3]:="#N#"
_ret[114][1]:="getgbit"        ;_ret[114][3]:="NNNN"
_ret[115][1]:="math_code"      ;_ret[115][3]:="#N#"
_ret[116][1]:="setgbit"        ;_ret[116][3]:="_NNNN"
_ret[117][1]:="fexist"         ;_ret[117][3]:="LC"
_ret[118][1]:="istype"         ;_ret[118][3]:="L#C"
_ret[119][1]:="trstk_code"     ;_ret[119][3]:="##"
_ret[120][1]:="isempty"        ;_ret[120][3]:="L"
_ret[121][1]:="type"           ;_ret[121][3]:="C#"
_ret[122][1]:="matrange"       ;_ret[122][3]:="AN##"
_ret[123][1]:="afindstk"       ;_ret[123][3]:="A#C#"
_ret[124][1]:="xmsize"         ;_ret[124][3]:="AA"
_ret[125][1]:="fmisca_code"    ;_ret[125][3]:="_"
_ret[126][1]:="getenv"         ;_ret[126][3]:="CC"
_ret[127][1]:="tstats_code"    ;_ret[127][3]:="ANA"
_ret[128][1]:="xor"            ;_ret[128][3]:="LLL"
_ret[129][1]:="xsetbit"        ;_ret[129][3]:="_NNN"
_ret[130][1]:="xgetbit"        ;_ret[130][3]:="NNN"
_ret[131][1]:="vtab"           ;_ret[131][3]:="_N"
_ret[132][1]:="htab"           ;_ret[132][3]:="_N"
_ret[133][1]:="millisec"       ;_ret[133][3]:="_N"
_ret[134][1]:="isnan"          ;_ret[134][3]:="L#"
_ret[135][1]:="strccar"        ;_ret[135][3]:="####"
_ret[136][1]:="bitnot"         ;_ret[136][3]:="##"
_ret[137][1]:="tokenstrmat"    ;_ret[137][3]:="ACC"
_ret[138][1]:="strlin"         ;_ret[138][3]:="###"
_ret[139][1]:="isinf"          ;_ret[139][3]:="L#"
_ret[140][1]:="join"           ;_ret[140][3]:="CA"
_ret[141][1]:="mput"           ;_ret[141][3]:="_ANN#"
_ret[142][1]:="mget"           ;_ret[142][3]:="#ANN"
_ret[143][1]:="seed"           ;_ret[143][3]:="_N"
_ret[144][1]:="keyput"         ;_ret[144][3]:="_NN"   // KEY PUT keyboard
_ret[145][1]:="xmat"           ;_ret[145][3]:="AAA"   // mjltiplicacion matricial
_ret[146][1]:="tstk_code"      ;_ret[146][3]:="_N#"
_ret[147][1]:="tfstk_code"     ;_ret[147][3]:="_NN"
_ret[148][1]:="fcmd"           ;_ret[148][3]:="CC"
_ret[149][1]:="cmd"            ;_ret[149][3]:="_C"
_ret[150][1]:="precision"      ;_ret[150][3]:="_N"
_ret[151][1]:=".getdata"       ;_ret[151][3]:="#"
_ret[152][1]:=".putdata"       ;_ret[152][3]:="_#"
_ret[153][1]:="cursor"         ;_ret[153][3]:="_N"
_ret[154][1]:="strpad"         ;_ret[154][3]:="###"
_ret[155][1]:="cleartry"       ;_ret[155][3]:="_"
///_ret[156][1]:="fformat"        ;_ret[156][3]:="CCCAACA"
_ret[156][1]:="process"        ;_ret[156][3]:="_N##"  // envia mensaje, escucha y sirve resultados.   
_ret[157][1]:="tcast_code"     ;_ret[157][3]:="#N#"
_ret[158][1]:="tend"           ;_ret[158][3]:="_"
_ret[159][1]:="try"            ;_ret[159][3]:="_"
_ret[160][1]:="codsubmat"      ;_ret[160][3]:="AC##"
_ret[161][1]:="whatsup"        ;_ret[161][3]:="N"
_ret[162][1]:="ok"             ;_ret[162][3]:="L"
_ret[163][1]:="fwriteb"        ;_ret[163][3]:="_FN"
_ret[164][1]:="freadb"         ;_ret[164][3]:="NF"
_ret[165][1]:="fwritel"        ;_ret[165][3]:="_FC"
_ret[166][1]:="istime"         ;_ret[166][3]:="##"
_ret[167][1]:="prange"         ;_ret[167][3]:="_AA#"
_ret[168][1]:="grange"         ;_ret[168][3]:="AAA"
_ret[169][1]:="server"         ;_ret[169][3]:="AN"  // devuelve un array con los datos para procesar en xu.
_ret[170][1]:="response"       ;_ret[170][3]:="_A"  // responde la solicitud creando el archivo request. 
_ret[171][1]:="satura"         ;_ret[171][3]:="###C"
_ret[172][1]:="money"          ;_ret[172][3]:="##CNN"
_ret[173][1]:="feof"           ;_ret[173][3]:="LF"
_ret[174][1]:="freadl"         ;_ret[174][3]:="CF"
_ret[175][1]:="codemsg"        ;_ret[175][3]:="_C"  // el codigo del mensaje: la extensión del archivo de mensaje.
_ret[176][1]:="fclose"         ;_ret[176][3]:="_F"
_ret[177][1]:="fopen"          ;_ret[177][3]:="FCN"
_ret[178][1]:="mask"           ;_ret[178][3]:="##C"
_ret[179][1]:="rpush"          ;_ret[179][3]:="_N"
_ret[180][1]:="STPOP"          ;_ret[180][3]:="_"
_ret[181][1]:="flush"          ;_ret[181][3]:="_"
_ret[182][1]:="msleep"         ;_ret[182][3]:="_N"
_ret[183][1]:="sleep"          ;_ret[183][3]:="_N"
_ret[184][1]:=".funpop"        ;_ret[184][3]:="V"   //"#"
_ret[185][1]:="xcode_cc"       ;_ret[185][3]:="#N#"

_ret[186][1]:="brkgz"          ;_ret[186][3]:="_N"  // jp  salte si es positivo
_ret[187][1]:="brklz"          ;_ret[187][3]:="_N"  // jn  salte si es negativo   
_ret[188][1]:="brklez"         ;_ret[188][3]:="_N"  // jlez  salte si es menor o igual a cero
_ret[189][1]:="brkgez"         ;_ret[189][3]:="_N"  // jgez  salte si es mayor o igual a cero

_ret[190][1]:="tdate2_code"    ;_ret[190][3]:="#N#"

_ret[191][1]:="XXXXXX"         ;_ret[191][3]:="_"
_ret[192][1]:="XXXXXX"         ;_ret[192][3]:="_"
_ret[193][1]:="XXXXXX"         ;_ret[193][3]:="_"
_ret[194][1]:="XXXXXX"         ;_ret[194][3]:="_"

_ret[195][1]:="not"            ;_ret[195][3]:="_#"
_ret[196][1]:="isleap"         ;_ret[196][3]:="##"
_ret[197][1]:="back"           ;_ret[197][3]:="_"
_ret[198][1]:="gosub"          ;_ret[198][3]:="_C"
_ret[199][1]:="dateadd"        ;_ret[199][3]:="###"
_ret[200][1]:="sort"           ;_ret[200][3]:="AANCNN"
_ret[201][1]:="flc"            ;_ret[201][3]:="AC"
_ret[202][1]:="addmatstr"      ;_ret[202][3]:="AAA"
_ret[203][1]:="XXXXXX"         ;_ret[203][3]:="_"
_ret[204][1]:="XXXXXX"         ;_ret[204][3]:="_"
_ret[205][1]:="xtostack"       ;_ret[205][3]:="A#"
_ret[206][1]:="xtovariant"     ;_ret[206][3]:="V#"
////_ret[206][1]:="XXXXXX"         ;_ret[206][3]:="_"
_ret[207][1]:="daysdiff"       ;_ret[207][3]:="###"
_ret[208][1]:="XXXXXX"         ;_ret[208][3]:="_"
_ret[209][1]:="xummcd"         ;_ret[209][3]:="###"
_ret[210][1]:="xummcm"         ;_ret[210][3]:="###"
_ret[211][1]:="bit_code"       ;_ret[211][3]:="#N##"
_ret[212][1]:="parsatt"        ;_ret[212][3]:="###A"
_ret[213][1]:="XXXXXX"         ;_ret[213][3]:="_"
_ret[214][1]:="true"           ;_ret[214][3]:="L"
_ret[215][1]:="false"          ;_ret[215][3]:="L"
_ret[216][1]:="garbage"        ;_ret[216][3]:="_"
_ret[217][1]:="XXXXXX"         ;_ret[217][3]:="_"
_ret[218][1]:="XXXXXX"         ;_ret[218][3]:="_"
_ret[219][1]:="raise"          ;_ret[219][3]:="_N"
_ret[220][1]:="elseif"         ;_ret[220][3]:="LL"
_ret[221][1]:="tdate_code"     ;_ret[221][3]:="#N#"
_ret[222][1]:="letmmulstk"     ;_ret[222][3]:="AAA"
_ret[223][1]:="else"           ;_ret[223][3]:="_"
_ret[224][1]:="datenow"        ;_ret[224][3]:="C"
_ret[225][1]:="endif"          ;_ret[225][3]:="_"
_ret[226][1]:="timenow"        ;_ret[226][3]:="C"
_ret[227][1]:="opera_mat"      ;_ret[227][3]:="_"
_ret[228][1]:="use"            ;_ret[228][3]:="_A"
_ret[229][1]:="push"           ;_ret[229][3]:="_V"    //"_#"
_ret[230][1]:="while"          ;_ret[230][3]:="LL"
_ret[231][1]:="pop"            ;_ret[231][3]:="_"
_ret[232][1]:="write"          ;_ret[232][3]:="_#"
_ret[233][1]:="wend"           ;_ret[233][3]:="_"
_ret[234][1]:="at"             ;_ret[234][3]:="_NN"
_ret[235][1]:="and"            ;_ret[235][3]:="LLL"
_ret[236][1]:="color"          ;_ret[236][3]:="_N"
_ret[237][1]:="tox"            ;_ret[237][3]:="##"
_ret[238][1]:="or"             ;_ret[238][3]:="LLL"
_ret[239][1]:="do"             ;_ret[239][3]:="_"
_ret[240][1]:="@"              ;_ret[240][3]:="_"
_ret[241][1]:="<>"             ;_ret[241][3]:="_"
_ret[242][1]:=">="             ;_ret[242][3]:="_"
_ret[243][1]:="<="             ;_ret[243][3]:="_"
_ret[244][1]:=">"              ;_ret[244][3]:="_"
_ret[245][1]:="<"              ;_ret[245][3]:="_"
_ret[246][1]:="="              ;_ret[246][3]:="_"
_ret[247][1]:="%"              ;_ret[247][3]:="_"
_ret[248][1]:="^"              ;_ret[248][3]:="_"
_ret[249][1]:="\"              ;_ret[249][3]:="_"
_ret[250][1]:="/"              ;_ret[250][3]:="_"
_ret[251][1]:="*"              ;_ret[251][3]:="_"
_ret[252][1]:="-"              ;_ret[252][3]:="_"
_ret[253][1]:="+"              ;_ret[253][3]:="_"
_ret[254][1]:="$"              ;_ret[254][3]:="_"
_ret[255][1]:="XXXXXX"         ;_ret[255][3]:="_"  // NULO NO TOCAR

/* DESDE AQUI EN ADELANTE SON INSTRUCCIONES QUE DESAPARECEN EN TIEMPO DE COMPILACION
   NO AGREGAR NINGUNA INSTRUCCION QUE PERTENEZCA A LA EJECUCION */

_ret[256][1]:="recursive"      ;_ret[256][3]:="_"    
_ret[257][1]:="endr"           ;_ret[257][3]:="_" 
_ret[258][1]:="XXXXXX"         ;_ret[258][3]:="_"  // 
_ret[259][1]:="XXXXXX"         ;_ret[259][3]:="_"  // 
_ret[260][1]:="XXXXXX"        ;_ret[260][3]:="_"  // 
_ret[261][1]:="XXXXXX"         ;_ret[261][3]:="_"  // 
_ret[262][1]:="XXXXXX"         ;_ret[262][3]:="_"  // 
_ret[263][1]:="exception"      ;_ret[263][3]:="_"
_ret[264][1]:="brkif"          ;_ret[264][3]:="LL"
_ret[265][1]:="until"          ;_ret[265][3]:="LL"
_ret[266][1]:="sub"            ;_ret[266][3]:="_C"
_ret[267][1]:="if"             ;_ret[267][3]:="LL"
_ret[268][1]:="break"          ;_ret[268][3]:="_"
_ret[269][1]:="continue"       ;_ret[269][3]:="_"
_ret[270][1]:="rend"           ;_ret[270][3]:="_"
_ret[271][1]:="room"           ;_ret[271][3]:="_L"  // ex area51
_ret[272][1]:="lend"           ;_ret[272][3]:="_"
_ret[273][1]:="loop"           ;_ret[273][3]:="_"
_ret[274][1]:="again"          ;_ret[274][3]:="_"
_ret[275][1]:="case"           ;_ret[275][3]:="_L"
_ret[276][1]:="otherwise"      ;_ret[276][3]:="_"
_ret[277][1]:="evend"          ;_ret[277][3]:="_"  // fin del eval
_ret[278][1]:="XXXXXX"         ;_ret[278][3]:="_"  

return _ret

procedure _GenLIB(libFile,tempFile)
LOCAL flib,fp,i,j,Temporal,pLine,nLen

outstd(_CR+hb_utf8tostr("Generando librería "+libFile+"...")+_CR)

fp:=memoread(tempFile)
nLen:=mlcount(fp,1024)
flib:=fcreate(libFile)
if ferror()!=0
   _Error("No es posible crear el archivo de librería, Error: "+alltrim(str(ferror())),0)
end
i:=1
while i<=nLen
   Temporal:=alltrim(memoline(fp,1024,i))
   Temporal:=alltrim(substr(Temporal,at(":",Temporal)+1,len(Temporal)))
   if Temporal=="functions:"
      exit
   end
   ++i
end
j:=i+1
while j<=nLen
   Temporal:=alltrim(memoline(fp,1024,j))
   Temporal:=alltrim(substr(Temporal,at(":",Temporal)+1,len(Temporal)))
   if Temporal=="algorithm:"
      exit
   end
   pLine:=Temporal+_CR
   fwrite(flib,pLine,len(pLine))
   ++j
end
fclose(flib)
outstd( "[Ok]" ) 
return

function _PASO_2(tempFile)
LOCAL Ret:={}, fp,nLine,i,Temporal,pLine,nLen

fp:=memoread(tempFile)
nLen:=mlcount(fp,512)
Ret:=array(nLen,2)
for i:=1 to nLen
   Temporal:=alltrim(memoline(fp,512,i))
   nLine:=val(substr(Temporal,1,at(":",Temporal)-1))
   pLine:=alltrim(substr(Temporal,at(":",Temporal)+1,len(Temporal)))
   Ret[i][1]:=pLine
   Ret[i][2]:=nLine
end
return Ret

procedure _Carga_archivo(file,tempFile)
LOCAL h_ini, h_fin,nSavePos,nLineaTemp,nLineaAmp,nLineas
LOCAL fp,c,linea,lineaFisica:=1,pFileInclude,pString,pCodeString,pLinea
LOCAL fpi,i_ini,i_fin,tmpFile
LOCAL swAmper,swEspacio,swCuerpo,swUse,sw
LOCAL DEF:={},DEFVAR:={},DEFBODY:={},STKSTR:={}

fp:=fopen(file)
if ferror()!=0
  _Error("Archivo fuente no puede ser abierto: "+file,0)   
end

ft:=fcreate(tempFile)
if ferror()!=0
  _Error("Archivo temporal no puede ser creado: "+tempFile,0)
end

c:=" "
linea:=NULL
swAmper:=.F.
swEspacio:=.F.
swCuerpo:=.F.
sw:=.F.
nLineaTemp:=0
nLineaAmp:=0

h_fin:=fseek(fp,0,2)
h_ini:=fseek(fp,0,0)
//? "H_INI=",h_ini,"  H_FIN=",h_fin

while h_ini<h_fin
  fread(fp,@c,1); ++h_ini  // leo caracter
  if c!=" "
     if swEspacio
        swEspacio:=.F.
     end
  end
  
  if c == chr(10)      // salto de línea
     if !swAmper
       /*  OJO: AQUÍ PROCESA LOS CORCHETES ^[],[.], TOX MOV, <-a<-b<-c... 
           instrucc..., [if/while/until], {a,b,c}<-{}/a... NO. DESPUES */
        linea:=alltrim(linea)   
        if len(linea)>1
           if linea=="algorithm:" .or. linea=="begin:"
              swCuerpo:=.T.
           end
           if linea=="end"
              swCuerpo:=.F.
           end

           linea:=_CAMBIODEFINE(@DEF,@DEFVAR,@DEFBODY,linea,@lineaFisica)

          /**** PARA DESPUÉS, CUANDO TENGA MI ARCHIVO TEMPORAL LSTO ****/
           if swCuerpo
              linea:=BUSCAMATENDURO(linea,lineaFisica)
           
              if "^[" $ linea 
                 linea:=_BuscaEstaticos(linea,lineaFisica)
              end

              linea:=_PREPROCESO(linea)
           
              
              linea:=SEPARAESTRUCT(linea,lineaFisica)
              linea:=REPLASIGCOMP(linea,lineaFisica)
              linea:=SEPARACOMBINADOS(linea,lineaFisica)
              linea:=REPLSEMANTOS(linea)
              ct:=0
              while at("{",linea)>0 .and. at("?",linea)>0 .and. "}" $ linea .and. ct<20
               //  ? "--->",linea
                 linea:=EXPANSIONMACRO(linea,lineaFisica)
                // linea:=SEPARACOMBINADOS(linea,lineaFisica)
               //  ? "<---",linea
                 ++ct
              end
              linea:=REPLIFFINLINE(linea,STKSTR)
           else
              if ":=" $ linea
                 linea:=strtran(linea,":=","=")
              elseif "(" $ linea .and. !("$" $ linea) // evito "(ref)" y "(*)"
                 // obtengo nombre de la funcion
                 nPos:=at("(",linea)
                 nFuncion:=alltrim(substr(linea,1,nPos-1))
                 cArgs:=substr(linea,nPos+1,len(linea))
                 cArgs:=alltrim(substr(cArgs,1,rat(")",cArgs)-1))
                 cRetorna:=alltrim(substr(linea,rat(")",linea)+1,len(linea)))
                 linea:=nFuncion+"=function"+cRetorna+_CR
                 for j:=1 to numtoken(cArgs,",")
                    Arg:=token(cArgs,",",j)
                    linea+=strtran(Arg,":","=$"+alltrim(str(j))+":")+_CR
                 end
                 linea:=substr(linea,1,len(linea)-1)  // quito ultimo _CR
              end
           end
           
           if nLineaTemp>0
              if nLineaAmp>0
                 nLineaTemp:=nLineaAmp
              end
              linea:=strzero(nLineaTemp,10)+":"+alltrim(linea)
           else
              if nLineaAmp==0
                 linea:=strzero(lineaFisica,10)+":"+alltrim(linea)
              else
                 linea:=strzero(nlineaAmp,10)+":"+alltrim(linea)
              end
           end
           if _CR $ linea
              if nLineaTemp>0
                 if nLineaAmp>0
                    nLineaTemp:=nLineaAmp
                 end
                 linea:=strtran(linea,_CR,_CR+strzero(nLineaTemp,10)+":")
              else
                 if nLineaAmp==0
                    linea:=strtran(linea,_CR,_CR+strzero(LineaFisica,10)+":")
                 else
                    linea:=strtran(linea,_CR,_CR+strzero(nLineaAmp,10)+":")
                 end
              end
           end
           nLineaTemp:=0
           nLineaAmp:=0
           
           linea+=_CR
           
           fwrite(ft,linea,len(linea))

        //   aadd(Ret,{alltrim(hb_utf8tostr(linea)),lineaFisica})
           linea:=NULL
           STKSTR:={}
        end
     else
        swAmper:=.F.   // bajo bandera, por si ya no hay más "&"
     end
     ++lineaFisica
  elseif c == "&"   // une líneas
     swAmper:=.T.
     if nLineaAmp==0
        nLineaAmp:=lineaFisica
     end
     ;
  elseif c == chr(13)
     ;
  elseif c =="("   // puede ser paréntesis normal o XTONuM. Altera analisis de macros "#"
     linea+=c 
     fread(fp,@c,1); ++h_ini
     nSavePos := fseek( fp, 0, 1 )
     if c=="#"
        linea+=c
     else
        fseek(fp,nSavePos-1,0); --h_ini
     end
     ;
  elseif c == "["
     linea+=c 
     fread(fp,@c,1); ++h_ini
     nSavePos := fseek( fp, 0, 1 )
     if c == "."
        linea+=c   // porque después puede venir una comilla
     else
        fseek(fp,nSavePos-1,0); --h_ini
     end
  elseif c == "#"   // use, define, include, insert
     fread(fp,@c,1); ++h_ini
     while isalpha(c) .and. h_ini<=h_fin
        linea+=c
        fread(fp,@c,1); ++h_ini
     end
     linea:=alltrim(linea)
     ///QuitaEspacio(@h_ini,@h_fin,@fp,@c)
     swUse:=.F.
     if linea=="use"
        linea:=NULL
        while c!=chr(10) .and.h_ini<=h_fin
           while c!="," .and. c!=chr(10) .and. h_ini<=h_fin
              linea+=c
              fread(fp,@c,1); ++h_ini
              nSavePos := fseek( fp, 0, 1 )
              if !swUse
                 swUse:=.T.
              end
           end
           linea:=alltrim(linea)
           if     linea=="bit"   ; _SW_BITS:=.T.
           elseif linea=="date"  ; _SW_DATES:=.T.
           elseif linea=="string"; _SW_STRINGS:=.T.
           elseif linea=="math"  ; _SW_MATHS:=.T.
           elseif linea=="trig"  ; _SW_TRIGS:=.T.
           elseif linea=="base"  ; _SW_BASES:=.T.
           elseif linea=="matrix"; _SW_MATRIXS:=.T.
           elseif linea=="stack" ; _SW_STACKS:=.T.
           elseif linea=="set"   ; _SW_SETS:=.T.
           else; _Error("Error: No reconozco qué quieres usar: "+upper(linea),lineaFisica)
           end
           linea:=NULL
           if c==","; c:=" "; end
        end
        if c==chr(10)
           if !swUse
              _Error("Error: Indica qué set de funciones quieres usar",lineaFisica)
           end
           fseek(fp,nSavePos-1,0); --h_ini
        end
     elseif linea=="define"
        nSavePos:=GETDEFINE(@DEF,@DEFVAR,@DEFBODY,@h_ini,@h_fin,@fp,@c,@lineaFisica)
        if c==chr(10)  // por si resulto ser una linea simple
           fseek(fp,nSavePos-1,0); --h_ini
        end
        linea:=NULL
     elseif linea=="import"
        ////linea:="#"+linea+" "
      /*** SE ACEPTAN:
          #import file.*     todas las funciones del archivo file
          #import file.funcion  la funcion especidicada.
          #import file.{fun1,fun2,fun3...}  una lista de funciones
          Al cargar cada funcion, se invoca _Carga_archivo recursivamente, luego [se borran
          los numeros de linea y] se añade a variable "linea".
          El archivo temporal generado con cada invocacion debe ser eliminado luego de su
          proceso.
          Como el archivo ya viene preprocesado, solo se debe grabar y continuar dentro de este
          mismo contexto.
          [En PASO 2: especificar _lineexe con un array de arrays para multiples numeros de linea,
          a pesar de que manda el primero.]
          PARA EVITAR LA LLAMADA RECURSIVA, AÑADIR UNA OPCION AL COMPILADOR: "-L", CON LO CUAL SE
          OBTIENE EL ARCHIVO ".LIB" LUEGO DE LA CARGA Y ANÁLISIS: EN VEZ DE GENERAR EL BINARIO, 
          RECUPERA (SI EL ANALISIS FUE EXITOSO), EL ARCHIVO TEMPORAL, Y AQUÍ SOLO SE ABRE Y SE PEGA.
          DE ESTA MANERA, PUEDO USAR ARCHIVOS DE LIBRERÍA CON #DEFINE Y TODA ESA MIERDA!
          EL ARCHIVO LIBRERÍA DEBERIA TENER LA SECCION "ALGORITHM:/STOP", PERO VACIA, PARA QUE NO
          DE ERROR DE COMPILACION.
          ***/
          linea:=NULL
          nLineas:=lineaFisica
          QuitaEspacio(@h_ini,@h_fin,@fp,@c)
          pFileInclude:=NULL    // archivo insert
          while c!=chr(10) .and. c!=".".and.h_ini<=h_fin
             pFileInclude+=c
             fread(fp,@c,1); ++h_ini
             nSavePos := fseek( fp, 0, 1 )
          end
          if c!="."
             _Error("Error: No puedo reconocer el archivo: "+pFileInclude,nLineas)
          end
          pFileInclude:=PATH_LIB+_fileSeparator+pFileInclude+".lib"    // armo el archivo LIB
          if !file(pFileInclude)
             _Error("Error: No puedo encontrar el archivo librería: "+pFileInclude,nLineas)
          end
          fpi:=memoread(pFileInclude)
         /*** VEO SI ES "*" o algun nombre de funcion ***/
          fread(fp,@c,1); ++h_ini
          if c=="*"   // carga toda la huea
             linea+=fpi
          elseif c=="{"   // es una lista de funciones
             pLinea:=NULL
             fread(fp,@c,1); ++h_ini
             while c!=chr(10) .and. c!="}".and.h_ini<=h_fin
                if c!="/"
                   pLinea+=c
                else   // busca el puto comentario
                   fread(fp,@c,1); ++h_ini
                   if c=="*"
                      BloqueComentario(@h_ini,@h_fin,@fp,@nLineas,@c)
                   elseif c=="/"
                      while c!=chr(10) .and.h_ini<=h_fin
                         fread(fp,@c,1); ++h_ini
                         nSavePos := fseek( fp, 0, 1 )
                      end
                      if c==chr(10)
                         fseek(fp,nSavePos-1,0); --h_ini
                         exit
                      end
                   else
                      _Error("Error: ¿Qué hueá es esto por la chucha?: '/"+c+"'",nLineas)
                   end
                end
                fread(fp,@c,1); ++h_ini
                nSavePos := fseek( fp, 0, 1 )
                if c=="/"
                   fread(fp,@c,1); ++h_ini
                   if c=="*"
                      BloqueComentario(@h_ini,@h_fin,@fp,@nLineas,@c)
                   elseif c=="/"
                      while c!=chr(10) .and.h_ini<=h_fin
                         fread(fp,@c,1); ++h_ini
                         nSavePos := fseek( fp, 0, 1 )
                      end
                      if c==chr(10)
                         fseek(fp,nSavePos-1,0); --h_ini
                         exit
                      end
                   else  // es nombre de funcion y tiene esta huea
                      _Error("Error: No es un nombre de función: "+pLinea,nLineas)
                   end
                elseif c=="," .or. c=="}"  //
                  /*** carga la funcion ***/
                   pLinea:=alltrim(pLinea)
                   pString:=CARGAFUNCION(@fpi,@STKSTR,pLinea)
                   if pString=="-1"
                      _Error("Error: No existe la función especificada: "+pLinea,nLineas)
                   end
                   linea+=pString
                   pLinea:=NULL
                   if c!="}"
                      fread(fp,@c,1); ++h_ini    // leo siguiente caracter
                      nSavePos := fseek( fp, 0, 1 )
                   end
                end
             end
             if len(pLinea)>0   // quedó una funcion sin leer
               /*** carga la funcion ***/
               
                setcolor("0/6")
                outstd(_CR+ "*** Guarning ***"+_CR)
                outstd( "(LINEA:"+alltrim(str(lineaFisica))+"): no usaste '}' al final de la lista. Pasa por esta vez (8=DjO)" +_CR)
                setcolor("") 
                pLinea:=alltrim(pLinea)
                pString:=CARGAFUNCION(@fpi,@STKSTR,pLinea)
                if pString=="-1"
                   _Error("Error: No existe la función especificada: "+pLinea,nLineas)
                end
                linea+=pString
             end
             
          else   // solo carga una funcion
             pLinea:=NULL
             while .T.
                if c!="/"
                   pLinea+=c
                   fread(fp,@c,1); ++h_ini
                   nSavePos := fseek( fp, 0, 1 )
                   while c!=chr(10).and.h_ini<=h_fin
                      if c=="/"   // debe ser un comentario pq es una sola función
                         fread(fp,@c,1); ++h_ini
                         if c=="*"
                            BloqueComentario(@h_ini,@h_fin,@fp,@nLineas,@c)
                            fread(fp,@c,1); ++h_ini
                         elseif c=="/"
                            while c!=chr(10) .and.h_ini<=h_fin
                               fread(fp,@c,1); ++h_ini
                               nSavePos := fseek( fp, 0, 1 )
                            end
                            if c==chr(10)
                               fseek(fp,nSavePos-1,0); --h_ini
                               exit
                            end
                         end
                      else
                         pLinea+=c
                         fread(fp,@c,1); ++h_ini
                         nSavePos := fseek( fp, 0, 1 )
                      end
                   end
                   if c==chr(10)
                      fseek(fp,nSavePos-1,0); --h_ini
                   end
                   pLinea:=alltrim(pLinea)
                   pString:=CARGAFUNCION(@fpi,@STKSTR,pLinea)
                   if pString=="-1"
                      _Error("Error: No existe la función especificada: "+pLinea,nLineas)
                   end
                   linea+=pString
                   exit
                else   // busca el puto comentario: debe ser de bloque.
                   fread(fp,@c,1); ++h_ini
                   if c=="*"
                      BloqueComentario(@h_ini,@h_fin,@fp,@nLineas,@c)
                      fread(fp,@c,1); ++h_ini
                   else
                      _Error("Error: No declaraste ninguna función a importar, merme: '/"+c+"'",nLineas)
                   end
                end
             end
             
          end
          linea:=strzero(LineaFisica,10)+":"+linea
          if substr(linea,len(linea),1)==_CR
             linea:=substr(linea,1,len(linea)-1) // quito el CR
          end
          linea:=strtran(linea,_CR,_CR+strzero(LineaFisica,10)+":")
          linea+=_CR

          fwrite(ft,linea,len(linea))
          linea:=NULL
        //  ++lineaFisica
            
     elseif linea=="include"
      /*** Se aceptan: 
          #include <archivo.def>  para buscar en directorio "include"
          #include ./archivo.def  para buscar en otro lado
          ***/
        QuitaEspacio(@h_ini,@h_fin,@fp,@c)
        pFileInclude:=NULL
        while c!=chr(10) .and. c!=" ".and.h_ini<=h_fin
           pFileInclude+=c
           fread(fp,@c,1); ++h_ini
           nSavePos := fseek( fp, 0, 1 )
        end
        if substr(pFileInclude,1,1)=="<"
           pFileInclude:=substr(pFileInclude,2,len(pFileInclude))
           pFileInclude:=substr(pFileInclude,1,at(">",pFileInclude)-1)
           if !file(PATH_INCLUDE+_fileSeparator+pFileInclude)
              _Error("Error: No existe en directorio 'include': "+pFileInclude,lineaFisica)
           end
           fpi:=fopen(PATH_INCLUDE+_fileSeparator+pFileInclude)
           if ferror()!=0
              _Error("Error: No puedo abrir el archivo: "+pFileInclude,lineaFisica)
           end
        else
           if !file(pFileInclude)
              _Error("Error: No existe encuentro el archivo include: "+pFileInclude,lineaFisica)
           end
           fpi:=fopen(pFileInclude)
           if ferror()!=0
              _Error("Error: No puedo abrir el archivo: "+pFileInclude,lineaFisica)
           end
        end
        i_fin:=fseek(fpi,0,2)
        i_ini:=fseek(fpi,0,0)
        c:=" "
        while .T.
           while c!="#".and.i_ini<=i_fin
              fread(fpi,@c,1); ++i_ini
           end
           if i_ini>i_fin
              fclose(fpi)
              exit
           end
          // busco palabra "define" 
           linea:=NULL
           fread(fpi,@c,1); ++i_ini
           while isalpha(c) .and. i_ini<=i_fin
              linea+=c
              fread(fpi,@c,1); ++i_ini
           end
           linea:=alltrim(linea)
           if linea=="define"
    //          ? linea
              nLineas:=lineaFisica  // no importa. Es para el error
              nLineas:=GETDEFINE(@DEF,@DEFVAR,@DEFBODY,@i_ini,@i_fin,@fpi,@c,@nLineas)
           else
              _Error("Error: directiva 'define' no es válida",lineafisica)
           end
        end
        linea:=NULL
        ++lineaFisica
     else
        _Error("Error: Directiva de preproceso no reconocida: "+upper(linea),lineafisica)
     end
     
  elseif c=='"'    // es un string: lo leo completo: OJO debo cambiar los "\&" por "&"
   /* OJO: SI APARECEN CADENAS FUERA DE LUGAR, AQUÍ ESTÁ EL PROBLEMA CON EL RANDOM */
     pString:=NULL
     //pCodeString:=c      // para resguardar el string de cambios futuros
     c:=" "
     while c!=chr(10).and.c!='"'.and.h_ini<=h_fin
        fread(fp,@c,1); ++h_ini
        // AQUI NO DEBO PONER ANALISIS DE "\n" PORQUE VA EN XBUSCACONST
        if c == "\"   // veo si es '\"'
           fread(fp,@c,1); ++h_ini
           pString+="\"+c
           c:=" "
        else
           if c!='"'
              pString+=c
           end
        end
     end
     if c==chr(10)
        _Error("Error: Cadena sin cerrar",lineafisica)
     end
    // ? "-->PSTRING:",pString
     pCodeString:="___XUsTr"+alltrim(str(int(hb_random()*1000000000)))+"___"
     aadd(STKSTR,{pCodeString,pString})
     linea+='"'+pCodeString+'"'
  elseif c==";"      // separador de instrucciones
     linea:=alltrim(linea)
     if len(linea)>0
        if linea=="algorithm:" .or. linea=="begin:"
           swCuerpo:=.T.
        end
        if linea=="end"
           swCuerpo:=.F.
        end
        
        linea:=_CAMBIODEFINE(@DEF,@DEFVAR,@DEFBODY,linea,@lineaFisica)
        
       /**** PARA DESPUÉS, CUANDO TENGA MI ARCHIVO TEMPORAL LSTO ****/ 
        if swCuerpo
           linea:=BUSCAMATENDURO(linea,lineaFisica)
           
           if "^[" $ linea 
              linea:=_BuscaEstaticos(linea,lineaFisica)
           end
           
           linea:=_PREPROCESO(linea)
           
           linea:=SEPARAESTRUCT(linea,lineaFisica)
           linea:=REPLASIGCOMP(linea,lineaFisica)
           linea:=SEPARACOMBINADOS(linea,lineaFisica)
           linea:=REPLSEMANTOS(linea)
           ct:=0
           while at("{",linea)>0 .and. at("?",linea)>0 .and. "}" $ linea .and. ++ct<20
               
              linea:=EXPANSIONMACRO(linea,lineaFisica)
           end
           linea:=REPLIFFINLINE(linea,STKSTR)
        else
           if ":=" $ linea
              linea:=strtran(linea,":=","=")
           end
        end
        
       /**** reemplazar CR por num linea fisica ****/ 
           if nLineaTemp>0
              if nLineaAmp>0
                 nLineaTemp:=nLineaAmp
              end
              linea:=strzero(nLineaTemp,10)+":"+alltrim(linea)
           else
              if nLineaAmp==0
                 linea:=strzero(lineaFisica,10)+":"+alltrim(linea)
              else
                 linea:=strzero(lineaAmp,10)+":"+alltrim(linea)
              end
           end
           if _CR $ linea
              if nLineaTemp>0
                 if nLineaAmp>0
                    nLineaTemp:=nLineaAmp
                 end
                 linea:=strtran(linea,_CR,_CR+strzero(nLineaTemp,10)+":")
              else
                 if nLineaAmp==0
                    linea:=strtran(linea,_CR,_CR+strzero(LineaFisica,10)+":")
                 else
                    linea:=strtran(linea,_CR,_CR+strzero(nLineaAmp,10)+":")
                 end
              end
           end
           nLineaTemp:=0
           nLineaAmp:=0
        linea+=_CR
        
        fwrite(ft,linea,len(linea));
           
      //  aadd(Ret,{alltrim(hb_utf8tostr(linea)),lineaFisica})
        linea:=NULL
        STKSTR:={}
     end
  elseif c=="."   // ver si se trata de un write
     fread(fp,@c,1); ++h_ini
     nSavePos := fseek( fp, 0, 1 )
     if c=='"'
        linea+="write "
        fseek(fp,nSavePos-1,0); --h_ini
     else
        if c!=chr(10)
           linea+="."+c
        else
           linea+="."
           fseek(fp,nSavePos-1,0); --h_ini
        end
     end
  elseif c=="/"
     fread(fp,@c,1); ++h_ini
     nSavePos := fseek( fp, 0, 1 )     
     if c == "*"     // es un comentario de bloque
        if len(alltrim(linea))>0
           nLineaTemp:=lineaFisica
        end
        BloqueComentario(@h_ini,@h_fin,@fp,@lineaFisica,@c)
        if nLineaTemp == lineaFisica  // no hubo salto
           nLineaTemp:=0
        end
     elseif c == "/"  // comentario de linea
        nSavePos:=LineaComentario(@h_ini,@h_fin,@fp,@c)  // no se usa nSavePos
     else
        linea+="/"
        fseek(fp,nSavePos-1,0); --h_ini
     end
  elseif c=="0"       // podría ser un numero con base
      // 0xAB12h, 0x123o, 0x011010101b ??
     pString:=c
     c:=" "
     fread(fp,@c,1); ++h_ini
     nSavePos := fseek( fp, 0, 1 )
     if c=="x"   // es un numero con base!
        pString:=""
        while c!=chr(10).and.h_ini<=h_fin
           fread(fp,@c,1); ++h_ini
           if isdigit(c) .or. c=="A".or.c=="B".or.c=="C".or.c=="D".or.c=="E".or.c=="F"
              pString+=c
              c:=" "
           else
              exit
           end
        end
        if c=="b"     // es hexadecimal
           for i:=1 to len(pString)
              xt:=substr(pString,i,1)
              if xt!="0" .and. xt!="1"
                 _Error("Error: Número binario mal formado",lineafisica)
              end
           end
           pString:=hb_ntos(BINTODEC(pString))
        elseif c=="o"   // es octal
           for i:=1 to len(pString)
              xt:=substr(pString,i,1)
              if !(xt $ "01234567")
                 _Error("Error: Número octal mal formado",lineafisica)
              end
           end
           pString:=hb_ntos(OCTALTODEC(pString))
        elseif c=="h"    // es binario
           for i:=1 to len(pString)
              xt:=substr(pString,i,1)
              if !(xt $ "0123456789ABCDEF")
                 _Error("Error: Número hexadecimal mal formado",lineafisica)
              end
           end
           pString:=hb_ntos(HEXATODEC(pString))
        else   // no es ninguna hueá: error!
              _Error("Error: Base numérica no reconocida por XU",lineafisica)
        end 
        linea+=pString
     else
        // es otra cosa continua...
        if c==chr(10).or. c==";".or.c=="/"  // podría ser inicio de comentario
           fseek(fp,nSavePos-1,0); --h_ini
           linea+=pString
        else
           linea+=pString+c
        end
     end
     
  elseif isdigit(c)    // esto, porque podría ser un número en notación científica
     // n.nEk, n.nE-k
     // numeros así no aceptan negativos. Se debe hacer: (n.nEk*(-1))
     pString:=c
     c:=" "
     sw:=.T.
     while c!=chr(10).and.h_ini<=h_fin.and.sw
        fread(fp,@c,1); ++h_ini
        nSavePos := fseek( fp, 0, 1 )
        if isdigit(c) .or. c=="."
           pString+=c
           c:=" "
        elseif c=="e" .or. c=="E"   // notacion cientifica
           pString+=upper(c)
           while c!=chr(10).and.h_ini<=h_fin
              fread(fp,@c,1); ++h_ini
              nSavePos := fseek( fp, 0, 1 )
              if isdigit(c)
                 pString+=c
              elseif c=="-" .or. c=="+"
                 pString+=c
              else
                 fseek(fp,nSavePos-1,0); --h_ini
                 sw:=.F.
                 exit
              end
              c:=" "
           end
           if c==chr(10)
              fseek(fp,nSavePos-1,0); --h_ini
              c:=" "
           end
           if ISNOTATION(pString)==1
              xt:=val(substr(pString,at("E",pString)+1,len(pString)))
              if xt<0
                 xt:=xt*(-1)
              end
              if xt>14
                 pString:='e2d("'+pString+'")'
                 ///_Error("Error: Use la función E2D() para usar este número",lineafisica)
              else
                // ? "string = ",pString
                // ? "normal = ",E2D(pString)
                 pString:=alltrim(str(E2D(pString)))
                // ? "alltrim str string = ",pString
              end
           else
              _Error("Error: Número en notación científica mal formado",lineafisica)
           end
           linea+=pString
           exit
        else
           // es otra cosa continua...
           if c!=chr(10).and.c!=";".and.c!="/"
              linea+=pString+c
           end
           exit
        end
     end
     if c==chr(10).or.c==";".or.c=="/"
        fseek(fp,nSavePos-1,0); --h_ini
        linea+=pString
     end
        
  else
   /* OJO: PUEDO LEER ALPHA,"_" Y NUMEROS Y DEJARLO EN PSTRING POR SI EL SIGUIENTE ES UN "[" */
     if !swEspacio
        linea+=c
     end
     if c==" "
        if !swEspacio
           swEspacio:=.T.
        end
     end
  end 
end

if len(linea)>0   // por si no hay salto de linea al final del archivo
  linea+=_CR
  linea:=strzero(lineaFisica,10)+":"+alltrim(linea)
  fwrite(ft,linea,len(linea));
  //aadd(Ret,{linea,lineaFisica})
end
fclose(ft)
fclose(fp)

return

function BinToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

// si uso FOR nX:=1 TO nLen, harbour toma: FOR nX:=1 000237 nLen, por el #define!!

   for nX := 1 to nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "01" ) - 1 ) * ( 2 ^ ( nLen - nX ) )
   end

return nNumber

function OctalToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

   for nX := 1 to nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "01234567" ) - 1 ) * ( 8 ^ ( nLen - nX ) )
   end

return nNumber

function HexaToDec( cString )

   LOCAL nNumber := 0, nX
   LOCAL cNewString := AllTrim( cString )
   LOCAL nLen := Len( cNewString )

   for nX := 1 to nLen
      nNumber += ( At( SubStr( cNewString, nX, 1 ), "0123456789ABCDEF" ) - 1 ) * ( 16 ^ ( nLen - nX ) )
   end

return nNumber

function BUSCAMATENDURO(a,lineaFisica)
LOCAL nPos,cVar,pIzq,pLinea,pString,pAnterior,numFilas,numColumnas,numPaginas,numBloques
LOCAL cColumnas,swPrimeraCol,swPrimeraRow,swPrimeraPag,swPrimeraBlk
LOCAL pDim,cPar,cParc,pSeccion,cSeccion,nTok,i,c,ctaPar,aTemp

aTemp:=a

nPos:=at("<-",a)
cVar:=alltrim(substr(a,1,nPos-1))
a:=alltrim(substr(a,nPos+2,len(a)))
pIzq:=substr(a,1,2)
pLinea:=NULL
pString:=NULL
pAnterior:=NULL

cColumnas:=0
swPrimeraCol:=.T.
swPrimeraRow:=.T.
swPrimeraPag:=.T.
swPrimeraBlk:=.T.
numFilas:=0
numColumnas:=0
numPaginas:=0
numBloques:=0

if pIzq=="_("
   nPos:=rat(")",a)
   if nPos>0
      a:=substr(a,1,nPos-1)  // quito ")"
      a:=substr(a,3,len(a))  // quito "_("
   else
      _Error("Error: NO CERRASTE EL CASTOR",lineaFisica)
   end

   /*** SACO DIMENSIONES ***/
   pDim := alltrim(substr(a,1,at(")",a)))
   cParc := numtoken(pDim,",")
   if cParc==1
      pSeccion:={"mat.row("}
      cSeccion:={0}
   elseif cParc==2
      pSeccion:={"mat.row(","mat.col("}
      cSeccion:={0,0}
   elseif cParc==3
      pSeccion:={"mat.pg(","mat.row(","mat.col("}
      cSeccion:={0,0,0}
   elseif cParc==4
      pSeccion:={"mat.bk(","mat.pg(","mat.row(","mat.col("}
      cSeccion:={0,0,0,0}
   else
      _Error("Error: DIMENSION UNDERFLOW U OVERFLOW",lineaFisica)
   end
   a:=alltrim(substr(a,at(")",a)+1,len(a)))
   pLinea:="dim "+cVar+pDim+_CR

   if len(a)==0
      return pLinea
   elseif numtoken(a,",")==1
      /*** DECLARA PARA RELLENAR CON UN VALOR ***/
      a:=substr(a,at("{",a)+1,len(a))
      a:=substr(a,1,at("}",a)-1)
      pLinea+=cVar+"<-("+a+")"
      return pLinea
 /*  elseif numtoken(a,",")==2
      // declara con doble relleno 
      if at("?",a)==0
         a:=substr(a,at("{",a)+1,len(a))
         a:=substr(a,1,at("}",a)-1)
         pLinea+="{"+cVar+","+cVar+"}<-{"+a+"}"
         return pLinea
      end */
   end
   /*** SACO LOS PARENTESIS Y GUARDO DIMENSIONES DECLARADAS ***/
   nTok:={}
   pDim:=substr(pDim,2,len(pDim))
   pDim:=substr(pDim,1,len(pDim)-1)
   if len(alltrim(pDim))==0
      _Error("Error: NO DECLARASTE NINGUNA DIMENSION",lineaFisica)
   end
   for i:=1 to cParc
      aadd(nTok,val(token(pDim,",",i)))
   end
   /*** ANALISIS ***/
   pLinea+="use ("+cVar+")"+_CR
   cPar:=0
   i:=1

   while i<=len(a)
      c:=substr(a,i,1)
      if c=="{"
            ++cPar
            if cPar>4
               _Error("Error: DIMENSION DECLARADA EXCEDIDA",lineaFisica)
            end 
            if cPar>0 .and. cPar<=cParc
               pLinea+=pSeccion[cPar]+alltrim(str(++cSeccion[cPar]))+")"+_CR
            else
               _Error("Error: ARRAY ESTATICO MAL FORMADO (1)",lineaFisica)
            end
      elseif c=="}"
         if pAnterior!="}"
            if len(alltrim(pString))>0
               pLinea+="mat.put("+alltrim(pString)+")"+_CR
            else
               _Error("Error: NO SE ADMITEN ELEMENTOS NULOS",lineaFisica)
            end
            pString:=NULL
            ++cColumnas
         end
         if cParc==1
            if swPrimeraRow
               swPrimeraRow:=.F.
               numFilas:=cSeccion[cPar]
            else
               if numFilas!=cSeccion[cPar]
                  _Error("Error: ARRAY ESTATICO MAL FORMADO (FILAS)",lineaFisica)
               end
            end
         elseif cParc==2
            if cPar==1
               if swPrimeraRow
                  swPrimeraRow:=.F.
                  numFilas:=cSeccion[cPar]
               else
                  if numFilas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (FILAS)",lineaFisica)
                  end
               end
            else
               if swPrimeraCol
                  swPrimeraCol:=.F.
                  numColumnas:=cSeccion[cPar]
               else
                  if numColumnas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (COLUMNAS)",lineaFisica)
                  end
               end
            end
         elseif cParc==3
            if cPar==1
               if swPrimeraPag
                  swPrimeraPag:=.F.
                  numPaginas:=cSeccion[cPar]
               else
                  if numPaginas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (PAGINAS)",lineaFisica)
                  end
               end
            elseif cPar==2
               if swPrimeraRow
                  swPrimeraRow:=.F.
                  numFilas:=cSeccion[cPar]
               else
                  if numFilas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (FILAS)",lineaFisica)
                  end
               end
            else
               if swPrimeraCol
                  swPrimeraCol:=.F.
                  numColumnas:=cSeccion[cPar]
               else
                  if numColumnas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (COLUMNAS)",lineaFisica)
                  end
               end
            end
         elseif cParc==4
            if cPar==1
               if swPrimeraBlk
                  swPrimeraBlk:=.F.
                  numBloques:=cSeccion[cPar]
               else
                  if numBloques!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (BLOQUES)",lineaFisica)
                  end
               end
            elseif cPar==2
               if swPrimeraPag
                  swPrimeraPag:=.F.
                  numPaginas:=cSeccion[cPar]
               else
                  if numPaginas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (PAGINAS)",lineaFisica)
                  end
               end
            elseif cPar==3
               if swPrimeraRow
                  swPrimeraRow:=.F.
                  numFilas:=cSeccion[cPar]
               else
                  if numFilas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (FILAS)",lineaFisica)
                  end
               end
            else
               if swPrimeraCol
                  swPrimeraCol:=.F.
                  numColumnas:=cSeccion[cPar]
               else
                  if numColumnas!=cSeccion[cPar]
                     _Error("Error: ARRAY ESTATICO MAL FORMADO (COLUMNAS)",lineaFisica)
                  end
               end
            end
         end
         cColumnas:=0
         cSeccion[cPar]:=0
         --cPar
         if cPar<0
            _Error("Error: PUSISTE UNA '}' DE MÁS",lineaFisica)
         end
         pAnterior:="}"
      elseif c==","
         if pAnterior!="}"
            if len(alltrim(pString))>0
               pLinea+="mat.put("+alltrim(pString)+")"+_CR
            else
               _Error("Error: NO SE ADMITEN ELEMENTOS NULOS",lineaFisica)
            end
            if cPar>0 .and. cPar<=cParc
               pLinea+=pSeccion[cPar]+alltrim(str(++cSeccion[cPar]))+")"+_CR
            else
               _Error("Error: ARRAY ESTATICO MAL FORMADO (2)",lineaFisica)
            end
            pString:=NULL
            ++cColumnas
         else
            while c!="{" .and.i<=len(a)
               c:=substr(a,++i,1)
               if c!="{"
                  if c!=" "
                     _Error("Error: QUE HUEA ES ESTO? ==> "+c,lineaFisica)
                  end
               end
            end
            if c=="{"
               if cPar>0 .and. cPar<=cParc
                  pLinea+=pSeccion[cPar]+alltrim(str(++cSeccion[cPar]))+")"+_CR
               else
                  _Error("Error: ARRAY ESTATICO MAL FORMADO (3)",lineaFisica)
               end
               --i
            else
               _Error("Error: ARRAY ESTATICO MAL FORMADO (4)",lineaFisica)
            end
            pAnterior:=NULL
         end
      elseif c=="!"
         ctaPar:=0
         while ++i<=len(a)
            c:=substr(a,i,1)
            if c==","
               if ctaPar==0
                  --i
                  exit
               end
            elseif c=="{"
               ++ctaPar
            elseif c=="}"
               --ctaPar
               if ctaPar<0
                  --i
                  //numFilas:=1
                  exit
               end
            end 
            pString+=c
         end
      else  // es un caracter leible
         pString+=c
      end
      ++i
   end
else
   return aTemp
end

/*** COMPROBACION DE DIMENSIONES ***/


if cParc==1
   if numFilas!=nTok[1]
      _Error("Error: FILAS DECLARADAS NO COINCIDEN CON FILAS LEIDAS"+str(numFilas)+","+str(nTok[1]),lineaFisica)
   end
elseif cParc==2
   if numFilas!=nTok[1]
      _Error("Error: FILAS DECLARADAS NO COINCIDEN CON FILAS LEIDAS"+str(numFilas)+","+str(nTok[1]),lineaFisica)
   end
   if numColumnas!=nTok[2]
      _Error("Error: COLUMNAS DECLARADAS NO COINCIDEN CON COLUMNAS LEIDAS"+str(numColumnas)+","+str(nTok[2]),lineaFisica)
   end
elseif cParc==3
   if numPaginas!=nTok[3]
      _Error("Error: PAGINAS DECLARADAS NO COINCIDEN CON PAGINAS LEIDAS"+str(numPaginas)+","+str(nTok[3]),lineaFisica)
   end
   if numFilas!=nTok[1]
      _Error("Error: FILAS DECLARADAS NO COINCIDEN CON FILAS LEIDAS"+str(numFilas)+","+str(nTok[1]),lineaFisica)
   end
   if numColumnas!=nTok[2]
      _Error("Error: COLUMNAS DECLARADAS NO COINCIDEN CON COLUMNAS LEIDAS"+str(numColumnas)+","+str(nTok[2]),lineaFisica)
   end
else
   if numBloques!=nTok[4]
      _Error("Error: BLOQUES DECLARADOS NO COINCIDEN CON BLOQUES LEIDOS O ARRAY MAL FORMADO"+str(numBloques)+","+str(nTok[4]),lineaFisica)
   end
   if numPaginas!=nTok[3]
      _Error("Error: PAGINAS DECLARADAS NO COINCIDEN CON PAGINAS LEIDAS"+str(numPaginas)+","+str(nTok[3]),lineaFisica)
   end
   if numFilas!=nTok[1]
      _Error("Error: FILAS DECLARADAS NO COINCIDEN CON FILAS LEIDAS"+str(numFilas)+","+str(nTok[1]),lineaFisica)
   end
   if numColumnas!=nTok[2]
      _Error("Error: COLUMNAS DECLARADAS NO COINCIDEN CON COLUMNAS LEIDAS"+str(numColumnas)+","+str(nTok[2]),lineaFisica)
   end
end
return substr(pLinea,1,len(pLinea)-1)

function CARGAFUNCION(fpi,STKSTR,pLinea)
LOCAL nLen,i,j,c,linea,pLen,tLen,lRet:=""
LOCAL pCodeString,pString
LOCAL swFind:=.F.,swFin:=.F.
nLen:=mlcount(fpi,512)
pLen:=len(pLinea)
i:=0
while ++i<=nLen .and. !swFin
   linea:=alltrim(memoline(fpi,1024,i))
   if substr(linea,1,at("=",linea)-1)==pLinea
      swFind:=.T.
      while i<=nLen   // leo toda la funcion
        /*** ANALIZO PRESENCIA DE STRINGS Y CODIFICO POR LINEA LEIDA ***/
/*         if '"' $ linea
            j:=0
            tLen:=len(linea)
            while ++j<=tLen
               c:=substr(linea,j,1)
               if c=='"'   // es un string
                  pCodeString:=NULL
                  c:=NULL
                  pString:=NULL
                  while ++j<=tLen .and. c!='"'
                     c:=substr(linea,j,1)
                     if c == "\"   // veo si es '\"'
                        c:=substr(linea,++j,1)
                        pString+="\"+c
                     else
                        if c!='"'
                           pString+=c
                        end
                     end
                  end
                  pCodeString:="___XUsTr"+alltrim(str(int(hb_random()*1000000000)))+"___"
                  aadd(STKSTR,{pCodeString,pString})
                  lRet+='"'+pCodeString+'"'
               else
                  lRet+=c
               end
            end
            lRet+=_CR
         else */
            lRet+=linea+_CR
            if linea=="end"
               swFin:=.T.
               exit
            end
      //   end
         linea:=alltrim(memoline(fpi,1024,++i))
      end
   end
end
if !swFind
   lRet:="-1"
end
return lRet

function EXPANSIONMACRO(linea,lineaFisica)
LOCAL pLinea,nLen,i,j,Temporal,sInst,pCodeI,pCodeD
LOCAL pAsigna,nPos,n,c,pEvalua,sLen,nCntElse,pComb
LOCAL pTox:=NULL,swTox:=.F.,ctaPar
/*** NO S EPUEDE PONER DENTRO DE NINGUNA ESTRUCTURA, POR EJEMPLO:
     WHILE A<{C=0?10:100} O IF STRLEN({C=0?SVAR1:SVAR2})>0
     PORQUE EXPANDE A "IF", LUEGO, DEJARÍA UNA ESTRUCTURA AL MENOS
     SIN CERRAR.
     ESTO eXPANDE ASI:  return {c=1? 1 : n*.fact(n-1)}
     if c=1
        return 1
     else
        return n*.fact(n-1)
     end
     ***/

 pLinea:=NULL
 nLen:=mlcount(linea,1024)
 for i:=1 to nLen
    Temporal:=alltrim(memoline(linea,1024,i))

    if "?" $ Temporal /*.and. ":" $ Temporal */.and. "{" $ Temporal .and. "}" $ Temporal
       sInst:=alltrim( substr(Temporal,1,at(" ",Temporal)) )
       if sInst!="if" .or. sInst!="while" .or. sInst!="eval" .or. sInst!="room" // ver otras
        /*** busco pCodeI lado izquiero ***/
          nPos:=at("{",Temporal)
          pCodeI:=substr(Temporal,1,nPos-1)

        /*** busco pEvalua ***/
          n:=1
          pEvalua:="{"
          sLen:=len(Temporal)
          while n!=0 .and. ++nPos<=sLen
             c:=substr(Temporal,nPos,1)
             if c=="{"
                ++n
             elseif c=="}"
                --n
             end
             pEvalua+=c
          end
          if n!=0
             _Error("Error: Macro mal formada, como vó (ctm): "+pEvalua,lineaFisica)
          end

        /*** busco pCodeD lado derecho ***/
          pCodeD:=substr(Temporal,++nPos,sLen)  // luego buscar pCodeD "{" y llamar recursivamente

        /*** empieza la evaluacion ***/ 
          sLen:=len(pEvalua)
          j:=1
          pAsigna:=NULL
          nCntElse:=0
          while j<=sLen
             c:=substr(pEvalua,j,1)
             if c=="{"
                pLinea+="if "
                while ++j<=sLen
                   c:=substr(pEvalua,j,1)
                   if c=="?"
                      pLinea+=_CR
                      ++nCntElse
                      exit
                   else
                      pLinea+=c
                   end
                end
                if j>sLen
                   _Error("Error: Macro mal formada, como vó : "+pEvalua,lineaFisica)
                end
             elseif c="!"   // toma lo que hay tal cual, hasta "}"
                pAsigna:=NULL
                ctaPar:=0
                while ++j<=sLen
                   c:=substr(pEvalua,j,1)
                   if c=="{"
                      ++ctaPar
                   elseif c=="}"
                      --ctaPar
                   end   
                   pAsigna+=c
                   if ctaPar==0
                     /* if c!="{" .and. c!="!"
                         _Error("Error: Macro mal formada ("+c+"):"+pEvalua,lineaFisica)
                      end */
                      exit
                   end
                end
               /** veo si hay expresiones combinadas **/
                if at(",",pAsigna)>0
                   pComb:=NULL
                   if swTox
                      pComb+=alltrim(strtran(substr(pTox,4,len(pTox)),_CR,"") )
                      pComb+="<-"+pAsigna
                   else
                      pComb+=pCodeI+" "+pAsigna
                   end
                  // ?"PCOMB=",pComb
                   pComb:=SEPARACOMBINADOS(pComb,lineaFisica)
                   pLinea+=REPLSEMANTOS(pComb)+_CR
                else   
                   if swTox
                      plinea+=pTox
                   end
                   pLinea+=pCodeI+" "+pAsigna+" "+pCodeD
                end
               // else
               //  if swTox
               //       plinea+=pTox
               //  end
               //  pLinea+=pCodeI+" "+pAsigna+" "+pCodeD
               // end
                pAsigna:=NULL
               // --j
               // ? "EXPAN -->",pLinea
             elseif c==":"
                if substr(pEvalua,j-1,1)!="["  // es un array 3D
                   if len(alltrim(pAsigna))>0
                      if swTox
                         pLinea+=pTox
                      end
                      pLinea+=pCodeI+" "+pAsigna+" "+pCodeD+_CR
                      pAsigna:=NULL
                   end
                   --nCntElse
                   pLinea+="else"+_CR
                else
                   pAsigna+=c
                end
             elseif c=="}"
                if len(alltrim(pAsigna))>0
                   if swTox
                      pLinea+=pTox
                   end
                   pLinea+=pCodeI+" "+pAsigna+" "+pCodeD+_CR
                   pAsigna:=NULL
                end
                //swTox:=.F.
                pLinea+="endif"+_CR
             else
                pAsigna+=c
             end
             ++j  
          end
        //  ?"PLINEA=",pLinea
          if nCntElse>0
             setcolor("0/6")
             outstd( _CR+hb_utf8tostr("*** Guarning ***")+_CR )
             outstd( hb_utf8tostr("(LINEA:"+alltrim(str(lineaFisica))+"): No agregaste un ':'. Podría redundar en un error. Pasa por ahora.")+_CR)
             setcolor("")
             
          elseif nCntElse<0
             _Error("Error: Pusiste un ':' de más, merme",lineaFisica) 
          end
       else
          _Error("Error: No se puede expandir esta macro en una estructura: "+sInst,lineaFisica)
       end
    else
       if substr(Temporal,1,3)!="tox" 
          if Temporal!="else" .and. Temporal!="endif"
             if swTox
                pLinea+=pTox
             end
          end
          pLinea+=Temporal+_CR
          swTox:=.F.
       else
          /*** guardo "tox x" para ser asignado en caso de expresiones combinadas ***/
          pTox:=Temporal+_CR
          swTox:=.T.
       end
    end
 end

return substr(pLinea,1,len(pLinea)-1)

function REPLIFFINLINE(linea,STKSTR)
LOCAL pLinea,nLen,i,j,Temporal,sLen
 sLen:=len(STKSTR)
 pLinea:=NULL
 nLen:=mlcount(linea,1024)
 for i:=1 to nLen
    Temporal:=alltrim(memoline(linea,1024,i))

    if "++" $ Temporal
       Temporal:=strtran(Temporal,"++","finc ")
    end
    if "--" $ Temporal
       Temporal:=strtran(Temporal,"--","fdec ")
    end 
    
   /*** REEMPLAZO EL CODIGO STRING ***/
    if sLen>0
       for j:=1 to sLen
          if STKSTR[j][1] $ Temporal
             Temporal:=strtran(Temporal,STKSTR[j][1],STKSTR[j][2])
          end
       end
    end
   /*** ***/ 
    pLinea+=Temporal+_CR
 end
return substr(pLinea,1,len(pLinea)-1)

function REPLASIGCOMP(linea,lineaFisica)
LOCAL pLinea,nLen,i,Temporal,pVar,pFin,nAtPos
 pLinea:=NULL
 nLen:=mlcount(linea,1024)
 for i:=1 to nLen
    Temporal:=alltrim(memoline(linea,1024,i))      
    if "<-+" $ Temporal 
         nAtpos:=at("<-+",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"+"+pFin)+_CR
    elseif "<--" $ Temporal
         nAtpos:=at("<--",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"-"+pFin)+_CR
    elseif "<-*" $ Temporal
         nAtpos:=at("<-*",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"*"+pFin)+_CR
    elseif "<-/" $ Temporal
         nAtpos:=at("<-/",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"/"+pFin)+_CR
    elseif "<-\" $ Temporal
         nAtpos:=at("<-\",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"\"+pFin)+_CR
    elseif "<-%" $ Temporal
         nAtpos:=at("<-%",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"%"+pFin)+_CR
    elseif at("<-^",Temporal)>0
        /*** chequear si no es un aray estático mal declarado ***/
         if at("<-^[",Temporal) > 0
            _Error("Error: Debes castear el array estático",lineaFisica)
         end
         nAtpos:=at("<-^",Temporal)
         pVar:=substr(Temporal,1,nAtPos-1)
         pFin:=substr(Temporal,nAtPos+3,len(Temporal))
         if "{" $ pVar .or. "{" $ pFin
            _Error("Error: Esta combinación no es válida",lineaFisica)
         end
         pLinea+=alltrim(pVar+"<-"+pVar+"^"+pFin)+_CR
    else
         pLinea+=Temporal+_CR
    end
 end   
 
return substr(pLinea,1,len(pLinea)-1)

function REPLSEMANTOS(linea)
LOCAL pLinea,nLen,i,Temporal
LOCAL op1,op2,pPos

 pLinea:=NULL
 nLen:=mlcount(linea,1024)
 for i:=1 to nLen
    Temporal:=alltrim(memoline(linea,1024,i))

    
    /*** REEMPLAZO CASTORES ***/
    Temporal:=_cambia_array(Temporal)
    
    /*** ANALIZO SI HAY VALOR ABSOLUTO ***/ 
    if "|" $ Temporal
       Temporal:=_Valor_Absoluto(Temporal)
    end 
    
    if "<->" $ Temporal
       op1:=substr(Temporal,1,at("<->",Temporal)-1)
       op2:=substr(Temporal,at("<->",Temporal)+3,len(Temporal))
       pLinea+="swap "+op1+" "+op2+_CR
       
    elseif "<-" $ Temporal
       pPos:=at("<-",Temporal)
       op1:=substr(Temporal,1,pPos-1)
       op2:=substr(Temporal,pPos+2,len(Temporal))
       pLinea+="tox "+op1+_CR+"mov "+op2+_CR
    else
       pLinea+=Temporal+_CR   
    end
 end
return substr(pLinea,1,len(pLinea)-1)

function DESCOMBINA(Temporal)
LOCAL cuerpo1,cuerpo2,s,c,ctaPar,pAsigna,pLinea
pLinea:=NULL
            cuerpo1:=alltrim(substr(Temporal,1,at("<-",Temporal)-1))   // rescato el receptor
            cuerpo2:=alltrim(substr(Temporal,at("<-",Temporal)+2,len(Temporal)))
          //  if at("{",cuerpo2)==1   //"{" $ cuerpo2
               cuerpo2:=substr(cuerpo2,2,len(cuerpo2))  // quito "{" del conjunto
               cuerpo2:=substr(cuerpo2,1,len(cuerpo2)-1) // quito "}"
          //  end
           /** recorro la linea en busca de "?:"**/ 
            s:=NULL
            c:=1
            ctaPar:=0
            pAsigna:=NULL
            while c<=len(cuerpo2)
               s:=substr(cuerpo2,c,1)
               if s=="{"
                  ++ctaPar
                  pAsigna+=s
               elseif s=="}"
                  --ctaPar
                  pAsigna+=s
               elseif s==","
                  if ctaPar==0
                     pLinea+=cuerpo1 + "<-" + pAsigna + _CR
                     pAsigna:=NULL
                  else
                     pAsigna+=s
                  end
               else
                  pAsigna+=s
               end  
               ++c 
            end
            if len(alltrim(pAsigna))>0
               pLinea+=cuerpo1 + "<-" + pAsigna + _CR
            end
          //  ? "hasta aqui: ",pLinea 
           /*** aqui termina insercion ***/
         /*   tot2:=numtoken(cuerpo2,",")
            c:=1
            while c<=tot2
               pLinea+=cuerpo1 + "<-" + token(cuerpo2,",",c) + _CR
               ++c
            end */
return pLinea

function SEPARACOMBINADOS(linea,lineaFisica)
/****** DEBO SEPARAR COSAS COMO ESTA:
   X<-Y<-Z
   X,Y<-Z
   X,Y<-A,B eg: [a 1], x <- 10, mth.sqrt([a 1])
   con X simple o "[]"
   PUSH{x,y,z,...}
   FOR X<-1 TO N STEP 2
   DIM X(N,M,..)
   RESHAPE X(N,M,...)
   SELECT / CASE
   ********************/
LOCAL Temporal,posAsig,i,j,k,nLen,nPos,nAtpos,nDim,pTemporal
LOCAL pLinea,pVar,pIni,pFin,pInc,pTo,pQuita,tokCuerpo2
LOCAL Estructura,c,s,cuerpo1,cuerpo2,tot1,tot2,ctaPar,pAsigna
   pLinea:=NULL
   nLen:=mlcount(linea,512)
   for i:=1 to nLen
      Temporal:=alltrim(memoline(linea,1024,i))
  
      if substr(Temporal,1,4)=="push"
         nPos:=at("{",Temporal)
         if nPos>0   // push combinado!
            nTok:=numtoken(Temporal,",")
            if nTok>1
               Temporal:=substr(Temporal,nPos+1,len(Temporal))
               Temporal:=substr(Temporal,1,rat("}",Temporal)-1)
               s:=NULL
               c:=1
               ctaPar:=0
               pAsigna:=NULL
               while c<=len(Temporal)
                  s:=substr(Temporal,c,1)
                  if s=="{"
                     ++ctaPar
                     pAsigna+=s
                  elseif s=="}"
                     --ctaPar
                     pAsigna+=s
                  elseif s==","
                     if ctaPar==0
                        pLinea+="push " + pAsigna + _CR
                        pAsigna:=NULL
                     else
                        pAsigna+=s
                     end
                  else
                     pAsigna+=s
                  end  
                  ++c 
               end
               if len(alltrim(pAsigna))>0
                  pLinea+="push " + pAsigna + _CR
               end
             //  for j:=1 to nTok
             //     pLinea+="push "+token(Temporal,",",j)+_CR
             //  end
            else
               pLinea+=Temporal+_CR
            end
         else
            pLinea+=Temporal+_CR
         end
         
      elseif substr(Temporal,1,2)=="++"
         pLinea+="inc "+substr(Temporal,3,len(Temporal))+_CR
      elseif substr(Temporal,1,2)=="--"
         pLinea+="dec "+substr(Temporal,3,len(Temporal))+_CR
         
      elseif substr(Temporal,1,5)=="write"
         cuerpo1:=alltrim(substr(Temporal,6,len(Temporal)))  // saco write
         c:=1
         tot1:=numtoken(cuerpo1, ",")
         while !empty(cuerpo1) .and. c<=tot1
            pVar:=token(cuerpo1,",",c++)
            pLinea+="write "+pVar+_CR 
         end
         
      elseif substr(Temporal,1,1)=="!"  // asignación con target múltiple
         nPos:=at("<-",Temporal)
         if nPos>0
            Temporal:=substr(Temporal,2,len(Temporal))
            //cuerpo1:=alltrim(substr(Temporal,1,nPos-1))
            cuerpo2:=alltrim(substr(Temporal,nPos,len(Temporal)))
            if at(",",cuerpo2)>0
               Temporal:=DESCOMBINA(Temporal)
               pIni:=numtoken(Temporal,_CR)
               for j:=1 to pIni
                  pTemporal:=token(Temporal,_CR,j)

                  nPos:=at("<-",pTemporal)
                  cuerpo1:=alltrim(substr(pTemporal,1,nPos-1))
                  cuerpo2:=alltrim(substr(pTemporal,nPos,len(pTemporal)))
                  cuerpo1:=EXPANSIONMACRO(cuerpo1,lineaFisica)
                  nPos:=mlcount(cuerpo1,1024)
                  for k:=1 to nPos
                     pAsigna:=alltrim(memoline(cuerpo1,1024,k))
                     if substr(pAsigna,1,2)!="if" .and. pAsigna!="else".and.pAsigna!="endif"
                        pLinea+=pAsigna+cuerpo2+_CR
                     else
                        pLinea+=pAsigna+_CR
                     end
                  end
               end
            else
               cuerpo1:=alltrim(substr(Temporal,1,nPos-1))
               cuerpo1:=EXPANSIONMACRO(cuerpo1,lineaFisica)
               nPos:=mlcount(cuerpo1,1024)
               for j:=1 to nPos
                  pAsigna:=alltrim(memoline(cuerpo1,1024,j))
                  if substr(pAsigna,1,2)!="if" .and. pAsigna!="else".and.pAsigna!="endif"
                     pLinea+=pAsigna+cuerpo2+_CR
                  else
                     pLinea+=pAsigna+_CR
                  end
               end
            end
            //? pLinea
         else
            Temporal:=substr(Temporal,2,len(Temporal))
            pLinea+=EXPANSIONMACRO(Temporal,lineaFisica)+_CR
           // ? pLinea
            //_Error("Error: Esta expansión requiere una asignación (<-)",lineaFisica)
         end
      elseif at("<-",Temporal)>0 .and. at("{",Temporal)>at("<-",Temporal)
         pLinea:=DESCOMBINA(Temporal)
         
      elseif numat("<-",Temporal)>1 .and. substr(Temporal,1,3)!="for"  
         // hay que procesar esta linea: []<-[]<-...<- valor
         cuerpo1:=substr(Temporal,rat("<-",Temporal)+2,len(Temporal))   // rescato el valor
         cuerpo2:=substr(Temporal,1,rat("<-",Temporal)-1)  // lista []<-[]<-..

         while numat("<-",cuerpo2)>=1
            pVar:=substr(cuerpo2,rat("<-",cuerpo2)+2,len(cuerpo2))
            cuerpo2:=substr(cuerpo2,1,rat("<-",cuerpo2)-1)
            pLinea+=pVar+"<-"+cuerpo1+_CR
         end
         pLinea+=cuerpo2+"<-"+cuerpo1+_CR
         
      elseif substr(Temporal,1,1)=="{" .and. at("<-",Temporal)>0
         cuerpo1:=alltrim(substr(Temporal,1,at("<-",Temporal)-1))
         cuerpo2:=alltrim(substr(Temporal,at("<-",Temporal)+2,len(Temporal)))

         cuerpo1:=substr(cuerpo1,2,len(cuerpo1))  // caso los "{" externos
         cuerpo1:=substr(cuerpo1,1,len(cuerpo1)-1)
         if "{" $ cuerpo2
            cuerpo2:=substr(cuerpo2,2,len(cuerpo2))
            cuerpo2:=substr(cuerpo2,1,len(cuerpo2)-1)
         end

         tot1:=numtoken(cuerpo1,",")
         /*** extraigo los tokens de cuerpo2
              solo debe haber igual numero que tot1, o bien,
              un solo token.
              valor distinto: error 
              Luego, se asigna a continuacion a cuerpo1 ***/
         tokCuerpo2:={} // aqui se asignan los token de cuerpo2
         s:=NULL
            c:=1
            ctaPar:=0
            pAsigna:=NULL
            while c<=len(cuerpo2)
               s:=substr(cuerpo2,c,1)
               if s=="{"
                  ++ctaPar
                  pAsigna+=s
               elseif s=="}"
                  --ctaPar
                  pAsigna+=s
               elseif s==","
                  if ctaPar==0
                     aadd(tokCuerpo2, pAsigna)
                     pAsigna:=NULL
                  else
                     pAsigna+=s
                  end
               else
                  pAsigna+=s
               end  
               ++c 
            end
            if len(alltrim(pAsigna))>0
               aadd(tokCuerpo2, pAsigna)
            end
          //  ? "hasta aqui: ",pLinea
           tot2:=len(tokCuerpo2)
         if tot1==tot2
            c:=1
            while c<=tot1
               pLinea+=token(cuerpo1,",",c) + "<-" + tokCuerpo2[c]+_CR
               ++c
            end
         elseif tot2==1  // hay uno solo que asigna a todos
            c:=1
            while c<=tot1
               pLinea+=token(cuerpo1,",",c) + "<-" + tokCuerpo2[1] + _CR
               ++c
            end
         elseif tot1!=tot2    // hay diferencia, error
            _Error("Error: Asignación múltiple no es simétrica (debe haber correspondencia)",lineaFisica)
         end  
       //    ? pLinea
       /*  tot2:=numtoken(cuerpo2,",")
         
         if tot1==tot2
            c:=1
            while c<=tot1
               pLinea+=token(cuerpo1,",",c) + "<-" + token(cuerpo2,",",c)+_CR
               ++c
            end
         elseif tot2==1  // hay uno solo que asigna a todos
            c:=1
            while c<=tot1
               pLinea+=token(cuerpo1,",",c) + "<-" + cuerpo2 + _CR
               ++c
            end
         elseif tot1!=tot2    // hay diferencia, error
            _Error("Error: Asignación múltiple no es simétrica (debe haber correspondencia)",lineaFisica)
         end */

      elseif substr(Temporal,1,8)=="for each"
  //       ;
         pVar:=token(Temporal," ",3)  //2) para foreach
         pTo:= token(Temporal," ", 4)   //3) para foreach
         cuerpo1:=token(Temporal," ",5)  //4)
         pFin:="Tk0819"+pVar
         pIni:="Ct0819"+pVar
        
         // aniade variables para el hash de variables
         if ASCAN(_Stack_nvar,pFin)==0
            aadd(_Stack_nvar,pFin)
         end
         if ASCAN(_Stack_nvar,pIni)==0  
            aadd(_Stack_nvar,pIni)
         end
         if pTo=="in"    // es un string
            pLinea+=pIni+"<-0"+_CR 
            pLinea+=pFin+"<-xcode_nc 3 ("+cuerpo1+")"+_CR
            pLinea+="while ("+pIni+" < "+pFin+")"+_CR
            pLinea+="inc "+pIni+_CR
            pLinea+=pVar+"<-strtok ("+cuerpo1+" "+pIni+")"+_CR  
         elseif pTo=="inlist"    // es un stack
            pLinea+="use "+cuerpo1+_CR 
            pLinea+=pIni+"<-0"+_CR 
            pLinea+=pFin+"<-vget (xmsize ("+cuerpo1+") 2)"+_CR
            pLinea+="while ("+pIni+" < "+pFin+")"+_CR
            pLinea+="inc "+pIni+_CR
            pLinea+="tfstk_code 1 "+pIni+_CR
            pLinea+=pVar+"<-.getdata"+_CR
         else        // es un error
            _Error("Error: FOR EACH está formulado como las hueas",lineaFisica) 
         end

      elseif substr(Temporal,1,3)=="for"
         Temporal:=substr(Temporal,4,len(Temporal))
         pTo:=at("downto",Temporal)
         if pTo==0
            pTo:=at("to",Temporal)
            pQuita:=2  // por "to"
         else
            pQuita:=6  // por "downto"
         end
         pIni:=alltrim(substr(Temporal,1,pTo-1))
         pVar:=alltrim(substr(pIni,1,at("<-",pIni)-1))
         Temporal:=alltrim(substr(Temporal,pTo+pQuita,len(Temporal)))
         pTo:=at("step", Temporal)
         if pTo==0
            pFin:=Temporal
            if pQuita==2
               pLinea+=pIni+" - 1"+_CR+"while "+pVar+" < "+pFin +;
                       _CR+"inc "+pVar+_CR
            else   // es un "downto"
               pLinea+=pIni+" + 1"+_CR+"while "+pVar+" > "+pFin +;
                       _CR+"dec "+pVar+_CR
            end
         else
            pFin:=substr(Temporal,1,pTo-1)
            pInc:=substr(Temporal,pTo+4,len(Temporal))
            if pQuita==2
               pLinea+=pIni+" - "+pInc+_CR+"while ("+pVar+"+"+pInc+") <= "+pFin +;
                       _CR+pVar+"<-"+pVar+" + "+pInc+_CR
            else
               pLinea+=pIni+" + "+pInc+_CR+"while ("+pVar+"-"+pInc+") >= "+pFin +;
                       _CR+pVar+"<-"+pVar+" - "+pInc+_CR
            end
         end

      elseif Temporal=="next"
         pLinea+="wend"+_CR

      elseif substr(Temporal,1,3)=="pop"
         pLinea+="pop"+_CR
         
      elseif substr(Temporal,1,7)=="reshape"
        // obtengo elementos
         Temporal:=alltrim(substr(Temporal,8,len(Temporal)))   // saco "reshape "
         nPos:=at("(",Temporal)
         if substr(Temporal,len(Temporal),1)!=")"
            _Error("Error: Paréntesis desbalanceados en RESHAPE",lineaFisica)
         else
            Temporal:=substr(Temporal,1,len(Temporal)-1)
         end
         pVar:=alltrim(substr(Temporal,1,nPos-1))
         nDim:=alltrim(substr(Temporal,nPos+1,len(Temporal)))
         pLinea+="reshape "+pVar+" "
         pInc:=1
         nPos:=at(",",nDim)
         while nPos>0
            pLinea+=substr(nDim,1,nPos-1)+" "
            nDim:=alltrim(substr(nDim,nPos+1,len(nDim)))
            nPos:=at(",",nDim)
            ++pInc
            if pInc>4
               _Error("Error: Sobra una dimensión. Ergo, puedes incrustártela en el orto",lineaFisica)
            end
         end
         pLinea+=nDim
         for j = pInc+1 to 4
            pLinea+=" 0"
         end
         pLinea+=_CR

      elseif substr(Temporal,1,3)=="dim"
         // obtengo elementos
         Temporal:=substr(Temporal,4,len(Temporal))   // saco "dim "
         nPos:=at("(",Temporal)
         if substr(Temporal,len(Temporal),1)!=")"
            _Error("Error: Paréntesis desbalanceados en DIM",lineaFisica)
         else
            Temporal:=substr(Temporal,1,len(Temporal)-1)
         end
         pVar:=alltrim(substr(Temporal,1,nPos-1))
         nDim:=alltrim(substr(Temporal,nPos+1,len(Temporal)))
         pLinea+="set_array "
         pInc:=1
         nPos:=at(",",nDim)
         while nPos>0
            pLinea+=substr(nDim,1,nPos-1)+" "
            nDim:=alltrim(substr(nDim,nPos+1,len(nDim)))
            nPos:=at(",",nDim)
            ++pInc
            if pInc>4
               _Error("Error: Solo me la puedo con hasta 4 dimensiones",lineaFisica)
            end
         end
         pLinea+=nDim
         for j = pInc+1 to 4
            pLinea+=" 0"
         end
         pLinea+=_CR+"config_array "+pVar+_CR

      elseif substr(Temporal,1,4)=="eval"
         pLinea+=strtran (Temporal,"for","=")+_CR
 
      elseif substr(Temporal,1,4)=="case"
         if ":" $ Temporal
            cuerpo1:=substr(Temporal,1,at(":",Temporal)-1)
            Temporal:=alltrim(substr(Temporal,at(":",Temporal)+1,len(Temporal)))
            if empty(Temporal)
               pLinea+=cuerpo1+_CR
            else
               ////pLinea+=cuerpo1+_CR+Temporal+_CR // no s epuede, porque si es "write"
               //// quedaría sin ser separado.
               _Error("Error: Sentencia 'case...:' <y-nada-más-aquí-huea>",lineaFisica)
            end
         else
            pLinea+=Temporal+_CR
         end
      elseif substr(Temporal,1,9)=="otherwise"
         if ":" $ Temporal
            cuerpo1:=substr(Temporal,1,at(":",Temporal)-1)
            Temporal:=alltrim(substr(Temporal,at(":",Temporal)+1,len(Temporal)))
            if empty(Temporal)
               pLinea+=cuerpo1+_CR
            else
               _Error("Error: Sentencia 'otherwise' <y-nada-más-aquí-huea>",lineaFisica)
            end
         else
            pLinea+=Temporal+_CR
         end
  
      elseif substr(Temporal,1,1)==":"  // recursividad
         pLinea+="recursive"+_CR+alltrim(substr(Temporal,2,len(Temporal)))+_CR+"endr"+_CR
      else
         pLinea+=Temporal+_CR   
      end
   end
return substr(pLinea,1,len(pLinea)-1)

function SEPARAESTRUCT(linea,lineaFisica)
LOCAL Temporal,pLinea:="",sLinea:="",tLinea:="",i,j
LOCAL pos_cond,Estructura,Orden,pOrden
LOCAL pStruct:={},nLen

tLinea:=linea
nLen:=mlcount(linea,1024)

for j:=1 to nLen
   linea:=memoline(tlinea,1024,j)
   if "," $ linea    // existen mas de un proceso en la fila
      Temporal:=linea
      pLinea:=linea
      while "," $ Temporal
         pos_cond:=rat(",",Temporal)             // rat x at
         Estructura:=alltrim(substr(Temporal,pos_cond+1,len(Temporal)) )

        // procesa estructura
         Orden:=alltrim(substr(Estructura,1,at(" ",Estructura)) )
         pOrden:=alltrim(substr(Estructura,1,at("(",Estructura)-1) )
      
         if Orden=="while" .or. pOrden=="while"
            aadd(pStruct,{Estructura,"wend"})
         elseif Orden=="if" .or. pOrden=="if"
            aadd(pStruct,{Estructura,"endif"})
         elseif Orden=="until" .or. pOrden=="until"
            aadd(pStruct,{"do",Estructura})
         else
            exit 
         end
        /*** extraigo estructura de la linea pa seguir webeando ***/
         Temporal:=substr(Temporal,1,pos_cond-1)
         pLinea:=Temporal
        /*** ***/
      end
     /*** proceso estructuras ***/
      if len(pStruct)>0
         for i:=len(pStruct) to 1 step -1  // si no encontró estructuras, esto se salta
            pLinea:=pStruct[i][1]+_CR+pLinea+_CR+pStruct[i][2]
         end
      end
      sLinea+=pLinea+_CR
   else
      //return linea
      sLinea+=linea+_CR
   end
next
sLinea:=substr(sLinea,1,len(sLinea)-1) // quito el último CR
return sLinea //pLinea


procedure GETDEFINE(DEF,DEFVAR,DEFBODY,h_ini,h_fin,fp,c,lineaFisica)
LOCAL pDefine,pBodyDef,pVarDef,nTok,iTok,nSavePos,aTempVar:={},cta_c:=0
pDefine:=NULL
pBodyDef:=NULL
pVarDef:=NULL
/************** DEBO ACEPTAR COSAS COMO ESTA:
  #define PUSH(X,Y)        ... use(X); push Y 
  #define VECTOR(X,Y)      ...   [X Y]
  #define PRNVECTOR(X,Y,Z) ... {  Y<-0; do \\
                                        write [X Y]\\
                                     until (++Y)=Z } 
  #define IMPRIME_LA_HUEA(X,Y)...  write X,Y,"\n"
  #define PRINT         ... write
***************/

/*** obtengo el avatar del define. LEO HASTA el " " ***/
        
        QuitaEspacio(@h_ini,@h_fin,@fp,@c)
        
        while c!=" ".and.c!=chr(10) .and.h_ini<=h_fin
           pDefine+=c
           fread(fp,@c,1); ++h_ini
           nSavePos := fseek( fp, 0, 1 )
        end
        if c==chr(10)
           _Error("Error: El salto de línea no va aquí, hueón de la mente",lineafisica)
        end
        pDefine:=alltrim(pDefine)
        
/*** obtengo el cuerpo del define ***/
        c:=" "
        QuitaEspacio(@h_ini,@h_fin,@fp,@c)
        
     //   if c=="{"   // es un conjunto de instrucciones
     //      c:=" "
     //      ++cta_c
     //      QuitaEspacio(@h_ini,@h_fin,@fp,@c)
           if c==chr(10)
              _Error("Error: Debes empezar a definir aquí, no en la línea siguiente, huea",lineafisica)
           end
           sw_otra_linea:=.F.
           sw_next:=.T.
           //while c!="}" .and. h_ini<=h_fin
           while sw_next .and. h_ini<=h_fin
              pBodyDef+=c
              fread(fp,@c,1); ++h_ini
              nSavePos := fseek( fp, 0, 1 )
              if c=="/"    // quito comentarios
                 fread(fp,@c,1); ++h_ini
                 nSavePos := fseek( fp, 0, 1 )
                 if c=="*"
                    BloqueComentario(@h_ini,@h_fin,@fp,@lineaFisica,@c)
                    fread(fp,@c,1); ++h_ini
                    nSavePos := fseek( fp, 0, 1 )
                 elseif c=="/"
                    nSavePos := LineaComentario(@h_ini,@h_fin,@fp,@c)
                    fread(fp,@c,1); ++h_ini
                    nSavePos := fseek( fp, 0, 1 )
                 else
                    pBodyDef+="/"
                 end
              end
              if c=="{"
                 ++cta_c
                 pBodyDef+=c
                 c:=" "
              elseif c=="}"
                 if cta_c>1
                    --cta_c
                    pBodyDef+="}"
                    c:=" "
                 end
              
              elseif c=="\"
                 fread(fp,@c,1); ++h_ini
                 nSavePos := fseek( fp, 0, 1 )
                 if c=="\"
                    sw_otra_linea:=.T.
                    c:=" "
                 else
                    fseek(fp,nSavePos-1,0); --h_ini
                    c:="\"
                 end
                 
              elseif c==";"
                 pBodyDef+=_CR
                 c:=" "
              elseif c==chr(10)
                 if sw_otra_linea
                    sw_otra_linea:=.F.
                    sw_next:=.T.
                    ++lineaFisica
                 else
                    sw_next:=.F.
                 end
                 
              end
           end
          // ? pBodyDef
          // inkey(0)
           if cta_c!=0
              _Error("Error: Instrucción compuesta '{}' como el pico",lineafisica)
           end
           
    /*    else        // deberia ser simple:
           pBodyDef+=c
           fread(fp,@c,1); ++h_ini
           nSavePos := fseek( fp, 0, 1 )
           while c!=chr(10) .and. h_ini<=h_fin
              pBodyDef+=c
              fread(fp,@c,1); ++h_ini
              nSavePos := fseek( fp, 0, 1 )
              if c=="/"
                 fread(fp,@c,1); ++h_ini
                 nSavePos := fseek( fp, 0, 1 )
                 if c=="*"
                    BloqueComentario(@h_ini,@h_fin,@fp,@lineaFisica,@c)
                    fread(fp,@c,1); ++h_ini
                    nSavePos := fseek( fp, 0, 1 )
                 elseif c=="/"
                    nSavePos:=LineaComentario(@h_ini,@h_fin,@fp,@c)
                    exit
                 else
                    pBodyDef+="/"
                 end
              end
              if c==";"
                 pBodyDef+=_CR
                 c:=" "
              end
           end
        end */
        pBodyDef:=BUSCALINEASBLANCAS(pBodyDef)

        if len(pBodyDef)==0
           _Error("Error: Para qué defines hueás que no vas a completar? "+upper(pDefine),lineafisica)
        end
        pBodyDef:=_CAMBIODEFINE(@DEF,@DEFVAR,@DEFBODY,pBodyDef,lineaFisica)
        
/*** Tiene variables? ***/
        if "(" $ pDefine
           pVarDef:=alltrim( substr(pDefine,at("(",pDefine)+1,len(pDefine)) )
           pVarDef:=alltrim( substr(pVarDef,1,at(")",pVarDef)-1) )
           pDefine:=alltrim( substr(pDefine,1,at("(",pDefine)-1) )

           nTok:=numtoken(pVarDef,",")
           iTok:=1
           while iTok<=nTok
              aadd( aTempVar,TOKEN(pVarDef,",",iTok) )
              ++iTok
           end

        end
        aadd( DEFVAR, aTempVar )  // si no hay vars, len(aTempVar)=0
        aadd( DEF,pDefine )
        aadd( DEFBODY, pBodyDef )
return nSavePos

function _CAMBIODEFINE(DEF,DEFVAR,DEFBODY,linea,lineaFisica)
LOCAL nLen,i,j,nPos,pLinea:="",pLineafin:="",ctaPar 
LOCAL c:="",pPos,pBody:="",tBody,nTok:=0,cTok:=""
nLen:=len(DEF)
for i:=1 to nLen
   if at(DEF[i],linea)>0
      if len(DEFVAR[i])==0   // no tiene variable. solo reemplazo
         linea:=strtran(linea,DEF[i],DEFBODY[i])
      else   // aqui empieza el webeo por la puta
         nPos:=at(DEF[i],linea)
         while nPos>0

           /** identifico la macro en cuestión **/
            ctaPar := 0     // para saber si hay cosas cmo MACRO( a*(b-c), n ) que hueá!!
            pPos:=nPos+len(DEF[i])
            while .T.
               c:=substr(linea,pPos,1)
               if c=="("
                  ++ctaPar
                  if ctaPar>1
                     pBody+=c
                  end
               elseif c==")"
                  --ctaPar
                  if ctaPar>0
                     pBody+=c
                  end
               elseif pPos>=len(linea)
                  _Error("Error: Estas usando mal tu macro, aweonao",lineaFisica)
               else
                  pBody+=c
               end
               
               if ctaPar==0
                  exit
               end
               ++pPos
            end

           /*** aislo la porcion de codigo a procesar ***/
            pLinea:=substr(linea,1,nPos-1)
            pLineaFin:=substr(linea,pPos+1,len(linea))
           /*** procedo con la macro sustitucion ***/
            nTok:=numtoken(pBody,",")
            if nTok!=len(DEFVAR[i])
               _Error("Error: Número de argumentos no coincide: "+pBody,lineaFisica)
            end 
            tBody:=DEFBODY[i]
            for j:=1 to len(DEFVAR[i])
               cTok:=TOKEN(pBody,",",j)
               if len(alltrim(cTok))>0
                  tBody:=strtran(tBody,DEFVAR[i][j],cTok)
               else
                  _Error("Error: Menos argumentos en tu macro de lo esperado: "+DEF[i],lineaFisica)
               end
            end
            linea:=pLinea+tBody+pLineaFin
            pBody:=NULL
            nPos:=at(DEF[i],linea)
         end
      end
   end
end
return linea

function BUSCALINEASBLANCAS(pBodyDef)
LOCAL i,s,nLineas,pLinea:=""
nLineas:=mlcount(pBodyDef,1024)
for i:=1 to nLineas-1
   s:=alltrim(Memoline(pBodyDef,1024,i))
   if len(s)>0
      pLinea+=s+_CR
   end
end
s:=alltrim(Memoline(pBodyDef,1024,i))
if len(s)==0
   pLinea:=substr(pLinea,1,len(pLinea)-1)
else
   pLinea+=s
end

return pLinea

procedure QuitaEspacio(h_ini,h_fin,fp,c)
while c==" " .and. h_ini<=h_fin  // quito espacios de mas
  fread(fp,@c,1); ++h_ini
end
return

procedure BloqueComentario(h_ini,h_fin,fp,lineaFisica,c)
LOCAL cAnt:=""
while h_ini<=h_fin
  fread(fp,@c,1); ++h_ini
  if c=="*"
     fread(fp,@c,1); ++h_ini
     if c=="/"
        exit
     elseif c==chr(10)
        ++lineaFisica
     end
  elseif c=="/" .and. cAnt=="*"
     exit
  elseif c==chr(10)
     ++lineaFisica
  end
  cAnt:=c
end
return

procedure LineaComentario(h_ini,h_fin,fp,c)
while h_ini<=h_fin
   fread(fp,@c,1); ++h_ini   // lee hasta el fin de linea
   nSavePos := fseek( fp, 0, 1 )
   if c==chr(10)
      fseek(fp,nSavePos-1,0); --h_ini
      exit
   end
end
return nSavePos

function _Valor_Absoluto(_l)
local _i,_n,_c , _sw_val, _t:=""

_n:=len(_l)

  _sw_val:=.F.
  _sw_ope:=.F.
  for _i:=1 to _n
    _c:=substr(_l,_i,1)
    if _c==" "
       _t:=_t+_c
       loop
    end
    if _c=="|" 
       if _sw_val 
           if _cant=="+" .or. _cant=="-" .or. _cant=="*" .or. _cant=="?".or.;
              _cant=="/" .or._cant=="\".or._cant=="%".or. _cant=="^".or.;
              _cant==":"
              _c:="math_code(6 "
           else
              _c:=")"
           end
       else
           _sw_val:=.T.
           _c:="math_code(6 "
       end
    end
    _t:=_t+_c
    _cant:=_c
  next
return _t

function _BuscaEstaticos(s,_lv)
//pilas de trabajo:
local _p:=stacknew(), _e:=stacknew(), _s:=stacknew()
// variables de dimensiones
local F:=0,C:=0,P:=0,B:=0 
local fila:=0,col:=0,pag:=0,blk:=0
// switch del sistema
local swfila,swcol,swpag,swblk, swtype,swcoma
// otras variables
local _c, _sust,_type,_cc, _ctapto,_arr
local pos:=0,_ctapar,_nivel

while "^[" $ s
  _p:={}
  pos:=at("^[",s)+2
  stackpush(_p,"{")
  _ctapar:=1
  
  _ctapto:=0
  _c:=""; _sust:="^["
  _type:="";_cc:="";_arr:=""
  swfila:=.T.; swcol:=.T.;swpag:=.T.;swblk:=.T.;swtype:=.T.;swcoma:=.T.
  swdim:=.T.;_dim:=0
  _nivel:=0
  fil:=0;col:=0;pag:=0;blk:=0
  F:=0;C:=0;P:=0;B:=0
  _head:='xustticdm("{'
  while pos<=len(s) .and. _ctapar>0
 
    _c:=substr(s,pos,1)
    _sust:=_sust+_c 
    if _c==" "
       ++pos
       loop
    end
    if _c!="["
       swdim:=.F.
    end
    if _c=="["
       //? "["
       stackpush(_p,_c)
       if swdim
          _dim++
       end
       _ctapar++
    elseif _c==","
       //? ","
       if swcoma
          stackpush(_s,_c)
       else
          swcoma:=.T.
          if swcol
             C:=col
             swcol:=.F.
          end
       end
    elseif _c=="]"
      // ? "] ";?? _ctapar;?? "--- swcoma= ";??swcoma       

       _ctapar--
       if swcoma
          fil++
          swcoma:=.F.
          col:=len(_s)+1
          if !swcol
             if col!=C
                _Error("Error: número de columnas distinto",_lv)  
             else
                col:=0
             end
          end
          _s:={}
          stackpop(_p)
       else
         if _ctapar==0
           if !swfila 
             if fil!=F .and. fil!=0 .and. pag==0
                _Error("Error: número de filas distinto",_lv)  
             end
           else
             F:=fil
             swfila:=.F.
             fil:=0
           end
           ++pos
           loop
         elseif _ctapar==1 
           if !swfila 
             if fil!=F .and. fil!=0 .and. pag>0
                _Error("Error: número de filas distinto",_lv)  
             end
           else
             F:=fil
             swfila:=.F.
           end
           fil:=0
           stackpop(_p)
           col:=0
           
           if _dim<=2
             ++pag
           end
           
           if _dim>=3
             if !swpag
                if pag!=P
                   _Error("Error: número de páginas distinto",_lv)  
                end
             else
                swpag:=.F.
                P:=pag
             end
             blk++
             pag:=0
           end
           
           ++pos
           loop
        elseif _ctapar==2
           if !swfila 
             if fil!=F
                _Error("Error: número de columnas distinto",_lv)  
             end
           else
             F:=fil
             swfila:=.F.
           end
           fil:=0
           pag++
           stackpop(_p)
         end
       end
    elseif _c=='"'
       if swtype
         swtype:=.F.
         _type:="C"
       else
         if _type!="C"
            _Error("Error: tipos distintos en declaración de matriz estática",_lv)  
         end
       end 
       _cc:="'"
       _c:=""
       while _c!='"' .and. pos<=len(s) // busco el string constante
         _c:=substr(s,++pos,1)
         _cc:=_cc+iif(_c=='"',"'",_c)
         _sust:=_sust+_c
       end  
       if pos>len(s)
          _Error("Error: cierra este string como si fuera tu ojete: >>"+_sust+"<<",_lv)  
       end
       stackpush(_e,_cc)
       
    elseif isdigit(_c) .or. _c=="-"
       if swtype
         swtype:=.F.
         _type:="N"
       else
         if _type!="N"
            _Error("Error: tipos distintos en declaración de matriz estática",_lv)  
         end
       end 
       _ctapto:=0
       _cc:=""
       while isdigit(_c) .or. _c=='.' .or. _c=="-" // busco el string constante
         _cc:=_cc+_c
         _c:=substr(s,++pos,1)
         if _c=="."
            ++_ctapto
            if _ctapto>1
               _Error("Error: constante numérica deforme como voh!: "+_sust+">>"+_c+"<<",_lv)  
            end
         elseif _c=="-"
            _Error("Error: métete este signo en el orto: "+_sust+">>"+_c+"<<",_lv)  
         end
         _sust:=_sust+_c
       end  
       if pos>len(s)
          _Error("Error: número trucho!: >>"+_sust+"<<",_lv)  
       end
       if !isdigit(_c)
          --pos  // ajuste por salida de ciclo en una posicion mas
          _sust:=substr(_sust,1,len(_sust)-1)
       end
       stackpush(_e,_cc)
     elseif _c=="t" 
       if swtype
         swtype:=.F.
         _type:="L"
       else
         if _type!="L"
            _Error("Error: tipos distintos en declaración de matriz estática",_lv)  
         end
       end 
       _cc:=_c
       while isalpha(_c)   // busco el string constante
         _c:=substr(s,++pos,1)
         _cc:=_cc+_c
       end  
       _cc:=substr(_cc,1,len(_cc)-1)
       if _cc=="true"
          _sust:=substr(_sust,1,len(_sust)-1)+_cc
       else
          _Error("Error: constante lógica (true) ilógica!: >>"+_cc+"<<",_lv)  
       end          
       --pos
       if pos>len(s) .or. _cc!="true"
          _Error("Error: constante lógica (true) ilógica!: >>"+_sust+"<<",_lv)  
       end
     elseif _c=="f"
       if swtype
         swtype:=.F.
         _type:="L"
       else
         if _type!="L"
            _Error("Error: tipos distintos en declaración de matriz estática",_lv)  
         end
       end 
       _cc:=_c
       while isalpha(_c)   // busco el string constante
         _c:=substr(s,++pos,1)
         _cc:=_cc+_c
       end
       _cc:=substr(_cc,1,len(_cc)-1)
       if _cc=="false"
          _sust:=substr(_sust,1,len(_sust)-1)+_cc
       else
          _Error("Error: constante lógica (false) ilógica!: >>"+_cc+"<<",_lv)  
       end          
       --pos  
       if pos>len(s) 
          _Error("Error: constante lógica (false) ilógica!: >>"+_sust+"<<",_lv)  
       end
     else
       _Error("Error: elemento no reconocido: "+substr(_sust,1,len(_sust)-1)+">>"+_c+"<<",_lv)  
    end  // if de simbolos
       
    // ubico el siguiente caracter
    ++pos
  end // segundo while
  if C==0 .and. col>0
     C:=col
  end
  if P==0 .and. pag>1
     P:=pag
  end
  if B==0 .and. blk>0
     B:=blk
  end
  if F==0 .and. C>0
     F:=C
     C:=0
  end
  _arr:=_head+_arr+strtran(substr(_sust,3,len(_sust)),'"',"'")
  _arr:=strtran(_arr,"true","T")
  _arr:=strtran(_arr,"false","F")
  _arr:=strtran(_arr,"{","")
  _arr:=strtran(_arr,"[","")
  _arr:=strtran(_arr,"]","")
  _arr:=strtran(_arr,"]","")
  
  if _type=="L"
     _arr:=_arr+'" true() '+alltrim(str(F))+' '+alltrim(str(C))+' '+alltrim(str(P))+' '+alltrim(str(B))+')'
  elseif _type=="N"
     _arr:=_arr+'" 0 '+alltrim(str(F))+' '+alltrim(str(C))+' '+alltrim(str(P))+' '+alltrim(str(B))+')'
  else
     _arr:=_arr+'" "'+_type+'" '+alltrim(str(F))+' '+alltrim(str(C))+' '+alltrim(str(P))+' '+alltrim(str(B))+')'
  end
  
  
  s:=strtran(s,_sust,_arr)

  //? s
  if len(_p)>1
     _Error("Error: paréntesis desbalanceados. V.g., si quisiste escribir: ()*() y pusiste: )*()",_lv)
  end
end //primer while

return s

function _cambia_array(s)
local recept,body,s1,s2,command,var
// cambia macros de arrays

if "[" $ s
   if "<-" $ s // puede ser un put disfrazado:
      recept:=alltrim(substr(s,1,at("<-",s)-1))
      body:=alltrim(substr(s,at("<-",s)+2,len(s)))

      // cambiar put a mano:
      
      if substr(recept,1,1)=="["    // hay un put!!
         s1:=substr(recept,2,1)
         if !(s1 $ "_:.>")  // es un vector simple
            var:=substr(recept,2,at(" ",recept)-1)
            recept:="vput "+substr(recept,2,len(recept))
         else
            s1:=substr(recept,1,2)
            if s1=="[_"    // es un put de bloque
               command:="bput "
            elseif s1=="[:"   // es un put de matrix 3d
               command:="pput "
            elseif s1=="[."   // es de matrix 2d
               command:="mput "
            elseif s1=="[>"    // es un rango
               command:="prange "
            end
            recept:=command+substr(recept,3,len(recept))
         end
         
         recept:=substr(recept,1,len(recept)-1)  // quito último parentesis

         if "[" $ recept   // hay posibles gets dentro de put (indireccion)
            recept:=strtran(recept,"[_","bget(")
            recept:=strtran(recept,"[:","pget( ")
            recept:=strtran(recept,"[.","mget( ")
            recept:=strtran(recept,"[@","xmsize( ")
            recept:=strtran(recept,"[=","seqsp( ")
            recept:=strtran(recept,"[\","afindstk( ")
            recept:=strtran(recept,"[%","blkcopy( ")
            recept:=strtran(recept,"[!","unique( ")
   //         recept:=strtran(recept,"[>>","bit_code(5 ")
            recept:=strtran(recept,"[<","grange( ")
            recept:=strtran(recept,"[+|","xmatalter( 1 1 ")  // cat horizontal
            recept:=strtran(recept,"[+-","xmatalter( 1 2 ")  // cat vertical
            recept:=strtran(recept,"[--","xmatalter( 2 1 ") // cut de filas
            recept:=strtran(recept,"[-|","xmatalter( 2 2 ") // cut de columnas
            recept:=strtran(recept,"[^-","ymatalter( 1 ") // ins de filas
            recept:=strtran(recept,"[^|","ymatalter( 2 ") // ins de columnas
            recept:=strtran(recept,"[*'","matrange( 4 ")
            recept:=strtran(recept,"[*|","matrange( 2 ")
            recept:=strtran(recept,"[*-","matrange( 3 ")
            recept:=strtran(recept,"[$","money( ")
            recept:=strtran(recept,"[*","matrange( 1 1 ")  // 1=FANTASMA
            recept:=strtran(recept,"]",")")
            recept:=strtran(recept,"[","vget( ")
         end
      else
         recept:=recept+"<-"
      end
      body:=recept+" "+body
   else
      body := s
   end
  // convierto:
   if "[" $ body   // hay posibles gets
      body:=strtran(body,"[_","bget( ")
      body:=strtran(body,"[:","pget( ")
      body:=strtran(body,"[.","mget( ")
      body:=strtran(body,"[@","xmsize( ")
      body:=strtran(body,"[=","seqsp( ")
      body:=strtran(body,"[\","afindstk( ")
      body:=strtran(body,"[%","blkcopy( ")
      body:=strtran(body,"[!","unique( ")
 //     body:=strtran(body,"[>>","bit_code(5 ")
      body:=strtran(body,"[<","grange( ")
      body:=strtran(body,"[+|","xmatalter( 1 1 ")  // cat horizontal
      body:=strtran(body,"[+-","xmatalter( 1 2 ")  // cat vertical
      body:=strtran(body,"[--","xmatalter( 2 1 ") // cut de filas
      body:=strtran(body,"[-|","xmatalter( 2 2 ") // cut de columnas
      body:=strtran(body,"[^-","ymatalter( 1 ") // ins de filas
      body:=strtran(body,"[^|","ymatalter( 2 ") // ins de columnas
      body:=strtran(body,"[*'","matrange( 4 ")
      body:=strtran(body,"[*|","matrange( 2 ")
      body:=strtran(body,"[*-","matrange( 3 ")
      body:=strtran(body,"[*","matrange( 1 1 ")
      body:=strtran(body,"[$","money( ")
      body:=strtran(body,"]",")")
      body:=strtran(body,"[","vget( ")
    //  body:=strtran(body,";"," ") choca con FOR: no va!
   end
   s:=body
   //? s; inkey(0)
end

return s


/*
function _Carga_archivo(file)
local _ret:={},_i,_v,_l,_tl,_nl,a,_ll:=NULL,_lv:=0,_llv:="", _temp
local _sw_com:=.F.,_sw_compas:=.F.,_inst//,_sw_debug:=0,_sw_debug_final:=.F.
local sw_multiasig:=.F.,ndx:=0, _sw_cuerpo:=.F.,_tmp_file,_tiene_stop:=.F.


    _tmp_file:=file

    outstd(_CR+ "--->Paso I...")
     
//    _temp:=_Detecta_FOR(_Saca_COMENTARIOS(file))
    _temp:=_Detecta_FOR(file)
    outstd( "[Ok]")
    _v:=Memoread(_temp)
    _nl:=MlCount(_v,500)

    outstd(_CR+ "--->Paso II...")

    for _i:=1 to _nl
        _sw_inline:=.F.
        sw_multiasig:=.F.

        _l := alltrim(Memoline(_v,500,_i))

        _lv:= val(substr(_l,1,10))
        _l := substr(_l,11,len(_l))
       
    //****** para aceptar o rechazar agrupacion de asignaciones
        _xltemp:=lower(_l)
        if _xltemp=="algorithm:" .or. _xltemp=="begin:"
            _sw_cuerpo:=.T.
        end
        if _xltemp=="end" //.or. _xltemp=="retorne"     // "emethods:"  ??
            _sw_cuerpo:=.F.
        end
        if _xltemp=="stop"
           _tiene_stop:=.T.
        end

        _l:=_PREPROCESO(_l) 
        // proceso de continuacion de lineas

        _l:=alltrim(_l) 

        if !empty(_l)

        //-------PREPROCESO DESAGREGACIÃ N DE PARRAFOS SIMPLES
           _sw_estr_while:=.F.
           _sw_estr_if:=.F.
           _sw_estr_rep:=.F.
             
           
                    
           if "<-+" $ _l  // desagrego "<-+ y <--, <-* y <-/, <-%, <-\"
              _var:=alltrim(substr(_l,1,at("<-+",_l)-1))  
              _resto:=alltrim(substr(_l,at("<-+",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"+"+_resto+")"

           elseif "<--" $ _l
              _var:=alltrim(substr(_l,1,at("<--",_l)-1))  
              _resto:=alltrim(substr(_l,at("<--",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"-"+_resto+")"

           elseif "<-*" $ _l
              _var:=alltrim(substr(_l,1,at("<-*",_l)-1))  
              _resto:=alltrim(substr(_l,at("<-*",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"*"+_resto+")"

           elseif "<-/" $ _l
              _var:=alltrim(substr(_l,1,at("<-/",_l)-1))  
              _resto:=alltrim(substr(_l,at("<-/",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"/"+_resto+")"

           elseif "<-%" $ _l
              _var:=alltrim(substr(_l,1,at("<-%",_l)-1))  
              _resto:=alltrim(substr(_l,at("<-%",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"%"+_resto+")"

           elseif "<-\" $ _l
              _var:=alltrim(substr(_l,1,at("<-\",_l)-1))  
              _resto:=alltrim(substr(_l,at("<-\",_l)+3,len(_l)))
              _l:=_var+"<-("+_var+"\"+_resto+")"
           end

           _l:=_cambia_array(_l)
           
        //  del tipo  <instruccion>, <if|until|while <expre> >
           
           _tmpl:=_l
           
           if "," $ _l    // existen mas de un proceso en la fila
             if _sw_cuerpo
                _pos_cond:=rat(",",_l)             // rat x at
                _estructura:=alltrim(substr(_l,_pos_cond+1,len(_l)) )

                _l:=alltrim(substr(_l,1,_pos_cond-1))  //obtengo instruccion
                // procesa estructura
                _orden:=alltrim(substr(_estructura,1,at(" ",_estructura)) )
                if _orden=="while"   //
                   aadd (_ret,{_estructura, _lv})
                   ++_nl
                   _sw_estr_while:=.T.
                elseif _orden=="if"   //
                   aadd (_ret,{_estructura, _lv})
                   ++_nl
                   _sw_estr_if:=.T.
                elseif _orden=="until"   //
                   aadd (_ret,{"do", _lv})
                   ++_nl
                   _sw_estr_rep:=.T.
                else
                   if lower(substr(_l,1,6))!="write "
                      _Error("Error(3): Instrucción compuesta no es válida",_lv)
                   else
                      _l:=_tmpl  //_l+","+_estructura
                   end
                end
             end
           end
      
           _var_arr:={}
           
        // -------proceso de separacion de instruccion compuesta:
        // -------del tipo: a <- b <- c <- ... <- valor/expr
           if numat("<-",_l)>1   // esto esta hueveando: numtoken es mula!
              sw_multiasig:=.T.
              _valor:=substr(_l,rat("<-",_l)+2,len(_l))  // obtengo el valor

              _l:=substr(_l,1,rat("<-",_l)+1)
              
              while !empty(_l) 
                 aadd(_var_arr,alltrim(substr(_l,1,at("<-",_l)+1)+_valor))
                 _l:=alltrim(substr(_l,at("<-",_l)+2,len(_l)))
              end
           else
             // _l:=_cambia_array(_l)
              aadd(_var_arr,_l)    // desde aqui se ve todo
           end
        
        //-------FIN PROCESO DESAGREGACIÃ N DE PARRAFOS SIMPLES
           _long:=len(_var_arr)    // a lo menos _long =: 1
           for ndx:=1 to _long
              _l:=_var_arr[ndx]
              _l := _Reemplaza_Semantos(_l)   // antes del siguiente proceso
              _l := _Valor_Absoluto(_l,_i)

              _ll:=NULL
              // busco los "TO" y los separo
              if at(" tox ",_l)>1
                 a:=at(" tox ",_l)
                 _ll:=alltrim( substr(_l,a+1,len(_l)))
                 _l:=alltrim(substr(_l,1,a))
                 _nl++
              end
          
              if !empty(_ll)
                 //--------PREPROCESO VAR<-{<EXPR>?VALOR1:VALOR2}
                 if at("?",_l)>0 .and. at(":",_l)>0  // no puede haber "?" sin ":"
                    if numtoken(_l,"{") == 2
                       if rat("}",_l)==len(_l)
                          _l:=strtran(_l,"}","")
                          if_inline(_ret,substr(_l,at("{",_l)+1,len(_l))+"@"+_ll,_lv,"mov ")
                       else
                          iif_inline(_ret,_l+"13Y_XH98TU"+_ll,_lv)   
                       end
                    else
                       if rat("}",_l)<=len(_l) .and. len(_l)>0
                          iif_inline(_ret,_l+"13Y_XH98TU"+_ll,_lv)   
                       else
                          _Error("Error: Encontré un carácter '{' y no logro determinar su sustancia",_lv)
                       end
                    end
                    _sw_inline:=.T.   
                   //---------FIN PREPROCESO
                 else
                    aadd (_ret,{_ll,_lv})
                 end
              end
              if !_sw_inline    // No hay preproceso de inline
                 if at("?",_l)>0 .and. at(":",_l)>0
                    if numtoken(_l,"{") == 2
                       if rat("}",_l)==len(_l)
                          _inst:=alltrim(substr(_l,1,at("{",_l)-1))
                          _l:=strtran(_l,"}","")
                          if_inline(_ret,alltrim(substr(_l,at("{",_l)+1,len(_l)))+"@"+_inst,_lv,_inst+" ")
                       else
                          iif_inline(_ret,_l,_lv)
                       end
                    else
                       if rat("}",_l)<=len(_l) 
                          iif_inline(_ret,_l,_lv)
                       else
                          _Error("Error: Encontré un car�cter '{' y no logro saber a quién se le cayó...",_lv)
                       end
                    end
                 else  
                    aadd (_ret,{_l,_lv })
                 end
              end
           next      // multi asignacion
           // si hay desagregacion, cierro la estructura
           if _sw_estr_while
              aadd (_ret,{"wend",_lv })
           elseif _sw_estr_if
              aadd (_ret,{"endif",_lv })
           elseif _sw_estr_rep
              aadd (_ret,{_estructura,_lv })
           end
        end
    next
    
   // RECUPERO cadenas en FILE_FOR:
 
  _lcx:=len(_cadenas_x)
  if _lcx>0
    for _j:=1 to len(_ret)
       for _i:=1 to _lcx
          _ret[_j][1]:=strtran(_ret[_j][1],_cadenas_x[_i][1],_cadenas_x[_i][2])
       end
    end
  end
 
  if !_tiene_stop
     _Error("Error: El programa debe terminar con STOP",len(_ret)-3)
  end

 if _sw_pre3
    debug_on(PATH_DEBUG+_fileSeparator+_arch+".xpre")
    _pad:=""
    for k=1 to len(_ret)
       _code:=_ret[k,1]
       if _code=="endif".or._code=="wend".or. "until" $ _code .or._code=="end".or._code=="else".or._code=="next";
           .or. _code=="exception".or._code=="tend".or._code=="lend"
          _pad:=substr(_pad,1,len(_pad)-3)
       elseif _code=="algorithm:".or. _code=="functions:" .or._code=="vars:"
          _pad:=""
       end
       ? padl(_ret[k,2],5)+" : "+_pad+_ret[k,1]  //+ _CR 
       if "while" $ _code .or."if " $ _code.or._code=="do".or._code=="else".or._code=="begin:".or._code=="try";
          .or. _code=="loop"
          _pad:=_pad+"   "
       elseif _code=="algorithm:".or. _code=="functions:" .or._code=="vars:"
          _pad:="   "
       end   
    next
    debug_off() 
 end

return _ret
*/

procedure _header()
    outstd("XU v0.9999999+.2010-2018 --- XU VM ",_CR)
    outstd(hb_UTF8tostr("Diseño y programación (vintash) Daniel Stuardo (Dr.DaLiEn). Full Spanglish!!"),_CR)
    outstd(hb_UTF8tostr("Verano de 2010 - 27F - Laura no está :( - ¡Copitos! :O - Invierno de 2018."),_CR)
    
return

procedure _modo_de_uso()
    _header()
    outstd(_CR+"  Modo de uso:"+_CR+_CR)

    outstd("  XUC <archivo.xu> <[-x][-v][-m][-p][-l][-wret][-verb][-h]>"+_CR)
    outstd(_CR+"--------------------------------------------------------------------------------------")
    outstd(_CR+"  donde:"+_CR)
    outstd("           -x      Genera el archivo XU-CODE ejecutable."+_CR)
    outstd("           -v      Genera un archivo con los objetos variables, constantes y"+_CR)
    outstd("                   direcciones principales (.VAR)."+_CR)
    outstd("           -m      Genera un archivo de mapas de direcciones del programa (.MAP) para"+_CR)
    outstd("                   fines de debugueo."+_CR)
    outstd(hb_UTF8tostr("           -l      Genera un archivo librería con extensión .LIB, y lo guarda en la")+_CR)
    outstd("                   carpeta LIB. Dicho archivo se puede importar con '#import' en el"+_CR)
    outstd(hb_UTF8tostr("                   área de funciones (functions:).")+_CR)
    
    outstd("           -p      Genera el archivo preprocesado (.XPRE) para fines de debugueo."+_CR)
    outstd(hb_UTF8tostr("           -wret   Anula el warning-error generado cuando XU detecta que el valor")+_CR)
    outstd(hb_UTF8tostr("                   devuelto por una función se encuentra dentro de una estructura")+_CR)
    outstd(hb_UTF8tostr("                   de control IF o WHILE u otra.")+_CR)
    outstd(hb_UTF8tostr("           -verb   Muestra las etapas de la compilación. Es aburrida la hueá, así")+_CR)
    outstd(hb_UTF8tostr("                   que mejor omita usar este parámetro mierder.")+_CR)
//////    ?hb_UTF8tostr("           -ra     Almacena funciones atómicas con metadata en la librería KB.")
//////    ?hb_UTF8tostr("           -rc     Almacena una función compleja con metadata en la librerí­a KB.")
//////    ?"           -q      Anexa una cola al programa. Se debe especificar solo el"
//////    ?"                   nombre de la cola, por ejemplo:"
//////    ?"                      ./xuc programa.xu [opciones] -q <nombre de cola>"
//////    ?"                   Si el archivo de cola es message_prueba.queue, el nombre"
//////    ?"                   de la cola será prueba."
//    ?"           -sh     compila la cola para ser abierta en modo compartido."
//    ?"           -ex     compila la cola para ser abierta en modo exclusivo."
    outstd("           -h      Muestra esta ayuda."+_CR+_CR)

    outstd("  Bugs, dudas y aportes: daniel.stuardo@gmail.com"+_CR)
return


function SDP( _lista )
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
return  _Last_valor 


*  Determina si el stack esta vacio
*
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

procedure _Carga_Configuracion()
local _f,_v,_w,_nl,_i,_linea,_p

PATH_XU:=CURDIR()
OSHost:=OS()
OSHost:=upper(alltrim(substr(OSHost,1,at(" ",OSHost))))
if OSHost=="LINUX" .or. OSHost=="DARWIN"
  _fileSeparator:="/"
  PATH_XU:="/"+PATH_XU
elseif OSHost=="WINDOWS"
  _fileSeparator:="\"
end

if !file("."+_fileSeparator+"xuc")
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
   inkey(0)
   quit
else
   _v:=Memoread(PATH_XU+_fileSeparator+"xu.config")
   _nl:=MlCount(_v,100)
   for _i:=1 to _nl
      _linea:=alltrim(Memoline(_v,500,_i))
      if substr(_linea,1,1)!=";"
         if !empty(_linea)
            _w:=upper(alltrim(substr(_linea,1,at("=",_linea)-1)))
            _p:=alltrim(substr(_linea,at("=",_linea)+1,len(_linea)))

            do case
               case _w=="ROOT"
                  PATH_ROOT:=PATH_XU+_fileSeparator+_p
                  //? PATH_ROOT
               case _w=="BINARY"
                  PATH_BINARY:=PATH_XU+_fileSeparator+_p
                  //? PATH_BINARY
               case _w=="SOURCE"
                  PATH_SOURCE:=PATH_XU+_fileSeparator+_p
                  //? PATH_SOURCE
               case _w=="INCLUDE"
                  PATH_INCLUDE:=PATH_XU+_fileSeparator+_p
                  //? PATH_INCLUDE
            /*   case _w=="INTERFACE"
                  PATH_INTERFACE:=_p */
                  //? PATH_INTERFACE
               case _w=="DEBUG"
                  PATH_DEBUG:=PATH_XU+_fileSeparator+_p
                  //? PATH_DEBUG
             /*  case _w=="KB_NAME"
                  LIBNAME:=_p  */
                  //? LIBNAME
               case _w=="TEMP"
                  PATH_TEMP:=PATH_XU+_fileSeparator+_p
                  //? PATH_TEMP
               case _w=="LIB"
                  PATH_LIB:=PATH_XU+_fileSeparator+_p
            end
         end
      end
   next
end

return nil


/** codigo C **/
#pragma BEGINDUMP
#include "hbapi.h"
#include "hbapiitm.h"
#include <ctype.h>
#include <math.h>
#include <stdlib.h>

//  #define _MAC64_
//  #define _LINUX32_
  #define _LINUX64_

#ifdef _MAC64_
   #include <sys/time.h>
#endif
#ifdef _LINUX64_
   #include <time.h>
#endif

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

HB_FUNC ( E2D )
{
   const char *linea = hb_parc(1);
   const char *buf;
   char *sMant;
   double nMant;
   int nExp,mant=0,signo;
   buf=linea;
   while(*buf!='E') {
      mant++;
      ++buf;
   }
   nExp = atoi(++buf);
   sMant = (char *)malloc(sizeof(char)*mant+1);
   strncpy(sMant,linea,mant);
   sMant[mant]='\0';
   if (sMant[0]=='-') {
      signo=(-1); 
      sMant++;
   } else signo=1;
   nMant = atof(sMant);
  // printf("--> %f, %d, %d\n%f\n",nMant,nExp,signo, nMant * pow( (double)10, (double)nExp)*signo);
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
    if(toupper(DX)=='E'){
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


HB_FUNC( ISTNUMBER )  // esto debe ir!! llevar otros codigos semejante a "C"
{
  PHB_ITEM pText = hb_param(1,HB_IT_STRING);
  const char *AX = hb_itemGetCPtr( pText );
  
  hb_retnint(fun_istnumber(AX));
}

/*
 * Harbour Project source code:
 * Stack structure
 *
 * Copyright 2000 Jose Lalin <dezac@corevia.com>
 * www - http://www.harbour-project.org
*/
/* StackNew() --> <aStack>
*/
HB_FUNC( STACKNEW )
{
   hb_itemReturnRelease( hb_itemArrayNew( 0 ) ); /* Create array */
}

/*  StackPush( <aStack>, <xValue> ) --> <aStack>
*/
HB_FUNC( STACKPUSH )
{
   hb_arrayAdd( hb_param( 1, HB_IT_ARRAY ), 
                hb_param( 2, HB_IT_ANY ) );
}

/* StackPop( <aStack> ) --> <xValue>
   Returns NIL if the stack is empty
*/
HB_FUNC( STACKPOP )
{
   PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
   long ulLen = hb_arrayLen( pArray );
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

/* StackIsEmpty( <aStack> ) --> <lEmpty>
*/
/*HB_FUNC( STACKISEMPTY )
{
   hb_retl( hb_arrayLen( hb_param( 1, HB_IT_ARRAY ) ) == 0 );
}*/

/* StackTop( <aStack> ) --> <xValue>
   Returns the top item
*/
/*HB_FUNC( STACKTOP )
{
   PHB_ITEM pLast = hb_itemNew( NULL );

   hb_arrayLast( hb_param( 1, HB_IT_ARRAY ), pLast );

   hb_itemReturnRelease( pLast );
}*/

#pragma ENDDUMP
