apt-get update

sudo apt-get install git curl build-essential \
                     libssl-dev libreadline-dev zlib1g-dev \
                     libpq-dev libffi-dev libmagickwand-dev \
                     imagemagick python3 redis
                     
                     #postgresql postgresql-contrib 
apt install rbenv -y

mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build 

cd "$(rbenv root)"/plugins/ruby-build && git pull

rbenv install 3.2.2
gem install bundler

## Install  nvm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.1/install.sh | bash

source ~/.bashrc

nvm install 14
nvm alias default 14


WORKDIR /app
# cd ~/app # or wherever you like to keep your code
git clone https://www.github.com/nobleman97/loomio.git && cd loomio                   

sed -i "s/ruby '3.2.2'/ruby '3.0.2'/" Gemfile
apt install ruby-dev -y

bundle install
cd vue; npm install && cd ..

cp config/database.example.yml config/database.yml

## On Linux you'll need to create a postgres user with the same name as your Linux user account. This is not required on MacOS as it's automatic.

sudo postgres -c 'createuser -P --superuser <username>' #root

apt-get install libvips -y


createdb loomio_development
rake db:setup

# In one terminal run

rails s

# In the another run

cd vue
npm run serve


# You can view Loomio in your browser by visiting http://localhost:8080.

# To view Loomio's features and changes to your source code, visit any of the dev routes listed at http://localhost:8080/dev/ (be sure to include the trailing slash). A good place to is http://localhost:8080/dev/setup_group.

##

# Rails stuff

#    sometimes rails s and similar commands will fail. Try with bundle exec rails s and that can help.
#    rails c will bring up a rails console
#   'rspec' will run the rails tests














