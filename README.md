# 🌊 Jetski MVC framework for Ruby. 

### Installation guide

`gem install jetski`

### Creating an app

After installing the jetski gem you can use the jetski command in your terminal to generate new apps

`jetski new my-app`

### Example app

This is an app I built which uses the jetski library and shows you the structure of a Jetski app.

https://github.com/indigotechtutorials/ruby-web-app-fun

### Hosting Assets

To include external asset files such as CSS stylesheets and images you can put them in the assets folder under the corresponding file type

### CSS 

for css files put them in the `/app/assets/stylesheets` folder. Jetski will automatically search for a matching css file that matches your controller name.

For example if you have a pages_controller it will look for a matching pages.css file located at `/app/assets/stylesheets/pages.css`

To access the files just go to the name of the file in the browser `localhost:8000/pages.css`

You can use this to include the CSS file manually as well

Add this to head section in html 

```html
<link rel="stylesheet" type="text/css" href="/pages.css">
```

### Images

for image files you can put them in `app/assets/images` Jetski will find these matching image files and host them with them being available through the url.

For example adding a file `test-image.jpg` to the `app/assets/images` folder with a final path of `app/assets/images/test-image.jpg` will now be automatically available through the url `localhost:8000/test-image.jpg`

You can use this to for image sources on the page like so

```html
  <img src="/test-image.jpg" width="300px" height="400px"/>
```

### Routing

I initially had used a routes file where you could define your routes manually similar to Rails but than I thought that maybe it would be cool if we could have our routes be defined easier and automatically from the controller we are using. This will reduce the amount of files needed to change when building a new feature which does save time.

In my solution the routes are automatically created by the controller name and the action name it supports the default CRUD methods similar to rails and will set the HTTP method used automatically.

For any other method name it will use a GET http method by default but to override this and use a custom HTTP method you can set the `request_method "post"` line before your controller method to change the request method it looks for.

```ruby
class PostsController < Jetski::BaseController
  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```
Creates these route

```routes
  GET /posts/new
  POST /posts
  GET /posts/:id
  GET /posts/:id/edit
  PUT /posts/:id
  DELETE /posts/:id
```

```ruby
class PostsController < Jetski::BaseController
  request_method "post"
  def save
    # do the saving logic
  end
end
```

Creates this route: "POST /posts/save"

To set the root of the app simply add the "root" keyword before the method you want to use

```ruby
class PagesController < Jetski::BaseController
  root
  def home
  end
end
```

Set a custom url path by setting the path option before your method
currently setting the path and request_method only work for non CRUD named actions because those urls and methods are automatically created for now.

```ruby
class ProjectsController < Jetski::BaseController
  path "/cool-custom-url"
  request_method "post"
  def save
  end
end
```

### Generators

Similar to rails we have generator commands you can use to create new resources.

#### Controllers

Generate a new controller with a name and any actions that you want to generate as well.

`jetski generate controller pages home about contact`

This will create a pages controller with 3 actions home, about, and contact.

To destroy a controller you can run the corresponding destroy command like so
passing in the action names is not required but also won't break the command.

`jetski destroy controller pages`

### Framework description

now u can build websites even faster!

Whats faster a train or a jetski? Would you rather ride on a train or a jetski? 

This all depends on your preference but this is why I create the Jetski library for Ruby.

I wanted to see if I could create an alternative with a simpler and possibly faster approach and I realized I could do just that!


### Which would you rather ride?

![rails-jetski](https://github.com/user-attachments/assets/c72eba3d-a954-465a-be39-c1a636194c0d)

### Development mode

Testing CLI command. To test CLI command in development environment to avoid having to rebuild the command each time you can run `ruby -I lib ./bin/jetski`

To pass in a folder dir to use as the jetski route you can find the working directory of a jetski app by using `pwd` and then take that and set it as an environment variable

for example

```sh
cd jetski-app
pwd # /Users/username/apps/your-jetski-app

cd ~/jetski
export JETSKI_PROJECT_PATH="/Users/username/apps/your-jetski-app"
ruby -I lib ./bin/jetski routes
```

This will print out the routes generated in that app.