oauth		= require('oauth') #OAuthのリクアイア
parser     = require('xml2json') #xmljsonのリクアイア

class CybouzuStreaming
    
 self = @
    
 constructor : (options) ->
        
   @key		= options.key
   @secret		= options.secret
   @oa	= new oauth.OAuth 'https://api.cybozulive.com/oauth/token',
					null,
					@key,
					@secret,
					'1.0',
					null
					'HMAC-SHA1'

   @x_auth_params = 
				x_auth_mode	: 'client_auth'
				x_auth_password	: options.password
				x_auth_username	: options.username
                
   selfoa = @oa

   selfoa.getOAuthRequestToken @x_auth_params, (err, token, tokenSecret, results) ->
    # 新着記事の取得
    
    selfoa.get 'https://api.cybozulive.com/api/mpChat/V2?chat-type=DIRECT', token, tokenSecret, (err, data) ->
    #ndata = parser.toJson(data)
     console.log data
    
 send : (messeage) ->
        
 #test
  roomId = 'MYPAGE,1:328514,MP_CHAT,1:7325666'
  body = '<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2005/Atom" xmlns:cbl="http://schemas.cybozulive.com/common/2010"><cbl:operation type="insert"/><id>' + roomId + '</id><entry><summary type="text">' + messeage + '</summary></entry></feed>'
　
  it = @oa
  it.getOAuthRequestToken @x_auth_params, (err, token, tokenSecret, results) ->
   it.post "https://api.cybozulive.com/api/comet/mpChatPush/V2", token, tokenSecret, body, 'application/atom+xml', (err, data) ->
    console.log err
    
    #listen: ->


    
# サイボウズライブ の Adapter 
class Cybouzu
 send: (envelope, strings...) ->
  @bot.send("やっほーー！！")
        
        #bot の生成と持続的な収集を行う
 run: ->
  options =
			key 		: process.env.HUBOT_CYBOZU_KEY
			secret 		: process.env.HUBOT_CYBOZU_SECRET
			username 	: process.env.HUBOT_CYBOZU_USERNAME
			password 	: process.env.HUBOT_CYBOZU_PASSWORD
			roomid		: process.env.HUBOT_CYBOZU_CHATROOMID
  @bot = new CybouzuStreaming (options)
        

exports.use = (robot) ->
  new Cybouzu robot
        
        
        
#Test Main()
cybouzu = new Cybouzu()

cybouzu.run()
cybouzu.send "hello", "hello"

