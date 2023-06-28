require('coffeescript/register')
pageHelper = require('../helpers/pageHelper.coffee')

notificationTexts = [
  'accepted your invitation to join',
  'invited you to join',
  'approved your request',
  'requested to join',
  'mentioned you in',
  'replied to you in' ,
  'shared a poll outcome',
  'poll closing in 24 hours',
  'shared a poll',
  'reacted 🙂 to your comment',
  'made you an admin',
  // 'participated in',
  'added options to'
]

module.exports = {
  'has_all_the_notifications': (test) => {
    page = pageHelper(test)

    page.loadPath('setup_all_notifications')
    page.pause(500)
    page.click('.notifications__button')
    notificationTexts.map((text) => { page.expectText('.notifications__dropdown', text) })
  }
}
