Extraia o arquivo tarball
```bash
tar -zxvf mongodb-linux-x86_64-3.2.18.tgz
```

Crie uma pasta para armazenar os arquivos do mongoDB 
```bash
mkdir -p data/db
```

Para iniciar o serviço do `mongod`
```bash
sudo /home/bode/Codes/01-Dev/mongoDB/mongodb-linux-x86_64-debian92-4.0.6/bin/mongod --dbpath /home/bode/Codes/01-Dev/mongoDB/mongodb-linux-x86_64-debian92-4.0.6/data/db/
```

Para conectar-se ao servidor do mongo
```bash
/home/bode/Codes/01-Dev/mongoDB/mongodb-linux-x86_64-debian92-4.0.6/bin/mongo
```

Para mudar a sessão para um novo banco de dados 
```bash
use newdatabase
```

```
show dbs
show collections
db.help()
db.mycoll.help()
```
