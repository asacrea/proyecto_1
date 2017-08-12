# rubyArticulosEM
## By: Edwin Montoya - emontoya@eafit.edu.co

# DEVELOPMENT::

## 1. Creating the Article Application

        user1@dev$ rails new proyecto_1

## 2. Starting up the WebApp Server

        user1@dev$ rails s

* Open browser: http://localhost:3000

## 3. Main page: "Hello World"

        user1@dev$ rails generate controller Welcome index

        edit:
        app/views/welcome/index.html.erb
        config/routes.rb

## 4. Create REST routes        

* edit: config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.183/rubyArticulos
        Rails.application.routes.draw do
          scope '/' do
            get 'welcome/index'
            resources :articles
            root 'welcome#index'
          end
        end

* run:    
        user1@dev$ rails routes

* output:

      Prefix Verb   URI Pattern                    Controller#Action
          root GET    /                              static_pages#home
   session_new GET    /session/new(.:format)         session#new
          help GET    /help(.:format)                static_pages#help
         about GET    /about(.:format)               static_pages#about
       contact GET    /contact(.:format)             static_pages#contact
         login GET    /login(.:format)               session#new
               POST   /login(.:format)               session#create
        logout DELETE /logout(.:format)              session#destroy
following_user GET    /users/:id/following(.:format) users#following
followers_user GET    /users/:id/followers(.:format) users#followers
         users GET    /users(.:format)               users#index
               POST   /users(.:format)               users#create
      new_user GET    /users/new(.:format)           users#new
     edit_user GET    /users/:id/edit(.:format)      users#edit
          user GET    /users/:id(.:format)           users#show
               PATCH  /users/:id(.:format)           users#update
               PUT    /users/:id(.:format)           users#update
               DELETE /users/:id(.:format)           users#destroy
    microposts POST   /microposts(.:format)          microposts#create
     micropost DELETE /microposts/:id(.:format)      microposts#destroy
 relationships POST   /relationships(.:format)       relationships#create
  relationship DELETE /relationships/:id(.:format)   relationships#destroy

## 5. Generate controller for 'micropost' REST Services

        user1@dev$ rails generate controller Microposts

* modify: app/controllers/micropots_controller.rb
* create: app/views/micropost/new.html.erb    

* run: http://localhost:3000/microposts/new    

## 6. Create a FORM HTML to enter data for an micropost

* edit: app/views/microposts/new.html.erb:

    <%= form_for(@micropost) do |f| %>
		<%= render 'shared/error_messages', object: f.object %>
		<div class="field">
		<%= f.text_field :name, placeholder: "Name" %>
		<%= f.text_field :ext, placeholder: "Extension" %>
		<%= f.text_field :size, placeholder: "Size" %>
		</div>
		<%= f.submit "Post", class: "btn btn-primary" %>

		<span class="picture">
		<%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png' %>
		</span>
	<% end %>


* modify: app/views/micropost/new.html.erb:

      <%= form_for :micropost, url: articles_path do |f| %>

      POST method and require 'create' action.

* add 'create' action to ArticlesController:

        class ArticlesController < ApplicationController
          def new
          end

          def create
            @micropost = current_user.microposts.build(micropost_params)
          end
        end     

## 7. Creating the Micropost model

      user1@dev$ rails generate model Micropost name:string ext:string size:integer picture:string

* look db/migrate/YYYYMMDDHHMMSS_create_articles.rb:

      class CreateMicroposts < ActiveRecord::Migration[5.1]
        def change
		    create_table :microposts do |t|
		      t.text :name
		      t.string :ext
		      t.integer :size
		      t.integer :user_id

		      t.timestamps
		    end
		  end
      end

## 8. Running a Migration

run:

    user1@dev$ rails db:migrate

## include postgresql in test and production environment:

(Warning: install postgresql server on host)

* Modify Gemfile

      # Use Postgresql as the database for Active Record
      gem 'pg'

* Modify config/database.yml:
	  default: &default
		  adapter: mysql2
		  username: root
		  password: *******,
		  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
		  timeout: 5000

	  test:
		  <<: *default
		  database: mydatabase

      production:
		  adapter: mysql2
		  username: b7b0e8356a0f9d
		  password: a10df7f0
		  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
		  timeout: 5000
		  database: heroku_80ca0843bce279a
		  host: mysql://b7b0e8356a0f9d:a10df7f0@us-cdbr-iron-east-05.cleardb.net/heroku_80ca0843bce279a?reconnect=true


