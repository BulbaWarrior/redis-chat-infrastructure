# # redis
# sudo apt install redis-server -y
# sudo redis-server --append-only yes

# # postgres
# sudo apt install postgresql -y



sudo curl -sLS get.docker.com | sh

sudo docker run redis -p 6379:6379 --name redis
sudo docker exec redis redis-server -appendonly yes

sudo docker run postgres -p 5432:5432 --env POSTGRES_DB=postgres --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=postgres