import EventBus       from '@/shared/services/event_bus'
import AbilityService from '@/shared/services/ability_service'
import Session from '@/shared/services/session'
import Records from '@/shared/services/records'
import openModal from '@/shared/helpers/open_modal'
import Flash from '@/shared/services/flash'
import RescueUnsavedEditsService from '@/shared/services/rescue_unsaved_edits_service'

export default new class CommentService
  actions: (comment, vm, event) ->
    isOwnComment = comment.authorId == Session.userId
    translate_comment:
      name: 'common.action.translate'
      icon: 'mdi-translate'
      dock: 2
      canPerform: ->
        comment.body && AbilityService.canTranslate(comment)
      perform: ->
        Session.user() && comment.translate(Session.user().locale)

    notification_history:
      name: 'action_dock.notification_history'
      icon: 'mdi-alarm-check'
      menu: true
      perform: ->
        openModal
          component: 'AnnouncementHistory'
          props:
            model: comment
      canPerform: -> !comment.discardedAt

    react:
      dock: 1
      canPerform: -> !comment.discardedAt && AbilityService.canAddComment(comment.discussion())

    reply_to_comment:
      name: 'common.action.reply'
      icon: 'mdi-reply'
      dock: 1
      canPerform: -> AbilityService.canRespondToComment(comment)
      perform: ->
        if event.depth == comment.discussion().maxDepth
          EventBus.$emit('toggle-reply', comment, event.parentId)
        else
          EventBus.$emit('toggle-reply', comment, event.id)

    edit_comment:
      name: 'common.action.edit'
      icon: 'mdi-pencil'
      dock: 1
      canPerform: -> !comment.discardedAt && comment.authorIs(Session.user()) && AbilityService.canEditComment(comment)
      perform: ->
        openModal
          component: 'EditCommentForm'
          maxWidth: 800
          props:
            comment: comment.clone()

    admin_edit_comment:
      name: 'common.action.edit'
      icon: 'mdi-pencil'
      menu: true
      canPerform: ->
        !comment.authorIs(Session.user()) && AbilityService.canEditComment(comment)
      perform: ->
        openModal
          component: 'EditCommentForm'
          props:
            comment: comment.clone()

    show_history:
      name: 'action_dock.edited'
      icon: 'mdi-history'
      dock: 3
      canPerform: ->
        comment.edited() && (!comment.discardedAt ||
                             comment.discussion().adminsInclude(Session.user()))
      perform: ->
        openModal
          component: 'RevisionHistoryModal'
          props:
            model: comment

    discard_comment:
      name: 'common.action.discard'
      icon: 'mdi-delete-outline'
      menu: true
      canPerform: -> AbilityService.canDiscardComment(comment)
      perform: -> comment.discard()

    undiscard_comment:
      name: 'common.action.restore'
      icon: 'mdi-delete-restore'
      menu: true
      canPerform: -> AbilityService.canUndiscardComment(comment)
      perform: -> comment.undiscard()

    delete_comment:
      name: 'common.action.delete'
      icon: 'mdi-delete'
      menu: true
      canPerform: -> AbilityService.canDeleteComment(comment)
      perform: ->
        openModal
          component: 'ConfirmModal',
          props:
            confirm:
              submit: -> comment.destroy().then -> window.location.reload()
              text:
                title: 'delete_comment_dialog.title'
                helptext: 'delete_comment_dialog.question'
                confirm: 'delete_comment_dialog.title'
                flash: 'comment_form.messages.destroyed'
