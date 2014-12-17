{CompositeDisposable} = require 'event-kit'
[Minimap, MinimapElement] = []

module.exports =
class V4Main
  @includeInto: (base) ->
    for k,v of @prototype
      base::[k] = v

  activateV4: ->
    @editorsMinimaps = {}
    @subscriptions = new CompositeDisposable
    MinimapElement ?= require './minimap-element'

    MinimapElement.registerViewProvider()

  deactivate: ->
    minimap.destroy() for id,minimap of @editorsMinimaps
    @subscriptions.dispose()
    @editorsMinimaps = {}
    @toggled = false

  toggle: ->
    if @toggled
      @toggled = false
      @subscriptions.dispose()
    else
      @toggled = true
      @initSubscriptions()

  minimapForEditor: (editor) -> @editorsMinimaps[editor.id]

  initSubscriptions: ->
    Minimap ?= require './minimap'

    @subscriptions.add atom.workspace.observeTextEditors (textEditor) =>
      minimap = new Minimap({textEditor})
      @editorsMinimaps[textEditor.id] = minimap

      editorElement = atom.views.getView(textEditor)
      minimapElement = atom.views.getView(minimap)

      minimapElement.attach()
