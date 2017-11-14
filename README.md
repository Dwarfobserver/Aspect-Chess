
# Aspect-Chess

Etudiants :

 - CONGARD Sidney
 - LUCE Mathilde  

TP portant sur AspectJ. Le but est de corriger un jeu d'échec en Java sans toucher au code source,
et de journaliser les actions effectuées en jeu.

Vérifications lors d'un mouvement :

 - Les positions sont comprises dans le plateau
 - Les positions sont différentes
 - La 1e position contient un pion du joueur
 - La 2e position ne contient pas un pion du joueur
 - Le déplacement est valide, selon le cas où un ennemi est ciblé ou non (utile pour les pions)
 - La cible n'est pas bloquée, pour toutes les pièces sauf le chevalier

Autres corrections :
 
 - Les pions arrivant à l'autre bout du plateau peuvent être promus (une pièce est créée à l'aide
   de la réflexivité)
 - Les mouvements et promotions sont journalisées dans un nouveau fichier nommé "move-logs.txt"
 - Le fou (Bishop) avait l'apparence d'un pion, et affiche maintenant un 'b/B'
 - Le joueur humain se disait noir, maintenant blanc (joue en premier, avec les pièces minuscules)
 - Le move est affiché avec des chiffres de 0 à 7, maintenant de 1 à 8

Ce qui complèterait le programme :

 - Les conditions de victoire / défaite, le code AspectJ ne touche pas à la boucle de jeu
