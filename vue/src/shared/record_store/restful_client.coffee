import { encodeParams } from '@/shared/helpers/encode_params'
import { omitBy, snakeCase, compact, isString, defaults, pickBy, isNil, identity } from 'lodash'

getCSRF = ->
  decodeURIComponent document.cookie.match('(^|;)\\s*' + 'csrftoken' + '\\s*=\\s*([^;]+)')?.pop() || ''

export default class RestfulClient
  defaultParams: {}
  currentUpload: null
  apiPrefix: "/api/v1"

  onPrepare: (request)  -> request
  onCleanup: (response) -> response
  onResponse: (response) =>
    if response.ok
      response.json().then @onSuccess
    else
      @onFailure(response)

  onSuccess: (data) -> data

  onFailure: (response) ->
    if response.json
      response.json().then (data) ->
        data.status = response.status
        data.statusText = response.statusText
        data.ok = response.ok
        throw data
    else
      throw response


  onUploadSuccess: (response) -> response

  constructor: (resourcePlural = null) ->
    @defaultParams.unsubscribe_token = new URLSearchParams(location.search).get('unsubscribe_token')
    @defaultParams.membership_token = new URLSearchParams(location.search).get('membership_token')
    @defaultParams.stance_token = new URLSearchParams(location.search).get('stance_token')
    @defaultParams.discussion_reader_token = new URLSearchParams(location.search).get('discussion_reader_token')
    @defaultParams = omitBy(@defaultParams, isNil)
    @processing = []
    @resourcePlural = snakeCase(resourcePlural) if resourcePlural

  buildUrl: (path, params) ->
    path = compact([@apiPrefix, @resourcePlural, path]).join('/')
    return path unless params?
    path + "?" + encodeParams(params)

  memberPath: (id, action) ->
    compact([id, action]).join('/')

  fetchById: (id, params = {}) ->
    @getMember(id, '', params)

  fetch: ({params, path}) ->
    @get(path or '', params)

  post: (path, params) ->
    @request @buildUrl(path), 'POST', @paramsFor(params)

  patch: (path, params) ->
    @request @buildUrl(path), 'PATCH', @paramsFor(params)

  delete: (path, params) ->
    @request @buildUrl(path), 'DELETE', @paramsFor(params)

  # NB: get requests place their params into the query string, rather than the request body
  get: (path, params) ->
    @request @buildUrl(path, @paramsFor(params)), 'GET'

  request: (path, method, body = {}) ->
    opts =
      method: method
      credentials: 'same-origin'
      headers: 
        'Content-Type': 'application/json'
        'X-CSRF-TOKEN': getCSRF()
      body: JSON.stringify(body)
    delete opts.body if method == 'GET'
    @onPrepare()
    fetch(path, opts)
    .then(@onResponse, @onFailure)
    .finally(@onCleanup)

  postMember: (keyOrId, action, params) ->
    @post(@memberPath(keyOrId, action), params)

  patchMember: (keyOrId, action, params) ->
    @patch(@memberPath(keyOrId, action), params)

  getMember: (keyOrId, action = '', params) ->
    @get(@memberPath(keyOrId, action), params)

  create: (params) ->
    @post('', params)

  update: (id, params) ->
    @patch(id, params)

  destroy: (id, params) ->
    @delete(id, params)

  discard: (id, params) ->
    @delete(id+'/discard', params)

  undiscard: (id, params) ->
    @post(id+'/undiscard', params)

  upload: (path, file, options = {}, onProgress) ->
    return unless file
    new Promise (resolve, reject) =>
      data = new FormData()
      data.append(options.fileField     || 'file',     file)
      data.append(options.filenameField || 'filename', file.name.replace(/[^a-z0-9_\-\.]/gi, '_'))

      @currentUpload = new XMLHttpRequest()
      @currentUpload.open('POST', @buildUrl(path), true)
      @currentUpload.setRequestHeader('X-CSRF-TOKEN', getCSRF())
      @currentUpload.responseType = 'json'
      @currentUpload.addEventListener 'load', =>
        if (@currentUpload.status >= 200 && @currentUpload.status < 300)
          @currentUpload.response = JSON.parse(@currentUpload.response) if isString(@currentUpload.response)
          @onUploadSuccess(@currentUpload.response)
          resolve(@currentUpload.response)
          @currentUpload = null
      @currentUpload.upload.addEventListener('progress', onProgress) if onProgress
      @currentUpload.addEventListener('error', reject)
      @currentUpload.addEventListener('abort', reject)
      @currentUpload.send(data)

  abort: ->
    @currentUpload.abort() if @currentUpload

  paramsFor: (params) ->
    defaults({}, @defaultParams, pickBy(params, (v) -> !isNil(v)))
