$  rails -v
Rails 4.2.0

$  rails new effective_testing -T --database=mysql

$  cd effective_testing

added these lines at the bottom of my Gemfile:

```ruby
gem 'bootstrap-sass', '~> 3.3.4'
gem 'effective_regions'
gem 'effective_datatables'
gem 'effective_pages'
```
$  bundle

$  rake db:create

$  rails g effective_datatables:install

$  rails g effective_regions:install

$  rake db:migrate

$  rails g effective_pages:install

$  rake db:migrate

Add asset helpers/sprockest stuff to application js/scss/html.erb.

$  rails s

navigate to localhost:3000/admin/pages

Errors and fixes:
##First error
```ruby
NoMethodError in Admin::PagesController#index
undefined method `authenticate_user!' for #<Admin::PagesController
```

Add

```ruby
def authenticate_user!
  true
end
```
to ApplicationController.

navigate to localhost:3000/admin/pages

##Second error

```ruby
NameError in Admin::PagesController#index
undefined local variable or method 'acts_as_sluggable'
```

Add
```ruby
gem 'effective_slugs'
```
 explicitly in Gemfile makes this go away(dependency misconfiguration in the effective_pages gem?)

$  ctrl-c

$  bundle

$  rails s

navigate to localhost:3000/admin/pages

##Third error
```ruby
NameError in Admin::PagesController#index
undefined local variable or method 'acts_as_role_restricted'
```

Add

```ruby
gem 'effective_roles'
```
to Gemfile.

$  ctrl-c

$  bundle

$  rails g effective_roles:install

$  rails s

navigate to localhost:3000/admin/pages

##Fourth error

```ruby
Template is missing
Missing template admin/pages/index,
application/index with {:locale=>[:en], :formats=>[:html],
  :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}.
```
add

```ruby
gem "haml-rails", "~> 0.9"
```

to Gemfile.

$  ctrl-c

$  bundle

$  rails s

navigate to localhost:3000/admin/pages

##Fifth error

```ruby
ActiveRecord::StatementInvalid in Admin::Pages#index
Showing /home/sebastian/.rvm/gems/ruby-2.1.2@effective_testing/gems/effective_pages-0.9.9/app/views/admin/pages/index.html.haml
where line #5 raised:

Mysql2::Error: You have an error in your SQL syntax;
check the manual that corresponds to your MySQL server version for the right
syntax to use near '."title" ASC NULLS LAST LIMIT 9999999 OFFSET 0'
at line 1: SELECT  `pages`.* FROM `pages`  ORDER BY "pages"."title" ASC NULLS LAST LIMIT 9999999 OFFSET 0
```

At this point I remembered that EffectiveDatatables does not work with mysql out of the box. I [merged your master branch into my fork](https://github.com/sebastianiorga/effective_datatables/commit/89f48408cca7670c0e07ca0dc828aa841cdcc59c). Checked that another app using my fork of EDT is working.

Changed

```ruby
gem 'effective_datatables', github: 'sebastianiorga/effective_datatables'
```

in Gemfile.

$  ctrl-c

$  bundle

$  rails s

navigate to localhost:3000/admin/pages

Get some other error to do with not properly merging EDT(because I suck at git) [which I fix](https://github.com/sebastianiorga/effective_datatables/commit/9e998214a603c847cc326fd8ad9ea966e77d0d60).

$  bundle update

$  rails s

navigate to localhost:3000/admin/pages

#Great Success!

Using test commit 7ec780fae5f9bf7238d2f7a9046e99342cbcfc75 and my EDT fork at d131aeca441f9e6fafaaf1e10183cbe3447a65f6

navigate to localhost:3000/admin/pages/new

##Sixth error

```ruby
NoMethodError in Admin::Pages#new
Showing /home/sebastian/.rvm/gems/ruby-2.1.2@effective_testing/gems/effective_pages-0.9.9/app/views/admin/pages/_form.html.haml where line #1 raised:

undefined method `simple_form_for' for #<#<Class
```

Add

```ruby
gem 'simple_form'
```

$  ctrl-c

$  bundle

$  rails s

navigate to localhost:3000/admin/pages/new

#Great Success!

$  rails g simple_form:install --bootstrap

Now it also looks good.

##Seventh error

