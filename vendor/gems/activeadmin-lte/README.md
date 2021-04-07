# ActiveAdmin::LTE

Theme for ActiveAdmin

![Alt text](/doc/skin.png?raw=true "Optional Title")

## Installation

Add this line to your application's Gemfile:

    gem "activeadmin-lte", git: "https://github.com/cle61/activeadmin-lte"

Disable stylesheets of ActiveAdmin in your project. By default, remove this line to active_admin.scss
```
@import "active_admin/mixins";
@import "active_admin/base";
```

Configure the color, create file : `config/initializers/active_admin_lte.rb`
```
ActiveAdmin::LTE.configure.skin='blue'
```

## Usage

### Custom the color

TODO

## Version

AdminLTE - Version 2.3.0

### Version of Rails tested

- 4.2.4
