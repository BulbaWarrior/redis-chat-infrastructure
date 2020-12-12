sudo apt update

# download repo from git
sudo apt install git -y
cd /
sudo git clone https://github.com/kezzyhko/django-redis-chat.git
cd /django-redis-chat

# install python
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo pip3 install -r requirements.txt

# configure ip addresses
echo "${database_addr} redis" | sudo tee -a /etc/hosts
echo "${database_addr} postgres" | sudo tee -a /etc/hosts
	
# start django
sudo python3 manage.py collectstatic --no-input
sudo python3 manage.py makemigrations
sudo python3 manage.py migrate --run-syncdb
sudo python3 -u manage.py runserver 0.0.0.0:8000 --noreload