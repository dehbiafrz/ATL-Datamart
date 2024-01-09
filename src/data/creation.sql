CREATE TABLE Fournisseur (fournisseurID BIGINT PRIMARY KEY, nom_fournisseur VARCHAR(50));
CREATE TABLE Zone_Service (zone_serviceID BIGINT PRIMARY KEY, nom_zone_service VARCHAR(50));
CREATE TABLE Zone (zoneID BIGINT PRIMARY KEY, nom_zone VARCHAR(50), zone_serviceID BIGINT, FOREIGN KEY (zone_serviceID) REFERENCES Zone_Service(zone_serviceID));
CREATE TABLE Localisation (localisationID BIGINT PRIMARY KEY, nom_quartier VARCHAR(50), zoneID BIGINT, FOREIGN KEY (zoneID) REFERENCES Zone(zoneID));
CREATE TABLE Code_Tarifaire (code_tarifaireID BIGINT PRIMARY KEY, nom_code_tarifaire VARCHAR(50));
CREATE TABLE Type_Paiement (type_paiementID BIGINT PRIMARY KEY, nom_type_paiement VARCHAR(50));

INSERT INTO Fournisseur (fournisseurID, nom_fournisseur) VALUES (1, 'Creative Mobile Technologies, LLC'), (2, 'VeriFone Inc'),(6, 'Fournisseur Mystere');
INSERT INTO Code_Tarifaire(code_tarifaireID, nom_code_tarifaire) VALUES (1, 'Tarif standard'), (2, 'JFK'),(3, 'Newark'), (4, 'Nassau or Westchester'), (5, 'Tarif négocié'), (6, 'Trajet en groupe'), (99, 'Code mystere');
INSERT INTO Type_Paiement (type_paiementID, nom_type_paiement) VALUES (0,'Type NULL'), (1,'Carte de crédit'), (2, 'Espèces'), (3, 'Aucun'), (4, 'Litige'), (5, 'Inconnu'), (6, 'Trajet annulé');


COPY Zone_Service FROM '/home/service_zone.csv' WITH CSV HEADER DELIMITER ','
COPY Zone FROM '/home/zone.csv' WITH CSV HEADER DELIMITER ',';
COPY Localisation FROM '/home/location.csv' WITH CSV HEADER DELIMITER ',';


ALTER TABLE nyc_row ADD CONSTRAINT fk_fournisseur FOREIGN KEY (fournisseurID) REFERENCES Fournisseur(fournisseurID);
ALTER TABLE nyc_row ADD CONSTRAINT fk_code_tarifaire FOREIGN KEY (code_tarifaireID) REFERENCES Code_Tarifaire(code_tarifaireID);
ALTER TABLE nyc_row ADD CONSTRAINT fk_type_paiement FOREIGN KEY (type_paiementID) REFERENCES Type_Paiement(type_paiementID);
ALTER TABLE nyc_row ADD CONSTRAINT fk_localisation_depart FOREIGN KEY (localisation_departID) REFERENCES Localisation(localisationID);
ALTER TABLE nyc_row ADD CONSTRAINT fk_localisation_arrivee FOREIGN KEY (localisation_arriveeID) REFERENCES Localisation(localisationID);
