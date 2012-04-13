-- ##################################################
--
--	Baza danych dla portalu spo�eczno�ciowego o ksi��kach
-- 	2010 Copyright (c) Artur Trzop 12K2
--	Script-insert v. 3.0.0
--
-- ##################################################

PROMPT ;
PROMPT ----------------------------------------------;
PROMPT Kasujemy sekwencje i ustawiamy na nowo aby liczniki sie zresetowaly;
PROMPT ----------------------------------------------;
PROMPT ;

DROP SEQUENCE SEQ_MIASTO;
CREATE SEQUENCE SEQ_MIASTO INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_UZYTKOWNICY;
CREATE SEQUENCE SEQ_UZYTKOWNICY INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_SESJE_UZYTKOWNIKOW;
CREATE SEQUENCE SEQ_SESJE_UZYTKOWNIKOW INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_KATEGORIE_KSIAZEK;
CREATE SEQUENCE SEQ_KATEGORIE_KSIAZEK INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_AUTORZY;
CREATE SEQUENCE SEQ_AUTORZY INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_KSIAZKI;
CREATE SEQUENCE SEQ_KSIAZKI INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_CYTATY_Z_KSIAZEK;
CREATE SEQUENCE SEQ_CYTATY_Z_KSIAZEK INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_RECENZJE_KSIAZEK;
CREATE SEQUENCE SEQ_RECENZJE_KSIAZEK INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_KOMENTARZE_DO_RECENZJI;
CREATE SEQUENCE SEQ_KOMENTARZE_DO_RECENZJI INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_OPINIE_DO_KSIAZEK;
CREATE SEQUENCE SEQ_OPINIE_DO_KSIAZEK INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_WYDAWNICTWO;
CREATE SEQUENCE SEQ_WYDAWNICTWO INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 

DROP SEQUENCE SEQ_WERSJA_WYDANIA;
CREATE SEQUENCE SEQ_WERSJA_WYDANIA INCREMENT BY 1 START WITH 1
MAXVALUE 9999999999 MINVALUE 1; 


CLEAR SCREEN;
PROMPT ----------------------------------------------;
PROMPT Kasowanie danych z tabel (kolejnosc kasowania ma znaczenie!);
PROMPT ----------------------------------------------;
PROMPT ;

DELETE FROM KOMENTARZE_DO_RECENZJI;
DELETE FROM WERSJE_WYDANIA_KSIAZEK;
DELETE FROM AUK_AUTORZY_KSIAZKI;
DELETE FROM ULUBIONE_KSIAZKI;
DELETE FROM OPINIE_DO_KSIAZEK;
DELETE FROM CYTATY_Z_KSIAZEK;
DELETE FROM OCENY_KSIAZEK;
DELETE FROM RECENZJE_KSIAZEK;
DELETE FROM WERSJA_WYDANIA;
DELETE FROM ULA_ULUBIENI_AUTORZY;
DELETE FROM KSIAZKI;
DELETE FROM WYDAWNICTWO;
DELETE FROM KATEGORIE_KSIAZEK;
DELETE FROM AUTORZY;
DELETE FROM SESJE_UZYTKOWNIKOW;
DELETE FROM UZYTKOWNICY;
DELETE FROM MIASTO;




-- wyk.3, str.46 ustawianie domyslnego sposobu wyswietlania daty
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy/mm/dd hh24:mi:ss';

-- ##################################################
PROMPT ----------------------------------------------;
PROMPT Wstawianie danych do tabel;
PROMPT ----------------------------------------------;
PROMPT ;

-- ### Tworzenie miast
INSERT INTO MIASTO (MIA_MIASTO, MIA_WSPOLRZEDNE)
VALUES ('Krak�w', '52.025459,19.204102');
INSERT INTO MIASTO (MIA_MIASTO, MIA_WSPOLRZEDNE)
VALUES ('Warszawa', '50.070362,19.944992');




