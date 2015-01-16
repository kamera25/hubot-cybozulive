oauth		= require('oauth') #OAuthのリクアイア
parser     = require('xml2json') #xmljsonのリクアイア
{Adapter, TextMessage} = require 'hubot'
{EventEmitter} = require 'events'

# サイボウズライブ の Adapter 
class Cybozulive # extends Adapter
 send: (envelope, strings...) ->
  @bot.send str for str in strings
        
        #bot の生成と持続的な収集を行う
 run: ->
  options =
			key 		: process.env.HUBOT_CYBOZU_KEY
			secret 		: process.env.HUBOT_CYBOZU_SECRET
			username 	: process.env.HUBOT_CYBOZU_USERNAME
			password 	: process.env.HUBOT_CYBOZU_PASSWORD
			chatroomid	: process.env.HUBOT_CYBOZU_CHATROOMID
  @bot = new CybozuliveStreaming(options, @robot)
  
  #
  # メッセージの受け取り
  #
  @bot.on 'message', (userId, userData, message) ->
   user = @robot.brain.userForId userId, userData
   @receive new TextMessage user, message    
            
  @bot.listen()
            
  #@emit 'connected'

exports.use = (robot) ->
  new Cybozulive robot
            
            
class CybozuliveStreaming # extends EventEmitter
    
 constructor : (options, @robot) ->
        
   if options.key? and options.secret? and options.password? and options.username? and options.chatroomid?
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
   else
    console.log "Error : Dosen't exist some environment variable." 
    process.exit 1
                
   chatroomid = options.chatroomid
   selfoa = @oa    
        
   selfoa.getOAuthRequestToken @x_auth_params, (err, token, tokenSecret, results) =>
    if err
     console.log "Error get a token : " + err
     return

    @token = token
    @secret = tokenSecret 
    
    #chatroomidに該当するIDを探す。
    aimchatroomid = 'https://cybozulive.com/mpChat/view?chatRoomId=' + chatroomid

    #
    # 個人(ダイレクト)チャットで、該当するchatroomidが見つからないか検索
    #
    selfoa.get 'https://api.cybozulive.com/api/mpChat/V2?chat-type=DIRECT', token, tokenSecret, (err, data) =>
     if err
      console.log "Error get a json : " + err
      return
        
     # XML to JSON & パース
     jsondata = parser.toJson(data)
     json = JSON.parse( jsondata)
        
     if( !json.feed.entry?) #           ダイレクトチャットのリストがない時
      return
     if( !json.feed.entry.length?) #    ダイレクトチャットのリストが1つの時
      if( json.feed.entry.link[0].href == aimchatroomid)
       @roomId = json.feed.entry.id         
     else #                             ダイレクトチャットのリストが2つ以上の時
      for key,val of json.feed.entry
       if( val.link[0].href == aimchatroomid)
        @roomId = val.id
       
    #
    # 多人数(テーマ)チャットで、該当するchatroomidが見つからないか検索
    #
    selfoa.get 'https://api.cybozulive.com/api/mpChat/V2?chat-type=THEME', token, tokenSecret, (err, data) =>
     if err
      console.log "Error get a json : " + err
      return
        
        
     #XML to JSON & パース
     jsondata = parser.toJson(data)
     json = JSON.parse( jsondata)
        
     if( !json.feed.entry?) #           テーマチャットのリストがない時
      return
     if( !json.feed.entry.length?) #    テーマチャットのリストが1つの時
      if( json.feed.entry.href == aimchatroomid)
       @roomId = json.feed.entry.id
     else #                             テーマチャットのリストが2つ以上の時
      for key,val of json.feed.entry.link
       if( val.href == aimchatroomid)
        @roomId = val.id
    
    
    
 # テキストをサイボウズライブに送信する
 send : (messeage) ->
  if( @roomId == undefined)
   console.log "Error : send : undefined roomID. sometime, this problem occur when processing is not complete."
   return
            
  body = '<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2005/Atom" xmlns:cbl="http://schemas.cybozulive.com/common/2010"><cbl:operation type="insert"/><id>' + @roomId + '</id><entry><summary type="text">' + messeage + '</summary></entry></feed>'
　
  @oa.post "https://api.cybozulive.com/api/comet/mpChatPush/V2", @token, @secret, body, 'application/atom+xml', (err, data) ->
    if err? # エラー表示
     console.log "Error send. : " + err
    
    # 新着記事の取得を用いて、Hubotに返す文字列を取得
 listen: ->
        
  @rate = 10000
  timeout = =>
   body = '<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2005/Atom"><entry><id>' + @roomId + '</id></entry></feed>'

   # チャットの取得
   @oa.post "https://api.cybozulive.com/api/notification/V2?category=M_CHAT", @token, @secret, body, 'application/atom+xml', (err, data) =>
    if err || !@roomId?
     console.log "Error listen."
    else           
     jsondata = parser.toJson(data)
     json = JSON.parse( jsondata)
     message = json.feed.entry.summary.$t #内容の表示をする。
     user = json.feed.entry.author.name
     console.log message
     #@send("hello")   
     #@emit 'message', user, message
    setTimeout timeout, @rate
  timeout()

        
        
#Test Main()
#cybozu = new Cybozulive()

#cybozu.run()
#cybozu.send "hello", "hello"

