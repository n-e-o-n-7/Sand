//config
let config = {}

function getConfig(){
    browser.storage.sync.get("config").then((response) =>{
        config = response.config || config
    })
}
browser.storage.onChanged.addListener((changes,area)=>{
    config = changes["config"].newValue
//    let changedItems = Object.keys(changes);
//    for (let item of changedItems) {
//      console.log(item + " has changed:");
//      console.log("Old value: ");
//      console.log(changes[item].oldValue);
//      console.log("New value: ");
//      console.log(changes[item].newValue);
//    }
})
document.addEventListener("DOMContentLoaded", getConfig);

//query
document.onmousedown = function(event) {
    if (event.button === 0){
        document.addEventListener("mouseup", up);
    }
}

function up(event) {
    window.removeEventListener("mouseup", up);
    
    let content = window.getSelection().toString()
    content = content.replace(/^\s+|\s+$/g, "");
    
    if (content != "") {
        let pos = {x:event.clickX,y:event.clickY}
        browser.runtime.sendMessage({ type:"query",content })
        .then((response) => {
            if(response){
                console.log(JSON.parse(response))
            }
        });
    }
}

window.onresize = function(event){
    
}