* Drop, Create and migrate new database:

          user1@dev$ rake db:drop db:create db:migrate

## 9. Saving data in the controller

* Open app/controllers/microposts_controller.rb

      def create
	    @micropost = current_user.microposts.build(micropost_params)
	    if @micropost.save
	      flash[:success] = "Micropost created!"
	      redirect_to root_url
	    else
	      @feed_items = []
	      render 'static_pages/home'
	    end
	  end

	  private

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def micropost_params
	      params.require(:micropost).permit(:name, :ext, :size, :picture)
	    end

* fix1:

      @@micropost = current_user.microposts.build(micropost_params)

* fix2:

      def create
	    @micropost = current_user.microposts.build(micropost_params)
	    if @micropost.save
	      flash[:success] = "Micropost created!"
	      redirect_to root_url
	    else
	      @feed_items = []
	      render 'static_pages/home'
	    end
	  end

	  private

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def micropost_params
	      params.require(:micropost).permit(:name, :ext, :size, :picture)
	    end

## 10. Showing Micropost

* Route:

      user GET    /users/:id(.:format)           users#show


* Controller: add action in app/controllers/users_controller.rb

      def show
        @user = User.find(params[:id])
    	@microposts = @user.microposts.paginate(page: params[:page])
      end

* View: create a new file app/views/users/show.html.erb

      <li id="micropost-<%= micropost.id %>">
		  <%= link_to gravatar_for(micropost.user), micropost.user %>
		  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
		  <span class="content">
		    <%= micropost.name %>
		    <%= image_tag micropost.picture.url if micropost.picture? %>
		  </span>
		  <span class="content"><%= micropost.ext %></span>
		  <span class="content"><%= micropost.size %></span>
		  <span class="timestamp">
		    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
		    <% if current_user?(micropost.user) %>
		      <%= link_to "delete", micropost, method: :delete,
		                                       data: { confirm: "You sure?" } %>
		    <% end %>
		  </span>
		</li>

# 11. Listing all articles

* Route:

      articles GET    /users(.:format)          users#show

* Controller: add action in app/controllers/articles_controller.rb

      def show
        @user = User.find(params[:id])
    	@microposts = @user.microposts.paginate(page: params[:page])
      end

* View: create a new file app/views/articles/index.html.erb

      <li id="micropost-<%= micropost.id %>">
		  <%= link_to gravatar_for(micropost.user), micropost.user %>
		  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
		  <span class="content">
		    <%= micropost.name %>
		    <%= image_tag micropost.picture.url if micropost.picture? %>
		  </span>
		  <span class="content"><%= micropost.ext %></span>
		  <span class="content"><%= micropost.size %></span>
		  <span class="timestamp">
		    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
		    <% if current_user?(micropost.user) %>
		      <%= link_to "delete", micropost, method: :delete,
		                                       data: { confirm: "You sure?" } %>
		    <% end %>
		  </span>
	  </li>

# 12. Adding links

* View: Open app/views/shared/_user_info.html.erb

      <span><%= link_to "view my profile", current_user %></span>

* View: app/views/articles/index.html.erb

      <%= link_to 'New article', new_article_path %>    

* View: app/views/articles/new.html.erb


      <%= form_for :article, url: articles_path do |f| %>
        ...
      <% end %>

      <%= link_to 'Back', articles_path %>

* View: app/views/articles/show.html.erb

      <p>
        <strong>Title:</strong>
        <%= @article.title %>
      </p>

      <p>
        <strong>Text:</strong>
        <%= @article.text %>
      </p>

      <%= link_to 'Back', articles_path %>   

# 13. Updating Articles     

* Route:     

      article GET    /articles/:id(.:format)      articles#show

* Controller: edit action to the ArticlesController ->  app/controllers/articles_controller.rb

      def edit
      @article = Article.find(params[:id])
      end

* View: new page: app/views/articles/edit.html.erb

      <h1>Edit article</h1>

      <%= form_for(@article) do |f| %>

        <% if @article.errors.any? %>
          <div id="error_explanation">
            <h2>
              <%= pluralize(@article.errors.count, "error") %> prohibited
              this article from being saved:
            </h2>
            <ul>
              <% @article.errors.full_messages.each do |msg| %>
                <li><%= msg %></li>
              <% end %>
            </ul>
          </div>
        <% end %>

        <p>
          <%= f.label :title %><br>
          <%= f.text_field :title %>
        </p>

        <p>
          <%= f.label :text %><br>
          <%= f.text_area :text %>
        </p>

        <p>
          <%= f.submit %>
        </p>

      <% end %>

      <%= link_to 'Back', articles_path %>  

