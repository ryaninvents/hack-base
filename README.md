# hack-base

A simple launchpad for quickly building an app.

## Usage

You need `node` and `npm` on your system.

```
npm install
npm start
```

## Building

Everything is rebuilt on page refresh if it's been changed since the last build.

**Client-side JS** is built starting from `public/app.coffee`. You can use `require()` here to refer to other files as well as installed node modules.

**CSS** is built from `public/css/style.less`.

**The index page** is built from `index.jade`.

You can include **templates** in your code with `var tpl = require('./my-template.jade')`. This will set `tpl` to a function that, when called, will render your template. To populate the template you can pass in an object: `html = tpl({title: "Hello world"})`.

## Client-side JS

A base `Model` class is provided, extending `ampersand-model`. A collection class is also provided as `Model.Collection`, extending `ampersand-rest-collection`. Both use PouchDB for CRUD.

Extending the model is simple:

```js
var Model = require('./base/Model');

Car = Model.extend({
  pouch: { name: document.location.origin + '/db/car' },
  props: {
    make: {
      type: 'string',
      required: true
    },
    model: 'string',
    year: 'number'
  }
});

Car.Collection = Model.Collection.extend({
  model: Car,
  pouch: { name: document.location.origin + '/db/car' }
});
```

Saving models or collections is also simple:

```js
var myCar = new Car({
  make: "Pontiac",
  year: 1975
});

myCar.save();
```

This will save the created model directly to the server. If you want a local database, simply specify a name instead of a URL:

```js
Car = Model.extend({
  pouch: {name: 'car'}
});
```
