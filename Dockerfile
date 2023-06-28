FROM ubuntu

RUN apt-get update && apt-get upgrade -y

RUN apt-get install curl git nodejs npm build-essential \
                     libssl-dev libreadline-dev zlib1g-dev \
		     libpq-dev libffi-dev libmagickwand-dev \
                     imagemagick python3 redis -y
                     
RUN apt install rbenv -y
RUN mkdir -p "$(rbenv root)"/plugins && \
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build 

RUN cd "$(rbenv root)"/plugins/ruby-build && git pull && apt-get update
# RUN rbenv install 3.2.2 && gem install bundler

RUN apt install ruby-dev -y && gem install bundler

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.1/install.sh | bash

#RUN source ~/.bashrc
# RUN echo "source ~/.bashrc" >> ~/.bash_profile

# RUN nvm install 14 && nvm alias default 14

WORKDIR /app

# RUN git clone https://www.github.com/nobleman97/loomio.git && cd loomio

COPY ./loomio /app

RUN sed -i "s/ruby '3.2.2'/ruby '3.0.2'/" Gemfile # && apt install ruby-dev -y

RUN bundle install
RUN cd vue; npm install && cd ..

COPY ./database.yml ./config/database.yml

RUN apt-get install libvips  libvips-dev -y

# RUN bundle exec rake db:prepare

# RUN rake db:setup

WORKDIR /app/vue

RUN npm install

WORKDIR /app

EXPOSE 3000

# Start the Rails server and Vue development server
#CMD bundle exec rake db:prepare & &&  rake db:setup & && rails s & && cd vue && npm run serve

CMD bundle exec rake db:prepare & \
    rake db:setup & \
    rails s & \
    cd vue && npm run serve
