document.addEventListener "DOMContentLoaded", ->
  input = document.getElementById("message")
  input.addEventListener "change", ->
    App.chat.send message: @value
    @value = ""
  input.focus()