* Controller: update action in app/controllers/articles_controller.rb

      def update
        @article = Article.find(params[:id])

        if @article.update(article_params)
          redirect_to @article
        else
          render 'edit'
        end
      end

* View: add link 'edit' in app/views/articles/index.html.erb

      <table>
        <tr>
          <th>Title</th>
          <th>Text</th>
          <th colspan="2"></th>
        </tr>

        <% @articles.each do |article| %>
          <tr>
            <td><%= article.title %></td>
            <td><%= article.text %></td>
            <td><%= link_to 'Show', article_path(article) %></td>
            <td><%= link_to 'Edit', edit_article_path(article) %></td>
          </tr>
        <% end %>
      </table>

* View: add link 'edit' in app/views/articles/show.html.erb:

      ...
      <%= link_to 'Edit', edit_article_path(@article) %> |
      <%= link_to 'Back', articles_path %>

# 14. delete an Article

Route:

      micropost DELETE /microposts/:id(.:format)      microposts#destroy

Controller: app/controllers/microposts_controller.rb

      def destroy
        @@micropost.destroy
	    flash[:success] = "Micropost deleted"
	    redirect_to request.referrer || root_url
      end                                      

View: add 'delete' link to app/views/articles/index.html.erb

      ...
      < <span class="timestamp">
		    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
		    <% if current_user?(micropost.user) %>
		      <%= link_to "delete", micropost, method: :delete,
		                                       data: { confirm: "You sure?" } %>
		    <% end %>
		</span>
      ...

## DEPLOYMENT ON DCA FOR TESTING

# 1. Deploy the Article Web App on Linux Centos 7.x (test)

## Install ruby and rails

* references:

      https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-centos-7


* Connect remote server: (user1 is a sudo user)

      local$ ssh user1@10.131.137.183
      Password: *****

      user1@test$

* verify and install rvm, ruby, rails, postgres and nginx

