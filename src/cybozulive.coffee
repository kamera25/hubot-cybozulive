oauth		= require('oauth') #OAuthのリクアイア


class CybouzuStreaming

	constructor: (options) ->

		@key		= options.key
		@secret		= options.secret
		@oa		= new oauth.OAuth 'https://api.cybozulive.com/oauth/token',
					null,
					@key,
					@secret,
					'1.0',
					null,
					'HMAC-SHA1'

		x_auth_params = 
				x_auth_mode	: 'client_auth'
				x_auth_password	: options.password
				x_auth_username	: options.username
		selfoa = @oa

		selfoa.getOAuthRequestToken x_auth_params, (err, token, tokenSecret, results) ->
 		
			 # 新着記事の取得
			 selfoa.get 'https://api.cybozulive.com/api/mpChat/V2?chat-type=DIRECT', token, tokenSecret, (err, data) ->
				 console.log data



class Cybouzu

	run: ->
		options =
			key 		: process.env.HUBOT_CYBOZU_KEY
			secret 		: process.env.HUBOT_CYBOZU_SECRET
			username 	: process.env.HUBOT_CYBOZU_USERNAME
			password 	: process.env.HUBOT_CYBOZU_PASSWORD
			roomid		: process.env.HUBOT_CYBOZU_CHATROOMID
		bot = new CybouzuStreaming (options)

cybouzu = new Cybouzu()

cybouzu.run()


