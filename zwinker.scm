
(define (script-fu-add-layers-in-order layerlist img form)

	(if (< 0 (length form))
			
			(let* 
			(
				(head (car form))
				(layerToCopy (list-ref layerlist (- head 1)))
				(layer (car 
							(gimp-layer-copy layerToCopy FALSE) 
						)
				)
			)			
				(gimp-item-set-name layer (string-append "Bild " (number->string head)))
				
				(gimp-image-add-layer img layer -1)		
				
				(script-fu-add-layers-in-order layerlist img (cdr form))
			)
		
		0
	)
)

(define (script-fu-zwinker-gif width height pattern dir)
	(let*
	(
		;define local variables
		;create new image;
		(img (car (gimp-image-new width height RGB)))
		
		(open 1)
		
		(pfad (string-append dir "\\"))
		
		(layer1 
					(car
						(gimp-file-load-layer 1 img (string-append pfad "1.png"))
					)
		)
		
		(layer2 	(car
						(gimp-file-load-layer 1 img (string-append pfad "2.png"))
					)
		)
		
		(layer3 	(car
						(gimp-file-load-layer 1 img (string-append pfad "3.png"))
					)
		)
		(display dir)
		(newline)
		;Standard Reihenfolge
		;1111111112332111111123231
		(folge (script-fu-string-to-intlist pattern))
		
		(layerlist(list layer1 layer2 layer3))

	)
	
	(script-fu-add-layers-in-order layerlist img folge)
	
	(gimp-display-new img)
	(gimp-displays-flush)
	;(display pfad)
	;(newline)
	)
)

(define (script-fu-string-to-intlist str)
		
		(let*
		(
			(charlist (string->list str))
			(intlist)
		)
		
		(define (iter i)
			(if	(< i (length charlist)) 
				(let*
				(
					(int (string->number (string(list-ref charlist i))))
				)
					(set! intlist (append intlist (list int)))
					(iter (+ i 1))
				)
				intlist
			)
		)
		(iter 0)
		)
)

(script-fu-register 
	"script-fu-zwinker-gif" 				;zu regestrierende funktion
	"Zwinker Gif"							;name im menu
	"Fügt standartmäßig die Bilder nach dem folgendem Muster zusammen: 
	1111111112332111111123231.
	Die Bilder die normalerweise gewählt werden sind:
	1.png, 2.png und 3.png
	In dem ausgewähltem Ordner.
	Die Bilddateien sind fest im Script integriert,
	aktuell müssen diese noch im Script angepasst werden.
	Es muss manuel gespeichert werden!"  	;Beschreibung
	"BB20101997"  							;Author
	"GNU GPL 3" 							;License
	"01.08.2014" 							; erstell datum
	"All by GIMP supported -> GIF" 							; datei typen

	SF-VALUE 	"Width" 	"100"
	SF-VALUE 	"Height" 	"150"
	SF-STRING   "Pattern"	"1111111112332111111123231"
	SF-DIRNAME  "Ordner"	""

 )
 
(script-fu-menu-register "script-fu-zwinker-gif" "<Image>/File/Create/Text")