# eco_collecting
FIVEM ESX Zöldségek, gyümölcsök, egyéb tárgyak szedését, betakarítását teszi lehetővé. 

:pencil2: Tutya Discord elérhetősége (fejlesztő): HipnotikusAvasSzalonna#3252

ECO COLLECTING

Zöldségek, gyümölcsök, egyéb tárgyak (hulladék, műanyag stb.) szedését, betakarítását teszi lehetővé. A gazdaság és a craft rendszer mozgató rugója a mi szerverünkön.
Jelenleg 22 féle alapanyagot tartalmaz, így biztosítja például a

-	meth labor és pálinkafőző javításához a fém hulladékot, amit találni lehet a roncstelepen
-	cefréhez különféle gyümölcsöket
-	éttermek számára a friss zöldséget, gyümölcsöt
-	borászatnak a szőlőt
-	drog, gyógyító kivonat, gyógyszer alapanyagok a frakcióknak
-	műanyagot, és további craft alapanyagokat


Egyszerű bővíthetőség. Csak adj a config fájlhoz tetszőleges számú koordinátát a termék azonosítójával és restart után szedhető.
Nagyon keveset fogyaszt annak ellenére, hogy alaphelyzetben is több, mint 2200 szedhető helyet kezel. A szigeten lévő lehetőségek ki vannak kommentelve, mert az nem minden szerveren üzemel.

Termékekhez rendelhető, hogy kinek a tulajdona, milyen géppel lehet aratni, mennyi idő múlva legyen újra szedhető és egyéb megjelenítési tulajdonságok.

Testreszabhatóság:

-	frakciók tulajdonában is lehetnek áruk. A felsorolt frakciókon kívül más nem látja, nem szedheti.
-	Beállítható egy speciális ’farmer’ frakció, ami 3 * gyorsabban szed kézzel és azonnal betakaríthat a termékhez beállított járművekkel
-	betakarítás járművel csak 15 km/h alatt történik
-	Minden terméknek egyedi újra szedési idő állítható. Pl.: a krumpli betakarítás után 2 óra múlva szedhető megint.

Függőségek:

-	Mythic Notifications ( olyan verzió, amiben van SendAlert export )
-	Mythic Progbar

Fejlesztői szkriptek, segédletek a  bővítéshez, új pontok felvételéhez:

-	eco_coords ( a collecting formátumában képes felvenni új pontokat egy gombnyomásra, így könnyen bővíthetőek a termékek )
-	eco_sowing ( komplett szántóföldeket lehet bevetni egy gombnyomásra rendezett hálóban )
-	eco_anim ( újabb betakarítási animok kereséséhez )


![ecocollecting](https://github.com/Ekhion76/eco_collecting/blob/main/eco_collecting/preview_images/eco_collecting.jpg)
![ecocollecting_2](https://github.com/Ekhion76/eco_collecting/blob/main/eco_collecting/preview_images/eco_collecting_2.jpg)
![ecocollecting_3](https://github.com/Ekhion76/eco_collecting/blob/main/eco_collecting/preview_images/eco_collecting_3.jpg)