-- ### Tworzenie uzytkownikow
INSERT INTO UZYTKOWNICY (UZY_LOGIN, UZY_HASLO_HASH, UZY_STATUS, UZY_CZY_ADMIN, UZY_IMIE, UZY_PLEC, UZY_DATA_URODZENIA, UZY_EMAIL, MIA_ID)
VALUES ('Artur', 'd0be2dc421be4fcd0172e5afceea3970e2f3d940', 1, 1, 'Artur', 'm', to_date('1990/05/09', 'yyyy/mm/dd'), 'artur2006@o2.pl', 1);
INSERT INTO UZYTKOWNICY (UZY_LOGIN, UZY_HASLO_HASH, UZY_STATUS, UZY_CZY_ADMIN, UZY_IMIE, UZY_PLEC, UZY_DATA_URODZENIA, UZY_EMAIL, MIA_ID)
VALUES ('Micha87', 'dc421be4fcd0d0be2172e5afceead9403970e2f3', 1, 0, 'Micha�', 'm', to_date('1987/02/22', 'yyyy/mm/dd'), 'mich87@poczta.pl', 2);




-- ### Tworzenie przykladowych sesji zalogowanych uzytkownikow
-- Nie musimy podawa� daty kiedy zalogowano oraz do kiedy sesja jest wa�na poniewa� ustawiaj� to triggery
INSERT INTO SESJE_UZYTKOWNIKOW (UZY_ID, SES_KLUCZ, SES_IP)
VALUES (1, 'e5afceea3970e2f3d940d0be2dc421be4fcd0172', '127.0.0.1');

-- Spos�b aktualizacji sesji uzytkownika. Wystarczy ustawic SES_WAZNOSC na NULL a trigger sam ustawi dat� powi�kszon� o 7 dni od obecnej chwili
UPDATE SESJE_UZYTKOWNIKOW SET SES_WAZNOSC=NULL WHERE UZY_ID = 1;



-- ### Tworzenie kategorii ksiazek
-- kategorie g��wne (id od 1 do 6). Nie podajemy wartosci KAT_RODZIC_KATEGORII poniewaz g��wne kategorie maj� domy�lnie NULL
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Literatura');
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Edukacja');
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Informatyka');
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Biznes');
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Zdrowie');
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA)
VALUES ('Podr�czniki');
-- podkategorie dla literatury (id od 7 do 9)
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Powie��', 1);
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Historyczne', 1);
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Popularnonaukowe', 1);
-- podkategorie dla informatyki (id od 10 do 12)
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Bazy danych', 3);
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Programowanie', 3);
INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
VALUES ('Hacking', 3);
	INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
	VALUES ('Programowanie obiektowe', 11);
	INSERT INTO KATEGORIE_KSIAZEK (KAT_NAZWA, KAT_RODZIC_KATEGORII)
	VALUES ('Programowanie proceduralne', 11);



-- ### Tworzymy autor�w
INSERT INTO AUTORZY (UZY_ID, AUT_IMIE, AUT_NAZWISKO, AUT_PSEUDONIM, AUT_ROK_URODZENIA, AUT_ROK_SMIERCI, AUT_BIOGRAFIA)
VALUES (1, 'Adam', 'Mickiewicz', NULL, to_date('1798/12/24', 'yyyy/mm/dd'), to_date('1855/11/26', 'yyyy/mm/dd'), 'Polski poeta, dzia�acz i publicysta polityczny.');
INSERT INTO AUTORZY (UZY_ID, AUT_IMIE, AUT_NAZWISKO, AUT_PSEUDONIM, AUT_ROK_URODZENIA, AUT_ROK_SMIERCI, AUT_BIOGRAFIA)
VALUES (1, 'Jan', 'Poeta', NULL, to_date('1898/02/12', 'yyyy/mm/dd'), to_date('1951/10/01', 'yyyy/mm/dd'), 'Polski poeta, zwany Janem.');
INSERT INTO AUTORZY (UZY_ID, AUT_IMIE, AUT_NAZWISKO, AUT_PSEUDONIM, AUT_ROK_URODZENIA, AUT_ROK_SMIERCI, AUT_BIOGRAFIA)
VALUES (2, 'Marek', 'Nowak', NULL, to_date('1968/07/30', 'yyyy/mm/dd'), NULL, 'Wsp�czesny pisarz i zarazem pasjonat �eglarstwa.');
INSERT INTO AUTORZY (UZY_ID, AUT_IMIE, AUT_NAZWISKO, AUT_PSEUDONIM, AUT_ROK_URODZENIA, AUT_ROK_SMIERCI, AUT_BIOGRAFIA)
VALUES (1, 'John', 'Gates', NULL, to_date('1959/06/20', 'yyyy/mm/dd'), NULL, 'Informatyk i autor wielu ksi��ek dla in�ynier�w.');