But we can't save the first page because of [not showing the template field and its error](https://github.com/code-and-effect/effective_pages/blob/master/app/views/admin/pages/_form.html.haml#L11). The check returns true due to finding the example in effective/pages/example.html.haml however

```ruby
[2] pry(main)> EffectivePages.pages
=> {"example"=>{}}
```
The issue here is cute. Problem is in the [page form partial](https://github.com/sebastianiorga/effective_pages/blob/master/app/views/admin/pages/_form.html.haml#L12):

```ruby
- if EffectivePages.pages.length == 1
    = f.input :template, :as => :hidden, :value => EffectivePages.pages.first
```

That value argument doesn't actually do anything with the simple_form helper. That problem DOESN'T trigger an error for the layout field right below(that one made me laugh :D) because the layout field has a default value set in the migration whereas template has false.

Ok. Fork pages [and fix](https://github.com/sebastianiorga/effective_pages/commit/cd1cfd2947483d34d017788d5863c059b79fe24d). Update testing app to 17d6bfb and now we can save.

##Eighth error

About this time it dawns on my dim head that the gems are really meant to be used with Rails 3.2. Woops. Ah well, they mostly work either way, so let us carry on. Right after saving the Page, it tried to redirect to `http://localhost:3000/admin/pages/asd/edit` and produces:

```ruby
ActiveRecord::RecordNotFound in Admin::PagesController#edit
Couldn't find Effective::Page with 'id'=asd
```

Long story short Rails' module structure has changed(maybe?) and effective_slugs' override of `ActiveRecord::Base.find` isn't being inserted where it needs to be. [Fork, tweak](https://github.com/sebastianiorga/effective_slugs/commit/70d490c192340a4cea15129d121a8fb905cbaaf7), update testing app. `http://localhost:3000/admin/pages/asd/edit` loads.

##Ninth error

Click Save and Edit Content.

```ruby
Routing Error
The controller-level `respond_to' feature has been extracted to the `responders` gem. Add it to your Gemfile to continue using this feature: gem 'responders', '~> 2.0' Consult the Rails upgrade guide for details.
```

Add gem, restart app. Load page, js console errors about ckeditor files. Add gem 'effective_ckeditor' to gemfile, bundle, restart app. Reload `http://localhost:3000/sasd?edit=true` no errors, doesn't work.


##Tenth error(sort of)

Basically `http://localhost:3000/edit/asd` hits `Effective::RegionsController#edit` then gets redirected and processed by `PagesController#show`. However `http://localhost:3000/1?edit=true` or `http://localhost:3000/edit/1` work just fine and the region updates etc. So my hacky way of overriding `effective_slugs` is what's causing the problem.

Ahh, the parameterized url is meant to just hit the pages controller. But `http://localhost:3000/asd?edit=true` also doesn't manage to load the ckeditor stuff. What's up with that?

Interlude: We need to [strong_paramaterize the effective_menus params](https://github.com/sebastianiorga/effective_regions/commit/5b2c5af31b0a29da81dfbd7721aa1b580e39a529). Now we can save menus. (Assuming we visit on non-slugged path).

Continuing: Hmmm. One of the pages didn't trigger the region editor. Heisenbug. Deleted it and all other pages + menus work fine.

Last quibble: reloading `http://localhost:3000/worids-ofas?exit=%2Fadmin%2Fpages%2Fworids-ofas%2Fedit` breaks the CKEditor exit button. It correctly removes the edit=true param but does not return you to the admin page, even though if it was using the url it could. No idea what's going on there and it's now 7 hours from the start of this journey :D so maybe we'll look at it later. Oh to heck with it.

So the problem looks to be that the exit param is [not actually being used](https://github.com/code-and-effect/effective_ckeditor/blob/master/app/assets/javascripts/ckeditor/plugins/effective_regions/plugin.js.coffee#L64). Instead a cookie is being used. Aha. OK. This was a tricksy one again. I kept bashing my head against Rails because the cookie always vanished after I reloaded the editing page. Wat? Always. Even if I set it in the PagesController right before the request. Wat? Then I do a quick sublime ctrl-shift-f for cookies in the effective_ckeditor fork. [Lo and behold](https://github.com/code-and-effect/effective_ckeditor/blob/master/app/assets/javascripts/effective_ckeditor/init.js.coffee#L22). Now what to do about that? Ended up just commenting out the line. Cookies bad, url params good.

This was a lot of fun debugging :)
