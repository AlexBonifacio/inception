1. Le répertoire de données est-il déjà initialisé ?
   (test : est-ce que /var/lib/mysql/mysql existe ? — c'est la base système)
   if [ ! -d /var/lib/mysql/mysql ]; then...

2. S'il ne l'est PAS (premier démarrage) :
   a. mariadb-install-db          -> crée les tables système dans /var/lib/mysql
   b. créer ta base WordPress, ton utilisateur applicatif,
      définir les mots de passe root (lus depuis /run/secrets/)

3. Dans tous les cas, à la fin :
   exec mariadbd                  -> le serveur devient PID 1

DELETE FROM mysql.global_priv WHERE User=''; -> supprime les utilisateurs anonymes

Détail ligne par ligne
bash
#!/bin/bash

Interpréteur bash pour exécuter le script.

bash
mkdir -p /run/mysqld

Crée le répertoire où MariaDB place son socket Unix (mysqld.sock) et son fichier PID. -p évite une erreur si le dossier existe déjà.

bash
chown mysql:mysql /run/mysqld

Donne la propriété du dossier à l'utilisateur système mysql, car le serveur va tourner sous cet utilisateur (jamais en root) et doit pouvoir écrire dedans.

bash
DB_PASS=$(cat /run/secrets/db_password)
DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

Lit les mots de passe depuis des Docker secrets (fichiers montés en mémoire, non persistés dans l'image ni visibles dans docker inspect). C'est plus sûr que de les passer en variables d'environnement.

bash
if [ ! -d /var/lib/mysql/mysql ]; then

Vérifie si le sous-dossier mysql (la base système) existe déjà dans le datadir. S'il n'existe pas → c'est un tout premier démarrage → on initialise. S'il existe → la base est déjà initialisée, on saute tout ce bloc (comportement idempotent, essentiel pour ne pas réinitialiser à chaque redémarrage du conteneur).

bash
	echo "Init database..."

Simple message de log.

bash
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

Crée la structure physique des fichiers de la base mysql (tables système : user, db, global_priv, etc.) dans le datadir, avec les bons droits pour l'utilisateur mysql.

bash
	mariadbd --user=mysql --bootstrap << EOF

Lance le serveur MariaDB en mode bootstrap : il ne se met pas en écoute réseau, ne fork pas en démon, il lit des commandes SQL directement depuis stdin (ici via un heredoc << EOF), les exécute, puis s'arrête. C'est un mode spécial réservé à l'initialisation, sans authentification (car aucun utilisateur n'existe encore).

sql
USE mysql;

Positionne le contexte sur la base système mysql, pour que les requêtes suivantes n'aient pas besoin d'être préfixées.

sql
FLUSH PRIVILEGES;

Cette ligne ne sert quasiment à rien ici. En mode bootstrap il n'y a qu'une seule connexion, aucun cache de privilèges "périmé" à recharger puisque rien n'a encore été modifié. C'est une ligne cargo-culte copiée d'un ancien script — inoffensive mais inutile à cet endroit précis.

sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

Crée la base applicative dont le nom vient de la variable d'environnement MYSQL_DATABASE. IF NOT EXISTS évite une erreur si elle existe déjà.

sql
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASS';

Crée un utilisateur applicatif (nom venant de $MYSQL_USER) pouvant se connecter depuis n'importe quel hôte (@'%'), avec le mot de passe lu depuis le secret.

sql
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

Donne à cet utilisateur tous les droits, mais uniquement sur la base applicative créée plus haut (pas d'accès aux autres bases, ni à mysql).

sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';

Change le mot de passe du compte root local (par défaut sans mot de passe après mariadb-install-db), en utilisant le secret root.

sql
DELETE FROM mysql.global_priv WHERE User='';

Supprime les comptes anonymes (utilisateur avec un nom vide, créés par défaut par mariadb-install-db, autorisant des connexions sans authentification). global_priv est la table MariaDB moderne qui remplace l'ancienne mysql.user (stockage JSON des privilèges). Étape de durcissement sécurité classique.

sql
DROP DATABASE IF EXISTS test;

Supprime la base test, créée par défaut par mariadb-install-db, accessible sans restriction — autre étape de durcissement standard.

sql
FLUSH PRIVILEGES;

Là non plus, pas vraiment utile en mode bootstrap (le processus va s'arrêter juste après), mais c'est un réflexe habituel en fin de script d'admin.

EOF
fi

Fin du heredoc, puis fin du bloc conditionnel.