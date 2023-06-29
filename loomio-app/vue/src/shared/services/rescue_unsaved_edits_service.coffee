import {some, intersection, pick} from 'lodash'
import I18n from '@/i18n'

export default new class RescueUnsavedEditsService
  constructor: ->
    @models = []

  okToLeave: (model) ->
    attrs = ['description', 'title', 'body', 'details', 'name', 'reason', 'statement']
    models = ((model && [model]) || @models)
    models.forEach (m) -> m.beforeSave()
    if some(models, (m) -> intersection(attrs, m.modifiedAttributes()).length > 0)
      # console.log 'some modified', @models.map (m) ->
      #   modifiedAttrs = intersection(attrs, m.modifiedAttributes())
      #   if modifiedAttrs.length > 0
      #     o = {}
      #     o['new'] = pick(m, modifiedAttrs)
      #     o['old'] = pick(m.unmodified, modifiedAttrs)
      #     o
      #   else
      #     null

      if confirm(I18n.t('common.confirm_discard_changes'))
        (model && model.discardChanges()) || true
      else
        false
    else
      @models = []
      true

  add: (model) ->
    @models.push model

  clear: ->
    @models = []
