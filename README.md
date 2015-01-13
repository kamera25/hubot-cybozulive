hubot-cybozulive
==============

A Hubot adapter for cybozulive.

## Installation

1. Install `hubot-cybozulive`.
  ```sh
npm install hubot-cybozulive --save
  ```

2. Set environment variables.
  ```sh
export HUBOT_CYBOZU_USERNAME=hoge@foober.com    # a cybozulive account username for hubot
export HUBOT_CYBOZU_PASSWORD=qwert123           # a cybozulive account password for hubot
export HUBOT_CYBOZU_KEY=abcdef123456789abcdef123456789abcdef123 # Consumer Key. see https://developer.cybozulive.com/apps/top
export HUBOT_CYBOZU_SECRET=123456789abcdef123456789abcdef123456789 # Consumer Secret. see https://developer.cybozulive.com/apps/top
export HUBOT_CYBOZU_CHATROOMID=1%23456ABCD	# chatRoomId. more detail, check Caution.
  ```

3. Run hubot with cybozulive adapter.
  ```sh
bin/hubot -a cybozulive
  ```

## Caution
* Set API data accsess level "Z". otherwise, occur　an error. see https://developer.cybozulive.com/doc/current/pub/overview.html.
* Input a chatroomId in cybozulive. (e.g. "1%23456ABCD" of https://cybozulive.com/mpChat/view?chatRoomId=1%23456ABCD is chatRoomId)

## License
The MIT License. See `LICENSE` file.
