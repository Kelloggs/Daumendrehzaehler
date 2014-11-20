Daumendrehzähler
================

Dieses Processing (http://processing.org) Programm zählt, wie oft man die Daumen gedreht hat (typischen "Däumchendrehen").

Hierfür scannt es jedes Frame der Webcam nach dem Vorkommen einer bestimmten Farbe - in der aktuellen Implementierung ist dies ein sattes Grün. Jedes mal, wenn das getrackte Pixel verschwindet, zählt es den Counter hoch.

Um die Umdrehungen der Daumen zu zählen wird ein grüner Klebepunkt auf einen der Daumennägel geklebt. Die Daumen werden dann vor der Kamera gedreht. Immer, wenn der beklebte Daumen hinter dem anderen verschwindet, registriert das Programm eine Umdrehung und gibt den aktuellen Counter in der Konsole aus.

Um mit alternativen Klebepunkten zu arbeiten muss man den jeweiligen threshold in der ``findDot`` Methode anpassen.
