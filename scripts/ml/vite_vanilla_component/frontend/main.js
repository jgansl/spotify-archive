import './style.css'
import { Streamlit } from "streamlit-component-lib"

const span = document.body.appendChild(document.createElement("div"))
const textNode = span.appendChild(document.createTextNode(""))
const button = span.appendChild(document.createElement("button"))
button.textContent = "Click Me!"

let numClicks = 0
let isFocused = false
button.onclick = function() {
  numClicks += 1
  Streamlit.setComponentValue(numClicks)
}

button.onfocus = function() { isFocused = true }
button.onblur = function() { isFocused = false }

function onRender(event) {
  const data = event.detail
  if (data.theme) {
    const borderStyling = `1px solid var(${
      isFocused ? "--primary-color" : "gray"
    })`
    button.style.border = borderStyling
    button.style.outline = borderStyling
  }
  button.disabled = data.disabled
  let name = data.args["name"]
  textNode.textContent = `Hello, ${name}! ` + String.fromCharCode(160)
  Streamlit.setFrameHeight()
}

Streamlit.events.addEventListener(Streamlit.RENDER_EVENT, onRender)
Streamlit.setComponentReady()
Streamlit.setFrameHeight()