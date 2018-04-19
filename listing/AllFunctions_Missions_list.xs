;
;	Interfaccia gestione lista missioni
;		NB: il plantmanager offre solo la visualizzazione della lista,
;		la lista va riempita e controllata all'interno dello script
;
$define SLM_Nessuna			0
$define SLM_Attesa			1
$define SLM_Esecuzione		2
$define SLM_Disabilitata	3
$define SLM_Allarme			4
$define SLM_Eseguita		5
$define SLM_Annullata		6
;
;	Definizione tipi parametri
;
$define X_Type_Int			2
$define X_Type_String		10
;
; Impostazione numero massimo missioni gestite.
; Bisogna chiamare SetNumMissioni() per poter usare la lista missioni.
;
object XListaMissioni
	internal uint pLm	; INTERNAL POINTER - DO NOT TOUCH
	internal 0x090041FE constructor()
	internal 0x090041FF destructor()
	; Prima di usare la lista inizializzarla con numero massimo missioni e titolo
	internal 0x09004100 init(int,string)							; Numero massimo, titolo
	internal 0x09004101 setTitle(string)							; Impostazione titolo finestra
	internal 0x09004102 setParText(int,int,string)					; Parametro,valore parametro,testo -> Definizione testo associato a valore parametro
	internal 0x09004103 parText(int,int) : string					; Parametro,valore : testo associato a valore parametro
	internal 0x09004104 defParam(int,string,uint type=X_Type_Int)	; Definizione parametro (per tutte le missioni)
	; Gestione parametri
	internal 0x09004110 setParam(int idx, int param, int value)		; Missione,parametro,valore
	internal 0x09004111 getParam(int idx, int param) : int			; Missione,parametro : valore
	internal 0x09004112 setPriorita(int idx, int pri)				; Missione,priorita
	internal 0x09004113 getPriorita(int idx) : int					; Missione,priorita
	internal 0x09004114 setStatoMis(int idx, int status, int pri, string desc)
	internal 0x09004115 setStatoMis(int idx, int status)			; Missione,stato
	internal 0x09004116 getStatoMis(int idx) : int					; Missione : stato
	internal 0x09004117 getTempoAttesa(int idx) : real				; Missione : tempo in giorni
	internal 0x09004118 getTempoCambioStato(int idx) : real			; Missione : tempo in giorni
	internal 0x09004119 getDescMis(int idx) : string				; Descrizione missione
	internal 0x0900411A setFlags(int idx, uint mask, bool status)	; Impostazione flag (indice,maschera,stato)
	internal 0x0900411B getFlags(int idx) : uint					; Interrogazione flags missione
	internal 0x0900411C setTempoStartAttesa(int idx, string date)	; Impostazione tempo attesa (data assoluta)
	internal 0x0900411D setStringParam(int idx, int param, string value)	; Missione,parametro,valore
	internal 0x0900411E getStringParam(int idx, int param) : string	; Missione,parametro : valore
	;
	; misDaEseguire() torna l'indice della prossima missione da eseguire.
	;	Viene ritornata la missione che aspetta da maggior tempo tra quelle
	;	con la massima priorita'.
	;	Se non c'e' nessuna missione da eseguire la funzione ritorna il valore -1
	internal 0x09004120 misDaEseguire() : int
	;
	; Funzioni di ricerca
	;
	; cercaValoreParam() ritorna l'indice della prima missione valida
	; per cui il parametro indicato ha il valore cercato.
	; Ritorna -1 se il valore non e' stato trovato
	internal 0x09004130 cercaValoreParam(int,int) : int
	internal 0x09004131 primoPostoLibero() : int			; Indice prima posizione libera
end