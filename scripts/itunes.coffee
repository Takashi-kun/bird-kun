# Description:
#   Randomly recommend music iTunes Music
#
# Commands:
#   hubot music

parser = require('xml2js').parseString
request = require('request')

getTopSongs = (callback) ->
    url = "https://itunes.apple.com/jp/rss/topsongs/limit=100/xml"
    request url, (error, response, body) ->
        if error? || response.statusCode != 200
            callback []
            return
        parser body, {charkey: 'textContent'}, (error, result) ->
            entries = result.feed.entry
            list = []
            for entry in entries
                obj = []
                obj['title'] = entry.title
                for l in entry.id
                    obj['link'] = l.textContent

                list.push(obj)
            callback (list)

getRandomOne = (array) ->
    i = Math.floor(Math.random() * array.length)
    return array[i]

getItem = (array, callback) ->
    item = getRandomOne(array)
    callback(item)

createMessage = (item, callback) ->
    return "これやで!!!\n#{item.title} - #{item.link}"

module.exports = (robot) ->
    robot.hear /music$/i, (msg) ->
        getTopSongs (array) ->
            getItem array, (item) ->
               msg.send createMessage(item)