* install rvm (https://rvm.io/rvm/install)

        user1@test$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

        user1@test$ \curl -sSL https://get.rvm.io | bash

* reopen terminal app:

        user1@test$ exit

        local$ ssh user1@10.131.137.183
        Password: *****

* install ruby 2.4.1

        user1@test$ rvm list known
        user1@test$ rvm install 2.4.1

* install rails

        user1@test$ gem install rails

## install myslql:
		user1@test$ mysql57-community-release-fc24-8.noarch.rpm

		user1@test$ sudo dnf config-manager --enable mysql57-community
		Password: *****

		user1@test$ sudo dnf repolist enabled | grep "mysql.*-community.*"
		user1@test$ sudo dnf config-manager --disablerepo mysql56-community-source
		user1@test$ sudo dnf config-manager --disablerepo mysql56-community
		user1@test$ sudo dnf -y update

		user1@test$ sudo dnf -y install mysql-community-server

        user1@test$ sudo yum install -y mysql-devel

* run postgres:

        user1@test$ sudo systemctl start mysqld
        user1@test$ sudo systemctl enable mysqld

        user1@test$ mysql_secure_installation

## Setup RAILS_ENV and PORT (3000 for dev, 4000 for testing or 5000 for production)

        user1@test$ export RAILS_ENV=test
        user1@test$ export PORT=4000

## open PORT on firewalld service:

        user1@test$ sudo firewall-cmd --zone=public --add-port=4000/tcp --permanent
        user1@test$ sudo firewall-cmd --reload

## clone de git repo, install and run:

        user1@test$ mkdir apps
        user1@test$ cd apps
        user1@test$ git clone https://github.com/csanch35/proyecto_1
        user1@test$ cd proyecto_1
        user1@test$ bundle install
        user1@test$ rake db:drop db:create db:migrate
        user1@test$ export RAILS_ENV=test
        user1@test$ export PORT=4000
        user1@test$ rails server

# SETUP Centos 7.1 in production With Apache Web Server and Passenger.

* Install Apache Web Server

        user1@prod$ sudo yum install httpd
        user1@prod$ sudo systemctl enable httpd
        user1@prod$ sudo systemctl start httpd

        test in a browser: http://10.131.137.183

* Install YARN (https://yarnpkg.com/en/docs/install) (for rake assets:precompile):  

* Install module Passenger for Rails in HTTPD (https://www.phusionpassenger.com/library/install/apache/install/oss/el7/):

        user1@prod$ gem install passenger

        user1@prod$ passenger-install-apache2-module

when finish the install module, add to /etc/http/conf/httpd.conf:

        LoadModule passenger_module /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6/buildout/apache2/mod_passenger.so
        <IfModule mod_passenger.c>
          PassengerRoot /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6
          PassengerDefaultRuby /home/user1/.rvm/gems/ruby-2.4.1/wrappers/ruby
        </IfModule>

* Configure the ruby rails app to use passenger (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/el7/deploy_app.html):

* summary:

        - clone the repo to /var/www/myapp/proyecto_1

        user1@prod$ cd /var/www/myapp/proyecto_1

        user1@prod$ bundle install --deployment --without development test

        - Configure database.yml and secrets.yml:

        user1@prod$ bundle exec rake secret
        user1@prod$ vim config/secrets.yml

        production:
          secret_key_base: the value that you copied from 'rake secret'

        user1@prod$ bundle exec rake assets:precompile db:migrate RAILS_ENV=production

* add articles.conf to /etc/httpd/conf.d/myapp.conf:

        <VirtualHost *:80>
            ServerName 10.131.137.183

            # Tell Apache and Passenger where your app's 'public' directory is
            DocumentRoot /var/www/myapp/proyecto_1/public

            PassengerRuby /home/user1/.rvm/gems/ruby-2.4.1/wrappers/ruby

            # Relax Apache security settings
            <Directory /var/www/myapp/proyecto_1/public>
                Allow from all
                Options -MultiViews
                # Uncomment this if you're on Apache >= 2.4:
                #Require all granted
            </Directory>
        </VirtualHost>

* restart httpd

        user1@prod$ sudo systemctl restart httpd

        test: http://10.131.137.183

# SETUP Centos 7.1 in production With NGINX with inverse proxy

* Install nginx

        user1@prod$ sudo yum install nginx
        user1@prod$ sudo systemctl enable nginx
        user1@prod$ sudo systemctl start nginx

        test in a browser: http://10.131.137.183

* Rails app is running on 3000 port

        user1@prod$ cd proyecto_1
        user1@prod$ export RAILS_ENV=test
        user1@prod$ export PORT=3000
        user1@prod$ rails server
        => Booting Puma
        => Rails 5.1.2 application starting in test on http://0.0.0.0:3000
        => Run `rails server -h` for more startup options
        Puma starting in single mode...
        * Version 3.9.1 (ruby 2.4.1-p111), codename: Private Caller
        * Min threads: 5, max threads: 5
        * Environment: test
        * Listening on tcp://0.0.0.0:3000
        Use Ctrl-C to stop

* Warning: this app must as a service on Centos.

* Configure /etc/nginx/nginx.conf for Inverse Proxy

      App from browser: http://10.131.137.236/rubyArticulos

      // /etc/nginx/nginx.conf

      location /rubyArticulos/ {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://127.0.0.1:3000;
        proxy_redirect off;
      }

* MODIFY THE APPLICATION IN ORDER TO CONFIGURE THE NEW URI ('/rubyArticulos'):

      // modify config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.236/rubyArticulos
      Rails.application.routes.draw do
        scope '/rubyArticulos' do
          get 'welcome/index'
          resources :articles
          root 'welcome#index'
        end
      end

* Show new routes and controllers:

      user1@prod$ rails routes

            Prefix Verb   URI Pattern                    Controller#Action
	          root GET    /                              static_pages#home
	   session_new GET    /session/new(.:format)         session#new
	          help GET    /help(.:format)                static_pages#help
	         about GET    /about(.:format)               static_pages#about
	       contact GET    /contact(.:format)             static_pages#contact
	         login GET    /login(.:format)               session#new
	               POST   /login(.:format)               session#create
	        logout DELETE /logout(.:format)              session#destroy
	following_user GET    /users/:id/following(.:format) users#following
	followers_user GET    /users/:id/followers(.:format) users#followers
	         users GET    /users(.:format)               users#index
	               POST   /users(.:format)               users#create
	      new_user GET    /users/new(.:format)           users#new
	     edit_user GET    /users/:id/edit(.:format)      users#edit
	          user GET    /users/:id(.:format)           users#show
	               PATCH  /users/:id(.:format)           users#update
	               PUT    /users/:id(.:format)           users#update
	               DELETE /users/:id(.:format)           users#destroy
	    microposts POST   /microposts(.:format)          microposts#create
	     micropost DELETE /microposts/:id(.:format)      microposts#destroy
	 relationships POST   /relationships(.:format)       relationships#create
	  relationship DELETE /relationships/:id(.:format)   relationships#destroy

