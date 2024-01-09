import os
import sys
from minio import Minio
from minio.error import ResponseError
import pandas as pd
from sqlalchemy import create_engine

def telecharger_de_minio(minio_client, nom_bucket, nom_objet, chemin_local):
    try:
        minio_client.fget_object(nom_bucket, nom_objet, chemin_local)
        print(f"Téléchargement de {nom_objet} depuis Minio vers {chemin_local}")
    except ResponseError as err:
        print(f"Erreur lors du téléchargement de {nom_objet} depuis Minio : {err}")
        sys.exit(1)

def ecrire_donnees_postgres(dataframe: pd.DataFrame, engine, nom_table):
    try:
        with engine.connect() as connection:
            print("Connexion à PostgreSQL réussie ! Écriture des données dans la base de données.")
            dataframe.to_sql(nom_table, connection, index=False, if_exists='append')
            print("Données écrites dans PostgreSQL avec succès.")
    except Exception as e:
        print(f"Erreur lors de l'écriture des données dans PostgreSQL : {e}")
        sys.exit(1)

def nettoyer_noms_colonnes(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe.columns = map(str.lower, dataframe.columns)
    return dataframe

def principal():
    endpoint_minio = 'localhost:9000'
    cle_acces_minio = 'minio'
    cle_secrete_minio = 'minio123'
    nom_bucket = 'nyc-taxi'
    chemin_local = 'yellow_tripdata_2023-02.parquet'

    # Initialiser le client Minio
    minio_client = Minio(endpoint_minio,
                         access_key=cle_acces_minio,
                         secret_key=cle_secrete_minio,
                         secure=False)

    # Télécharger le fichier depuis Minio
    telecharger_de_minio(minio_client, nom_bucket, 'yellow_tripdata_2023-02.parquet', chemin_local)

    # Initialiser le moteur PostgreSQL
    config_bdd = {
        "moteur_bdd": "postgresql",
        "nom_utilisateur_bdd": "postgres",
        "mot_de_passe_bdd": "admin",
        "ip_bdd": "localhost",
        "port_bdd": "5432",
        "nom_base_de_donnees": "nyc_warehouse",
        "nom_table_bdd": "nyc_raw"
    }

    url_bdd = (
        f"{config_bdd['moteur_bdd']}://{config_bdd['nom_utilisateur_bdd']}:{config_bdd['mot_de_passe_bdd']}@"
        f"{config_bdd['ip_bdd']}:{config_bdd['port_bdd']}/{config_bdd['nom_base_de_donnees']}"
    )
    moteur = create_engine(url_bdd)

    # Lire le fichier parquet dans un DataFrame
    dataframe_parquet = pd.read_parquet(chemin_local, engine='pyarrow')
    nettoyer_noms_colonnes(dataframe_parquet)

    # Écrire les données dans PostgreSQL
    ecrire_donnees_postgres(dataframe_parquet, moteur, config_bdd['nom_table_bdd'])

    print("Importation des données réussie !")

if __name__ == '__main__':
    principal()
