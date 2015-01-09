Model = require './base/Model'

Foo = Model.extend
  pouch: name: document.location.origin+'/db/foo'
  props:
    bar: 'number'

myfoo = new Foo(bar: Math.random())
console.log myfoo.bar
