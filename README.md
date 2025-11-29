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

### Framework description

now u can build websites even faster!

Whats faster a train or a jetski? Would you rather ride on a train or a jetski? 

This all depends on your preference but this is why I create the Jetski library for Ruby.

I wanted to see if I could create an alternative with a simpler and possibly faster approach and I realized I could do just that!


### Which would you rather ride?

![rails-jetski](https://github.com/user-attachments/assets/c72eba3d-a954-465a-be39-c1a636194c0d)


### Structure

currently the jetski framework is structured very similar to the Ruby on Rails library this is because that is what I'm most familar with and when building this it was easy just to rebuild what I'm familar with and it works great! which makes you think with innovation you can build something even cooler!

For now create a app/controllers/pages_controller.rb ( or whatever your controller name is)

then create a `config/routes` file and add `get / pages home` this will route to that action and call the pages_controller home action and then render the template found in

app/views/pages/home.html

We are not using .ERB or any templating system yet. So it is basically a static site framework for now until I implement database support, models and better template files. 
