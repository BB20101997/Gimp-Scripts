(define (script-fu-zwinker-gif width height pattern dir files)
	(let*
	(
		(img (car (gimp-image-new width height RGB))) ;create image
		
		(open 1) ;?
		
		(pfad (string-append dir "\\")) ;modify the path of the files to work
		
		(folge (script-fu-string-to-intlist pattern)) ;get the string Pattern as a list of integers
		
		(layerlist (script-fu-get-layerlist-by-string pfad files img)) ;load the layers in file order

	)
	(script-fu-add-layers-in-order layerlist img folge) ;order the layers given the pattern and add them to the image
	
	(gimp-display-new img) ;display the file
	(gimp-displays-flush) ;fulsh i guess for undo?
	)
)
(define (script-fu-string-split expr str)
	(define (iter strg liste)
		(let*
			
			(
				(i (string-search expr strg))
			)
			
			(if (boolean? i)
			
				
				(let*
					()
					(set! liste (append liste (list strg)))
					liste
				)
			
				(let*
					()
					(set! liste (append liste (list (substring strg 0 i))))
					(iter (substring strg (+ i 1) (string-length strg)) liste)
				)
			)
		)
	)
	(iter str '())	
)
(define (string-search expr str)
	(let*
		(
			(expl (string-length expr))
		)
		(define (iter i)
						(if (<= (+ i expl) (string-length str))
							(let*
								()
								(if 
									(string=? expr (substring str i (+ i expl)))
									i
									(iter (+ i 1))
								)
							)
							#f
						)
		)
		(iter 0)
	)
)

(define (script-fu-get-layerlist-by-string dir str img)
	
	(let*
		
		(
			(filenames (script-fu-string-split ":" str))
			(layers)
		)
		(define (iter l)
			(if (< 0 (length l))
				
				(let*
					(
						(f (car l))
						(layer 
							(car
								(gimp-layer-new-from-visible (car (gimp-file-load 1 (string-append dir f) f)) img f)
							)
						)
					)
					(display (car l))
					(newline)
					(set! layers (append layers (list layer)))
					(iter (cdr l))
				)
				
				(let*
					()
					layers
				)	
			)	
		)
		
		(iter filenames)
	
	)
)

(define (script-fu-add-layers-in-order layerlist img form)

	(if (< 0 (length form))
			(if (and (<= (car form) (length layerlist)) (< 0 (car form)))
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
				
					(gimp-image-insert-layer img layer 0 -1)		
				
					(script-fu-add-layers-in-order layerlist img (cdr form))
				)
			
				(script-fu-add-layers-in-order layerlist img (cdr form))
			
			)
		0
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
	"Images to Layers"						;name im menu
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
	SF-STRING   "Pattern"	"11111111123321111111232321"
	SF-DIRNAME  "Ordner"	""
	SF-STRING	"Filenames"	"1.png:2.png:3.png"

 )
(script-fu-menu-register "script-fu-zwinker-gif" "<Image>/File/Create/Animation")
