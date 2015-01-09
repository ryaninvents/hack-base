AmpersandModel = require 'ampersand-model'
AmpersandRestCollection = require 'ampersand-rest-collection'
PouchDB = require 'pouchdb'
uuid = require 'node-uuid'

Model = AmpersandModel.extend
  initialize: (attrs, options) ->
    AmpersandModel::initialize.apply @, arguments
    @pouch = @constructor.pouchDb ?= new PouchDB @constructor::pouch
  idAttribute: '_id'
  props:
    _id:
      type: 'string'
      required: yes
      default: -> uuid.v4()
      setOnce: yes
    _rev: 'string'
  sync: (method, model, options) ->
    switch method
      when 'create'
        model.pouch.put model.serialize()
      when 'read'
        model.pouch.get model.getId(), (err, doc) ->
          if err
            return model.trigger 'error', err
          model.set doc
      when 'update'
        model.pouch.put model.serialize()
      when 'delete'
        model.pouch.remove model.serialize(), (err, doc) ->
          if err
            console.error err, err.stack
            return model.trigger 'error', err
      else
        model.trigger 'error', "Unknown method #{method} in Model::sync"



Model.Collection = AmpersandRestCollection.extend
  initialize: (models, options) ->
    AmpersandRestCollection::initialize.apply @, arguments
    @pouch = @constructor.pouchDb ?= new PouchDB @constructor::pouch
  sync: (method, collection, options) ->
    switch method
      when 'read'
        collection.pouch.allDocs include_docs: yes, (err, response) ->
          if err then return collection.trigger 'error', err
          docs = response.rows.map (row) -> new collection.model(row.doc)
          collection.set docs
      when 'update', 'create'
        collection.each (model) -> model.save()
      when 'delete'
        collection.each (model) -> model.destroy()
      else
        collection.trigger 'error', "Unknown method #{method} in Collection::sync"

module.exports = Model