-- ### Tworzenie ksiazek
-- ID oraz data dodania ksiazki zostanie dodana automatycznie przez trigger
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (1, 7, 'Pan Tadeusz');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (1, 7, 'Dziady');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (1, 7, 'Konrad Wallenrod');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (2, 7, 'Powie�� prawdziwa');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (2, 9, 'Wielka wyprawa w kosmos');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (1, 11, 'Programowanie w C++');
INSERT INTO KSIAZKI (UZY_ID, KAT_ID, KSI_TYTUL)
VALUES (2, 8, 'Super ksi��ka 2');


-- ### Przypisujemy autor�w do ksiazek
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (1, 1);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (1, 2);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (1, 3);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (2, 4);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (3, 5);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (4, 6);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (3, 7);
-- 
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (3, 1);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (4, 1);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (2, 6);
INSERT INTO AUK_AUTORZY_KSIAZKI (AUT_ID, KSI_ID)
VALUES (1, 5);


-- ### Tworzymy przykladowe wydawnictwa
INSERT INTO WYDAWNICTWO (WYD_NAZWA_WYDAWNICTWA, MIA_ID, WYD_ULICA, WYD_TELEFON, WYD_EMAIL)
VALUES ('PWN', 2, 'Kolorowa 12', '123-456-789', 'pwn@pwn.pl');
INSERT INTO WYDAWNICTWO (WYD_NAZWA_WYDAWNICTWA, MIA_ID, WYD_ULICA, WYD_TELEFON, WYD_EMAIL)
VALUES ('KrakMedia', 1, 'Krakowska 102', '345-765-311', 'biuro@krakmedia.pl');



-- ### Tworzymy opisy dodane do ksiazek
INSERT INTO WERSJA_WYDANIA (WYD_ID, WER_OPIS, WER_ROK_WYDANIA, WER_ISBN, WER_OKLADKA)
VALUES (1, 'Ksi��ka, kt�r� zna ka�dy Polak.', to_date('2008', 'yyyy'), '9788374356596', NULL);



-- ### Wi��emy opis ksi��ki z u�ytkownikiem kt�ry doda� go oraz z ksi��k� do kt�rej b�dzie przypisany
INSERT INTO WERSJE_WYDANIA_KSIAZEK (KSI_ID, WER_ID, UZY_ID)
VALUES (1, 1, 2);



-- ### Oceny przydzielone ksi��kom
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (1, 3, 4.0);
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (1, 1, 4.5);
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (1, 7, 2.5);
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (2, 1, 5.0);
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (2, 2, 4.0);
INSERT INTO OCENY_KSIAZEK (UZY_ID, KSI_ID, OCE_OCENA) VALUES (2, 4, 1.5);


-- ### Ulubione ksiazki uzytkownikow
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (1, 2);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (1, 6);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (1, 1);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (1, 5);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (2, 2);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (2, 4);
INSERT INTO ULUBIONE_KSIAZKI (UZY_ID, KSI_ID) VALUES (2, 5);



-- Zatwierdzamy operacje
COMMIT;