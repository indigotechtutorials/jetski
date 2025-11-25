# 🌊 Jetski MVC framework for Ruby. 

now u can build websites even faster!

Whats faster a train or a jetski? Would you rather ride on a train or a jetski? 

This all depends on your preference but this is why I create the Jetski library for Ruby.

I wanted to see if I could create an alternative with a simpler and possibly faster approach and I realized I could do just that!


### Which would you rather ride?

![rails-jetski](https://github.com/user-attachments/assets/c72eba3d-a954-465a-be39-c1a636194c0d)

### Installation guide

`gem install jetski`

### Creating an app

After installing the jetski gem you can use the jetski command in your terminal to generate new apps

`jetski new my-app`

### Example app

This is an app I built which uses the jetski library and shows you the structure of a Jetski app.

https://github.com/indigotechtutorials/ruby-web-app-fun

### Structure

currently the jetski framework is structured very similar to the Ruby on Rails library this is because that is what I'm most familar with and when building this it was easy just to rebuild what I'm familar with and it works great! which makes you think with innovation you can build something even cooler!

For now create a app/controllers/pages_controller.rb ( or whatever your controller name is)

then create a `config/routes` file and add `get / pages home` this will route to that action and call the pages_controller home action and then render the template found in

app/views/pages/home.html

We are not using .ERB or any templating system yet. So it is basically a static site framework for now until I implement database support, models and better template files. 
