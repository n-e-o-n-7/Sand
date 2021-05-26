//config
let config = {}

function getConfig(){
    browser.storage.sync.get("config").then((response) =>{
        config = response.config || config
    })
}

browser.storage.onChanged.addListener((changes,area)=>{
    config = changes["config"].newValue
})

document.addEventListener("DOMContentLoaded", getConfig);

//query
document.onmousedown = (event) => {
    if (event.button === 0){
        let container = document.getElementById("sandContainer")
        if (container.style.visibility === "hidden"){
            document.addEventListener("mouseup", up);
        }else {
            container.style.visibility = "hidden"
        }
    }
}

function up(event) {
    window.removeEventListener("mouseup", up);

    let content = window.getSelection().toString()
    content = content.replace(/^\s+|\s+$/g, "");

    if (content != "") {
        let pos = {x:event.pageX,y:event.pageY}
        browser.runtime.sendMessage({ type:"query",content })
        .then((response) => {
            if(response){
                let text = JSON.parse(response)
                console.log(text)
                draw(text.translation,pos)
            }
        });
    }
}

//document.addEventListener("click",(e)=>{
//    let range;
//    let textNode;
//    let offset;
//
//    if (document.caretPositionFromPoint) {
//        range = document.caretPositionFromPoint(e.clientX, e.clientY);
//        textNode = range.offsetNode;
//        offset = range.offset;
//
//    } else if (document.caretRangeFromPoint) {
//        range = document.caretRangeFromPoint(e.clientX, e.clientY);
//        textNode = range.startContainer;
//        offset = range.startOffset;
//    }
//
//    let content = window.getSelection().toString()
//
//    if (textNode && textNode.nodeType == 3&&content) {
//        var replacement = textNode.splitText(offset);
//    }
//},false)

//draw
function drawcontainer(){
    let container = document.createElement('div');
    container.id = "sandContainer"
    container.style.background = "white"
    container.style.padding = "10px"
    container.style.zIndex = "1000"
    container.style.position = "absolute"
    container.style.left = "0px"
    container.style.top = "0px"
    container.style.visibility = "hidden"
    let textNode = document.createTextNode("");
    container.appendChild(textNode)
    container.addEventListener("mousedown",(event)=>{
        event.stopPropagation()
    })
    document.body.insertBefore(container,document.body.firstChild)
}

document.body.onload = drawcontainer ;

function draw(text,pos){
    console.log(pos)
    let container = document.getElementById("sandContainer")
    container.firstChild.textContent = text
    container.style.left = pos.x + "px"
    container.style.top = pos.y + "px"
    container.style.visibility = "visible"
}

window.onresize = () => {
    let container = document.getElementById("sandContainer")
    container.style.visibility = "hidden"
}
