# download repo from git
sudo apt install git
sudo cd /
sudo git clone https://github.com/kezzyhko/django-redis-chat.git
sudo cd /django-redis-chat



# prepare env for web app
sudo pip install -r requirements.txt

# configure ip addresses
echo "${database_addr} redis" > /etc/hosts
echo "${database_addr} postgres" > /etc/hosts
	
# prepare django
sudo python3 manage.py collectstatic --no-input
sudo python3 manage.py makemigrations
sudo python3 manage.py migrate --run-syncdb



# run app
sudo python3 -u manage.py runserver 0.0.0.0:8000 --noreload