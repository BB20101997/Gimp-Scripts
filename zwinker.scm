
(define (script-fu-add-layers-in-order l1 l2 l3 img form)

	(if (< 0 (length form))
			
			(let* 
			(
				(head (car form))
			)
			
				(cond
						((= head 1) 
					
							(let* 
								(
									(layer (car 
												(gimp-layer-copy l1 FALSE)
											) 
									)
								)
								(gimp-item-set-name layer "Bild 1")
								(gimp-image-add-layer img layer -1)			
							)
						)	
			
						((= head 2)
							(let* 
								(
									(layer 
										(car 
												(gimp-layer-copy l2 FALSE)
										) 
									)
								)
								(gimp-item-set-name layer "Bild 2")
								(gimp-image-add-layer img layer -1)			
							)
						)
			
						((= head 3)
							(let* 
								(
									(layer (car 
												(gimp-layer-copy l3 FALSE)
											) 
									)
								)
								(gimp-item-set-name layer "Bild 3")
								(gimp-image-add-layer img layer -1)			
							)
						)
					)	
				
				(script-fu-add-layers-in-order l1 l2 l3 img (cdr form))
			)
		
		0
	)
)

(define (script-fu-zwinker-gif width height)
	(let*
	(
		;define local variables
		;create new image;
		(img (car (gimp-image-new width height RGB)))
		
		(open 1)
		;Benutzer
		(user "Modding")
		;Desktop Pfad warscheinlich Laufwerk C
		(drive "D")
		(pfad (string-append drive ":\\Users\\" user "\\Desktop\\"))
		;(pfad (string-append %HOMEPATH% "\\Desktop\\"))
		
		(img1 (car
					(file-png-load 
					open
					(string-append pfad "1.png")
					"1"					
					)
				)
		)
		(img2 (car
					(file-png-load 
					open
					(string-append pfad "2.png")
					"2"					
					)
				)
		)
		(img3 (car
					(file-png-load 
					open
					(string-append pfad "3.png")
					"3"					
					)
				)
		)
		
		(layer1 
					(car
						(gimp-layer-new-from-drawable 
													(car 
														(gimp-image-get-active-drawable img1)
													)
						img)
					)
		)
		
		(layer2 	(car
						(gimp-layer-new-from-drawable 
													(car 
														(gimp-image-get-active-drawable img2)
													)
						img)
					)
		)
		
		(layer3 	(car
						(gimp-layer-new-from-drawable 
													(car 
														(gimp-image-get-active-drawable img3)
													)
						img)
					)
		)
		
		;Standard Reihenfolge
		;1111111112332111111123231
		(folge '(1 1 1 1 1 1 1 1 1 2 3 3 2 1 1 1 1 1 1 1 2 3 2 3 1))

	)
	
	(script-fu-add-layers-in-order layer1 layer2 layer3 img folge)
	
	(gimp-display-new img)
	(gimp-displays-flush)
	;(display pfad)
	;(newline)
	)
)

(script-fu-register 
	"script-fu-zwinker-gif" 				;zu regestrierende funktion
	"Zwinker Gif"							;name im menu
	"Fügt die Bilder \"1.png\",\"2.png\" und \"3.png\" zusammen nach dem Standartmuster : 
	1111111112332111111123231.
	Für ein anderes Muster muss die stelle im Script geändert werden.
	Es muss manuel gespeichert werden!"  	;Beschreibung
	"BB20101997"  							;Author
	"GNU GPL 3" 							;License
	"01.08.2014" 							; erstell datum
	"PNG -> GIF" 							; datei typen

	SF-VALUE 	"Width" 	"100"
	SF-VALUE 	"Height" 	"150"

 )
(script-fu-menu-register "script-fu-zwinker-gif" "<Image>/File/Create/Text")